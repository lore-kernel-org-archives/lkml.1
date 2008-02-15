Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbYBOAru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbYBOAru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbYBOAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934898AbYBOAmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/12] PCI: remove pcibious_fixup_ghosts()
Date: Thu, 14 Feb 2008 16:40:09 -0800
Message-Id: <1203036010-27988-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was obviously never being used since early 2.5 days as any
device that it would try to remove would never really be removed from
the system due to the PCI device list being held in the driver core, not
the general list of PCI devices.

As we have not had a single report of a problem here in 4 years, I think
it's safe to remove now.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/frv/mb93090-mb00/pci-vdk.c |   53 --------------------------------------
 arch/x86/pci/common.c           |   54 ---------------------------------------
 2 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index 6d51f13..f003cfa 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -199,58 +199,6 @@ static struct pci_ops * __init pci_check_direct(void)
 }
 
 /*
- * Several buggy motherboards address only 16 devices and mirror
- * them to next 16 IDs. We try to detect this `feature' on all
- * primary buses (those containing host bridges as they are
- * expected to be unique) and remove the ghost devices.
- */
-
-static void __init pcibios_fixup_ghosts(struct pci_bus *b)
-{
-	struct list_head *ln, *mn;
-	struct pci_dev *d, *e;
-	int mirror = PCI_DEVFN(16,0);
-	int seen_host_bridge = 0;
-	int i;
-
-	for (ln=b->devices.next; ln != &b->devices; ln=ln->next) {
-		d = pci_dev_b(ln);
-		if ((d->class >> 8) == PCI_CLASS_BRIDGE_HOST)
-			seen_host_bridge++;
-		for (mn=ln->next; mn != &b->devices; mn=mn->next) {
-			e = pci_dev_b(mn);
-			if (e->devfn != d->devfn + mirror ||
-			    e->vendor != d->vendor ||
-			    e->device != d->device ||
-			    e->class != d->class)
-				continue;
-			for(i=0; i<PCI_NUM_RESOURCES; i++)
-				if (e->resource[i].start != d->resource[i].start ||
-				    e->resource[i].end != d->resource[i].end ||
-				    e->resource[i].flags != d->resource[i].flags)
-					continue;
-			break;
-		}
-		if (mn == &b->devices)
-			return;
-	}
-	if (!seen_host_bridge)
-		return;
-	printk("PCI: Ignoring ghost devices on bus %02x\n", b->number);
-
-	ln = &b->devices;
-	while (ln->next != &b->devices) {
-		d = pci_dev_b(ln->next);
-		if (d->devfn >= mirror) {
-			list_del(&d->global_list);
-			list_del(&d->bus_list);
-			kfree(d);
-		} else
-			ln = ln->next;
-	}
-}
-
-/*
  * Discover remaining PCI buses in case there are peer host bridges.
  * We use the number of last PCI bus provided by the PCI BIOS.
  */
@@ -356,7 +304,6 @@ void __init pcibios_fixup_bus(struct pci_bus *bus)
 #if 0
 	printk("### PCIBIOS_FIXUP_BUS(%d)\n",bus->number);
 #endif
-	pcibios_fixup_ghosts(bus);
 	pci_read_bridge_bases(bus);
 
 	if (bus->number == 0) {
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a67c1fe..86430d1 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -77,59 +77,6 @@ int pcibios_scanned;
  */
 DEFINE_SPINLOCK(pci_config_lock);
 
-/*
- * Several buggy motherboards address only 16 devices and mirror
- * them to next 16 IDs. We try to detect this `feature' on all
- * primary buses (those containing host bridges as they are
- * expected to be unique) and remove the ghost devices.
- */
-
-static void __devinit pcibios_fixup_ghosts(struct pci_bus *b)
-{
-	struct list_head *ln, *mn;
-	struct pci_dev *d, *e;
-	int mirror = PCI_DEVFN(16,0);
-	int seen_host_bridge = 0;
-	int i;
-
-	DBG("PCI: Scanning for ghost devices on bus %d\n", b->number);
-	list_for_each(ln, &b->devices) {
-		d = pci_dev_b(ln);
-		if ((d->class >> 8) == PCI_CLASS_BRIDGE_HOST)
-			seen_host_bridge++;
-		for (mn=ln->next; mn != &b->devices; mn=mn->next) {
-			e = pci_dev_b(mn);
-			if (e->devfn != d->devfn + mirror ||
-			    e->vendor != d->vendor ||
-			    e->device != d->device ||
-			    e->class != d->class)
-				continue;
-			for(i=0; i<PCI_NUM_RESOURCES; i++)
-				if (e->resource[i].start != d->resource[i].start ||
-				    e->resource[i].end != d->resource[i].end ||
-				    e->resource[i].flags != d->resource[i].flags)
-					continue;
-			break;
-		}
-		if (mn == &b->devices)
-			return;
-	}
-	if (!seen_host_bridge)
-		return;
-	printk(KERN_WARNING "PCI: Ignoring ghost devices on bus %02x\n", b->number);
-
-	ln = &b->devices;
-	while (ln->next != &b->devices) {
-		d = pci_dev_b(ln->next);
-		if (d->devfn >= mirror) {
-			list_del(&d->global_list);
-			list_del(&d->bus_list);
-			kfree(d);
-		} else
-			ln = ln->next;
-	}
-}
-
 static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
 {
 	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
@@ -152,7 +99,6 @@ void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
 	struct pci_dev *dev;
 
-	pcibios_fixup_ghosts(b);
 	pci_read_bridge_bases(b);
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);
-- 
1.5.4

