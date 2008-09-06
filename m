Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYIFBGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYIFBGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYIFBFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:05:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:2697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYIFBFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,343,1217833200"; 
   d="scan'208";a="613259006"
Message-Id: <20080906010448.703416000@intel.com>
References: <20080906010214.229910000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Sep 2008 18:02:17 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC 3/4] x86: HPET_MSI Basic HPET_MSI setup code
Content-Disposition: inline; filename=hpet_msi_setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic HPET MSI setup code. Routines to perform basic MSI read write
in HPET memory map and setting up irq_chip for HPET MSI.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/kernel/hpet.c    |   54 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/io_apic.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/hpet.h    |   21 +++++++++++++++
 3 files changed, 139 insertions(+)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c	2008-09-05 17:04:12.000000000 -0700
+++ tip/arch/x86/kernel/hpet.c	2008-09-05 17:20:03.000000000 -0700
@@ -6,6 +6,8 @@
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
@@ -25,6 +27,15 @@
 unsigned long hpet_address;
 static void __iomem *hpet_virt_address;
 
+struct hpet_dev {
+	struct clock_event_device evt;
+	unsigned int num;
+	int cpu;
+	unsigned int irq;
+	unsigned int flags;
+	char name[10];
+};
+
 unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
@@ -298,6 +309,49 @@ static int hpet_legacy_next_event(unsign
 }
 
 /*
+ * HPET MSI Support
+ */
+
+void hpet_msi_unmask(unsigned int irq)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+	unsigned long cfg;
+
+	/* unmask it */
+	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
+	cfg |= HPET_TN_FSB;
+	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
+}
+
+void hpet_msi_mask(unsigned int irq)
+{
+	unsigned long cfg;
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	/* mask it */
+	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
+	cfg &= ~HPET_TN_FSB;
+	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
+}
+
+void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
+	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
+}
+
+void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+{
+	struct hpet_dev *hdev = get_irq_data(irq);
+
+	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
+	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
+	msg->address_hi = 0;
+}
+
+/*
  * Clock source related code
  */
 static cycle_t read_hpet(void)
Index: tip/arch/x86/kernel/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/io_apic.c	2008-09-05 17:01:05.000000000 -0700
+++ tip/arch/x86/kernel/io_apic.c	2008-09-05 17:19:54.000000000 -0700
@@ -41,6 +41,7 @@
 #endif
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
+#include <linux/hpet.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -56,6 +57,7 @@
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
+#include <asm/hpet.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
@@ -3521,6 +3523,68 @@ int arch_setup_dmar_msi(unsigned int irq
 }
 #endif
 
+#ifdef CONFIG_HPET_TIMER
+
+#ifdef CONFIG_SMP
+static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	hpet_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	hpet_msi_write(irq, &msg);
+	desc = irq_to_desc(irq);
+	desc->affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip hpet_msi_type = {
+	.name = "HPET_MSI",
+	.unmask = hpet_msi_unmask,
+	.mask = hpet_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = hpet_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_hpet_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+
+	hpet_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
+		"edge");
+	return 0;
+}
+#endif
+
 #endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
Index: tip/include/asm-x86/hpet.h
===================================================================
--- tip.orig/include/asm-x86/hpet.h	2008-09-05 17:01:05.000000000 -0700
+++ tip/include/asm-x86/hpet.h	2008-09-05 17:07:30.000000000 -0700
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__HPET_H
 #define ASM_X86__HPET_H
 
+#include <linux/msi.h>
+
 #ifdef CONFIG_HPET_TIMER
 
 #define HPET_MMAP_SIZE		1024
@@ -10,6 +12,11 @@
 #define HPET_CFG		0x010
 #define HPET_STATUS		0x020
 #define HPET_COUNTER		0x0f0
+
+#define HPET_Tn_CFG(n)		(0x100 + 0x20 * n)
+#define HPET_Tn_CMP(n)		(0x108 + 0x20 * n)
+#define HPET_Tn_ROUTE(n)	(0x110 + 0x20 * n)
+
 #define HPET_T0_CFG		0x100
 #define HPET_T0_CMP		0x108
 #define HPET_T0_ROUTE		0x110
@@ -65,6 +72,20 @@ extern void hpet_disable(void);
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
 
+extern void hpet_msi_unmask(unsigned int irq);
+extern void hpet_msi_mask(unsigned int irq);
+extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+
+#ifdef CONFIG_PCI_MSI
+extern int arch_setup_hpet_msi(unsigned int irq);
+#else
+static inline int arch_setup_hpet_msi(unsigned int irq)
+{
+	return -EINVAL;
+}
+#endif
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 #include <linux/interrupt.h>

-- 

