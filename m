Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZIQIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZIQIzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZIQIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:55:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZIQIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:55:05 -0400
Date: Thu, 17 Sep 2009 08:54:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Stop buddies from hogging the system
Message-ID: <tip-de69a80be32445b0a71e8e3b757e584d7beb90f7@git.kernel.org>
Git-Commit-ID: de69a80be32445b0a71e8e3b757e584d7beb90f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 08:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de69a80be32445b0a71e8e3b757e584d7beb90f7
Gitweb:     http://git.kernel.org/tip/de69a80be32445b0a71e8e3b757e584d7beb90f7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Sep 2009 09:01:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 10:40:30 +0200

sched: Stop buddies from hogging the system

Clear buddies more agressively.

The (theoretical, haven't actually observed any of this) problem is
that when we do not select either buddy in pick_next_entity()
because they are too far ahead of the left-most task, we do not
clear the buddies.

This means that as soon as we service the left-most task, these
same buddies will be tried again on the next schedule. Now if the
left-most task was a pure hog, it wouldn't have done any wakeups
and it wouldn't have set buddies of its own. That leads to the old
buddies dominating, which would lead to bad latencies.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3e6f78c..ffee827 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -764,10 +764,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->last == se)
+	if (!se || cfs_rq->last == se)
 		cfs_rq->last = NULL;
 
-	if (cfs_rq->next == se)
+	if (!se || cfs_rq->next == se)
 		cfs_rq->next = NULL;
 }
 
@@ -1646,8 +1646,13 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 		/*
 		 * If se was a buddy, clear it so that it will have to earn
 		 * the favour again.
+		 *
+		 * If se was not a buddy, clear the buddies because neither
+		 * was elegible to run, let them earn it again.
+		 *
+		 * IOW. unconditionally clear buddies.
 		 */
-		__clear_buddies(cfs_rq, se);
+		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
