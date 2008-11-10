Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYKJS36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYKJS36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYKJS3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:29:47 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48641 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbYKJS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:29:45 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 00:03:26 +0530
Message-ID: <20081110183326.562.37718.stgit@drishya.in.ibm.com>
In-Reply-To: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system utilisation is low and more cpus are idle,
then the process waking up from sleep should prefer to
wakeup an idle cpu from semi-idle cpu package (multi core
package) rather than a completely idle cpu package which
would waste power.

Use the sched_mc balance logic in find_busiest_group() to
nominate a preferred wakeup cpu.

This info can be sored in appropriate sched_domain, but
updating this info in all copies of sched_domain is not
practical.  For now lets try with a per-cpu variable
pointing to a common storage in partition sched domain
attribute.  Global variable may not work in partitioned
sched domain case.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 715028a..8363d02 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -810,6 +810,7 @@ enum sched_domain_level {
 
 struct sched_domain_attr {
 	int relax_domain_level;
+	unsigned int preferred_wakeup_cpu;
 };
 
 #define SD_ATTR_INIT	(struct sched_domain_attr) {	\
diff --git a/kernel/sched.c b/kernel/sched.c
index d910496..16c5e1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1612,6 +1612,21 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+
+/*
+ * Preferred wake up cpu nominated by sched_mc balance that will be used when
+ * most cpus are idle in the system indicating overall very low system
+ * utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP (2).
+ */
+
+DEFINE_PER_CPU(unsigned int *, sched_mc_preferred_wakeup_cpu);
+
+/* Default storage allocation for non-partitioned sched domains */
+unsigned int fallback_preferred_wakeup_cpu;
+
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -3078,6 +3093,7 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
+
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
@@ -3394,6 +3410,10 @@ out_balanced:
 
 	if (this == group_leader && group_leader != group_min) {
 		*imbalance = min_load_per_task;
+		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP)
+			*per_cpu(sched_mc_preferred_wakeup_cpu,
+				 smp_processor_id()) =
+					first_cpu(group_leader->cpumask);
 		return group_min;
 	}
 #endif
@@ -7372,7 +7392,7 @@ static void set_domain_attribute(struct sched_domain *sd,
 static int __build_sched_domains(const cpumask_t *cpu_map,
 				 struct sched_domain_attr *attr)
 {
-	int i;
+	int i, cpu;
 	struct root_domain *rd;
 	SCHED_CPUMASK_DECLARE(allmasks);
 	cpumask_t *tmpmask;
@@ -7472,6 +7492,18 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+		/* Set the preferred wake up CPU */
+		if (attr) {
+			for_each_cpu_mask_nr(cpu, sd->span) {
+				per_cpu(sched_mc_preferred_wakeup_cpu, cpu) =
+					&attr->preferred_wakeup_cpu;
+			}
+		} else {
+			for_each_cpu_mask_nr(cpu, sd->span) {
+				per_cpu(sched_mc_preferred_wakeup_cpu, cpu) =
+					&fallback_preferred_wakeup_cpu;
+			}
+		}
 #endif
 
 #ifdef CONFIG_SCHED_SMT

