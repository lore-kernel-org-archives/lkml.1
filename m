Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYE2SRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYE2SRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYE2SRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:17:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39001 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYE2SRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:17:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3500817"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] sched: Give cpusets exclusive control over sched domains (ie remove cpu_isolated_map)
Date: Thu, 29 May 2008 11:17:03 -0700
Message-Id: <1212085023-22284-3-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1212085023-22284-2-git-send-email-maxk@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
 <1212085023-22284-2-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and Peter mentioned several times that cpu_isolated_map was a horrible hack.
So lets get rid of it.

cpu_isolated_map is controlling which CPUs are subject to the scheduler load balancing.
CPUs set in that map are put in the NULL scheduler domain and are excluded from the
load balancing. This functionality is provided in much more flexible and dynamic way by
the cpusets subsystem. Scheduler load balancing can be disabled/enabled either system
wide or per cpuset.

This patch gives cpusets exclusive control over the scheduler domains.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 Documentation/cpusets.txt |    3 +--
 kernel/sched.c            |   34 +++++-----------------------------
 2 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
index ad2bb3b..d8b269a 100644
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -382,8 +382,7 @@ Put simply, it costs less to balance between two smaller sched domains
 than one big one, but doing so means that overloads in one of the
 two domains won't be load balanced to the other one.
 
-By default, there is one sched domain covering all CPUs, except those
-marked isolated using the kernel boot time "isolcpus=" argument.
+By default, there is one sched domain covering all CPUs.
 
 This default load balancing across all CPUs is not well suited for
 the following two situations:
diff --git a/kernel/sched.c b/kernel/sched.c
index 5ebf6a7..e2eb2be 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6206,24 +6206,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 }
 
-/* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
-
-/* Setup the mask of cpus configured for isolated domains */
-static int __init isolated_cpu_setup(char *str)
-{
-	int ints[NR_CPUS], i;
-
-	str = get_options(str, ARRAY_SIZE(ints), ints);
-	cpus_clear(cpu_isolated_map);
-	for (i = 1; i <= ints[0]; i++)
-		if (ints[i] < NR_CPUS)
-			cpu_set(ints[i], cpu_isolated_map);
-	return 1;
-}
-
-__setup("isolcpus=", isolated_cpu_setup);
-
 /*
  * init_sched_build_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
@@ -6850,8 +6832,6 @@ static void free_sched_domains(void)
 
 /*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
- * For now this just excludes isolated cpus, but could be used to
- * exclude other special cases in the future.
  */
 static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
@@ -6862,7 +6842,7 @@ static int arch_init_sched_domains(const cpumask_t *cpu_map)
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
-	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+	*doms_cur = *cpu_map;
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
 
@@ -6923,7 +6903,7 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
 	if (doms_new == NULL) {
 		ndoms_new = 1;
 		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		*doms_new = cpu_online_map;
 	}
 
 	/* Destroy deleted domains */
@@ -7088,19 +7068,15 @@ static int update_sched_domains(struct notifier_block *nfb,
 
 void __init sched_init_smp(void)
 {
-	cpumask_t non_isolated_cpus;
-
 	get_online_cpus();
 	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
-	if (cpus_empty(non_isolated_cpus))
-		cpu_set(smp_processor_id(), non_isolated_cpus);
 	put_online_cpus();
+
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
-	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
+	/* Update init's affinity mask */
+	if (set_cpus_allowed(current, cpu_online_map) < 0)
 		BUG();
 	sched_init_granularity();
 }
-- 
1.5.4.5

