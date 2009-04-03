Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZDCJRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZDCJRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbZDCJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:16:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:18725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZDCJQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:16:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="678442776"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>
CC: IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 17:15:50 +0800
Subject: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping from
 x2apic
Thread-Topic: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Index: Acm0PMhlOF23xHqtTuqpjWSOSAGnZQ==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt remapping must be enabled before enabling x2apic, but
interrupt remapping doesn't depend on x2apic, it can be used
separately. Enable interrupt remapping in init_dmars even x2apic
is not supported.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   27 ++++++++++++++++++++++-----
 drivers/pci/intel-iommu.c      |    9 +++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 00e6071..8c09f4c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2528,7 +2528,7 @@ static void irq_complete_move(struct irq_desc **descp)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-#ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_X86_X2APIC
 static void ack_x2apic_level(unsigned int irq)
 {
 	ack_x2APIC_irq();
@@ -2538,7 +2538,6 @@ static void ack_x2apic_edge(unsigned int irq)
 {
 	ack_x2APIC_irq();
 }
-
 #endif
 
 static void ack_apic_edge(unsigned int irq)
@@ -2663,13 +2662,31 @@ static struct irq_chip ioapic_chip __read_mostly = {
 };
 
 #ifdef CONFIG_INTR_REMAP
+static void ir_ack_apic_edge(unsigned int irq)
+{
+#ifdef CONFIG_X86_X2APIC
+	if (x2apic_enabled())
+		return ack_x2apic_edge(irq);
+#endif
+	return ack_apic_edge(irq);
+}
+
+static void ir_ack_apic_level(unsigned int irq)
+{
+#ifdef CONFIG_X86_X2APIC
+	if (x2apic_enabled())
+		return ack_x2apic_level(irq);
+#endif
+	return ack_apic_level(irq);
+}
+
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
 	.startup	= startup_ioapic_irq,
 	.mask		= mask_IO_APIC_irq,
 	.unmask		= unmask_IO_APIC_irq,
-	.ack		= ack_x2apic_edge,
-	.eoi		= ack_x2apic_level,
+	.ack		= ir_ack_apic_edge,
+	.eoi		= ir_ack_apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ir_ioapic_affinity_irq,
 #endif
@@ -3399,7 +3416,7 @@ static struct irq_chip msi_ir_chip = {
 	.name		= "IR-PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
-	.ack		= ack_x2apic_edge,
+	.ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= ir_set_msi_irq_affinity,
 #endif
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f3f6865..6e48298 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2067,6 +2067,15 @@ static int __init init_dmars(void)
 		}
 	}
 
+#ifdef CONFIG_INTR_REMAP
+		if (!intr_remapping_enabled) {
+			ret = enable_intr_remapping(0);
+			if (ret)
+				printk(KERN_ERR
+				"IOMMU: enable interrupt remapping failed\n");
+		}
+#endif
+
 	/*
 	 * For each rmrr
 	 *   for each dev attached to rmrr
-- 
1.6.0.4
