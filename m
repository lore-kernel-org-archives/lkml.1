Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbYJEQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbYJEQjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbYJEQgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:36:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35291 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759134AbYJEQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:44 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 07/19] mtd: intel_dc21285 switch to ROM API
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:36:44 +0100
Message-ID: <20081005163639.3799.87267.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 98dc624..acf8f24 100644
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

