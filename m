Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXBUM5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXBUM5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXBUM5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:57:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbXBUM5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:57:10 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] NOMMU: Present backing device capabilities for MTD
	chardevs
To: torvalds@osdl.org, akpm@osdl.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org, dhowells@redhat.com
Date: Wed, 21 Feb 2007 12:56:21 +0000
Message-ID: <20070221125620.10141.71409.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Present backing device capabilities for MTD character device files to allow
NOMMU mmap to do direct mapping where possible.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 drivers/mtd/Makefile         |    2 +
 drivers/mtd/chips/map_ram.c  |   17 +++++++++++
 drivers/mtd/chips/map_rom.c  |   17 +++++++++++
 drivers/mtd/devices/mtdram.c |   14 +++++++++
 drivers/mtd/internal.h       |   17 +++++++++++
 drivers/mtd/mtdbdi.c         |   43 +++++++++++++++++++++++++++++
 drivers/mtd/mtdchar.c        |   63 +++++++++++++++++++++++++++++++++++++++++-
 drivers/mtd/mtdcore.c        |   15 ++++++++++
 drivers/mtd/mtdpart.c        |   15 ++++++++++
 include/linux/mtd/mtd.h      |   14 +++++++++
 10 files changed, 215 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index c130e62..a75b82a 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -4,7 +4,7 @@
 # $Id: Makefile.common,v 1.7 2005/07/11 10:39:27 gleixner Exp $
 
 # Core functionality.
-mtd-y				:= mtdcore.o
+mtd-y				:= mtdcore.o mtdbdi.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 obj-$(CONFIG_MTD)		+= $(mtd-y)
 
diff --git a/drivers/mtd/chips/map_ram.c b/drivers/mtd/chips/map_ram.c
index 5cb6d52..611b035 100644
--- a/drivers/mtd/chips/map_ram.c
+++ b/drivers/mtd/chips/map_ram.c
@@ -22,6 +22,8 @@ static int mapram_write (struct mtd_info *, loff_t, size_t, size_t *, const u_ch
 static int mapram_erase (struct mtd_info *, struct erase_info *);
 static void mapram_nop (struct mtd_info *);
 static struct mtd_info *map_ram_probe(struct map_info *map);
+static unsigned long mapram_unmapped_area(struct mtd_info *, unsigned long,
+					  unsigned long, unsigned long);
 
 
 static struct mtd_chip_driver mapram_chipdrv = {
@@ -65,6 +67,7 @@ static struct mtd_info *map_ram_probe(struct map_info *map)
 	mtd->type = MTD_RAM;
 	mtd->size = map->size;
 	mtd->erase = mapram_erase;
+	mtd->get_unmapped_area = mapram_unmapped_area;
 	mtd->read = mapram_read;
 	mtd->write = mapram_write;
 	mtd->sync = mapram_nop;
@@ -80,6 +83,20 @@ static struct mtd_info *map_ram_probe(struct map_info *map)
 }
 
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long mapram_unmapped_area(struct mtd_info *mtd,
+					  unsigned long len,
+					  unsigned long offset,
+					  unsigned long flags)
+{
+	struct map_info *map = mtd->priv;
+	return (unsigned long) map->virt + offset;
+}
+
 static int mapram_read (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
 	struct map_info *map = mtd->priv;
diff --git a/drivers/mtd/chips/map_rom.c b/drivers/mtd/chips/map_rom.c
index cb27f85..359f61e 100644
--- a/drivers/mtd/chips/map_rom.c
+++ b/drivers/mtd/chips/map_rom.c
@@ -20,6 +20,8 @@ static int maprom_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int maprom_write (struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static void maprom_nop (struct mtd_info *);
 static struct mtd_info *map_rom_probe(struct map_info *map);
+static unsigned long maprom_unmapped_area(struct mtd_info *, unsigned long,
+					  unsigned long, unsigned long);
 
 static struct mtd_chip_driver maprom_chipdrv = {
 	.probe	= map_rom_probe,
@@ -40,6 +42,7 @@ static struct mtd_info *map_rom_probe(struct map_info *map)
 	mtd->name = map->name;
 	mtd->type = MTD_ROM;
 	mtd->size = map->size;
+	mtd->get_unmapped_area = maprom_unmapped_area;
 	mtd->read = maprom_read;
 	mtd->write = maprom_write;
 	mtd->sync = maprom_nop;
@@ -52,6 +55,20 @@ static struct mtd_info *map_rom_probe(struct map_info *map)
 }
 
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long maprom_unmapped_area(struct mtd_info *mtd,
+					  unsigned long len,
+					  unsigned long offset,
+					  unsigned long flags)
+{
+	struct map_info *map = mtd->priv;
+	return (unsigned long) map->virt + offset;
+}
+
 static int maprom_read (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
 	struct map_info *map = mtd->priv;
diff --git a/drivers/mtd/devices/mtdram.c b/drivers/mtd/devices/mtdram.c
index e427c82..438cdb9 100644
--- a/drivers/mtd/devices/mtdram.c
+++ b/drivers/mtd/devices/mtdram.c
@@ -62,6 +62,19 @@ static void ram_unpoint(struct mtd_info *mtd, u_char * addr, loff_t from,
 {
 }
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long ram_get_unmapped_area(struct mtd_info *mtd,
+					   unsigned long len,
+					   unsigned long offset,
+					   unsigned long flags)
+{
+	return (unsigned long) mtd->priv + offset;
+}
+
 static int ram_read(struct mtd_info *mtd, loff_t from, size_t len,
 		size_t *retlen, u_char *buf)
 {
@@ -113,6 +126,7 @@ int mtdram_init_device(struct mtd_info *mtd, void *mapped_address,
 	mtd->erase = ram_erase;
 	mtd->point = ram_point;
 	mtd->unpoint = ram_unpoint;
+	mtd->get_unmapped_area = ram_get_unmapped_area;
 	mtd->read = ram_read;
 	mtd->write = ram_write;
 
diff --git a/drivers/mtd/internal.h b/drivers/mtd/internal.h
new file mode 100644
index 0000000..b366c68
--- /dev/null
+++ b/drivers/mtd/internal.h
@@ -0,0 +1,17 @@
+/* Internal MTD definitions
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * mtdbdi.c
+ */
+extern struct backing_dev_info mtd_bdi_unmappable;
+extern struct backing_dev_info mtd_bdi_ro_mappable;
+extern struct backing_dev_info mtd_bdi_rw_mappable;
diff --git a/drivers/mtd/mtdbdi.c b/drivers/mtd/mtdbdi.c
new file mode 100644
index 0000000..5312377
--- /dev/null
+++ b/drivers/mtd/mtdbdi.c
@@ -0,0 +1,43 @@
+/* MTD backing device capabilities
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/backing-dev.h>
+#include <linux/mtd/mtd.h>
+#include "internal.h"
+
+/*
+ * backing device capabilities for non-mappable devices (such as NAND flash)
+ * - permits private mappings, copies are taken of the data
+ */
+struct backing_dev_info mtd_bdi_unmappable = {
+	.capabilities	= BDI_CAP_MAP_COPY,
+};
+
+/*
+ * backing device capabilities for R/O mappable devices (such as ROM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_ro_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
+};
+
+/*
+ * backing device capabilities for writable mappable devices (such as RAM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_rw_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
+			   BDI_CAP_WRITE_MAP),
+};
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 1592eac..9d064ab 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/compatmac.h>
@@ -104,11 +105,14 @@ static int mtd_open(struct inode *inode, struct file *file)
 	if (IS_ERR(mtd))
 		return PTR_ERR(mtd);
 
-	if (MTD_ABSENT == mtd->type) {
+	if (mtd->type == MTD_ABSENT) {
 		put_mtd_device(mtd);
 		return -ENODEV;
 	}
 
+	if (mtd->backing_dev_info)
+		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
+
 	/* You can't open it RW if it's not a writeable device */
 	if ((file->f_mode & 2) && !(mtd->flags & MTD_WRITEABLE)) {
 		put_mtd_device(mtd);
@@ -760,6 +764,59 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	return ret;
 } /* memory_ioctl */
 
+/*
+ * try to determine where a shared mapping can be made
+ * - only supported for NOMMU at the moment (MMU can't doesn't copy private
+ *   mappings)
+ */
+#ifndef CONFIG_MMU
+static unsigned long mtd_get_unmapped_area(struct file *file,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags)
+{
+	struct mtd_file_info *mfi = file->private_data;
+	struct mtd_info *mtd = mfi->mtd;
+
+	if (mtd->get_unmapped_area) {
+		unsigned long offset;
+
+		if (addr != 0)
+			return (unsigned long) -EINVAL;
+
+		if (len > mtd->size || pgoff >= (mtd->size >> PAGE_SHIFT))
+			return (unsigned long) -EINVAL;
+
+		offset = pgoff << PAGE_SHIFT;
+		if (offset > mtd->size - len)
+			return (unsigned long) -EINVAL;
+
+		return mtd->get_unmapped_area(mtd, len, offset, flags);
+	}
+
+	/* can't map directly */
+	return (unsigned long) -ENOSYS;
+}
+#endif
+
+/*
+ * set up a mapping for shared memory segments
+ */
+static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	struct mtd_file_info *mfi = file->private_data;
+	struct mtd_info *mtd = mfi->mtd;
+
+	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM)
+		return 0;
+	return -ENOSYS;
+#else
+	return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
+#endif
+}
+
 static const struct file_operations mtd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= mtd_lseek,
@@ -768,6 +825,10 @@ static const struct file_operations mtd_fops = {
 	.ioctl		= mtd_ioctl,
 	.open		= mtd_open,
 	.release	= mtd_close,
+	.mmap		= mtd_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = mtd_get_unmapped_area,
+#endif
 };
 
 static int __init init_mtdchar(void)
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c153b64..959f68e 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -21,6 +21,7 @@
 #include <linux/proc_fs.h>
 
 #include <linux/mtd/mtd.h>
+#include "internal.h"
 
 /* These are exported solely for the purpose of mtd_blkdevs.c. You
    should not use them for _anything_ else */
@@ -46,6 +47,20 @@ int add_mtd_device(struct mtd_info *mtd)
 {
 	int i;
 
+	if (!mtd->backing_dev_info) {
+		switch (mtd->type) {
+		case MTD_RAM:
+			mtd->backing_dev_info = &mtd_bdi_rw_mappable;
+			break;
+		case MTD_ROM:
+			mtd->backing_dev_info = &mtd_bdi_ro_mappable;
+			break;
+		default:
+			mtd->backing_dev_info = &mtd_bdi_unmappable;
+			break;
+		}
+	}
+
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
 
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 633def3..230c30b 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -86,6 +86,18 @@ static void part_unpoint (struct mtd_info *mtd, u_char *addr, loff_t from, size_
 	part->master->unpoint (part->master, addr, from + part->offset, len);
 }
 
+static unsigned long part_get_unmapped_area(struct mtd_info *mtd,
+					    unsigned long len,
+					    unsigned long offset,
+					    unsigned long flags)
+{
+	struct mtd_part *part = PART(mtd);
+
+	offset += part->offset;
+	return part->master->get_unmapped_area(part->master, len, offset,
+					       flags);
+}
+
 static int part_read_oob(struct mtd_info *mtd, loff_t from,
 			 struct mtd_oob_ops *ops)
 {
@@ -343,6 +355,7 @@ int add_mtd_partitions(struct mtd_info *master,
 		slave->mtd.name = parts[i].name;
 		slave->mtd.bank_size = master->bank_size;
 		slave->mtd.owner = master->owner;
+		slave->mtd.backing_dev_info = master->backing_dev_info;
 
 		slave->mtd.read = part_read;
 		slave->mtd.write = part_write;
@@ -352,6 +365,8 @@ int add_mtd_partitions(struct mtd_info *master,
 			slave->mtd.unpoint = part_unpoint;
 		}
 
+		if (master->get_unmapped_area)
+			slave->mtd.get_unmapped_area = part_get_unmapped_area;
 		if (master->read_oob)
 			slave->mtd.read_oob = part_read_oob;
 		if (master->write_oob)
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 6a8570b..54168fa 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -146,6 +146,20 @@ struct mtd_info {
 	/* We probably shouldn't allow XIP if the unpoint isn't a NULL */
 	void (*unpoint) (struct mtd_info *mtd, u_char * addr, loff_t from, size_t len);
 
+	/* Allow NOMMU mmap() to directly map the device (if not NULL)
+	 * - return the address to which the offset maps
+	 * - return -ENOSYS to indicate refusal to do the mapping
+	 */
+	unsigned long (*get_unmapped_area) (struct mtd_info *mtd,
+					    unsigned long len,
+					    unsigned long offset,
+					    unsigned long flags);
+
+	/* Backing device capabilities for this device
+	 * - provides mmap capabilities
+	 */
+	struct backing_dev_info *backing_dev_info;
+
 
 	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf);
 	int (*write) (struct mtd_info *mtd, loff_t to, size_t len, size_t *retlen, const u_char *buf);
