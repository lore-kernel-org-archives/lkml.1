Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZIJS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZIJS6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZIJS6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:49834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZIJS6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:58:15 -0400
Date: Thu, 10 Sep 2009 18:57:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       realnc@arcor.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       realnc@arcor.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AA93D34.8040500@arcor.de>
References: <4AA93D34.8040500@arcor.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sched::sched_stat_wait tracepoint field
Message-ID: <tip-e1f8450854d69f0291882804406ea1bab3ca44b4@git.kernel.org>
Git-Commit-ID: e1f8450854d69f0291882804406ea1bab3ca44b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 10 Sep 2009 18:57:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1f8450854d69f0291882804406ea1bab3ca44b4
Gitweb:     http://git.kernel.org/tip/e1f8450854d69f0291882804406ea1bab3ca44b4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 10 Sep 2009 20:52:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Sep 2009 20:52:54 +0200

sched: Fix sched::sched_stat_wait tracepoint field

This weird perf trace output:

  cc1-9943  [001]  2802.059479616: sched_stat_wait: task: as:9944 wait: 2801938766276 [ns]

Is caused by setting one component field of the delta to zero
a bit too early. Move it to later.

( Note, this does not affect the NEW_FAIR_SLEEPERS interactivity bug,
  it's just a reporting bug in essence. )

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikos Chantziaras <realnc@arcor.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <4AA93D34.8040500@arcor.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 26fadb4..aa7f841 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -545,14 +545,13 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	schedstat_set(se->wait_count, se->wait_count + 1);
 	schedstat_set(se->wait_sum, se->wait_sum +
 			rq_of(cfs_rq)->clock - se->wait_start);
-	schedstat_set(se->wait_start, 0);
-
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
 		trace_sched_stat_wait(task_of(se),
 			rq_of(cfs_rq)->clock - se->wait_start);
 	}
 #endif
+	schedstat_set(se->wait_start, 0);
 }
 
 static inline void
