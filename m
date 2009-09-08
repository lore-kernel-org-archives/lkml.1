Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZIHLTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZIHLTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZIHLTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:19:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:58951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZIHLTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:19:39 -0400
Date: Tue, 8 Sep 2009 11:19:04 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Ensure that a child can't gain time over it's parent after fork()
Message-ID: <tip-b5d9d734a53e0204aab0089079cbde2a1285a38f@git.kernel.org>
Git-Commit-ID: b5d9d734a53e0204aab0089079cbde2a1285a38f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 08 Sep 2009 11:19:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5d9d734a53e0204aab0089079cbde2a1285a38f
Gitweb:     http://git.kernel.org/tip/b5d9d734a53e0204aab0089079cbde2a1285a38f
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 8 Sep 2009 11:12:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Sep 2009 13:15:34 +0200

sched: Ensure that a child can't gain time over it's parent after fork()

A fork/exec load is usually "pass the baton", so the child
should never be placed behind the parent.  With START_DEBIT we
make room for the new task, but with child_runs_first, that
room comes out of the _parent's_ hide. There's nothing to say
that the parent wasn't ahead of min_vruntime at fork() time,
which means that the "baton carrier", who is essentially the
parent in drag, can gain time and increase scheduling latencies
for waiters.

With NEW_FAIR_SLEEPERS + START_DEBIT + child_runs_first
enabled, we essentially pass the sleeper fairness off to the
child, which is fine, but if we don't base placement on the
parent's updated vruntime, we can end up compounding latency
woes if the child itself then does fork/exec.  The debit
incurred at fork doesn't hurt the parent who is then going to
sleep and maybe exit, but the child who acquires the error
harms all comers.

This improves latencies of make -j<n> kernel build workloads.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cc97ea4..e386e5d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -728,11 +728,11 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 			vruntime -= thresh;
 		}
-
-		/* ensure we never gain time by being placed backwards. */
-		vruntime = max_vruntime(se->vruntime, vruntime);
 	}
 
+	/* ensure we never gain time by being placed backwards. */
+	vruntime = max_vruntime(se->vruntime, vruntime);
+
 	se->vruntime = vruntime;
 }
 
@@ -1756,6 +1756,8 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 	sched_info_queued(p);
 
 	update_curr(cfs_rq);
+	if (curr)
+		se->vruntime = curr->vruntime;
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
