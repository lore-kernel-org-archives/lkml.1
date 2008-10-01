Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYJALo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYJALo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYJALoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:44:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40712 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbYJALoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:44:17 -0400
Date: Wed, 1 Oct 2008 06:44:15 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq() functions
Message-ID: <20081001114415.GA3281@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a means for UV interrupt MMRs to be setup with the message to be sent
when an MSI is raised.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

This functionality is needed by drivers/misc/sgi-xp. And a patch will be
submitted shortly.

 arch/x86/kernel/Makefile    |    2 
 arch/x86/kernel/io_apic.c   |   95 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/uv_irq.c    |   50 +++++++++++++++++++++
 include/asm-x86/uv/uv_irq.h |   34 ++++++++++++++
 kernel/irq/chip.c           |    1 
 5 files changed, 181 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/io_apic.c	2008-09-30 09:07:42.000000000 -0500
+++ linux/arch/x86/kernel/io_apic.c	2008-09-30 12:54:12.000000000 -0500
@@ -58,6 +58,8 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_irq.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
@@ -3694,6 +3696,99 @@ int arch_setup_ht_irq(unsigned int irq, 
 }
 #endif /* CONFIG_HT_IRQ */
 
+#ifdef CONFIG_X86_64
+static void noop(unsigned int irq)
+{
+}
+
+static unsigned int noop_ret(unsigned int irq)
+{
+	return 0;
+}
+
+static void ack_apic(unsigned int irq)
+{
+	ack_APIC_irq();
+}
+
+static struct irq_chip uv_irq_chip = {
+	.name		= "UV_MSI",
+	.startup	= noop_ret,
+	.shutdown	= noop,
+	.enable		= noop,
+	.disable	= noop,
+	.ack		= noop,
+	.mask		= noop,
+	.unmask		= noop,
+	.eoi		= ack_apic,
+	.end		= noop,
+};
+
+/*
+ * Re-target the irq to the specified CPU and enable the specified MMR located
+ * on the specified blade to allow the sending of MSIs to the specified CPU.
+ */
+int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
+		       unsigned long mmr_offset)
+{
+	const cpumask_t *eligible_cpu = get_cpu_mask(cpu);
+	struct irq_cfg *cfg;
+	int mmr_pnode;
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	unsigned long flags;
+	int err;
+
+	err = assign_irq_vector(irq, *eligible_cpu);
+	if (err != 0)
+		return err;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
+				      irq_name);
+	spin_unlock_irqrestore(&vector_lock, flags);
+
+	cfg = irq_cfg(irq);
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
+	entry->vector = cfg->vector;
+	entry->delivery_mode = INT_DELIVERY_MODE;
+	entry->dest_mode = INT_DEST_MODE;
+	entry->polarity = 0;
+	entry->trigger = 0;
+	entry->mask = 0;
+	entry->dest = cpu_mask_to_apicid(*eligible_cpu);
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+
+	return irq;
+}
+
+/*
+ * Disable the specified MMR located on the specified blade so that MSIs are
+ * longer allowed to be sent.
+ */
+void arch_disable_uv_irq(int mmr_blade, unsigned long mmr_offset)
+{
+	unsigned long mmr_value;
+	struct uv_IO_APIC_route_entry *entry;
+	int mmr_pnode;
+
+	mmr_value = 0;
+	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
+	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
+
+	entry->mask = 1;
+
+	mmr_pnode = uv_blade_to_pnode(mmr_blade);
+	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
+}
+#endif /* CONFIG_X86_64 */
+
 int __init io_apic_get_redir_entries (int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c	2008-09-30 09:07:42.000000000 -0500
+++ linux/kernel/irq/chip.c	2008-09-30 09:07:44.000000000 -0500
@@ -79,6 +79,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->name = "none";
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
Index: linux/arch/x86/kernel/uv_irq.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/uv_irq.c	2008-10-01 06:35:31.000000000 -0500
@@ -0,0 +1,50 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * SGI UV IRQ functions
+ *
+ * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <asm/uv/uv_irq.h>
+
+/*
+ * Set up a mapping of an available irq and vector, and enable the specified
+ * MMR that defines the MSI that is to be sent to the specified CPU when an
+ * interrupt is raised.
+ */
+int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
+		 unsigned long mmr_offset)
+{
+	int irq;
+	int ret;
+
+	irq = create_irq();
+	if (irq <= 0)
+		return -EBUSY;
+
+	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset);
+	if (ret != irq)
+		destroy_irq(irq);
+
+	return ret;
+}
+EXPORT_SYMBOL(uv_setup_irq);
+
+/*
+ * Tear down a mapping of an irq and vector, and disable the specified MMR that
+ * defined the MSI that was to be sent to the specified CPU when an interrupt
+ * was raised.
+ *
+ * Set mmr_blade and mmr_offset to what was passed in on uv_setup_irq().
+ */
+void uv_teardown_irq(unsigned int irq, int mmr_blade, unsigned long mmr_offset)
+{
+	arch_disable_uv_irq(mmr_blade, mmr_offset);
+	destroy_irq(irq);
+}
+EXPORT_SYMBOL(uv_teardown_irq);
Index: linux/include/asm-x86/uv/uv_irq.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/asm-x86/uv/uv_irq.h	2008-09-30 09:07:44.000000000 -0500
@@ -0,0 +1,34 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * SGI UV IRQ definitions
+ *
+ * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
+ */
+
+#ifndef ASM_X86__UV__UV_IRQ_H
+#define ASM_X86__UV__UV_IRQ_H
+
+/* If a generic version of this structure gets defined, eliminate this one. */
+struct uv_IO_APIC_route_entry {
+	__u64	vector		:  8,
+		delivery_mode	:  3,
+		dest_mode	:  1,
+		delivery_status	:  1,
+		polarity	:  1,
+		__reserved_1	:  1,
+		trigger		:  1,
+		mask		:  1,
+		__reserved_2	: 15,
+		dest		: 32;
+};
+
+extern int arch_enable_uv_irq(char *, unsigned int, int, int, unsigned long);
+extern void arch_disable_uv_irq(int, unsigned long);
+
+extern int uv_setup_irq(char *, int, int, unsigned long);
+extern void uv_teardown_irq(unsigned int, int, unsigned long);
+
+#endif /* ASM_X86__UV__UV_IRQ_H */
Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2008-09-30 09:07:42.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2008-09-30 09:07:44.000000000 -0500
@@ -107,7 +107,7 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
-	obj-y				+= bios_uv.o uv_sysfs.o
+	obj-y				+= bios_uv.o uv_sysfs.o uv_irq.o
         obj-y				+= genx2apic_cluster.o
         obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
