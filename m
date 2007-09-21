Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbXIUWci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbXIUWci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761894AbXIUWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:01 -0400
Received: from ns.suse.de ([195.135.220.2]:57022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648AbXIUWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:00 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: yhlu.kernel@gmail.com, clameter@sgi.com, ak@suse.de, lenb@kernel.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/50] x86_64: store core id bits in cpuinfo_x8
Message-Id: <20070921223158.EBBD413DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:31:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

We need to store core id bits to cpuinfo_x86 in early_identify_cpu. So we
use it to create acpiid_to_node array in k8topolgy.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/setup.c     |   72 +++++++++++++++++++++++++++--------------
 include/asm-x86_64/processor.h |    1 
 2 files changed, 49 insertions(+), 24 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -499,18 +499,7 @@ static void __init amd_detect_cmp(struct
 	int node = 0;
 	unsigned apicid = hard_smp_processor_id();
 #endif
-	unsigned ecx = cpuid_ecx(0x80000008);
-
-	c->x86_max_cores = (ecx & 0xff) + 1;
-
-	/* CPU telling us the core id bits shift? */
-	bits = (ecx >> 12) & 0xF;
-
-	/* Otherwise recompute */
-	if (bits == 0) {
-		while ((1 << bits) < c->x86_max_cores)
-			bits++;
-	}
+	bits = c->x86_coreid_bits;
 
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->phys_proc_id & ((1 << bits)-1);
@@ -546,6 +535,34 @@ static void __init amd_detect_cmp(struct
 #endif
 }
 
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned bits;
+	unsigned ecx;
+
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level < 0x80000008)
+		return;
+
+	ecx = cpuid_ecx(0x80000008);
+
+	c->x86_max_cores = (ecx & 0xff) + 1;
+
+	/* CPU telling us the core id bits shift? */
+	bits = (ecx >> 12) & 0xF;
+
+	/* Otherwise recompute */
+	if (bits == 0) {
+		while ((1 << bits) < c->x86_max_cores)
+			bits++;
+	}
+
+	c->x86_coreid_bits = bits;
+
+#endif
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
@@ -776,6 +793,7 @@ struct cpu_model_info {
 void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 {
 	u32 tfms;
+	u32 xlvl;
 
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
@@ -786,6 +804,7 @@ void __cpuinit early_identify_cpu(struct
 	c->x86_clflush_size = 64;
 	c->x86_cache_alignment = c->x86_clflush_size;
 	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
 	c->extended_cpuid_level = 0;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
@@ -822,18 +841,6 @@ void __cpuinit early_identify_cpu(struct
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-	u32 xlvl;
-
-	early_identify_cpu(c);
-
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
@@ -854,6 +861,23 @@ void __cpuinit identify_cpu(struct cpuin
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		early_init_amd(c);
+		break;
+	}
+
+}
+
+/*
+ * This does the hard work of actually picking apart the CPU stuff...
+ */
+void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	early_identify_cpu(c);
+
 	init_scattered_cpuid_features(c);
 
 	c->apicid = phys_pkg_id(0);
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -63,6 +63,7 @@ struct cpuinfo_x86 {
 	int	x86_tlbsize;	/* number of 4K pages in DTLB/ITLB combined(in pages)*/
         __u8    x86_virt_bits, x86_phys_bits;
 	__u8	x86_max_cores;	/* cpuid returned max cores value */
+	__u8	x86_coreid_bits; /* cpuid returned core id bits */
         __u32   x86_power; 	
 	__u32   extended_cpuid_level;	/* Max extended CPUID function supported */
 	unsigned long loops_per_jiffy;
