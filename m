Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbYFXOPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbYFXOPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbYFXOO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:14:59 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:4991 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192AbYFXOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:14:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/3] sched: limit "all_pinned" balance attempts to sd->span
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-rt-users@vger.kernel.org, ghaskins@novell.com, dbahi@novell.com
Date: Tue, 24 Jun 2008 08:14:57 -0600
Message-ID: <20080624141457.28259.61484.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080624140926.28259.2884.stgit@lsg.lsg.lab.novell.com>
References: <20080624140926.28259.2884.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load-balancing will never terminate if all cpus are "all_pinned" with
the current algorithm.  This would be pretty unlikely to occur, but we
should protect against it nonetheless.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 31f91d9..54b27b4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3178,7 +3178,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
-	cpumask_t cpus = CPU_MASK_ALL;
+	cpumask_t cpus = sd->span;
+	int remain = cpus_weight(sd->span) - 1;
 	unsigned long flags;
 
 	/*
@@ -3237,11 +3238,10 @@ redo:
 			resched_cpu(this_cpu);
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(all_pinned)) {
+		if (unlikely(all_pinned && remain)) {
 			cpu_clear(cpu_of(busiest), cpus);
-			if (!cpus_empty(cpus))
-				goto redo;
-			goto out_balanced;
+			remain--;
+			goto redo;
 		}
 	}
 
@@ -3332,7 +3332,8 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int ld_moved = 0;
 	int sd_idle = 0;
 	int all_pinned = 0;
-	cpumask_t cpus = CPU_MASK_ALL;
+	cpumask_t cpus = sd->span;
+	int remain = cpus_weight(sd->span) - 1;
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3375,10 +3376,10 @@ redo:
 					&all_pinned);
 		spin_unlock(&busiest->lock);
 
-		if (unlikely(all_pinned)) {
+		if (unlikely(all_pinned && remain)) {
 			cpu_clear(cpu_of(busiest), cpus);
-			if (!cpus_empty(cpus))
-				goto redo;
+			remain--;
+			goto redo;
 		}
 	}
 

