Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXGKHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXGKHOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXGKHOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:14:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:59048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXGKHOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,525,1175497200"; 
   d="scan'208";a="105056711"
Subject: [PATCH] Optimize struct task_delay_info
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: nagar@watson.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Jul 2007 15:13:54 +0800
Message-Id: <1184138034.3068.51.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct task_delay_info is used by per process block I/O delay statistics
feature which is useful in kernel. This struct is not optimized.

My patch against kernel 2.6.22 shrinks it a half.

1) Delete blkio_start and blkio_end. As the collection happens in
io_schedule and io_schedule_timeout, we use local variables to
replace them;
2) Delete lock. The change to the protected data has no nested cases.
In addition, the result is for performance data collection, so it’s
unnecessary to add such lock. 
3) Delete flags. It just has one value. Use the most significant bit of
blkio_delay (64 bits) to mark it..


Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

diff -Nraup linux-2.6.22/include/linux/delayacct.h linux-2.6.22_blkio_delay/include/linux/delayacct.h
--- linux-2.6.22/include/linux/delayacct.h	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_blkio_delay/include/linux/delayacct.h	2007-07-11 05:56:58.000000000 +0800
@@ -23,9 +23,9 @@
 /*
  * Per-task flags relevant to delay accounting
  * maintained privately to avoid exhausting similar flags in sched.h:PF_*
- * Used to set current->delays->flags
+ * Used to set the most significant bit of current>delays->blkio_delay
  */
-#define DELAYACCT_PF_SWAPIN	0x00000001	/* I am doing a swapin */
+#define DELAYACCT_PF_SWAPIN	(0x1LLU<<63)	/* I am doing a swapin */
 
 #ifdef CONFIG_TASK_DELAY_ACCT
 
@@ -39,16 +39,25 @@ extern void __delayacct_blkio_end(void);
 extern int __delayacct_add_tsk(struct taskstats *, struct task_struct *);
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
 
-static inline void delayacct_set_flag(int flag)
+static inline int delayacct_is_swapin(void)
 {
 	if (current->delays)
-		current->delays->flags |= flag;
+		return current->delays->blkio_delay & DELAYACCT_PF_SWAPIN
+			? 1 : 0;
+	else
+		return 0;
+}
+
+static inline void delayacct_set_swapin(void)
+{
+	if (current->delays)
+		current->delays->blkio_delay |= DELAYACCT_PF_SWAPIN;
 }
 
-static inline void delayacct_clear_flag(int flag)
+static inline void delayacct_clear_swapin(void)
 {
 	if (current->delays)
-		current->delays->flags &= ~flag;
+		current->delays->blkio_delay |= DELAYACCT_PF_SWAPIN;
 }
 
 static inline void delayacct_tsk_init(struct task_struct *tsk)
@@ -96,10 +105,19 @@ static inline __u64 delayacct_blkio_tick
 	return 0;
 }
 
+void delayacct_start(struct timespec *start);
+void delayacct_end(struct timespec *start);
+
+#define DECLARE_DELAYACCT_START_VAR	struct timespec delayacct_start_time
+#define DELAYACCT_START			delayacct_start(&delayacct_start_time)
+#define DELAYACCT_END			delayacct_end(&delayacct_start_time)
+
 #else
-static inline void delayacct_set_flag(int flag)
+static inline int delayacct_is_swapin(void)
+{ return 0; }
+static inline void delayacct_set_swapin(void)
 {}
-static inline void delayacct_clear_flag(int flag)
+static inline void delayacct_clear_swapin(void)
 {}
 static inline void delayacct_init(void)
 {}
@@ -107,15 +125,21 @@ static inline void delayacct_tsk_init(st
 {}
 static inline void delayacct_tsk_free(struct task_struct *tsk)
 {}
-static inline void delayacct_blkio_start(void)
-{}
-static inline void delayacct_blkio_end(void)
-{}
 static inline int delayacct_add_tsk(struct taskstats *d,
 					struct task_struct *tsk)
 { return 0; }
 static inline __u64 delayacct_blkio_ticks(struct task_struct *tsk)
 { return 0; }
+
+static inline void delayacct_start(struct timespec *start)
+{}
+static inline void delayacct_end(struct timespec *start)
+{}
+
+#define DECLARE_DELAYACCT_START_VAR
+#define DELAYACCT_START
+#define DELAYACCT_END
+
 #endif /* CONFIG_TASK_DELAY_ACCT */
 
 #endif
diff -Nraup linux-2.6.22/include/linux/sched.h linux-2.6.22_blkio_delay/include/linux/sched.h
--- linux-2.6.22/include/linux/sched.h	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_blkio_delay/include/linux/sched.h	2007-07-11 04:59:48.000000000 +0800
@@ -599,25 +599,11 @@ extern const struct file_operations proc
 
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
-	spinlock_t	lock;
-	unsigned int	flags;	/* Private per-task flags */
-
-	/* For each stat XXX, add following, aligned appropriately
-	 *
-	 * struct timespec XXX_start, XXX_end;
-	 * u64 XXX_delay;
-	 * u32 XXX_count;
-	 *
-	 * Atomicity of updates to XXX_delay, XXX_count protected by
-	 * single lock above (split into XXX_lock if contention is an issue).
-	 */
-
 	/*
 	 * XXX_count is incremented on every XXX operation, the delay
 	 * associated with the operation is added to XXX_delay.
 	 * XXX_delay contains the accumulated delay time in nanoseconds.
 	 */
-	struct timespec blkio_start, blkio_end;	/* Shared by blkio, swapin */
 	u64 blkio_delay;	/* wait for sync block io completion */
 	u64 swapin_delay;	/* wait for swapin block io completion */
 	u32 blkio_count;	/* total count of the number of sync block */
diff -Nraup linux-2.6.22/kernel/delayacct.c linux-2.6.22_blkio_delay/kernel/delayacct.c
--- linux-2.6.22/kernel/delayacct.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_blkio_delay/kernel/delayacct.c	2007-07-11 06:03:42.000000000 +0800
@@ -38,8 +38,6 @@ void delayacct_init(void)
 void __delayacct_tsk_init(struct task_struct *tsk)
 {
 	tsk->delays = kmem_cache_zalloc(delayacct_cache, GFP_KERNEL);
-	if (tsk->delays)
-		spin_lock_init(&tsk->delays->lock);
 }
 
 /*
@@ -47,53 +45,34 @@ void __delayacct_tsk_init(struct task_st
  * its starting timestamp (@start)
  */
 
-static inline void delayacct_start(struct timespec *start)
+void delayacct_start(struct timespec *start)
 {
 	do_posix_clock_monotonic_gettime(start);
 }
 
 /*
  * Finish delay accounting for a statistic using
- * its timestamps (@start, @end), accumalator (@total) and @count
+ * its timestamps (@start)
  */
 
-static void delayacct_end(struct timespec *start, struct timespec *end,
-				u64 *total, u32 *count)
+void delayacct_end(struct timespec *start)
 {
-	struct timespec ts;
+	struct timespec end, ts;
 	s64 ns;
-	unsigned long flags;
 
-	do_posix_clock_monotonic_gettime(end);
-	ts = timespec_sub(*end, *start);
+	do_posix_clock_monotonic_gettime(&end);
+	ts = timespec_sub(end, *start);
 	ns = timespec_to_ns(&ts);
 	if (ns < 0)
 		return;
 
-	spin_lock_irqsave(&current->delays->lock, flags);
-	*total += ns;
-	(*count)++;
-	spin_unlock_irqrestore(&current->delays->lock, flags);
-}
-
-void __delayacct_blkio_start(void)
-{
-	delayacct_start(&current->delays->blkio_start);
-}
-
-void __delayacct_blkio_end(void)
-{
-	if (current->delays->flags & DELAYACCT_PF_SWAPIN)
-		/* Swapin block I/O */
-		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
-			&current->delays->swapin_delay,
-			&current->delays->swapin_count);
-	else	/* Other block I/O */
-		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
-			&current->delays->blkio_delay,
-			&current->delays->blkio_count);
+	if (delayacct_is_swapin()) {
+		current->delays->swapin_delay += ns;
+		current->delays->swapin_count ++;
+	} else {	/* Other block I/O */
+		current->delays->blkio_delay += ns;
+		current->delays->blkio_count ++;
+	}
 }
 
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
@@ -101,7 +80,6 @@ int __delayacct_add_tsk(struct taskstats
 	s64 tmp;
 	struct timespec ts;
 	unsigned long t1,t2,t3;
-	unsigned long flags;
 
 	/* Though tsk->delays accessed later, early exit avoids
 	 * unnecessary returning of other data
@@ -134,14 +112,12 @@ int __delayacct_add_tsk(struct taskstats
 
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
 
-	spin_lock_irqsave(&tsk->delays->lock, flags);
-	tmp = d->blkio_delay_total + tsk->delays->blkio_delay;
+	tmp = d->blkio_delay_total + ( tsk->delays->blkio_delay & ~DELAYACCT_PF_SWAPIN);
 	d->blkio_delay_total = (tmp < d->blkio_delay_total) ? 0 : tmp;
 	tmp = d->swapin_delay_total + tsk->delays->swapin_delay;
 	d->swapin_delay_total = (tmp < d->swapin_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
-	spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 done:
 	return 0;
@@ -150,12 +126,9 @@ done:
 __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 {
 	__u64 ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&tsk->delays->lock, flags);
-	ret = nsec_to_clock_t(tsk->delays->blkio_delay +
-				tsk->delays->swapin_delay);
-	spin_unlock_irqrestore(&tsk->delays->lock, flags);
+	ret = nsec_to_clock_t( (tsk->delays->blkio_delay & ~DELAYACCT_PF_SWAPIN)
+			+ tsk->delays->swapin_delay);
 	return ret;
 }
 
diff -Nraup linux-2.6.22/kernel/sched.c linux-2.6.22_blkio_delay/kernel/sched.c
--- linux-2.6.22/kernel/sched.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_blkio_delay/kernel/sched.c	2007-07-11 05:40:25.000000000 +0800
@@ -4862,12 +4862,13 @@ EXPORT_SYMBOL(yield);
 void __sched io_schedule(void)
 {
 	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	DECLARE_DELAYACCT_START_VAR;
 
-	delayacct_blkio_start();
+	DELAYACCT_START;
 	atomic_inc(&rq->nr_iowait);
 	schedule();
 	atomic_dec(&rq->nr_iowait);
-	delayacct_blkio_end();
+	DELAYACCT_END;
 }
 EXPORT_SYMBOL(io_schedule);
 
@@ -4875,12 +4876,13 @@ long __sched io_schedule_timeout(long ti
 {
 	struct rq *rq = &__raw_get_cpu_var(runqueues);
 	long ret;
+	DECLARE_DELAYACCT_START_VAR;
 
-	delayacct_blkio_start();
+	DELAYACCT_START;
 	atomic_inc(&rq->nr_iowait);
 	ret = schedule_timeout(timeout);
 	atomic_dec(&rq->nr_iowait);
-	delayacct_blkio_end();
+	DELAYACCT_END;
 	return ret;
 }
 
diff -Nraup linux-2.6.22/mm/memory.c linux-2.6.22_blkio_delay/mm/memory.c
--- linux-2.6.22/mm/memory.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_blkio_delay/mm/memory.c	2007-07-11 05:41:53.000000000 +0800
@@ -2134,7 +2134,7 @@ static int do_swap_page(struct mm_struct
 		migration_entry_wait(mm, pmd, address);
 		goto out;
 	}
-	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
+	delayacct_set_swapin();
 	page = lookup_swap_cache(entry);
 	if (!page) {
 		grab_swap_token(); /* Contend for token _before_ read-in */
@@ -2148,7 +2148,7 @@ static int do_swap_page(struct mm_struct
 			page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 			if (likely(pte_same(*page_table, orig_pte)))
 				ret = VM_FAULT_OOM;
-			delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+			delayacct_clear_swapin();
 			goto unlock;
 		}
 
@@ -2157,7 +2157,7 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+	delayacct_clear_swapin();
 	mark_page_accessed(page);
 	lock_page(page);
 
