Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYL2Ssn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYL2Ssn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYL2Ssf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:48:35 -0500
Received: from rankki.sonarnerd.net ([83.145.240.118]:11442 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYL2Sse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:48:34 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 13:48:33 EST
Message-ID: <4959198A.3020209@sonarnerd.net>
Date: Mon, 29 Dec 2008 20:40:10 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Multimedia scheduling class
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------090707020905090303000404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090707020905090303000404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I have created an experimental multimedia scheduling class (SCHED_MM)
for use with multithreaded non-hardcore-realtime multimedia
applications, such as ones based on gstreamer. These typically don't
follow the determinism rules of well behaved SCHED_FIFO applications.
However, these usually handle tasks like VoIP call audio processing,
where somewhat lower scheduling latency is needed to obtain good user
experience. Usually these are not very CPU-heavy and are mostly IO-bound
processes. Thus, something between normal SCHED_OTHER and SCHED_FIFO is
needed in a way where different threads of execution can set different
kinds of scheduling parameters.

I have attached an initial version of my experimental patch for comments...


Best regards,

	- Jussi Laako

--------------090707020905090303000404
Content-Type: text/x-patch;
 name="sched-mm4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-mm4.patch"

diff -ur linux-2.6.27.7-9.orig/include/linux/sched.h linux-2.6.27.7-9.new/include/linux/sched.h
--- linux-2.6.27.7-9.orig/include/linux/sched.h	2008-12-05 03:48:08.000000000 +0200
+++ linux-2.6.27.7-9.new/include/linux/sched.h	2008-12-22 15:04:26.000000000 +0200
@@ -38,6 +38,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_MM		6
 
 #ifdef __KERNEL__
 
diff -ur linux-2.6.27.7-9.orig/kernel/sched.c linux-2.6.27.7-9.new/kernel/sched.c
--- linux-2.6.27.7-9.orig/kernel/sched.c	2008-12-05 03:48:08.000000000 +0200
+++ linux-2.6.27.7-9.new/kernel/sched.c	2008-12-29 17:32:20.000000000 +0200
@@ -24,6 +24,7 @@
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
  *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
  *              Thomas Gleixner, Mike Kravetz
+ *  2008-12-22  Multimedia scheduling class by Jussi Laako.
  */
 
 #include <linux/mm.h>
@@ -97,6 +98,14 @@
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
 /*
+ * User definable priorities for SCHED_MM.
+ */
+#define MM_PRIO_MIN		0
+#define MM_PRIO_MAX		39
+#define INV_MM_PRIO(p)		(39-(p))
+#define STATIC_PRIO(p)		((p)+MAX_RT_PRIO)
+
+/*
  * Helpers for converting nanosecond timing to jiffy resolution
  */
 #define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
@@ -150,6 +159,18 @@
 	return rt_policy(p->policy);
 }
 
+static inline int mm_policy(int policy)
+{
+	if (unlikely(policy == SCHED_MM))
+		return 1;
+	return 0;
+}
+
+static inline int task_has_mm_policy(struct task_struct *p)
+{
+	return mm_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -1629,8 +1650,17 @@
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
-	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	if (!task_has_mm_policy(p)) {
+		p->se.load.weight =
+			prio_to_weight[p->static_prio - MAX_RT_PRIO];
+		p->se.load.inv_weight =
+			prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	} else {
+		p->se.load.weight =
+			prio_to_weight[p->static_prio - MAX_RT_PRIO] << 1;
+		p->se.load.inv_weight =
+			prio_to_wmult[p->static_prio - MAX_RT_PRIO] >> 1;
+	}
 }
 
 static void update_avg(u64 *avg, u64 sample)
@@ -1680,6 +1710,8 @@
 
 	if (task_has_rt_policy(p))
 		prio = MAX_RT_PRIO-1 - p->rt_priority;
+	/*else if (task_has_mm_policy(p))
+		prio = MAX_RT_PRIO;*/
 	else
 		prio = __normal_prio(p);
 	return prio;
@@ -4919,7 +4951,13 @@
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 
-	p->static_prio = NICE_TO_PRIO(nice);
+	/*
+	 * No nice for SCHED_MM, always max priority (nice -20).
+	 */
+	if (task_has_mm_policy(p))
+		p->static_prio = MAX_RT_PRIO;
+	else
+		p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
@@ -5056,6 +5094,7 @@
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
+	case SCHED_MM:
 		p->sched_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
@@ -5066,6 +5105,9 @@
 
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
+	/* SCHED_MM is always at highest normal priority */
+	if (p->policy == SCHED_MM)
+		p->static_prio = prio;
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
 	set_load_weight(p);
@@ -5087,19 +5129,26 @@
 		policy = oldpolicy = p->policy;
 	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
 			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
-			policy != SCHED_IDLE)
+			policy != SCHED_IDLE && policy != SCHED_MM)
 		return -EINVAL;
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
 	 * SCHED_BATCH and SCHED_IDLE is 0.
+	 * SCHED_MM has valid range from MM_PRIO_MIN to MM_PRIO_MAX.
 	 */
-	if (param->sched_priority < 0 ||
-	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
-	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
-		return -EINVAL;
-	if (rt_policy(policy) != (param->sched_priority != 0))
-		return -EINVAL;
+	if (mm_policy(policy)) {
+		if (param->sched_priority < MM_PRIO_MIN ||
+		    param->sched_priority > MM_PRIO_MAX)
+			return -EINVAL;
+	} else {
+		if (param->sched_priority < 0 ||
+		    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
+		    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
+			return -EINVAL;
+		if (rt_policy(policy) != (param->sched_priority != 0))
+			return -EINVAL;
+	}
 
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
@@ -5176,7 +5225,11 @@
 		p->sched_class->put_prev_task(rq, p);
 
 	oldprio = p->prio;
-	__setscheduler(rq, p, policy, param->sched_priority);
+	if (mm_policy(policy))
+		__setscheduler(rq, p, policy,
+			STATIC_PRIO(INV_MM_PRIO(param->sched_priority)));
+	else
+		__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -5321,7 +5374,10 @@
 	if (retval)
 		goto out_unlock;
 
-	lp.sched_priority = p->rt_priority;
+	if (task_has_mm_policy(p))
+		lp.sched_priority = INV_MM_PRIO(USER_PRIO(p->static_prio));
+	else
+		lp.sched_priority = p->rt_priority;
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -5630,6 +5686,9 @@
 	case SCHED_RR:
 		ret = MAX_USER_RT_PRIO-1;
 		break;
+	case SCHED_MM:
+		ret = MM_PRIO_MAX;
+		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -5655,6 +5714,9 @@
 	case SCHED_RR:
 		ret = 1;
 		break;
+	case SCHED_MM:
+		ret = MM_PRIO_MIN;
+		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
diff -ur linux-2.6.27.7-9.orig/kernel/sched_fair.c linux-2.6.27.7-9.new/kernel/sched_fair.c
--- linux-2.6.27.7-9.orig/kernel/sched_fair.c	2008-12-05 03:48:04.000000000 +0200
+++ linux-2.6.27.7-9.new/kernel/sched_fair.c	2008-12-23 09:50:23.000000000 +0200
@@ -18,6 +18,9 @@
  *
  *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ *  Multimedia scheduling by Jussi Laako
+ *  Copyright (C) 2008 Nokia Corporation, Jussi Laako <jussi.laako@nokia.com>
  */
 
 #include <linux/latencytop.h>
@@ -959,7 +962,8 @@
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
-	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
+	if (likely(!sysctl_sched_compat_yield) &&
+		curr->policy != SCHED_BATCH) {
 		update_rq_clock(rq);
 		/*
 		 * Update run-time statistics of the 'current'.
@@ -1293,6 +1297,11 @@
 {
 	s64 gran, vdiff = curr->vruntime - se->vruntime;
 
+	/* preempt always for multimedia tasks */
+	if (unlikely(task_of(curr)->policy != SCHED_MM &&
+		task_of(se)->policy == SCHED_MM))
+		return 1;
+
 	if (vdiff <= 0)
 		return -1;
 
@@ -1331,9 +1340,25 @@
 	if (unlikely(p->policy == SCHED_BATCH))
 		return;
 
+	/*
+	 * Only non-multimedia tasks can be preempted.
+	 */
+	if (unlikely(p->policy != SCHED_MM && curr->policy == SCHED_MM))
+		return;
+
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	/*
+	 * Preempt non-multimedia tasks with multimedia tasks immediately.
+	 */
+	if (unlikely(p->policy == SCHED_MM && curr->policy != SCHED_MM)) {
+		update_rq_clock(rq);
+		update_curr(cfs_rq);
+		resched_task(curr);
+		return;
+	}
+
 	find_matching_se(&se, &pse);
 
 	while (se) {

--------------090707020905090303000404--
