Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZBSK7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZBSK7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBSK6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:58:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbZBSK6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:58:50 -0500
Date: Thu, 19 Feb 2009 12:55:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH v2] decouple x2apic from interrupt remapping
Message-ID: <20090219105551.GM26845@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased against latest tip:x86/acpi

Currently x2apic is used only if interrupt remapping can be enabled,
but if all apic ids are smaller then 255 there is no reason to enable
interrupt remapping at all. Although there is not real HW that has
x2apic but does not have IR the decoupling is useful since we want to
emulate x2apic interface in KVM (it is more vitalization friendly),
but we don't want to emulate IR just for that.

According to Intel docs BIOS should pass control to OS in x2apic mode
if there are apics with id > 255 and in xapic otherwise, so the proposed
patch requires IR configuration only if BIOS switched apic to x2apic
mode.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c12823e..d7588a9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1292,10 +1292,33 @@ void enable_x2apic(void)
 	}
 }
 
-void __init enable_IR_x2apic(void)
+static int __init enable_IR(void)
 {
-#ifdef CONFIG_INTR_REMAP
 	int ret;
+
+	ret = dmar_table_init();
+	if (ret) {
+		pr_info("dmar_table_init() failed with %d:\n", ret);
+		return ret;
+	}
+
+	ret = save_mask_IO_APIC_setup();
+	if (ret) {
+		pr_info("Saving IO-APIC state failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = enable_intr_remapping(1);
+	if (ret)
+		return ret;
+
+	reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+	return 0;
+}
+
+void __init enable_IR_x2apic(void)
+{
 	unsigned long flags;
 
 	if (!cpu_has_x2apic)
@@ -1316,72 +1339,33 @@ void __init enable_IR_x2apic(void)
 		return;
 	}
 
-	ret = dmar_table_init();
-	if (ret) {
-		pr_info("dmar_table_init() failed with %d:\n", ret);
-
-		if (x2apic_preenabled)
-			panic("x2apic enabled by bios. But IR enabling failed");
-		else
-			pr_info("Not enabling x2apic,Intr-remapping\n");
-		return;
-	}
-
 	local_irq_save(flags);
 	mask_8259A();
 
-	ret = save_mask_IO_APIC_setup();
-	if (ret) {
-		pr_info("Saving IO-APIC state failed: %d\n", ret);
-		goto end;
-	}
-
-	ret = enable_intr_remapping(1);
-
-	if (ret && x2apic_preenabled) {
+	if (x2apic_preenabled) {
+#ifdef CONFIG_INTR_REMAP
+		if (enable_IR()) {
+			local_irq_restore(flags);
+			panic("x2apic enabled by bios. But IR enabling failed");
+		}
+#else
 		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
+		panic("x2apic enabled prior OS handover,"
+				" enable CONFIG_INTR_REMAP");
+#endif
+		pr_info("Enabled interrupt remapping for x2apic\n");
 	}
 
-	if (ret)
-		goto end_restore;
-
 	if (!x2apic) {
 		x2apic = 1;
 		enable_x2apic();
 	}
 
-end_restore:
-	if (ret)
-		/*
-		 * IR enabling failed
-		 */
-		restore_IO_APIC_setup();
-	else
-		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
-
-end:
 	unmask_8259A();
 	local_irq_restore(flags);
 
-	if (!ret) {
-		if (!x2apic_preenabled)
-			pr_info("Enabled x2apic and interrupt-remapping\n");
-		else
-			pr_info("Enabled Interrupt-remapping\n");
-	} else
-		pr_err("Failed to enable Interrupt-remapping and x2apic\n");
-#else
-	if (!cpu_has_x2apic)
-		return;
-
-	if (x2apic_preenabled)
-		panic("x2apic enabled prior OS handover,"
-		      " enable CONFIG_INTR_REMAP");
-
-	pr_info("Enable CONFIG_INTR_REMAP for enabling intr-remapping "
-		" and x2apic\n");
-#endif
+	if (!x2apic_preenabled)
+		pr_info("Enabled x2apic\n");
 
 	return;
 }
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 70935dd..344a175 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -49,13 +49,6 @@ static struct apic *apic_probe[] __initdata = {
  */
 void __init default_setup_apic_routing(void)
 {
-#ifdef CONFIG_X86_X2APIC
-	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
-		if (!intr_remapping_enabled)
-			apic = &apic_flat;
-	}
-#endif
-
 	if (apic == &apic_flat) {
 		if (max_physical_apicid >= 8)
 			apic = &apic_physflat;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4e39d9a..3f7df23 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -24,7 +24,10 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 static const struct cpumask *x2apic_target_cpus(void)
 {
-	return cpumask_of(0);
+	if (intr_remapping_enabled)
+		return cpumask_of(0);
+	else
+		return cpu_online_mask;
 }
 
 /*
@@ -116,37 +119,46 @@ static int x2apic_apic_id_registered(void)
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
-	int cpu = cpumask_first(cpumask);
+	if (intr_remapping_enabled) {
+		/*
+		 * We're using fixed IRQ delivery, can only return one
+		 * logical APIC ID. May as well be the first.
+		 */
+		int cpu = cpumask_first(cpumask);
 
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
-	else
-		return BAD_APICID;
+		if ((unsigned)cpu < nr_cpu_ids)
+			return per_cpu(x86_cpu_to_logical_apicid, cpu);
+		else
+			return BAD_APICID;
+	} else
+		return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static unsigned int
 x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask)
 {
-	int cpu;
+	if (intr_remapping_enabled) {
+		int cpu;
 
-	/*
-	 * We're using fixed IRQ delivery, can only return one logical APIC ID.
-	 * May as well be the first.
-	 */
-	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
-			break;
-	}
+		/*
+		 * We're using fixed IRQ delivery, can only return one
+		 * logical APIC ID. May as well be the first.
+		 */
+		for_each_cpu_and(cpu, cpumask, andmask) {
+			if (cpumask_test_cpu(cpu, cpu_online_mask))
+				break;
+		}
 
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
+		if (cpu < nr_cpu_ids)
+			return per_cpu(x86_cpu_to_logical_apicid, cpu);
 
-	return BAD_APICID;
+		return BAD_APICID;
+	} else {
+		unsigned long mask1 = cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
+		unsigned long mask2 = cpumask_bits(andmask)[0] & APIC_ALL_CPUS;
+		return mask1 & mask2;
+	}
 }
 
 static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
--
			Gleb.
--
			Gleb.
