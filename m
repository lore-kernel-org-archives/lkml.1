Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbZEFRJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbZEFRJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZEFRJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:09:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:38667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbZEFRJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:09:11 -0400
Message-ID: <4A01C3DD.3050104@kernel.org>
Date: Wed, 06 May 2009 10:07:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 4/7] x86/acpi: move pin_programmed bit map to io_apic.c
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare to call setup_io_apic_routing in pcibios_irq_enable
also remove not needed member apic_id.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c    |   18 ++----------------
 arch/x86/kernel/apic/io_apic.c |   25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -904,10 +904,8 @@ extern int es7000_plat;
 #endif
 
 static struct {
-	int apic_id;
 	int gsi_base;
 	int gsi_end;
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
 int mp_find_ioapic(int gsi)
@@ -996,7 +994,6 @@ void __init mp_register_ioapic(int id, u
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
@@ -1189,7 +1186,7 @@ static int mp_config_acpi_gsi(struct dev
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	save_mp_irq(&mp_irq);
@@ -1224,23 +1221,12 @@ int mp_register_gsi(struct device *dev,
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+		       "%d-%d\n", mp_ioapics[ioapic].apicid,
 		       ioapic_pin);
 		return gsi;
 	}
 	mp_config_acpi_gsi(dev, gsi, triggering, polarity);
 
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-		return gsi;
-	}
-	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 	io_apic_set_pci_routing(dev, ioapic, ioapic_pin, gsi,
 				triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 				polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3923,7 +3923,7 @@ int __init io_apic_get_version(int ioapi
 }
 #endif
 
-int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
+static int __io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 				 int triggering, int polarity)
 {
 	struct irq_desc *desc;
@@ -3960,6 +3960,29 @@ int io_apic_set_pci_routing(struct devic
 	return 0;
 }
 
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
 
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
