Return-Path: <linux-kernel-owner+w=401wt.eu-S1765761AbXGWUUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765761AbXGWUUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764901AbXGWUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:20:12 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42705 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764450AbXGWUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:20:10 -0400
Date: Mon, 23 Jul 2007 13:07:21 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 6/10] x86_64: store core id bits in cpuinfo_x86
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231307.21739.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi said it looks good. but dont know if it is in his tree or not

[PATCH 6/10] x86_64: store core id bits in cpuinfo_x86

We need to store core id bits to cpuinfo_x86 in early_identify_cpu. So we
use it to create acpiid_to_node array in k8topolgy.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

 arch/x86_64/kernel/setup.c     |   72 +++++++++++++++++++++++++++--------------
 include/asm-x86_64/processor.h |    1
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 33ef718..24e6a52 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -499,18 +505,7 @@ static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
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
@@ -546,6 +541,34 @@ static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
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
@@ -768,6 +791,7 @@ struct cpu_model_info {
 void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 {
 	u32 tfms;
+	u32 xlvl;
 
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
@@ -778,6 +802,7 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 	c->x86_clflush_size = 64;
 	c->x86_cache_alignment = c->x86_clflush_size;
 	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
 	c->extended_cpuid_level = 0;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
@@ -814,18 +839,6 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
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
@@ -846,6 +859,23 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
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
diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index efc87a5..a5ac309 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -63,6 +63,7 @@ struct cpuinfo_x86 {
 	int	x86_tlbsize;	/* number of 4K pages in DTLB/ITLB combined(in pages)*/
         __u8    x86_virt_bits, x86_phys_bits;
 	__u8	x86_max_cores;	/* cpuid returned max cores value */
+	__u8	x86_coreid_bits; /* cpuid returned core id bits */
         __u32   x86_power; 	
 	__u32   extended_cpuid_level;	/* Max extended CPUID function supported */
 	unsigned long loops_per_jiffy;
