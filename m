Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZIHLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZIHLQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZIHLQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:16:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:60963 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754160AbZIHLQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:16:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SkRIr/n7SzWPjyFCTjC/leG0hRlaxxsrBODkLSP
	YQqNWloEy5dhe3
Subject: [patch] sched: ensure than a child can't start left of it's
 parent's vruntime at fork() time
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 13:16:17 +0200
Message-Id: <1252408577.10770.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: ensure than a child can't start left of it's parent's vruntime at fork() time.

With START_DEBIT we make room for the new task, but with child_runs_first,
the debit lands on the parent when we swap vruntimes.  There's nothing to
prevent the parent's vruntime having been right of min_vruntime at fork()
time, meaning that the child can gain vruntime, thus increasing scheduling
latency for waiters.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cc97ea4..eb1269c 100644
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
 
@@ -1756,6 +1757,8 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 	sched_info_queued(p);
 
 	update_curr(cfs_rq);
+	if (curr)
+		se->vruntime = curr->vruntime;	
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */


