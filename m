Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYB0W0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYB0W0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYB0W0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:26:25 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:42930 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYB0W0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:26:23 -0500
Message-Id: <20080227222542.056473000@chello.nl>
References: <20080227222103.673194000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 27 Feb 2008 23:21:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 1/4] sched: remove isolcpus
Content-Disposition: inline; filename=sched-remove-isol.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu isolation doesn't offer anything over cpusets, hence remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6217,24 +6217,6 @@ cpu_attach_domain(struct sched_domain *s
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
@@ -6856,7 +6838,7 @@ static int arch_init_sched_domains(const
 	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
-	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+	*doms_cur = *cpu_map;
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
 
@@ -6917,7 +6899,7 @@ void partition_sched_domains(int ndoms_n
 	if (doms_new == NULL) {
 		ndoms_new = 1;
 		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		doms_new[0] = cpu_online_map;
 	}
 
 	/* Destroy deleted domains */
@@ -7076,7 +7058,7 @@ void __init sched_init_smp(void)
 
 	get_online_cpus();
 	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
+	non_isolated_cpus = cpu_possible_map;
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	put_online_cpus();

--

