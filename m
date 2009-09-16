Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZIPKVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZIPKVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZIPKVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:21:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:46423 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbZIPKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:21:28 -0400
Date: Wed, 16 Sep 2009 10:21:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Weaken SD_POWERSAVINGS_BALANCE
Message-ID: <tip-ae154be1f34a674e6cbb43ccf6e442f56acd7a70@git.kernel.org>
Git-Commit-ID: ae154be1f34a674e6cbb43ccf6e442f56acd7a70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:21:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae154be1f34a674e6cbb43ccf6e442f56acd7a70
Gitweb:     http://git.kernel.org/tip/ae154be1f34a674e6cbb43ccf6e442f56acd7a70
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 14:40:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:06 +0200

sched: Weaken SD_POWERSAVINGS_BALANCE

One of the problems of power-saving balancing is that under certain
scenarios it is too slow and allows tons of real work to pile up.

Avoid this by ignoring the powersave stuff when there's real work
to be done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c      |   40 ++++++++++++++++++++--------------------
 kernel/sched_fair.c |   21 ++++++++++++++++++---
 2 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6c819f3..f0ccb8b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1538,6 +1538,26 @@ static unsigned long target_load(int cpu, int type)
 	return max(rq->cpu_load[type-1], total);
 }
 
+static struct sched_group *group_of(int cpu)
+{
+	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+
+	if (!sd)
+		return NULL;
+
+	return sd->groups;
+}
+
+static unsigned long power_of(int cpu)
+{
+	struct sched_group *group = group_of(cpu);
+
+	if (!group)
+		return SCHED_LOAD_SCALE;
+
+	return group->cpu_power;
+}
+
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
 static unsigned long cpu_avg_load_per_task(int cpu)
@@ -3982,26 +4002,6 @@ ret:
 	return NULL;
 }
 
-static struct sched_group *group_of(int cpu)
-{
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
-
-	if (!sd)
-		return NULL;
-
-	return sd->groups;
-}
-
-static unsigned long power_of(int cpu)
-{
-	struct sched_group *group = group_of(cpu);
-
-	if (!group)
-		return SCHED_LOAD_SCALE;
-
-	return group->cpu_power;
-}
-
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 09d19f7..eaa0001 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1333,10 +1333,25 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 
 	for_each_domain(cpu, tmp) {
 		/*
-		 * If power savings logic is enabled for a domain, stop there.
+		 * If power savings logic is enabled for a domain, see if we
+		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
-			break;
+		if (tmp->flags & SD_POWERSAVINGS_BALANCE) {
+			unsigned long power = 0;
+			unsigned long nr_running = 0;
+			unsigned long capacity;
+			int i;
+
+			for_each_cpu(i, sched_domain_span(tmp)) {
+				power += power_of(i);
+				nr_running += cpu_rq(i)->cfs.nr_running;
+			}
+
+			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+
+			if (nr_running/2 < capacity)
+				break;
+		}
 
 		switch (flag) {
 		case SD_BALANCE_WAKE:
