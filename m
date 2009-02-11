Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZBKOKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZBKOKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZBKOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:10:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:63675 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZBKOKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:10:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,192,1233561600"; 
   d="scan'208";a="109552961"
Date: Wed, 11 Feb 2009 15:10:27 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com
Subject: [patch] x86, ptrace: fix double-free on race
Message-ID: <20090211151027.A16643@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ptrace_detach() races with __ptrace_unlink() if the traced task is
reaped while detaching. This might cause a double-free of the BTS
buffer.

Change the ptrace_detach() path to only do the memory accounting in
ptrace_bts_detach() and leave the buffer free to ptrace_bts_untrace()
which will be called from __ptrace_unlink().

The fix follows a proposal from Oleg Nesterov.


Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ptrace.c
===================================================================
--- gits.orig/arch/x86/kernel/ptrace.c	2009-01-22 13:09:37.000000000 +0100
+++ gits/arch/x86/kernel/ptrace.c	2009-02-11 08:55:49.000000000 +0100
@@ -810,12 +810,14 @@
 
 static void ptrace_bts_detach(struct task_struct *child)
 {
-	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		ptrace_bts_free_buffer(child);
-	}
+	/* Ptrace_detach() races with ptrace_untrace() in case
+	 * the child dies and is reaped by another thread.
+	 *
+	 * We only do the memory accounting at this point and
+	 * leave the buffer deallocation and the bts tracer
+	 * release to ptrace_bts_untrace() which will be called
+	 * later on with tasklist_lock held. */
+	release_locked_buffer(child->bts_buffer, child->bts_size);
 }
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
Index: gits/include/linux/mm.h
===================================================================
--- gits.orig/include/linux/mm.h	2009-02-11 08:40:37.000000000 +0100
+++ gits/include/linux/mm.h	2009-02-11 08:51:28.000000000 +0100
@@ -1304,5 +1304,6 @@
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
+extern void release_locked_buffer(void *buffer, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: gits/mm/mlock.c
===================================================================
--- gits.orig/mm/mlock.c	2009-02-11 08:40:37.000000000 +0100
+++ gits/mm/mlock.c	2009-02-11 08:49:17.000000000 +0100
@@ -660,7 +660,7 @@
 	return buffer;
 }
 
-void free_locked_buffer(void *buffer, size_t size)
+void release_locked_buffer(void *buffer, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
@@ -670,6 +670,11 @@
 	current->mm->locked_vm -= pgsz;
 
 	up_write(&current->mm->mmap_sem);
+}
+
+void free_locked_buffer(void *buffer, size_t size)
+{
+	release_locked_buffer(buffer, size);
 
 	kfree(buffer);
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

