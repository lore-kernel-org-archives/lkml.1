Return-Path: <linux-kernel-owner+w=401wt.eu-S934276AbZJMULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbZJMULI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761205AbZJMULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:11:05 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59149 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZJMULC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=nDBz4dIQ21ubMKjiajW6S8riNKibboJOmCdND0OZsOnBuY93jDY/njmLEFp0gaW0Em
         8Fu7rFTPXr+7NEkFktjetBo6C0axGmMEX5U/H9zOxmNONziZewyIvxc32s45PzueSLI7
         Kb17P3xNNnbwbm4uTip8cbJVF32L1UBmPM9Ro=
Message-Id: <20091013201022.534682104@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 00:07:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/3] x86,apic: introduce NOOP apic driver
References: <20091013200702.019870576@openvz.org>
Content-Disposition: inline; filename=x86-apic-noop-v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce NOOP APIC driver. We should use it in case if apic was disabled
due to hardware of software/firmware problems (including user requested
to disable it case).

The driver is attempting to catch any inappropriate apic operation
call with warning issue.

Also it is possible to use some apic operation like IPI calls, read/write
without checking for apic presence which should make callers code easier.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apic.h      |    2 
 arch/x86/kernel/apic/Makefile    |    2 
 arch/x86/kernel/apic/apic_noop.c |  194 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 197 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -488,6 +488,8 @@ static inline unsigned int read_apic_id(
 
 extern void default_setup_apic_routing(void);
 
+extern struct apic apic_noop;
+
 #ifdef CONFIG_X86_32
 
 extern struct apic apic_default;
Index: linux-2.6.git/arch/x86/kernel/apic/Makefile
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/Makefile
+++ linux-2.6.git/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,7 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o probe_$(BITS).o ipi.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -0,0 +1,194 @@
+/*
+ * NOOP APIC driver.
+ *
+ * Does almost nothing and should be substituted by a real apic driver via
+ * probe routine.
+ *
+ * Though in case if apic is disabled (for some reason) we try
+ * to not uglify the caller's code and allow to call (some) apic routines
+ * like self-ipi, etc... and issue a warning if an operation is not allowed
+ */
+
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <asm/fixmap.h>
+#include <asm/mpspec.h>
+#include <asm/apicdef.h>
+#include <asm/apic.h>
+#include <asm/setup.h>
+
+#include <linux/smp.h>
+#include <asm/ipi.h>
+
+#include <linux/interrupt.h>
+#include <asm/acpi.h>
+#include <asm/e820.h>
+
+/*
+ * some operations should never be reached with
+ * noop apic if it's not turned off, this mostly
+ * means the caller forgot to disable apic (or
+ * check the apic presence) before doing a call
+ */
+static void warn_apic_enabled(void)
+{
+	WARN_ONCE((cpu_has_apic || !disable_apic),
+		"APIC: Called for NOOP operation with apic enabled\n");
+}
+
+/*
+ * To check operations but do not bloat source code
+ */
+#define NOOP_FUNC(func)			func { warn_apic_enabled(); }
+#define NOOP_FUNC_RET(func, ret)	func { warn_apic_enabled(); return ret; }
+
+NOOP_FUNC(static void noop_init_apic_ldr(void))
+NOOP_FUNC(static void noop_send_IPI_mask(const struct cpumask *cpumask, int vector))
+NOOP_FUNC(static void noop_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector))
+NOOP_FUNC(static void noop_send_IPI_allbutself(int vector))
+NOOP_FUNC(static void noop_send_IPI_all(int vector))
+NOOP_FUNC(static void noop_send_IPI_self(int vector))
+NOOP_FUNC_RET(static int noop_wakeup_secondary_cpu(int apicid, unsigned long start_eip), -1)
+NOOP_FUNC(static void noop_apic_write(u32 reg, u32 v))
+NOOP_FUNC(void noop_apic_wait_icr_idle(void))
+NOOP_FUNC_RET(static u32 noop_safe_apic_wait_icr_idle(void), 0)
+NOOP_FUNC_RET(static u64 noop_apic_icr_read(void), 0)
+NOOP_FUNC(static void noop_apic_icr_write(u32 low, u32 id))
+NOOP_FUNC_RET(static physid_mask_t noop_ioapic_phys_id_map(physid_mask_t phys_map), phys_map)
+NOOP_FUNC_RET(static int noop_cpu_to_logical_apicid(int cpu), 1)
+NOOP_FUNC_RET(static int noop_default_phys_pkg_id(int cpuid_apic, int index_msb), 0)
+NOOP_FUNC_RET(static unsigned int noop_get_apic_id(unsigned long x), 0)
+
+static int noop_probe(void)
+{
+	/* should not ever be enabled this way */
+	return 0;
+}
+
+static int noop_apic_id_registered(void)
+{
+	warn_apic_enabled();
+	return physid_isset(read_apic_id(), phys_cpu_present_map);
+}
+
+static const struct cpumask *noop_target_cpus(void)
+{
+	warn_apic_enabled();
+
+	/* only BSP here */
+	return cpumask_of(0);
+}
+
+static unsigned long noop_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	warn_apic_enabled();
+	return physid_isset(apicid, bitmap);
+}
+
+static unsigned long noop_check_apicid_present(int bit)
+{
+	warn_apic_enabled();
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	warn_apic_enabled();
+	if (cpu != 0)
+		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+int noop_apicid_to_node(int logical_apicid)
+{
+	warn_apic_enabled();
+
+	/* we're always on node 0 */
+	return 0;
+}
+
+static u32 noop_apic_read(u32 reg)
+{
+	/*
+	 * noop-read is always safe until we have
+	 * non-disabled unit
+	 */
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
+	return 0;
+}
+
+struct apic apic_noop = {
+	.name				= "noop",
+	.probe				= noop_probe,
+	.acpi_madt_oem_check		= NULL,
+
+	.apic_id_registered		= noop_apic_id_registered,
+
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all CPUs: */
+	.irq_dest_mode			= 1,
+
+	.target_cpus			= noop_target_cpus,
+	.disable_esr			= 0,
+	.dest_logical			= APIC_DEST_LOGICAL,
+	.check_apicid_used		= noop_check_apicid_used,
+	.check_apicid_present		= noop_check_apicid_present,
+
+	.vector_allocation_domain	= noop_vector_allocation_domain,
+	.init_apic_ldr			= noop_init_apic_ldr,
+
+	.ioapic_phys_id_map		= noop_ioapic_phys_id_map,
+	.setup_apic_routing		= NULL,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= noop_apicid_to_node,
+
+	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+
+	.phys_pkg_id			= noop_default_phys_pkg_id,
+
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= noop_get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= 0x0F << 24,
+
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= noop_send_IPI_mask,
+	.send_IPI_mask_allbutself	= noop_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= noop_send_IPI_allbutself,
+	.send_IPI_all			= noop_send_IPI_all,
+	.send_IPI_self			= noop_send_IPI_self,
+
+	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
+
+	/* should be safe */
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+
+	.wait_for_init_deassert		= NULL,
+
+	.smp_callin_clear_local_apic	= NULL,
+	.inquire_remote_apic		= NULL,
+
+	.read				= noop_apic_read,
+	.write				= noop_apic_write,
+	.icr_read			= noop_apic_icr_read,
+	.icr_write			= noop_apic_icr_write,
+	.wait_icr_idle			= noop_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= noop_safe_apic_wait_icr_idle,
+};

