Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYI2P5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYI2P5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYI2P5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:57:15 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2294 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYI2P5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:57:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 1/2] PCI: add pci_resource_enabled()
Date: Mon, 29 Sep 2008 09:56:56 -0600
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Rene Herman <rene.herman@keyaccess.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
References: <200809290953.56565.bjorn.helgaas@hp.com>
In-Reply-To: <200809290953.56565.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809290956.57727.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pci_resource_enabled() to determine whether a PCI BAR is
enabled.  Sometimes firmware leaves PCI BARs unconfigured, and
this interface is a way for the OS to identify that situation.
    
This is based on section 3.5 of the PCI Firmware spec, which says:
    
  Since not all devices may be configured prior to the operating
  system handoff, the operating system needs to know whether a
  specific BAR register has been configured by firmware. The operating
  system makes the determination by checking the I/O Enable, and
  Memory Enable bits in the device's command register, and Expansion
  ROM BAR enable bits. If the enable bit is set, then the corresponding
  resource register has been configured.
    
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1a5fc83..c4c90f8 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,6 +26,32 @@
 #include "pci.h"
 
 
+int pci_resource_enabled(struct pci_dev *dev, int bar)
+{
+	u16 command = 0;
+	u32 addr = 0;
+
+	/*
+	 * Based on section 3.5, "Device State at Firmware/Operating System
+	 * Handoff," in the PCI Firmware spec.
+	 */
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+
+	if (pci_resource_flags(dev, bar) & IORESOURCE_IO)
+		return command & PCI_COMMAND_IO;
+
+	if (command & PCI_COMMAND_MEMORY) {
+		if (bar == PCI_ROM_RESOURCE) {
+			pci_read_config_dword(dev, dev->rom_base_reg, &addr);
+			return addr & PCI_ROM_ADDRESS_ENABLE;
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
 {
 	struct pci_bus_region region;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c0e1400..28ec520 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -796,6 +796,8 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+extern int pci_resource_enabled(struct pci_dev *dev, int bar);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*
@@ -976,6 +978,9 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 						unsigned int devfn)
 { return NULL; }
 
+static inline int pci_resource_enabled(struct pci_dev *dev, int bar)
+{ return 0; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */
