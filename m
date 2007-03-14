Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXCNPVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXCNPVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXCNPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:45 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23375 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422657AbXCNPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:49 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:29 +0200
Message-Id: <20070314152029.1112.32730.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/22 take 3] UBI: user-interfaces unit
X-OriginalArrivalTime: 14 Mar 2007 15:20:29.0807 (UTC) FILETIME=[4CF5BFF0:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/uif.c tmp-to/drivers/mtd/ubi/uif.c
--- tmp-from/drivers/mtd/ubi/uif.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/uif.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,842 @@
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
+/*
+ * UBI user interfaces unit.
+ *
+ * This unit implements all the UBI user interfaces: kernel interfaces,
+ * character device interfaces, and sysfs interfaces.
+ *
+ * This file mostly implements kernel-API functions, character device
+ * operations are implemented in cdev.c, update functionality is implemented in
+ * upd.c, volume chane functionality - in vmt.c, and sysfs interfaces are
+ * implemented in sysfs.c.
+ *
+ * There are two kinds of character devices: UBI character devices and UBI
+ * volume character devices. UBI character devices allow users to manipulate
+ * whole volumes: create, remove, and re-size them. Volume character devices
+ * provide volume I/O capabilities.
+ *
+ * Major and minor numbers are assigned dynamically to both UBI and volume
+ * character devices.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <asm/div64.h>
+#include "ubi.h"
+
+/**
+ * ubi_get_device_info - get information about an UBI device.
+ *
+ * @ubi_num: UBI device number
+ * @di: the volume information is returned here
+ *
+ * This function fills the provided @di object with the information about the
+ * UBI device number @ubi_num. Returns %0 in case of success and a %-ENODEV if
+ * there is no such UBI device.
+ */
+int ubi_get_device_info(int ubi_num, struct ubi_dev_info *di)
+{
+	const struct ubi_info *ubi;
+	int err = -ENODEV;
+
+	if (!try_module_get(THIS_MODULE))
+		return err;
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES)
+		goto out_put;
+
+	if (!ubis[ubi_num])
+		goto out_put;
+
+	ubi = ubis[ubi_num];
+
+	di->ubi_num = ubi->ubi_num;
+	di->leb_size = ubi->io.leb_size;
+	di->min_io_size = ubi->io.min_io_size;
+	di->ro_mode = ubi->io.ro_mode;
+	di->cdev = MKDEV(ubi->uif.major, 0);
+	err = 0;
+
+out_put:
+	module_put(THIS_MODULE);
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_get_device_info);
+
+/**
+ * ubi_get_volume_info - get information about an UBI volume.
+ *
+ * @desc: volume descriptor
+ * @vi: the volume information is returned here
+ */
+void ubi_get_volume_info(struct ubi_vol_desc *desc, struct ubi_vol_info *vi)
+{
+	int vol_id = desc->vol->vol_id;
+	const struct ubi_info *ubi = desc->vol->ubi;
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
+	vi->cdev = MKDEV(ubi->uif.major, vi->vol_id + 1);
+}
+EXPORT_SYMBOL_GPL(ubi_get_volume_info);
+
+/*
+ * ubi_open_volume - open an UBI volume.
+ *
+ * @ubi_num: the UBI device number
+ * @vol_id: ID of the volume to open
+ * @mode: volume open mode
+ *
+ * This function opens an UBI volume. The @mode parameter specifies if the
+ * volume should be opened in read-only mode, read-write mode, or exclusive
+ * mode. The exclusive mode guarantees that nobody else will be able to open
+ * this volume. UBI allows to have many volume readers and one writer at a
+ * time.
+ *
+ * If a static volume is being opened for the first time since boot, the volume
+ * will be checked by this function, which means it will be fully read and the
+ * CRC checksum of each logical eraseblock will be checked.
+ *
+ * This function returns an UBI volume descriptor in case of success. In case
+ * of failure, the following error codes may be returned:
+ *
+ * o %-EBUSY if the volume is busy (it is being updated, or it is already
+ *   opened in exclusive or read-write mode by somebody else);
+ * o %-EINVAL if the input arguments are invalid;
+ * o %-ENODEV if this volume does not exist or the UBI device does not exist;
+ * o other negative error codes in case of other errors.
+ */
+struct ubi_vol_desc *ubi_open_volume(int ubi_num, int vol_id, int mode)
+{
+	int err, found = 0;
+	struct ubi_vol_desc *desc;
+	struct ubi_info *ubi;
+	struct ubi_uif_volume *vol;
+
+	dbg_uif("open device %d volume %d, mode %d", ubi_num, vol_id, mode);
+
+	err = -ENODEV;
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(err);
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES)
+		goto out_put;
+
+	if (!ubis[ubi_num])
+		goto out_put;
+
+	ubi = ubis[ubi_num];
+	ubi_assert(ubi->ubi_num == ubi_num);
+
+	desc = kmalloc(sizeof(struct ubi_vol_desc), GFP_KERNEL);
+	if (!desc) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	err = -EINVAL;
+	if (vol_id < 0 || vol_id >= ubi->vtbl.vt_slots)
+		goto out_free;
+
+	if (mode != UBI_READONLY && mode != UBI_READWRITE &&
+	    mode != UBI_EXCLUSIVE)
+		goto out_free;
+
+	spin_lock(&ubi->uif.volumes_list_lock);
+	list_for_each_entry(vol, &ubi->uif.volumes, list) {
+		if (vol->vol_id == vol_id) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	err = -EBUSY;
+	spin_lock(&vol->vol_lock);
+	switch (mode) {
+	case UBI_READONLY:
+		if (vol->exclusive)
+			goto out_unlock_vol;
+		vol->readers += 1;
+		break;
+
+	case UBI_READWRITE:
+		if (vol->exclusive || vol->writers > 0)
+			goto out_unlock_vol;
+		vol->writers += 1;
+		break;
+
+	case UBI_EXCLUSIVE:
+		if (vol->exclusive || vol->writers || vol->readers)
+			goto out_unlock_vol;
+		vol->exclusive = 1;
+		break;
+	}
+	spin_unlock(&vol->vol_lock);
+	spin_unlock(&ubi->uif.volumes_list_lock);
+
+	desc->vol = vol;
+	desc->mode = mode;
+
+	mutex_lock(&ubi->uif.vol_check_lock);
+	if (!vol->checked) {
+		/*
+		 * This is the first time this volume is being opened, we have
+		 * to check it. If the volume is corrupted, we still return
+		 * success, but mark it as corrupted and return %-EUCLEAN on
+		 * any further read.
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
+	mutex_unlock(&ubi->uif.vol_check_lock);
+
+	return desc;
+
+out_unlock_vol:
+	spin_unlock(&vol->vol_lock);
+out_unlock:
+	spin_unlock(&ubi->uif.volumes_list_lock);
+out_free:
+	kfree(desc);
+out_put:
+	module_put(THIS_MODULE);
+	return ERR_PTR(err);
+
+unlock_close:
+	mutex_unlock(&ubi->uif.vol_check_lock);
+	ubi_close_volume(desc);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(ubi_open_volume);
+
+/*
+ * ubi_open_volume_nm - open an UBI volume by volume name.
+ *
+ * @ubi_num: the UBI device number
+ * @name: volume name
+ * @mode: volume open mode
+ *
+ * This function is similar to the 'ubi_open_volume()' function, but opens UBI
+ * volumes by name.
+ */
+struct ubi_vol_desc *ubi_open_volume_nm(int ubi_num, const char *name, int mode)
+{
+	int vol_id = -1, len;
+	struct ubi_vol_desc *ret;
+	struct ubi_info *ubi;
+	struct ubi_uif_volume *vol;
+
+	dbg_uif("open volume by name %s, mode %d", name, mode);
+
+	if (!name)
+		return ERR_PTR(-EINVAL);
+
+	len = strnlen(name, UBI_VOL_NAME_MAX + 1);
+	if (len > UBI_VOL_NAME_MAX)
+		return ERR_PTR(-EINVAL);
+
+	ret = ERR_PTR(-ENODEV);
+	if (!try_module_get(THIS_MODULE))
+		return ret;
+
+	if (ubi_num < 0 || ubi_num >= UBI_MAX_DEVICES)
+		goto out_put;
+
+	if (!ubis[ubi_num])
+		goto out_put;
+
+	ubi = ubis[ubi_num];
+	ubi_assert(ubi->ubi_num == ubi_num);
+
+	/* Walk all volumes of this UBI device */
+	spin_lock(&ubi->uif.volumes_list_lock);
+	list_for_each_entry(vol, &ubi->uif.volumes, list) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		vtr = ubi_vtbl_get_vtr(vol->ubi, vol->vol_id);
+		if (len == vtr->name_len && !strcmp(name, vtr->name)) {
+			vol_id = vol->vol_id;
+			spin_unlock(&vol->vol_lock);
+			break;
+		}
+	}
+	spin_unlock(&ubi->uif.volumes_list_lock);
+
+	if (vol_id < 0)
+		goto out_put;
+
+	ret = ubi_open_volume(ubi_num, vol_id, mode);
+
+out_put:
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ubi_open_volume_nm);
+
+/**
+ * ubi_close_volume - close an UBI volume.
+ *
+ * @desc: UBI volume descriptor
+ */
+void ubi_close_volume(struct ubi_vol_desc *desc)
+{
+	struct ubi_uif_volume *vol = desc->vol;
+
+	dbg_uif("close volume %d, mode %d", vol->vol_id, desc->mode);
+
+	spin_lock(&vol->vol_lock);
+	switch (desc->mode) {
+	case UBI_READONLY:
+		ubi_assert(vol->readers > 0 && vol->writers >= 0);
+		ubi_assert(vol->exclusive == 0);
+		vol->readers -= 1;
+		break;
+
+	case UBI_READWRITE:
+		ubi_assert(vol->readers >= 0 && vol->writers == 1);
+		ubi_assert(vol->exclusive == 0);
+		vol->writers -= 1;
+		break;
+
+	case UBI_EXCLUSIVE:
+		ubi_assert(vol->readers == 0 && vol->writers == 0);
+		ubi_assert(vol->exclusive == 1);
+		vol->exclusive = 0;
+	}
+	spin_unlock(&vol->vol_lock);
+
+	kfree(desc);
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL_GPL(ubi_close_volume);
+
+/**
+ * ubi_eraseblock_read - read data from a logical eraseblock.
+ *
+ * @desc: volume descriptor
+ * @lnum: the logical eraseblock number to read from
+ * @buf: a buffer where to store the read data
+ * @offset: the offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ * @check: whether UBI has to check the read data's CRC or not.
+ *
+ * This function reads data from offset @offset of the logical eraseblock @lnum
+ * and stores the read data at @buf. When reading from static volumes, @check
+ * may be used to specify whether the read data has to be checked or not. If
+ * checking is requested, the whole logical eraseblock will be read and its CRC
+ * checksum will be checked (i.e., the CRC checksum is per-eraseblock). So
+ * checking may substantially slow down the read speed. The @check argument is
+ * ignored for dynamic volumes.
+ *
+ * In case of success, this function returns zero. In case of failure, this
+ * function returns a negative error code.
+ *
+ * A special %-EBADMSG error code is returned:
+ * o for both static and dynamic volumes if the MTD driver has detected a data
+ *   integrity problem (unrecoverable ECC checksum mismatch in case of NAND);
+ * o for static volumes if the data CRC mismatches.
+ *
+ * In case of reading a corrupted UBI volume, this function never returns zero,
+ * but %-EUCLEAN is returned instead, even though the data was read without
+ * errors because the corruption did not affect this particular piece of data,
+ * otherwise %-EBADMSG would have been returned. Thus, %-EUCLEAN just means
+ * that the read static volume is corrupted, but the read data is actually OK.
+ *
+ * %-EUCLEAN is not returned for dynamic volumes, because UBI does not protect
+ * their contents.
+ *
+ * If the volume is damaged because of an interrupted update this function just
+ * returns immediately with %-EBADF error code.
+ */
+int ubi_eraseblock_read(struct ubi_vol_desc *desc, int lnum, char *buf,
+			int offset, int len, int check)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = desc->vol->ubi;
+	int err, vol_id = desc->vol->vol_id;
+
+	dbg_uif("read %d bytes from LEB %d:%d:%d",
+		len, vol_id, lnum, offset);
+
+	if (unlikely(vol_id < 0 || vol_id >= ubi->vtbl.vt_slots))
+		return -EINVAL;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(lnum < 0 || lnum >= vtr->used_ebs))
+		return -EINVAL;
+
+	if (unlikely(offset < 0 || len < 0 ||
+		     offset + len > vtr->usable_leb_size))
+		return -EINVAL;
+
+	if (unlikely(vtr->vol_type == UBI_STATIC_VOLUME &&
+		     lnum == vtr->used_ebs - 1 &&
+		     offset + len > vtr->last_eb_bytes))
+		return -EINVAL;
+
+	if (unlikely(vtr->upd_marker))
+		return -EBADF;
+
+	if (unlikely(len == 0))
+		return 0;
+
+reread:
+	err = ubi_eba_read_leb(ubi, vol_id, lnum, buf, offset, len, check);
+	if (unlikely(err)) {
+		if (err == -EBADMSG && vtr->vol_type == UBI_STATIC_VOLUME &&
+		    !vtr->corrupted) {
+			int err1;
+
+			/*
+			 * We have read a static volume and result in data
+			 * integrity error. If we did not do checking, re-read
+			 * with checking enabled. Otherwise mark this static
+			 * eraseblock as corrupted.
+			 */
+			if (!check) {
+				check = 1;
+				goto reread;
+			}
+
+			ubi_warn("mark volume %d as corrupted", vol_id);
+			err1 = ubi_vtbl_set_corrupted(ubi, vol_id);
+			if (err1)
+				err = err1;
+		}
+		return err;
+	}
+
+	if (unlikely(vtr->corrupted)) {
+		ubi_assert(vtr->vol_type == UBI_STATIC_VOLUME);
+		err = -EUCLEAN;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_read);
+
+/**
+ * ubi_eraseblock_write - write data to a logical eraseblock.
+ *
+ * @desc: volume descriptor
+ * @lnum: the logical eraseblock number to write to
+ * @buf: the data to write
+ * @offset: offset within the logical eraseblock where to write
+ * @len: how many bytes from @buf to write
+ * @dtype: expected data type
+ *
+ * This function writes @len bytes of data from buffer @buf to offset @offset
+ * of logical eraseblock @lnum. The @dtype argument describes the expected
+ * lifetime of the data that is being written.
+ *
+ * Note, this function takes care of physical eraseblock write failures. If a
+ * write to the physical eraseblock write operation fails, the logical
+ * eraseblock is re-mapped to another physical eraseblock, the data is
+ * recovered, and the write finishes. UBI has a pool of reserved physical
+ * eraseblocks for this.
+ *
+ * If all the data were successfully written, zero is returned. If an error
+ * occurred and UBI has not been able to recover from it, this function returns
+ * a negative error code. Note, in case of an error, it is possible that
+ * something was still written to the flash media, but that may be some
+ * garbage.
+ *
+ * If the volume is damaged because of an interrupted update this function just
+ * returns immediately with %-EBADF error code.
+ */
+int ubi_eraseblock_write(struct ubi_vol_desc *desc, int lnum, const void *buf,
+			 int offset, int len, int dtype)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("write %zd bytes to LEB %d:%d:%d",
+		len, vol_id, lnum, offset);
+
+	if (unlikely(vol_id < 0 || vol_id >= ubi->vtbl.vt_slots))
+		return -EINVAL;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY ||
+		     vtr->vol_type == UBI_STATIC_VOLUME))
+		return -EROFS;
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs))
+		return -EINVAL;
+
+	if (unlikely(offset < 0 || len < 0 ||
+		     offset + len > vtr->usable_leb_size))
+		return -EINVAL;
+
+	if (unlikely(offset % ubi->io.min_io_size ||
+		     len % ubi->io.min_io_size))
+		return -EINVAL;
+
+	if (unlikely(dtype != UBI_DATA_LONGTERM &&
+		     dtype != UBI_DATA_SHORTTERM &&
+		     dtype != UBI_DATA_UNKNOWN))
+		return -EINVAL;
+
+	if (unlikely(vtr->upd_marker))
+		return -EBADF;
+
+	if (unlikely(len == 0))
+		return 0;
+
+	return ubi_eba_write_leb(ubi, vol_id, lnum, buf, offset, len, dtype);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_write);
+
+/**
+ * ubi_eraseblock_erase - erase a logical eraseblock.
+ *
+ * @desc: volume descriptor
+ * @lnum: the logical eraseblock number to erase
+ *
+ * This function un-maps logical eraseblock @lnum and synchronously erases the
+ * correspondent physical eraseblock. Returns zero in case of success and a
+ * negative error code in case of failure.
+ *
+ * If the volume is damaged because of an interrupted update this function just
+ * returns immediately with %-EBADF error code.
+ */
+int ubi_eraseblock_erase(struct ubi_vol_desc *desc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = desc->vol->ubi;
+	int err, vol_id = desc->vol->vol_id;
+
+	dbg_uif("erase LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY ||
+	             vtr->vol_type == UBI_STATIC_VOLUME))
+		return -EROFS;
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs))
+		return -EINVAL;
+
+	if (unlikely(vtr->upd_marker))
+		return -EBADF;
+
+	err = ubi_eba_unmap_leb(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	return ubi_wl_flush(ubi);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_erase);
+
+/**
+ * ubi_eraseblock_unmap - un-map a logical eraseblock.
+ *
+ * @desc: volume descriptor
+ * @lnum: the logical eraseblock number to un-map
+ *
+ * This function un-maps logical eraseblock @lnum and schedules the
+ * corresponding physical eraseblock for erasure, so that it will eventually be
+ * physically erased in background. So this operation is much faster then the
+ * erase operation.
+ *
+ * Unlike erase, the un-map operation does not guarantee that the logical
+ * eraseblock will contain all 0xFF bytes when UBI is initialized again. For
+ * example, if several logical eraseblocks are un-mapped, and an unclean reboot
+ * happens after this, the logical eraseblocks will not necessarily be
+ * un-mapped again when this MTD device is attached. They may actually be
+ * mapped to the same physical eraseblocks again. So, this function has to be
+ * used with care.
+ *
+ * In other words, when un-mapping a logical eraseblock, UBI does not store
+ * any information about this on the flash media, it just marks the logical
+ * eraseblock as "un-mapped" in RAM. If UBI is detached before the physical
+ * eraseblock is physically erased, the physical eraseblock will be mapped
+ * again to the same logical eraseblock when the MTD device is attached again.
+ *
+ * The main and obvious use-case of this function is when the contents of a
+ * logical eraseblock has to be re-written. Then it is much more efficient to
+ * first un-map it, then write new data, rather then first erase it, then write
+ * new data. Note, once new data has been written to the logical eraseblock,
+ * UBI guarantees that the old contents has gone forever. In other words, if an
+ * unclean reboot happens after the logical eraseblock has been un-mapped and
+ * then written to, it will contain the last written data.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. If the volume is damaged because of an interrupted update
+ * this function just returns immediately with %-EBADF error code.
+ */
+int ubi_eraseblock_unmap(struct ubi_vol_desc *desc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("unmap LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(desc->mode == UBI_READONLY ||
+	             vtr->vol_type == UBI_STATIC_VOLUME))
+		return -EROFS;
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs))
+		return -EINVAL;
+
+	if (unlikely(vtr->upd_marker))
+		return -EBADF;
+
+	return ubi_eba_unmap_leb(ubi, vol_id, lnum);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_unmap);
+
+/**
+ * ubi_eraseblock_is_mapped - check if a logical eraseblock is mapped to a
+ * physical eraseblock
+ *
+ * @desc: volume descriptor
+ * @lnum: the logical eraseblock number to erase
+ *
+ * This function checks if a logical eraseblock is mapped to a physical
+ * eraseblock. Unmapped logical eraseblocks are equivalent to erased logical
+ * eraseblocks and contain only 0xFF bytes. Mapped logical eraseblocks are
+ * those that were explicitly written to. They may also contain only 0xFF
+ * bytes if these were written there.
+ *
+ * Note, if a logical eraseblock is unmapped, this does not necessarily mean
+ * it will still be un-mapped after the corresponding UBI device is detached
+ * and attached again. After the UBI device is re-attached, the logical
+ * eraseblock may become mapped to the physical eraseblock it was last mapped
+ * to. Se the 'ubi_eraseblock_unmap()' function for more explanation.
+ *
+ * This function returns %1 if the LEB is mapped, %0 if not, and a negative
+ * error code in case of failure. If the volume is damaged because of an
+ * interrupted update this function just returns immediately with %-EBADF error
+ * code.
+ */
+int ubi_eraseblock_is_mapped(struct ubi_vol_desc *desc, int lnum)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = desc->vol->ubi;
+	int vol_id = desc->vol->vol_id;
+
+	dbg_uif("check LEB %d:%d", vol_id, lnum);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(lnum < 0 || lnum >= vtr->reserved_pebs))
+		return -EINVAL;
+
+	if (unlikely(vtr->upd_marker))
+		return -EBADF;
+
+	return ubi_eba_leb_is_mapped(ubi, vol_id, lnum);
+}
+EXPORT_SYMBOL_GPL(ubi_eraseblock_is_mapped);
+
+/**
+ * kill_volumes - close user interfaces for all volumes.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function is called when the UBI device is detached so no locking is
+ * needed.
+ */
+static void kill_volumes(struct ubi_info *ubi)
+{
+	struct ubi_uif_volume *vol, *vol_tmp;
+
+	list_for_each_entry_safe(vol, vol_tmp, &ubi->uif.volumes, list) {
+		int err;
+
+		list_del(&vol->list);
+		err = ubi_gluebi_vol_close(vol);
+		BUG_ON(err);
+		cdev_del(&vol->cdev);
+		ubi_sysfs_vol_close(vol);
+	}
+}
+
+/**
+ * ubi_uif_init - initialize user interfaces for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_uif_init(struct ubi_info *ubi)
+{
+	int i, err;
+
+	dbg_uif("initialize the user interfaces unit");
+
+	spin_lock_init(&ubi->uif.volumes_list_lock);
+	mutex_init(&ubi->uif.vol_check_lock);
+	mutex_init(&ubi->uif.vol_change_lock);
+	INIT_LIST_HEAD(&ubi->uif.volumes);
+
+	sprintf(ubi->uif.ubi_name, UBI_STRING_NAME "%d", ubi->ubi_num);
+
+	err = ubi_cdev_init(ubi);
+	if (err)
+		return 0;
+
+	err = ubi_sysfs_init(ubi);
+	if (err)
+		goto out_cdev;
+
+	for (i = 0; i < ubi->vtbl.vt_slots; i++) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		cond_resched();
+
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr))
+			continue;
+
+		err = ubi_vmt_mkvol(ubi, i, NULL);
+		if (err < 0)
+			goto out_volumes;
+	}
+
+	dbg_uif("the user interfaces unit is initialized");
+	return 0;
+
+out_volumes:
+	kill_volumes(ubi);
+	ubi_sysfs_close(ubi);
+out_cdev:
+	ubi_cdev_close(ubi);
+	return err;
+}
+
+/**
+ * ubi_uif_close - close the UBI user interface unit for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_uif_close(struct ubi_info *ubi)
+{
+	dbg_uif("close the user interface unit for %s", ubi->uif.ubi_name);
+
+	kill_volumes(ubi);
+	ubi_sysfs_close(ubi);
+	ubi_cdev_close(ubi);
+}
+
+/**
+ * ubi_uif_get_exclusive - get exclusive access to an UBI volume.
+ *
+ * @desc: volume descriptor
+ *
+ * This function changes UBI volume mode to "exclusive". Obviously, the caller
+ * has to be the only holder of the volume to make this function succeed.
+ * Returns previous mode value (positive integer) in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_uif_get_exclusive(struct ubi_vol_desc *desc)
+{
+	int users, ret;
+	struct ubi_uif_volume *vol = desc->vol;
+
+	spin_lock(&vol->vol_lock);
+	users = vol->readers + vol->writers + vol->exclusive;
+	ubi_assert(users > 0);
+	if (users > 1) {
+		dbg_err("%d users for volume %d", users, vol->vol_id);
+		ret = -EBUSY;
+	} else {
+		dbg_uif("changed volume %d mode %d to exclusive",
+			vol->vol_id, desc->mode);
+		vol->readers = vol->writers = 0;
+		vol->exclusive = 1;
+	}
+	spin_unlock(&vol->vol_lock);
+
+	ret = desc->mode;
+	desc->mode = UBI_EXCLUSIVE;
+	return ret;
+}
+
+/**
+ * ubi_uif_revoke_exclusive - switch to a non-exclusive open mode.
+ *
+ * @desc: volume descriptor
+ * @mode: the new mode to switch to
+ *
+ * This function revokes the "exclusive" mode and switches to the @mode mode.
+ */
+void ubi_uif_revoke_exclusive(struct ubi_vol_desc *desc, int mode)
+{
+	struct ubi_uif_volume *vol = desc->vol;
+
+	spin_lock(&vol->vol_lock);
+	ubi_assert(vol->readers == 0 && vol->writers == 0);
+	ubi_assert(vol->exclusive == 1 && desc->mode == UBI_EXCLUSIVE);
+
+	vol->exclusive = 0;
+	if (mode == UBI_READONLY)
+		vol->readers = 1;
+	else if (mode == UBI_READWRITE)
+		vol->writers = 1;
+	else
+		vol->exclusive = 1;
+
+	spin_unlock(&vol->vol_lock);
+
+	desc->mode = mode;
+	dbg_uif("revoke exclusive mode for volume %d, new mode is %d",
+		vol->vol_id, mode);
+}
