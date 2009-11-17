Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZKQJwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZKQJwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZKQJwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:52:08 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63777 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZKQJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e2es8HrRnBanQI19jHHZrMfwj06i+i7fSMMwV1P7K6BEp7cSA43vVETowsYfTwdcH1
         mma5dH1W9BqZVZrp/st3chleorwZGdp3VqggxL2w/9HrvFd3I6cqJSTloQogaG1eg86c
         44QTALzTD6wAMaSBVLRURK5n9+3dEI8lgju5E=
From: Jupyung Lee <jupyung@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
       Jupyung Lee <jupyung@gmail.com>
Subject: [PATCH 1/1] sched: move update_curr() in check_preempt_wakeup() to avoid redundant call
Date: Tue, 17 Nov 2009 18:51:40 +0900
Message-Id: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: micro-optimization

If a RT task is woken up while a non-RT task is running, 
check_preempt_wakeup() is called to check whether the new task can 
preempt the old task. The function returns quickly without going deeper 
because it is apparent that a RT task can always preempt a non-RT task.

In this situation, check_preempt_wakeup() always calls update_curr() to
update vruntime value of the currently running task. However, the function
call is unnecessary and redundant at that moment because (1) a non-RT task can 
always be preempted by a RT task regardless of its vruntime value, and
(2) update_curr() will be called shortly when the context switch between two occurs.

By moving update_curr() in check_preempt_wakeup(), we can avoid redundant
call to update_curr(), slightly reducing the time taken to wake up RT tasks.

Signed-off-by: Jupyung Lee <jupyung@gmail.com>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37087a7..32256c0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1596,8 +1596,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	update_curr(cfs_rq);
-
 	if (unlikely(rt_prio(p->prio))) {
 		resched_task(curr);
 		return;
@@ -1655,6 +1653,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 
 	BUG_ON(!pse);
 
+	update_curr(cfs_rq);
+
 	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
 		/*
-- 
1.6.5.GIT

