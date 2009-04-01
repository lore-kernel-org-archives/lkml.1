Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZDAKSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZDAKSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbZDAKPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:15:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:33974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbZDAKPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:15:03 -0400
Date: Wed, 1 Apr 2009 10:13:17 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.417259499@chello.nl>
References: <20090330171023.417259499@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: executable mmap() information
Message-ID: <tip-b2f5c7cf9c5359702e09e7619959fe9cfa84e8f7@git.kernel.org>
Git-Commit-ID: b2f5c7cf9c5359702e09e7619959fe9cfa84e8f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:13:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2f5c7cf9c5359702e09e7619959fe9cfa84e8f7
Gitweb:     http://git.kernel.org/tip/b2f5c7cf9c5359702e09e7619959fe9cfa84e8f7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:33 +0200

perf_counter: executable mmap() information

Currently the profiling information returns userspace IPs but no way
to correlate them to userspace code. Userspace could look into
/proc/$pid/maps but that might not be current or even present anymore
at the time of analyzing the IPs.

Therefore provide means to track the mmap information and provide it
in the output stream.

XXX: only covers mmap()/munmap(), mremap() and mprotect() are missing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090330171023.417259499@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   24 ++++++-
 kernel/perf_counter.c        |  145 ++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                    |   10 +++
 3 files changed, 177 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 8ac1885..037a811 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
 
@@ -491,6 +496,12 @@ static inline int is_software_counter(struct perf_counter *counter)
 
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
@@ -511,6 +522,15 @@ static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c95e923..f35e89e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -25,6 +25,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
+#include <linux/dcache.h>
 
 #include <asm/irq_regs.h>
 
@@ -1844,6 +1845,150 @@ void perf_counter_output(struct perf_counter *counter,
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
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 00ced3e..c14fa8c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
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
@@ -1752,6 +1756,12 @@ static void remove_vma_list(struct mm_struct *mm, struct vm_area_struct *vma)
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
