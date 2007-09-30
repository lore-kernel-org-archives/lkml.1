Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXI3TN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXI3TN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXI3TNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:13:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10720 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXI3TNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ibha8ROUYojnOJ95mREIZym109ZtvmcrzvuwSOpvkADzu5eCm5T2JZbIApc7sEt3jzqBh6/g+G/e+wjovOB1dLhUaONFNUDgz0SyjFu3BW/9L8hrFJIexWUJpxmYF4UkiiJ1LSeWo0xfdhsNktbhBoY9FxXWuHDKepdKi1l4lcY=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 30 Sep 2007 21:13:14 +0200
Message-Id: <1191179594.6417.8.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



here is a few patches on top of the recent 'sched-dev':

(1) [ proposal ] make timeslices of SCHED_RR tasks constant and not
dependent on task's static_prio;

(2) [ cleanup ] calc_weighted() is obsolete, remove it;

(3) [ refactoring ] make dequeue_entity() / enqueue_entity() 
and update_stats_dequeue() / update_stats_enqueue() look similar, structure-wise.

-----------------------------------

(1)

- make timeslices of SCHED_RR tasks constant and not
dependent on task's static_prio [1] ;
- remove obsolete code (timeslice related bits);
- make sched_rr_get_interval() return something more
meaningful [2] for SCHED_OTHER tasks.

[1] according to the following link, the current behavior is not compliant
with SUSv3 (not sure though, what is the reference for us :-)
http://lkml.org/lkml/2007/3/7/656

[2] the interval is dynamic and can be depicted as follows "should a
task be one of the runnable tasks at this particular moment, it would
expect to run for this interval of time before being re-scheduled by the
scheduler tick".

all in all, the code doesn't increase:

   text    data     bss     dec     hex filename
  46585    5102      40   51727    ca0f ../build/kernel/sched.o.before
  46553    5102      40   51695    c9ef ../build/kernel/sched.o

yeah, this seems to require task_rq_lock/unlock() but this is not a hot
path.

what do you think?

(compiles well, not functionally tested yet)

Almost-Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 0abed89..eba7827 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -104,11 +104,9 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 /*
  * These are the 'tuning knobs' of the scheduler:
  *
- * Minimum timeslice is 5 msecs (or 1 jiffy, whichever is larger),
- * default timeslice is 100 msecs, maximum timeslice is 800 msecs.
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
  * Timeslices get refilled after they expire.
  */
-#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
 #ifdef CONFIG_SMP
@@ -132,24 +130,6 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 }
 #endif
 
-#define SCALE_PRIO(x, prio) \
-	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
-
-/*
- * static_prio_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
- * to time slice values: [800ms ... 100ms ... 5ms]
- */
-static unsigned int static_prio_timeslice(int static_prio)
-{
-	if (static_prio == NICE_TO_PRIO(19))
-		return 1;
-
-	if (static_prio < NICE_TO_PRIO(0))
-		return SCALE_PRIO(DEF_TIMESLICE * 4, static_prio);
-	else
-		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
-}
-
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
@@ -4759,6 +4739,7 @@ asmlinkage
 long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 {
 	struct task_struct *p;
+	unsigned int time_slice;
 	int retval = -EINVAL;
 	struct timespec t;
 
@@ -4775,9 +4756,20 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 	if (retval)
 		goto out_unlock;
 
-	jiffies_to_timespec(p->policy == SCHED_FIFO ?
-				0 : static_prio_timeslice(p->static_prio), &t);
+	if (p->policy == SCHED_FIFO)
+		time_slice = 0;
+	else if (p->policy == SCHED_RR)
+		time_slice = DEF_TIMESLICE;
+	else {
+		unsigned long flags;
+		struct rq *rq;
+
+		rq = task_rq_lock(p, &flags);
+		time_slice = sched_slice(&rq->cfs, &p->se);
+		task_rq_unlock(rq, &flags);
+	}
 	read_unlock(&tasklist_lock);
+	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:
 	return retval;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index dbe4d8c..5c52881 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -206,7 +206,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
 	if (--p->time_slice)
 		return;
 
-	p->time_slice = static_prio_timeslice(p->static_prio);
+	p->time_slice = DEF_TIMESLICE;
 
 	/*
 	 * Requeue to the end of queue if we are not the only element

---

