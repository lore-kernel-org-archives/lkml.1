Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYLPPZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYLPPZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbYLPPYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:24:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:34250 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbYLPPYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:24:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,231,1228118400"; 
   d="scan'208";a="371339747"
Date: Tue, 16 Dec 2008 16:24:24 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [rfc] x86, ptrace: memory accounting for branch tracing
Message-ID: <20081216162424.A30209@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account memory allocated for the BTS buffer to the traced task's
total_vm and locked_vm.

The mlock ulimit is typically quite low if you want to trace multiple
tasks. By accounting the memory to the tracee, we should be OK if
we're debugging multiple processes. For debugging multiple threads,
though, the ulimit may be too low.


When the tracer dies, it does not detach properly from the traced
tasks. In particular, ptrace_detach() and ptrace_disable() are not
called.

Thus, BTS resources are not properly released. They will be released
in exit_thread() when the tracee dies. At that time, the task's mm has
already been destroyed, so we don't update total_vm and locked_vm.

While we're not actually leaking memory, we don't give it back to
total_vm and locked_vm. From how I understood the code, we started
with a copy, anyway, so the changes are gone when the process
dies. That may be good enough.

In case the debugger re-attaches, it will find an already allocated
bts buffer and use that one, or deallocate it and allocate a new
one. In that case, the tracer will get the memory for the existing
buffer subtracted from its total_vm and locked_vm.

Two tasks working together (one allocating the bts buffer and dying;
the other deallocating the bts buffer) would be able to mlock an
unlimited amount of memory.


I guess my approach is simply wrong. How would one approach this
correctly? Could anyone point me to some code?


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-12-15 10:52:58.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-12-15 11:18:23.000000000 +0100
@@ -650,6 +650,56 @@
 	return drained;
 }
 
+static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
+{
+	unsigned long rlim, vm, pgsz;
+	int error = -ENOMEM;
+
+	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	down_write(&child->mm->mmap_sem);
+
+	rlim = child->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm   = child->mm->total_vm + pgsz;
+	if (rlim < vm)
+		goto out;
+
+	rlim = child->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm   = child->mm->locked_vm + pgsz;
+	if (rlim < vm)
+		goto out;
+
+	child->bts_buffer = kzalloc(size, GFP_KERNEL);
+	if (!child->bts_buffer)
+		goto out;
+
+	child->bts_size = size;
+
+	child->mm->total_vm  += pgsz;
+	child->mm->locked_vm += pgsz;
+
+	error = 0;
+ out:
+	up_write(&child->mm->mmap_sem);
+	return error;
+}
+
+static void ptrace_bts_free_buffer(struct task_struct *child)
+{
+	unsigned long pgsz = PAGE_ALIGN(child->bts_size) >> PAGE_SHIFT;
+
+	down_write(&child->mm->mmap_sem);
+
+	child->mm->total_vm  -= pgsz;
+	child->mm->locked_vm -= pgsz;
+
+	up_write(&child->mm->mmap_sem);
+
+	kfree(child->bts_buffer);
+	child->bts_buffer = NULL;
+	child->bts_size = 0;
+}
+
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
@@ -679,14 +729,13 @@
 
 	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&
 	    (cfg.size != child->bts_size)) {
-		kfree(child->bts_buffer);
+		int error;
 
-		child->bts_size = cfg.size;
-		child->bts_buffer = kzalloc(cfg.size, GFP_KERNEL);
-		if (!child->bts_buffer) {
-			child->bts_size = 0;
-			return -ENOMEM;
-		}
+		ptrace_bts_free_buffer(child);
+
+		error = ptrace_bts_allocate_buffer(child, cfg.size);
+		if (error < 0)
+			return error;
 	}
 
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
@@ -701,10 +750,8 @@
 	if (IS_ERR(child->bts)) {
 		int error = PTR_ERR(child->bts);
 
-		kfree(child->bts_buffer);
+		ptrace_bts_free_buffer(child);
 		child->bts = NULL;
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
 
 		return error;
 	}
@@ -787,9 +834,7 @@
 		ds_release_bts(child->bts);
 		child->bts = NULL;
 
-		kfree(child->bts_buffer);
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
+		ptrace_bts_free_buffer(child);
 	}
 #endif /* CONFIG_X86_PTRACE_BTS */
 }
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

