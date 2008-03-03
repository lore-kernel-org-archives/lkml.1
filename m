Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYCCRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYCCRdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbYCCRQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759665AbYCCRQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:37 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 34/52] move sibling functions to common file
Date: Mon,  3 Mar 2008 14:13:02 -0300
Message-Id: <1204564400-17636-35-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-34-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_cpu_sibling_map() and remove_sibling_info() are
equal between architectures, and are now moved to common
file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   88 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   88 -----------------------------------------
 arch/x86/kernel/smpboot_64.c |   89 ------------------------------------------
 3 files changed, 88 insertions(+), 177 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 40a3b56..d774520 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -29,7 +29,95 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
+
+/* representing cpus for which sibling maps can be computed */
+static cpumask_t cpu_sibling_setup_map;
+
+void __cpuinit set_cpu_sibling_map(int cpu)
+{
+	int i;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	cpu_set(cpu, cpu_sibling_setup_map);
+
+	if (smp_num_siblings > 1) {
+		for_each_cpu_mask(i, cpu_sibling_setup_map) {
+			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
+			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
+				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
+				cpu_set(i, per_cpu(cpu_core_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_core_map, i));
+				cpu_set(i, c->llc_shared_map);
+				cpu_set(cpu, cpu_data(i).llc_shared_map);
+			}
+		}
+	} else {
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
+	}
+
+	cpu_set(cpu, c->llc_shared_map);
+
+	if (current_cpu_data.x86_max_cores == 1) {
+		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
+		c->booted_cores = 1;
+		return;
+	}
+
+	for_each_cpu_mask(i, cpu_sibling_setup_map) {
+		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
+		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
+			cpu_set(i, c->llc_shared_map);
+			cpu_set(cpu, cpu_data(i).llc_shared_map);
+		}
+		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
+			cpu_set(i, per_cpu(cpu_core_map, cpu));
+			cpu_set(cpu, per_cpu(cpu_core_map, i));
+			/*
+			 *  Does this new cpu bringup a new core?
+			 */
+			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
+				/*
+				 * for each core in package, increment
+				 * the booted_cores for this new cpu
+				 */
+				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
+					c->booted_cores++;
+				/*
+				 * increment the core count for all
+				 * the other cpus in this package
+				 */
+				if (i != cpu)
+					cpu_data(i).booted_cores++;
+			} else if (i != cpu && !c->booted_cores)
+				c->booted_cores = cpu_data(i).booted_cores;
+		}
+	}
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
+void remove_siblinginfo(int cpu)
+{
+	int sibling;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+		/*/
+		 * last thread sibling in this cpu core going down
+		 */
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
+			cpu_data(sibling).booted_cores--;
+	}
+
+	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
+	cpus_clear(per_cpu(cpu_core_map, cpu));
+	c->phys_proc_id = 0;
+	c->cpu_core_id = 0;
+	cpu_clear(cpu, cpu_sibling_setup_map);
+}
 
 int additional_cpus __initdata = -1;
 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 0fbc981..322f466 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -274,71 +274,6 @@ cpumask_t cpu_coregroup_map(int cpu)
 		return c->llc_shared_map;
 }
 
-/* representing cpus for which sibling maps can be computed */
-static cpumask_t cpu_sibling_setup_map;
-
-void __cpuinit set_cpu_sibling_map(int cpu)
-{
-	int i;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	cpu_set(cpu, cpu_sibling_setup_map);
-
-	if (smp_num_siblings > 1) {
-		for_each_cpu_mask(i, cpu_sibling_setup_map) {
-			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
-			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
-				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
-				cpu_set(i, per_cpu(cpu_core_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_core_map, i));
-				cpu_set(i, c->llc_shared_map);
-				cpu_set(cpu, cpu_data(i).llc_shared_map);
-			}
-		}
-	} else {
-		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
-	}
-
-	cpu_set(cpu, c->llc_shared_map);
-
-	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
-		c->booted_cores = 1;
-		return;
-	}
-
-	for_each_cpu_mask(i, cpu_sibling_setup_map) {
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpu_set(i, c->llc_shared_map);
-			cpu_set(cpu, cpu_data(i).llc_shared_map);
-		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpu_set(i, per_cpu(cpu_core_map, cpu));
-			cpu_set(cpu, per_cpu(cpu_core_map, i));
-			/*
-			 *  Does this new cpu bringup a new core?
-			 */
-			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
-				/*
-				 * for each core in package, increment
-				 * the booted_cores for this new cpu
-				 */
-				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
-					c->booted_cores++;
-				/*
-				 * increment the core count for all
-				 * the other cpus in this package
-				 */
-				if (i != cpu)
-					cpu_data(i).booted_cores++;
-			} else if (i != cpu && !c->booted_cores)
-				c->booted_cores = cpu_data(i).booted_cores;
-		}
-	}
-}
-
 /*
  * Activate a secondary processor.
  */
@@ -1120,29 +1055,6 @@ void __init native_smp_prepare_boot_cpu(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void remove_siblinginfo(int cpu)
-{
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
-		/*/
-		 * last thread sibling in this cpu core going down
-		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
-	}
-			
-	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
-}
-
 int __cpu_disable(void)
 {
 	cpumask_t map = cpu_online_map;
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 20f1c7d..329f9c5 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -225,71 +225,6 @@ cpumask_t cpu_coregroup_map(int cpu)
 		return c->llc_shared_map;
 }
 
-/* representing cpus for which sibling maps can be computed */
-static cpumask_t cpu_sibling_setup_map;
-
-void __cpuinit set_cpu_sibling_map(int cpu)
-{
-	int i;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	cpu_set(cpu, cpu_sibling_setup_map);
-
-	if (smp_num_siblings > 1) {
-		for_each_cpu_mask(i, cpu_sibling_setup_map) {
-			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
-			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
-				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
-				cpu_set(i, per_cpu(cpu_core_map, cpu));
-				cpu_set(cpu, per_cpu(cpu_core_map, i));
-				cpu_set(i, c->llc_shared_map);
-				cpu_set(cpu, cpu_data(i).llc_shared_map);
-			}
-		}
-	} else {
-		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
-	}
-
-	cpu_set(cpu, c->llc_shared_map);
-
-	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
-		c->booted_cores = 1;
-		return;
-	}
-
-	for_each_cpu_mask(i, cpu_sibling_setup_map) {
-		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
-		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpu_set(i, c->llc_shared_map);
-			cpu_set(cpu, cpu_data(i).llc_shared_map);
-		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
-			cpu_set(i, per_cpu(cpu_core_map, cpu));
-			cpu_set(cpu, per_cpu(cpu_core_map, i));
-			/*
-			 *  Does this new cpu bringup a new core?
-			 */
-			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
-				/*
-				 * for each core in package, increment
-				 * the booted_cores for this new cpu
-				 */
-				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
-					c->booted_cores++;
-				/*
-				 * increment the core count for all
-				 * the other cpus in this package
-				 */
-				if (i != cpu)
-					cpu_data(i).booted_cores++;
-			} else if (i != cpu && !c->booted_cores)
-				c->booted_cores = cpu_data(i).booted_cores;
-		}
-	}
-}
-
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
@@ -917,30 +852,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-void remove_siblinginfo(int cpu)
-{
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
-		/*
-		 * last thread sibling in this cpu core going down
-		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
-	}
-			
-	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
-}
-
 static void __ref remove_cpu_from_maps(void)
 {
 	int cpu = smp_processor_id();
-- 
1.5.0.6

