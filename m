Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZCQLHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZCQLHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZCQLHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:07:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:37215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZCQLHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:07:39 -0400
Date: Tue, 17 Mar 2009 11:06:34 GMT
From: Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090316195902.GA6197@hades.domain.com>
References: <20090316195902.GA6197@hades.domain.com>
Subject: [tip:sched/cleanups] sched: small optimisation of can_migrate_task()
Message-ID: <tip-708dc5125309cd33c5daaad3026cc4ae6ef39c8b@git.kernel.org>
Git-Commit-ID: 708dc5125309cd33c5daaad3026cc4ae6ef39c8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 11:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  708dc5125309cd33c5daaad3026cc4ae6ef39c8b
Gitweb:     http://git.kernel.org/tip/708dc5125309cd33c5daaad3026cc4ae6ef39c8b
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Mon, 16 Mar 2009 19:59:02 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Mar 2009 12:04:41 +0100

sched: small optimisation of can_migrate_task()

There were 3 invocations of task_hot() in can_migrate_task().

Replace these 3 invocations by only one invocation, cached in
a local variable.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
LKML-Reference: <20090316195902.GA6197@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 489e7d9..d2dfe4c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3002,6 +3002,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum cpu_idle_type idle,
 		     int *all_pinned)
 {
+	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) running (obviously), or
@@ -3025,10 +3026,11 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
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
@@ -3036,7 +3038,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		return 1;
 	}
 
-	if (task_hot(p, rq->clock, sd)) {
+	if (tsk_cache_hot) {
 		schedstat_inc(p, se.nr_failed_migrations_hot);
 		return 0;
 	}
