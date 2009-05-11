Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZEKJ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZEKJ4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZEKJyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840AbZEKJyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:54:18 -0400
Date: Mon, 11 May 2009 09:53:00 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, lenb@kernel.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, yinghai@kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A01C422.5070400@kernel.org>
References: <4A01C422.5070400@kernel.org>
Subject: [tip:irq/numa] x86/acpi: move setup io apic routing out of CONFIG_ACPI scope
Message-ID: <tip-5ef2183768bb7d64b85eccbfa1537a61cbefa97c@git.kernel.org>
Git-Commit-ID: 5ef2183768bb7d64b85eccbfa1537a61cbefa97c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:53:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ef2183768bb7d64b85eccbfa1537a61cbefa97c
Gitweb:     http://git.kernel.org/tip/5ef2183768bb7d64b85eccbfa1537a61cbefa97c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 May 2009 10:08:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:35:09 +0200

x86/acpi: move setup io apic routing out of CONFIG_ACPI scope

So we could set io apic routing when ACPI is not enabled.

[ Impact: prepare for new functionality ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C422.5070400@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/io_apic.h |    4 +-
 arch/x86/kernel/apic/io_apic.c |  122 ++++++++++++++++++++--------------------
 2 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 27bd2fd..6fd99f9 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -154,10 +154,10 @@ extern int timer_through_8259;
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
-extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
-				  int irq, int edge_level, int active_high_low);
 #endif /* CONFIG_ACPI */
 
+extern int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin,
+				  int irq, int edge_level, int active_high_low);
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index caf9dbd..3a68dae 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3839,6 +3839,67 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
+static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
+{
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int node;
+
+	if (!IO_APIC_IRQ(irq)) {
+		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
+			ioapic);
+		return -EINVAL;
+	}
+
+	if (dev)
+		node = dev_to_node(dev);
+	else
+		node = cpu_to_node(boot_cpu_id);
+
+	desc = irq_to_desc_alloc_node(irq, node);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+		return 0;
+	}
+
+	/*
+	 * IRQs < 16 are already in the irq_2_pin[] map
+	 */
+	if (irq >= NR_IRQS_LEGACY) {
+		cfg = desc->chip_data;
+		add_pin_to_irq_node(cfg, node, ioapic, pin);
+	}
+
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
+
+	return 0;
+}
+
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
+int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+				 int triggering, int polarity)
+{
+
+	/*
+	 * Avoid pin reprogramming.  PRTs typically include entries
+	 * with redundant pin->gsi mappings (but unique PCI devices);
+	 * we only program the IOAPIC on the first.
+	 */
+	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[ioapic].apicid, pin);
+		return 0;
+	}
+	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
+
+	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
+					 triggering, polarity);
+}
+
 /* --------------------------------------------------------------------------
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
@@ -3933,67 +3994,6 @@ int __init io_apic_get_version(int ioapic)
 }
 #endif
 
-static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
-{
-	struct irq_desc *desc;
-	struct irq_cfg *cfg;
-	int node;
-
-	if (!IO_APIC_IRQ(irq)) {
-		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			ioapic);
-		return -EINVAL;
-	}
-
-	if (dev)
-		node = dev_to_node(dev);
-	else
-		node = cpu_to_node(boot_cpu_id);
-
-	desc = irq_to_desc_alloc_node(irq, node);
-	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc %d\n", irq);
-		return 0;
-	}
-
-	/*
-	 * IRQs < 16 are already in the irq_2_pin[] map
-	 */
-	if (irq >= NR_IRQS_LEGACY) {
-		cfg = desc->chip_data;
-		add_pin_to_irq_node(cfg, node, ioapic, pin);
-	}
-
-	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
-
-	return 0;
-}
-
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
-				 int triggering, int polarity)
-{
-
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[ioapic].apicid, pin);
-		return 0;
-	}
-	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
-
-	return __io_apic_set_pci_routing(dev, ioapic, pin, irq,
-					 triggering, polarity);
-}
-
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
 	int i;
