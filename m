Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbYASEck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbYASEck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbYASEcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:32:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:56683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761839AbYASEcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:32:20 -0500
From: Andi Kleen <ak@suse.de>
References: <20080119532.133547000@suse.de>
In-Reply-To: <20080119532.133547000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, jesse.barnes@intel.com,
       andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Fix MTRR check on AMD systems with > 4GB RAM
Message-Id: <20080119043219.40E8214A13@wotan.suse.de>
Date: Sat, 19 Jan 2008 05:32:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Newer AMD systems (since K8RevF) have a magic SYSCFG MSR bit to force WB
on memory beyond 4GB. This is not reflected in the standard MTRR
MSRs, so the MTRR checking routine would get confused and disable
perfectly good RAM beyond 4GB. Implement code for checking that bit.


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mtrr/main.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Index: linux/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux/arch/x86/kernel/cpu/mtrr/main.c
@@ -634,6 +634,37 @@ static int __init disable_mtrr_trim_setu
 early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
 
 #ifdef CONFIG_X86_64
+
+/*
+ * Newer AMD K8s and later CPUs have a special magic MSR way to force WB
+ * for memory >4GB. Check for that here.
+ * Note this won't check if the MTRRs < 4GB where the magic bit doesn't
+ * apply to are wrong, but so far we don't know of any such case in the wild.
+ */
+
+#define Tom2ForceMemTypeWB (1U << 22)
+static __init int amd_special_default_mtrr(void)
+{
+	u32 l, h;
+
+	/* Doesn't apply to memory < 4GB */
+	if (end_pfn <= (0xffffffff >> PAGE_SHIFT))
+		return 0;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return 0;
+	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+		return 0;
+	/* In case some hypervisor doesn't pass SYSCFG through */
+	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
+		return 0;
+	/* Memory between 4GB and top of mem is forced WB by this magic bit.
+	 * Reserved before K8RevF, but should be zero there.
+	 */
+	if (l & Tom2ForceMemTypeWB)
+		return 1;
+	return 0;
+}
+
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
  *
@@ -667,6 +698,9 @@ void __init mtrr_trim_uncached_memory(vo
 			highest_addr = base + size;
 	}
 
+	if (amd_special_default_mtrr())
+		return;
+
 	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
 		printk(KERN_WARNING "***************\n");
 		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
