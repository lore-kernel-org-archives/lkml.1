Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYI2WbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYI2WbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYI2Wau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:30:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYI2Wau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:30:50 -0400
Date: Mon, 29 Sep 2008 18:29:42 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/2] x86: move prefill_possible_map calling early, fix, V2
Message-ID: <20080929182942.68fbb4fb@redhat.com>
In-Reply-To: <20080929182756.4e33b06b@redhat.com>
References: <20080929182756.4e33b06b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

x86: move prefill_possible_map calling early, fix, V2

fix:

arch/x86/kernel/built-in.o: In function `setup_arch':
: undefined reference to `prefill_possible_map'

Fix this by making prefill_possible_map() available even when
CONFIG_HOTPLUG_CPU is not set. The function is needed so that
the number of possible CPUs can be determined.

Tested on uniprocessor machine with CPU hotplug disabled.
>From boot log:
Before: NR_CPUS: 512, nr_cpu_ids: 512, nr_node_ids 1
After: NR_CPUS: 512, nr_cpu_ids: 1, nr_node_ids 1

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---

Index: linux-2.6.26.noarch/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.26.noarch.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.26.noarch/arch/x86/kernel/smpboot.c
@@ -1254,39 +1254,8 @@ void __init native_smp_cpus_done(unsigne
 	check_nmi_watchdog();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void remove_siblinginfo(int cpu)
-{
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
-		/*/
-		 * last thread sibling in this cpu core going down
-		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
-	}
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
-}
-
 static int additional_cpus __initdata = -1;
 
-static __init int setup_additional_cpus(char *s)
-{
-	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
-}
-early_param("additional_cpus", setup_additional_cpus);
-
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1336,6 +1305,37 @@ __init void prefill_possible_map(void)
 	nr_cpu_ids = possible;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void remove_siblinginfo(int cpu)
+{
+	int sibling;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+		/*/
+		 * last thread sibling in this cpu core going down
+		 */
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
+			cpu_data(sibling).booted_cores--;
+	}
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
+	cpus_clear(per_cpu(cpu_core_map, cpu));
+	c->phys_proc_id = 0;
+	c->cpu_core_id = 0;
+	cpu_clear(cpu, cpu_sibling_setup_map);
+}
+
+static __init int setup_additional_cpus(char *s)
+{
+	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
+}
+early_param("additional_cpus", setup_additional_cpus);
+
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
