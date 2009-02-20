Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZBTMgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZBTMgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZBTMgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:36:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZBTMgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:36:42 -0500
Date: Fri, 20 Feb 2009 14:33:28 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220123328.GC24826@redhat.com>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu> <499DE05A.40804@kernel.org> <1235086118.14523.40.camel@vayu> <20090220083528.GB24555@elte.hu> <20090220090912.GA4632@redhat.com> <20090220094123.GJ24555@elte.hu> <20090220105804.GA24826@redhat.com> <20090220110651.GH28581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220110651.GH28581@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:06:51PM +0100, Ingo Molnar wrote:
> > > > If you'll revert my patch it will not be possible to use 
> > > > x2apic in KVM (at least without KVM implementing interrupt 
> > > > remapping which is unneeded otherwise) and x2apic interface is 
> > > > much better for vitalization. Instead of reverting the patch 
> > > > it will be better to add check if x2apic can be used without 
> > > > intr-remmaping (all CPUs belong to cluster 0) or allow 
> > > > enabling of x2apic without IR if running as a guest.
> > > 
> > > yep, that would be required - because your patch can break real 
> > > systems right now. Mind sending me a fix for it?
> > > 
> > > I've applied Yinghai's fix as well, so please base it on latest 
> > > tip:master.
> > > 
> > OK. Will send next week.
> 
> ok, that's too long of a breakage window - i'll revert it then, 
> please send a new version once you have it.
> 
What approach you actually prefer? Enable x2apic without intr-remapping
only when running in KVM, or even if running on real HW but all CPUs are
in cluster 0? If former then below is updated patch (tested only in KVM)
if later then it's definitely for next week :)

From: Gleb Natapov <gleb@redhat.com>
Subject: x86, apic: decouple x2apic from interrupt remapping

Currently x2apic is used only if interrupt remapping can be enabled,
and although there is not real HW that has x2apic but does not have
intr-remapping  the decoupling is useful since we want to emulate x2apic
interface in KVM (it is more vitalization friendly), but we don't want
to emulate intr-remapping just for that. Attached patch enables x2apic
when running in kvm guest even if intr-remapping cannot be enabled.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c3acf90..98b9a0b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -48,6 +48,7 @@
 #include <asm/idle.h>
 #include <asm/mtrr.h>
 #include <asm/smp.h>
+#include <asm/kvm_para.h>
 
 unsigned int num_processors;
 
@@ -1296,10 +1297,44 @@ void enable_x2apic(void)
 	}
 }
 
-void __init enable_IR_x2apic(void)
+static int __init enable_IR(void)
 {
 #ifdef CONFIG_INTR_REMAP
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
+	if (ret) {
+		restore_IO_APIC_setup();
+		return ret;
+	}
+
+	reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+	return 0;
+#else
+	if (!kvm_para_available()) {
+		local_irq_restore(flags);
+		panic("x2apic enabled prior OS handover,"
+				" enable CONFIG_INTR_REMAP");
+	}
+	return -ENODEV;
+#endif
+}
+
+void __init enable_IR_x2apic(void)
+{
 	unsigned long flags;
 
 	if (!cpu_has_x2apic)
@@ -1320,72 +1355,33 @@ void __init enable_IR_x2apic(void)
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
-		local_irq_restore(flags);
-		panic("x2apic enabled by bios. But IR enabling failed");
+	if (enable_IR()) {
+		if (!kvm_para_available()) {
+			if (x2apic_preenabled) {
+				local_irq_restore(flags);
+				panic("x2apic enabled by bios. "
+						"But IR enabling failed");
+			}
+			goto no_x2apic;
+		}
+	} else {
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
+no_x2apic:
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
+	if (x2apic && !x2apic_preenabled)
+		pr_info("Enabled x2apic\n");
 
 	return;
 }
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 70935dd..8f11f6d 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -22,6 +22,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/setup.h>
+#include <asm/kvm_para.h>
 
 extern struct apic apic_flat;
 extern struct apic apic_physflat;
@@ -51,7 +52,7 @@ void __init default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_X2APIC
 	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
-		if (!intr_remapping_enabled)
+		if (!intr_remapping_enabled && !kvm_para_available())
 			apic = &apic_flat;
 	}
 #endif
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
