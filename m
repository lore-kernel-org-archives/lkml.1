Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYETT3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYETT3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYETT24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:28:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYETT2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:28:54 -0400
Date: Tue, 20 May 2008 15:18:12 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
Message-ID: <20080520191812.GB31805@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org> <4832E461.2070503@zytor.com> <20080520151655.GA542@redhat.com> <4833112F.7020402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4833112F.7020402@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:58:07AM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > On Tue, May 20, 2008 at 07:46:57AM -0700, H. Peter Anvin wrote:
 > >  > Dave Jones wrote:
 > >  > > There were no 64bit Transmeta CPUs made (and it'd be something of
 > >  > > a surprise if they started any time soon).   To the best of my knowledge,
 > >  > > no CPU vendor cloned the 80860000 cpuid space claimed by Transmeta.
 > >  > > By removing this code, we can also eliminate calling cpuid 0x80000007 twice.
 > >  > > 
 > >  > > Signed-off-by: Dave Jones <davej@redhat.com>
 > >  > 
 > >  > I'd really like to avoid divergences between the 32-bit and 64-bit code 
 > >  > if they can be avoided at this point.  These codes need to be unified, 
 > >  > not further split.
 > > 
 > > Umm, the 32 bit code has the per-vendor stuff removed from setup.c, and factored
 > > out into per-vendor files in arch/x86/kernel/cpu/  Because the 64bit version
 > > doesn't do that (yet), my removal of this code actually gets us closer to unification.
 > > After my patch, neither of the setup.c files have the Transmeta bits :)
 > > 
 > 
 > *Shrug* ... it seems like pointless churn to code that really needs to 
 > die to me.

Moving along the same direction..  Moving the vendor specific bits out of setup_64.c
into cpu/ would go a long way towards killing of setup64.c.  I took a first pass at doing this
in the diff below. So far I only looked at the AMD specific bits, and haven't done
a complete conversion to cpu_dev style initialisation as done on 32bit, but that
can easily be performed later after moving all the code out into its respective places.
(downside: a bunch of externs in the interim).

comments on this before I go any further?

	Dave

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0c6f81..ef065c1 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -7,6 +7,7 @@ obj-y			+= proc.o feature_names.o
 
 obj-$(CONFIG_X86_32)	+= common.o bugs.o
 obj-$(CONFIG_X86_32)	+= amd.o
+obj-$(CONFIG_X86_64)	+= amd_64.o
 obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
 obj-$(CONFIG_X86_32)	+= transmeta.o
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
new file mode 100644
index 0000000..a0ba1eb
--- /dev/null
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -0,0 +1,252 @@
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/mm.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/apic.h>
+
+#include <asm/numa_64.h>
+#include <asm/mmconfig.h>
+#include <asm/cacheflush.h>
+
+#include <mach_apic.h>
+#include "cpu.h"
+
+extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
+extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
+
+int force_mwait __cpuinitdata;
+
+#ifdef CONFIG_NUMA
+static int __cpuinit nearby_node(int apicid)
+{
+        int i, node;
+
+        for (i = apicid - 1; i >= 0; i--) {
+                node = apicid_to_node[i];
+                if (node != NUMA_NO_NODE && node_online(node))
+                        return node;
+        }
+        for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
+                node = apicid_to_node[i];
+                if (node != NUMA_NO_NODE && node_online(node))
+                        return node;
+        }
+        return first_node(node_online_map); /* Shouldn't happen */
+}
+#endif
+
+static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
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
+	        while ((1 << bits) < c->x86_max_cores)
+	                bits++;
+	}
+
+	c->x86_coreid_bits = bits;
+#endif
+}
+
+#define ENABLE_C1E_MASK         0x18000000
+#define CPUID_PROCESSOR_SIGNATURE       1
+#define CPUID_XFAM              0x0ff00000
+#define CPUID_XFAM_K8           0x00000000
+#define CPUID_XFAM_10H          0x00100000
+#define CPUID_XFAM_11H          0x00200000
+#define CPUID_XMOD              0x000f0000
+#define CPUID_XMOD_REV_F        0x00040000
+
+/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
+static __cpuinit int amd_apic_timer_broken(void)
+{
+        u32 lo, hi, eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+
+        switch (eax & CPUID_XFAM) {
+        case CPUID_XFAM_K8:
+                if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
+                        break;
+        case CPUID_XFAM_10H:
+        case CPUID_XFAM_11H:
+                rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
+                if (lo & ENABLE_C1E_MASK)
+                        return 1;
+                break;
+        default:
+                /* err on the side of caution */
+                return 1;
+        }
+        return 0;
+}
+
+
+void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	early_init_amd_mc(c);
+
+	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
+	if (c->x86_power & (1<<8))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+}
+
+/*
+ * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
+ * Assumes number of cores is a power of two.
+ */
+static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+        unsigned bits;
+#ifdef CONFIG_NUMA
+        int cpu = smp_processor_id();
+        int node = 0;
+        unsigned apicid = hard_smp_processor_id();
+#endif
+        bits = c->x86_coreid_bits;
+
+        /* Low order bits define the core id (index of core in socket) */
+        c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
+        /* Convert the initial APIC ID into the socket ID */
+        c->phys_proc_id = c->initial_apicid >> bits;
+
+#ifdef CONFIG_NUMA
+        node = c->phys_proc_id;
+        if (apicid_to_node[apicid] != NUMA_NO_NODE)
+                node = apicid_to_node[apicid];
+        if (!node_online(node)) {
+                /* Two possibilities here:
+                   - The CPU is missing memory and no node was created.
+                   In that case try picking one from a nearby CPU
+                   - The APIC IDs differ from the HyperTransport node IDs
+                   which the K8 northbridge parsing fills in.
+                   Assume they are all increased by a constant offset,
+                   but in the same order as the HT nodeids.
+                   If that doesn't result in a usable node fall back to the
+                   path for the previous case.  */
+                int ht_nodeid = c->initial_apicid;
+
+                if (ht_nodeid >= 0 &&
+                    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+                        node = apicid_to_node[ht_nodeid];
+                /* Pick a nearby node */
+                if (!node_online(node))
+                        node = nearby_node(apicid);
+        }
+        numa_set_node(cpu, node);
+
+        printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+#endif
+}
+
+
+void __cpuinit init_amd(struct cpuinfo_x86 *c)
+{
+	unsigned level;
+
+#ifdef CONFIG_SMP
+	unsigned long long value;
+
+	/*
+	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
+	 * bit 6 of msr C001_0015
+	 *
+	 * Errata 63 for SH-B3 steppings
+	 * Errata 122 for all steppings (F+ have it disabled by default)
+	 */
+	if (c->x86 == 15) {
+		rdmsrl(MSR_K7_HWCR, value);
+		value |= 1 << 6;
+		wrmsrl(MSR_K7_HWCR, value);
+	}
+#endif
+
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
+	clear_cpu_cap(c, 0*32+31);
+
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	level = cpuid_eax(1);
+	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) ||
+		level >= 0x0f58))
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	if (c->x86 == 0x10 || c->x86 == 0x11)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/* Enable workaround for FXSAVE leak */
+	if (c->x86 >= 6)
+		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
+
+	level = get_model_name(c);
+	if (!level) {
+		switch (c->x86) {
+		case 15:
+			/* Should distinguish Models here, but this is only
+			a fallback anyways. */
+			strcpy(c->x86_model_id, "Hammer");
+			break;
+		}
+	}
+	display_cacheinfo(c);
+
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level >= 0x80000008)
+		amd_detect_cmp(c);
+
+	if (c->extended_cpuid_level >= 0x80000006 &&
+		(cpuid_edx(0x80000006) & 0xf000))
+		num_cache_leaves = 4;
+	else
+		num_cache_leaves = 3;
+
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
+		set_cpu_cap(c, X86_FEATURE_K8);
+
+	/* MFENCE stops RDTSC speculation */
+	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg();
+
+	if (amd_apic_timer_broken())
+		disable_apic_timer = 1;
+
+	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&
+		(tseg >> PMD_SHIFT) < (max_pfn_mapped >> (PMD_SHIFT-PAGE_SHIFT)))
+		set_memory_4k((unsigned long)__va(tseg), 1);
+	}
+}
+
+
+static struct cpu_dev amd_cpu_dev __cpuinitdata = {
+	.c_vendor	= "AMD",
+	.c_ident	= { "AuthenticAMD" },
+	.c_early_init	= early_init_amd,
+	.c_init		= init_amd,
+};
+
+cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index ff62838..0414a0c 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -96,8 +96,6 @@ int bootloader_type;
 
 unsigned long saved_video_mode;
 
-int force_mwait __cpuinitdata;
-
 /*
  * Early DMI memory
  */
@@ -526,7 +524,7 @@ void __init setup_arch(char **cmdline_p)
 	check_enable_amd_mmconf_dmi();
 }
 
-static int __cpuinit get_model_name(struct cpuinfo_x86 *c)
+int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 
@@ -542,7 +540,7 @@ static int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 }
 
 
-static void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, eax, ebx, ecx, edx;
 
@@ -574,227 +572,6 @@ static void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 	}
 }
 
-#ifdef CONFIG_NUMA
-static int __cpuinit nearby_node(int apicid)
-{
-	int i, node;
-
-	for (i = apicid - 1; i >= 0; i--) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	return first_node(node_online_map); /* Shouldn't happen */
-}
-#endif
-
-/*
- * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
- * Assumes number of cores is a power of two.
- */
-static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits;
-#ifdef CONFIG_NUMA
-	int cpu = smp_processor_id();
-	int node = 0;
-	unsigned apicid = hard_smp_processor_id();
-#endif
-	bits = c->x86_coreid_bits;
-
-	/* Low order bits define the core id (index of core in socket) */
-	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
-	/* Convert the initial APIC ID into the socket ID */
-	c->phys_proc_id = c->initial_apicid >> bits;
-
-#ifdef CONFIG_NUMA
-	node = c->phys_proc_id;
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
-	if (!node_online(node)) {
-		/* Two possibilities here:
-		   - The CPU is missing memory and no node was created.
-		   In that case try picking one from a nearby CPU
-		   - The APIC IDs differ from the HyperTransport node IDs
-		   which the K8 northbridge parsing fills in.
-		   Assume they are all increased by a constant offset,
-		   but in the same order as the HT nodeids.
-		   If that doesn't result in a usable node fall back to the
-		   path for the previous case.  */
-
-		int ht_nodeid = c->initial_apicid;
-
-		if (ht_nodeid >= 0 &&
-		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
-			node = apicid_to_node[ht_nodeid];
-		/* Pick a nearby node */
-		if (!node_online(node))
-			node = nearby_node(apicid);
-	}
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-#endif
-}
-
-static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits, ecx;
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level < 0x80000008)
-		return;
-
-	ecx = cpuid_ecx(0x80000008);
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
-
-	c->x86_coreid_bits = bits;
-
-#endif
-}
-
-#define ENABLE_C1E_MASK		0x18000000
-#define CPUID_PROCESSOR_SIGNATURE	1
-#define CPUID_XFAM		0x0ff00000
-#define CPUID_XFAM_K8		0x00000000
-#define CPUID_XFAM_10H		0x00100000
-#define CPUID_XFAM_11H		0x00200000
-#define CPUID_XMOD		0x000f0000
-#define CPUID_XMOD_REV_F	0x00040000
-
-/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
-static __cpuinit int amd_apic_timer_broken(void)
-{
-	u32 lo, hi, eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
-
-	switch (eax & CPUID_XFAM) {
-	case CPUID_XFAM_K8:
-		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
-			break;
-	case CPUID_XFAM_10H:
-	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
-		if (lo & ENABLE_C1E_MASK)
-			return 1;
-		break;
-	default:
-		/* err on the side of caution */
-		return 1;
-	}
-	return 0;
-}
-
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
-{
-	early_init_amd_mc(c);
-
- 	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
-	if (c->x86_power & (1<<8))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-}
-
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-{
-	unsigned level;
-
-#ifdef CONFIG_SMP
-	unsigned long value;
-
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 15) {
-		rdmsrl(MSR_K8_HWCR, value);
-		value |= 1 << 6;
-		wrmsrl(MSR_K8_HWCR, value);
-	}
-#endif
-
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_cpu_cap(c, 0*32+31);
-
-	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	level = cpuid_eax(1);
-	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) ||
-			     level >= 0x0f58))
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	if (c->x86 == 0x10 || c->x86 == 0x11)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-
-	/* Enable workaround for FXSAVE leak */
-	if (c->x86 >= 6)
-		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
-
-	level = get_model_name(c);
-	if (!level) {
-		switch (c->x86) {
-		case 15:
-			/* Should distinguish Models here, but this is only
-			   a fallback anyways. */
-			strcpy(c->x86_model_id, "Hammer");
-			break;
-		}
-	}
-	display_cacheinfo(c);
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level >= 0x80000008)
-		amd_detect_cmp(c);
-
-	if (c->extended_cpuid_level >= 0x80000006 &&
-		(cpuid_edx(0x80000006) & 0xf000))
-		num_cache_leaves = 4;
-	else
-		num_cache_leaves = 3;
-
-	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
-		set_cpu_cap(c, X86_FEATURE_K8);
-
-	/* MFENCE stops RDTSC speculation */
-	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
-
-	if (c->x86 == 0x10)
-		fam10h_check_enable_mmcfg();
-
-	if (amd_apic_timer_broken())
-		disable_apic_timer = 1;
-
-	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
-		unsigned long long tseg;
-
-		/*
-		 * Split up direct mapping around the TSEG SMM area.
-		 * Don't do it for gbpages because there seems very little
-		 * benefit in doing so.
-		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&
-		(tseg >> PMD_SHIFT) < (max_pfn_mapped >> (PMD_SHIFT-PAGE_SHIFT)))
-			set_memory_4k((unsigned long)__va(tseg), 1);
-	}
-}
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
@@ -978,6 +755,10 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 		c->x86_vendor = X86_VENDOR_UNKNOWN;
 }
 
+// FIXME: Needs to use cpu_vendor_dev_register
+extern void __cpuinit early_init_amd(struct cpuinfo_x86 *c);
+extern void __cpuinit init_amd(struct cpuinfo_x86 *c);
+
 /* Do some early cpuid on the boot CPU to get some parameter that are
    needed before check_bugs. Everything advanced is in identify_cpu
    below. */
-- 
http://www.codemonkey.org.uk
