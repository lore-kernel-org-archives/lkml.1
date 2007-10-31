Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXJaVPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXJaVPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbXJaVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbXJaVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:18 -0400
Message-Id: <20071031211249.531637000@chello.nl>
References: <20071031211030.310581000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 22:10:35 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: [PATCH 5/6] sched: SCHED_FIFO/SCHED_RR watchdog timer
Content-Disposition: inline; filename=sched-watchdog.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new rlimit that allows the user to set a runtime timeout
on real-time tasks. Once this limit is exceeded the task will receive
SIGXCPU.

Input and ideas by Thomas Gleixner and Lennart Poettering.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Lennart Poettering <mzxreary@0pointer.de>
---
 include/asm-generic/resource.h |    5 +++--
 include/linux/sched.h          |    1 +
 kernel/sched.c                 |    2 +-
 kernel/sched_rt.c              |   18 ++++++++++++++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

Index: linux-2.6/include/asm-generic/resource.h
===================================================================
--- linux-2.6.orig/include/asm-generic/resource.h
+++ linux-2.6/include/asm-generic/resource.h
@@ -44,8 +44,8 @@
 #define RLIMIT_NICE		13	/* max nice prio allowed to raise to
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
-
-#define RLIM_NLIMITS		15
+#define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
+#define RLIM_NLIMITS		16
 
 /*
  * SuS says limits have to be unsigned.
@@ -86,6 +86,7 @@
 	[RLIMIT_MSGQUEUE]	= {   MQ_BYTES_MAX,   MQ_BYTES_MAX },	\
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
+	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 }
 
 #endif	/* __KERNEL__ */
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -31,6 +31,9 @@ static void enqueue_task_rt(struct rq *r
 
 	list_add_tail(&p->rt.run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+
+	if (wakeup)
+		p->rt.timeout = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
 }
 
 /*
@@ -205,8 +208,23 @@ move_one_task_rt(struct rq *this_rq, int
 }
 #endif
 
+#define TICK_US (1000000UL / HZ)
+
+static void watchdog(struct rq *rq, struct task_struct *p)
+{
+	if (p->rt.timeout != RLIM_INFINITY) {
+		if (p->rt.timeout < TICK_US) {
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, p);
+			return;
+		}
+		p->rt.timeout -= TICK_US;
+	}
+}
+
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	watchdog(rq, p);
+
 	/*
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -914,6 +914,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned int time_slice;
+	unsigned long timeout;
 };
 
 struct task_struct {

--

