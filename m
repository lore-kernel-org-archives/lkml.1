Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZCDF5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZCDF5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 00:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZCDF5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 00:57:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33678 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZCDF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 00:57:09 -0500
Date: Wed, 4 Mar 2009 05:57:05 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
cc: greg@kroah.com
Subject: [PATCH] pci: expose boot VGA device via sysfs.
Message-ID: <alpine.DEB.2.00.0903040555490.28485@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X really would like to know which VGA device was considered the boot
device by the system. The x86 PCI fixups have support for discovering this
but we provide no way to expose it to userspace.

This adds a sysfs file per VGA class device which has the value 0 for
non the boot device or unknown, and 1 if the VGA device is the boot device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/pci/pci-sysfs.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index dfc4e0d..52afb3a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -241,6 +241,17 @@ struct device_attribute pci_dev_attrs[] = {
 };
 
 static ssize_t
+boot_vga_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%u\n",
+		!!(pdev->resource[PCI_ROM_RESOURCE].flags &
+		   IORESOURCE_ROM_SHADOW));
+}
+struct device_attribute vga_attr = __ATTR_RO(boot_vga);
+
+static ssize_t
 pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
@@ -884,18 +895,27 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 		pdev->rom_attr = attr;
 	}
 
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {
+		retval = device_create_file(&pdev->dev, &vga_attr);
+		if (retval)
+			goto err_rom_file;
+	}
+
 	/* add platform-specific attributes */
 	retval = pcibios_add_platform_entries(pdev);
 	if (retval)
-		goto err_rom_file;
+		goto err_vga_file;
 
 	/* add sysfs entries for various capabilities */
 	retval = pci_create_capabilities_sysfs(pdev);
 	if (retval)
-		goto err_rom_file;
+		goto err_vga_file;
 
 	return 0;
 
+err_vga_file:
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
+		device_remove_file(&pdev->dev, &vga_attr);
 err_rom_file:
 	if (rom_size) {
 		sysfs_remove_bin_file(&pdev->dev.kobj, pdev->rom_attr);
-- 
1.6.0.3

