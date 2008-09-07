Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYIGHPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYIGHPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 03:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYIGHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 03:15:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38982 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbYIGHP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 03:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w1lTxX8q2mwgWJkzT1t/jIckQloCrtTzUO5U0yi1BvBqPFo4RM+dNg7jFbE5gyzAfW
         /d7q2cA7cL8HjPirlALP4JP4/M26J95dq4MTcw7cpB+HRD/66FaoMywJP8j52XEfJCBG
         a/grgiQoP7rMFhqUyeniQISVXaH+zunTlYAjc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: cpu make amd.c more like amd_64.c
Date: Sun,  7 Sep 2008 00:15:25 -0700
Message-Id: <1220771725-26763-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. make 32bit have early_init_amd_mc and amd_detect_cmp
2. seperate init_amd_k5/k6/k7 ...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd.c    |  396 ++++++++++++++++++++++++-------------------
 arch/x86/kernel/cpu/amd_64.c |   17 +
 include/asm-x86/processor.h  |    4 
 3 files changed, 236 insertions(+), 181 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -24,8 +24,200 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
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
+
+/*
+ * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
+ * Assumes number of cores is a power of two.
+ */
+static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits;
+
+	bits = c->x86_coreid_bits;
+
+	/* Low order bits define the core id (index of core in socket) */
+	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
+	/* Convert the initial APIC ID into the socket ID */
+	c->phys_proc_id = c->initial_apicid >> bits;
+#endif
+}
+
+static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits, ecx;
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
+#endif
+}
+
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
+	early_init_amd_mc(c);
+
 	if (c->x86_power & (1<<8))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
@@ -37,9 +229,6 @@ static void __cpuinit early_init_amd(str
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
-	u32 l, h;
-	int mbytes = num_physpages >> (20-PAGE_SHIFT);
-
 #ifdef CONFIG_SMP
 	unsigned long long value;
 
@@ -50,7 +239,7 @@ static void __cpuinit init_amd(struct cp
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 15) {
+	if (c->x86 == 0xf) {
 		rdmsrl(MSR_K7_HWCR, value);
 		value |= 1 << 6;
 		wrmsrl(MSR_K7_HWCR, value);
@@ -73,192 +262,55 @@ static void __cpuinit init_amd(struct cp
 
 	switch (c->x86) {
 	case 4:
-		/*
-		 * General Systems BIOSen alias the cpu frequency registers
-		 * of the Elan at 0x000df000. Unfortuantly, one of the Linux
-		 * drivers subsequently pokes it, and changes the CPU speed.
-		 * Workaround : Remove the unneeded alias.
-		 */
-#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
-#define CBAR_ENB	(0x80000000)
-#define CBAR_KEY	(0X000000CB)
-			if (c->x86_model == 9 || c->x86_model == 10) {
-				if (inl (CBAR) & CBAR_ENB)
-					outl (0 | CBAR_KEY, CBAR);
-			}
-			break;
+		init_amd_k5(c);
+		break;
 	case 5:
-			if (c->x86_model < 6) {
-				/* Based on AMD doc 20734R - June 2000 */
-				if (c->x86_model == 0) {
-					clear_cpu_cap(c, X86_FEATURE_APIC);
-					set_cpu_cap(c, X86_FEATURE_PGE);
-				}
-				break;
-			}
-
-			if (c->x86_model == 6 && c->x86_mask == 1) {
-				const int K6_BUG_LOOP = 1000000;
-				int n;
-				void (*f_vide)(void);
-				unsigned long d, d2;
-
-				printk(KERN_INFO "AMD K6 stepping B detected - ");
-
-				/*
-				 * It looks like AMD fixed the 2.6.2 bug and improved indirect
-				 * calls at the same time.
-				 */
-
-				n = K6_BUG_LOOP;
-				f_vide = vide;
-				rdtscl(d);
-				while (n--)
-					f_vide();
-				rdtscl(d2);
-				d = d2-d;
-
-				if (d > 20*K6_BUG_LOOP)
-					printk("system stability may be impaired when more than 32 MB are used.\n");
-				else
-					printk("probably OK (after B9730xxxx).\n");
-				printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
-			}
-
-			/* K6 with old style WHCR */
-			if (c->x86_model < 8 ||
-			   (c->x86_model == 8 && c->x86_mask < 8)) {
-				/* We can only write allocate on the low 508Mb */
-				if (mbytes > 508)
-					mbytes = 508;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0x0000FFFF) == 0) {
-					unsigned long flags;
-					l = (1<<0)|((mbytes/4)<<1);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-				break;
-			}
-
-			if ((c->x86_model == 8 && c->x86_mask > 7) ||
-			     c->x86_model == 9 || c->x86_model == 13) {
-				/* The more serious chips .. */
-
-				if (mbytes > 4092)
-					mbytes = 4092;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0xFFFF0000) == 0) {
-					unsigned long flags;
-					l = ((mbytes>>2)<<22)|(1<<16);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-
-				break;
-			}
-
-			if (c->x86_model == 10) {
-				/* AMD Geode LX is model 10 */
-				/* placeholder for any needed mods */
-				break;
-			}
-			break;
-	case 6: /* An Athlon/Duron */
-
-			/*
-			 * Bit 15 of Athlon specific MSR 15, needs to be 0
-			 * to enable SSE on Palomino/Morgan/Barton CPU's.
-			 * If the BIOS didn't enable it already, enable it here.
-			 */
-			if (c->x86_model >= 6 && c->x86_model <= 10) {
-				if (!cpu_has(c, X86_FEATURE_XMM)) {
-					printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-					rdmsr(MSR_K7_HWCR, l, h);
-					l &= ~0x00008000;
-					wrmsr(MSR_K7_HWCR, l, h);
-					set_cpu_cap(c, X86_FEATURE_XMM);
-				}
-			}
-
-			/*
-			 * It's been determined by AMD that Athlons since model 8 stepping 1
-			 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
-			 * As per AMD technical note 27212 0.2
-			 */
-			if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
-				rdmsr(MSR_K7_CLK_CTL, l, h);
-				if ((l & 0xfff00000) != 0x20000000) {
-					printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
-						((l & 0x000fffff)|0x20000000));
-					wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
-				}
-			}
-			break;
-	}
-
-	switch (c->x86) {
-	case 15:
-	/* Use K8 tuning for Fam10h and Fam11h */
-	case 0x10:
-	case 0x11:
-		set_cpu_cap(c, X86_FEATURE_K8);
+		init_amd_k6(c);
 		break;
-	case 6:
-		set_cpu_cap(c, X86_FEATURE_K7);
+	case 6: /* An Athlon/Duron */
+		init_amd_k7(c);
 		break;
 	}
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6)
+		clear_cpu_cap(c, X86_FEATURE_MCE);
+
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
+	if (!c->x86_model_id[0]) {
+		switch (c->x86) {
+		case 0xf:
+			/* Should distinguish Models here, but this is only
+			   a fallback anyways. */
+			strcpy(c->x86_model_id, "Hammer");
+			break;
+		}
+	}
+
 	display_cacheinfo(c);
 
-	if (cpuid_eax(0x80000000) >= 0x80000008)
-		c->x86_max_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level >= 0x80000008)
+		amd_detect_cmp(c);
 
-#ifdef CONFIG_X86_HT
-	/*
-	 * On a AMD multi core setup the lower bits of the APIC id
-	 * distinguish the cores.
-	 */
-	if (c->x86_max_cores > 1) {
-		int cpu = smp_processor_id();
-		unsigned bits = (cpuid_ecx(0x80000008) >> 12) & 0xf;
-
-		if (bits == 0) {
-			while ((1 << bits) < c->x86_max_cores)
-				bits++;
-		}
-		c->cpu_core_id = c->phys_proc_id & ((1<<bits)-1);
-		c->phys_proc_id >>= bits;
-		printk(KERN_INFO "CPU %d(%d) -> Core %d\n",
-		       cpu, c->x86_max_cores, c->cpu_core_id);
-	}
-#endif
+	detect_ht(c);
 
-	if (cpuid_eax(0x80000000) >= 0x80000006) {
-		if ((c->x86 == 0x10) && (cpuid_edx(0x80000006) & 0xf000))
+	if (c->extended_cpuid_level >= 0x80000006) {
+		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
 	}
 
-	/* K6s reports MCEs but don't actually have all the MSRs */
-	if (c->x86 < 6)
-		clear_cpu_cap(c, X86_FEATURE_MCE);
+	if (c->x86 >= 0xf && c->x86 <= 0x11)
+		set_cpu_cap(c, X86_FEATURE_K8);
 
-	if (cpu_has_xmm2)
+	if (cpu_has_xmm2) {
+		/* MFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+	}
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -174,17 +174,20 @@ static void __cpuinit init_amd(struct cp
 	if (c->extended_cpuid_level >= 0x80000008)
 		amd_detect_cmp(c);
 
-	if (c->extended_cpuid_level >= 0x80000006 &&
-		(cpuid_edx(0x80000006) & 0xf000))
-		num_cache_leaves = 4;
-	else
-		num_cache_leaves = 3;
+	if (c->extended_cpuid_level >= 0x80000006) {
+		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
+			num_cache_leaves = 4;
+		else
+			num_cache_leaves = 3;
+	}
 
 	if (c->x86 >= 0xf && c->x86 <= 0x11)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
-	/* MFENCE stops RDTSC speculation */
-	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+	if (cpu_has_xmm2) {
+		/* MFENCE stops RDTSC speculation */
+		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+	}
 
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
Index: linux-2.6/include/asm-x86/processor.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor.h
+++ linux-2.6/include/asm-x86/processor.h
@@ -76,8 +76,6 @@ struct cpuinfo_x86 {
 	int			 x86_tlbsize;
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
-	/* CPUID returned core id bits: */
-	__u8			x86_coreid_bits;
 #endif
 	/* Max extended CPUID function supported: */
 	__u32			extended_cpuid_level;
@@ -101,6 +99,8 @@ struct cpuinfo_x86 {
 	u16			initial_apicid;
 	u16			x86_clflush_size;
 #ifdef CONFIG_SMP
+	/* CPUID returned core id bits: */
+	__u8			x86_coreid_bits;
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;
 	/* Physical processor id: */
