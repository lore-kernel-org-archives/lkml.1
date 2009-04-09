Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZDIFkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZDIFkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761388AbZDIFhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:37:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761133AbZDIFhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:37:50 -0400
Date: Wed, 08 Apr 2009 22:37:40 -0700 (PDT)
Message-Id: <20090408.223740.87522039.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/12]: sparc64: Refactor MDESC cpu scanning code using an
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
 arch/sparc/include/asm/mdesc.h |    1 +
 arch/sparc/kernel/mdesc.c      |  146 ++++++++++++++++++++++++----------------
 2 files changed, 90 insertions(+), 57 deletions(-)

diff --git a/arch/sparc/include/asm/mdesc.h b/arch/sparc/include/asm/mdesc.h
index 1acc727..8f8a520 100644
--- a/arch/sparc/include/asm/mdesc.h
+++ b/arch/sparc/include/asm/mdesc.h
@@ -72,6 +72,7 @@ struct mdesc_notifier_client {
 extern void mdesc_register_notifier(struct mdesc_notifier_client *client);
 
 extern void mdesc_fill_in_cpu_data(cpumask_t mask);
+extern void mdesc_populate_present_mask(cpumask_t *mask);
 
 extern void sun4v_mdesc_init(void);
 
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index f0e6ed2..f50af3f 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -574,7 +574,7 @@ static void __init report_platform_properties(void)
 	mdesc_release(hp);
 }
 
-static void __devinit fill_in_one_cache(cpuinfo_sparc *c,
+static void __cpuinit fill_in_one_cache(cpuinfo_sparc *c,
 					struct mdesc_handle *hp,
 					u64 mp)
 {
@@ -619,8 +619,7 @@ static void __devinit fill_in_one_cache(cpuinfo_sparc *c,
 	}
 }
 
-static void __devinit mark_core_ids(struct mdesc_handle *hp, u64 mp,
-				    int core_id)
+static void __cpuinit mark_core_ids(struct mdesc_handle *hp, u64 mp, int core_id)
 {
 	u64 a;
 
@@ -653,7 +652,7 @@ static void __devinit mark_core_ids(struct mdesc_handle *hp, u64 mp,
 	}
 }
 
-static void __devinit set_core_ids(struct mdesc_handle *hp)
+static void __cpuinit set_core_ids(struct mdesc_handle *hp)
 {
 	int idx;
 	u64 mp;
@@ -678,8 +677,7 @@ static void __devinit set_core_ids(struct mdesc_handle *hp)
 	}
 }
 
-static void __devinit mark_proc_ids(struct mdesc_handle *hp, u64 mp,
-				    int proc_id)
+static void __cpuinit mark_proc_ids(struct mdesc_handle *hp, u64 mp, int proc_id)
 {
 	u64 a;
 
@@ -698,8 +696,7 @@ static void __devinit mark_proc_ids(struct mdesc_handle *hp, u64 mp,
 	}
 }
 
-static void __devinit __set_proc_ids(struct mdesc_handle *hp,
-				     const char *exec_unit_name)
+static void __cpuinit __set_proc_ids(struct mdesc_handle *hp, const char *exec_unit_name)
 {
 	int idx;
 	u64 mp;
@@ -720,13 +717,13 @@ static void __devinit __set_proc_ids(struct mdesc_handle *hp,
 	}
 }
 
-static void __devinit set_proc_ids(struct mdesc_handle *hp)
+static void __cpuinit set_proc_ids(struct mdesc_handle *hp)
 {
 	__set_proc_ids(hp, "exec_unit");
 	__set_proc_ids(hp, "exec-unit");
 }
 
-static void __devinit get_one_mondo_bits(const u64 *p, unsigned int *mask,
+static void __cpuinit get_one_mondo_bits(const u64 *p, unsigned int *mask,
 					 unsigned char def)
 {
 	u64 val;
@@ -745,7 +742,7 @@ use_default:
 	*mask = ((1U << def) * 64U) - 1U;
 }
 
-static void __devinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
+static void __cpuinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 				     struct trap_per_cpu *tb)
 {
 	const u64 *val;
@@ -763,23 +760,15 @@ static void __devinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 	get_one_mondo_bits(val, &tb->nonresum_qmask, 2);
 }
 
-void __cpuinit mdesc_fill_in_cpu_data(cpumask_t mask)
+static void * __cpuinit mdesc_iterate_over_cpus(void *(*func)(struct mdesc_handle *, u64, int, void *), void *arg, cpumask_t *mask)
 {
 	struct mdesc_handle *hp = mdesc_grab();
+	void *ret = NULL;
 	u64 mp;
 
-	ncpus_probed = 0;
 	mdesc_for_each_node_by_name(hp, mp, "cpu") {
 		const u64 *id = mdesc_get_property(hp, mp, "id", NULL);
-		const u64 *cfreq = mdesc_get_property(hp, mp, "clock-frequency", NULL);
-		struct trap_per_cpu *tb;
-		cpuinfo_sparc *c;
-		int cpuid;
-		u64 a;
-
-		ncpus_probed++;
-
-		cpuid = *id;
+		int cpuid = *id;
 
 #ifdef CONFIG_SMP
 		if (cpuid >= NR_CPUS) {
@@ -788,62 +777,105 @@ void __cpuinit mdesc_fill_in_cpu_data(cpumask_t mask)
 			       cpuid, NR_CPUS);
 			continue;
 		}
-		if (!cpu_isset(cpuid, mask))
-			continue;
-#else
-		/* On uniprocessor we only want the values for the
-		 * real physical cpu the kernel booted onto, however
-		 * cpu_data() only has one entry at index 0.
-		 */
-		if (cpuid != real_hard_smp_processor_id())
+		if (!cpu_isset(cpuid, *mask))
 			continue;
-		cpuid = 0;
 #endif
 
-		c = &cpu_data(cpuid);
-		c->clock_tick = *cfreq;
+		ret = func(hp, mp, cpuid, arg);
+		if (ret)
+			goto out;
+	}
+out:
+	mdesc_release(hp);
+	return ret;
+}
 
-		tb = &trap_block[cpuid];
-		get_mondo_data(hp, mp, tb);
+static void * __cpuinit record_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid, void *arg)
+{
+	ncpus_probed++;
+#ifdef CONFIG_SMP
+	set_cpu_present(cpuid, true);
+#endif
+	return NULL;
+}
 
-		mdesc_for_each_arc(a, hp, mp, MDESC_ARC_TYPE_FWD) {
-			u64 j, t = mdesc_arc_target(hp, a);
-			const char *t_name;
+void __cpuinit mdesc_populate_present_mask(cpumask_t *mask)
+{
+	if (tlb_type != hypervisor)
+		return;
 
-			t_name = mdesc_node_name(hp, t);
-			if (!strcmp(t_name, "cache")) {
-				fill_in_one_cache(c, hp, t);
-				continue;
-			}
+	ncpus_probed = 0;
+	mdesc_iterate_over_cpus(record_one_cpu, NULL, mask);
+}
 
-			mdesc_for_each_arc(j, hp, t, MDESC_ARC_TYPE_FWD) {
-				u64 n = mdesc_arc_target(hp, j);
-				const char *n_name;
+static void * __cpuinit fill_in_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid, void *arg)
+{
+	const u64 *cfreq = mdesc_get_property(hp, mp, "clock-frequency", NULL);
+	struct trap_per_cpu *tb;
+	cpuinfo_sparc *c;
+	u64 a;
 
-				n_name = mdesc_node_name(hp, n);
-				if (!strcmp(n_name, "cache"))
-					fill_in_one_cache(c, hp, n);
-			}
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
+	c = &cpu_data(cpuid);
+	c->clock_tick = *cfreq;
+
+	tb = &trap_block[cpuid];
+	get_mondo_data(hp, mp, tb);
+
+	mdesc_for_each_arc(a, hp, mp, MDESC_ARC_TYPE_FWD) {
+		u64 j, t = mdesc_arc_target(hp, a);
+		const char *t_name;
+
+		t_name = mdesc_node_name(hp, t);
+		if (!strcmp(t_name, "cache")) {
+			fill_in_one_cache(c, hp, t);
+			continue;
 		}
 
-#ifdef CONFIG_SMP
-		cpu_set(cpuid, cpu_present_map);
-#endif
+		mdesc_for_each_arc(j, hp, t, MDESC_ARC_TYPE_FWD) {
+			u64 n = mdesc_arc_target(hp, j);
+			const char *n_name;
 
-		c->core_id = 0;
-		c->proc_id = -1;
+			n_name = mdesc_node_name(hp, n);
+			if (!strcmp(n_name, "cache"))
+				fill_in_one_cache(c, hp, n);
+		}
 	}
 
+	c->core_id = 0;
+	c->proc_id = -1;
+
+	return NULL;
+}
+
+void __cpuinit mdesc_fill_in_cpu_data(cpumask_t mask)
+{
+	struct mdesc_handle *hp;
+
+	mdesc_populate_present_mask(&mask);
+	mdesc_iterate_over_cpus(fill_in_one_cpu, NULL, &mask);
+
 #ifdef CONFIG_SMP
 	sparc64_multi_core = 1;
 #endif
 
+	hp = mdesc_grab();
+
 	set_core_ids(hp);
 	set_proc_ids(hp);
 
-	smp_fill_in_sib_core_maps();
-
 	mdesc_release(hp);
+
+	smp_fill_in_sib_core_maps();
 }
 
 static ssize_t mdesc_read(struct file *file, char __user *buf,
-- 
1.6.2.2

