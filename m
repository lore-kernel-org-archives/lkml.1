Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbZEFJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbZEFJ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbZEFJ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:57:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:41116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZEFJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:57:56 -0400
Subject: [RFC][git-pull -tip] x86: cpu_debug and cpufeature patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090503090908.GA23183@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam>
	 <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
	 <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam>
	 <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam>
	 <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam>
	 <20090503090908.GA23183@elte.hu>
Content-Type: text/plain
Date: Wed, 06 May 2009 15:27:21 +0530
Message-Id: <1241603841.3322.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 11:09 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > We can use cpu_has tests for unknown processors but 'cpu model' is 
> > accurate and cover all range.
> > 
> > cpu_has does not cover following registers:
> > 1. platform
> > 2. poweron
> > 3. control
> > 4. bios
> > 5. freq
> > 6. cache
> > 7. misc
> > 8. base
> > 9. ver
> > 10. conf
> 
> Firstly these should be added to cpufeatures.h.
> 
> Then add cpu_has_xxx() accessors need to be added for them and 
> during CPU init they have to be properly set, via two methods:
> 
>  - via CPUID (where this is possible+specified in docs)
>  - or via "later than CPU version X" checks
> 
> Your cpu-model table is equivalent to an explicitly enumerated CPU 
> version check, but this breaks every time a new CPU comes out. 
> 
> "Later than" or CPUID based feature bits are a lot more future-proof 
> - we only have to add support for new _features_ (and quirks, 
> occasionally), and dont have to maintain that full table of specific 
> models to specific features mapping tables.
> 

I add some cpufeatures for review, I am still adding rest of them.

The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
  Ingo Molnar (1):
        Merge branch 'irq/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (6):
      x86: cpu_debug.c avoid storing cpu_descriptors locally
      x86: cpu_debug update Kconfig entry
      x86: cpu_debug.c remove unwanted header files
      x86: Add cpufeature for Processor Name
      x86: Add cpufeatures for Advanced Power Management
      x86: Add cpufeature for Microcode update

 arch/x86/Kconfig                  |   11 ++++++++-
 arch/x86/include/asm/cpufeature.h |   21 ++++++++++++++----
 arch/x86/include/asm/processor.h  |    1 -
 arch/x86/kernel/cpu/Makefile      |    2 +-
 arch/x86/kernel/cpu/amd.c         |    9 --------
 arch/x86/kernel/cpu/common.c      |   16 +++++++++++++-
 arch/x86/kernel/cpu/cpu_debug.c   |   42 +++++++++++++++++-------------------
 arch/x86/kernel/cpu/intel.c       |   14 ------------
 arch/x86/kernel/cpu/powerflags.c  |   20 -----------------
 arch/x86/kernel/cpu/proc.c        |   14 ------------
 arch/x86/kernel/microcode_amd.c   |    3 ++
 arch/x86/kernel/microcode_intel.c |    3 ++
 12 files changed, 68 insertions(+), 88 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/powerflags.c

Complete diff:
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4395f4f..213cbca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -951,7 +951,16 @@ config X86_CPU_DEBUG
 	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
 	---help---
 	  If you select this option, this will provide various x86 CPUs
-	  information through debugfs.
+	  information through debugfs. Any user can read these file but writing
+	  needs root privilege.
+
+	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
+	  automatically (like usual drivers). You will need to load it manually
+	  (or add it to list of modules loaded during boot).
+
+	  2. You need debugfs, if you want to mount debugfs automatically
+	  append this line in /etc/fstab:
+	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
 
 choice
 	prompt "High Memory Support"
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..64aebdd 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -76,7 +76,6 @@
 #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
 #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
@@ -153,8 +152,10 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -163,12 +164,22 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx */
+#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
+#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
+#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
+#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
+#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
+#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
-extern const char * const x86_power_flags[32];
 
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0b2fab0..deabe4a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -90,7 +90,6 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	int			x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	int			x86_power;
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..b43fcbb 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ CFLAGS_REMOVE_common.o = -pg
 endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= proc.o capflags.o common.o
 obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..2c1931f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,15 +333,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
-	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	}
-
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a86769e..9d71629 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -360,6 +360,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
+	set_cpu_cap(c, X86_FEATURE_PNAME);
 
 	/*
 	 * Intel chips right-justify this string for some dumb reason;
@@ -575,8 +576,21 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
+		c->x86_capability[9] = cpuid_edx(0x80000007);
 
+	/*
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
+	 *
+	 * It is also reliable across cores and sockets. (but not across
+	 * cabinets - we turn it off in that case explicitly.)
+	 */
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+		sched_clock_stable = 1;
+	}
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..fe38763 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,16 +6,12 @@
  * For licencing details see kernel-base/COPYING
  */
 
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -26,7 +22,6 @@
 #include <asm/cpu_debug.h>
 #include <asm/paravirt.h>
 #include <asm/system.h>
-#include <asm/traps.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 
@@ -34,7 +29,6 @@ static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(unsigned, cpu_modelflag);
 static DEFINE_PER_CPU(int, cpu_priv_count);
-static DEFINE_PER_CPU(unsigned, cpu_model);
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
@@ -227,7 +221,7 @@ static struct cpu_debug_range cpu_amd_range[] = {
 
 
 /* Intel */
-static int get_intel_modelflag(unsigned model)
+static unsigned get_intel_modelflag(unsigned model)
 {
 	int flag;
 
@@ -279,7 +273,7 @@ static int get_intel_modelflag(unsigned model)
 }
 
 /* AMD */
-static int get_amd_modelflag(unsigned model)
+static unsigned get_amd_modelflag(unsigned model)
 {
 	int flag;
 
@@ -310,18 +304,18 @@ static int get_amd_modelflag(unsigned model)
 	return flag;
 }
 
-static int get_cpu_modelflag(unsigned cpu)
+static unsigned get_cpu_flag(struct cpuinfo_x86 *cpui)
 {
-	int flag;
+	unsigned flag;
 
-	flag = per_cpu(cpu_model, cpu);
+	flag = (cpui->x86 << 8) | cpui->x86_model;
 
-	switch (flag >> 16) {
+	switch (cpui->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		flag = get_intel_modelflag(flag);
 		break;
 	case X86_VENDOR_AMD:
-		flag = get_amd_modelflag(flag & 0xffff);
+		flag = get_amd_modelflag(flag);
 		break;
 	default:
 		flag = CPU_NONE;
@@ -333,9 +327,12 @@ static int get_cpu_modelflag(unsigned cpu)
 
 static int get_cpu_range_count(unsigned cpu)
 {
+	struct cpuinfo_x86 *cpui;
 	int index;
 
-	switch (per_cpu(cpu_model, cpu) >> 16) {
+	cpui = &cpu_data(cpu);
+
+	switch (cpui->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		index = ARRAY_SIZE(cpu_intel_range);
 		break;
@@ -352,7 +349,8 @@ static int get_cpu_range_count(unsigned cpu)
 
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
-	unsigned vendor, modelflag;
+	struct cpuinfo_x86 *cpui;
+	unsigned modelflag;
 	int i, index;
 
 	/* Standard Registers should be always valid */
@@ -360,11 +358,11 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 		return 1;
 
 	modelflag = per_cpu(cpu_modelflag, cpu);
-	vendor = per_cpu(cpu_model, cpu) >> 16;
 	index = get_cpu_range_count(cpu);
+	cpui = &cpu_data(cpu);
 
 	for (i = 0; i < index; i++) {
-		switch (vendor) {
+		switch (cpui->x86_vendor) {
 		case X86_VENDOR_INTEL:
 			if ((cpu_intel_range[i].model & modelflag) &&
 			    (cpu_intel_range[i].flag & flag))
@@ -385,11 +383,14 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
+	struct cpuinfo_x86 *cpui;
 	unsigned modelflag;
 
 	modelflag = per_cpu(cpu_modelflag, cpu);
+	cpui = &cpu_data(cpu);
 	*max = 0;
-	switch (per_cpu(cpu_model, cpu) >> 16) {
+
+	switch (cpui->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		if ((cpu_intel_range[index].model & modelflag) &&
 		    (cpu_intel_range[index].flag & flag)) {
@@ -850,10 +851,7 @@ static int cpu_init_cpu(void)
 		cpui = &cpu_data(cpu);
 		if (!cpu_has(cpui, X86_FEATURE_MSR))
 			continue;
-		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
-					   (cpui->x86 << 8) |
-					   (cpui->x86_model));
-		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
+		per_cpu(cpu_modelflag, cpu) = get_cpu_flag(cpui);
 
 		sprintf(cpu_dir, "cpu%d", cpu);
 		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dac7bd..361e7e5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,20 +61,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
-	 *
-	 * It is also reliable across cores and sockets. (but not across
-	 * cabinets - we turn it off in that case explicitly.)
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
-		sched_clock_stable = 1;
-	}
-
-	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
 	 * " Page with PAT set to WC while associated MTRR is UC
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
deleted file mode 100644
index 5abbea2..0000000
--- a/arch/x86/kernel/cpu/powerflags.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Strings for the various x86 power flags
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..523bf39 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -121,20 +121,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 #endif
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
 	seq_printf(m, "\n\n");
 
 	return 0;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..4f6002d 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -141,6 +141,9 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	if (mc_header->patch_id <= rev)
 		return 0;
 
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	return 1;
 }
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..2fcaa58 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -168,6 +168,9 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		return -1;
 	}
 
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {


