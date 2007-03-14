Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXCNPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXCNPZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXCNPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:24 -0400
Received: from smtp.nokia.com ([131.228.20.173]:63753 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422668AbXCNPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:05 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:50 +0200
Message-Id: <20070314152050.1112.50792.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/22 take 3] UBI: sysfs functionality
X-OriginalArrivalTime: 14 Mar 2007 15:20:49.0931 (UTC) FILETIME=[58F46DB0:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172051-22E7ABB0-7051BF01/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/sysfs.c tmp-to/drivers/mtd/ubi/sysfs.c
--- tmp-from/drivers/mtd/ubi/sysfs.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/sysfs.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,408 @@
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
+#include <linux/kobject.h>
+#include <linux/stat.h>
+#include "ubi.h"
+
+static struct class *ubi_class;
+
+/* "Show" and "store" methods for files in '/<sysfs>/class/ubi/' */
+static ssize_t ubi_version_show(struct class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", UBI_VERSION);
+}
+
+/* Class attributes corresponding to files in '/<sysfs>/class/ubi/' */
+static struct class_attribute ubi_version =
+	__ATTR(version, S_IRUGO, ubi_version_show, NULL);
+
+/**
+ * ubi_sysfs_infr_init - initialize UBI sysfs infrastructure support.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_sysfs_infr_init(void)
+{
+	int err;
+
+	ubi_class = class_create(THIS_MODULE, UBI_STRING_NAME);
+	if (IS_ERR(ubi_class))
+		return PTR_ERR(ubi_class);
+
+	err = class_create_file(ubi_class, &ubi_version);
+	if (err)
+		goto out_class;
+
+	return 0;
+
+out_class:
+	class_destroy(ubi_class);
+	return err;
+}
+
+/**
+ * ubi_sysfs_infr_close - close UBI sysfs infrastructure.
+ */
+void ubi_sysfs_infr_close(void)
+{
+	class_remove_file(ubi_class, &ubi_version);
+	class_destroy(ubi_class);
+}
+
+/**
+ * dev2ubi - find UBI device description object by the pointer to the device
+ * object.
+ *
+ * @dev: device object pointer
+ *
+ * This function returns a pointer to the UBI device description object.
+ */
+static inline struct ubi_info *dev2ubi(struct device *dev)
+{
+	return container_of(dev, struct ubi_info, uif.dev);
+}
+
+static ssize_t dev_attribute_show(struct device *dev,
+				  struct device_attribute *attr, char *buf);
+
+/*
+ * Device attributes corresponding to files in '/<sysfs>/class/ubi/ubiX'.
+ */
+static struct device_attribute dev_eraseblock_size =
+	__ATTR(eraseblock_size, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_avail_eraseblocks =
+	__ATTR(avail_eraseblocks, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_total_eraseblocks =
+	__ATTR(total_eraseblocks, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_volumes_count =
+	__ATTR(volumes_count, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_max_ec =
+	__ATTR(max_ec, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_reserved_for_bad =
+	__ATTR(reserved_for_bad, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_bad_peb_count =
+	__ATTR(bad_peb_count, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_max_vol_count =
+	__ATTR(max_vol_count, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_min_io_size =
+	__ATTR(min_io_size, S_IRUGO, dev_attribute_show, NULL);
+static struct device_attribute dev_bgt_enabled =
+	__ATTR(bgt_enabled, S_IRUGO, dev_attribute_show, NULL);
+
+/* "Show" method for files in '/<sysfs>/class/ubi/ubiX/' */
+static ssize_t dev_attribute_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	const struct ubi_info *ubi = dev2ubi(dev);
+
+	if (attr == &dev_eraseblock_size)
+		return sprintf(buf, "%d\n", ubi->io.leb_size);
+	else if (attr == &dev_avail_eraseblocks)
+		return sprintf(buf, "%d\n", ubi->acc.avail_pebs);
+	else if (attr == &dev_total_eraseblocks)
+		return sprintf(buf, "%d\n", ubi->io.good_peb_count);
+	else if (attr == &dev_volumes_count)
+		return sprintf(buf, "%d\n", ubi->vtbl.vol_count);
+	else if (attr == &dev_max_ec)
+		return sprintf(buf, "%d\n", ubi->wl.max_ec);
+	else if (attr == &dev_reserved_for_bad)
+		return sprintf(buf, "%d\n", ubi->acc.beb_rsvd_pebs);
+	else if (attr == &dev_bad_peb_count)
+		return sprintf(buf, "%d\n", ubi->io.bad_peb_count);
+	else if (attr == &dev_max_vol_count)
+		return sprintf(buf, "%d\n", ubi->vtbl.vt_slots);
+	else if (attr == &dev_min_io_size)
+		return sprintf(buf, "%d\n", ubi->io.min_io_size);
+	else if (attr == &dev_bgt_enabled) {
+		return sprintf(buf, "%d\n", ubi->wl.thread_enabled);
+	}
+
+	return 0;
+}
+
+/* "Release" method for UBI devices */
+static void dev_release(struct device *dev)
+{
+	return;
+}
+
+/**
+ * ubi_sysfs_init - initialize sysfs for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_sysfs_init(struct ubi_info *ubi)
+{
+	int err;
+
+	ubi->uif.dev.release = dev_release;
+	ubi->uif.dev.devt = MKDEV(ubi->uif.major, 0);
+	ubi->uif.dev.class = ubi_class;
+	sprintf(&ubi->uif.dev.bus_id[0], UBI_STRING_NAME"%d", ubi->ubi_num);
+	err = device_register(&ubi->uif.dev);
+	if (err)
+		goto out;
+
+	err = device_create_file(&ubi->uif.dev, &dev_eraseblock_size);
+	if (err)
+		goto out_unregister;
+	err = device_create_file(&ubi->uif.dev, &dev_avail_eraseblocks);
+	if (err)
+		goto out_eraseblock_size;
+	err = device_create_file(&ubi->uif.dev, &dev_total_eraseblocks);
+	if (err)
+		goto out_avail_eraseblocks;
+	err = device_create_file(&ubi->uif.dev, &dev_volumes_count);
+	if (err)
+		goto out_total_eraseblocks;
+	err = device_create_file(&ubi->uif.dev, &dev_max_ec);
+	if (err)
+		goto out_volumes_count;
+	err = device_create_file(&ubi->uif.dev, &dev_reserved_for_bad);
+	if (err)
+		goto out_volumes_max_ec;
+	err = device_create_file(&ubi->uif.dev, &dev_bad_peb_count);
+	if (err)
+		goto out_reserved_for_bad;
+	err = device_create_file(&ubi->uif.dev, &dev_max_vol_count);
+	if (err)
+		goto out_bad_peb_count;
+	err = device_create_file(&ubi->uif.dev, &dev_min_io_size);
+	if (err)
+		goto out_max_vol_count;
+	err = device_create_file(&ubi->uif.dev, &dev_bgt_enabled);
+	if (err)
+		goto out_min_io_size;
+
+	return 0;
+
+out_min_io_size:
+	device_remove_file(&ubi->uif.dev, &dev_min_io_size);
+out_max_vol_count:
+	device_remove_file(&ubi->uif.dev, &dev_max_vol_count);
+out_bad_peb_count:
+	device_remove_file(&ubi->uif.dev, &dev_bad_peb_count);
+out_reserved_for_bad:
+	device_remove_file(&ubi->uif.dev, &dev_reserved_for_bad);
+out_volumes_max_ec:
+	device_remove_file(&ubi->uif.dev, &dev_max_ec);
+out_volumes_count:
+	device_remove_file(&ubi->uif.dev, &dev_volumes_count);
+out_total_eraseblocks:
+	device_remove_file(&ubi->uif.dev, &dev_total_eraseblocks);
+out_avail_eraseblocks:
+	device_remove_file(&ubi->uif.dev, &dev_avail_eraseblocks);
+out_eraseblock_size:
+	device_remove_file(&ubi->uif.dev, &dev_eraseblock_size);
+out_unregister:
+	device_unregister(&ubi->uif.dev);
+out:
+	ubi_err("failed to initialize sysfs for UBI device %d", ubi->ubi_num);
+	return err;
+}
+
+/**
+ * ubi_sysfs_close - close sysfs for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_sysfs_close(struct ubi_info *ubi)
+{
+	device_remove_file(&ubi->uif.dev, &dev_bgt_enabled);
+	device_remove_file(&ubi->uif.dev, &dev_min_io_size);
+	device_remove_file(&ubi->uif.dev, &dev_max_vol_count);
+	device_remove_file(&ubi->uif.dev, &dev_bad_peb_count);
+	device_remove_file(&ubi->uif.dev, &dev_reserved_for_bad);
+	device_remove_file(&ubi->uif.dev, &dev_max_ec);
+	device_remove_file(&ubi->uif.dev, &dev_volumes_count);
+	device_remove_file(&ubi->uif.dev, &dev_total_eraseblocks);
+	device_remove_file(&ubi->uif.dev, &dev_avail_eraseblocks);
+	device_remove_file(&ubi->uif.dev, &dev_eraseblock_size);
+	device_unregister(&ubi->uif.dev);
+}
+
+/**
+ * dev2ubi - find volume description object by the pointer to the device
+ * object.
+ *
+ * @dev: device object pointer
+ *
+ * This function returns a pointer to the UBI volume description object.
+ */
+static inline struct ubi_uif_volume *dev2vol(struct device *dev)
+{
+	return container_of(dev, struct ubi_uif_volume, dev);
+}
+
+static ssize_t vol_attribute_show(struct device *dev,
+				  struct device_attribute *attr, char *buf);
+
+/* Device attributes corresponding to files in '/<sysfs>/class/ubi/ubiX_Y' */
+static struct device_attribute vol_reserved_ebs =
+	__ATTR(reserved_ebs, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_type =
+	__ATTR(type, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_name =
+	__ATTR(name, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_corrupted =
+	__ATTR(corrupted, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_alignment =
+	__ATTR(alignment, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_usable_eb_size =
+	__ATTR(usable_eb_size, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_data_bytes =
+	__ATTR(data_bytes, S_IRUGO, vol_attribute_show, NULL);
+static struct device_attribute vol_upd_marker =
+	__ATTR(upd_marker, S_IRUGO, vol_attribute_show, NULL);
+
+/*
+ * "Show" method for files in '/<sysfs>/class/ubi/ubiX_Y/'.
+ *
+ * Consider a situation:
+ * A. process 1 opens a sysfs file related to volume Y, say
+ *    /<sysfs>/class/ubi/ubiX_Y/reserved_ebs;
+ * B. process 2 removes volume Y;
+ * C. process 1 starts reading the /<sysfs>/class/ubi/ubiX_Y/reserved_ebs file;
+ *
+ * What we want to do in a situation like that is to return error when the file
+ * is read. This is done by means of the 'removed' flag and the 'vol_lock' of
+ * the UBI UIF volume information structure.
+ */
+static ssize_t vol_attribute_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	int usable_eb_size, ret = 0;
+	const struct ubi_vtbl_vtr *vtr;
+	const char *tp;
+	struct ubi_uif_volume *vol = dev2vol(dev);
+
+	spin_lock(&vol->vol_lock);
+	if (vol->removed) {
+		spin_unlock(&vol->vol_lock);
+		dbg_err("volume %d was removed", vol->vol_id);
+		return -EIO;
+	}
+	vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+	if (attr == &vol_reserved_ebs)
+		ret = sprintf(buf, "%d\n", vtr->reserved_pebs);
+	else if (attr == &vol_type) {
+		tp = vtr->vol_type == UBI_DYNAMIC_VOLUME ? "dynamic" : "static";
+		ret = sprintf(buf, "%s\n", tp);
+	} else if (attr == &vol_name)
+		ret = sprintf(buf, "%s\n", vtr->name);
+	else if (attr == &vol_corrupted)
+		ret = sprintf(buf, "%d\n", vtr->corrupted);
+	else if (attr == &vol_alignment)
+		ret = sprintf(buf, "%d\n", vtr->alignment);
+	else if (attr == &vol_usable_eb_size) {
+		usable_eb_size = vol->ubi->io.leb_size - vtr->data_pad;
+		ret = sprintf(buf, "%d\n", usable_eb_size);
+	} else if (attr == &vol_data_bytes)
+		ret = sprintf(buf, "%lld\n", vtr->used_bytes);
+	else if (attr == &vol_upd_marker)
+		ret = sprintf(buf, "%d\n", vtr->upd_marker);
+	spin_unlock(&vol->vol_lock);
+	return ret;
+}
+
+/* Release method for volume devices */
+static void vol_release(struct device *dev)
+{
+	const struct ubi_uif_volume *vol = dev2vol(dev);
+
+	dbg_uif("release volume %d", vol->vol_id);
+	kfree(vol);
+}
+
+/**
+ * ubi_sysfs_vol_init - initialize sysfs for an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol: volume description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ *
+ * Note, this function does not free allocated resources in case of failure -
+ * the caller does it. This is because this would cause release() here and the
+ * caller would oops.
+ */
+int ubi_sysfs_vol_init(struct ubi_info *ubi, struct ubi_uif_volume *vol)
+{
+	int err;
+
+	vol->dev.release = vol_release;
+	vol->dev.parent = &ubi->uif.dev;
+	vol->dev.devt = MKDEV(ubi->uif.major, vol->vol_id + 1);
+	vol->dev.class = ubi_class;
+	sprintf(&vol->dev.bus_id[0], "%s_%d", ubi->uif.ubi_name, vol->vol_id);
+	err = device_register(&vol->dev);
+	if (err)
+		return err;
+
+	err = device_create_file(&vol->dev, &vol_reserved_ebs);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_type);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_name);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_corrupted);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_alignment);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_usable_eb_size);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_data_bytes);
+	if (err)
+		return err;
+	err = device_create_file(&vol->dev, &vol_upd_marker);
+	if (err)
+		return err;
+	return 0;
+}
+
+/**
+ * ubi_sysfs_vol_close - close sysfs for an UBI volume.
+ *
+ * @vol: volume description object
+ */
+void ubi_sysfs_vol_close(struct ubi_uif_volume *vol)
+{
+	device_remove_file(&vol->dev, &vol_upd_marker);
+	device_remove_file(&vol->dev, &vol_data_bytes);
+	device_remove_file(&vol->dev, &vol_usable_eb_size);
+	device_remove_file(&vol->dev, &vol_alignment);
+	device_remove_file(&vol->dev, &vol_corrupted);
+	device_remove_file(&vol->dev, &vol_name);
+	device_remove_file(&vol->dev, &vol_type);
+	device_remove_file(&vol->dev, &vol_reserved_ebs);
+	device_unregister(&vol->dev);
+}
