Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZJNNP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZJNNP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbZJNNP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:15:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:43453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761252AbZJNNPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:15:20 -0400
Date: Wed, 14 Oct 2009 13:13:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, pwil3058@bigpond.net.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, pwil3058@bigpond.net.au,
       mingo@elte.hu
In-Reply-To: <1253687579.7695.89.camel@twins>
References: <1253687579.7695.89.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Make sure task has correct sched_class after policy change
Message-ID: <tip-67d08dfed042855431dc99c9e0e6f6f7e85737ef@git.kernel.org>
Git-Commit-ID: 67d08dfed042855431dc99c9e0e6f6f7e85737ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 13:13:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67d08dfed042855431dc99c9e0e6f6f7e85737ef
Gitweb:     http://git.kernel.org/tip/67d08dfed042855431dc99c9e0e6f6f7e85737ef
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 12 Oct 2009 17:20:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 15:02:35 +0200

sched: Make sure task has correct sched_class after policy change

>From the code in rt_mutex_setprio(), it is evident that the
intention is that task's with a RT 'prio' value as a consequence of
receiving a PI boost also have their 'sched_class' field set to
'&rt_sched_class'.

However, Peter noticed that the code in __setscheduler() could
result in this intention being frustrated. Fix it.

Reported-by: Peter Williams <pwil3058@bigpond.net.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1253687579.7695.89.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 789001d..2d7a002 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6145,23 +6145,14 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
 	BUG_ON(p->se.on_rq);
 
-	p->policy = policy;
-	switch (p->policy) {
-	case SCHED_NORMAL:
-	case SCHED_BATCH:
-	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
-		break;
-	case SCHED_FIFO:
-	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
-		break;
-	}
-
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
 	set_load_weight(p);
 }
 
