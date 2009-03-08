Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZCHPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZCHPxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZCHPwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:52:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:34142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZCHPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:52:38 -0400
Date: Sun, 8 Mar 2009 15:51:58 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B377D2.8030108@kernel.org>
References: <49B377D2.8030108@kernel.org>
Subject: [tip:x86/apic] x86: remove smp_apply_quirks()/smp_checks()
Message-ID: <tip-1f442d70c84aa798e243e721eba728a98434cd86@git.kernel.org>
Git-Commit-ID: 1f442d70c84aa798e243e721eba728a98434cd86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:52:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f442d70c84aa798e243e721eba728a98434cd86
Gitweb:     http://git.kernel.org/tip/1f442d70c84aa798e243e721eba728a98434cd86
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Sat, 7 Mar 2009 23:46:26 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 16:22:56 +0100

x86: remove smp_apply_quirks()/smp_checks()

Impact: cleanup and code size reduction on 64-bit

This code is only applied to Intel Pentium and AMD K7 32-bit cpus.

Move those checks to intel_init()/amd_init() for 32-bit
so 64-bit will not build this code.

Also change to use cpu_index check to see if we need to emit warning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49B377D2.8030108@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/amd.c   |   52 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c |   25 ++++++++++++++
 arch/x86/kernel/smpboot.c   |   78 -------------------------------------------
 3 files changed, 77 insertions(+), 78 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 25423a5..f47df59 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -5,6 +5,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -141,6 +142,55 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
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
@@ -175,6 +225,8 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 	}
 
 	set_cpu_cap(c, X86_FEATURE_K7);
+
+	amd_k7_smp_check(c);
 }
 #endif
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 25c559b..191117f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -13,6 +13,7 @@
 #include <asm/uaccess.h>
 #include <asm/ds.h>
 #include <asm/bugs.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/topology.h>
@@ -110,6 +111,28 @@ static void __cpuinit trap_init_f00f_bug(void)
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
@@ -186,6 +209,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_NUMAQ
 	numaq_tsc_disable();
 #endif
+
+	intel_smp_check(c);
 }
 #else
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 249334f..ef7d101 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
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
@@ -340,76 +334,6 @@ notrace static void __cpuinit start_secondary(void *unused)
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
@@ -423,7 +347,6 @@ void __cpuinit smp_store_cpu_info(int id)
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);
-	smp_apply_quirks(c);
 }
 
 
@@ -1193,7 +1116,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	pr_debug("Boot done.\n");
 
 	impress_friends();
-	smp_checks();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
 #endif
