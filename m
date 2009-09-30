Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZI3Hov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZI3Hov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZI3Hov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:44:51 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:36395 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZI3Hou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TykrU4UYwgnqy3ZZmCxPHuGxJyKpDsBVHDyCyl9jkueLCbgUfuMii6bcQ8m+XiGDri
         P12841RVSKVRZf1GlQyhgFCnnaf9wxrYWLMXbbq/lC+IlN6GGVwZvSl4ZH2uCdoHaI3O
         XZgwaK73LPZjL4JQmZmqmKJaZqfaYBzqZyY20=
MIME-Version: 1.0
Date: Wed, 30 Sep 2009 15:44:54 +0800
Message-ID: <2674af740909300044s56d75da1n5ab3cb67183dac13@mail.gmail.com>
Subject: [PATCH] sched/trival: remove usage of this_best_prio
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a393baa9a491a95afc94e122ea1f602b3010d035 Mon Sep 17 00:00:00 2001
From: Yong Zhang <yong.zhang0@gmail.com>
Date: Wed, 30 Sep 2009 15:32:58 +0800
Subject: [PATCH] sched/trival: remove usage of this_best_prio

With commit 051c6764:
sched: remove prio preference from balance decisions
this_best_prio become useless now.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/sched.h   |    2 +-
 kernel/sched.c          |    9 +++------
 kernel/sched_fair.c     |   12 ++++++------
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 5 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..ef05cac 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1081,7 +1081,7 @@ struct sched_class {
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, int *this_best_prio);
+			int *all_pinned);

 	int (*move_one_task) (struct rq *this_rq, int this_cpu,
 			      struct rq *busiest, struct sched_domain *sd,
diff --git a/kernel/sched.c b/kernel/sched.c
index ee61f45..2524fcd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1405,7 +1405,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator);
+	      struct rq_iterator *iterator);

 static int
 iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
@@ -3194,7 +3194,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator)
+	      struct rq_iterator *iterator)
 {
 	int loops = 0, pulled = 0, pinned = 0;
 	struct task_struct *p;
@@ -3237,8 +3237,6 @@ next:
 	 * We only want to steal up to the prescribed amount of weighted load.
 	 */
 	if (rem_load_move > 0) {
-		if (p->prio < *this_best_prio)
-			*this_best_prio = p->prio;
 		p = iterator->next(iterator->arg);
 		goto next;
 	}
@@ -3270,13 +3268,12 @@ static int move_tasks(struct rq *this_rq, int
this_cpu, struct rq *busiest,
 {
 	const struct sched_class *class = sched_class_highest;
 	unsigned long total_load_moved = 0;
-	int this_best_prio = this_rq->curr->prio;

 	do {
 		total_load_moved +=
 			class->load_balance(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, all_pinned);
 		class = class->next;

 #ifdef CONFIG_PREEMPT
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..4e64eee 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1733,7 +1733,7 @@ static struct task_struct
*load_balance_next_fair(void *arg)
 static unsigned long
 __load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move, struct sched_domain *sd,
-		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
+		enum cpu_idle_type idle, int *all_pinned,
 		struct cfs_rq *cfs_rq)
 {
 	struct rq_iterator cfs_rq_iterator;
@@ -1744,7 +1744,7 @@ __load_balance_fair(struct rq *this_rq, int
this_cpu, struct rq *busiest,

 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &cfs_rq_iterator);
+			&cfs_rq_iterator);
 }

 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1752,7 +1752,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -1777,7 +1777,7 @@ load_balance_fair(struct rq *this_rq, int
this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);

 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned,
 				tg->cfs_rq[busiest_cpu]);

 		if (!moved_load)
@@ -1799,11 +1799,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	return __load_balance_fair(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			&busiest->cfs);
 }
 #endif

diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index b133a28..d48ba74 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -49,7 +49,7 @@ static unsigned long
 load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	return 0;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..c6825f4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1498,7 +1498,7 @@ static unsigned long
 load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move,
 		struct sched_domain *sd, enum cpu_idle_type idle,
-		int *all_pinned, int *this_best_prio)
+		int *all_pinned)
 {
 	/* don't touch RT tasks */
 	return 0;
-- 
1.6.3.3
