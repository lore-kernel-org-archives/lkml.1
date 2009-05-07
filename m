Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbZEGJdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbZEGJdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761201AbZEGJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:28:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:45244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762221AbZEGJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:28:09 -0400
Date: Thu, 7 May 2009 09:26:08 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090424095143.A30265@sedona.ch.intel.com>
References: <20090424095143.A30265@sedona.ch.intel.com>
Subject: [tip:tracing/core] x86, bts, mm: clean up buffer allocation
Message-ID: <tip-1cb81b143fa8f0e4629f10690862e2e52ca792ff@git.kernel.org>
Git-Commit-ID: 1cb81b143fa8f0e4629f10690862e2e52ca792ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:26:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1cb81b143fa8f0e4629f10690862e2e52ca792ff
Gitweb:     http://git.kernel.org/tip/1cb81b143fa8f0e4629f10690862e2e52ca792ff
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 24 Apr 2009 09:51:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Apr 2009 10:18:52 +0200

x86, bts, mm: clean up buffer allocation

The current mm interface is asymetric. One function allocates a locked
buffer, another function only refunds the memory.

Change this to have two functions for accounting and refunding locked
memory, respectively; and do the actual buffer allocation in ptrace.

[ Impact: refactor BTS buffer allocation code ]

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090424095143.A30265@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ptrace.c |   39 ++++++++++++++++++++++++++-------------
 include/linux/mm.h       |    6 ++++--
 mm/mlock.c               |   36 +++++++++++++++++-------------------
 3 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d5252ae..09ecbde 100644
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
@@ -638,7 +649,7 @@ static inline void free_bts_buffer(struct bts_context *context)
 	kfree(context->buffer);
 	context->buffer = NULL;
 
-	refund_locked_buffer_memory(context->mm, context->size);
+	refund_locked_memory(context->mm, context->size);
 	context->size = 0;
 
 	mmput(context->mm);
@@ -786,13 +797,15 @@ static int ptrace_bts_config(struct task_struct *child,
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a3963ba..009eabd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,6 +19,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct rlimit;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1319,7 +1320,8 @@ int vmemmap_populate_basepages(struct page *start_page,
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
 
-extern void *alloc_locked_buffer(size_t size);
-extern void refund_locked_buffer_memory(struct mm_struct *mm, size_t size);
+extern int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
+				 size_t size);
+extern void refund_locked_memory(struct mm_struct *mm, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/mlock.c b/mm/mlock.c
index 28be15e..ac13043 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -629,38 +629,36 @@ void user_shm_unlock(size_t size, struct user_struct *user)
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
 
