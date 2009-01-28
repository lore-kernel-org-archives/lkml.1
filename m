Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbZA2ASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbZA2ASY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZA1Xqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:53283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbZA1Xqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:34 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 083/114] x86: remove subarchitecture support
Date: Wed, 28 Jan 2009 23:42:29 +0000
Message-Id: <1233186180-29883-84-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the 32-bit subarchitecture support code.

All subarchitectures but Voyager have been converted. Voyager will be
done later or will be removed.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Makefile               |   21 -----
 arch/x86/include/asm/apic.h     |    2 +
 arch/x86/kernel/Makefile        |    2 +-
 arch/x86/kernel/io_apic.c       |   17 ----
 arch/x86/kernel/probe_32.c      |  163 +++++++++++++++++++++++++++++++++++++++
 arch/x86/mach-default/setup.c   |  162 --------------------------------------
 arch/x86/mach-generic/default.c |   93 ----------------------
 7 files changed, 166 insertions(+), 294 deletions(-)
 delete mode 100644 arch/x86/mach-default/setup.c
 delete mode 100644 arch/x86/mach-generic/default.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 799a0d9..99550c4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -102,24 +102,6 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 
-###
-# Sub architecture support
-# fcore-y is linked before mcore-y files.
-
-# Default subarch .c files
-mcore-y  := arch/x86/mach-default/
-
-# Voyager subarch support
-mflags-$(CONFIG_X86_VOYAGER)	:= -Iarch/x86/include/asm/mach-voyager
-mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
-
-# default subarch .h files
-mflags-y += -Iarch/x86/include/asm/mach-default
-
-# 64 bit does not support subarch support - clear sub arch variables
-fcore-$(CONFIG_X86_64)  :=
-mcore-$(CONFIG_X86_64)  :=
-
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
@@ -145,9 +127,6 @@ core-$(CONFIG_LGUEST_GUEST) += arch/x86/lguest/
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
-# Remaining sub architecture files
-core-y += $(mcore-y)
-
 core-y += arch/x86/crypto/
 core-y += arch/x86/vdso/
 core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 6a77068..b03711d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -215,6 +215,7 @@ static inline void disable_local_APIC(void) { }
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
@@ -224,6 +225,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
 	else
 		return (x >> 24) & 0x0F;
 }
+#endif
 
 #endif
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 61aeca3..cea216f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_SMP)		+= setup_percpu.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o ipi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 241a01d..3378ffb 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -797,23 +797,6 @@ static void clear_IO_APIC (void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_X86_32)
-void default_send_IPI_self(int vector)
-{
-	unsigned int cfg;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | apic->dest_logical;
-	/*
-	 * Send the IPI. The write to APIC_ICR fires this off.
-	 */
-	apic_write(APIC_ICR, cfg);
-}
-#endif /* !CONFIG_SMP && CONFIG_X86_32*/
-
 #ifdef CONFIG_X86_32
 /*
  * support for broken MP BIOSs, enables hand-redirection of PIRQ0-7 to
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index a6fba69..61339a0 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -32,6 +32,26 @@
 #include <asm/genapic.h>
 #include <asm/ipi.h>
 
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/acpi.h>
+#include <asm/arch_hooks.h>
+#include <asm/e820.h>
+#include <asm/setup.h>
+
+#include <asm/genapic.h>
+
+#ifdef CONFIG_HOTPLUG_CPU
+#define DEFAULT_SEND_IPI	(1)
+#else
+#define DEFAULT_SEND_IPI	(0)
+#endif
+
+int no_broadcast = DEFAULT_SEND_IPI;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/*
@@ -246,3 +266,146 @@ int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	}
 	return 0;
 }
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
+/**
+ * pre_intr_init_hook - initialisation prior to setting up interrupt vectors
+ *
+ * Description:
+ *	Perform any necessary interrupt initialisation prior to setting up
+ *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
+ *	interrupts should be initialised here if the machine emulates a PC
+ *	in any way.
+ **/
+void __init pre_intr_init_hook(void)
+{
+	if (x86_quirks->arch_pre_intr_init) {
+		if (x86_quirks->arch_pre_intr_init())
+			return;
+	}
+	init_ISA_irqs();
+}
+
+/**
+ * intr_init_hook - post gate setup interrupt initialisation
+ *
+ * Description:
+ *	Fill in any interrupts that may have been left out by the general
+ *	init_IRQ() routine.  interrupts having to do with the machine rather
+ *	than the devices on the I/O bus (like APIC interrupts in intel MP
+ *	systems) are started here.
+ **/
+void __init intr_init_hook(void)
+{
+	if (x86_quirks->arch_intr_init) {
+		if (x86_quirks->arch_intr_init())
+			return;
+	}
+}
+
+/**
+ * pre_setup_arch_hook - hook called prior to any setup_arch() execution
+ *
+ * Description:
+ *	generally used to activate any machine specific identification
+ *	routines that may be needed before setup_arch() runs.  On Voyager
+ *	this is used to get the board revision and type.
+ **/
+void __init pre_setup_arch_hook(void)
+{
+}
+
+/**
+ * trap_init_hook - initialise system specific traps
+ *
+ * Description:
+ *	Called as the final act of trap_init().  Used in VISWS to initialise
+ *	the various board specific APIC traps.
+ **/
+void __init trap_init_hook(void)
+{
+	if (x86_quirks->arch_trap_init) {
+		if (x86_quirks->arch_trap_init())
+			return;
+	}
+}
+
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
+	.mask = CPU_MASK_NONE,
+	.name = "timer"
+};
+
+/**
+ * pre_time_init_hook - do any specific initialisations before.
+ *
+ **/
+void __init pre_time_init_hook(void)
+{
+	if (x86_quirks->arch_pre_time_init)
+		x86_quirks->arch_pre_time_init();
+}
+
+/**
+ * time_init_hook - do any specific initialisations for the system timer.
+ *
+ * Description:
+ *	Must plug the system timer interrupt source at HZ into the IRQ listed
+ *	in irq_vectors.h:TIMER_IRQ
+ **/
+void __init time_init_hook(void)
+{
+	if (x86_quirks->arch_time_init) {
+		/*
+		 * A nonzero return code does not mean failure, it means
+		 * that the architecture quirk does not want any
+		 * generic (timer) setup to be performed after this:
+		 */
+		if (x86_quirks->arch_time_init())
+			return;
+	}
+
+	irq0.mask = cpumask_of_cpu(0);
+	setup_irq(0, &irq0);
+}
+
+#ifdef CONFIG_MCA
+/**
+ * mca_nmi_hook - hook into MCA specific NMI chain
+ *
+ * Description:
+ *	The MCA (Microchannel Architecture) has an NMI chain for NMI sources
+ *	along the MCA bus.  Use this to hook into that chain if you will need
+ *	it.
+ **/
+void mca_nmi_hook(void)
+{
+	/*
+	 * If I recall correctly, there's a whole bunch of other things that
+	 * we can do to check for NMI problems, but that's all I know about
+	 * at the moment.
+	 */
+	pr_warning("NMI generated from unknown source!\n");
+}
+#endif
+
+static __init int no_ipi_broadcast(char *str)
+{
+	get_option(&str, &no_broadcast);
+	pr_info("Using %s mode\n",
+		no_broadcast ? "No IPI Broadcast" : "IPI Broadcast");
+	return 1;
+}
+__setup("no_ipi_broadcast=", no_ipi_broadcast);
+
+static int __init print_ipi_mode(void)
+{
+	pr_info("Using IPI %s mode\n",
+		no_broadcast ? "No-Shortcut" : "Shortcut");
+	return 0;
+}
+
+late_initcall(print_ipi_mode);
+
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
deleted file mode 100644
index b65ff0b..0000000
--- a/arch/x86/mach-default/setup.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- *	Machine specific setup for generic
- */
-
-#include <linux/smp.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <asm/acpi.h>
-#include <asm/arch_hooks.h>
-#include <asm/e820.h>
-#include <asm/setup.h>
-
-#include <asm/genapic.h>
-
-#ifdef CONFIG_HOTPLUG_CPU
-#define DEFAULT_SEND_IPI	(1)
-#else
-#define DEFAULT_SEND_IPI	(0)
-#endif
-
-int no_broadcast = DEFAULT_SEND_IPI;
-
-/**
- * pre_intr_init_hook - initialisation prior to setting up interrupt vectors
- *
- * Description:
- *	Perform any necessary interrupt initialisation prior to setting up
- *	the "ordinary" interrupt call gates.  For legacy reasons, the ISA
- *	interrupts should be initialised here if the machine emulates a PC
- *	in any way.
- **/
-void __init pre_intr_init_hook(void)
-{
-	if (x86_quirks->arch_pre_intr_init) {
-		if (x86_quirks->arch_pre_intr_init())
-			return;
-	}
-	init_ISA_irqs();
-}
-
-/**
- * intr_init_hook - post gate setup interrupt initialisation
- *
- * Description:
- *	Fill in any interrupts that may have been left out by the general
- *	init_IRQ() routine.  interrupts having to do with the machine rather
- *	than the devices on the I/O bus (like APIC interrupts in intel MP
- *	systems) are started here.
- **/
-void __init intr_init_hook(void)
-{
-	if (x86_quirks->arch_intr_init) {
-		if (x86_quirks->arch_intr_init())
-			return;
-	}
-}
-
-/**
- * pre_setup_arch_hook - hook called prior to any setup_arch() execution
- *
- * Description:
- *	generally used to activate any machine specific identification
- *	routines that may be needed before setup_arch() runs.  On Voyager
- *	this is used to get the board revision and type.
- **/
-void __init pre_setup_arch_hook(void)
-{
-}
-
-/**
- * trap_init_hook - initialise system specific traps
- *
- * Description:
- *	Called as the final act of trap_init().  Used in VISWS to initialise
- *	the various board specific APIC traps.
- **/
-void __init trap_init_hook(void)
-{
-	if (x86_quirks->arch_trap_init) {
-		if (x86_quirks->arch_trap_init())
-			return;
-	}
-}
-
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL,
-	.mask = CPU_MASK_NONE,
-	.name = "timer"
-};
-
-/**
- * pre_time_init_hook - do any specific initialisations before.
- *
- **/
-void __init pre_time_init_hook(void)
-{
-	if (x86_quirks->arch_pre_time_init)
-		x86_quirks->arch_pre_time_init();
-}
-
-/**
- * time_init_hook - do any specific initialisations for the system timer.
- *
- * Description:
- *	Must plug the system timer interrupt source at HZ into the IRQ listed
- *	in irq_vectors.h:TIMER_IRQ
- **/
-void __init time_init_hook(void)
-{
-	if (x86_quirks->arch_time_init) {
-		/*
-		 * A nonzero return code does not mean failure, it means
-		 * that the architecture quirk does not want any
-		 * generic (timer) setup to be performed after this:
-		 */
-		if (x86_quirks->arch_time_init())
-			return;
-	}
-
-	irq0.mask = cpumask_of_cpu(0);
-	setup_irq(0, &irq0);
-}
-
-#ifdef CONFIG_MCA
-/**
- * mca_nmi_hook - hook into MCA specific NMI chain
- *
- * Description:
- *	The MCA (Microchannel Architecture) has an NMI chain for NMI sources
- *	along the MCA bus.  Use this to hook into that chain if you will need
- *	it.
- **/
-void mca_nmi_hook(void)
-{
-	/*
-	 * If I recall correctly, there's a whole bunch of other things that
-	 * we can do to check for NMI problems, but that's all I know about
-	 * at the moment.
-	 */
-	pr_warning("NMI generated from unknown source!\n");
-}
-#endif
-
-static __init int no_ipi_broadcast(char *str)
-{
-	get_option(&str, &no_broadcast);
-	pr_info("Using %s mode\n",
-		no_broadcast ? "No IPI Broadcast" : "IPI Broadcast");
-	return 1;
-}
-__setup("no_ipi_broadcast=", no_ipi_broadcast);
-
-static int __init print_ipi_mode(void)
-{
-	pr_info("Using IPI %s mode\n",
-		no_broadcast ? "No-Shortcut" : "Shortcut");
-	return 0;
-}
-
-late_initcall(print_ipi_mode);
-
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
deleted file mode 100644
index d9d44c8..0000000
--- a/arch/x86/mach-generic/default.c
+++ /dev/null
@@ -1,93 +0,0 @@
-/*
- * Default generic APIC driver. This handles up to 8 CPUs.
- */
-#define APIC_DEFINITION 1
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <asm/mpspec.h>
-#include <asm/genapic.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/smp.h>
-#include <linux/init.h>
-#include <asm/genapic.h>
-#include <asm/ipi.h>
-
-static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	/*
-	 * Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
-}
-
-/* should be called last. */
-static int probe_default(void)
-{
-	return 1;
-}
-
-struct genapic apic_default = {
-
-	.name				= "default",
-	.probe				= probe_default,
-	.acpi_madt_oem_check		= NULL,
-	.apic_id_registered		= default_apic_id_registered,
-
-	.irq_delivery_mode		= dest_LowestPrio,
-	/* logical delivery broadcast to all CPUs: */
-	.irq_dest_mode			= 1,
-
-	.target_cpus			= default_target_cpus,
-	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= default_check_apicid_used,
-	.check_apicid_present		= default_check_apicid_present,
-
-	.vector_allocation_domain	= default_vector_allocation_domain,
-	.init_apic_ldr			= default_init_apic_ldr,
-
-	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= default_setup_apic_routing,
-	.multi_timer_check		= NULL,
-	.apicid_to_node			= default_apicid_to_node,
-	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= default_phys_pkg_id,
-	.mps_oem_check			= NULL,
-
-	.get_apic_id			= default_get_apic_id,
-	.set_apic_id			= NULL,
-	.apic_id_mask			= 0x0F << 24,
-
-	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
-
-	.send_IPI_mask			= default_send_IPI_mask,
-	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= default_send_IPI_allbutself,
-	.send_IPI_all			= default_send_IPI_all,
-	.send_IPI_self			= NULL,
-
-	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
-
-	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= default_inquire_remote_apic,
-};
-- 
1.6.0.2

