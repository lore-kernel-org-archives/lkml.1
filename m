Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYHRM2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYHRM2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYHRM23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:28:29 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:43848 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYHRM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:28:28 -0400
Date: Mon, 18 Aug 2008 14:28:22 +0200
From: Marc Zyngier <maz@misterjones.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Sparse RAM MTD map support
Message-ID: <20080818142822.0d495932@not-of-this-earth.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds an MTD device for accessing an 8bit RAM plugged to
a 16bit or 32bit bus, or a 16bit RAM plugged to a 32bit bus.

Tested on an Xscale PXA-255 board, with a 256KB 8bit static
RAM plugged to a 16bit data bus.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
---
 drivers/mtd/maps/Kconfig       |   10 ++
 drivers/mtd/maps/Makefile      |    1 +
 drivers/mtd/maps/sparse_ram.c  |  319 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/sparse_ram.h |   19 +++
 4 files changed, 349 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/maps/sparse_ram.c
 create mode 100644 include/linux/mtd/sparse_ram.h

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index df8e00b..274e4b8 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -571,5 +571,15 @@ config MTD_PLATRAM
 
 	  This selection automatically selects the map_ram driver.
 
+config MTD_SPARSE_RAM
+	tristate "Sparse mapping for a 8/16 bit RAM on a 16/32 bit bus"
+	depends on MTD
+	select MTD_RAM
+	select MTD_MAP_BANK_WIDTH_1
+	select MTD_MAP_BANK_WIDTH_2
+	select MTD_COMPLEX_MAPPINGS
+	help
+	  This adds an MTD device for accessing an 8bit RAM plugged to
+	  a 16bit or 32bit bus, or a 16bit RAM plugged to a 32bit bus.
 endmenu
 
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 6cda6df..074b0e1 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -65,3 +65,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
 obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
+obj-$(CONFIG_MTD_SPARSE_RAM)	+= sparse_ram.o
diff --git a/drivers/mtd/maps/sparse_ram.c b/drivers/mtd/maps/sparse_ram.c
new file mode 100644
index 0000000..a05f353
--- /dev/null
+++ b/drivers/mtd/maps/sparse_ram.c
@@ -0,0 +1,319 @@
+/*
+ * Sparse 8/16 bit RAM map driver.
+ * Copyright (C) 2008 Marc Zyngier <maz@misterjones.org>
+ *
+ * Heavily based on:
+ *   PXA2xx external 8 bit SRAM MTD map driver.
+ *   Copyright (C) 2005 Arcom Control Systems Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/sparse_ram.h>
+
+static inline long sparse_ram_read_16(struct map_info *map, unsigned long ofs)
+{
+	int offset = map->map_priv_1;
+	return __raw_readw(map->virt + (ofs << 1)) >> offset;
+}
+
+static inline long sparse_ram_read_32(struct map_info *map, unsigned long ofs)
+{
+	int offset = map->map_priv_1;
+	return __raw_readl(map->virt + (ofs << 2)) >> offset;
+}
+
+static map_word sparse_ram_read_8_16(struct map_info *map, unsigned long ofs)
+{
+	map_word ret;
+	ret.x[0] = sparse_ram_read_16(map, ofs) & 0xFF;
+	return ret;
+}
+
+static map_word sparse_ram_read_8_32(struct map_info *map, unsigned long ofs)
+{
+	map_word ret;
+	ret.x[0] = sparse_ram_read_32(map, ofs) & 0xFF;
+	return ret;
+}
+
+static map_word sparse_ram_read_16_32(struct map_info *map, unsigned long ofs)
+{
+	map_word ret;
+	ret.x[0] = sparse_ram_read_32(map, ofs) & 0xFFFF;
+	return ret;
+}
+
+static inline void sparse_ram_write_16(struct map_info *map, __u16 data,
+				       unsigned long ofs)
+{
+	__raw_writew(data, map->virt + (ofs << 1));
+}
+
+static inline void sparse_ram_write_32(struct map_info *map, __u32 data,
+				       unsigned long ofs)
+{
+	__raw_writel(data, map->virt + (ofs << 2));
+}
+
+static void sparse_ram_write_8_16(struct map_info *map, const map_word d,
+				  unsigned long ofs)
+{
+	int offset = map->map_priv_1;
+	sparse_ram_write_16(map, d.x[0] << offset, ofs);
+}
+
+static void sparse_ram_write_8_32(struct map_info *map, const map_word d,
+				  unsigned long ofs)
+{
+	int offset = map->map_priv_1;
+	sparse_ram_write_32(map, d.x[0] << offset, ofs);
+}
+
+static void sparse_ram_copy_from_8_16(struct map_info *map, void *to,
+				      unsigned long from, ssize_t len)
+{
+	__u8 *dst = (__u8 *)to;
+
+	while (len) {
+		*dst = sparse_ram_read_16(map, from) & 0xFF;
+		len--; dst++; from++;
+	}
+}
+
+static void sparse_ram_copy_from_8_32(struct map_info *map, void *to,
+				      unsigned long from, ssize_t len)
+{
+	__u8 *dst = (__u8 *)to;
+
+	while (len) {
+		*dst = sparse_ram_read_32(map, from) & 0xFF;
+		len--; dst++; from++;
+	}
+}
+
+static void sparse_ram_copy_from_16_32(struct map_info *map, void *to,
+				       unsigned long from, ssize_t len)
+{
+	__u16 *dst = (__u16 *)to;
+
+	BUG_ON(len & 1 || from & 1 || (unsigned long)to & 1);
+
+	len >>= 1;
+	while (len) {
+		*dst = sparse_ram_read_32(map, from) & 0xFFFF;
+		len--; dst++; from += 2;
+	}
+}
+
+static void sparse_ram_copy_to_8_16(struct map_info *map, unsigned long to,
+				    const void *from, ssize_t len)
+{
+	__u8 *src = (__u8 *)from;
+	int offset = map->map_priv_1;
+
+	while (len) {
+		sparse_ram_write_16(map, *src << offset, to);
+		len--; to++; src++;
+	}
+}
+
+static void sparse_ram_copy_to_8_32(struct map_info *map, unsigned long to,
+				    const void *from, ssize_t len)
+{
+	__u8 *src = (__u8 *)from;
+	int offset = map->map_priv_1;
+
+	while (len) {
+		sparse_ram_write_32(map, *src << offset, to);
+		len--; to++; src++;
+	}
+}
+
+static void sparse_ram_copy_to_16_32(struct map_info *map, unsigned long to,
+				     const void *from, ssize_t len)
+{
+	__u16 *src = (__u16 *)from;
+	int offset = map->map_priv_1;
+
+	BUG_ON(len & 1 || to & 1 || (unsigned long)from & 1);
+
+	len >>= 1;
+	while (len) {
+		sparse_ram_write_32(map, *src << offset, to);
+		len--; to += 2; src++;
+	}
+}
+
+struct sparse_ram {
+	struct mtd_info *mtd;
+	struct map_info  map;
+	struct resource *res;
+};
+
+static int sparse_ram_remove(struct platform_device *dev)
+{
+	struct sparse_ram *info = platform_get_drvdata(dev);
+
+	if (!info)
+		return 0;
+
+	if (info->mtd) {
+		del_mtd_device(info->mtd);
+		map_destroy(info->mtd);
+	}
+	if (info->map.virt)
+		iounmap(info->map.virt);
+	if (info->res) {
+		release_resource(info->res);
+		kfree(info->res);
+	}
+
+	kfree(info);
+
+	return 0;
+}
+
+
+static int sparse_ram_probe(struct platform_device *dev)
+{
+	struct sparse_ram_data *data = dev->dev.platform_data;
+	struct sparse_ram *info;
+	resource_size_t res_size;
+	int err;
+
+	if (!data) {
+		dev_err(&dev->dev, "No platform data\n");
+		err = -ENODEV;
+		goto error;
+	}
+
+	info = kzalloc(sizeof(struct sparse_ram), GFP_KERNEL);
+	if (!info) {
+		dev_err(&dev->dev, "Out of memory\n");
+		err = -ENOMEM;
+		goto error;
+	}
+
+	platform_set_drvdata(dev, info);
+
+	res_size = dev->resource->end - dev->resource->start + 1;
+	info->map.phys = NO_XIP;
+	info->map.size = res_size / (data->access / data->width);
+	info->map.bankwidth = data->width;
+	info->map.map_priv_1 = data->offset;
+	info->map.name = data->name;
+
+	if (!((data->width == 1 && (data->access == 2 || data->access == 4)) ||
+	      (data->width == 2 && data->access == 4))) {
+		dev_err(&dev->dev, "Invalid width %d access %d combinaison\n",
+			data->width, data->access);
+		err = -EINVAL;
+		goto error;
+	}
+
+	if (data->access == 2) {
+		info->map.read = sparse_ram_read_8_16;
+		info->map.copy_from = sparse_ram_copy_from_8_16;
+		info->map.write = sparse_ram_write_8_16;
+		info->map.copy_to = sparse_ram_copy_to_8_16;
+	} else {
+		info->map.write = sparse_ram_write_8_32;
+		if (data->width == 1) {
+			info->map.read = sparse_ram_read_8_32;
+			info->map.copy_from = sparse_ram_copy_from_8_32;
+			info->map.copy_to = sparse_ram_copy_to_8_32;
+		} else {
+			info->map.read = sparse_ram_read_16_32;
+			info->map.copy_from = sparse_ram_copy_from_16_32;
+			info->map.copy_to = sparse_ram_copy_to_16_32;
+		}
+	}
+
+	info->res = request_mem_region(dev->resource->start,
+				       res_size, "sparse_ram");
+	if (!info->res) {
+		dev_err(&dev->dev, "Memory region in use\n");
+		err = -ENOMEM;
+		goto error;
+	}
+
+	info->map.virt = ioremap(info->res->start, res_size);
+	if (!info->map.virt) {
+		dev_err(&dev->dev, "ioremap failed\n");
+		err = -EIO;
+		goto error;
+	}
+
+	dev_info(&dev->dev, "Probing %dbit RAM on a %dbit bus %.8llx@%.8llx\n",
+		data->width * 8, data->access * 8,
+		(unsigned long long) res_size,
+		(unsigned long long) info->res->start);
+
+	info->mtd = do_map_probe("map_ram", &info->map);
+	if (!info->mtd) {
+		dev_err(&dev->dev, "RAM not found\n");
+		err = -ENXIO;
+		goto error;
+	}
+
+	info->mtd->owner = THIS_MODULE;
+
+	add_mtd_device(info->mtd);
+
+	return 0;
+
+error:
+	sparse_ram_remove(dev);
+	return err;
+}
+
+static struct platform_driver sparse_ram_driver = {
+	.probe          = sparse_ram_probe,
+	.remove         = sparse_ram_remove,
+	.driver		= {
+		.name	= "sparse-ram",
+	}
+};
+
+static int __init sparse_ram_init(void)
+{
+	return platform_driver_register(&sparse_ram_driver);
+}
+
+static void __exit sparse_ram_exit(void)
+{
+	platform_driver_unregister(&sparse_ram_driver);
+}
+
+module_init(sparse_ram_init);
+module_exit(sparse_ram_exit);
+
+MODULE_ALIAS("platform:sparse-ram");
+MODULE_AUTHOR("Marc Zyngier <maz@misterjones.org>");
+MODULE_DESCRIPTION("Sparse RAM map driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mtd/sparse_ram.h b/include/linux/mtd/sparse_ram.h
new file mode 100644
index 0000000..28315b4
--- /dev/null
+++ b/include/linux/mtd/sparse_ram.h
@@ -0,0 +1,19 @@
+#ifndef __LINUX_MTD_SPARSE_RAM_H
+#define __LINUX_MTD_SPARSE_RAM_H __FILE__
+
+/*
+ * width  : RAM width, in bytes (1 for 8 bits, 2 for 16 bits)
+ * access : Bus width, in bytes (2 for 16 bits, 32 bits)
+ * offset : Data position within a bus word, in bits
+ *
+ * Device size will be computed from resource, width and access.
+ */
+
+struct sparse_ram_data {
+	const char   *name;
+	unsigned int  width;
+	unsigned int  access;
+	unsigned int  offset;
+};
+
+#endif /* __LINUX_MTD_SPARSE_RAM_H */
-- 
1.5.4.3


-- 
A rat a day keeps the plague away.
