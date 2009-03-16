Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbZCPUB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbZCPUB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZCPUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:01:13 -0400
Received: from relay1.ptmail.sapo.pt ([212.55.154.21]:56188 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758689AbZCPUBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:01:10 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 16 Mar 2009 19:59:02 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 -tip] sched: small optimisation on can_migrate_task
Message-ID: <20090316195902.GA6197@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were 3 invocation to task_hot() in function can_migrate_task().  These 3
invocations have been replaced by only one invocation, cached in a local
variable.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/sched.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a5d929..4000304 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3072,6 +3072,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum cpu_idle_type idle,
 		     int *all_pinned)
 {
+	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) running (obviously), or
@@ -3095,10 +3096,11 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	if (!task_hot(p, rq->clock, sd) ||
-			sd->nr_balance_failed > sd->cache_nice_tries) {
+	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	if (!tsk_cache_hot ||
+		sd->nr_balance_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, rq->clock, sd)) {
+		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
 			schedstat_inc(p, se.nr_forced_migrations);
 		}
@@ -3106,7 +3108,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		return 1;
 	}
 
-	if (task_hot(p, rq->clock, sd)) {
+	if (tsk_cache_hot) {
 		schedstat_inc(p, se.nr_failed_migrations_hot);
 		return 0;
 	}
-- 
1.6.2

