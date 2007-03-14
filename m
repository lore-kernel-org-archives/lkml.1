Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXCNP2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXCNP2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXCNP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:26:25 -0400
Received: from smtp.nokia.com ([131.228.20.172]:25211 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXCNP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:26:20 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:45 +0200
Message-Id: <20070314152045.1112.57749.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/22 take 3] UBI: volume management functionality
X-OriginalArrivalTime: 14 Mar 2007 15:20:44.0786 (UTC) FILETIME=[55E35D20:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172046-50611BB0-474003CD/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/vmt.c tmp-to/drivers/mtd/ubi/vmt.c
--- tmp-from/drivers/mtd/ubi/vmt.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/vmt.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,360 @@
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
+ * This is a part of the user interfaces unit which implements volume creation,
+ * deletion, updating and resizing.
+ */
+
+#include <linux/err.h>
+#include "ubi.h"
+
+/**
+ * find_vacant_vol_id - find an unused volume ID.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns a positive vacant volume ID or %-ENOSPC if there are
+ * no vacant volume slots.
+ */
+static int find_vacant_vol_id(const struct ubi_info *ubi)
+{
+	int i;
+
+	for (i = 0; i < ubi->vtbl.vt_slots; i++) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr)) {
+			dbg_uif("found volume ID %d", i);
+			return i;
+		}
+	}
+
+	dbg_err("vacant volume ID not found");
+	return -ENOSPC;
+}
+
+/**
+ * mkvol_flash - create a volume on flash media.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID to assign to the new volume
+ * @vtr: volume table record describing the new volume
+ *
+ * If @vol_id is %UBI_VOL_NUM_AUTO, then new volume is automatically given an
+ * unused volume identifier. This function returns the ID of the newly created
+ * volume in case of success, and a negative error code in case of failure.
+ */
+static int mkvol_flash(struct ubi_info *ubi, int vol_id,
+		       struct ubi_vtbl_vtr *vtr)
+{
+	int i, err;
+	const struct ubi_vtbl_vtr *vtr_ck;
+
+	mutex_lock(&ubi->uif.vol_change_lock);
+
+	if (vol_id == UBI_VOL_NUM_AUTO) {
+		vol_id = find_vacant_vol_id(ubi);
+		if (vol_id < 0) {
+			err = vol_id;
+			goto out_unlock;
+		}
+	} else
+		ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+
+	/* Get sure that this volume does not exist */
+	err = -EEXIST;
+	vtr_ck = ubi_vtbl_get_vtr(ubi, vol_id);
+	if (!IS_ERR(vtr_ck)) {
+		dbg_err("volume %d already exists", vol_id);
+		goto out_unlock;
+	}
+
+	/* Ensure that this volume has a unique name */
+	for (i = 0; i < ubi->vtbl.vt_slots; i++) {
+		vtr_ck = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr_ck))
+			continue;
+
+		if (vtr->name_len == vtr_ck->name_len &&
+		    strcmp(vtr->name, vtr_ck->name) == 0) {
+			dbg_err("not unique name \"%s\", used by volume %d",
+				vtr->name, i);
+			goto out_unlock;
+		}
+	}
+
+	if (ubi->vtbl.vol_count + 1 > ubi->vtbl.vt_slots) {
+		dbg_err("no room for the volume");
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
+	err = ubi_acc_reserve(ubi, vtr->reserved_pebs);
+	if (err)
+		goto out_unlock;
+
+	/*
+	 * Finish all the pending erases because there may be some LEBs
+	 * belonging to the same volume ID. We don't want to be messed-up.
+	 */
+	err = ubi_wl_flush(ubi);
+	if (err)
+		goto out_acc;
+
+	err = ubi_eba_mkvol(ubi, vol_id, vtr->reserved_pebs);
+	if (err)
+		goto out_acc;
+
+	err = ubi_vtbl_mkvol(ubi, vol_id, vtr);
+	if (err)
+		goto out_eba;
+
+	mutex_unlock(&ubi->uif.vol_change_lock);
+	return vol_id;
+
+out_eba:
+	ubi_eba_rmvol(ubi, vol_id);
+out_acc:
+	ubi_acc_free(ubi, vtr->reserved_pebs);
+out_unlock:
+	mutex_unlock(&ubi->uif.vol_change_lock);
+	return err;
+}
+
+/**
+ * rmvol_flash - remove a volume from the flash media.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to remove
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+static int rmvol_flash(struct ubi_info *ubi, int vol_id)
+{
+	int err, reserved_pebs;
+	const struct ubi_vtbl_vtr *vtr;
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+
+	mutex_lock(&ubi->uif.vol_change_lock);
+
+	/* Ensure that this volume exists */
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	if (IS_ERR(vtr)) {
+		err = PTR_ERR(vtr);
+		goto out_unlock;
+	}
+
+	reserved_pebs = vtr->reserved_pebs;
+
+	err = ubi_vtbl_rmvol(ubi, vol_id);
+	if (err)
+		goto out_unlock;
+
+	err = ubi_eba_rmvol(ubi, vol_id);
+	if (err)
+		goto out_unlock;
+
+	ubi_acc_free(ubi, reserved_pebs);
+
+out_unlock:
+	mutex_unlock(&ubi->uif.vol_change_lock);
+	return err;
+}
+
+/**
+ * ubi_vmt_mkvol - create a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vtr: volume table record of the newly created volume
+ * @vol_id: ID of the new volume
+ *
+ * This function creates an UBI volume. If @vtr is %NULL, this function creates
+ * only the user interface-related data structures for this volume. This is
+ * used when the MTD device is being attached and the volume already exists
+ * on the media.
+ *
+ * If @vtr is not %NULL, the caller has to correctly fill @vtr except of
+ * @vtr->usable_leb_size field. If @vol_id is %UBI_VOL_NUM_AUTO then new volume
+ * is automatically given an unused volume identifier. In case of success the
+ * @vtr object will be filled with new volume information.
+ *
+ * This function returns ID of the newly created volume in case of success, and
+ * a negative error code in case of failure.
+ */
+int ubi_vmt_mkvol(struct ubi_info *ubi, int vol_id, struct ubi_vtbl_vtr *vtr)
+{
+	int err;
+	struct ubi_uif_volume *vol;
+
+	if (vtr) {
+		dbg_uif("create volume ID %d, size %d, type %d, name %s",
+			vol_id, vtr->reserved_pebs, vtr->vol_type, vtr->name);
+
+		err = mkvol_flash(ubi, vol_id, vtr);
+		if (err < 0)
+			return err;
+		vol_id = err;
+	} else
+		ubi_assert(vol_id != UBI_VOL_NUM_AUTO);
+
+	vol = kzalloc(sizeof(struct ubi_uif_volume), GFP_KERNEL);
+	if (!vol) {
+		err = -ENOMEM;
+		goto out_rmvol;
+	}
+
+	vol->ubi = ubi;
+	vol->vol_id = vol_id;
+	spin_lock_init(&vol->vol_lock);
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
+	spin_lock(&ubi->uif.volumes_list_lock);
+	list_add(&vol->list, &ubi->uif.volumes);
+	spin_unlock(&ubi->uif.volumes_list_lock);
+
+	return vol_id;
+
+out_cdev:
+	ubi_cdev_vol_close(vol);
+out_sysfs:
+	ubi_sysfs_vol_close(vol);
+out_rmvol:
+	if (vtr)
+		rmvol_flash(ubi, vol_id);
+	return err;
+}
+
+/**
+ * ubi_vmt_rmvol - remove a volume.
+ *
+ * @desc: volume descriptor
+ * @uif_only: do not remove volume from the media if non zero
+ *
+ * The volume has to be opened in "exclusive" mode. This function returns zero
+ * in case of success and a negative error code in case of failure.
+ */
+int ubi_vmt_rmvol(struct ubi_vol_desc *desc)
+{
+	struct ubi_uif_volume *vol = desc->vol;
+	struct ubi_info *ubi = vol->ubi;
+	int err, vol_id = vol->vol_id;
+
+	dbg_uif("remove UBI volume %d", vol_id);
+	ubi_assert(desc->mode == UBI_EXCLUSIVE);
+
+	err = ubi_gluebi_vol_close(vol);
+	if (err)
+		return err;
+
+	spin_lock(&vol->vol_lock);
+	vol->removed = 1;
+	spin_unlock(&vol->vol_lock);
+
+	spin_lock(&ubi->uif.volumes_list_lock);
+	list_del(&vol->list);
+	spin_unlock(&ubi->uif.volumes_list_lock);
+
+	ubi_cdev_vol_close(vol);
+	ubi_sysfs_vol_close(vol);
+	kfree(desc);
+	module_put(THIS_MODULE);
+
+	return rmvol_flash(ubi, vol_id);
+}
+
+/**
+ * ubi_vmt_rsvol - re-size a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to re-size
+ * @reserved_pebs: new volume size
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_vmt_rsvol(struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int err, pebs, old_reserved_pebs;
+	const struct ubi_vtbl_vtr *vtr;
+
+	dbg_uif("re-size volume %d to %d PEBs", vol_id, reserved_pebs);
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+	ubi_assert(reserved_pebs > 0);
+
+	mutex_lock(&ubi->uif.vol_change_lock);
+
+	/* Ensure that this volume exists */
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	if (IS_ERR(vtr)) {
+		err = PTR_ERR(vtr);
+		goto out_unlock;
+	}
+
+	if (vtr->vol_type == UBI_STATIC_VOLUME &&
+	    reserved_pebs < vtr->used_ebs) {
+		dbg_err("too small size %d, static volume %d has %d used LEBs",
+			reserved_pebs, vol_id, vtr->used_ebs);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* If the size is the same, we have nothing to do */
+	if (reserved_pebs == vtr->reserved_pebs) {
+		err = 0;
+		goto out_unlock;
+	}
+
+	old_reserved_pebs = vtr->reserved_pebs;
+
+	err = ubi_vtbl_rsvol(ubi, vol_id, reserved_pebs);
+	if (err)
+		goto out_unlock;
+
+	pebs = reserved_pebs - old_reserved_pebs;
+	if (pebs > 0) {
+		err = ubi_acc_reserve(ubi, pebs);
+		if (err)
+			goto out_unlock;
+	} else
+		ubi_acc_free(ubi, -pebs);
+
+	err = ubi_eba_rsvol(ubi, vol_id, reserved_pebs);
+	if (err)
+		goto out_unlock;
+
+out_unlock:
+	mutex_unlock(&ubi->uif.vol_change_lock);
+	return err;
+}
