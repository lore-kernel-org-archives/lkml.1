Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZKJUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZKJUzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZKJUzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:55:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZKJUz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:55:28 -0500
Date: Tue, 10 Nov 2009 20:54:52 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
       tglx@linutronix.de, pwil3058@bigpond.net.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, pwil3058@bigpond.net.au, mingo@elte.hu
In-Reply-To: <1257880321.4108.457.camel@laptop>
References: <1257880321.4108.457.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make sure task has correct sched_class after policy change
Message-ID: <tip-ffd44db5f02af32bcc25a8eb5981bf02a141cdab@git.kernel.org>
Git-Commit-ID: ffd44db5f02af32bcc25a8eb5981bf02a141cdab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffd44db5f02af32bcc25a8eb5981bf02a141cdab
Gitweb:     http://git.kernel.org/tip/ffd44db5f02af32bcc25a8eb5981bf02a141cdab
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 10 Nov 2009 20:12:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 20:22:31 +0100

sched: Make sure task has correct sched_class after policy change

>From the code in rt_mutex_setprio(), it is evident that the
intention is that task's with a RT 'prio' value as a consequence
of receiving a PI boost also have their 'sched_class' field set
to '&rt_sched_class'.

However, Peter noticed that the code in __setscheduler() could
result in this intention being frustrated. Fix it.

Reported-by: Peter Williams <pwil3058@bigpond.net.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1257880321.4108.457.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ad37776..43e61fa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6159,22 +6159,14 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
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
 
