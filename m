Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZEKId0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZEKId0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZEKIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:33:16 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:19317 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEKIdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:33:15 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 04:33:14 EDT
Message-ID: <4A07E044.8040807@sonarnerd.net>
Date: Mon, 11 May 2009 11:22:28 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net> <1232954745.4863.4.camel@laptop>
In-Reply-To: <1232954745.4863.4.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010604030302030807020401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010604030302030807020401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Peter Zijlstra wrote:
> Right, and I think the solution to this problem is twofold, 1)
> application writers should start writing (soft) realtime applications if
> they want (soft) realtime behaviour -- there's just no way around that.

Just to avoid need for reviewing and reworking ~800 klocs of user space
code in just gstreamer, here's a second take on patches. This time
splitting things into smaller pieces. Attached patch exposes 40
priorities ~ nice values as something accessible through
sched_()/pthreads API in order to control priorities of individual
threads. Current Linux implementation of SCHED_OTHER is broken in a way,
that it exposes only one single priority level - 0. Thus no possibility
to properly control priorities of threads through pthread API. This is
patch is against 2.6.29.2 and not tested, but builds. I can also send
rest of the changes as separate small feature patches as needed.
However, before doing any more work I would like to hear opinions on
this and especially what is wrong with the code or idea...

> And 2), the kernel can help by providing a deadline based scheduler,
> which should make the above easier and less likely to mess up the rest
> of the system. ie. a deadline scheduled application will not exceed its
> allotted budget, unlike a FIFO scheduled app.

Any news on this one?


	- Jussi

--------------010604030302030807020401
Content-Type: text/x-patch;
 name="sched-tiny.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched-tiny.patch"

diff -urN linux-2.6.29.2.orig/include/linux/sched.h linux-2.6.29.2.new/include/linux/sched.h
--- linux-2.6.29.2.orig/include/linux/sched.h	2009-04-27 20:37:11.000000000 +0300
+++ linux-2.6.29.2.new/include/linux/sched.h	2009-05-11 11:02:26.000000000 +0300
@@ -38,6 +38,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_MM		6
 
 #ifdef __KERNEL__
 
diff -urN linux-2.6.29.2.orig/kernel/sched.c linux-2.6.29.2.new/kernel/sched.c
--- linux-2.6.29.2.orig/kernel/sched.c	2009-04-27 20:37:11.000000000 +0300
+++ linux-2.6.29.2.new/kernel/sched.c	2009-05-11 11:02:26.000000000 +0300
@@ -24,6 +24,7 @@
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
  *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
  *              Thomas Gleixner, Mike Kravetz
+ *  2008-12-22  Multimedia scheduling class by Jussi Laako.
  */
 
 #include <linux/mm.h>
@@ -98,6 +99,14 @@
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
@@ -160,6 +169,18 @@
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
@@ -5282,6 +5303,7 @@
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
+	case SCHED_MM:
 		p->sched_class = &fair_sched_class;
 		break;
 	case SCHED_FIFO:
@@ -5292,6 +5314,8 @@
 
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
+	if (task_has_mm_policy(p))
+		p->static_prio = prio;
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
 	set_load_weight(p);
@@ -5329,19 +5353,26 @@
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
@@ -5418,7 +5449,11 @@
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
@@ -5563,7 +5598,10 @@
 	if (retval)
 		goto out_unlock;
 
-	lp.sched_priority = p->rt_priority;
+	if (task_has_mm_policy(p))
+		lp.sched_priority = INV_MM_PRIO(USER_PRIO(p->static_prio));
+	else
+		lp.sched_priority = p->rt_priority;
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -5890,6 +5928,9 @@
 	case SCHED_RR:
 		ret = MAX_USER_RT_PRIO-1;
 		break;
+	case SCHED_MM:
+		ret = MM_PRIO_MAX;
+		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -5915,10 +5956,14 @@
 	case SCHED_RR:
 		ret = 1;
 		break;
+	case SCHED_MM:
+		ret = MM_PRIO_MIN;
+		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
 		ret = 0;
+		break;
 	}
 	return ret;
 }

--------------010604030302030807020401--
