Return-Path: <linux-kernel-owner+w=401wt.eu-S2992579AbXBQRBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992579AbXBQRBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992576AbXBQRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:01:19 -0500
Received: from smtp.nokia.com ([131.228.20.173]:33721 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369AbXBQRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:00:59 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:26 +0200
Message-Id: <20070217165726.5845.68108.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 36/44 take 2] [UBI] user-interfaces unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:53.0204 (UTC) FILETIME=[9FCE5940:01C752B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/uif.c tmp-to/drivers/mtd/ubi/uif.c
--- tmp-from/drivers/mtd/ubi/uif.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/uif.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,786 @@
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
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <asm/div64.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "misc.h"
+#include "sysfs.h"
+#include "upd.h"
+#include "wl.h"
+#include "uif.h"
+#include "cdev.h"
+#include "alloc.h"
+#include "debug.h"
+#include "vtbl.h"
+#include "volmgmt.h"
+#include "io.h"
+#include "eba.h"
+#include "account.h"
+
+int ubi_get_device_info(int ubi_num, struct ubi_dev_info *di)
+{
+	const struct ubi_info *ubi;
+	int err = -ENODEV;
+
+	if (!try_module_get(THIS_MODULE))
+		return err;
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_INSTANCES) {
+		dbg_err("bad UBI device number %d", ubi_num);
+		goto out_put;
+	}
+
+	if (!ubis[ubi_num]) {
+		dbg_err("UBI device %d does not exist", ubi_num);
+		goto out_put;
+	}
+	ubi = ubis[ubi_num];
+
+	di->ubi_num = ubi->ubi_num;
+	di->leb_size = ubi->io->leb_size;
+	di->min_io_size = ubi->io->min_io_size;
+	di->ro_mode = ubi->io->ro_mode;
+	di->cdev = MKDEV(ubi->uif->major, 0);
+	err = 0;
+
+out_put:
+	module_put(THIS_MODULE);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_get_device_info);
+
+static void fill_ubi_vol_info(const struct ubi_info *ubi, int vol_id,
+			      struct ubi_vol_info *vi);
+
+void ubi_get_volume_info(struct ubi_vol_desc *udesc, struct ubi_vol_info *vi)
+{
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	fill_ubi_vol_info(ubi, vol_id, vi);
+}
+EXPORT_SYMBOL_GPL(ubi_get_volume_info);
+
+struct ubi_vol_desc *ubi_open_volume(int ubi_num, int vol_id,
+				     enum ubi_open_mode mode)
+{
+	int err, found = 0;
+	struct ubi_vol_desc *desc;
+	const struct ubi_info *ubi;
+	struct ubi_uif_info *uif;
+	struct ubi_uif_volume *vol;
+
+	dbg_uif("open device %d volume %d, mode %d", ubi_num, vol_id, mode);
+
+	err = -ENODEV;
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(err);
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_INSTANCES) {
+		dbg_err("bad UBI device number %d", ubi_num);
+		goto out_put;
+	}
+
+	if (!ubis[ubi_num]) {
+		dbg_err("UBI device %d does not exist", ubi_num);
+		goto out_put;
+	}
+
+	ubi = ubis[ubi_num];
+	ubi_assert(ubi->ubi_num == ubi_num);
+	uif = ubi->uif;
+
+	desc = ubi_kzalloc(sizeof(struct ubi_vol_desc));
+	if (!desc) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	err = -EINVAL;
+	if (vol_id < 0 || vol_id >= ubi->acc->max_volumes) {
+		dbg_err("bad vol_id %d", vol_id);
+		goto out_free;
+	}
+
+	if (mode != UBI_READONLY && mode != UBI_READWRITE &&
+	    mode != UBI_EXCLUSIVE) {
+		dbg_err("bad mode %d", mode);
+		goto out_free;
+	}
+
+	mutex_lock(&uif->volumes_list_lock);
+	list_for_each_entry(vol, &uif->volumes, list)
+		if (vol->vol_id == vol_id) {
+			found = 1;
+			break;
+		}
+	if (!found) {
+		dbg_err("volume %d does not exist", vol_id);
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	err = -EBUSY;
+	spin_lock(&vol->vol_lock);
+	if (vol->updating) {
+		/* If the volume is being updated, no one can open it */
+		dbg_err("device busy - updating");
+		goto out_unlock_vol;
+	}
+
+	switch (mode) {
+	case UBI_READONLY:
+		if (vol->exclusive) {
+			dbg_err("device is busy - exclusive");
+			goto out_unlock_vol;
+		}
+		vol->readers += 1;
+		break;
+
+	case UBI_READWRITE:
+		if (vol->exclusive || vol->writers > 0) {
+			if (vol->exclusive)
+				dbg_err("device is busy - exclusive");
+			else
+				dbg_err("device is busy - writers");
+			goto out_unlock_vol;
+		}
+		vol->writers += 1;
+		break;
+
+	case UBI_EXCLUSIVE:
+		if (vol->exclusive || vol->writers || vol->readers) {
+			if (vol->exclusive)
+				dbg_err("device is busy - exclusive");
+			else if (vol->writers)
+				dbg_err("device is busy - writers");
+			else
+				dbg_err("device is busy - readers");
+			goto out_unlock_vol;
+		}
+		vol->exclusive = 1;
+		break;
+	}
+	spin_unlock(&vol->vol_lock);
+	mutex_unlock(&uif->volumes_list_lock);
+
+	desc->vol = vol;
+	desc->mode = mode;
+
+	mutex_lock(&uif->vol_check);
+	if (!vol->checked) {
+		/*
+		 * This is the first time this volume is being opened, we have
+		 * to check it. If the volume is corrupted, we still return
+		 * success.
+		 */
+		err = ubi_check_volume(ubi, vol_id);
+		if (err < 0)
+			goto unlock_close;
+
+		if (err == 1) {
+			ubi_warn("volume %d on UBI device %d is corrupted",
+				 vol_id, ubi->ubi_num);
+			err = ubi_vtbl_set_corrupted(ubi, vol_id);
+			if (err)
+				goto unlock_close;
+		}
+		vol->checked = 1;
+	}
+	mutex_unlock(&uif->vol_check);
+
+	return desc;
+
+out_unlock_vol:
+	spin_unlock(&vol->vol_lock);
+out_unlock:
+	mutex_unlock(&uif->volumes_list_lock);
+out_free:
+	ubi_kfree(desc);
+out_put:
+	module_put(THIS_MODULE);
+	return ERR_PTR(err);
+
+unlock_close:
+	mutex_unlock(&uif->vol_check);
+	ubi_close_volume(desc);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(ubi_open_volume);
+
+struct ubi_vol_desc *ubi_open_volume_nm(int ubi_num, const char *name,
+					enum ubi_open_mode mode)
+{
+	int err, vol_id = -1, len;
+	struct ubi_vol_desc *ret;
+	const struct ubi_info *ubi;
+	struct ubi_uif_info *uif;
+	struct ubi_uif_volume *vol;
+
+	dbg_uif("open volume by name %s, mode %d", name, mode);
+
+	if (!name) {
+		dbg_err("bad name");
+		return ERR_PTR(-EINVAL);
+	}
+	len = strnlen(name, UBI_VOL_NAME_MAX + 1);
+	if (len > UBI_VOL_NAME_MAX) {
+		dbg_err("bad name");
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = -ENODEV;
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(err);
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_INSTANCES) {
+		dbg_err("bad UBI device number %d", ubi_num);
+		goto out_put;
+	}
+
+	if (!ubis[ubi_num]) {
+		dbg_err("UBI device %d does not exist", ubi_num);
+		goto out_put;
+	}
+
+	ubi = ubis[ubi_num];
+	ubi_assert(ubi->ubi_num == ubi_num);
+	uif = ubi->uif;
+
+	/* Walk all volumes of this UBI device */
+	mutex_lock(&uif->volumes_list_lock);
+	list_for_each_entry(vol, &uif->volumes, list) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		spin_lock(&vol->vol_lock);
+		vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+		if (len == vtr->name_len && !strcmp(name, vtr->name)) {
+			vol_id = vol->vol_id;
+			dbg_err("found volume volume %d", vol_id);
+			spin_unlock(&vol->vol_lock);
+			break;
+		}
+		spin_unlock(&vol->vol_lock);
+	}
+	mutex_unlock(&uif->volumes_list_lock);
+
+	if (vol_id < 0) {
+		dbg_err("volume %s does not exist", name);
+		goto out_put;
+	}
+
+	ret = ubi_open_volume(ubi_num, vol_id, mode);
+	if (!IS_ERR(ret))
+		return ret;
+
+	err = PTR_ERR(ret);
+
+out_put:
+	module_put(THIS_MODULE);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(ubi_open_volume_nm);
+
+void ubi_close_volume(struct ubi_vol_desc *udesc)
+{
+	struct ubi_vol_desc *desc = udesc;
+	struct ubi_uif_volume *vol = desc->vol;
+
+	dbg_uif("close volume %d, mode %d", vol->vol_id, desc->mode);
+
+	spin_lock(&vol->vol_lock);
+	switch (desc->mode) {
+	case UBI_READONLY:
+		ubi_assert(vol->readers > 0);
+		vol->readers -= 1;
+		break;
+
+	case UBI_READWRITE:
+		ubi_assert(vol->writers > 0);
+		vol->writers -= 1;
+		break;
+
+	case UBI_EXCLUSIVE:
+		ubi_assert(vol->exclusive > 0);
+		vol->exclusive = 0;
+	}
+	spin_unlock(&vol->vol_lock);
+
+	ubi_kfree(desc);
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL_GPL(ubi_close_volume);
+
+int ubi_eraseblock_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
+			int offset, int len, int check)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	int err, vol_id = desc->vol->vol_id;
+
+	dbg_uif("read %d bytes from offset %d of LEB %d:%d",
+		len, offset, vol_id, lnum);
+
+	if (unlikely(vol_id < 0 || vol_id >= ubi->acc->max_volumes)) {
+		dbg_err("bad vol_id %d", vol_id);
+		return -EINVAL;
+	}
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(lnum < 0 || lnum >= vtr->used_ebs)) {
+		dbg_err("bad lnum %d", lnum);
+		return -EINVAL;
+	}
+
+	if (unlikely(offset < 0 || len < 0 ||
+		     offset + len > vtr->usable_leb_size)) {
+		dbg_err("bad offset %d or len %d", offset, len);
+		return -EINVAL;
+	}
+
+	if (unlikely(vtr->vol_type == UBI_STATIC_VOLUME &&
+		     lnum == vtr->used_ebs - 1 &&
+		     offset + len > vtr->last_eb_bytes)) {
+		dbg_err("bad offset %d or len %d for last LEB", offset, len);
+		return -EINVAL;
+	}
+
+	if (unlikely(len == 0))
+		return 0;
+
+	if (unlikely(vtr->upd_marker)) {
+		dbg_err("reading from update-interrupted volume");
+		return -EBADF;
+	}
+
+	err = ubi_eba_read_leb(ubi, vol_id, lnum, buf, offset, len, check);
+	if (unlikely(err))
+		return err;
+	if (unlikely(vtr->corrupted)) {
+		ubi_assert(vtr->vol_type == UBI_STATIC_VOLUME);
+		dbg_err("corrupted volume is read");
+		err = -EUCLEAN;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_read);
+
+int ubi_eraseblock_write(struct ubi_vol_desc *udesc, int lnum, const void *buf,
+			 int offset, int len, enum ubi_data_type dtype)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	const struct ubi_io_info *io = ubi->io;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("write %zd bytes at offset %d of LEB %d:%d",
+		len, offset, vol_id, lnum);
+
+	if (unlikely(vol_id < 0 || vol_id >= ubi->acc->max_volumes)) {
+		dbg_err("bad vol_id %d", vol_id);
+		return -EINVAL;
+	}
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (unlikely(vtr->vol_type == UBI_STATIC_VOLUME)) {
+		dbg_err("static volume");
+		return -EROFS;
+	}
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs)) {
+		dbg_err("bad lnum %d", lnum);
+		return -EINVAL;
+	}
+
+	if (unlikely(offset < 0 || len < 0 ||
+		     offset + len > vtr->usable_leb_size)) {
+		dbg_err("bad offset %d or len %zd", offset, len);
+		return -EINVAL;
+	}
+
+	if (unlikely(offset % io->min_io_size || len % io->min_io_size)) {
+		dbg_err("unaligned offset %d or len %zd", offset, len);
+		return -EINVAL;
+	}
+
+	if (unlikely(dtype != UBI_DATA_LONGTERM &&
+		     dtype != UBI_DATA_SHORTTERM &&
+		     dtype != UBI_DATA_UNKNOWN)) {
+		dbg_err("bad dtype %d", dtype);
+		return -EINVAL;
+	}
+
+	if (unlikely(len == 0))
+		return 0;
+
+	if (unlikely(vtr->upd_marker)) {
+		dbg_err("writing update-interrupted volume");
+		return -EBADF;
+	}
+
+	return ubi_eba_write_leb(ubi, vol_id, lnum, buf, offset, len, dtype);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_write);
+
+int ubi_eraseblock_erase(struct ubi_vol_desc *udesc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("erase LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (unlikely(vtr->vol_type == UBI_STATIC_VOLUME)) {
+		dbg_err("static volume");
+		return -EROFS;
+	}
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs)) {
+		dbg_err("bad lnum %d", lnum);
+		return -EINVAL;
+	}
+
+	if (unlikely(vtr->upd_marker)) {
+		dbg_err("erasing update-interrupted volume");
+		return -EBADF;
+	}
+
+	return ubi_eba_erase_leb(ubi, vol_id, lnum);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_erase);
+
+int ubi_eraseblock_unmap(struct ubi_vol_desc *udesc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	int err, vol_id = desc->vol->vol_id;
+
+	dbg_uif("erase LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (unlikely(vtr->vol_type == UBI_STATIC_VOLUME)) {
+		dbg_err("static volume");
+		return -EROFS;
+	}
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs)) {
+		dbg_err("bad lnum %d", lnum);
+		return -EINVAL;
+	}
+
+	if (unlikely(vtr->upd_marker)) {
+		dbg_err("unmapping eraseblock of an update-interrupted "
+			"volume");
+		return -EBADF;
+	}
+
+	err = ubi_eba_erase_leb(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	return ubi_wl_flush(ubi);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_unmap);
+
+int ubi_eraseblock_is_mapped(struct ubi_vol_desc *udesc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vol_desc *desc = udesc;
+	const struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("check LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs)) {
+		dbg_err("bad lnum %d", lnum);
+		return -EINVAL;
+	}
+
+	if (unlikely(vtr->upd_marker)) {
+		dbg_err("update-interrupted volume");
+		return -EBADF;
+	}
+
+	return ubi_eba_leb_is_mapped(ubi, vol_id, lnum);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_is_mapped);
+
+int ubi_uif_mkvol(const struct ubi_info *ubi, int vol_id)
+{
+	int err;
+	struct ubi_uif_volume *vol;
+	struct ubi_uif_info *uif = ubi->uif;
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	dbg_uif("create volume %d, size %d, type %d",
+		vol_id, vtr->reserved_pebs, vtr->vol_type);
+
+	vol = ubi_kzalloc(sizeof(struct ubi_uif_volume));
+	if (!vol)
+		return -ENOMEM;
+	vol->ubi = ubi;
+	vol->vol_id = vol_id;
+	vol->exclusive = 1;
+	spin_lock_init(&vol->vol_lock);
+
+	mutex_lock(&uif->volumes_list_lock);
+	list_add(&vol->list, &uif->volumes);
+	mutex_unlock(&uif->volumes_list_lock);
+
+	err = ubi_sysfs_vol_init(ubi, vol);
+	if (err)
+		goto out_sysfs;
+
+	err = ubi_cdev_vol_init(ubi, vol);
+	if (err)
+		goto out_sysfs;
+
+	err = ubi_gluebi_vol_init(ubi, vol);
+	if (err)
+		goto out_cdev;
+
+	spin_lock(&vol->vol_lock);
+	vol->exclusive = 0;
+	spin_unlock(&vol->vol_lock);
+
+	return 0;
+
+out_cdev:
+	ubi_cdev_vol_close(vol);
+out_sysfs:
+	mutex_lock(&uif->volumes_list_lock);
+	spin_lock(&vol->vol_lock);
+	vol->removed = 1;
+	spin_unlock(&vol->vol_lock);
+	list_del(&vol->list);
+	mutex_unlock(&uif->volumes_list_lock);
+	ubi_sysfs_vol_close(vol);
+	return err;
+}
+
+int ubi_uif_close_and_rmvol(struct ubi_vol_desc *desc)
+{
+	int err;
+	struct ubi_uif_volume *vol = desc->vol;
+	struct ubi_uif_info *uif = vol->ubi->uif;
+
+	dbg_uif("remove UBI volume %d", vol->vol_id);
+	ubi_assert(desc->mode == UBI_EXCLUSIVE);
+
+	err = ubi_gluebi_vol_close(vol);
+	if (err)
+		/* Somebody still holds the emulated MTD device */
+		return err;
+
+	spin_lock(&vol->vol_lock);
+	vol->removed = 1;
+	spin_unlock(&vol->vol_lock);
+
+	mutex_lock(&uif->volumes_list_lock);
+	list_del(&vol->list);
+	mutex_unlock(&uif->volumes_list_lock);
+
+	ubi_cdev_vol_close(vol);
+	ubi_sysfs_vol_close(vol);
+	ubi_kfree(desc);
+	module_put(THIS_MODULE);
+	return err;
+}
+
+static void delete_volumes(const struct ubi_info *ubi);
+
+int ubi_uif_init(struct ubi_info *ubi)
+{
+	int i, err;
+	struct ubi_uif_info *uif;
+	const struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_uif("initialize the user interface unit");
+
+	uif = ubi_kzalloc(sizeof(struct ubi_uif_info));
+	if (!uif)
+		return -ENOMEM;
+	ubi->uif = uif;
+	uif->ubi = ubi;
+
+	mutex_init(&uif->volumes_list_lock);
+	mutex_init(&uif->vol_check);
+	INIT_LIST_HEAD(&uif->volumes);
+
+	uif->ubi_name = ubi_kmalloc(sizeof(UBI_NAME_STR) + 5);
+	if (!uif->ubi_name) {
+		err = -ENOMEM;
+		goto out_uif;
+	}
+	sprintf(uif->ubi_name, UBI_NAME_STR "%d", ubi->ubi_num);
+
+	err = ubi_cdev_init(ubi);
+	if (err)
+		goto out_name;
+
+	err = ubi_sysfs_init(ubi);
+	if (err)
+		goto out_cdev;
+
+	for (i = 0; i < acc->max_volumes; i++) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		cond_resched();
+
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr))
+			continue;
+
+		err = ubi_uif_mkvol(ubi, i);
+		if (unlikely(err))
+			goto out_volumes;
+	}
+
+	dbg_uif("the user interface unit is initialized");
+	return 0;
+
+out_volumes:
+	delete_volumes(ubi);
+	ubi_sysfs_close(ubi);
+
+out_cdev:
+	ubi_cdev_close(ubi);
+
+out_name:
+	ubi_kfree(uif->ubi_name);
+
+out_uif:
+	ubi_kfree(uif);
+	return err;
+}
+
+void ubi_uif_close(const struct ubi_info *ubi)
+{
+	struct ubi_uif_info *uif = ubi->uif;
+
+	dbg_uif("close the user interface unit for %s", uif->ubi_name);
+
+	delete_volumes(ubi);
+	ubi_sysfs_close(ubi);
+	ubi_cdev_close(ubi);
+	ubi_kfree(uif->ubi_name);
+	ubi_kfree(uif);
+}
+
+int __init ubi_uif_global_init(void)
+{
+	return ubi_sysfs_global_init();
+}
+
+void ubi_uif_global_close(void)
+{
+	return ubi_sysfs_global_close();
+}
+
+/**
+ * delete_volumes - delete all the volume information.
+ *
+ * @ubi: the UBI device description object
+ */
+static void delete_volumes(const struct ubi_info *ubi)
+{
+	struct ubi_uif_volume *vol, *vol_tmp;
+	struct ubi_uif_info *uif = ubi->uif;
+
+	list_for_each_entry_safe(vol, vol_tmp, &uif->volumes, list) {
+		list_del(&vol->list);
+		vol->removed = 1;
+		ubi_gluebi_vol_close(vol);
+		ubi_cdev_vol_close(vol);
+		ubi_sysfs_vol_close(vol);
+	}
+}
+
+/**
+ * fill_ubi_vol_info - fill an "user volume information data structure".
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume
+ * @vi: the volume information to fill
+ *
+ * This function must be invoked when the @vol_id volume will for sure not go.
+ */
+static void fill_ubi_vol_info(const struct ubi_info *ubi, int vol_id,
+			      struct ubi_vol_info *vi)
+{
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	vi->vol_id = vol_id;
+	vi->ubi_num = ubi->ubi_num;
+	vi->size = vtr->reserved_pebs;
+	vi->used_bytes = vtr->used_bytes;
+	vi->vol_type = vtr->vol_type;
+	vi->corrupted = vtr->corrupted;
+	vi->upd_marker = vtr->upd_marker;
+	vi->alignment = vtr->alignment;
+	vi->usable_leb_size = vtr->usable_leb_size;
+	vi->name_len = vtr->name_len;
+	vi->name = vtr->name;
+	vi->cdev = MKDEV(ubi->uif->major, vi->vol_id + 1);
+}
