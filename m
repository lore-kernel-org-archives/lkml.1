Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbXKZTeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbXKZTeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXKZTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:34:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbXKZTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:34:03 -0500
Date: Mon, 26 Nov 2007 20:33:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 arch fixes for v2.6.24
Message-ID: <20071126193353.GA1676@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 fixes for v2.6.24 tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

small fixlets: regression fixes, build and boot fixes, an NTP API fix 
(acked by Ulrich), kernel version added to WARN_ON() for QA and an ACPI 
fix.

NOTE: this tree includes the following (unmodified) queue pushed out by 
Thomas:

   http://lkml.org/lkml/2007/11/17/84

if you already pulled Thomas's update then ignore this pull request and 
we'll send a new one once you have pushed out your latest tree.

	Ingo

------------------>
Alexey Starikovskiy (1):
      ACPI: Set max_cstate to 1 for early Opterons.

Andreas Herrmann (1):
      x86: correctly set UTS_MACHINE for "make ARCH=x86"

Andrew Morton (1):
      x86: fix kprobes_64.c inlining borkage

Arjan van de Ven (1):
      x86: printk kernel version in WARN_ON and other dump_stack users

Ingo Molnar (2):
      x86: turn off iommu merge by default
      x86: fix APIC related bootup crash on Athlon XP CPUs

John Stultz (1):
      time: add ADJ_OFFSET_SS_READ

Maciej W. Rozycki (1):
      x86: fix NMI watchdog & 'stopped time' problem

Michal Schmidt (1):
      pci: use pci=bfsort for HP DL385 G2, DL585 G2

Peter Zijlstra (1):
      lockdep: annotate do_debug() trap handler

Theodore Ts'o (1):
      x86: export the symbol empty_zero_page on the 32-bit x86 architecture

Thomas Gleixner (1):
      x86: fix ACPI compile for LOCAL_APIC=n

---
 arch/x86/Makefile               |    5 ++---
 arch/x86/kernel/apic_32.c       |    2 +-
 arch/x86/kernel/i386_ksyms_32.c |    2 ++
 arch/x86/kernel/io_apic_32.c    |   12 ++++++++++--
 arch/x86/kernel/kprobes_64.c    |    2 +-
 arch/x86/kernel/nmi_32.c        |    9 +++++++--
 arch/x86/kernel/pci-dma_64.c    |    2 +-
 arch/x86/kernel/traps_32.c      |    7 +++++++
 arch/x86/kernel/traps_64.c      |    9 +++++++++
 arch/x86/pci/common.c           |   16 ++++++++++++++++
 drivers/acpi/processor_idle.c   |    1 +
 include/asm-ia64/acpi.h         |    1 +
 include/asm-x86/acpi.h          |   27 +++++++++++++++++++++++++++
 include/asm-x86/apic_32.h       |    1 +
 include/linux/timex.h           |    1 +
 kernel/time/ntp.c               |    9 ++++++---
 16 files changed, 93 insertions(+), 13 deletions(-)

Index: linux-x86.q/arch/x86/Makefile
===================================================================
--- linux-x86.q.orig/arch/x86/Makefile
+++ linux-x86.q/arch/x86/Makefile
@@ -11,10 +11,9 @@ endif
 $(srctree)/arch/x86/Makefile%: ;
 
 ifeq ($(CONFIG_X86_32),y)
+        UTS_MACHINE := i386
         include $(srctree)/arch/x86/Makefile_32
 else
+        UTS_MACHINE := x86_64
         include $(srctree)/arch/x86/Makefile_64
 endif
-
-
-
Index: linux-x86.q/arch/x86/kernel/apic_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/apic_32.c
+++ linux-x86.q/arch/x86/kernel/apic_32.c
@@ -789,7 +789,7 @@ void __init sync_Arb_IDs(void)
 	 * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
 	 * needed on AMD.
 	 */
-	if (modern_apic())
+	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return;
 	/*
 	 * Wait for idle.
Index: linux-x86.q/arch/x86/kernel/i386_ksyms_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/i386_ksyms_32.c
+++ linux-x86.q/arch/x86/kernel/i386_ksyms_32.c
@@ -2,6 +2,7 @@
 #include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 
 EXPORT_SYMBOL(__down_failed);
 EXPORT_SYMBOL(__down_failed_interruptible);
@@ -29,3 +30,4 @@ EXPORT_SYMBOL(__read_lock_failed);
 #endif
 
 EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(empty_zero_page);
Index: linux-x86.q/arch/x86/kernel/io_apic_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/io_apic_32.c
+++ linux-x86.q/arch/x86/kernel/io_apic_32.c
@@ -2166,6 +2166,10 @@ static inline void __init check_timer(vo
 {
 	int apic1, pin1, apic2, pin2;
 	int vector;
+	unsigned int ver;
+
+	ver = apic_read(APIC_LVR);
+	ver = GET_APIC_VERSION(ver);
 
 	/*
 	 * get/set the timer IRQ vector:
@@ -2179,11 +2183,15 @@ static inline void __init check_timer(vo
 	 * mode for the 8259A whenever interrupts are routed
 	 * through I/O APICs.  Also IRQ0 has to be enabled in
 	 * the 8259A which implies the virtual wire has to be
-	 * disabled in the local APIC.
+	 * disabled in the local APIC.  Finally timer interrupts
+	 * need to be acknowledged manually in the 8259A for
+	 * timer_interrupt() and for the i82489DX when using
+	 * the NMI watchdog.
 	 */
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-	timer_ack = 1;
+	timer_ack = !cpu_has_tsc;
+	timer_ack |= (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
 	if (timer_over_8254 > 0)
 		enable_8259A_irq(0);
 
Index: linux-x86.q/arch/x86/kernel/kprobes_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/kprobes_64.c
+++ linux-x86.q/arch/x86/kernel/kprobes_64.c
@@ -58,7 +58,7 @@ const int kretprobe_blacklist_size = ARR
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
-static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
+static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 {
 	switch (*insn) {
 	case 0xfa:		/* cli */
Index: linux-x86.q/arch/x86/kernel/nmi_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/nmi_32.c
+++ linux-x86.q/arch/x86/kernel/nmi_32.c
@@ -25,6 +25,7 @@
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
+#include <asm/timer.h>
 
 #include "mach_traps.h"
 
@@ -83,7 +84,7 @@ static int __init check_nmi_watchdog(voi
 
 	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
 	if (!prev_nmi_count)
-		return -1;
+		goto error;
 
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
@@ -117,7 +118,7 @@ static int __init check_nmi_watchdog(voi
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
-		return -1;
+		goto error;
 	}
 	printk("OK.\n");
 
@@ -128,6 +129,10 @@ static int __init check_nmi_watchdog(voi
 
 	kfree(prev_nmi_count);
 	return 0;
+error:
+	timer_ack = !cpu_has_tsc;
+
+	return -1;
 }
 /* This needs to happen later in boot so counters are working */
 late_initcall(check_nmi_watchdog);
Index: linux-x86.q/arch/x86/kernel/pci-dma_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/pci-dma_64.c
+++ linux-x86.q/arch/x86/kernel/pci-dma_64.c
@@ -12,7 +12,7 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
-int iommu_merge __read_mostly = 1;
+int iommu_merge __read_mostly = 0;
 EXPORT_SYMBOL(iommu_merge);
 
 dma_addr_t bad_dma_address __read_mostly;
Index: linux-x86.q/arch/x86/kernel/traps_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/traps_32.c
+++ linux-x86.q/arch/x86/kernel/traps_32.c
@@ -283,6 +283,11 @@ void dump_stack(void)
 {
 	unsigned long stack;
 
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
 	show_trace(current, NULL, &stack);
 }
 
@@ -828,6 +833,8 @@ fastcall void __kprobes do_debug(struct 
 	unsigned int condition;
 	struct task_struct *tsk = current;
 
+	trace_hardirqs_fixup();
+
 	get_debugreg(condition, 6);
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
Index: linux-x86.q/arch/x86/kernel/traps_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/traps_64.c
+++ linux-x86.q/arch/x86/kernel/traps_64.c
@@ -31,6 +31,7 @@
 #include <linux/uaccess.h>
 #include <linux/bug.h>
 #include <linux/kdebug.h>
+#include <linux/utsname.h>
 
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
@@ -400,6 +401,12 @@ void show_stack(struct task_struct *tsk,
 void dump_stack(void)
 {
 	unsigned long dummy;
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
 	show_trace(NULL, NULL, &dummy);
 }
 
@@ -846,6 +853,8 @@ asmlinkage void __kprobes do_debug(struc
 	struct task_struct *tsk = current;
 	siginfo_t info;
 
+	trace_hardirqs_fixup();
+
 	get_debugreg(condition, 6);
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
Index: linux-x86.q/arch/x86/pci/common.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/common.c
+++ linux-x86.q/arch/x86/pci/common.c
@@ -315,6 +315,22 @@ static struct dmi_system_id __devinitdat
 		},
 	},
 #endif
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
 	{}
 };
 
Index: linux-x86.q/drivers/acpi/processor_idle.c
===================================================================
--- linux-x86.q.orig/drivers/acpi/processor_idle.c
+++ linux-x86.q/drivers/acpi/processor_idle.c
@@ -1658,6 +1658,7 @@ int __cpuinit acpi_processor_power_init(
 
 	if (!first_run) {
 		dmi_check_system(processor_power_dmi_table);
+		max_cstate = acpi_processor_cstate_check(max_cstate);
 		if (max_cstate < ACPI_C_STATES_MAX)
 			printk(KERN_NOTICE
 			       "ACPI: processor limited to max C-state %d\n",
Index: linux-x86.q/include/asm-ia64/acpi.h
===================================================================
--- linux-x86.q.orig/include/asm-ia64/acpi.h
+++ linux-x86.q/include/asm-ia64/acpi.h
@@ -94,6 +94,7 @@ ia64_acpi_release_global_lock (unsigned 
 #define acpi_noirq 0	/* ACPI always enabled on IA64 */
 #define acpi_pci_disabled 0 /* ACPI PCI always enabled on IA64 */
 #define acpi_strict 1	/* no ACPI spec workarounds on IA64 */
+#define acpi_processor_cstate_check(x) (x) /* no idle limits on IA64 :) */
 static inline void disable_acpi(void) { }
 
 const char *acpi_get_sysname (void);
Index: linux-x86.q/include/asm-x86/acpi.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/acpi.h
+++ linux-x86.q/include/asm-x86/acpi.h
@@ -1,5 +1,32 @@
+#ifndef _ASM_X86_ACPI_H
+#define _ASM_X86_ACPI_H
+
 #ifdef CONFIG_X86_32
 # include "acpi_32.h"
 #else
 # include "acpi_64.h"
 #endif
+
+#include <asm/processor.h>
+
+/*
+ * Check if the CPU can handle C2 and deeper
+ */
+static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
+{
+	/*
+	 * Early models (<=5) of AMD Opterons are not supposed to go into
+	 * C2 state.
+	 *
+	 * Steppings 0x0A and later are good
+	 */
+	if (boot_cpu_data.x86 == 0x0F &&
+	    boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_model <= 0x05 &&
+	    boot_cpu_data.x86_mask < 0x0A)
+		return 1;
+	else
+		return max_cstate;
+}
+
+#endif
Index: linux-x86.q/include/asm-x86/apic_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/apic_32.h
+++ linux-x86.q/include/asm-x86/apic_32.h
@@ -120,6 +120,7 @@ extern int local_apic_timer_disabled;
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
+#define local_apic_timer_c2_ok		1
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
Index: linux-x86.q/include/linux/timex.h
===================================================================
--- linux-x86.q.orig/include/linux/timex.h
+++ linux-x86.q/include/linux/timex.h
@@ -137,6 +137,7 @@ struct timex {
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
 #define ADJ_TICK		0x4000	/* tick value */
 #define ADJ_OFFSET_SINGLESHOT	0x8001	/* old-fashioned adjtime */
+#define ADJ_OFFSET_SS_READ	0xa001  /* read-only adjtime */
 
 /* xntp 3.4 compatibility names */
 #define MOD_OFFSET	ADJ_OFFSET
Index: linux-x86.q/kernel/time/ntp.c
===================================================================
--- linux-x86.q.orig/kernel/time/ntp.c
+++ linux-x86.q/kernel/time/ntp.c
@@ -249,10 +249,12 @@ int do_adjtimex(struct timex *txc)
 
 	/* Now we validate the data before disabling interrupts */
 
-	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
+	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT) {
 	  /* singleshot must not be used with any other mode bits */
-		if (txc->modes != ADJ_OFFSET_SINGLESHOT)
+		if (txc->modes != ADJ_OFFSET_SINGLESHOT &&
+					txc->modes != ADJ_OFFSET_SS_READ)
 			return -EINVAL;
+	}
 
 	if (txc->modes != ADJ_OFFSET_SINGLESHOT && (txc->modes & ADJ_OFFSET))
 	  /* adjustment Offset limited to +- .512 seconds */
@@ -372,7 +374,8 @@ int do_adjtimex(struct timex *txc)
 leave:	if ((time_status & (STA_UNSYNC|STA_CLOCKERR)) != 0)
 		result = TIME_ERROR;
 
-	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
+	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
+			(txc->modes == ADJ_OFFSET_SS_READ))
 		txc->offset = save_adjust;
 	else
 		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
