Return-Path: <linux-kernel-owner+w=401wt.eu-S1762496AbZDIFkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762496AbZDIFkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbZDIFhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58075
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760591AbZDIFhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:48 -0400
Date: Wed, 08 Apr 2009 22:37:38 -0700 (PDT)
Message-Id: <20090408.223738.63750701.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/12]: sparc64: Refactor OBP cpu scanning code using an
 iterator.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/prom.h |    1 +
 arch/sparc/kernel/prom_64.c   |  235 ++++++++++++++++++++++-------------------
 2 files changed, 127 insertions(+), 109 deletions(-)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 900d447..1b15212 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -86,6 +86,7 @@ extern int of_node_to_nid(struct device_node *dp);
 #endif
 
 extern void prom_build_devicetree(void);
+extern void of_populate_present_mask(void);
 
 /* Dummy ref counting routines - to be implemented later */
 static inline struct device_node *of_node_get(struct device_node *node)
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index ca55c70..04b518d 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -374,75 +374,26 @@ static const char *get_mid_prop(void)
 	return (tlb_type == spitfire ? "upa-portid" : "portid");
 }
 
-struct device_node *of_find_node_by_cpuid(int cpuid)
-{
-	struct device_node *dp;
-	const char *mid_prop = get_mid_prop();
-
-	for_each_node_by_type(dp, "cpu") {
-		int id = of_getintprop_default(dp, mid_prop, -1);
-		const char *this_mid_prop = mid_prop;
-
-		if (id < 0) {
-			this_mid_prop = "cpuid";
-			id = of_getintprop_default(dp, this_mid_prop, -1);
-		}
-
-		if (id < 0) {
-			prom_printf("OF: Serious problem, cpu lacks "
-				    "%s property", this_mid_prop);
-			prom_halt();
-		}
-		if (cpuid == id)
-			return dp;
-	}
-	return NULL;
-}
-
-void __init of_fill_in_cpu_data(void)
+static void *of_iterate_over_cpus(void *(*func)(struct device_node *, int, void *), void *arg)
 {
 	struct device_node *dp;
 	const char *mid_prop;
 
-	if (tlb_type == hypervisor)
-		return;
-
 	mid_prop = get_mid_prop();
-	ncpus_probed = 0;
 	for_each_node_by_type(dp, "cpu") {
 		int cpuid = of_getintprop_default(dp, mid_prop, -1);
 		const char *this_mid_prop = mid_prop;
-		struct device_node *portid_parent;
-		int portid = -1;
+		void *ret;
 
-		portid_parent = NULL;
 		if (cpuid < 0) {
 			this_mid_prop = "cpuid";
 			cpuid = of_getintprop_default(dp, this_mid_prop, -1);
-			if (cpuid >= 0) {
-				int limit = 2;
-
-				portid_parent = dp;
-				while (limit--) {
-					portid_parent = portid_parent->parent;
-					if (!portid_parent)
-						break;
-					portid = of_getintprop_default(portid_parent,
-								       "portid", -1);
-					if (portid >= 0)
-						break;
-				}
-			}
 		}
-
 		if (cpuid < 0) {
 			prom_printf("OF: Serious problem, cpu lacks "
 				    "%s property", this_mid_prop);
 			prom_halt();
 		}
-
-		ncpus_probed++;
-
 #ifdef CONFIG_SMP
 		if (cpuid >= NR_CPUS) {
 			printk(KERN_WARNING "Ignoring CPU %d which is "
@@ -450,79 +401,145 @@ void __init of_fill_in_cpu_data(void)
 			       cpuid, NR_CPUS);
 			continue;
 		}
-#else
-		/* On uniprocessor we only want the values for the
-		 * real physical cpu the kernel booted onto, however
-		 * cpu_data() only has one entry at index 0.
-		 */
-		if (cpuid != real_hard_smp_processor_id())
-			continue;
-		cpuid = 0;
 #endif
+		ret = func(dp, cpuid, arg);
+		if (ret)
+			return ret;
+	}
+	return NULL;
+}
 
-		cpu_data(cpuid).clock_tick =
-			of_getintprop_default(dp, "clock-frequency", 0);
-
-		if (portid_parent) {
-			cpu_data(cpuid).dcache_size =
-				of_getintprop_default(dp, "l1-dcache-size",
-						      16 * 1024);
-			cpu_data(cpuid).dcache_line_size =
-				of_getintprop_default(dp, "l1-dcache-line-size",
-						      32);
-			cpu_data(cpuid).icache_size =
-				of_getintprop_default(dp, "l1-icache-size",
-						      8 * 1024);
-			cpu_data(cpuid).icache_line_size =
-				of_getintprop_default(dp, "l1-icache-line-size",
-						      32);
-			cpu_data(cpuid).ecache_size =
-				of_getintprop_default(dp, "l2-cache-size", 0);
-			cpu_data(cpuid).ecache_line_size =
-				of_getintprop_default(dp, "l2-cache-line-size", 0);
-			if (!cpu_data(cpuid).ecache_size ||
-			    !cpu_data(cpuid).ecache_line_size) {
-				cpu_data(cpuid).ecache_size =
-					of_getintprop_default(portid_parent,
-							      "l2-cache-size",
-							      (4 * 1024 * 1024));
-				cpu_data(cpuid).ecache_line_size =
-					of_getintprop_default(portid_parent,
-							      "l2-cache-line-size", 64);
-			}
-
-			cpu_data(cpuid).core_id = portid + 1;
-			cpu_data(cpuid).proc_id = portid;
+static void *check_cpu_node(struct device_node *dp, int cpuid, void *arg)
+{
+	int id = (int) (long) arg;
+
+	if (id == cpuid)
+		return dp;
+	return NULL;
+}
+
+struct device_node *of_find_node_by_cpuid(int cpuid)
+{
+	return of_iterate_over_cpus(check_cpu_node, (void *) (long) cpuid);
+}
+
+static void *record_one_cpu(struct device_node *dp, int cpuid, void *arg)
+{
+	ncpus_probed++;
 #ifdef CONFIG_SMP
-			sparc64_multi_core = 1;
+	set_cpu_present(cpuid, true);
+	set_cpu_possible(cpuid, true);
 #endif
-		} else {
-			cpu_data(cpuid).dcache_size =
-				of_getintprop_default(dp, "dcache-size", 16 * 1024);
-			cpu_data(cpuid).dcache_line_size =
-				of_getintprop_default(dp, "dcache-line-size", 32);
+	return NULL;
+}
+
+void __init of_populate_present_mask(void)
+{
+	if (tlb_type == hypervisor)
+		return;
+
+	ncpus_probed = 0;
+	of_iterate_over_cpus(record_one_cpu, NULL);
+}
 
-			cpu_data(cpuid).icache_size =
-				of_getintprop_default(dp, "icache-size", 16 * 1024);
-			cpu_data(cpuid).icache_line_size =
-				of_getintprop_default(dp, "icache-line-size", 32);
+static void *fill_in_one_cpu(struct device_node *dp, int cpuid, void *arg)
+{
+	struct device_node *portid_parent = NULL;
+	int portid = -1;
+
+	if (of_find_property(dp, "cpuid", NULL)) {
+		int limit = 2;
+
+		portid_parent = dp;
+		while (limit--) {
+			portid_parent = portid_parent->parent;
+			if (!portid_parent)
+				break;
+			portid = of_getintprop_default(portid_parent,
+						       "portid", -1);
+			if (portid >= 0)
+				break;
+		}
+	}
 
+#ifndef CONFIG_SMP
+	/* On uniprocessor we only want the values for the
+	 * real physical cpu the kernel booted onto, however
+	 * cpu_data() only has one entry at index 0.
+	 */
+	if (cpuid != real_hard_smp_processor_id())
+		return NULL;
+	cpuid = 0;
+#endif
+
+	cpu_data(cpuid).clock_tick =
+		of_getintprop_default(dp, "clock-frequency", 0);
+
+	if (portid_parent) {
+		cpu_data(cpuid).dcache_size =
+			of_getintprop_default(dp, "l1-dcache-size",
+					      16 * 1024);
+		cpu_data(cpuid).dcache_line_size =
+			of_getintprop_default(dp, "l1-dcache-line-size",
+					      32);
+		cpu_data(cpuid).icache_size =
+			of_getintprop_default(dp, "l1-icache-size",
+					      8 * 1024);
+		cpu_data(cpuid).icache_line_size =
+			of_getintprop_default(dp, "l1-icache-line-size",
+					      32);
+		cpu_data(cpuid).ecache_size =
+			of_getintprop_default(dp, "l2-cache-size", 0);
+		cpu_data(cpuid).ecache_line_size =
+			of_getintprop_default(dp, "l2-cache-line-size", 0);
+		if (!cpu_data(cpuid).ecache_size ||
+		    !cpu_data(cpuid).ecache_line_size) {
 			cpu_data(cpuid).ecache_size =
-				of_getintprop_default(dp, "ecache-size",
+				of_getintprop_default(portid_parent,
+						      "l2-cache-size",
 						      (4 * 1024 * 1024));
 			cpu_data(cpuid).ecache_line_size =
-				of_getintprop_default(dp, "ecache-line-size", 64);
-
-			cpu_data(cpuid).core_id = 0;
-			cpu_data(cpuid).proc_id = -1;
+				of_getintprop_default(portid_parent,
+						      "l2-cache-line-size", 64);
 		}
 
+		cpu_data(cpuid).core_id = portid + 1;
+		cpu_data(cpuid).proc_id = portid;
 #ifdef CONFIG_SMP
-		set_cpu_present(cpuid, true);
-		set_cpu_possible(cpuid, true);
+		sparc64_multi_core = 1;
 #endif
+	} else {
+		cpu_data(cpuid).dcache_size =
+			of_getintprop_default(dp, "dcache-size", 16 * 1024);
+		cpu_data(cpuid).dcache_line_size =
+			of_getintprop_default(dp, "dcache-line-size", 32);
+
+		cpu_data(cpuid).icache_size =
+			of_getintprop_default(dp, "icache-size", 16 * 1024);
+		cpu_data(cpuid).icache_line_size =
+			of_getintprop_default(dp, "icache-line-size", 32);
+
+		cpu_data(cpuid).ecache_size =
+			of_getintprop_default(dp, "ecache-size",
+					      (4 * 1024 * 1024));
+		cpu_data(cpuid).ecache_line_size =
+			of_getintprop_default(dp, "ecache-line-size", 64);
+
+		cpu_data(cpuid).core_id = 0;
+		cpu_data(cpuid).proc_id = -1;
 	}
 
+	return NULL;
+}
+
+void __init of_fill_in_cpu_data(void)
+{
+	if (tlb_type == hypervisor)
+		return;
+
+	of_populate_present_mask();
+	of_iterate_over_cpus(fill_in_one_cpu, NULL);
+
 	smp_fill_in_sib_core_maps();
 }
 
-- 
1.6.2.2

