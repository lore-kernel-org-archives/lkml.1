Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYCEOlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYCEOlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYCEOlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:41:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYCEOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:41:44 -0500
Subject: [PATCH] balance RT task resched only on runqueue
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 09:41:41 -0500
Message-Id: <1204728101.5241.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the RT kernel we discovered a place that can reschedule a task
without holding the tasks runqueue lock.  This was caused by the RT
balancing code that pulls RT tasks to the current run queue and will
reschedule the current task.

There's a slight chance that the pulling of the RT tasks will release
the current runqueue's lock and retake it (in the double_lock_balance).
During this time that the runqueue is released, the current task can
migrate to another runqueue.

In the prio_changed_rt code, after the pull, if the current task is of
lesser priority than one of the RT tasks pulled, resched_task is called
on the current task. If the current task had migrated in that small
window, resched_task will be called without holding the runqueue lock
for the runqueue that the task is on.

This race condition also exists in the mainline kernel and this patch
adds a check to make sure the task hasn't migrated before calling
resched_task.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_rt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2008-03-05 09:07:28.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2008-03-05 09:18:58.000000000 -0500
@@ -1107,9 +1107,11 @@ static void prio_changed_rt(struct rq *r
 			pull_rt_task(rq);
 		/*
 		 * If there's a higher priority task waiting to run
-		 * then reschedule.
+		 * then reschedule. Note, the above pull_rt_task
+		 * can release the rq lock and p could migrate.
+		 * Only reschedule if p is still on the same runqueue.
 		 */
-		if (p->prio > rq->rt.highest_prio)
+		if (p->prio > rq->rt.highest_prio && task_rq(p) == rq)
 			resched_task(p);
 #else
 		/* For UP simply resched on drop of prio */


