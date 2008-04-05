Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYDEBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYDEBN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYDEBLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45145 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751741AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011101.381954000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:03 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: [PATCH 03/12] cpumask: reduce stack pressure in cpu_coregroup_map
Content-Disposition: inline; filename=cpu_coregroup_map
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Return pointer to requested cpumask_t value for the cpu_coregroup_map()
    functions instead of returning the cpumask_t value on the stack.

    The only uses of these functions are in the sparc and x86 architectures.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# sparc
Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>

# x86
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smpboot.c      |    6 +++---
 include/asm-sparc64/topology.h |    2 +-
 include/asm-x86/topology.h     |    2 +-
 kernel/sched.c                 |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.x86.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.x86/arch/x86/kernel/smpboot.c
@@ -545,7 +545,7 @@ void __cpuinit set_cpu_sibling_map(int c
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
+const cpumask_t *cpu_coregroup_map(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
@@ -553,9 +553,9 @@ cpumask_t cpu_coregroup_map(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
+		return &per_cpu(cpu_core_map, cpu);
 	else
-		return c->llc_shared_map;
+		return &c->llc_shared_map;
 }
 
 /*
--- linux-2.6.x86.orig/include/asm-sparc64/topology.h
+++ linux-2.6.x86/include/asm-sparc64/topology.h
@@ -12,6 +12,6 @@
 
 #include <asm-generic/topology.h>
 
-#define cpu_coregroup_map(cpu)			(cpu_core_map[cpu])
+#define cpu_coregroup_map(cpu)			(&cpu_core_map[cpu])
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */
--- linux-2.6.x86.orig/include/asm-x86/topology.h
+++ linux-2.6.x86/include/asm-x86/topology.h
@@ -201,7 +201,7 @@ static inline void set_mp_bus_to_node(in
 
 #include <asm-generic/topology.h>
 
-extern cpumask_t cpu_coregroup_map(int cpu);
+const cpumask_t *cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -6615,7 +6615,7 @@ cpu_to_phys_group(int cpu, const cpumask
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
-	cpumask_t mask = cpu_coregroup_map(cpu);
+	cpumask_t mask = *cpu_coregroup_map(cpu);
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 #elif defined(CONFIG_SCHED_SMT)
@@ -6849,7 +6849,7 @@ static int build_sched_domains(const cpu
 		p = sd;
 		sd = &per_cpu(core_domains, i);
 		*sd = SD_MC_INIT;
-		sd->span = cpu_coregroup_map(i);
+		sd->span = *cpu_coregroup_map(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -6884,7 +6884,7 @@ static int build_sched_domains(const cpu
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu_mask(i, *cpu_map) {
-		cpumask_t this_core_map = cpu_coregroup_map(i);
+		cpumask_t this_core_map = *cpu_coregroup_map(i);
 		cpus_and(this_core_map, this_core_map, *cpu_map);
 		if (i != first_cpu(this_core_map))
 			continue;

-- 
