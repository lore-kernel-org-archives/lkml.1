Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYCZVlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYCZVlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760763AbYCZVlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:41:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760475AbYCZVlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:41:22 -0400
Date: Wed, 26 Mar 2008 22:41:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080326214107.GA29607@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,

	Ingo

------------------>
Andres Salomon (1):
      x86: GEODE: add missing module.h include

Ingo Molnar (1):
      x86: add dmi quirk for io_delay

Nick Andrew (1):
      x86: Documentation/i386/IO-APIC.txt: fix description

Randy Dunlap (1):
      x86: convert mtrr/generic.c to kernel-doc

Stephan Diestelhorst (1):
      x86, cpufreq: fix Speedfreq-SMI call that clobbers ECX

Suresh Siddha (1):
      x86: fix performance drop for glx

Yinghai Lu (2):
      x86: fix memoryless node oops during boot
      x86: fix trim mtrr not to setup_memory two times

 Documentation/i386/IO-APIC.txt              |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c |   39 +++++++++++++++---------
 arch/x86/kernel/cpu/mtrr/generic.c          |   42 ++++++++++++++------------
 arch/x86/kernel/io_delay.c                  |    8 +++++
 arch/x86/kernel/mfgpt_32.c                  |    1 +
 arch/x86/kernel/setup_32.c                  |    9 ++---
 arch/x86/kernel/setup_64.c                  |    2 +-
 arch/x86/mm/discontig_32.c                  |    1 -
 arch/x86/mm/ioremap.c                       |    6 +++-
 arch/x86/mm/pageattr.c                      |    2 +-
 include/asm-x86/pgtable.h                   |    2 +
 11 files changed, 70 insertions(+), 44 deletions(-)

diff --git a/Documentation/i386/IO-APIC.txt b/Documentation/i386/IO-APIC.txt
index f951666..30b4c71 100644
--- a/Documentation/i386/IO-APIC.txt
+++ b/Documentation/i386/IO-APIC.txt
@@ -70,7 +70,7 @@ Every PCI card emits a PCI IRQ, which can be INTA, INTB, INTC or INTD:
 
 These INTA-D PCI IRQs are always 'local to the card', their real meaning
 depends on which slot they are in. If you look at the daisy chaining diagram,
-a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ2 of
+a card in slot4, issuing INTA IRQ, it will end up as a signal on PIRQ4 of
 the PCI chipset. Most cards issue INTA, this creates optimal distribution
 between the PIRQ lines. (distributing IRQ sources properly is not a
 necessity, PCI IRQs can be shared at will, but it's a good for performance
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index f2b5a62..8a85c93 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -63,7 +63,7 @@ static struct cpufreq_frequency_table speedstep_freqs[] = {
  */
 static int speedstep_smi_ownership (void)
 {
-	u32 command, result, magic;
+	u32 command, result, magic, dummy;
 	u32 function = GET_SPEEDSTEP_OWNER;
 	unsigned char magic_data[] = "Copyright (c) 1999 Intel Corporation";
 
@@ -73,8 +73,11 @@ static int speedstep_smi_ownership (void)
 	dprintk("trying to obtain ownership with command %x at port %x\n", command, smi_port);
 
 	__asm__ __volatile__(
+		"push %%ebp\n"
 		"out %%al, (%%dx)\n"
-		: "=D" (result)
+		"pop %%ebp\n"
+		: "=D" (result), "=a" (dummy), "=b" (dummy), "=c" (dummy), "=d" (dummy),
+			"=S" (dummy)
 		: "a" (command), "b" (function), "c" (0), "d" (smi_port),
 			"D" (0), "S" (magic)
 		: "memory"
@@ -96,7 +99,7 @@ static int speedstep_smi_ownership (void)
  */
 static int speedstep_smi_get_freqs (unsigned int *low, unsigned int *high)
 {
-	u32 command, result = 0, edi, high_mhz, low_mhz;
+	u32 command, result = 0, edi, high_mhz, low_mhz, dummy;
 	u32 state=0;
 	u32 function = GET_SPEEDSTEP_FREQS;
 
@@ -109,10 +112,12 @@ static int speedstep_smi_get_freqs (unsigned int *low, unsigned int *high)
 
 	dprintk("trying to determine frequencies with command %x at port %x\n", command, smi_port);
 
-	__asm__ __volatile__("movl $0, %%edi\n"
+	__asm__ __volatile__(
+		"push %%ebp\n"
 		"out %%al, (%%dx)\n"
-		: "=a" (result), "=b" (high_mhz), "=c" (low_mhz), "=d" (state), "=D" (edi)
-		: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0)
+		"pop %%ebp"
+		: "=a" (result), "=b" (high_mhz), "=c" (low_mhz), "=d" (state), "=D" (edi), "=S" (dummy)
+		: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0), "D" (0)
 	);
 
 	dprintk("result %x, low_freq %u, high_freq %u\n", result, low_mhz, high_mhz);
@@ -135,16 +140,18 @@ static int speedstep_smi_get_freqs (unsigned int *low, unsigned int *high)
 static int speedstep_get_state (void)
 {
 	u32 function=GET_SPEEDSTEP_STATE;
-	u32 result, state, edi, command;
+	u32 result, state, edi, command, dummy;
 
 	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
 
 	dprintk("trying to determine current setting with command %x at port %x\n", command, smi_port);
 
-	__asm__ __volatile__("movl $0, %%edi\n"
+	__asm__ __volatile__(
+		"push %%ebp\n"
 		"out %%al, (%%dx)\n"
-		: "=a" (result), "=b" (state), "=D" (edi)
-		: "a" (command), "b" (function), "c" (0), "d" (smi_port), "S" (0)
+		"pop %%ebp\n"
+		: "=a" (result), "=b" (state), "=D" (edi), "=c" (dummy), "=d" (dummy), "=S" (dummy)
+		: "a" (command), "b" (function), "c" (0), "d" (smi_port), "S" (0), "D" (0)
 	);
 
 	dprintk("state is %x, result is %x\n", state, result);
@@ -160,7 +167,7 @@ static int speedstep_get_state (void)
  */
 static void speedstep_set_state (unsigned int state)
 {
-	unsigned int result = 0, command, new_state;
+	unsigned int result = 0, command, new_state, dummy;
 	unsigned long flags;
 	unsigned int function=SET_SPEEDSTEP_STATE;
 	unsigned int retry = 0;
@@ -182,10 +189,12 @@ static void speedstep_set_state (unsigned int state)
 		}
 		retry++;
 		__asm__ __volatile__(
-			"movl $0, %%edi\n"
+			"push %%ebp\n"
 			"out %%al, (%%dx)\n"
-			: "=b" (new_state), "=D" (result)
-			: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0)
+			"pop %%ebp"
+			: "=b" (new_state), "=D" (result), "=c" (dummy), "=a" (dummy),
+				"=d" (dummy), "=S" (dummy)
+			: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0), "D" (0)
 			);
 	} while ((new_state != state) && (retry <= SMI_TRIES));
 
@@ -195,7 +204,7 @@ static void speedstep_set_state (unsigned int state)
 	if (new_state == state) {
 		dprintk("change to %u MHz succeeded after %u tries with result %u\n", (speedstep_freqs[new_state].frequency / 1000), retry, result);
 	} else {
-		printk(KERN_ERR "cpufreq: change failed with new_state %u and result %u\n", new_state, result);
+		printk(KERN_ERR "cpufreq: change to state %u failed with new_state %u and result %u\n", state, new_state, result);
 	}
 
 	return;
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 103d61a..3e18db4 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -176,12 +176,13 @@ static inline void k8_enable_fixed_iorrs(void)
 }
 
 /**
- * Checks and updates an fixed-range MTRR if it differs from the value it
- * should have. If K8 extentions are wanted, update the K8 SYSCFG MSR also.
- * see AMD publication no. 24593, chapter 7.8.1, page 233 for more information
- * \param msr MSR address of the MTTR which should be checked and updated
- * \param changed pointer which indicates whether the MTRR needed to be changed
- * \param msrwords pointer to the MSR values which the MSR should have
+ * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
+ * @msr: MSR address of the MTTR which should be checked and updated
+ * @changed: pointer which indicates whether the MTRR needed to be changed
+ * @msrwords: pointer to the MSR values which the MSR should have
+ *
+ * If K8 extentions are wanted, update the K8 SYSCFG MSR also.
+ * See AMD publication no. 24593, chapter 7.8.1, page 233 for more information.
  */
 static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
@@ -199,12 +200,15 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 	}
 }
 
+/**
+ * generic_get_free_region - Get a free MTRR.
+ * @base: The starting (base) address of the region.
+ * @size: The size (in bytes) of the region.
+ * @replace_reg: mtrr index to be replaced; set to invalid value if none.
+ *
+ * Returns: The index of the region on success, else negative on error.
+ */
 int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free MTRR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
 	int i, max;
 	mtrr_type ltype;
@@ -249,8 +253,8 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 }
 
 /**
- * Checks and updates the fixed-range MTRRs if they differ from the saved set
- * \param frs pointer to fixed-range MTRR values, saved by get_fixed_ranges()
+ * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
+ * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
 static int set_fixed_ranges(mtrr_type * frs)
 {
@@ -294,13 +298,13 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 
 static u32 deftype_lo, deftype_hi;
 
+/**
+ * set_mtrr_state - Set the MTRR state for this CPU.
+ *
+ * NOTE: The CPU must already be in a safe state for MTRR changes.
+ * RETURNS: 0 if no changes made, else a mask indicating what was changed.
+ */
 static unsigned long set_mtrr_state(void)
-/*  [SUMMARY] Set the MTRR state for this CPU.
-    <state> The MTRR state information to read.
-    <ctxt> Some relevant CPU context.
-    [NOTE] The CPU must already be in a safe state for MTRR changes.
-    [RETURNS] 0 if no changes made, else a mask indication what was changed.
-*/
 {
 	unsigned int i;
 	unsigned long change_mask = 0;
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index c706a30..5921e5f 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -78,6 +78,14 @@ static struct dmi_system_id __initdata io_delay_0xed_port_dmi_table[] = {
 	},
 	{
 		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "HP Pavilion dv6000",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30B8")
+		}
+	},
+	{
+		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "HP Pavilion tx1000",
 		.matches	= {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 027fc06..b402c0f 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -30,6 +30,7 @@
 
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <asm/geode.h>
 
 static struct mfgpt_timer_t {
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index a1d7071..2b3e5d4 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -406,8 +406,6 @@ static unsigned long __init setup_memory(void)
 	 */
 	min_low_pfn = PFN_UP(init_pg_tables_end);
 
-	find_max_pfn();
-
 	max_low_pfn = find_max_low_pfn();
 
 #ifdef CONFIG_HIGHMEM
@@ -764,12 +762,13 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
-	max_low_pfn = setup_memory();
-
 	/* update e820 for memory not covered by WB MTRRs */
+	find_max_pfn();
 	mtrr_bp_init();
 	if (mtrr_trim_uncached_memory(max_pfn))
-		max_low_pfn = setup_memory();
+		find_max_pfn();
+
+	max_low_pfn = setup_memory();
 
 #ifdef CONFIG_VMI
 	/*
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 7637dc9..f4f7ecf 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -801,7 +801,7 @@ static void __cpuinit srat_detect_node(void)
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE)
+	if (node == NUMA_NO_NODE || !node_online(node))
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index c394ca0..8e25e06 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -324,7 +324,6 @@ unsigned long __init setup_memory(void)
 	 * this space and use it to adjust the boundary between ZONE_NORMAL
 	 * and ZONE_HIGHMEM.
 	 */
-	find_max_pfn();
 	get_memcfg_numa();
 
 	kva_pages = calculate_numa_remap_pages();
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 4afaba0..794895c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -137,7 +137,11 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		/*
+		 * FIXME: we will use UC MINUS for now, as video fb drivers
+		 * depend on it. Upcoming ioremap_wc() will fix this behavior.
+		 */
+		prot = PAGE_KERNEL_UC_MINUS;
 		break;
 	case IOR_MODE_CACHED:
 		prot = PAGE_KERNEL;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 14e48b5..7b79f6b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -771,7 +771,7 @@ static inline int change_page_attr_clear(unsigned long addr, int numpages,
 int set_memory_uc(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_PCD | _PAGE_PWT));
+				    __pgprot(_PAGE_PCD));
 }
 EXPORT_SYMBOL(set_memory_uc);
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..9cf472a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -85,6 +85,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
@@ -101,6 +102,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_UC_MINUS		MAKE_GLOBAL(__PAGE_KERNEL_UC_MINUS)
 #define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
