Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYGCVls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYGCVls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbYGCVhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:37:15 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:1108 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbYGCVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:37:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] sched: remove extraneous load manipulations
To: stable@vger.kernel.org, linux-rt-users@vger.kernel.org,
       rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, ghaskins@novell.com, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2008 15:37:11 -0600
Message-ID: <20080703213711.1275.56107.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
References: <20080703212939.1275.27072.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b reverted some patches
in the scheduler, but it looks like it may have left a few redundant
calls to inc_load/dec_load remain in set_user_nice (since the
 dequeue_task/enqueue_task take care of the load.  This could result
in the load values being off since the load may change while dequeued.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 31f91d9..b046754 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4679,10 +4679,8 @@ void set_user_nice(struct task_struct *p, long nice)
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		dec_load(rq, p);
-	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4692,7 +4690,7 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
+
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:

