Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYFMVaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYFMVaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYFMV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:29:53 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:39862 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753196AbYFMV3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:29:52 -0400
Date: Fri, 13 Jun 2008 22:29:51 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 2/2] PCI: Expose PCI 2.1 VPD through sysfs
Message-ID: <20080613212950.GB11300@solarflare.com>
References: <cover.1213391292.git.bhutchings@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1213391292.git.bhutchings@solarflare.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI 2.1 specifies a way of storing VPD in the expansion ROM.  Search for
this and expose it through sysfs in the same way as PCI 2.2 VPD.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/pci/pci-sysfs.c |    2 +-
 drivers/pci/pci.h       |    1 +
 drivers/pci/rom.c       |  138 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 271d41c..97ba6a1 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -693,7 +693,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 		goto err;
 
 	/* If the device has VPD, try to expose it in sysfs. */
-	if (pdev->vpd) {
+	if (pdev->vpd || pci_vpd_pci21_init(pdev) == 0) {
 		attr = kzalloc(sizeof(*attr), GFP_ATOMIC);
 		if (attr) {
 			pdev->vpd->attr = attr;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0a497c1..f62ad21 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -30,6 +30,7 @@ struct pci_vpd {
 	struct bin_attribute *attr; /* descriptor for sysfs VPD entry */
 };
 
+extern int pci_vpd_pci21_init(struct pci_dev *dev);
 extern int pci_vpd_pci22_init(struct pci_dev *dev);
 static inline void pci_vpd_release(struct pci_dev *dev)
 {
diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index 94d2afd..f070599 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -283,5 +283,143 @@ void pci_cleanup_rom(struct pci_dev *pdev)
 	}
 }
 
+struct pci_vpd_pci21 {
+	struct pci_vpd base;
+	size_t addr; /* offset within ROM */
+	u16 size;
+};
+
+static int pci_vpd_pci21_read(struct pci_dev *pdev, int pos, int size,
+			      char *buf)
+{
+	struct pci_vpd_pci21 *vpd =
+		container_of(pdev->vpd, struct pci_vpd_pci21, base);
+	void __iomem *rom;
+	size_t win_size;
+	int ret;
+	int i;
+
+	if (pos < 0 || pos > (int)vpd->size || size > vpd->size - pos)
+		return -EINVAL;
+
+	rom = __pci_map_rom(pdev, &win_size);
+	if (!rom)
+		return -EIO;
+	if (vpd->addr > win_size || vpd->size > win_size - vpd->addr) {
+		ret = -EIO;
+		goto out_unmap;
+	}
+
+	memcpy_fromio(buf, rom + vpd->addr + pos, size);
+	ret = size;
+
+out_unmap:
+	pci_unmap_rom(pdev, rom);
+	return ret;
+}
+
+static int pci_vpd_pci21_write(struct pci_dev *pdev, int pos, int size,
+			       const char *buf)
+{
+	return -EROFS;
+}
+
+static int pci_vpd_pci21_get_size(struct pci_dev *pdev)
+{
+	struct pci_vpd_pci21 *vpd =
+		container_of(pdev->vpd, struct pci_vpd_pci21, base);
+	return vpd->size;
+}
+
+static void pci_vpd_pci21_release(struct pci_dev *pdev)
+{
+	kfree(container_of(pdev->vpd, struct pci_vpd_pci21, base));
+}
+
+static struct pci_vpd_ops pci_vpd_pci21_ops = {
+	.read = pci_vpd_pci21_read,
+	.write = pci_vpd_pci21_write,
+	.get_size = pci_vpd_pci21_get_size,
+	.release = pci_vpd_pci21_release
+};
+
+int pci_vpd_pci21_init(struct pci_dev *pdev)
+{
+	struct pci_vpd_pci21 *vpd;
+	void __iomem *rom, *image, *pds;
+	size_t rom_size, image_size, addr = 0, limit = 0;
+	bool last;
+	int ret;
+
+	if (pci_resource_len(pdev, PCI_ROM_RESOURCE) == 0 &&
+	    !(pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW))
+		return -ENODEV;
+
+	rom = __pci_map_rom(pdev, &rom_size);
+	if (!rom)
+		return -ENODEV;
+
+	/* Find first image with VPD */
+	image = rom;
+	for (;;) {
+		image_size = pci_get_rom_image_size(rom, rom_size,
+						    image, &last);
+		if (image_size != 0) {
+			pds = image + readw(image + 24);
+			addr = readw(pds + 8);
+			if (addr != 0 && addr < image_size)
+				break;
+		}
+		if (last) {
+			ret = -ENODEV;
+			goto out_unmap;
+		}
+		image += image_size;
+	}
+	addr += image - rom;
+	limit = image - rom + min_t(size_t, image_size, 1 << 16);
+
+	vpd = kzalloc(sizeof(*vpd), GFP_ATOMIC);
+	if (!vpd) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+	vpd->base.ops = &pci_vpd_pci21_ops;
+	vpd->addr = addr;
+	vpd->size = limit - addr; /* in case we can't find an ending tag */
+	pdev->vpd = &vpd->base;
+	ret = 0;
+
+	/* Follow chain of resources to find VPD size. */
+	for (;;) {
+		u8 tag;
+		u16 res_size;
+
+		tag = readb(rom + addr);
+		if (tag & 0x80) {
+			if (addr > limit - 3)
+				break;
+			res_size = readb(rom + addr + 1);
+			res_size += readb(rom + addr + 2) << 8;
+			addr += 3;
+		} else {
+			res_size = tag & 7;
+			addr += 1;
+			if (res_size == 0) {
+				/* Valid ending tag */
+				vpd->size = addr - vpd->addr;
+				break;
+			}
+		}
+		if (addr >= limit - res_size)
+			break;
+		addr += res_size;
+	}
+
+out_unmap:
+	pci_unmap_rom(pdev, rom);
+	return ret;
+}
+
 EXPORT_SYMBOL(pci_map_rom);
 EXPORT_SYMBOL(pci_unmap_rom);

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
