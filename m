Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZIPKWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZIPKWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZIPKV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:21:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46447 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbZIPKV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:21:56 -0400
Date: Wed, 16 Sep 2009 10:21:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix task affinity for select_task_rq_fair
Message-ID: <tip-d7c33c4930f569caf6b2ece597432853c4151a45@git.kernel.org>
Git-Commit-ID: d7c33c4930f569caf6b2ece597432853c4151a45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:21:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7c33c4930f569caf6b2ece597432853c4151a45
Gitweb:     http://git.kernel.org/tip/d7c33c4930f569caf6b2ece597432853c4151a45
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Sep 2009 12:45:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:07 +0200

sched: Fix task affinity for select_task_rq_fair

While merging select_task_rq_fair() and sched_balance_self() I made
a mistake that leads to testing the wrong task affinty.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 43dc6d1..8b3eddb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1318,7 +1318,6 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  */
 static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 {
-	struct task_struct *t = current;
 	struct sched_domain *tmp, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
@@ -1393,13 +1392,13 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 			continue;
 		}
 
-		group = find_idlest_group(sd, t, cpu);
+		group = find_idlest_group(sd, p, cpu);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu);
+		new_cpu = find_idlest_cpu(group, p, cpu);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
