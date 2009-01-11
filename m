Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZAKOnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZAKOnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZAKOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:43:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZAKOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:43:14 -0500
Date: Sun, 11 Jan 2009 15:43:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20090111144305.GA7154@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Li Zefan (1):
      sched: partly revert "sched debug: remove NULL checking in print_cfs_rt_rq()"

Rusty Russell (1):
      cpumask: fix CONFIG_NUMA=y sched.c

Steven Noonan (1):
      kernel/sched.c: add missing forward declaration for 'double_rq_lock'


 kernel/sched.c       |   13 ++++++++-----
 kernel/sched_debug.c |   21 +++++++++++++++++----
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index deb5ac8..8be2c13 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -125,6 +125,9 @@ DEFINE_TRACE(sched_switch);
 DEFINE_TRACE(sched_migrate_task);
 
 #ifdef CONFIG_SMP
+
+static void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
  * Since cpu_power is a 'constant', we can use a reciprocal divide.
@@ -7282,10 +7285,10 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
  * groups, so roll our own. Now each node has its own list of groups which
  * gets dynamically allocated.
  */
-static DEFINE_PER_CPU(struct sched_domain, node_domains);
+static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
-static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
+static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
 static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
@@ -7560,7 +7563,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 #ifdef CONFIG_NUMA
 		if (cpumask_weight(cpu_map) >
 				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
-			sd = &per_cpu(allnodes_domains, i);
+			sd = &per_cpu(allnodes_domains, i).sd;
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			cpumask_copy(sched_domain_span(sd), cpu_map);
@@ -7570,7 +7573,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		} else
 			p = NULL;
 
-		sd = &per_cpu(node_domains, i);
+		sd = &per_cpu(node_domains, i).sd;
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
@@ -7688,7 +7691,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(node_domains, j);
+			sd = &per_cpu(node_domains, j).sd;
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4293cfa..16eeba4 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -145,6 +145,19 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
+#if defined(CONFIG_CGROUP_SCHED) && \
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+static void task_group_path(struct task_group *tg, char *buf, int buflen)
+{
+	/* may be NULL if the underlying cgroup isn't fully-created yet */
+	if (!tg->css.cgroup) {
+		buf[0] = '\0';
+		return;
+	}
+	cgroup_path(tg->css.cgroup, buf, buflen);
+}
+#endif
+
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
@@ -154,10 +167,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	unsigned long flags;
 
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
-	char path[128] = "";
+	char path[128];
 	struct task_group *tg = cfs_rq->tg;
 
-	cgroup_path(tg->css.cgroup, path, sizeof(path));
+	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
@@ -208,10 +221,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
-	char path[128] = "";
+	char path[128];
 	struct task_group *tg = rt_rq->tg;
 
-	cgroup_path(tg->css.cgroup, path, sizeof(path));
+	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else
