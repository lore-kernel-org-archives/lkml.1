Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYARMCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYARMCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:01:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYARMB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:01:58 -0500
Date: Fri, 18 Jan 2008 13:01:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64
	identity map and kernel text
Message-ID: <20080118120112.GB8583@elte.hu>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com> <20080115221758.GG2665@elte.hu> <20080115232115.GD8903@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115232115.GD8903@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> > ok. So it seems we dont even need all that many special cases, a 
> > "dont write MTRRs" and "use PATs everywhere" rule would just do the 
> > right thing all across?
> 
> Yes. The main thing required is on the lines of Jesse's patch. If the 
> MTRR's def type is not WB, then we need to check if any of the RAM is 
> not covered by MTRR range registers and trim the RAM accordingly.

ok. I've dusted off Jesse's patch (and Andrew's fix to it) and merged it 
to x86.git - see below.

one immediate problem is:

  +#ifdef CONFIG_X86_64

we should do this on 32-bit too.

	Ingo

----------->
Subject: x86, 32-bit: trim memory not covered by wb mtrrs
From: Jesse Barnes <jesse.barnes@intel.com>

On some machines, buggy BIOSes don't properly setup WB MTRRs to cover all
available RAM, meaning the last few megs (or even gigs) of memory will be
marked uncached.  Since Linux tends to allocate from high memory addresses
first, this causes the machine to be unusably slow as soon as the kernel
starts really using memory (i.e.  right around init time).

This patch works around the problem by scanning the MTRRs at boot and
figuring out whether the current end_pfn value (setup by early e820 code)
goes beyond the highest WB MTRR range, and if so, trimming it to match.  A
fairly obnoxious KERN_WARNING is printed too, letting the user know that
not all of their memory is available due to a likely BIOS bug.

Something similar could be done on i386 if needed, but the boot ordering
would be slightly different, since the MTRR code on i386 depends on the
boot_cpu_data structure being setup.

This patch fixes a bug in the last patch that caused the code to run on
non-Intel machines (AMD machines apparently don't need it and it's untested
on other non-Intel machines, so best keep it off).

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Tested-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    6 ++
 arch/x86/kernel/bugs_64.c           |    1 
 arch/x86/kernel/cpu/mtrr/generic.c  |    8 ---
 arch/x86/kernel/cpu/mtrr/if.c       |    8 ---
 arch/x86/kernel/cpu/mtrr/main.c     |   90 ++++++++++++++++++++++++++----------
 arch/x86/kernel/cpu/mtrr/mtrr.h     |    3 +
 arch/x86/kernel/setup_64.c          |    4 +
 include/asm-x86/mtrr.h              |    5 +-
 8 files changed, 86 insertions(+), 39 deletions(-)

Index: linux-x86.q/Documentation/kernel-parameters.txt
===================================================================
--- linux-x86.q.orig/Documentation/kernel-parameters.txt
+++ linux-x86.q/Documentation/kernel-parameters.txt
@@ -562,6 +562,12 @@ and is between 256 and 4096 characters. 
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
+	disable_mtrr_trim [X86-64, Intel only]
+			By default the kernel will trim any uncacheable
+			memory out of your available memory pool based on
+			MTRR settings.  This parameter disables that behavior,
+			possibly causing your machine to run very slowly.
+
 	dmasound=	[HW,OSS] Sound subsystem buffers
 
 	dscc4.setup=	[NET]
Index: linux-x86.q/arch/x86/kernel/bugs_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/bugs_64.c
+++ linux-x86.q/arch/x86/kernel/bugs_64.c
@@ -13,7 +13,6 @@
 void __init check_bugs(void)
 {
 	identify_cpu(&boot_cpu_data);
-	mtrr_bp_init();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
Index: linux-x86.q/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-x86.q/arch/x86/kernel/cpu/mtrr/generic.c
@@ -14,7 +14,7 @@
 #include "mtrr.h"
 
 struct mtrr_state {
-	struct mtrr_var_range *var_ranges;
+	struct mtrr_var_range var_ranges[MAX_VAR_RANGES];
 	mtrr_type fixed_ranges[NUM_FIXED_RANGES];
 	unsigned char enabled;
 	unsigned char have_fixed;
@@ -90,12 +90,6 @@ void __init get_mtrr_state(void)
 	unsigned lo, dummy;
 	unsigned long flags;
 
-	if (!mtrr_state.var_ranges) {
-		mtrr_state.var_ranges = kmalloc(num_var_ranges * sizeof (struct mtrr_var_range),
-						GFP_KERNEL);
-		if (!mtrr_state.var_ranges)
-			return;
-	}
 	vrs = mtrr_state.var_ranges;
 
 	rdmsr(MTRRcap_MSR, lo, dummy);
Index: linux-x86.q/arch/x86/kernel/cpu/mtrr/if.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mtrr/if.c
+++ linux-x86.q/arch/x86/kernel/cpu/mtrr/if.c
@@ -11,10 +11,6 @@
 #include <asm/mtrr.h>
 #include "mtrr.h"
 
-/* RED-PEN: this is accessed without any locking */
-extern unsigned int *usage_table;
-
-
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
@@ -397,7 +393,7 @@ static int mtrr_seq_show(struct seq_file
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
 		if (size == 0)
-			usage_table[i] = 0;
+			mtrr_usage_table[i] = 0;
 		else {
 			if (size < (0x100000 >> PAGE_SHIFT)) {
 				/* less than 1MB */
@@ -411,7 +407,7 @@ static int mtrr_seq_show(struct seq_file
 			len += seq_printf(seq, 
 				   "reg%02i: base=0x%05lx000 (%4luMB), size=%4lu%cB: %s, count=%d\n",
 			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_attrib_to_str(type), usage_table[i]);
+			     mtrr_attrib_to_str(type), mtrr_usage_table[i]);
 		}
 	}
 	return 0;
Index: linux-x86.q/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-x86.q/arch/x86/kernel/cpu/mtrr/main.c
@@ -38,8 +38,8 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
+#include <asm/e820.h>
 #include <asm/mtrr.h>
-
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -47,7 +47,7 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int *usage_table;
+unsigned int mtrr_usage_table[MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -121,13 +121,8 @@ static void __init init_table(void)
 	int i, max;
 
 	max = num_var_ranges;
-	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
-	    == NULL) {
-		printk(KERN_ERR "mtrr: could not allocate\n");
-		return;
-	}
 	for (i = 0; i < max; i++)
-		usage_table[i] = 1;
+		mtrr_usage_table[i] = 1;
 }
 
 struct set_mtrr_data {
@@ -383,7 +378,7 @@ int mtrr_add_page(unsigned long base, un
 			goto out;
 		}
 		if (increment)
-			++usage_table[i];
+			++mtrr_usage_table[i];
 		error = i;
 		goto out;
 	}
@@ -391,15 +386,15 @@ int mtrr_add_page(unsigned long base, un
 	i = mtrr_if->get_free_region(base, size, replace);
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
-		if (likely(replace < 0))
-			usage_table[i] = 1;
-		else {
-			usage_table[i] = usage_table[replace];
+		if (likely(replace < 0)) {
+			mtrr_usage_table[i] = 1;
+		} else {
+			mtrr_usage_table[i] = mtrr_usage_table[replace];
 			if (increment)
-				usage_table[i]++;
+				mtrr_usage_table[i]++;
 			if (unlikely(replace != i)) {
 				set_mtrr(replace, 0, 0, 0);
-				usage_table[replace] = 0;
+				mtrr_usage_table[replace] = 0;
 			}
 		}
 	} else
@@ -529,11 +524,11 @@ int mtrr_del_page(int reg, unsigned long
 		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
-	if (usage_table[reg] < 1) {
+	if (mtrr_usage_table[reg] < 1) {
 		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
-	if (--usage_table[reg] < 1)
+	if (--mtrr_usage_table[reg] < 1)
 		set_mtrr(reg, 0, 0, 0);
 	error = reg;
  out:
@@ -593,16 +588,11 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value * mtrr_state;
+static struct mtrr_value mtrr_state[MAX_VAR_RANGES];
 
 static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 {
 	int i;
-	int size = num_var_ranges * sizeof(struct mtrr_value);
-
-	mtrr_state = kzalloc(size,GFP_ATOMIC);
-	if (!mtrr_state)
-		return -ENOMEM;
 
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i,
@@ -624,7 +614,6 @@ static int mtrr_restore(struct sys_devic
 				 mtrr_state[i].lsize,
 				 mtrr_state[i].ltype);
 	}
-	kfree(mtrr_state);
 	return 0;
 }
 
@@ -635,6 +624,59 @@ static struct sysdev_driver mtrr_sysdev_
 	.resume		= mtrr_restore,
 };
 
+static int disable_mtrr_trim;
+
+static int __init disable_mtrr_trim_setup(char *str)
+{
+	disable_mtrr_trim = 1;
+	return 0;
+}
+early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
+
+#ifdef CONFIG_X86_64
+/**
+ * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
+ *
+ * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
+ * memory configurations.  This routine checks to make sure the MTRRs having
+ * a write back type cover all of the memory the kernel is intending to use.
+ * If not, it'll trim any memory off the end by adjusting end_pfn, removing
+ * it from the kernel's allocation pools, warning the user with an obnoxious
+ * message.
+ */
+void __init mtrr_trim_uncached_memory(void)
+{
+	unsigned long i, base, size, highest_addr = 0, def, dummy;
+	mtrr_type type;
+
+	/* Make sure we only trim uncachable memory on Intel machines */
+	rdmsr(MTRRdefType_MSR, def, dummy);
+	def &= 0xff;
+	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
+		return;
+
+	/* Find highest cached pfn */
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type != MTRR_TYPE_WRBACK)
+			continue;
+		base <<= PAGE_SHIFT;
+		size <<= PAGE_SHIFT;
+		if (highest_addr < base + size)
+			highest_addr = base + size;
+	}
+
+	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
+		printk(KERN_WARNING "***************\n");
+		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
+		printk(KERN_WARNING "**** MTRRs don't cover all of "
+		       "memory, trimmed %ld pages\n", end_pfn -
+		       (highest_addr >> PAGE_SHIFT));
+		printk(KERN_WARNING "***************\n");
+		end_pfn = highest_addr >> PAGE_SHIFT;
+	}
+}
+#endif
 
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
Index: linux-x86.q/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-x86.q/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -12,6 +12,7 @@
 #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
 
 #define NUM_FIXED_RANGES 88
+#define MAX_VAR_RANGES 256
 #define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
@@ -32,6 +33,8 @@
    an 8 bit field: */
 typedef u8 mtrr_type;
 
+extern unsigned int mtrr_usage_table[MAX_VAR_RANGES];
+
 struct mtrr_ops {
 	u32	vendor;
 	u32	use_intel_if;
Index: linux-x86.q/arch/x86/kernel/setup_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_64.c
+++ linux-x86.q/arch/x86/kernel/setup_64.c
@@ -322,6 +322,10 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
+	/* Trim memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	mtrr_trim_uncached_memory();
+
 	num_physpages = end_pfn;
 
 	check_efer();
Index: linux-x86.q/include/asm-x86/mtrr.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/mtrr.h
+++ linux-x86.q/include/asm-x86/mtrr.h
@@ -97,6 +97,7 @@ extern int mtrr_del_page (int reg, unsig
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void mtrr_trim_uncached_memory(void);
 #  else
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
@@ -120,7 +121,9 @@ static __inline__ int mtrr_del_page (int
 {
     return -ENODEV;
 }
-
+static __inline__ void mtrr_trim_uncached_memory(void)
+{
+}
 static __inline__ void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi) {;}
 
 #define mtrr_ap_init() do {} while (0)

Subject: x86, 32-bit: trim memory not covered by wb mtrrs, fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/cpu/mtrr/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-x86.q/arch/x86/kernel/cpu/mtrr/main.c
@@ -666,7 +666,7 @@ void __init mtrr_trim_uncached_memory(vo
 			highest_addr = base + size;
 	}
 
-	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
+	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
 		printk(KERN_WARNING "***************\n");
 		printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
 		printk(KERN_WARNING "**** MTRRs don't cover all of "
