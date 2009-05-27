Return-Path: <linux-kernel-owner+w=401wt.eu-S1763361AbZE0NdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361AbZE0NdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762184AbZE0NdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:33:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761381AbZE0NdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:33:07 -0400
Message-ID: <4A1D40FD.5050102@kernel.org>
Date: Wed, 27 May 2009 22:32:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       towerlexa@gmx.de, Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: [RFC PATCH] pccard: configure CLS on attach
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com> <4A1C8091.4050909@kernel.org> <4A1C86F5.1020603@jp.fujitsu.com>
In-Reply-To: <4A1C86F5.1020603@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 13:32:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For non hotplug PCI devices, the system firmware usually configures
CLS correctly.  For pccard devices system firmware can't do it and
linux PCI layer doesn't do it either leaving it unconfigured.
Unfortunately this leads to poor performanc for certain devices
(sata_sil).  Unless MWI, which requires separate configuration, is to
be used, CLS doesn't affect correctness, so the configuration should
be harmless.

Please note that some other PCI hotplug drivers (shpchp and pciehp)
also configure CLS on hotplug.

THIS IS A RFC PATCH, SO NO SOB.  PLEASE DON'T APPLY YET.

towerlexa, can you please test this patch?

Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: towerlexa@gmx.de
---
 drivers/pci/pci.c        |    3 +--
 drivers/pcmcia/cardbus.c |   23 +++++++++++++++--------
 include/linux/pci.h      |    1 +
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1a91bf9..eafbe01 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1860,8 +1860,7 @@ u8 pci_cache_line_size = PCI_CACHE_LINE_BYTES / 4;
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
-static int
-pci_set_cacheline_size(struct pci_dev *dev)
+int pci_set_cacheline_size(struct pci_dev *dev)
 {
 	u8 cacheline_size;
 
diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index db77e1f..98789c0 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
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
 
@@ -228,7 +235,7 @@ int __ref cb_alloc(struct pcmcia_socket * s)
 	 */
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);
-	cardbus_assign_irqs(bus, s->pci_irq);
+	cardbus_config_irq_and_cls(bus, s->pci_irq);
 
 	/* socket specific tune function */
 	if (s->tune_bridge)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 72698d8..e1a1aa6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -688,6 +688,7 @@ void pci_disable_device(struct pci_dev *dev);
 void pci_set_master(struct pci_dev *dev);
 void pci_clear_master(struct pci_dev *dev);
 int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
+int pci_set_cacheline_size(struct pci_dev *dev);
 #define HAVE_PCI_SET_MWI
 int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
