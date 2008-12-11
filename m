Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYLKL3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYLKL3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYLKL2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:28:19 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55204 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754953AbYLKL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:28:11 -0500
Message-Id: <20081211112806.873424000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 11 Dec 2008 03:28:08 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
References: <20081211112806.499831000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=fix-cpu_mask_to_apicid_and.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix potential problem.

In determining the destination apicid, there are usually three cpumasks
that are considered: the incoming cpumask arg, cfg->domain and the
cpu_online_mask.  Since we are just introducing the cpu_mask_to_apicid_and
function, make sure it includes the cpu_online_mask in it's evaluation.

Based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git/cpus4096
+ git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
There are two io_apic.c functions that did not previously use the
cpu_online_mask:  setup_IO_APIC_irq and msi_compose_msg.  Both of these
simply used cpu_mask_to_apicid(cfg->domain && TARGET_CPUS) though I'm not
sure why you would want to set a destination apic id for an offline cpu?
Numaq is the only arch that can potentially return a TARGET_CPUS set that
includes offlined cpus.  (Is this an error?)
---
 arch/x86/include/asm/bigsmp/apic.h            |    4 +-
 arch/x86/include/asm/es7000/apic.h            |   40 +++++++++++---------------
 arch/x86/include/asm/mach-default/mach_apic.h |    3 +
 arch/x86/include/asm/summit/apic.h            |   30 +++++++++++--------
 arch/x86/kernel/genapic_flat_64.c             |    4 +-
 arch/x86/kernel/genx2apic_cluster.c           |    4 +-
 arch/x86/kernel/genx2apic_phys.c              |    4 +-
 arch/x86/kernel/genx2apic_uv_x.c              |    4 +-
 8 files changed, 52 insertions(+), 41 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/include/asm/bigsmp/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/bigsmp/apic.h
@@ -138,7 +138,9 @@ static inline unsigned int cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_any_and(cpumask, andmask);
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
 	if (cpu < nr_cpu_ids)
 		return cpu_to_logical_apicid(cpu);
 
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/es7000/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/es7000/apic.h
@@ -214,51 +214,47 @@ static inline unsigned int cpu_mask_to_a
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
 	int num_bits_set;
-	int num_bits_set2;
 	int cpus_found = 0;
 	int cpu;
-	int apicid = 0;
+	int apicid = cpu_to_logical_apicid(0);
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return apicid;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
 
 	num_bits_set = cpumask_weight(cpumask);
-	num_bits_set2 = cpumask_weight(andmask);
-	num_bits_set = min(num_bits_set, num_bits_set2);
 	/* Return id to all */
-	if (num_bits_set >= nr_cpu_ids)
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-		return 0xFF;
-#else
-		return cpu_to_logical_apicid(0);
-#endif
+	if (num_bits_set == NR_CPUS)
+		goto exit;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = cpumask_first_and(cpumask, andmask);
+	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
-
 	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask) &&
-		    cpumask_test_cpu(cpu, andmask)) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)) {
-				printk(KERN_WARNING
-					"%s: Not a valid mask!\n", __func__);
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-				return 0xFF;
-#else
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n", __func__);
 				return cpu_to_logical_apicid(0);
-#endif
 			}
 			apicid = new_apicid;
 			cpus_found++;
 		}
 		cpu++;
 	}
+exit:
+	free_cpumask_var(cpumask);
 	return apicid;
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/mach-default/mach_apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/mach-default/mach_apic.h
@@ -72,8 +72,9 @@ static inline unsigned int cpu_mask_to_a
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
+	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
 
-	return (unsigned int)(mask1 & mask2);
+	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
 static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/summit/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/summit/apic.h
@@ -170,35 +170,37 @@ static inline unsigned int cpu_mask_to_a
 	return apicid;
 }
 
-static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
 	int num_bits_set;
-	int num_bits_set2;
 	int cpus_found = 0;
 	int cpu;
-	int apicid = 0;
+	int apicid = 0xFF;
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return (int) 0xFF;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
 
 	num_bits_set = cpumask_weight(cpumask);
-	num_bits_set2 = cpumask_weight(andmask);
-	num_bits_set = min(num_bits_set, num_bits_set2);
 	/* Return id to all */
-	if (num_bits_set >= nr_cpu_ids)
-		return 0xFF;
+	if (num_bits_set == nr_cpu_ids)
+		goto exit;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = cpumask_first_and(cpumask, andmask);
+	cpu = cpumask_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask)
-		    && cpumask_test_cpu(cpu, andmask)) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)) {
-				printk(KERN_WARNING
-					"%s: Not a valid mask!\n", __func__);
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n", __func__);
 				return 0xFF;
 			}
 			apicid = apicid | new_apicid;
@@ -206,6 +208,8 @@ static inline unsigned int cpu_mask_to_a
 		}
 		cpu++;
 	}
+exit:
+	free_cpumask_var(cpumask);
 	return apicid;
 }
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genapic_flat_64.c
@@ -276,7 +276,9 @@ physflat_cpu_mask_to_apicid_and(const st
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_any_and(cpumask, andmask);
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_cluster.c
@@ -133,7 +133,9 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_any_and(cpumask, andmask);
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_phys.c
@@ -132,7 +132,9 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_any_and(cpumask, andmask);
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;
--- linux-2.6-for-ingo.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6-for-ingo/arch/x86/kernel/genx2apic_uv_x.c
@@ -188,7 +188,9 @@ static unsigned int uv_cpu_mask_to_apici
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = cpumask_any_and(cpumask, andmask);
+	for_each_cpu_and(cpu, cpumask, andmask)
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
 	if (cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	return BAD_APICID;

