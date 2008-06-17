Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbYFQWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbYFQWfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759684AbYFQWfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:35:01 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49730 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbYFQWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:34:59 -0400
Date: Wed, 18 Jun 2008 01:33:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       dhowells@redhat.com, gerg@uclinux.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [2.6 patch] remove pcibios_update_resource() functions
Message-ID: <20080617223332.GM25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King did the following back in 2003:

<--  snip  -->

    [PCI] pci-9: Kill per-architecture pcibios_update_resource()
    
    Kill pcibios_update_resource(), replacing it with pci_update_resource().
    pci_update_resource() uses pcibios_resource_to_bus() to convert a
    resource to a device BAR - the transformation should be exactly the
    same as the transformation used for the PCI bridges.
    
    pci_update_resource "knows" about 64-bit BARs, but doesn't attempt to
    set the high 32-bits to anything non-zero - currently no architecture
    attempts to do something different.  If anyone cares, please fix; I'm
    going to reflect current behaviour for the time being.
    
    Ivan pointed out the following architectures need to examine their
    pcibios_update_resource() implementation - they should make sure that
    this new implementation does the right thing.  #warning's have been
    added where appropriate.
    
        ia64
        mips
        mips64
    
    This cset also includes a fix for the problem reported by AKPM where
    64-bit arch compilers complain about the resource mask being placed
    in a u32.

<--  snip  -->


This patch removes the unused pcibios_update_resource() functions the 
kernel gained since.


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/frv/mb93090-mb00/pci-frv.c    |   30 ------------------------
 arch/m68knommu/kernel/comempci.c   |    9 -------
 arch/mips/pmc-sierra/yosemite/ht.c |   36 -----------------------------
 arch/sh/drivers/pci/pci.c          |   32 -------------------------
 4 files changed, 107 deletions(-)

ebd37440bafbb6f9f5ecd6315ac9953cf97f20e9 diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index 4f165c9..edae117 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -19,36 +19,6 @@
 
 #include "pci-frv.h"
 
-#if 0
-void
-pcibios_update_resource(struct pci_dev *dev, struct resource *root,
-			struct resource *res, int resource)
-{
-	u32 new, check;
-	int reg;
-
-	new = res->start | (res->flags & PCI_REGION_FLAG_MASK);
-	if (resource < 6) {
-		reg = PCI_BASE_ADDRESS_0 + 4*resource;
-	} else if (resource == PCI_ROM_RESOURCE) {
-		res->flags |= IORESOURCE_ROM_ENABLE;
-		new |= PCI_ROM_ADDRESS_ENABLE;
-		reg = dev->rom_base_reg;
-	} else {
-		/* Somebody might have asked allocation of a non-standard resource */
-		return;
-	}
-
-	pci_write_config_dword(dev, reg, new);
-	pci_read_config_dword(dev, reg, &check);
-	if ((new ^ check) & ((new & PCI_BASE_ADDRESS_SPACE_IO) ? PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK)) {
-		printk(KERN_ERR "PCI: Error while updating region "
-		       "%s/%d (%08x != %08x)\n", pci_name(dev), resource,
-		       new, check);
-	}
-}
-#endif
-
 /*
  * We need to avoid collisions with `mirrored' VGA ports
  * and other strange ISA hardware, so we always want the
diff --git a/arch/m68knommu/kernel/comempci.c b/arch/m68knommu/kernel/comempci.c
index 6ee00ef..0a68b5a 100644
--- a/arch/m68knommu/kernel/comempci.c
+++ b/arch/m68knommu/kernel/comempci.c
@@ -375,15 +375,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 
 /*****************************************************************************/
 
-void pcibios_update_resource(struct pci_dev *dev, struct resource *root, struct resource *r, int resource)
-{
-	printk(KERN_WARNING "%s(%d): no support for changing PCI resources...\n",
-		__FILE__, __LINE__);
-}
-
-
-/*****************************************************************************/
-
 /*
  *	Local routines to interrcept the standard I/O and vector handling
  *	code. Don't include this 'till now - initialization code above needs
diff --git a/arch/mips/pmc-sierra/yosemite/ht.c b/arch/mips/pmc-sierra/yosemite/ht.c
index 6380662..678388f 100644
--- a/arch/mips/pmc-sierra/yosemite/ht.c
+++ b/arch/mips/pmc-sierra/yosemite/ht.c
@@ -345,42 +345,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
         return pcibios_enable_resources(dev);
 }
 
-
-
-void pcibios_update_resource(struct pci_dev *dev, struct resource *root,
-                             struct resource *res, int resource)
-{
-        u32 new, check;
-        int reg;
-
-        return;
-
-        new = res->start | (res->flags & PCI_REGION_FLAG_MASK);
-        if (resource < 6) {
-                reg = PCI_BASE_ADDRESS_0 + 4 * resource;
-        } else if (resource == PCI_ROM_RESOURCE) {
-		res->flags |= IORESOURCE_ROM_ENABLE;
-                reg = dev->rom_base_reg;
-        } else {
-                /*
-                 * Somebody might have asked allocation of a non-standard
-                 * resource
-                 */
-                return;
-        }
-
-        pci_write_config_dword(dev, reg, new);
-        pci_read_config_dword(dev, reg, &check);
-        if ((new ^ check) &
-            ((new & PCI_BASE_ADDRESS_SPACE_IO) ? PCI_BASE_ADDRESS_IO_MASK :
-             PCI_BASE_ADDRESS_MEM_MASK)) {
-                printk(KERN_ERR "PCI: Error while updating region "
-                       "%s/%d (%08x != %08x)\n", pci_name(dev), resource,
-                       new, check);
-        }
-}
-
-
 void pcibios_align_resource(void *data, struct resource *res,
                             resource_size_t size, resource_size_t align)
 {
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 08d2e73..f57095a 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -76,38 +76,6 @@ void __devinit __weak pcibios_fixup_bus(struct pci_bus *bus)
 	pci_read_bridge_bases(bus);
 }
 
-void
-pcibios_update_resource(struct pci_dev *dev, struct resource *root,
-			struct resource *res, int resource)
-{
-	u32 new, check;
-	int reg;
-
-	new = res->start | (res->flags & PCI_REGION_FLAG_MASK);
-	if (resource < 6) {
-		reg = PCI_BASE_ADDRESS_0 + 4*resource;
-	} else if (resource == PCI_ROM_RESOURCE) {
-		res->flags |= IORESOURCE_ROM_ENABLE;
-		new |= PCI_ROM_ADDRESS_ENABLE;
-		reg = dev->rom_base_reg;
-	} else {
-		/*
-		 * Somebody might have asked allocation of a non-standard
-		 * resource
-		 */
-		return;
-	}
-
-	pci_write_config_dword(dev, reg, new);
-	pci_read_config_dword(dev, reg, &check);
-	if ((new ^ check) & ((new & PCI_BASE_ADDRESS_SPACE_IO) ?
-		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK)) {
-		printk(KERN_ERR "PCI: Error while updating region "
-		       "%s/%d (%08x != %08x)\n", pci_name(dev), resource,
-		       new, check);
-	}
-}
-
 void pcibios_align_resource(void *data, struct resource *res,
 			    resource_size_t size, resource_size_t align)
 			    __attribute__ ((weak));

