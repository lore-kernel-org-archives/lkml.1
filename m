Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957Ab0AUQl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0AUQl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477Ab0AUQl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38415 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0AUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:25 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] x86, cacheinfo: Calculate L3 indexes
Date: Thu, 21 Jan 2010 17:41:33 +0100
Message-Id: <1264092093-13739-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

We need to know the valid L3 indexes interval when disabling them over
/sysfs. Do that when the core is brought online and add boundary checks
to the sysfs .store attribute.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 +++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0ce0e8d..d231c38 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,7 +151,8 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -161,7 +162,8 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 };
 
 unsigned short			num_cache_leaves;
@@ -291,6 +293,29 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+static unsigned int __cpuinit amd_calc_l3_indices(void)
+{
+	/*
+	 * We're called over smp_call_function_single() and therefore
+	 * are on the correct cpu.
+	 */
+	int cpu = smp_processor_id();
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int sc0, sc1, sc2, sc3;
+	u32 val;
+
+	pci_read_config_dword(dev, 0x1C4, &val);
+
+	/* calculate subcache sizes */
+	sc0 = !(val & BIT(0));
+	sc1 = !(val & BIT(4));
+	sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
@@ -306,7 +331,8 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
-	this_leaf->can_disable = 1;
+	this_leaf->can_disable = true;
+	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
 
 static int
@@ -765,7 +791,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 		return -EINVAL;
 
 	/* do not allow writes outside of allowed bits */
-	if (val & ~(SUBCACHE_MASK | SUBCACHE_INDEX))
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
 		return -EINVAL;
 
 	val |= BIT(30);
-- 
1.6.6

