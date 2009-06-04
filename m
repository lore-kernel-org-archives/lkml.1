Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbZFDQBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbZFDQBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZFDQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbZFDQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:01:15 -0400
Date: Thu, 4 Jun 2009 16:00:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Remove munmap stuff
Message-ID: <tip-d99e9446200c1ffab28cb0e39b76c34a2bfafd06@git.kernel.org>
Git-Commit-ID: d99e9446200c1ffab28cb0e39b76c34a2bfafd06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 16:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d99e9446200c1ffab28cb0e39b76c34a2bfafd06
Gitweb:     http://git.kernel.org/tip/d99e9446200c1ffab28cb0e39b76c34a2bfafd06
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Jun 2009 17:08:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 17:51:38 +0200

perf_counter: Remove munmap stuff

In name of keeping it simple, only track mmap events. Userspace
will have to remove old overlapping maps when it encounters them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   11 +----------
 kernel/perf_counter.c        |   38 +++-----------------------------------
 mm/mmap.c                    |    6 ------
 3 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 380247b..6ca403a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -148,11 +148,10 @@ struct perf_counter_attr {
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
 				mmap           :  1, /* include mmap data     */
-				munmap         :  1, /* include munmap data   */
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
 
-				__reserved_1   : 52;
+				__reserved_1   : 53;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -246,7 +245,6 @@ enum perf_event_type {
 	 * };
 	 */
 	PERF_EVENT_MMAP			= 1,
-	PERF_EVENT_MUNMAP		= 2,
 
 	/*
 	 * struct {
@@ -622,9 +620,6 @@ extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
 extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 			      unsigned long pgoff, struct file *file);
 
-extern void perf_counter_munmap(unsigned long addr, unsigned long len,
-				unsigned long pgoff, struct file *file);
-
 extern void perf_counter_comm(struct task_struct *tsk);
 extern void perf_counter_fork(struct task_struct *tsk);
 
@@ -677,10 +672,6 @@ static inline void
 perf_counter_mmap(unsigned long addr, unsigned long len,
 		  unsigned long pgoff, struct file *file)		{ }
 
-static inline void
-perf_counter_munmap(unsigned long addr, unsigned long len,
-		    unsigned long pgoff, struct file *file)		{ }
-
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 78c5862..195712e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -41,7 +41,6 @@ static int perf_overcommit __read_mostly = 1;
 
 static atomic_t nr_counters __read_mostly;
 static atomic_t nr_mmap_counters __read_mostly;
-static atomic_t nr_munmap_counters __read_mostly;
 static atomic_t nr_comm_counters __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
@@ -1448,8 +1447,6 @@ static void free_counter(struct perf_counter *counter)
 	atomic_dec(&nr_counters);
 	if (counter->attr.mmap)
 		atomic_dec(&nr_mmap_counters);
-	if (counter->attr.munmap)
-		atomic_dec(&nr_munmap_counters);
 	if (counter->attr.comm)
 		atomic_dec(&nr_comm_counters);
 
@@ -2510,7 +2507,7 @@ static void perf_counter_fork_output(struct perf_counter *counter,
 
 static int perf_counter_fork_match(struct perf_counter *counter)
 {
-	if (counter->attr.comm || counter->attr.mmap || counter->attr.munmap)
+	if (counter->attr.comm || counter->attr.mmap)
 		return 1;
 
 	return 0;
@@ -2557,8 +2554,7 @@ void perf_counter_fork(struct task_struct *task)
 	struct perf_fork_event fork_event;
 
 	if (!atomic_read(&nr_comm_counters) &&
-	    !atomic_read(&nr_mmap_counters) &&
-	    !atomic_read(&nr_munmap_counters))
+	    !atomic_read(&nr_mmap_counters))
 		return;
 
 	fork_event = (struct perf_fork_event){
@@ -2722,12 +2718,7 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 static int perf_counter_mmap_match(struct perf_counter *counter,
 				   struct perf_mmap_event *mmap_event)
 {
-	if (counter->attr.mmap &&
-	    mmap_event->event.header.type == PERF_EVENT_MMAP)
-		return 1;
-
-	if (counter->attr.munmap &&
-	    mmap_event->event.header.type == PERF_EVENT_MUNMAP)
+	if (counter->attr.mmap)
 		return 1;
 
 	return 0;
@@ -2821,27 +2812,6 @@ void perf_counter_mmap(unsigned long addr, unsigned long len,
 	perf_counter_mmap_event(&mmap_event);
 }
 
-void perf_counter_munmap(unsigned long addr, unsigned long len,
-			 unsigned long pgoff, struct file *file)
-{
-	struct perf_mmap_event mmap_event;
-
-	if (!atomic_read(&nr_munmap_counters))
-		return;
-
-	mmap_event = (struct perf_mmap_event){
-		.file   = file,
-		.event  = {
-			.header = { .type = PERF_EVENT_MUNMAP, },
-			.start  = addr,
-			.len    = len,
-			.pgoff  = pgoff,
-		},
-	};
-
-	perf_counter_mmap_event(&mmap_event);
-}
-
 /*
  * Log sample_period changes so that analyzing tools can re-normalize the
  * event flow.
@@ -3525,8 +3495,6 @@ done:
 	atomic_inc(&nr_counters);
 	if (counter->attr.mmap)
 		atomic_inc(&nr_mmap_counters);
-	if (counter->attr.munmap)
-		atomic_inc(&nr_munmap_counters);
 	if (counter->attr.comm)
 		atomic_inc(&nr_comm_counters);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 2c1c2cb..6451ce2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1756,12 +1756,6 @@ static void remove_vma_list(struct mm_struct *mm, struct vm_area_struct *vma)
 	do {
 		long nrpages = vma_pages(vma);
 
-		if (vma->vm_flags & VM_EXEC) {
-			perf_counter_munmap(vma->vm_start,
-					nrpages << PAGE_SHIFT,
-					vma->vm_pgoff, vma->vm_file);
-		}
-
 		mm->total_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);
