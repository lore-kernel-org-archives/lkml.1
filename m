Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZIPKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZIPKUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZIPKUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:20:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:46367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZIPKUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:20:36 -0400
Date: Wed, 16 Sep 2009 10:19:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move code around
Message-ID: <tip-f5f08f39ee4c5fd0a757d25d9e04d696676b3df7@git.kernel.org>
Git-Commit-ID: f5f08f39ee4c5fd0a757d25d9e04d696676b3df7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:20:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5f08f39ee4c5fd0a757d25d9e04d696676b3df7
Gitweb:     http://git.kernel.org/tip/f5f08f39ee4c5fd0a757d25d9e04d696676b3df7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 13:35:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:03 +0200

sched: Move code around

In preparation to other code movement, move weighted_cpuload(),
source_load() and target_load() before the class includes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   81 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 17e4391..b56d150 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1507,8 +1507,45 @@ static int tg_nop(struct task_group *tg, void *data)
 #endif
 
 #ifdef CONFIG_SMP
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
+/* Used instead of source_load when we know the type == 0 */
+static unsigned long weighted_cpuload(const int cpu)
+{
+	return cpu_rq(cpu)->load.weight;
+}
+
+/*
+ * Return a low guess at the load of a migration-source cpu weighted
+ * according to the scheduling class and "nice" value.
+ *
+ * We want to under-estimate the load of migration sources, to
+ * balance conservatively.
+ */
+static unsigned long source_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return min(rq->cpu_load[type-1], total);
+}
+
+/*
+ * Return a high guess at the load of a migration-target cpu weighted
+ * according to the scheduling class and "nice" value.
+ */
+static unsigned long target_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return max(rq->cpu_load[type-1], total);
+}
+
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
 static unsigned long cpu_avg_load_per_task(int cpu)
@@ -1959,13 +1996,6 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
-
-/* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->load.weight;
-}
-
 /*
  * Is this task likely cache-hot:
  */
@@ -2241,39 +2271,6 @@ void kick_process(struct task_struct *p)
 EXPORT_SYMBOL_GPL(kick_process);
 
 /*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load[type-1], total);
-}
-
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
-static unsigned long target_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return max(rq->cpu_load[type-1], total);
-}
-
-/*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
  */
