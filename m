Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYFMQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYFMQyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYFMQxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:53:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23941 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYFMQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:53:28 -0400
Message-Id: <20080613165304.021507599@ldl.fc.hp.com>
References: <20080613165209.507694130@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jun 2008 10:52:10 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/5] ACPI: use dev_printk when possible
Content-Disposition: inline; filename=acpi-dev_printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to use dev_printk().  The most obvious change will
be messages like this:

   -ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 31 (level, low) -> IRQ 31
   +cciss 0000:00:04.0: PCI INTA# -> GSI 31 (level, low) -> IRQ 31

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work11/drivers/acpi/pci_irq.c
===================================================================
--- work11.orig/drivers/acpi/pci_irq.c	2008-06-12 16:53:52.000000000 -0600
+++ work11/drivers/acpi/pci_irq.c	2008-06-13 09:32:19.000000000 -0600
@@ -162,7 +162,7 @@ do_prt_fixups(struct acpi_prt_entry *ent
 		    !strcmp(prt->source, quirk->source) &&
 		    strlen(prt->source) >= strlen(quirk->actual_source)) {
 			printk(KERN_WARNING PREFIX "firmware reports "
-				"%04x:%02x:%02x[%c] connected to %s; "
+				"%04x:%02x:%02x PCI INT%c# connected to %s; "
 				"changing to %s\n",
 				entry->id.segment, entry->id.bus,
 				entry->id.device, 'A' + entry->pin,
@@ -429,7 +429,7 @@ acpi_pci_irq_derive(struct pci_dev *dev,
 {
 	struct pci_dev *bridge = dev;
 	int irq = -1;
-	u8 bridge_pin = 0;
+	u8 bridge_pin = 0, orig_pin = pin;
 
 
 	if (!dev)
@@ -463,8 +463,8 @@ acpi_pci_irq_derive(struct pci_dev *dev,
 	}
 
 	if (irq < 0) {
-		printk(KERN_WARNING PREFIX "Unable to derive IRQ for device %s\n",
-			      pci_name(dev));
+		dev_warn(&dev->dev, "can't derive routing for PCI INT%c#\n",
+			 'A' + orig_pin);
 		return -1;
 	}
 
@@ -487,6 +487,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	int triggering = ACPI_LEVEL_SENSITIVE;
 	int polarity = ACPI_ACTIVE_LOW;
 	char *link = NULL;
+	char link_desc[16];
 	int rc;
 
 
@@ -503,7 +504,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	pin--;
 
 	if (!dev->bus) {
-		printk(KERN_ERR PREFIX "Invalid (NULL) 'bus' field\n");
+		dev_err(&dev->dev, "invalid (NULL) 'bus' field\n");
 		return -ENODEV;
 	}
 
@@ -538,8 +539,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	 * driver reported one, then use it. Exit in any case.
 	 */
 	if (irq < 0) {
-		printk(KERN_WARNING PREFIX "PCI Interrupt %s[%c]: no GSI",
-		       pci_name(dev), ('A' + pin));
+		dev_warn(&dev->dev, "PCI INT%c#: no GSI", 'A' + pin);
 		/* Interrupt Line values above 0xF are forbidden */
 		if (dev->irq > 0 && (dev->irq <= 0xF)) {
 			printk(" - using IRQ %d\n", dev->irq);
@@ -554,21 +554,21 @@ int acpi_pci_irq_enable(struct pci_dev *
 
 	rc = acpi_register_gsi(irq, triggering, polarity);
 	if (rc < 0) {
-		printk(KERN_WARNING PREFIX "PCI Interrupt %s[%c]: failed "
-		       "to register GSI\n", pci_name(dev), ('A' + pin));
+		dev_warn(&dev->dev, "PCI INT%c#: failed to register GSI\n",
+			 'A' + pin);
 		return rc;
 	}
 	dev->irq = rc;
 
-	printk(KERN_INFO PREFIX "PCI Interrupt %s[%c] -> ",
-	       pci_name(dev), 'A' + pin);
-
 	if (link)
-		printk("Link [%s] -> ", link);
+		snprintf(link_desc, sizeof(link_desc), " -> Link[%s]", link);
+	else
+		link_desc[0] = '\0';
 
-	printk("GSI %u (%s, %s) -> IRQ %d\n", irq,
-	       (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
-	       (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
+	dev_info(&dev->dev, "PCI INT%c#%s -> GSI %u (%s, %s) -> IRQ %d\n",
+		 'A' + pin, link_desc, irq,
+		 (triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
+		 (polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
 	return 0;
 }
@@ -616,10 +616,6 @@ void acpi_pci_irq_disable(struct pci_dev
 	 * (e.g. PCI_UNDEFINED_IRQ).
 	 */
 
-	printk(KERN_INFO PREFIX "PCI interrupt for device %s disabled\n",
-	       pci_name(dev));
-
+	dev_info(&dev->dev, "PCI INT%c# disabled\n", 'A' + pin);
 	acpi_unregister_gsi(gsi);
-
-	return;
 }

-- 
