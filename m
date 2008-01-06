Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYAFQZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYAFQZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbYAFQXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:23 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:53048 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756673AbYAFQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:16 -0500
Message-Id: <20080106162123.590915000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:33 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/11] hrtimer: unlock hrtimer_wakeup
Content-Disposition: inline; filename=hrtimer-do_nanosleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_wakeup creates a

  base->lock
    rq->lock

lock dependancy. Avoid this by switching to HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
which doesn't hold base->lock.

This fully untangles hrtimer locks from the scheduler locks, and allows
hrtimer usage in the scheduler proper.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1296,7 +1296,7 @@ void hrtimer_init_sleeper(struct hrtimer
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
 #ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
+	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 #endif
 }
 
@@ -1307,6 +1307,8 @@ static int __sched do_nanosleep(struct h
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start(&t->timer, t->timer.expires, mode);
+		if (!hrtimer_active(&t->timer))
+			t->task = NULL;
 
 		if (likely(t->task))
 			schedule();

--

