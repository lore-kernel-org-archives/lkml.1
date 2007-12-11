Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXLKDQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXLKDQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 22:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXLKDQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 22:16:08 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39330 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXLKDQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 22:16:07 -0500
Message-Id: <20071211031458.885439069@goodmis.org>
References: <20071211030033.632581735@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Dec 2007 22:00:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4 v2] Subject: SCHED - Clean up some old cpuset logic
Content-Disposition: inline; filename=sched-clean-up-some-old-cpuset-logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We had support for overlapping cpuset based rto logic in early prototypes that
is no longer used, so clean it up.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

Index: linux-sched/kernel/sched_rt.c
===================================================================
--- linux-sched.orig/kernel/sched_rt.c	2007-12-10 20:39:19.000000000 -0500
+++ linux-sched/kernel/sched_rt.c	2007-12-10 20:39:21.000000000 -0500
@@ -586,38 +586,6 @@ static int pull_rt_task(struct rq *this_
 			continue;
 
 		src_rq = cpu_rq(cpu);
-		if (unlikely(src_rq->rt.rt_nr_running <= 1)) {
-			/*
-			 * It is possible that overlapping cpusets
-			 * will miss clearing a non overloaded runqueue.
-			 * Clear it now.
-			 */
-			if (double_lock_balance(this_rq, src_rq)) {
-				/* unlocked our runqueue lock */
-				struct task_struct *old_next = next;
-
-				next = pick_next_task_rt(this_rq);
-				if (next != old_next)
-					ret = 1;
-			}
-			if (likely(src_rq->rt.rt_nr_running <= 1)) {
-				/*
-				 * Small chance that this_rq->curr changed
-				 * but it's really harmless here.
-				 */
-				rt_clear_overload(this_rq);
-			} else {
-				/*
-				 * Heh, the src_rq is now overloaded, since
-				 * we already have the src_rq lock, go straight
-				 * to pulling tasks from it.
-				 */
-				goto try_pulling;
-			}
-			spin_unlock(&src_rq->lock);
-			continue;
-		}
-
 		/*
 		 * We can potentially drop this_rq's lock in
 		 * double_lock_balance, and another CPU could
@@ -641,7 +609,6 @@ static int pull_rt_task(struct rq *this_
 			continue;
 		}
 
- try_pulling:
 		p = pick_next_highest_task_rt(src_rq, this_cpu);
 
 		/*

-- 
