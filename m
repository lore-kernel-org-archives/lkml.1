Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZIGUiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZIGUiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZIGUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:38:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:50472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZIGUiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:38:00 -0400
Date: Mon, 7 Sep 2009 20:37:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Deal with low-load in wake_affine()
Message-ID: <tip-71a29aa7b600595d0ef373ea605ac656876d1f2f@git.kernel.org>
Git-Commit-ID: 71a29aa7b600595d0ef373ea605ac656876d1f2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 07 Sep 2009 20:37:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71a29aa7b600595d0ef373ea605ac656876d1f2f
Gitweb:     http://git.kernel.org/tip/71a29aa7b600595d0ef373ea605ac656876d1f2f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 7 Sep 2009 18:28:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Sep 2009 20:39:06 +0200

sched: Deal with low-load in wake_affine()

wake_affine() would always fail under low-load situations where
both prev and this were idle, because adding a single task will
always be a significant imbalance, even if there's nothing
around that could balance it.

Deal with this by allowing imbalance when there's nothing you
can do about it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d7fda41..cc97ea4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1262,7 +1262,17 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
-	balanced = 100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+	/*
+	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
+	 * due to the sync cause above having dropped tl to 0, we'll always have
+	 * an imbalance, but there's really nothing you can do about that, so
+	 * that's good too.
+	 *
+	 * Otherwise check if either cpus are near enough in load to allow this
+	 * task to be woken on this_cpu.
+	 */
+	balanced = !tl ||
+		100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
