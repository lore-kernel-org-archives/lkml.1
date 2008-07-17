Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbYGQIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbYGQIJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYGQIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:09:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYGQIJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:09:30 -0400
Message-ID: <487EFDD0.2060101@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 16:07:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple cpusets are overlapping in their 'cpus' and hence they
form a single sched domain, the largest sched_relax_domain_level among
those should be used. But when top_cpuset's sched_load_balance is
set, its sched_relax_domain_level is used regardless other sub-cpusets'.

There are several proposals to solve this:

1) Travel the cpuset hierarchy to find the largest relax_domain_level
   in rebuild_sched_domains(). But cpuset avoids hierarchy travelling
   when top_cpuset.sched_load_balance is set.

2) Remember the largest relax_domain_level when we update a cpuset's
   sched_load_balance, sched_relax_domain_level and cpus. This should
   work, but seems a bit tricky and a bit ugly. (As this patch shows)

3) Don't treat this as a bug, but document this behavior.


Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 cpuset.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

--- linux-mm.orig/kernel/cpuset.c	2008-07-17 15:02:12.000000000 +0800
+++ linux-mm/kernel/cpuset.c	2008-07-17 15:01:18.000000000 +0800
@@ -69,6 +69,14 @@ int number_of_cpusets __read_mostly;
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
+/*
+ * Tracks # of cpusets in each relax domain level. This is to avoid
+ * travelling the cpuset hierachy in rebuild_sched_domains()
+ * when top_cpuset.sched_load_balance == 1.
+ */
+static unsigned int __cpusets_rd_lv[SD_LV_MAX+1];
+static unsigned int *cpusets_rd_lv = __cpusets_rd_lv + 1;
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -594,6 +602,14 @@ static void rebuild_sched_domains(void)
 			update_domain_attr(dattr, &top_cpuset);
 		}
 		*doms = top_cpuset.cpus_allowed;
+
+		for (i = SD_LV_MAX - 1; i >= 0; i--) {
+			if (cpusets_rd_lv[i] && dattr) {
+				dattr->relax_domain_level = i;
+				break;
+			}
+		}
+
 		goto rebuild;
 	}
 
@@ -807,6 +823,7 @@ static int update_cpumask(struct cpuset 
 	struct cpuset trialcs;
 	int retval;
 	int is_load_balanced;
+	int cpus_empty_changed;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
 	if (cs == &top_cpuset)
@@ -839,11 +856,20 @@ static int update_cpumask(struct cpuset 
 		return 0;
 
 	is_load_balanced = is_sched_load_balance(&trialcs);
+	cpus_empty_changed = (cpus_empty(cs->cpus_allowed) !=
+			      cpus_empty(trialcs.cpus_allowed));
 
 	mutex_lock(&callback_mutex);
 	cs->cpus_allowed = trialcs.cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
+	if (is_load_balanced && cpus_empty_changed) {
+		if (cpus_empty(cs->cpus_allowed))
+			cpusets_rd_lv[cs->relax_domain_level]--;
+		else
+			cpusets_rd_lv[cs->relax_domain_level]++;
+	}
+
 	/*
 	 * Scan tasks in the cpuset, and update the cpumasks of any
 	 * that need an update.
@@ -1074,12 +1100,19 @@ int current_cpuset_is_being_rebound(void
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
+	int need_rebuild = (!cpus_empty(cs->cpus_allowed) &&
+			    is_sched_load_balance(cs));
+
 	if (val < -1 || val >= SD_LV_MAX)
 		return -EINVAL;
 
 	if (val != cs->relax_domain_level) {
+		if (need_rebuild) {
+			cpusets_rd_lv[cs->relax_domain_level]--;
+			cpusets_rd_lv[val]++;
+		}
 		cs->relax_domain_level = val;
-		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+		if (need_rebuild)
 			rebuild_sched_domains();
 	}
 
@@ -1120,8 +1153,13 @@ static int update_flag(cpuset_flagbits_t
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
-	if (cpus_nonempty && balance_flag_changed)
+	if (cpus_nonempty && balance_flag_changed) {
+		if (is_sched_load_balance(cs))
+			cpusets_rd_lv[cs->relax_domain_level]++;
+		else
+			cpusets_rd_lv[cs->relax_domain_level]--;
 		rebuild_sched_domains();
+	}
 
 	return 0;
 }
@@ -1856,6 +1894,7 @@ static void scan_for_empty_cpusets(const
 	struct list_head queue;
 	struct cgroup *cont;
 	nodemask_t oldmems;
+	cpumask_t oldcpus;
 
 	INIT_LIST_HEAD(&queue);
 
@@ -1876,6 +1915,7 @@ static void scan_for_empty_cpusets(const
 			continue;
 
 		oldmems = cp->mems_allowed;
+		oldcpus = cp->cpus_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -1884,6 +1924,12 @@ static void scan_for_empty_cpusets(const
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
 
+		if (is_sched_load_balance(cp)) {
+			if (cpus_empty(cp->cpus_allowed) &&
+			    !cpus_empty(oldcpus))
+				cpusets_rd_lv[cp->relax_domain_level]--;
+		}
+
 		/* Move tasks from the empty cpuset to a parent */
 		if (cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
