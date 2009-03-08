Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbZCHHrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbZCHHrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 03:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZCHHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 03:47:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:51973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZCHHrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 03:47:31 -0400
Message-ID: <49B377D2.8030108@kernel.org>
Date: Sat, 07 Mar 2009 23:46:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove smp_apply_quirks()/smp_checks()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup to make 64 bit don't compile those related code

those code is only applied to intel pentium and amd k7 32 bit cpus.
move those check to intel_init()/amd_init() for 32bit
so 64 bit will not include those code

also change to use cpu_index check to see if need emit warning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/amd.c   |   52 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c |   25 ++++++++++++++
 arch/x86/kernel/smpboot.c   |   78 --------------------------------------------
 3 files changed, 77 insertions(+), 78 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -5,6 +5,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -141,6 +142,55 @@ static void __cpuinit init_amd_k6(struct
 	}
 }
 
+static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	/* calling is from identify_secondary_cpu() ? */
+	if (c->cpu_index == boot_cpu_id)
+		return;
+
+	/*
+	 * Certain Athlons might work (for various values of 'work') in SMP
+	 * but they are not certified as MP capable.
+	 */
+	/* Athlon 660/661 is valid. */
+	if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
+	    (c->x86_mask == 1)))
+		goto valid_k7;
+
+	/* Duron 670 is valid */
+	if ((c->x86_model == 7) && (c->x86_mask == 0))
+		goto valid_k7;
+
+	/*
+	 * Athlon 662, Duron 671, and Athlon >model 7 have capability
+	 * bit. It's worth noting that the A5 stepping (662) of some
+	 * Athlon XP's have the MP bit set.
+	 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
+	 * more.
+	 */
+	if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
+	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
+	     (c->x86_model > 7))
+		if (cpu_has_mp)
+			goto valid_k7;
+
+	/* If we get here, not a certified SMP capable AMD system. */
+
+	/*
+	 * Don't taint if we are running SMP kernel on a single non-MP
+	 * approved Athlon
+	 */
+	WARN_ONCE(1, "WARNING: This combination of AMD"
+		"processors is not suitable for SMP.\n");
+	if (!test_taint(TAINT_UNSAFE_SMP))
+		add_taint(TAINT_UNSAFE_SMP);
+
+valid_k7:
+	;
+#endif
+}
+
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -175,6 +225,8 @@ static void __cpuinit init_amd_k7(struct
 	}
 
 	set_cpu_cap(c, X86_FEATURE_K7);
+
+	amd_k7_smp_check(c);
 }
 #endif
 
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -14,6 +14,7 @@
 #include <asm/uaccess.h>
 #include <asm/ds.h>
 #include <asm/bugs.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/topology.h>
@@ -139,6 +140,28 @@ static void __cpuinit trap_init_f00f_bug
 }
 #endif
 
+static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	/* calling is from identify_secondary_cpu() ? */
+	if (c->cpu_index == boot_cpu_id)
+		return;
+
+	/*
+	 * Mask B, Pentium, but not Pentium MMX
+	 */
+	if (c->x86 == 5 &&
+	    c->x86_mask >= 1 && c->x86_mask <= 4 &&
+	    c->x86_model <= 3) {
+		/*
+		 * Remember we have B step Pentia with bugs
+		 */
+		WARN_ONCE(1, "WARNING: SMP operation may be unreliable"
+				    "with B stepping processors.\n");
+	}
+#endif
+}
+
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
@@ -215,6 +238,8 @@ static void __cpuinit intel_workarounds(
 #ifdef CONFIG_X86_NUMAQ
 	numaq_tsc_disable();
 #endif
+
+	intel_smp_check(c);
 }
 #else
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -114,10 +114,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
-
-/* Set if we find a B stepping CPU */
-static int __cpuinitdata smp_b_stepping;
-
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
 
 /* which logical CPUs are on which nodes */
@@ -271,8 +267,6 @@ static void __cpuinit smp_callin(void)
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
-static int __cpuinitdata unsafe_smp;
-
 /*
  * Activate a secondary processor.
  */
@@ -340,76 +334,6 @@ notrace static void __cpuinit start_seco
 	cpu_idle();
 }
 
-static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
-{
-	/*
-	 * Mask B, Pentium, but not Pentium MMX
-	 */
-	if (c->x86_vendor == X86_VENDOR_INTEL &&
-	    c->x86 == 5 &&
-	    c->x86_mask >= 1 && c->x86_mask <= 4 &&
-	    c->x86_model <= 3)
-		/*
-		 * Remember we have B step Pentia with bugs
-		 */
-		smp_b_stepping = 1;
-
-	/*
-	 * Certain Athlons might work (for various values of 'work') in SMP
-	 * but they are not certified as MP capable.
-	 */
-	if ((c->x86_vendor == X86_VENDOR_AMD) && (c->x86 == 6)) {
-
-		if (num_possible_cpus() == 1)
-			goto valid_k7;
-
-		/* Athlon 660/661 is valid. */
-		if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
-		    (c->x86_mask == 1)))
-			goto valid_k7;
-
-		/* Duron 670 is valid */
-		if ((c->x86_model == 7) && (c->x86_mask == 0))
-			goto valid_k7;
-
-		/*
-		 * Athlon 662, Duron 671, and Athlon >model 7 have capability
-		 * bit. It's worth noting that the A5 stepping (662) of some
-		 * Athlon XP's have the MP bit set.
-		 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
-		 * more.
-		 */
-		if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
-		    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
-		     (c->x86_model > 7))
-			if (cpu_has_mp)
-				goto valid_k7;
-
-		/* If we get here, not a certified SMP capable AMD system. */
-		unsafe_smp = 1;
-	}
-
-valid_k7:
-	;
-}
-
-static void __cpuinit smp_checks(void)
-{
-	if (smp_b_stepping)
-		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
-				    "with B stepping processors.\n");
-
-	/*
-	 * Don't taint if we are running SMP kernel on a single non-MP
-	 * approved Athlon
-	 */
-	if (unsafe_smp && num_online_cpus() > 1) {
-		printk(KERN_INFO "WARNING: This combination of AMD"
-			"processors is not suitable for SMP.\n");
-		add_taint(TAINT_UNSAFE_SMP);
-	}
-}
-
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
@@ -423,7 +347,6 @@ void __cpuinit smp_store_cpu_info(int id
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);
-	smp_apply_quirks(c);
 }
 
 
@@ -1198,7 +1121,6 @@ void __init native_smp_cpus_done(unsigne
 	pr_debug("Boot done.\n");
 
 	impress_friends();
-	smp_checks();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
 #endif
