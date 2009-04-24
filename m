Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZDXMcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZDXMcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZDXMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:31:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:31426 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZDXMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,241,1239001200"; 
   d="scan'208";a="684633791"
Date: Fri, 24 Apr 2009 14:31:46 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org
Subject: [patch] x86, bts, mm: buffer allocation
Message-ID: <20090424143146.A26799@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate buffer allocation and memory accounting.


CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ptrace.c |   39 	26 +	13 -	0 !
 include/linux/mm.h       |    6 	4 +	2 -	0 !
 mm/mlock.c               |   36 	17 +	19 -	0 !
 3 files changed, 47 insertions(+), 34 deletions(-)

Index: b/include/linux/mm.h
===================================================================
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,6 +19,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct rlimit;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1319,7 +1320,8 @@ int vmemmap_populate_basepages(struct pa
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
 
-extern void *alloc_locked_buffer(size_t size);
-extern void refund_locked_buffer_memory(struct mm_struct *mm, size_t size);
+extern int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
+				 size_t size);
+extern void refund_locked_memory(struct mm_struct *mm, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -629,38 +629,36 @@ void user_shm_unlock(size_t size, struct
 	free_uid(user);
 }
 
-void *alloc_locked_buffer(size_t size)
+int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
+			  size_t size)
 {
-	unsigned long rlim, vm, pgsz;
-	void *buffer = NULL;
+	unsigned long lim, vm, pgsz;
+	int error = -ENOMEM;
 
 	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
-
-	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->total_vm + pgsz;
-	if (rlim < vm)
-		goto out;
+	down_write(&mm->mmap_sem);
 
-	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->locked_vm + pgsz;
-	if (rlim < vm)
+	lim = rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm   = mm->total_vm + pgsz;
+	if (lim < vm)
 		goto out;
 
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
+	lim = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm   = mm->locked_vm + pgsz;
+	if (lim < vm)
 		goto out;
 
-	current->mm->total_vm  += pgsz;
-	current->mm->locked_vm += pgsz;
+	mm->total_vm  += pgsz;
+	mm->locked_vm += pgsz;
 
+	error = 0;
  out:
-	up_write(&current->mm->mmap_sem);
-	return buffer;
+	up_write(&mm->mmap_sem);
+	return error;
 }
 
-void refund_locked_buffer_memory(struct mm_struct *mm, size_t size)
+void refund_locked_memory(struct mm_struct *mm, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
Index: b/arch/x86/kernel/ptrace.c
===================================================================
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -617,17 +617,28 @@ struct bts_context {
 	struct work_struct	work;
 };
 
-static inline void alloc_bts_buffer(struct bts_context *context,
-				    unsigned int size)
+static int alloc_bts_buffer(struct bts_context *context, unsigned int size)
 {
-	void *buffer;
+	void *buffer = NULL;
+	int err = -ENOMEM;
 
-	buffer = alloc_locked_buffer(size);
-	if (buffer) {
-		context->buffer = buffer;
-		context->size = size;
-		context->mm = get_task_mm(current);
-	}
+	err = account_locked_memory(current->mm, current->signal->rlim, size);
+	if (err < 0)
+		return err;
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		goto out_refund;
+
+	context->buffer = buffer;
+	context->size = size;
+	context->mm = get_task_mm(current);
+
+	return 0;
+
+ out_refund:
+	refund_locked_memory(current->mm, size);
+	return err;
 }
 
 static inline void free_bts_buffer(struct bts_context *context)
@@ -638,7 +649,7 @@ static inline void free_bts_buffer(struc
 	kfree(context->buffer);
 	context->buffer = NULL;
 
-	refund_locked_buffer_memory(context->mm, context->size);
+	refund_locked_memory(context->mm, context->size);
 	context->size = 0;
 
 	mmput(context->mm);
@@ -786,13 +797,15 @@ static int ptrace_bts_config(struct task
 	context->tracer = NULL;
 
 	if ((cfg.flags & PTRACE_BTS_O_ALLOC) && (cfg.size != context->size)) {
+		int err;
+
 		free_bts_buffer(context);
 		if (!cfg.size)
 			return 0;
 
-		alloc_bts_buffer(context, cfg.size);
-		if (!context->buffer)
-			return -ENOMEM;
+		err = alloc_bts_buffer(context, cfg.size);
+		if (err < 0)
+			return err;
 	}
 
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
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

