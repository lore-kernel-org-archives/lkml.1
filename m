Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXFKQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXFKQvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXFKQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:51:24 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:58572 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXFKQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:51:22 -0400
Date: Mon, 11 Jun 2007 17:51:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de
Message-ID: <20070611165112.GA30272@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [RFC] Runtime allocation of PCI resources
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BIOS authors don't always program all the features of hardware. This is 
often the case for Intel IDE controllers, which are usually able to run 
in AHCI mode but are rarely configured to do so. Reprogramming them is 
easy enough other than the requirement for some MMIO space. If the BIOS 
hasn't allocated this, it's necessary for us to do so manually.

This patch simply attempts to find some free address space and allocate 
it. The function is designed to be called after the rest of the 
resources have been allocated in order to avoid colliding with other 
devices.

This seems to work fine on x86, but I'm happy to admit that I know 
little about the intricacies of how PCI is implemented elsewhere. Is 
this approach valid in the general case? I'm also working on the 
assumption that the firmware will program hotplug PCI hardware in a way 
that isn't going to end up colliding with this. Anyway, any 
thoughts/comments?

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e48fcf0..1e188e8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -126,7 +126,7 @@ static inline unsigned int pci_calc_resource_flags(unsigned int flags)
 /*
  * Find the extent of a PCI decode..
  */
-static u32 pci_size(u32 base, u32 maxbase, u32 mask)
+u32 pci_size(u32 base, u32 maxbase, u32 mask)
 {
 	u32 size = mask & maxbase;	/* Find the significant bits */
 	if (!size)
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 6dfd861..37d484c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -25,6 +25,51 @@
 #include <linux/slab.h>
 #include "pci.h"
 
+int
+pci_allocate_resource(struct pci_dev *dev, int resno)
+{
+	int err;
+	u32 size, mask, reg;
+	resource_size_t start;
+	struct resource *res = &dev->resource[resno];
+	struct resource *bres = pci_find_parent_resource(dev, res);
+
+	if (!bres)
+		return -ENOMEM;
+	
+	if (res->flags & IORESOURCE_IO) {
+		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
+		start = PCIBIOS_MIN_IO;
+	} else {
+		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+		start = PCIBIOS_MIN_MEM;
+	}
+
+	reg = PCI_BASE_ADDRESS_0 + 4 * resno;
+
+	pci_write_config_dword(dev, reg, ~0);
+	pci_read_config_dword(dev, reg, &size);
+
+	if (!size || size == 0xffffffff)
+		return 0;
+
+	size = pci_size(0, size, mask);
+	
+	if (res->start != 0 && res->end != 0)
+		release_resource (res);
+
+	err = allocate_resource (bres, res, size+1, start, ~0U, 1024, NULL,
+				 NULL);
+
+	if (err)
+		return err;
+
+	pci_update_resource (dev, res, resno);
+
+	return 0;
+}
+
+EXPORT_SYMBOL(pci_allocate_resource);
 
 void
 pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fbf3766..502c34e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -549,6 +549,7 @@ void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pci_allocate_resource(struct pci_dev *dev, int resno);
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_assign_resource_fixed(struct pci_dev *dev, int i);
@@ -608,6 +609,7 @@ void pci_remove_behind_bridge(struct pci_dev *);
 struct pci_driver *pci_dev_driver(const struct pci_dev *);
 const struct pci_device_id *pci_match_device(struct pci_driver *drv, struct pci_dev *dev);
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids, struct pci_dev *dev);
+u32 pci_size(u32 base, u32 maxbase, u32 mask);
 int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass);
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),

-- 
Matthew Garrett | mjg59@srcf.ucam.org
