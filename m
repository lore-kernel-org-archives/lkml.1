Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZA2ARH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZA2ARH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbZA1Xqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:53259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748AbZA1XqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:25 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 081/114] x86: remove subarchitecture support code
Date: Wed, 28 Jan 2009 23:42:27 +0000
Message-Id: <1233186180-29883-82-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove remaining bits of the subarchitecture code. Now that all the
special platforms are runtime probed and runtime handled, we can remove
these facilities.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Makefile              |    5 -
 arch/x86/kernel/Makefile       |    2 +-
 arch/x86/kernel/probe_32.c     |  248 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mach-generic/Makefile |    7 -
 arch/x86/mach-generic/probe.c  |  156 -------------------------
 5 files changed, 249 insertions(+), 169 deletions(-)
 create mode 100644 arch/x86/kernel/probe_32.c
 delete mode 100644 arch/x86/mach-generic/Makefile
 delete mode 100644 arch/x86/mach-generic/probe.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index cacee98..799a0d9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -113,11 +113,6 @@ mcore-y  := arch/x86/mach-default/
 mflags-$(CONFIG_X86_VOYAGER)	:= -Iarch/x86/include/asm/mach-voyager
 mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
 
-# generic subarchitecture
-mflags-$(CONFIG_X86_GENERICARCH):= -Iarch/x86/include/asm/mach-generic
-fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
-mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
-
 # default subarch .h files
 mflags-y += -Iarch/x86/include/asm/mach-default
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ad6df80..61aeca3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -30,7 +30,7 @@ obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
-obj-$(CONFIG_X86_32)	+= probe_roms_32.o
+obj-$(CONFIG_X86_32)	+= probe_32.o probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
new file mode 100644
index 0000000..a6fba69
--- /dev/null
+++ b/arch/x86/kernel/probe_32.c
@@ -0,0 +1,248 @@
+/*
+ * Default generic APIC driver. This handles up to 8 CPUs.
+ *
+ * Copyright 2003 Andi Kleen, SuSE Labs.
+ * Subject to the GNU Public License, v.2
+ *
+ * Generic x86 APIC driver probe layer.
+ */
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <asm/fixmap.h>
+#include <asm/mpspec.h>
+#include <asm/apicdef.h>
+#include <asm/genapic.h>
+#include <asm/setup.h>
+
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <asm/mpspec.h>
+#include <asm/genapic.h>
+#include <asm/fixmap.h>
+#include <asm/apicdef.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <asm/genapic.h>
+#include <asm/ipi.h>
+
+static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	/*
+	 * Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
+}
+
+/* should be called last. */
+static int probe_default(void)
+{
+	return 1;
+}
+
+struct genapic apic_default = {
+
+	.name				= "default",
+	.probe				= probe_default,
+	.acpi_madt_oem_check		= NULL,
+	.apic_id_registered		= default_apic_id_registered,
+
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all CPUs: */
+	.irq_dest_mode			= 1,
+
+	.target_cpus			= default_target_cpus,
+	.disable_esr			= 0,
+	.dest_logical			= APIC_DEST_LOGICAL,
+	.check_apicid_used		= default_check_apicid_used,
+	.check_apicid_present		= default_check_apicid_present,
+
+	.vector_allocation_domain	= default_vector_allocation_domain,
+	.init_apic_ldr			= default_init_apic_ldr,
+
+	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
+	.setup_apic_routing		= default_setup_apic_routing,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= default_apicid_to_node,
+	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+	.phys_pkg_id			= default_phys_pkg_id,
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= default_get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= 0x0F << 24,
+
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= default_send_IPI_mask,
+	.send_IPI_mask_allbutself	= NULL,
+	.send_IPI_allbutself		= default_send_IPI_allbutself,
+	.send_IPI_all			= default_send_IPI_all,
+	.send_IPI_self			= NULL,
+
+	.wakeup_cpu			= NULL,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
+	.smp_callin_clear_local_apic	= NULL,
+	.store_NMI_vector		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
+};
+
+extern struct genapic apic_numaq;
+extern struct genapic apic_summit;
+extern struct genapic apic_bigsmp;
+extern struct genapic apic_es7000;
+extern struct genapic apic_default;
+
+struct genapic *apic = &apic_default;
+
+static struct genapic *apic_probe[] __initdata = {
+#ifdef CONFIG_X86_NUMAQ
+	&apic_numaq,
+#endif
+#ifdef CONFIG_X86_SUMMIT
+	&apic_summit,
+#endif
+#ifdef CONFIG_X86_BIGSMP
+	&apic_bigsmp,
+#endif
+#ifdef CONFIG_X86_ES7000
+	&apic_es7000,
+#endif
+	&apic_default,	/* must be last */
+	NULL,
+};
+
+static int cmdline_apic __initdata;
+static int __init parse_apic(char *arg)
+{
+	int i;
+
+	if (!arg)
+		return -EINVAL;
+
+	for (i = 0; apic_probe[i]; i++) {
+		if (!strcmp(apic_probe[i]->name, arg)) {
+			apic = apic_probe[i];
+			cmdline_apic = 1;
+			return 0;
+		}
+	}
+
+	if (x86_quirks->update_genapic)
+		x86_quirks->update_genapic();
+
+	/* Parsed again by __setup for debug/verbose */
+	return 0;
+}
+early_param("apic", parse_apic);
+
+void __init generic_bigsmp_probe(void)
+{
+#ifdef CONFIG_X86_BIGSMP
+	/*
+	 * This routine is used to switch to bigsmp mode when
+	 * - There is no apic= option specified by the user
+	 * - generic_apic_probe() has chosen apic_default as the sub_arch
+	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
+	 */
+
+	if (!cmdline_apic && apic == &apic_default) {
+		if (apic_bigsmp.probe()) {
+			apic = &apic_bigsmp;
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
+			printk(KERN_INFO "Overriding APIC driver with %s\n",
+			       apic->name);
+		}
+	}
+#endif
+}
+
+void __init generic_apic_probe(void)
+{
+	if (!cmdline_apic) {
+		int i;
+		for (i = 0; apic_probe[i]; i++) {
+			if (apic_probe[i]->probe()) {
+				apic = apic_probe[i];
+				break;
+			}
+		}
+		/* Not visible without early console */
+		if (!apic_probe[i])
+			panic("Didn't find an APIC driver");
+
+		if (x86_quirks->update_genapic)
+			x86_quirks->update_genapic();
+	}
+	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
+}
+
+/* These functions can switch the APIC even after the initial ->probe() */
+
+int __init
+generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+{
+	int i;
+
+	for (i = 0; apic_probe[i]; ++i) {
+		if (!apic_probe[i]->mps_oem_check)
+			continue;
+		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
+			continue;
+
+		if (!cmdline_apic) {
+			apic = apic_probe[i];
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
+			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
+			       apic->name);
+		}
+		return 1;
+	}
+	return 0;
+}
+
+int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	int i;
+
+	for (i = 0; apic_probe[i]; ++i) {
+		if (!apic_probe[i]->acpi_madt_oem_check)
+			continue;
+		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
+			continue;
+
+		if (!cmdline_apic) {
+			apic = apic_probe[i];
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
+			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
+			       apic->name);
+		}
+		return 1;
+	}
+	return 0;
+}
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
deleted file mode 100644
index 05e4a7c..0000000
--- a/arch/x86/mach-generic/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-#
-# Makefile for the generic architecture
-#
-
-EXTRA_CFLAGS			:= -Iarch/x86/kernel
-
-obj-y				:= probe.o default.o
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
deleted file mode 100644
index c03c722..0000000
--- a/arch/x86/mach-generic/probe.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * Copyright 2003 Andi Kleen, SuSE Labs.
- * Subject to the GNU Public License, v.2
- *
- * Generic x86 APIC driver probe layer.
- */
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/ctype.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <asm/fixmap.h>
-#include <asm/mpspec.h>
-#include <asm/apicdef.h>
-#include <asm/genapic.h>
-#include <asm/setup.h>
-
-extern struct genapic apic_numaq;
-extern struct genapic apic_summit;
-extern struct genapic apic_bigsmp;
-extern struct genapic apic_es7000;
-extern struct genapic apic_default;
-
-struct genapic *apic = &apic_default;
-
-static struct genapic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_NUMAQ
-	&apic_numaq,
-#endif
-#ifdef CONFIG_X86_SUMMIT
-	&apic_summit,
-#endif
-#ifdef CONFIG_X86_BIGSMP
-	&apic_bigsmp,
-#endif
-#ifdef CONFIG_X86_ES7000
-	&apic_es7000,
-#endif
-	&apic_default,	/* must be last */
-	NULL,
-};
-
-static int cmdline_apic __initdata;
-static int __init parse_apic(char *arg)
-{
-	int i;
-
-	if (!arg)
-		return -EINVAL;
-
-	for (i = 0; apic_probe[i]; i++) {
-		if (!strcmp(apic_probe[i]->name, arg)) {
-			apic = apic_probe[i];
-			cmdline_apic = 1;
-			return 0;
-		}
-	}
-
-	if (x86_quirks->update_genapic)
-		x86_quirks->update_genapic();
-
-	/* Parsed again by __setup for debug/verbose */
-	return 0;
-}
-early_param("apic", parse_apic);
-
-void __init generic_bigsmp_probe(void)
-{
-#ifdef CONFIG_X86_BIGSMP
-	/*
-	 * This routine is used to switch to bigsmp mode when
-	 * - There is no apic= option specified by the user
-	 * - generic_apic_probe() has chosen apic_default as the sub_arch
-	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
-	 */
-
-	if (!cmdline_apic && apic == &apic_default) {
-		if (apic_bigsmp.probe()) {
-			apic = &apic_bigsmp;
-			if (x86_quirks->update_genapic)
-				x86_quirks->update_genapic();
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
-		}
-	}
-#endif
-}
-
-void __init generic_apic_probe(void)
-{
-	if (!cmdline_apic) {
-		int i;
-		for (i = 0; apic_probe[i]; i++) {
-			if (apic_probe[i]->probe()) {
-				apic = apic_probe[i];
-				break;
-			}
-		}
-		/* Not visible without early console */
-		if (!apic_probe[i])
-			panic("Didn't find an APIC driver");
-
-		if (x86_quirks->update_genapic)
-			x86_quirks->update_genapic();
-	}
-	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
-}
-
-/* These functions can switch the APIC even after the initial ->probe() */
-
-int __init
-generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
-{
-	int i;
-
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->mps_oem_check)
-			continue;
-		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
-			continue;
-
-		if (!cmdline_apic) {
-			apic = apic_probe[i];
-			if (x86_quirks->update_genapic)
-				x86_quirks->update_genapic();
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
-		}
-		return 1;
-	}
-	return 0;
-}
-
-int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	int i;
-
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->acpi_madt_oem_check)
-			continue;
-		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
-			continue;
-
-		if (!cmdline_apic) {
-			apic = apic_probe[i];
-			if (x86_quirks->update_genapic)
-				x86_quirks->update_genapic();
-			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-			       apic->name);
-		}
-		return 1;
-	}
-	return 0;
-}
-- 
1.6.0.2

