Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYIWQZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYIWQZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYIWQZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:25:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59845 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752034AbYIWQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:25:22 -0400
Date: Tue, 23 Sep 2008 17:25:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: Export the ROM enable/disable helpers and use them in
 mtd
Message-ID: <20080923172510.37419440@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some other future conversions to follow if folks are ok with
this interface being exported.


mtd: intel_dc21285 switch to ROM API

From: Alan Cox <alan@redhat.com>

Expose the needed helpers and it becomes a nice
simple switch over. Closes #9420

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/mtd/maps/pci.c |   16 +++-------------
 drivers/pci/rom.c      |    6 ++++--
 include/linux/pci.h    |    2 ++
 3 files changed, 9 insertions(+), 15 deletions(-)


diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index 5c6a25c..d978c2e 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -203,15 +203,8 @@ intel_dc21285_init(struct pci_dev *dev, struct map_pci_info *map)
 		 * not enabled, should we be allocating a new resource for it
 		 * or simply enabling it?
 		 */
-		if (!(pci_resource_flags(dev, PCI_ROM_RESOURCE) &
-				    IORESOURCE_ROM_ENABLE)) {
-		     	u32 val;
-			pci_resource_flags(dev, PCI_ROM_RESOURCE) |= IORESOURCE_ROM_ENABLE;
-			pci_read_config_dword(dev, PCI_ROM_ADDRESS, &val);
-			val |= PCI_ROM_ADDRESS_ENABLE;
-			pci_write_config_dword(dev, PCI_ROM_ADDRESS, val);
-			printk("%s: enabling expansion ROM\n", pci_name(dev));
-		}
+		pci_enable_rom(dev);
+		printk("%s: enabling expansion ROM\n", pci_name(dev));
 	}
 
 	if (!len || !base)
@@ -240,10 +233,7 @@ intel_dc21285_exit(struct pci_dev *dev, struct map_pci_info *map)
 	/*
 	 * We need to undo the PCI BAR2/PCI ROM BAR address alteration.
 	 */
-	pci_resource_flags(dev, PCI_ROM_RESOURCE) &= ~IORESOURCE_ROM_ENABLE;
-	pci_read_config_dword(dev, PCI_ROM_ADDRESS, &val);
-	val &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(dev, PCI_ROM_ADDRESS, val);
+	pci_disable_rom(dev);
 }
 
 static unsigned long
diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index bd5c0e0..1f5f614 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -21,7 +21,7 @@
  * between the ROM and other resources, so enabling it may disable access
  * to MMIO registers or other card memory.
  */
-static int pci_enable_rom(struct pci_dev *pdev)
+int pci_enable_rom(struct pci_dev *pdev)
 {
 	struct resource *res = pdev->resource + PCI_ROM_RESOURCE;
 	struct pci_bus_region region;
@@ -45,7 +45,7 @@ static int pci_enable_rom(struct pci_dev *pdev)
  * Disable ROM decoding on a PCI device by turning off the last bit in the
  * ROM BAR.
  */
-static void pci_disable_rom(struct pci_dev *pdev)
+void pci_disable_rom(struct pci_dev *pdev)
 {
 	u32 rom_addr;
 	pci_read_config_dword(pdev, pdev->rom_base_reg, &rom_addr);
@@ -260,3 +260,5 @@ void pci_cleanup_rom(struct pci_dev *pdev)
 
 EXPORT_SYMBOL(pci_map_rom);
 EXPORT_SYMBOL(pci_unmap_rom);
+EXPORT_SYMBOL_GPL(pci_enable_rom);
+EXPORT_SYMBOL_GPL(pci_disable_rom);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c0e1400..7a4cee0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -631,6 +631,8 @@ int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
 /* ROM control related routines */
+int pci_enable_rom(struct pci_dev *pdev);
+void pci_disable_rom(struct pci_dev *pdev);
 void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
 void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom);
 size_t pci_get_rom_size(void __iomem *rom, size_t size);
