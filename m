Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZJNNPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZJNNPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760787AbZJNNPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:15:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:43452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760783AbZJNNPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:15:17 -0400
Date: Wed, 14 Oct 2009 13:13:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yanmin_zhang@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255084986.8802.46.camel@laptop>
References: <1255084986.8802.46.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Do less agressive buddy clearing
Message-ID: <tip-92f6a5e37a2e2d3342dafb2b39c2f8bc340bbf84@git.kernel.org>
Git-Commit-ID: 92f6a5e37a2e2d3342dafb2b39c2f8bc340bbf84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 13:13:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92f6a5e37a2e2d3342dafb2b39c2f8bc340bbf84
Gitweb:     http://git.kernel.org/tip/92f6a5e37a2e2d3342dafb2b39c2f8bc340bbf84
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Oct 2009 12:43:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 15:02:34 +0200

sched: Do less agressive buddy clearing

Yanmin reported a hackbench regression due to:

 > commit de69a80be32445b0a71e8e3b757e584d7beb90f7
 > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 > Date:   Thu Sep 17 09:01:20 2009 +0200
 >
 >     sched: Stop buddies from hogging the system

I really liked de69a80b, and it affecting hackbench shows I wasn't
crazy ;-)

So hackbench is a multi-cast, with one sender spraying multiple
receivers, who in their turn don't spray back.

This would be exactly the scenario that patch 'cures'. Previously
we would not clear the last buddy after running the next task,
allowing the sender to get back to work sooner than it otherwise
ought to have been, increasing latencies for other tasks.

Now, since those receivers don't poke back, they don't enforce the
buddy relation, which means there's nothing to re-elect the sender.

Cure this by less agressively clearing the buddy stats. Only clear
buddies when they were not chosen. It should still avoid a buddy
sticking around long after its served its time.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1255084986.8802.46.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..c32c3e6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -861,12 +861,21 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *buddy;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
-		return cfs_rq->next;
+	if (cfs_rq->next) {
+		buddy = cfs_rq->next;
+		cfs_rq->next = NULL;
+		if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
-		return cfs_rq->last;
+	if (cfs_rq->last) {
+		buddy = cfs_rq->last;
+		cfs_rq->last = NULL;
+		if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
 	return se;
 }
@@ -1654,16 +1663,6 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
-		/*
-		 * If se was a buddy, clear it so that it will have to earn
-		 * the favour again.
-		 *
-		 * If se was not a buddy, clear the buddies because neither
-		 * was elegible to run, let them earn it again.
-		 *
-		 * IOW. unconditionally clear buddies.
-		 */
-		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
