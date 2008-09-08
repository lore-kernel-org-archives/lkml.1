Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYIHBAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYIHBAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYIHA7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:51963 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYIHA7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CxtNTVujRgcRUUUwbXVq9GeNspuhPjrITJ8hWQ+OQLU0ht1TCZfMzp/Hh/OjVGsefA
         CWjh1lLyf4xkcgTFL1JFqJxXwacGTwzxvJ1pHCmriUXKZN6FCBNsElLWeL+fDLoB5F9F
         /w0v2IHgeWXdKtR3YLWVHEPdg8DwyMIPE21LY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 6/9] x86: make amd_64 have 32 bit code
Date: Sun,  7 Sep 2008 17:58:55 -0700
Message-Id: <1220835538-18280-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/amd_64.c |  259 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 247 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 1d83601..32e7352 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -16,7 +16,171 @@
 
 #include "cpu.h"
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_X86_32
+/*
+ *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
+ *	misexecution of code under Linux. Owners of such processors should
+ *	contact AMD for precise details and a CPU swap.
+ *
+ *	See	http://www.multimania.com/poulot/k6bug.html
+ *		http://www.amd.com/K6/k6docs/revgd.html
+ *
+ *	The following test is erm.. interesting. AMD neglected to up
+ *	the chip setting when fixing the bug but they also tweaked some
+ *	performance at the same time..
+ */
+
+extern void vide(void);
+__asm__(".align 4\nvide: ret");
+
+static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
+{
+/*
+ * General Systems BIOSen alias the cpu frequency registers
+ * of the Elan at 0x000df000. Unfortuantly, one of the Linux
+ * drivers subsequently pokes it, and changes the CPU speed.
+ * Workaround : Remove the unneeded alias.
+ */
+#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
+#define CBAR_ENB	(0x80000000)
+#define CBAR_KEY	(0X000000CB)
+	if (c->x86_model == 9 || c->x86_model == 10) {
+		if (inl (CBAR) & CBAR_ENB)
+			outl (0 | CBAR_KEY, CBAR);
+	}
+}
+
+
+static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
+{
+	u32 l, h;
+	int mbytes = num_physpages >> (20-PAGE_SHIFT);
+
+	if (c->x86_model < 6) {
+		/* Based on AMD doc 20734R - June 2000 */
+		if (c->x86_model == 0) {
+			clear_cpu_cap(c, X86_FEATURE_APIC);
+			set_cpu_cap(c, X86_FEATURE_PGE);
+		}
+		return;
+	}
+
+	if (c->x86_model == 6 && c->x86_mask == 1) {
+		const int K6_BUG_LOOP = 1000000;
+		int n;
+		void (*f_vide)(void);
+		unsigned long d, d2;
+
+		printk(KERN_INFO "AMD K6 stepping B detected - ");
+
+		/*
+		 * It looks like AMD fixed the 2.6.2 bug and improved indirect
+		 * calls at the same time.
+		 */
+
+		n = K6_BUG_LOOP;
+		f_vide = vide;
+		rdtscl(d);
+		while (n--)
+			f_vide();
+		rdtscl(d2);
+		d = d2-d;
+
+		if (d > 20*K6_BUG_LOOP)
+			printk("system stability may be impaired when more than 32 MB are used.\n");
+		else
+			printk("probably OK (after B9730xxxx).\n");
+		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
+	}
+
+	/* K6 with old style WHCR */
+	if (c->x86_model < 8 ||
+	   (c->x86_model == 8 && c->x86_mask < 8)) {
+		/* We can only write allocate on the low 508Mb */
+		if (mbytes > 508)
+			mbytes = 508;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0x0000FFFF) == 0) {
+			unsigned long flags;
+			l = (1<<0)|((mbytes/4)<<1);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+		return;
+	}
+
+	if ((c->x86_model == 8 && c->x86_mask > 7) ||
+	     c->x86_model == 9 || c->x86_model == 13) {
+		/* The more serious chips .. */
+
+		if (mbytes > 4092)
+			mbytes = 4092;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0xFFFF0000) == 0) {
+			unsigned long flags;
+			l = ((mbytes>>2)<<22)|(1<<16);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+
+		return;
+	}
+
+	if (c->x86_model == 10) {
+		/* AMD Geode LX is model 10 */
+		/* placeholder for any needed mods */
+		return;
+	}
+}
+
+static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
+{
+	u32 l, h;
+
+	/*
+	 * Bit 15 of Athlon specific MSR 15, needs to be 0
+	 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	 * If the BIOS didn't enable it already, enable it here.
+	 */
+	if (c->x86_model >= 6 && c->x86_model <= 10) {
+		if (!cpu_has(c, X86_FEATURE_XMM)) {
+			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			rdmsr(MSR_K7_HWCR, l, h);
+			l &= ~0x00008000;
+			wrmsr(MSR_K7_HWCR, l, h);
+			set_cpu_cap(c, X86_FEATURE_XMM);
+		}
+	}
+
+	/*
+	 * It's been determined by AMD that Athlons since model 8 stepping 1
+	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
+	 * As per AMD technical note 27212 0.2
+	 */
+	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+		rdmsr(MSR_K7_CLK_CTL, l, h);
+		if ((l & 0xfff00000) != 0x20000000) {
+			printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
+				((l & 0x000fffff)|0x20000000));
+			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
+		}
+	}
+
+	set_cpu_cap(c, X86_FEATURE_K7);
+}
+#endif
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
@@ -41,7 +205,7 @@ static int __cpuinit nearby_node(int apicid)
  */
 static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_HT
 	unsigned bits;
 
 	bits = c->x86_coreid_bits;
@@ -55,7 +219,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 
 static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
 	unsigned apicid = hard_smp_processor_id();
@@ -91,7 +255,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 
 static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_HT
 	unsigned bits, ecx;
 
 	/* Multi core CPU? */
@@ -112,7 +276,6 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 	}
 
 	c->x86_coreid_bits = bits;
-
 #endif
 }
 
@@ -124,15 +287,21 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1<<8))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+#ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
+#else
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86 == 5)
+		if (c->x86_model == 13 || c->x86_model == 9 ||
+		    (c->x86_model == 8 && c->x86_mask >= 8))
+			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
+#endif
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
-	unsigned level;
-
 #ifdef CONFIG_SMP
-	unsigned long value;
+	unsigned long long value;
 
 	/*
 	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
@@ -142,26 +311,55 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
 	if (c->x86 == 0xf) {
-		rdmsrl(MSR_K8_HWCR, value);
+		rdmsrl(MSR_K7_HWCR, value);
 		value |= 1 << 6;
-		wrmsrl(MSR_K8_HWCR, value);
+		wrmsrl(MSR_K7_HWCR, value);
 	}
 #endif
 
 	early_init_amd(c);
 
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
 	clear_cpu_cap(c, 0*32+31);
 
+#ifdef CONFIG_X86_64
 	/* On C+ stepping K8 rep microcode works well for copy/memset */
 	if (c->x86 == 0xf) {
+		u32 level;
+
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
+
+	/*
+	 *	FIXME: We should handle the K5 here. Set up the write
+	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
+	 *	no bus pipeline)
+	 */
+
+	switch (c->x86) {
+	case 4:
+		init_amd_k5(c);
+		break;
+	case 5:
+		init_amd_k6(c);
+		break;
+	case 6: /* An Athlon/Duron */
+		init_amd_k7(c);
+		break;
+	}
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6)
+		clear_cpu_cap(c, X86_FEATURE_MCE);
+#endif
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
@@ -176,6 +374,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			break;
 		}
 	}
+
 	display_cacheinfo(c);
 
 	/* Multi core CPU? */
@@ -184,6 +383,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		srat_detect_node(c);
 	}
 
+#ifdef CONFIG_X86_32
+	detect_ht(c);
+#endif
+
 	if (c->extended_cpuid_level >= 0x80000006) {
 		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
 			num_cache_leaves = 4;
@@ -199,6 +402,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
+#ifdef CONFIG_X86_64
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
 		if (c == &boot_cpu_data)
@@ -225,11 +429,42 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			set_memory_4k((unsigned long)__va(tseg), 1);
 		}
 	}
+#endif
+}
+
+#ifdef CONFIG_X86_32
+static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+{
+	/* AMD errata T13 (order #21922) */
+	if ((c->x86 == 6)) {
+		if (c->x86_model == 3 && c->x86_mask == 0)	/* Duron Rev A0 */
+			size = 64;
+		if (c->x86_model == 4 &&
+		    (c->x86_mask == 0 || c->x86_mask == 1))	/* Tbird rev A1/A2 */
+			size = 256;
+	}
+	return size;
 }
+#endif
 
 static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
+#ifdef CONFIG_X86_32
+	.c_models = {
+		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
+		  {
+			  [3] = "486 DX/2",
+			  [7] = "486 DX/2-WB",
+			  [8] = "486 DX/4",
+			  [9] = "486 DX/4-WB",
+			  [14] = "Am5x86-WT",
+			  [15] = "Am5x86-WB"
+		  }
+		},
+	},
+	.c_size_cache	= amd_size_cache,
+#endif
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
 	.c_x86_vendor	= X86_VENDOR_AMD,
-- 
1.5.4.5

