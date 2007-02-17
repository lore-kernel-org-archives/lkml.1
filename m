Return-Path: <linux-kernel-owner+w=401wt.eu-S2992741AbXBQRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992741AbXBQRIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXBQRIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:08:22 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52666 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992477AbXBQQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:00 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:36 +0200
Message-Id: <20070217165736.5845.69602.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 38/44 take 2] [UBI] sysfs handling unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:57:03.0266 (UTC) FILETIME=[A5CDB020:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185401-63EC2BB0-01DA7B8A/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/sysfs.c tmp-to/drivers/mtd/ubi/sysfs.c
--- tmp-from/drivers/mtd/ubi/sysfs.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/sysfs.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,614 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: Artem B. Bityutskiy
+ */
+
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "uif.h"
+#include "upd.h"
+#include "debug.h"
+#include "sysfs.h"
+#include "io.h"
+#include "wl.h"
+#include "badeb.h"
+#include "account.h"
+#include "vtbl.h"
+#include "alloc.h"
+#include "background.h"
+
+static struct class *ubi_class;
+
+static ssize_t ubi_version_show(struct class *class, char *buf);
+
+/* Class attributes corresponding to files in '/<sysfs>/class/ubi/' */
+static struct class_attribute ubi_version =
+	__ATTR(version, S_IRUGO, ubi_version_show, NULL);
+
+int __init ubi_sysfs_global_init(void)
+{
+	int err;
+
+	ubi_class = class_create(THIS_MODULE, UBI_NAME_STR);
+	if (IS_ERR(ubi_class)) {
+		err = PTR_ERR(ubi_class);
+		goto out;
+	}
+
+	err = class_create_file(ubi_class, &ubi_version);
+	if (err)
+		goto out_class;
+
+	return 0;
+
+out_class:
+	class_destroy(ubi_class);
+out:
+	return err;
+}
+
+void ubi_sysfs_global_close(void)
+{
+	class_remove_file(ubi_class, &ubi_version);
+	class_destroy(ubi_class);
+}
+
+static void dev_release(struct class_device *dev);
+static ssize_t dev_eraseblock_size_show(struct class_device *dev, char *buf);
+static ssize_t dev_avail_eraseblocks_show(struct class_device *dev, char *buf);
+static ssize_t dev_total_eraseblocks_show(struct class_device *dev, char *buf);
+static ssize_t dev_volumes_count_show(struct class_device *dev, char *buf);
+static ssize_t dev_max_ec_show(struct class_device *dev, char *buf);
+static ssize_t dev_update_show(struct class_device *dev, char *buf);
+static ssize_t dev_reserved_for_bad_show(struct class_device *dev, char *buf);
+static ssize_t dev_bad_peb_count_show(struct class_device *dev, char *buf);
+static ssize_t dev_max_vol_count_show(struct class_device *dev, char *buf);
+static ssize_t dev_min_io_size_show(struct class_device *dev, char *buf);
+static ssize_t dev_bgt_enabled_show(struct class_device *dev, char *buf);
+static ssize_t dev_bgt_enabled_store(struct class_device *dev, const char *buf,
+				     size_t count);
+
+/*
+ * Class device attributes corresponding to files in '/<sysfs>/class/ubi/ubiX'.
+ */
+static struct class_device_attribute dev_eraseblock_size =
+	__ATTR(eraseblock_size, S_IRUGO, dev_eraseblock_size_show, NULL);
+static struct class_device_attribute dev_avail_eraseblocks =
+	__ATTR(avail_eraseblocks, S_IRUGO, dev_avail_eraseblocks_show, NULL);
+static struct class_device_attribute dev_total_eraseblocks =
+	__ATTR(total_eraseblocks, S_IRUGO, dev_total_eraseblocks_show, NULL);
+static struct class_device_attribute dev_volumes_count =
+	__ATTR(volumes_count, S_IRUGO, dev_volumes_count_show, NULL);
+static struct class_device_attribute dev_max_ec =
+	__ATTR(max_ec, S_IRUGO, dev_max_ec_show, NULL);
+static struct class_device_attribute dev_update =
+	__ATTR(update, S_IRUGO, dev_update_show, NULL);
+static struct class_device_attribute dev_reserved_for_bad =
+	__ATTR(reserved_for_bad, S_IRUGO, dev_reserved_for_bad_show, NULL);
+static struct class_device_attribute dev_bad_peb_count =
+	__ATTR(bad_peb_count, S_IRUGO, dev_bad_peb_count_show, NULL);
+static struct class_device_attribute dev_max_vol_count =
+	__ATTR(max_vol_count, S_IRUGO, dev_max_vol_count_show, NULL);
+static struct class_device_attribute dev_min_io_size =
+	__ATTR(min_io_size, S_IRUGO, dev_min_io_size_show, NULL);
+static struct class_device_attribute dev_bgt_enabled =
+	__ATTR(bgt_enabled, S_IRUGO | S_IWUSR,
+	       dev_bgt_enabled_show, dev_bgt_enabled_store);
+
+int ubi_sysfs_init(const struct ubi_info *ubi)
+{
+	int err;
+	struct ubi_uif_info *uif = ubi->uif;
+
+	uif->dev.release = dev_release;
+	uif->dev.devt = MKDEV(uif->major, 0);
+	uif->dev.class = ubi_class;
+	sprintf(&uif->dev.class_id[0], UBI_NAME_STR"%d", ubi->ubi_num);
+	err = class_device_register(&uif->dev);
+	if (err)
+		goto out;
+
+	err = class_device_create_file(&uif->dev, &dev_eraseblock_size);
+	if (err)
+		goto out_unregister;
+	err = class_device_create_file(&uif->dev, &dev_avail_eraseblocks);
+	if (err)
+		goto out_eraseblock_size;
+	err = class_device_create_file(&uif->dev, &dev_total_eraseblocks);
+	if (err)
+		goto out_avail_eraseblocks;
+	err = class_device_create_file(&uif->dev, &dev_volumes_count);
+	if (err)
+		goto out_total_eraseblocks;
+	err = class_device_create_file(&uif->dev, &dev_max_ec);
+	if (err)
+		goto out_volumes_count;
+	err = class_device_create_file(&uif->dev, &dev_update);
+	if (err)
+		goto out_volumes_max_ec;
+	err = class_device_create_file(&uif->dev, &dev_reserved_for_bad);
+	if (err)
+		goto out_update;
+	err = class_device_create_file(&uif->dev, &dev_bad_peb_count);
+	if (err)
+		goto out_reserved_for_bad;
+	err = class_device_create_file(&uif->dev, &dev_max_vol_count);
+	if (err)
+		goto out_bad_peb_count;
+	err = class_device_create_file(&uif->dev, &dev_min_io_size);
+	if (err)
+		goto out_max_vol_count;
+	err = class_device_create_file(&uif->dev, &dev_bgt_enabled);
+	if (err)
+		goto out_min_io_size;
+
+	return 0;
+
+out_min_io_size:
+	class_device_remove_file(&uif->dev, &dev_min_io_size);
+out_max_vol_count:
+	class_device_remove_file(&uif->dev, &dev_max_vol_count);
+out_bad_peb_count:
+	class_device_remove_file(&uif->dev, &dev_bad_peb_count);
+out_reserved_for_bad:
+	class_device_remove_file(&uif->dev, &dev_reserved_for_bad);
+out_update:
+	class_device_remove_file(&uif->dev, &dev_update);
+out_volumes_max_ec:
+	class_device_remove_file(&uif->dev, &dev_max_ec);
+out_volumes_count:
+	class_device_remove_file(&uif->dev, &dev_volumes_count);
+out_total_eraseblocks:
+	class_device_remove_file(&uif->dev, &dev_total_eraseblocks);
+out_avail_eraseblocks:
+	class_device_remove_file(&uif->dev, &dev_avail_eraseblocks);
+out_eraseblock_size:
+	class_device_remove_file(&uif->dev, &dev_eraseblock_size);
+out_unregister:
+	class_device_unregister(&uif->dev);
+out:
+	ubi_err("failed to initialize sysfs for UBI device %d", ubi->ubi_num);
+	return err;
+}
+
+void ubi_sysfs_close(const struct ubi_info *ubi)
+{
+	struct ubi_uif_info *uif = ubi->uif;
+
+	class_device_remove_file(&uif->dev, &dev_bgt_enabled);
+	class_device_remove_file(&uif->dev, &dev_min_io_size);
+	class_device_remove_file(&uif->dev, &dev_max_vol_count);
+	class_device_remove_file(&uif->dev, &dev_bad_peb_count);
+	class_device_remove_file(&uif->dev, &dev_reserved_for_bad);
+	class_device_remove_file(&uif->dev, &dev_update);
+	class_device_remove_file(&uif->dev, &dev_max_ec);
+	class_device_remove_file(&uif->dev, &dev_volumes_count);
+	class_device_remove_file(&uif->dev, &dev_total_eraseblocks);
+	class_device_remove_file(&uif->dev, &dev_avail_eraseblocks);
+	class_device_remove_file(&uif->dev, &dev_eraseblock_size);
+	class_device_unregister(&uif->dev);
+}
+
+static void vol_release(struct class_device *dev);
+static ssize_t vol_reserved_ebs_show(struct class_device *dev, char *buf);
+static ssize_t vol_type_show(struct class_device *dev, char *buf);
+static ssize_t vol_name_show(struct class_device *dev, char *buf);
+static ssize_t vol_corrupted_show(struct class_device *dev, char *buf);
+static ssize_t vol_alignment_show(struct class_device *dev, char *buf);
+static ssize_t vol_usable_eb_size_show(struct class_device *dev, char *buf);
+static ssize_t vol_data_bytes_show(struct class_device *dev, char *buf);
+static ssize_t vol_upd_marker_show(struct class_device *dev, char *buf);
+
+/*
+ * Class device attributes corresponding to files in
+ * '/<sysfs>/class/ubi/ubiX/Y'.
+ */
+static struct class_device_attribute vol_reserved_ebs =
+	__ATTR(reserved_ebs, S_IRUGO, vol_reserved_ebs_show, NULL);
+static struct class_device_attribute vol_type =
+	__ATTR(type, S_IRUGO, vol_type_show, NULL);
+static struct class_device_attribute vol_name =
+	__ATTR(name, S_IRUGO, vol_name_show, NULL);
+static struct class_device_attribute vol_corrupted =
+	__ATTR(corrupted, S_IRUGO, vol_corrupted_show, NULL);
+static struct class_device_attribute vol_alignment =
+	__ATTR(alignment, S_IRUGO, vol_alignment_show, NULL);
+static struct class_device_attribute vol_usable_eb_size =
+	__ATTR(usable_eb_size, S_IRUGO, vol_usable_eb_size_show, NULL);
+static struct class_device_attribute vol_data_bytes =
+	__ATTR(data_bytes, S_IRUGO, vol_data_bytes_show, NULL);
+static struct class_device_attribute vol_upd_marker =
+	__ATTR(upd_marker, S_IRUGO, vol_upd_marker_show, NULL);
+
+/*
+ * Note, this function does not free allocated resources in case of failure -
+ * the caller does it. This is because this would cause release() here and the
+ * caller would oops.
+ */
+int ubi_sysfs_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol)
+{
+	int err;
+
+	vol->dev.release = vol_release;
+	vol->dev.parent = &ubi->uif->dev;
+	vol->dev.devt = MKDEV(ubi->uif->major, vol->vol_id + 1);
+	vol->dev.class = ubi_class;
+	sprintf(&vol->dev.class_id[0], "%d", vol->vol_id);
+	err = class_device_register(&vol->dev);
+	if (err)
+		return err;
+
+	err = class_device_create_file(&vol->dev, &vol_reserved_ebs);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_type);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_name);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_corrupted);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_alignment);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_usable_eb_size);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_data_bytes);
+	if (err)
+		return err;
+	err = class_device_create_file(&vol->dev, &vol_upd_marker);
+	if (err)
+		return err;
+	return 0;
+}
+
+void ubi_sysfs_vol_close(struct ubi_uif_volume *vol)
+{
+	class_device_remove_file(&vol->dev, &vol_upd_marker);
+	class_device_remove_file(&vol->dev, &vol_data_bytes);
+	class_device_remove_file(&vol->dev, &vol_usable_eb_size);
+	class_device_remove_file(&vol->dev, &vol_alignment);
+	class_device_remove_file(&vol->dev, &vol_corrupted);
+	class_device_remove_file(&vol->dev, &vol_name);
+	class_device_remove_file(&vol->dev, &vol_type);
+	class_device_remove_file(&vol->dev, &vol_reserved_ebs);
+	class_device_unregister(&vol->dev);
+}
+
+/**
+ * dev2ubi -- find UBI device description object by the pointer to the class
+ * device object.
+ *
+ * @dev: class device object pointer
+ *
+ * This function returns a pointer to the UBI device description object.
+ */
+static inline struct ubi_info *dev2ubi(struct class_device *dev)
+{
+	struct ubi_uif_info *uif;
+
+	uif = container_of(dev, struct ubi_uif_info, dev);
+	return uif->ubi;
+}
+
+/* "Show" and "store" methods for files in '/<sysfs>/class/ubi/' */
+static ssize_t ubi_version_show(struct class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", UBI_VERSION);
+}
+
+/* "Release" method for UBI devices */
+static void dev_release(struct class_device *dev)
+{
+	return;
+}
+
+/* "Show" method for files in '/<sysfs>/class/ubi/ubiX/' */
+static ssize_t dev_eraseblock_size_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->io->leb_size);
+}
+
+static ssize_t dev_avail_eraseblocks_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->acc->avail_pebs);
+}
+
+static ssize_t dev_total_eraseblocks_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->io->good_peb_count);
+}
+
+static ssize_t dev_volumes_count_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->acc->uvol_count);
+}
+
+static ssize_t dev_max_ec_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->wl->max_ec);
+}
+
+static ssize_t dev_update_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+	int vol_id = ubi->upd->vol_id;
+
+	if (vol_id == -1)
+		return 0;
+	return sprintf(buf, "%d\n", vol_id);
+}
+
+static ssize_t dev_reserved_for_bad_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->beb->reserved_pebs);
+}
+
+static ssize_t dev_bad_peb_count_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->io->bad_peb_count);
+}
+
+static ssize_t dev_max_vol_count_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->acc->max_volumes);
+}
+
+static ssize_t dev_min_io_size_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->io->min_io_size);
+}
+
+static ssize_t dev_bgt_enabled_show(struct class_device *dev, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	return sprintf(buf, "%d\n", ubi->bgt->enabled);
+}
+
+static ssize_t dev_bgt_enabled_store(struct class_device *dev, const char *buf,
+				     size_t count)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	if (count > 2)
+		return -EINVAL;
+
+	if (count == 2 && buf[1] != '\n')
+		return -EINVAL;
+
+	if (buf[0] == '1')
+		ubi_bgt_enable(ubi);
+	else if (buf[0] == '0')
+		ubi_bgt_disable(ubi);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+/**
+ * dev2ubi -- find volume description object by the pointer to the class device
+ * object.
+ *
+ * @dev: class device object pointer
+ *
+ * This function returns a pointer to the UBI volume description object.
+ */
+static inline struct ubi_uif_volume *dev2vol(struct class_device *dev)
+{
+	return container_of(dev, struct ubi_uif_volume, dev);
+}
+
+/* Release method for volume devices */
+static void vol_release(struct class_device *dev)
+{
+	const struct ubi_uif_volume *vol = dev2vol(dev);
+
+	dbg_uif("release volume %d", vol->vol_id);
+	ubi_kfree(vol);
+}
+
+/*
+ * "Show" methods for files in '/<sysfs>/class/ubi/ubiX/Y/'.
+ *
+ * Consider a situation:
+ * A. process 1 opens a sysfs file related to volume Y, say
+ *    /<sysfs>/class/ubi/ubiX/Y/reserved_ebs;
+ * B. process 2 removes volume Y;
+ * C. process 1 starts reading the /<sysfs>/class/ubi/ubiX/Y/reserved_ebs file;
+ *
+ * What we want to do in a situation like that is to return error when the file
+ * is read. This is done by means of the 'removed' flag and the 'vol_lock' of
+ * the UBI UIF volume information structure.
+ */
+
+static ssize_t vol_reserved_ebs_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%d\n", vtr->reserved_pebs);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_type_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const char *tp;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	tp = vtr->vol_type == UBI_DYNAMIC_VOLUME ? "dynamic" : "static";
+	ret = sprintf(buf, "%s\n", tp);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_name_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%s\n", vtr->name);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_corrupted_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%d\n", vtr->corrupted);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_alignment_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%d\n", vtr->alignment);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_usable_eb_size_show(struct class_device *dev, char *buf)
+{
+	int ret, usable_eb_size;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+	const struct ubi_io_info *io = vol->ubi->io;
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	usable_eb_size = io->leb_size - vtr->data_pad;
+	ret = sprintf(buf, "%d\n", usable_eb_size);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_data_bytes_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%lld\n", vtr->used_bytes);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+static ssize_t vol_upd_marker_show(struct class_device *dev, char *buf)
+{
+	int ret;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_uif("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	ret = sprintf(buf, "%d\n", vtr->upd_marker);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
