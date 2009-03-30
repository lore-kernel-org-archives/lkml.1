Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbZC3RQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbZC3RQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZC3RLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZC3RLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:31 -0400
Message-Id: <20090330171023.417259499@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/15] perf_counter: executable mmap() information
Content-Disposition: inline; filename=perf_counter-mmap-tracking.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the profiling information returns userspace IPs but no way
to correlate them to userspace code. Userspace could look into
/proc/$pid/maps but that might not be current or even present anymore
at the time of analyzing the IPs.

Therefore provide means to track the mmap information and provide it
in the output stream.

XXX: only covers mmap()/munmap(), mremap() and mprotect() are missing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/perf_counter.h |   24 ++++++-
 kernel/perf_counter.c        |  145 +++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                    |   10 ++
 3 files changed, 177 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -137,9 +137,11 @@ struct perf_counter_hw_event {
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
-				include_tid    :  1, /* include the tid */
+				include_tid    :  1, /* include the tid       */
+				mmap           :  1, /* include mmap data     */
+				munmap         :  1, /* include munmap data   */
 
-				__reserved_1   : 54;
+				__reserved_1   : 52;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -211,6 +213,9 @@ enum perf_event_type {
 	PERF_EVENT_IP		= 0,
 	PERF_EVENT_GROUP	= 1,
 
+	PERF_EVENT_MMAP		= 2,
+	PERF_EVENT_MUNMAP	= 3,
+
 	__PERF_EVENT_TID	= 0x100,
 };
 
@@ -491,6 +496,12 @@ static inline int is_software_counter(st
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
 
+extern void perf_counter_mmap(unsigned long addr, unsigned long len,
+			      unsigned long pgoff, struct file *file);
+
+extern void perf_counter_munmap(unsigned long addr, unsigned long len,
+				unsigned long pgoff, struct file *file);
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -511,6 +522,15 @@ static inline int perf_counter_task_enab
 static inline void
 perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)	{ }
 
+
+static inline void
+perf_counter_mmap(unsigned long addr, unsigned long len,
+		  unsigned long pgoff, struct file *file)		{ }
+
+static inline void
+perf_counter_munmap(unsigned long addr, unsigned long len,
+		    unsigned long pgoff, struct file *file) 		{ }
+
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -25,6 +25,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
+#include <linux/dcache.h>
 
 #include <asm/irq_regs.h>
 
@@ -1842,6 +1843,150 @@ void perf_counter_output(struct perf_cou
 }
 
 /*
+ * mmap tracking
+ */
+
+struct perf_mmap_event {
+	struct file	*file;
+	char		*file_name;
+	int		file_size;
+
+	struct {
+		struct perf_event_header	header;
+
+		u32				pid;
+		u32				tid;
+		u64				start;
+		u64				len;
+		u64				pgoff;
+	} event;
+};
+
+static void perf_counter_mmap_output(struct perf_counter *counter,
+				     struct perf_mmap_event *mmap_event)
+{
+	struct perf_output_handle handle;
+	int size = mmap_event->event.header.size;
+	int ret = perf_output_begin(&handle, counter, size);
+
+	if (ret)
+		return;
+
+	perf_output_put(&handle, mmap_event->event);
+	perf_output_copy(&handle, mmap_event->file_name,
+				   mmap_event->file_size);
+	perf_output_end(&handle, 0);
+}
+
+static int perf_counter_mmap_match(struct perf_counter *counter,
+				   struct perf_mmap_event *mmap_event)
+{
+	if (counter->hw_event.mmap &&
+	    mmap_event->event.header.type == PERF_EVENT_MMAP)
+		return 1;
+
+	if (counter->hw_event.munmap &&
+	    mmap_event->event.header.type == PERF_EVENT_MUNMAP)
+		return 1;
+
+	return 0;
+}
+
+static void perf_counter_mmap_ctx(struct perf_counter_context *ctx,
+				  struct perf_mmap_event *mmap_event)
+{
+	struct perf_counter *counter;
+
+	if (system_state != SYSTEM_RUNNING || list_empty(&ctx->event_list))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
+		if (perf_counter_mmap_match(counter, mmap_event))
+			perf_counter_mmap_output(counter, mmap_event);
+	}
+	rcu_read_unlock();
+}
+
+static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
+{
+	struct perf_cpu_context *cpuctx;
+	struct file *file = mmap_event->file;
+	unsigned int size;
+	char tmp[16];
+	char *buf = NULL;
+	char *name;
+
+	if (file) {
+		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		if (!buf) {
+			name = strncpy(tmp, "//enomem", sizeof(tmp));
+			goto got_name;
+		}
+		name = dentry_path(file->f_dentry, buf, PATH_MAX);
+		if (IS_ERR(name)) {
+			name = strncpy(tmp, "//toolong", sizeof(tmp));
+			goto got_name;
+		}
+	} else {
+		name = strncpy(tmp, "//anon", sizeof(tmp));
+		goto got_name;
+	}
+
+got_name:
+	size = ALIGN(strlen(name), sizeof(u64));
+
+	mmap_event->file_name = name;
+	mmap_event->file_size = size;
+
+	mmap_event->event.header.size = sizeof(mmap_event->event) + size;
+
+	cpuctx = &get_cpu_var(perf_cpu_context);
+	perf_counter_mmap_ctx(&cpuctx->ctx, mmap_event);
+	put_cpu_var(perf_cpu_context);
+
+	perf_counter_mmap_ctx(&current->perf_counter_ctx, mmap_event);
+
+	kfree(buf);
+}
+
+void perf_counter_mmap(unsigned long addr, unsigned long len,
+		       unsigned long pgoff, struct file *file)
+{
+	struct perf_mmap_event mmap_event = {
+		.file   = file,
+		.event  = {
+			.header = { .type = PERF_EVENT_MMAP, },
+			.pid	= current->group_leader->pid,
+			.tid	= current->pid,
+			.start  = addr,
+			.len    = len,
+			.pgoff  = pgoff,
+		},
+	};
+
+	perf_counter_mmap_event(&mmap_event);
+}
+
+void perf_counter_munmap(unsigned long addr, unsigned long len,
+			 unsigned long pgoff, struct file *file)
+{
+	struct perf_mmap_event mmap_event = {
+		.file   = file,
+		.event  = {
+			.header = { .type = PERF_EVENT_MUNMAP, },
+			.pid	= current->group_leader->pid,
+			.tid	= current->pid,
+			.start  = addr,
+			.len    = len,
+			.pgoff  = pgoff,
+		},
+	};
+
+	perf_counter_mmap_event(&mmap_event);
+}
+
+/*
  * Generic software counter infrastructure
  */
 
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -27,6 +27,7 @@
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
+#include <linux/perf_counter.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1219,6 +1220,9 @@ munmap_back:
 	if (correct_wcount)
 		atomic_inc(&inode->i_writecount);
 out:
+	if (vm_flags & VM_EXEC)
+		perf_counter_mmap(addr, len, pgoff, file);
+
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
@@ -1752,6 +1756,12 @@ static void remove_vma_list(struct mm_st
 	do {
 		long nrpages = vma_pages(vma);
 
+		if (vma->vm_flags & VM_EXEC) {
+			perf_counter_munmap(vma->vm_start,
+					nrpages << PAGE_SHIFT,
+					vma->vm_pgoff, vma->vm_file);
+		}
+
 		mm->total_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);

-- 

