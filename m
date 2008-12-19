Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYLSORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYLSORS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 09:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYLSORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 09:17:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:58544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYLSORI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 09:17:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,249,1228118400"; 
   d="scan'208";a="475396557"
Date: Fri, 19 Dec 2008 15:17:02 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [patch 2/2] x86, bts: memory accounting
Message-ID: <20081219151702.A5121@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add alloc_locked_buffer() and free_locked_buffer() functions to mm/mlock.c to kalloc a buffer and account the locked memory to current.

Account the memory for the BTS buffer to the tracer.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-12-18 13:51:36.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-12-18 15:04:43.000000000 +0100
@@ -650,6 +650,24 @@
 	return drained;
 }
 
+static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
+{
+	child->bts_buffer = alloc_locked_buffer(size);
+	if (!child->bts_buffer)
+		return -ENOMEM;
+
+	child->bts_size = size;
+
+	return 0;
+}
+
+static void ptrace_bts_free_buffer(struct task_struct *child)
+{
+	free_locked_buffer(child->bts_buffer, child->bts_size);
+	child->bts_buffer = NULL;
+	child->bts_size = 0;
+}
+
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
@@ -679,14 +697,13 @@
 
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
@@ -701,10 +718,8 @@
 	if (IS_ERR(child->bts)) {
 		int error = PTR_ERR(child->bts);
 
-		kfree(child->bts_buffer);
+		ptrace_bts_free_buffer(child);
 		child->bts = NULL;
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
 
 		return error;
 	}
@@ -784,6 +799,9 @@
 		ds_release_bts(child->bts);
 		child->bts = NULL;
 
+		/* We cannot update total_vm and locked_vm since
+		   child's mm is already gone. But we can reclaim the
+		   memory. */
 		kfree(child->bts_buffer);
 		child->bts_buffer = NULL;
 		child->bts_size = 0;
@@ -792,7 +810,12 @@
 
 static void ptrace_bts_detach(struct task_struct *child)
 {
-	ptrace_bts_untrace(child);
+	if (unlikely(child->bts)) {
+		ds_release_bts(child->bts);
+		child->bts = NULL;
+
+		ptrace_bts_free_buffer(child);
+	}
 }
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
Index: ftrace/include/linux/mm.h
===================================================================
--- ftrace.orig/include/linux/mm.h	2008-11-26 09:50:59.000000000 +0100
+++ ftrace/include/linux/mm.h	2008-12-18 15:00:32.000000000 +0100
@@ -1286,5 +1286,7 @@
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
 
+extern void *alloc_locked_buffer(size_t size);
+extern void free_locked_buffer(void *buffer, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: ftrace/mm/mlock.c
===================================================================
--- ftrace.orig/mm/mlock.c	2008-11-26 09:51:04.000000000 +0100
+++ ftrace/mm/mlock.c	2008-12-18 16:18:41.000000000 +0100
@@ -667,3 +667,48 @@
 	spin_unlock(&shmlock_user_lock);
 	free_uid(user);
 }
+
+void *alloc_locked_buffer(size_t size)
+{
+	unsigned long rlim, vm, pgsz;
+	void *buffer = NULL;
+
+	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm   = current->mm->total_vm + pgsz;
+	if (rlim < vm)
+		goto out;
+
+	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm   = current->mm->locked_vm + pgsz;
+	if (rlim < vm)
+		goto out;
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		goto out;
+
+	current->mm->total_vm  += pgsz;
+	current->mm->locked_vm += pgsz;
+
+ out:
+	up_write(&current->mm->mmap_sem);
+	return buffer;
+}
+
+void free_locked_buffer(void *buffer, size_t size)
+{
+	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	current->mm->total_vm  -= pgsz;
+	current->mm->locked_vm -= pgsz;
+
+	up_write(&current->mm->mmap_sem);
+
+	kfree(buffer);
+}
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

