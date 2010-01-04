Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327Ab0ADJVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0ADJVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184Ab0ADJU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:20:56 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:43313 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0ADJU4 (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Mon, 4 Jan 2010 04:20:56 -0500
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Suresh Jayaraman <sjayaraman@suse.de>
Subject: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy machines
Date: Mon,  4 Jan 2010 14:50:42 +0530
Message-Id: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I understand the idea of sleeper fairness is to consider sleeping tasks
similar to the ones on the runqueue and credit the sleepers in a way that it
would get CPU as if it were running.

Currently, when fair sleepers are enabled, the task that was sleeping seem to
get a bonus of cfs_rq->min_vruntime - sched_latency (in most cases). While with
gentle fair sleepers this effect was reduced to half, there still remains a
chance that on busy machines with more number of tasks, the sleepers might get
a huge undue bonus.

Here's a patch to avoid this by computing the entitled CPU time for the
sleeping task during the period taking into account only the current
cfs_rq->nr_running and thus tries to make it adaptive.
Compile-tested only.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 kernel/sched_fair.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..d81fcb3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -739,6 +739,15 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	/* sleeps up to a single latency don't count. */
 	if (!initial && sched_feat(FAIR_SLEEPERS)) {
 		unsigned long thresh = sysctl_sched_latency;
+		unsigned long delta_exec = (unsigned long)
+					(rq_of(cfs_rq)->clock - se->exec_start);
+		unsigned long sleeper_bonus;
+
+		/* entitled share of CPU time adapted to current nr_running */
+		if (likely(cfs_rq->nr_running > 1))
+			sleeper_bonus = delta_exec/cfs_rq->nr_running;
+		else
+			sleeper_bonus = delta_exec;
 
 		/*
 		 * Convert the sleeper threshold into virtual time.
@@ -757,7 +766,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		if (sched_feat(GENTLE_FAIR_SLEEPERS))
 			thresh >>= 1;
 
-		vruntime -= thresh;
+		vruntime -= min(thresh, sleeper_bonus);
 	}
 
 	/* ensure we never gain time by being placed backwards. */
