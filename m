Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZGDFI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZGDFI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 01:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZGDFIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 01:08:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZGDFIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 01:08:46 -0400
Message-ID: <4A4EE430.4030404@kernel.org>
Date: Sat, 04 Jul 2009 14:10:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] pccard: configure CLS on attach
References: <4A4EE3E9.7090205@kernel.org> <4A4EE410.4080001@kernel.org>
In-Reply-To: <4A4EE410.4080001@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 05:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For non hotplug PCI devices, the system firmware usually configures
CLS correctly.  For pccard devices system firmware can't do it and
Linux PCI layer doesn't do it either.  Unfortunately this leads to
poor performance for certain devices (sata_sil).  Unless MWI, which
requires separate configuration, is to be used, CLS doesn't affect
correctness, so the configuration should be harmless.

This patch makes pci_set_cacheline_size() always built and export it
and make pccard call it during attach.

Please note that some other PCI hotplug drivers (shpchp and pciehp)
also configure CLS on hotplug.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Axel Birndt <towerlexa@gmx.de>
---
 drivers/pci/pci.c        |   39 +++++++++++++++++++--------------------
 drivers/pcmcia/cardbus.c |   23 +++++++++++++++--------
 include/linux/pci.h      |    1 +
 3 files changed, 35 insertions(+), 28 deletions(-)

Index: work/drivers/pcmcia/cardbus.c
===================================================================
--- work.orig/drivers/pcmcia/cardbus.c
+++ work/drivers/pcmcia/cardbus.c
@@ -184,26 +184,33 @@ fail:
     
 =====================================================================*/
 
-/*
- * Since there is only one interrupt available to CardBus
- * devices, all devices downstream of this device must
- * be using this IRQ.
- */
-static void cardbus_assign_irqs(struct pci_bus *bus, int irq)
+static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
 {
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		u8 irq_pin;
 
+		/*
+		 * Since there is only one interrupt available to
+		 * CardBus devices, all devices downstream of this
+		 * device must be using this IRQ.
+		 */
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq_pin);
 		if (irq_pin) {
 			dev->irq = irq;
 			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
 		}
 
+		/*
+		 * Some controllers transfer very slowly with 0 CLS.
+		 * Configure it.  This may fail as CLS configuration
+		 * is mandatory only for MWI.
+		 */
+		pci_set_cacheline_size(dev);
+
 		if (dev->subordinate)
-			cardbus_assign_irqs(dev->subordinate, irq);
+			cardbus_config_irq_and_cls(dev->subordinate, irq);
 	}
 }
 
@@ -228,7 +235,7 @@ int __ref cb_alloc(struct pcmcia_socket
 	 */
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);
-	cardbus_assign_irqs(bus, s->pci_irq);
+	cardbus_config_irq_and_cls(bus, s->pci_irq);
 
 	/* socket specific tune function */
 	if (s->tune_bridge)
Index: work/drivers/pci/pci.c
===================================================================
--- work.orig/drivers/pci/pci.c
+++ work/drivers/pci/pci.c
@@ -1840,23 +1840,6 @@ void pci_clear_master(struct pci_dev *de
 	__pci_set_master(dev, false);
 }
 
-#ifdef PCI_DISABLE_MWI
-int pci_set_mwi(struct pci_dev *dev)
-{
-	return 0;
-}
-
-int pci_try_set_mwi(struct pci_dev *dev)
-{
-	return 0;
-}
-
-void pci_clear_mwi(struct pci_dev *dev)
-{
-}
-
-#else
-
 /**
  * pci_set_cacheline_size - ensure the CACHE_LINE_SIZE register is programmed
  * @dev: the PCI device for which MWI is to be enabled
@@ -1867,13 +1850,12 @@ void pci_clear_mwi(struct pci_dev *dev)
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
-static int
-pci_set_cacheline_size(struct pci_dev *dev)
+int pci_set_cacheline_size(struct pci_dev *dev)
 {
 	u8 cacheline_size;
 
 	if (!pci_cache_line_size)
-		return -EINVAL;		/* The system doesn't support MWI. */
+		return -EINVAL;
 
 	/* Validate current setting: the PCI_CACHE_LINE_SIZE must be
 	   equal to or multiple of the right value. */
@@ -1895,6 +1877,23 @@ pci_set_cacheline_size(struct pci_dev *d
 	return -EINVAL;
 }
 
+#ifdef PCI_DISABLE_MWI
+int pci_set_mwi(struct pci_dev *dev)
+{
+	return 0;
+}
+
+int pci_try_set_mwi(struct pci_dev *dev)
+{
+	return 0;
+}
+
+void pci_clear_mwi(struct pci_dev *dev)
+{
+}
+
+#else
+
 /**
  * pci_set_mwi - enables memory-write-invalidate PCI transaction
  * @dev: the PCI device for which MWI is enabled
Index: work/include/linux/pci.h
===================================================================
--- work.orig/include/linux/pci.h
+++ work/include/linux/pci.h
@@ -697,6 +697,7 @@ void pci_disable_device(struct pci_dev *
 void pci_set_master(struct pci_dev *dev);
 void pci_clear_master(struct pci_dev *dev);
 int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
+int pci_set_cacheline_size(struct pci_dev *dev);
 #define HAVE_PCI_SET_MWI
 int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
