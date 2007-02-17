Return-Path: <linux-kernel-owner+w=401wt.eu-S965357AbXBQQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357AbXBQQ5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965346AbXBQQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:57:00 -0500
Received: from smtp.nokia.com ([131.228.20.173]:32786 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992470AbXBQQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:38 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:05 +0200
Message-Id: <20070217165605.5845.69568.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/44 take 2] [UBI] volume table unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:32.0552 (UTC) FILETIME=[6FBBD480:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185239-0B11ABB0-43D76296/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/vtbl.c tmp-to/drivers/mtd/ubi/vtbl.c
--- tmp-from/drivers/mtd/ubi/vtbl.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/vtbl.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,1369 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) Nokia Corporation, 2006
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
+#include <linux/string.h>
+#include <linux/crc32.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <mtd/ubi-header.h>
+#include <asm/div64.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "wl.h"
+#include "io.h"
+#include "vtbl.h"
+#include "eba.h"
+#include "scan.h"
+#include "misc.h"
+#include "debug.h"
+
+static int change_volume(const struct ubi_info *ubi,
+			 int vol_id, const struct ubi_vtbl_vtr *vtr);
+static void fill_data_size_fields(const struct ubi_info *ubi,
+				  struct ubi_vtbl_vtr *vtr);
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_VTBL
+static int paranoid_check_vtr(const struct ubi_info *ubi,
+			      const struct ubi_vtbl_vtr *vtr);
+#else
+#define paranoid_check_vtr(ubi, vtr) 0
+#endif
+
+int ubi_vtbl_mkvol(const struct ubi_info *ubi, int vol_id,
+		   const struct ubi_vtbl_vtr *vtr)
+{
+	int err;
+	struct ubi_vtbl_vtr new_vtr;
+
+	dbg_vtbl("create volume: vol_id %d, reserved_pebs %d, "
+		 "alignment %d, data_pad %d, vol_type %d, "
+		 "name_len %d, name %s", vol_id, vtr->reserved_pebs,
+		 vtr->alignment, vtr->data_pad, vtr->vol_type,
+		 vtr->name_len, vtr->name);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl->vt_slots);
+	ubi_assert(vtr->reserved_pebs > 0);
+	ubi_assert(ubi->vtbl->vt[vol_id].reserved_pebs == 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+
+	memset(&new_vtr, 0, sizeof(struct ubi_vtbl_vtr));
+	new_vtr.reserved_pebs = vtr->reserved_pebs;
+	new_vtr.alignment = vtr->alignment;
+	new_vtr.data_pad = vtr->data_pad;
+	new_vtr.vol_type = vtr->vol_type;
+	new_vtr.name_len = vtr->name_len;
+	new_vtr.name = vtr->name;
+
+	fill_data_size_fields(ubi, &new_vtr);
+
+	err = change_volume(ubi, vol_id, &new_vtr);
+	return err;
+}
+
+int ubi_vtbl_rmvol(const struct ubi_info *ubi, int vol_id)
+{
+	int err;
+	struct ubi_vtbl_vtr empty_vtr;
+
+	dbg_vtbl("remove volume %d", vol_id);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl->vt_slots);
+	ubi_assert(ubi->vtbl->vt[vol_id].reserved_pebs != 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+
+	empty_vtr.reserved_pebs = 0;
+	err = change_volume(ubi, vol_id, &empty_vtr);
+	return err;
+}
+
+int ubi_vtbl_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int err;
+	struct ubi_vtbl_vtr vtr;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	dbg_vtbl("re-size volume %d to %d LEBs, old size %d LEBs", vol_id,
+		 reserved_pebs, vtbl->vt[vol_id].reserved_pebs);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0 && vol_id < vtbl->vt_slots);
+	ubi_assert(reserved_pebs > 0);
+	ubi_assert(vtbl->vt[vol_id].reserved_pebs != 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+
+	memcpy(&vtr, &vtbl->vt[vol_id], sizeof(struct ubi_vtbl_vtr));
+
+	vtr.name = strdup_len(vtbl->vt[vol_id].name,
+			      vtbl->vt[vol_id].name_len);
+	if (!vtr.name)
+		return -ENOMEM;
+
+	vtr.reserved_pebs = reserved_pebs;
+	err = change_volume(ubi, vol_id, &vtr);
+	ubi_kfree(vtr.name);
+	return err;
+}
+
+int ubi_vtbl_set_upd_marker(const struct ubi_info *ubi, int vol_id)
+{
+	int err;
+	struct ubi_vtbl_vtr vtr;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	dbg_vtbl("set update marker for volume %d", vol_id);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0 && vol_id < vtbl->vt_slots);
+	ubi_assert(vtbl->vt[vol_id].reserved_pebs != 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+
+	if (vtbl->vt[vol_id].upd_marker) {
+		dbg_vtbl("update marker is already set, do nothing");
+		return 0;
+	}
+
+	memcpy(&vtr, &vtbl->vt[vol_id], sizeof(struct ubi_vtbl_vtr));
+
+	vtr.name = strdup_len(vtbl->vt[vol_id].name,
+			      vtbl->vt[vol_id].name_len);
+	if (!vtr.name)
+		return -ENOMEM;
+	vtr.upd_marker = 1;
+
+	err = change_volume(ubi, vol_id, &vtr);
+	ubi_kfree(vtr.name);
+	return err;
+}
+
+int ubi_vtbl_clear_upd_marker(const struct ubi_info *ubi, int vol_id,
+			      long long bytes)
+{
+	int err;
+	struct ubi_vtbl_vtr vtr;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	dbg_vtbl("clear update marker for volume %d", vol_id);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0 && vol_id < vtbl->vt_slots);
+	ubi_assert(vtbl->vt[vol_id].reserved_pebs != 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(bytes >= 0 && bytes <= vtbl->vt[vol_id].usable_leb_size *
+				          vtbl->vt[vol_id].reserved_pebs);
+
+	if (!vtbl->vt[vol_id].upd_marker) {
+		dbg_vtbl("update marker is already cleared, do nothing");
+		return 0;
+	}
+
+	memcpy(&vtr, &vtbl->vt[vol_id], sizeof(struct ubi_vtbl_vtr));
+
+	vtr.name = strdup_len(vtbl->vt[vol_id].name,
+			      vtbl->vt[vol_id].name_len);
+	if (!vtr.name)
+		return -ENOMEM;
+	vtr.upd_marker = 0;
+
+	if (vtbl->vt[vol_id].vol_type == UBI_STATIC_VOLUME) {
+		dbg_vtbl("set data length of static volume %d to %lld",
+			 vol_id, bytes);
+		vtr.used_bytes = bytes;
+		vtr.corrupted = 0;
+		fill_data_size_fields(ubi, &vtr);
+	} else
+		ubi_assert(vtr.corrupted == 0);
+
+	err = paranoid_check_vtr(ubi, &vtbl->vt[vol_id]);
+	if (err)
+		return err;
+
+	err = change_volume(ubi, vol_id, &vtr);
+	ubi_kfree(vtr.name);
+
+	return err;
+}
+
+int ubi_vtbl_set_corrupted(const struct ubi_info *ubi, int vol_id)
+{
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	struct ubi_vtbl_vtr *vtr = &vtbl->vt[vol_id];
+
+	ubi_assert(vol_id >= 0 && vol_id < vtbl->vt_slots);
+	ubi_assert(ubi->vtbl->vt[vol_id].reserved_pebs != 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(ubi->vtbl->vt[vol_id].upd_marker == 0);
+
+	if (vtr->vol_type == UBI_STATIC_VOLUME) {
+		dbg_vtbl("mark static volume %d as corrupted", vol_id);
+		vtr->corrupted = 1;
+	}
+
+	return 0;
+}
+
+static const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
+					       int vol_id);
+
+const struct ubi_vtbl_vtr *ubi_vtbl_get_vtr(const struct ubi_info *ubi,
+					    int vol_id)
+{
+	int err;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+
+	if (ubi_is_ivol(vol_id))
+		return get_ivol_vtr(ubi, vol_id);
+
+	ubi_assert(vol_id >= 0 && vol_id < vtbl->vt_slots);
+
+	if (vtbl->vt[vol_id].reserved_pebs == 0)
+		return ERR_PTR(-ENODEV);
+
+	err = paranoid_check_vtr(ubi, &vtbl->vt[vol_id]);
+	return &vtbl->vt[vol_id];
+}
+
+int ubi_vtbl_get_compat(const struct ubi_info *ubi, int vol_id)
+{
+	if (!ubi_is_ivol(vol_id))
+		return 0;
+
+	switch (vol_id) {
+		case UBI_LAYOUT_VOL_ID:
+			return UBI_LAYOUT_VOLUME_COMPAT;
+		default:
+			BUG();
+	}
+
+	return -ENODEV;
+}
+
+static int init_ram_vt(const struct ubi_info *ubi,
+		       const struct ubi_scan_info *si,
+		       const struct ubi_vol_tbl_record *vol_tbl);
+
+static struct ubi_vol_tbl_record *create_empty_lvol(const struct ubi_info *ubi,
+						    struct ubi_scan_info *si);
+
+static struct ubi_vol_tbl_record *process_lvol(const struct ubi_info *ubi,
+					       struct ubi_scan_info *si,
+					       struct ubi_scan_volume *sv);
+
+static int check_scanning_info(const struct ubi_info *ubi,
+			       struct ubi_scan_info *si);
+
+static void free_volume_info(const struct ubi_info *ubi);
+
+static void init_ivols(struct ubi_info *ubi);
+
+int ubi_vtbl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err;
+	uint32_t crc;
+	struct ubi_vol_tbl_record *vol_tbl;
+	struct ubi_vtbl_info *vtbl;
+	struct ubi_scan_volume *sv;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_vtbl("initialize the volume table unit");
+
+	vtbl = ubi_kzalloc(sizeof(struct ubi_vtbl_info));
+	if (!vtbl)
+		return -ENOMEM;
+	ubi->vtbl = vtbl;
+
+	mutex_init(&vtbl->mutex);
+
+	/* Initialize the empty volume table record pattern */
+	vol_tbl = (struct ubi_vol_tbl_record *)&vtbl->empty_rec;
+	crc = crc32(UBI_CRC32_INIT, vol_tbl, UBI_VTBL_RECORD_SIZE_CRC);
+	vol_tbl->crc = cpu_to_ubi32(crc);
+
+	/*
+	 * The number of supported volumes is limited by the eraseblock size
+	 * and by the UBI_MAX_VOLUMES constant.
+	 */
+	vtbl->vt_slots = io->leb_size / UBI_VTBL_RECORD_SIZE;
+	if (vtbl->vt_slots > UBI_MAX_VOLUMES)
+		vtbl->vt_slots = UBI_MAX_VOLUMES;
+
+	/*
+	 * We are going to calculate size of the volume table. It must be less
+	 * then the logical eraseblock size or equivalent to it. Here we also
+	 * ensure that @vtbl->vt_size has correct alignment (i.e., it is
+	 * multiple of the minimal flash I/O unit size).
+	 */
+	vtbl->vt_size = vtbl->vt_slots * UBI_VTBL_RECORD_SIZE;
+	vtbl->vt_size = align_up(vtbl->vt_size, io->min_io_size);
+
+	sv = ubi_scan_find_sv(si, UBI_LAYOUT_VOL_ID);
+	if (!sv) {
+		/*
+		 * No logical eraseblocks belonging to the layout volume were
+		 * found. This could mean that the flash is just empty. In
+		 * this case we "UBI-nize" this flash by means of creating a
+		 * layout volume with an empty volume table.
+		 *
+		 * But if flash is not empty this must be a serious corruption
+		 * or we were just fed by a bad/random/etc data. We could try
+		 * to do some recovery, but it is not implemented. And it seems
+		 * its better to do this using some user-space tools.
+		 */
+		if (si->is_empty) {
+			vol_tbl = create_empty_lvol(ubi, si);
+			if (IS_ERR(vol_tbl)) {
+				err = PTR_ERR(vol_tbl);
+				goto out;
+			}
+		} else {
+			ubi_err("the layout volume was not found");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		/*
+		 * The layout volume was found during scanning, lets look at
+		 * it, check it, etc.
+		 */
+
+		if (sv->leb_count > UBI_LAYOUT_VOLUME_EBS) {
+			/* This must not happen with right UBI images */
+			dbg_err("too many logical LEBs (%d) belonging to the "
+				"layout volume found", sv->leb_count);
+			err = -EINVAL;
+			goto out;
+		}
+
+		vol_tbl = process_lvol(ubi, si, sv);
+		if (IS_ERR(vol_tbl)) {
+			err = PTR_ERR(vol_tbl);
+			goto out;
+		}
+	}
+
+	/*
+	 * The layout volume is OK, initialize the corresponding in-RAM data
+	 * structures.
+	 */
+	err = init_ram_vt(ubi, si, vol_tbl);
+	if (err)
+		goto out;
+
+	ubi_kfree(vol_tbl);
+
+	init_ivols(ubi);
+
+	/*
+	 * Get sure that the scanning information is consistent to the
+	 * information stored in the volume table.
+	 */
+	err = check_scanning_info(ubi, si);
+	if (err)
+		goto out_vi;
+
+	dbg_vtbl("the volume table unit is initialized");
+	return 0;
+
+out_vi:
+	free_volume_info(ubi);
+out:
+	ubi_kfree(vtbl);
+	return err;
+}
+
+void ubi_vtbl_close(const struct ubi_info *ubi)
+{
+	dbg_vtbl("close the volume table unit");
+	free_volume_info(ubi);
+	ubi_kfree(ubi->vtbl);
+}
+
+/**
+ * change_volume - change geometry of an user volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to change
+ * @vtr: new volume table record
+ *
+ * This function accepts a new volume table record in @vtr and changes the
+ * volume table correspondingly (both in RAM and on flash). If the
+ * @vtr->reserved_pebs field contains zero, the volume is be deleted.
+ *
+ * This function changes both on-flash and in-RAM volume tables. Returns zero
+ * in case of success and a negative error code in case of failure.
+ */
+static int change_volume(const struct ubi_info *ubi,
+			 int vol_id, const struct ubi_vtbl_vtr *vtr)
+{
+	int i, err;
+	struct ubi_vol_tbl_record *vol_tbl;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	vol_tbl = ubi_kzalloc(vtbl->vt_size);
+	if (!vol_tbl)
+		return -ENOMEM;
+
+	mutex_lock(&vtbl->mutex);
+
+	/* Generate the on-flash volume table contents */
+	for (i = 0; i < vtbl->vt_slots; i++) {
+		uint32_t crc;
+		const struct ubi_vtbl_vtr *tmp_vtr;
+
+		cond_resched();
+		tmp_vtr = &vtbl->vt[i];
+
+		err = paranoid_check_vtr(ubi, tmp_vtr);
+		if (unlikely(err))
+			goto out_unlock;
+
+		if (unlikely(i == vol_id))
+			tmp_vtr = vtr;
+
+		if (tmp_vtr->reserved_pebs == 0) {
+			/* Volume is empty */
+			memcpy(&vol_tbl[i], &vtbl->empty_rec, UBI_VTBL_RECORD_SIZE);
+			continue;
+		}
+
+		vol_tbl[i].reserved_pebs = cpu_to_ubi32(tmp_vtr->reserved_pebs);
+		vol_tbl[i].alignment = cpu_to_ubi32(tmp_vtr->alignment);
+		vol_tbl[i].data_pad = cpu_to_ubi32(tmp_vtr->data_pad);
+		vol_tbl[i].upd_marker = tmp_vtr->upd_marker;
+		if (tmp_vtr->vol_type == UBI_DYNAMIC_VOLUME)
+			vol_tbl[i].vol_type = UBI_VID_DYNAMIC;
+		else
+			vol_tbl[i].vol_type = UBI_VID_STATIC;
+		vol_tbl[i].name_len = cpu_to_ubi16((uint16_t)tmp_vtr->name_len);
+
+		memcpy(&vol_tbl[i].name, tmp_vtr->name, tmp_vtr->name_len);
+		vol_tbl[i].name[tmp_vtr->name_len] = '\0';
+
+		crc = crc32(UBI_CRC32_INIT, &vol_tbl[i],
+			    UBI_VTBL_RECORD_SIZE_CRC);
+		vol_tbl[i].crc = cpu_to_ubi32(crc);
+	}
+
+	/* Update both volume table copies */
+	for (i = 0; i < UBI_LAYOUT_VOLUME_EBS; i++) {
+		cond_resched();
+
+		err = ubi_eba_erase_leb(ubi, UBI_LAYOUT_VOL_ID, i);
+		if (unlikely(err))
+			goto out_unlock;
+
+		err = ubi_wl_flush(ubi);
+		if (unlikely(err))
+			goto out_unlock;
+
+		err = ubi_eba_write_leb(ubi, UBI_LAYOUT_VOL_ID, i, vol_tbl, 0,
+					vtbl->vt_size, UBI_DATA_LONGTERM);
+		if (unlikely(err))
+			goto out_unlock;
+	}
+
+	/* Change the in-RAM volume table correspondingly */
+	ubi_kfree(vtbl->vt[vol_id].name);
+	if (vtr->reserved_pebs != 0) {
+		memcpy(&vtbl->vt[vol_id], vtr, sizeof(struct ubi_vtbl_vtr));
+		vtbl->vt[vol_id].name = strdup_len(vtr->name, vtr->name_len);
+		if (!vtbl->vt[vol_id].name) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+		if (vtr->vol_type == UBI_DYNAMIC_VOLUME)
+			vtbl->vt[vol_id].used_ebs = vtr->reserved_pebs;
+		if (unlikely(paranoid_check_vtr(ubi, &vtbl->vt[vol_id]))) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+	} else
+		memset(&vtbl->vt[vol_id], 0, sizeof(struct ubi_vtbl_vtr));
+
+	mutex_unlock(&vtbl->mutex);
+	ubi_kfree(vol_tbl);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&vtbl->mutex);
+
+	/*
+	 * The volume table is probably in an inconsistent state now, so switch
+	 * to read-only mode.
+	 */
+	ubi_eba_ro_mode(ubi);
+	ubi_kfree(vol_tbl);
+	return err;
+}
+
+/**
+ * fill_data_size_fields - fills data size-related fields in a volume table
+ * record.
+ *
+ * @ubi: the UBI device description object
+ * @vtr: a pointer to the volume table record to fill
+ *
+ * This function initializes the @vtr->usable_leb_size, @vtr->used_ebs and
+ * @vtr->last_eb_bytes fields of the volume table record using the
+ * @vtr->vol_type, @vtr->data_pad, and @vtr->bytes fields.
+ */
+static void fill_data_size_fields(const struct ubi_info *ubi,
+				  struct ubi_vtbl_vtr *vtr)
+{
+	const struct ubi_io_info *io = ubi->io;
+
+	vtr->usable_leb_size = io->leb_size - vtr->data_pad;
+
+	if (vtr->vol_type == UBI_DYNAMIC_VOLUME) {
+		vtr->used_ebs = vtr->reserved_pebs;
+		vtr->last_eb_bytes = vtr->usable_leb_size;
+		vtr->used_bytes = vtr->used_ebs * vtr->usable_leb_size;
+	} else {
+		uint64_t tmp = vtr->used_bytes;
+
+		vtr->last_eb_bytes = do_div(tmp, vtr->usable_leb_size);
+		vtr->used_ebs = tmp;
+		if (vtr->last_eb_bytes)
+			vtr->used_ebs += 1;
+		else
+			vtr->last_eb_bytes = vtr->usable_leb_size;
+	}
+}
+
+static int create_vtbl(const struct ubi_info *ubi, struct ubi_scan_info *si,
+		       int copy, void *vol_tbl);
+
+/**
+ * create_empty_lvol - create an empty layout volume.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * If during scanning it was found out that the flash device is empty, this
+ * function is called to create an empty layout volume.
+ *
+ * This function returns the volume table contents in case of success and an
+ * error code in case of failure.
+ */
+static struct ubi_vol_tbl_record *create_empty_lvol(const struct ubi_info *ubi,
+						    struct ubi_scan_info *si)
+{
+	int i, err;
+	struct ubi_vol_tbl_record *vol_tbl;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	vol_tbl = ubi_kmalloc(vtbl->vt_size);
+	if (!vol_tbl)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < vtbl->vt_slots; i++)
+		memcpy(&vol_tbl[i], &vtbl->empty_rec, UBI_VTBL_RECORD_SIZE);
+
+	for (i = 0; i < UBI_LAYOUT_VOLUME_EBS; i++) {
+		cond_resched();
+
+		err = create_vtbl(ubi, si, i, vol_tbl);
+		if (unlikely(err))
+			goto out_free;
+	}
+
+	return vol_tbl;
+
+out_free:
+	ubi_kfree(vol_tbl);
+	return ERR_PTR(err);
+}
+
+static int vol_tbl_check(const struct ubi_info *ubi,
+			 const struct ubi_vol_tbl_record *vol_tbl);
+
+/**
+ * process_lvol - process the layout volume.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @sv: scanning information about the layout volume
+ *
+ * This function is responsible for reading the layout volume, ensuring it is
+ * not corrupted, and recovering from corruptions if needed.
+ *
+ * This function returns the volume table in case of success and a negative
+ * error code in case of failure.
+ */
+static struct ubi_vol_tbl_record *process_lvol(const struct ubi_info *ubi,
+					       struct ubi_scan_info *si,
+					       struct ubi_scan_volume *sv)
+{
+	int err;
+	struct rb_node *rb;
+	struct ubi_scan_leb *seb;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	struct ubi_vol_tbl_record *leb[UBI_LAYOUT_VOLUME_EBS] = { NULL, NULL };
+	int leb_corrupted[UBI_LAYOUT_VOLUME_EBS] = {1, 1};
+
+	/*
+	 * UBI goes through the following steps when it updates the layout
+	 * volume:
+	 * a. erase LEB 0;
+	 * b. write new data to LEB 0;
+	 * c. erase LEB 1;
+	 * d. write new data to LEB 1.
+	 * Before being updated, LEBs 0 and 1 contain the same data.
+	 *
+	 * Owing to unclean reboots, we may lose the contents of LEB 0 but there
+	 * is always LEB 1 present. Thus, it is normal situation when LEB 0 is
+	 * corrupted while LEB 1 is OK. Also, due to unclean reboots, the LEB 1
+	 * may be corrupted, but there has to be LEB 0. And finally, unclean
+	 * reboots may result in a situation when neither LEB 0 nor LEB 1 are
+	 * corrupted, but are different. In this case, LEB 0 contains more
+	 * recent information.
+	 *
+	 * So the plan is to first check LEB 0. Then
+	 * a. if LEB 0 is OK, it contains the most resent data; then we
+	 * compare its contents with LEB 1, and if they are different, we copy
+	 * LEB 0 to LEB 1.
+	 * b. if LEB 0 is corrupted, but LEB 1 is OK, we copy LEB 1 to LEB 0.
+	 */
+
+	dbg_vtbl("check the layout volume");
+
+	/* Read both LEB 0 and LEB 1 into RAM */
+	rb_for_each_entry(rb, seb, &sv->root, u.rb) {
+		cond_resched();
+
+		leb[seb->lnum] = ubi_kzalloc(vtbl->vt_size);
+		if (!leb[seb->lnum]) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		err = ubi_io_read_data(ubi, leb[seb->lnum], seb->pnum, 0,
+				      vtbl->vt_size);
+		if (err == UBI_IO_BITFLIPS || err == -EBADMSG)
+			/* Scrub the PEB later */
+			seb->scrub = 1;
+		else if (err)
+			goto out_free;
+	}
+
+	if (leb[0])
+		leb_corrupted[0] = vol_tbl_check(ubi, leb[0]);
+
+	if (leb_corrupted[0] == 0) {
+		/* LEB 0 is OK */
+
+		if (leb[1])
+			leb_corrupted[1] = memcmp(leb[0], leb[1],
+						  vtbl->vt_size);
+		if (leb_corrupted[1]) {
+			ubi_warn("the volume table copy #2 is corrupted");
+			err = create_vtbl(ubi, si, 1, leb[0]);
+			if (err)
+				goto out_free;
+		}
+
+		/* Both LEB 1 and LEB 2 are OK and consistent */
+		ubi_kfree(leb[1]);
+		return leb[0];
+	} else {
+		/* LEB 0 is corrupted or does not exist */
+		if (leb[1])
+			leb_corrupted[1] = vol_tbl_check(ubi, leb[1]);
+		if (leb_corrupted[1]) {
+			/*
+			 * Both LEB 0 and LEB 1 are corrupted. We don't try to
+			 * restore them and let user-space tools do this.
+			 */
+			ubi_err("the layout volume is corrupted");
+			err = -EINVAL;
+			goto out_free;
+		}
+
+		ubi_warn("the volume table copy #1 is corrupted");
+		err = create_vtbl(ubi, si, 0, leb[1]);
+		if (err)
+			goto out_free;
+
+		ubi_kfree(leb[0]);
+		return leb[1];
+	}
+
+out_free:
+	ubi_kfree(leb[0]);
+	ubi_kfree(leb[1]);
+	return ERR_PTR(err);
+}
+
+/**
+ * create_vtbl - create a copy of the volume table.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @copy: the number of the volume table copy
+ * @vol_tbl: the contents of the volume table
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int create_vtbl(const struct ubi_info *ubi, struct ubi_scan_info *si,
+		       int copy, void *vol_tbl)
+{
+	int err, tries = 0, pnum, ec;
+	unsigned int leb_ver;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	static struct ubi_vid_hdr *vid_hdr;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *new_seb, *old_seb = NULL;
+
+	ubi_msg("create volume table (copy #%d)", copy + 1);
+
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (!vid_hdr)
+		return -ENOMEM;
+
+	/*
+	 * First we look if there is a logical eraseblock which would have to
+	 * contain this volume table copy was found during scanning. We have
+	 * to wipe it.
+	 */
+	sv = ubi_scan_find_sv(si, UBI_LAYOUT_VOL_ID);
+	if (sv)
+		old_seb = ubi_scan_find_seb(sv, copy);
+
+retry:
+	new_seb = ubi_scan_get_free_peb(ubi, si);
+	if (IS_ERR(new_seb)) {
+		err = PTR_ERR(new_seb);
+		goto out_free;
+	}
+	pnum = new_seb->pnum;
+	ec = new_seb->ec;
+	ubi_free_scan_leb(new_seb);
+
+	vid_hdr->vol_type = UBI_VID_DYNAMIC;
+	vid_hdr->vol_id = cpu_to_ubi32(UBI_LAYOUT_VOL_ID);
+	vid_hdr->compat = UBI_LAYOUT_VOLUME_COMPAT;
+	vid_hdr->data_size = vid_hdr->used_ebs =
+			     vid_hdr->data_pad = cpu_to_ubi32(0);
+	vid_hdr->lnum = cpu_to_ubi32(copy);
+	leb_ver = old_seb ? old_seb->leb_ver + 1: 0;
+	vid_hdr->leb_ver = cpu_to_ubi32(leb_ver);
+
+	/* The EC header is already there, write the VID header */
+	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
+	if (err)
+		goto write_error;
+
+	/* Write the layout volume contents */
+	err = ubi_io_write_data(ubi, vol_tbl, pnum, 0, vtbl->vt_size);
+	if (err)
+		goto write_error;
+
+	/*
+	 * And add it to the scanning information. Don't delete the old
+	 * @old_seb as it will be deleted and freed in 'ubi_scan_add_peb()'.
+	 */
+	err = ubi_scan_add_peb(ubi, si, pnum, ec, vid_hdr, 0);
+	if (err)
+		goto out_free;
+
+out_free:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return err;
+
+write_error:
+	/* May be this physical eraseblock went bad, try to pick another one */
+	if (++tries <= 5) {
+		err = ubi_scan_add_corr_peb(si, pnum, ec);
+		if (err)
+			goto out_free;
+		goto retry;
+	}
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return err;
+}
+
+/**
+ * init_ivols - initialize internal volumes information.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function initializes information about internal UBI volumes. This
+ * information is not stored on flash but instead, is kept only in RAM.
+ */
+static void init_ivols(struct ubi_info *ubi)
+{
+	struct ubi_vtbl_vtr *vtr;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	const struct ubi_io_info *io = ubi->io;
+
+	/* The layout volume */
+	vtr = &vtbl->ivol_vtrs[0];
+	vtr->reserved_pebs = UBI_LAYOUT_VOLUME_EBS;
+	vtr->alignment = 1;
+	vtr->vol_type = UBI_DYNAMIC_VOLUME;
+	vtr->name_len = sizeof(UBI_LAYOUT_VOLUME_NAME) - 1;
+	vtr->name = UBI_LAYOUT_VOLUME_NAME;
+	vtr->usable_leb_size = io->leb_size;
+	vtr->used_ebs = vtr->reserved_pebs;
+	vtr->last_eb_bytes = vtr->reserved_pebs;
+	vtr->used_bytes = vtr->used_ebs * (io->leb_size - vtr->data_pad);
+}
+
+/**
+ * get_ivol_vtr - get volume table record of an internal volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the requested volume ID
+ *
+ * This function returns a pointer to the volume tabe record. The @vol_id must
+ * be correct.
+ */
+static const struct ubi_vtbl_vtr *get_ivol_vtr(const struct ubi_info *ubi,
+					       int vol_id)
+{
+	ubi_assert(ubi_is_ivol(vol_id));
+	return &ubi->vtbl->ivol_vtrs[vol_id - UBI_INTERNAL_VOL_START];
+}
+
+/**
+ * init_ram_vt - initialize the in-RAM copy of the volume table.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @vol_tbl: the volume table
+ *
+ * This function builds the in-RAM volume table representation. Note, the
+ * in-RAM volume table contains more data than the on-flash volume table. This
+ * function returns zero in case of success and a negative error code in case
+ * of failure.
+ */
+static int init_ram_vt(const struct ubi_info *ubi,
+		       const struct ubi_scan_info *si,
+		       const struct ubi_vol_tbl_record *vol_tbl)
+{
+	int i;
+	struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	vtbl->vt = ubi_kzalloc(vtbl->vt_slots * sizeof(struct ubi_vtbl_vtr));
+	if (!vtbl->vt)
+		return -ENOMEM;
+
+	for (i = 0; i < vtbl->vt_slots; i++) {
+		struct ubi_vtbl_vtr *vtr = &vtbl->vt[i];
+		struct ubi_scan_volume *sv;
+		int name_len;
+		char *name;
+
+		cond_resched();
+
+		vtr->reserved_pebs = ubi32_to_cpu(vol_tbl[i].reserved_pebs);
+
+		/* Skip empty records */
+		if (vtr->reserved_pebs == 0)
+			continue;
+
+		vtr->alignment = ubi32_to_cpu(vol_tbl[i].alignment);
+		vtr->data_pad = ubi32_to_cpu(vol_tbl[i].data_pad);
+		vtr->vol_type = vol_tbl[i].vol_type == UBI_VID_DYNAMIC ?
+		    UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
+		name_len = ubi16_to_cpu(vol_tbl[i].name_len);
+		vtr->name_len = name_len;
+		vtr->usable_leb_size = ubi->io->leb_size - vtr->data_pad;
+
+		vtr->name = ubi_kmalloc(name_len + 1);
+		if (unlikely(!vtr->name)) {
+			free_volume_info(ubi);
+			return -ENOMEM;
+		}
+
+		name = (char *)vtr->name;
+		memcpy(name, vol_tbl[i].name, name_len + 1);
+		name[name_len] = '\0';
+
+		/* Initialize the RAM-only fields */
+
+		/*
+		 * In case of dynamic volume UBI knows nothing about how many
+		 * data is stored there. So assume the whole volume is used.
+		 */
+		if (vtr->vol_type == UBI_DYNAMIC_VOLUME) {
+			vtr->used_ebs = vtr->reserved_pebs;
+			vtr->last_eb_bytes = vtr->usable_leb_size;
+			vtr->used_bytes = vtr->used_ebs * vtr->usable_leb_size;
+			continue;
+		}
+
+		/* Static volumes only */
+		sv = ubi_scan_find_sv(si, i);
+		if (!sv)
+			/*
+			 * No eraseblocks belonging to this volume found. We
+			 * don't actually know whether this static volume is
+			 * completely corrupted or just contains no data. And
+			 * we cannot know this as long as the data table is not
+			 * maintained on flash. So we just assume the volume is
+			 * empty.
+			 */
+			continue;
+
+		if (unlikely(sv->leb_count != sv->used_ebs)) {
+			/*
+			 * We found a static volume which misses several
+			 * eraseblocks. Treat it as corrupted.
+			 */
+			ubi_warn("static volume %d misses %d LEBs",
+				 sv->vol_id, sv->used_ebs - sv->leb_count);
+			vtr->corrupted = 1;
+			continue;
+		}
+
+		vtr->used_ebs = sv->used_ebs;
+		vtr->used_bytes = (vtr->used_ebs - 1) * vtr->usable_leb_size;
+		vtr->used_bytes += sv->last_data_size;
+		vtr->last_eb_bytes = sv->last_data_size;
+	}
+
+	return 0;
+}
+
+/**
+ * free_volume_info - free the in-RAM copy of the volume table.
+ *
+ * @ubi: the UBI device description object
+ */
+static void free_volume_info(const struct ubi_info *ubi)
+{
+	int i;
+
+	for (i = 0; i < ubi->vtbl->vt_slots; i++)
+		ubi_kfree(ubi->vtbl->vt[i].name);
+
+	ubi_kfree(ubi->vtbl->vt);
+}
+
+/**
+ * vol_tbl_check - check if the volume table is not corrupted and contains sane
+ * data.
+ *
+ * @ubi: the UBI device description object
+ * @vol_tbl: the volume table
+ *
+ * This function returns zero if the volume table is all right and %-EINVAL if
+ * not.
+ */
+static int vol_tbl_check(const struct ubi_info *ubi,
+			 const struct ubi_vol_tbl_record *vol_tbl)
+{
+	int i, reserved_pebs, alignment, data_pad, vol_type, name_len;
+	int upd_marker;
+	const char *name;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	const struct ubi_io_info *io = ubi->io;
+
+	for (i = 0; i < vtbl->vt_slots; i++) {
+		int n;
+		uint32_t crc;
+
+		cond_resched();
+
+		reserved_pebs = ubi32_to_cpu(vol_tbl[i].reserved_pebs);
+		alignment = ubi32_to_cpu(vol_tbl[i].alignment);
+		data_pad = ubi32_to_cpu(vol_tbl[i].data_pad);
+		upd_marker = vol_tbl[i].upd_marker;
+		vol_type = vol_tbl[i].vol_type;
+		name_len = ubi16_to_cpu(vol_tbl[i].name_len);
+		name = &vol_tbl[i].name[0];
+
+		crc = crc32(UBI_CRC32_INIT, &vol_tbl[i],
+			    UBI_VTBL_RECORD_SIZE_CRC);
+
+		if (unlikely(ubi32_to_cpu(vol_tbl[i].crc) != crc)) {
+			ubi_err("wrong CRC at record %u: %#08x, not %#08x",
+				 i, crc, ubi32_to_cpu(vol_tbl[i].crc));
+			return -EINVAL;
+		}
+
+		if (reserved_pebs == 0) {
+			int is_zero;
+
+			is_zero = ubi_buf_all_zeroes(&vol_tbl[i],
+						     UBI_VTBL_RECORD_SIZE_CRC);
+			if (unlikely(is_zero == 0)) {
+				dbg_err("zero reserved_pebs");
+				goto bad;
+			}
+
+			continue;
+		}
+
+		if (unlikely(reserved_pebs < 0 || alignment < 0 ||
+			     data_pad < 0 || name_len < 0)) {
+			dbg_err("negative values");
+			goto bad;
+		}
+
+		if (unlikely(alignment > io->leb_size)) {
+			dbg_err("too large alignment");
+			goto bad;
+		}
+
+		if (unlikely(alignment == 0)) {
+			dbg_err("zero alignment");
+			goto bad;
+		}
+
+		n = alignment % io->min_io_size;
+		if (alignment != 1 && unlikely(n)) {
+			dbg_err("alignment is not multiple of min I/O unit"
+				 "size");
+			goto bad;
+		}
+
+		n = io->leb_size % alignment;
+		if (unlikely(data_pad != n)) {
+			dbg_err("bad data_pad, has to be %d", n);
+			goto bad;
+		}
+
+		if (likely(vol_type != UBI_VID_DYNAMIC &&
+			   vol_type != UBI_VID_STATIC)) {
+			dbg_err("bad vol_type");
+			goto bad;
+		}
+
+		if (unlikely(upd_marker != 0 && upd_marker != 1)) {
+			dbg_err("bad upd_marker");
+			goto bad;
+		}
+
+		if (unlikely(reserved_pebs > io->good_peb_count)) {
+			dbg_err("too large reserved_pebs");
+			goto bad;
+		}
+
+		if (unlikely(name_len > UBI_VOL_NAME_MAX)) {
+			dbg_err("too long volume name, max is %d",
+				UBI_VOL_NAME_MAX);
+			goto bad;
+		}
+
+		if (unlikely(name[0] == '\0')) {
+			dbg_err("NULL volume name");
+			goto bad;
+		}
+
+		n = strnlen(name, name_len + 1);
+		if (unlikely(name_len != n)) {
+			dbg_err("bad name_len");
+			goto bad;
+		}
+	}
+
+	return 0;
+
+bad:
+	ubi_err("volume table check failed");
+	dbg_err("volume record %d dump:", i);
+	ubi_dbg_dump_vol_tbl_record(&vol_tbl[i]);
+	return -EINVAL;
+}
+
+static int check_sv(const struct ubi_info *ubi,
+		    const struct ubi_scan_volume *sv,
+		    const struct ubi_vtbl_vtr *vtr);
+
+/**
+ * check_scanning_info - check that scanning information is consistent to the
+ * information from the volume table.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * Even though we protect on-flash data by CRC checksums, we still don't trust
+ * the media. Who knows what users are trying to feed us.
+ *
+ * This function returns zero if the scanning information is sane and %-EINVAL
+ * if it is not.
+ */
+static int check_scanning_info(const struct ubi_info *ubi,
+			       struct ubi_scan_info *si)
+{
+	int err, i;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_scan_volume *sv;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+
+	for (i = 0; i < vtbl->vt_slots; i++) {
+		cond_resched();
+
+		vtr = &vtbl->vt[i];
+		sv = ubi_scan_find_sv(si, i);
+
+		if (vtr->reserved_pebs == 0) {
+			if (likely(!sv))
+				continue;
+
+			/*
+			 * The scanning unit has found a volume which does not
+			 * exist according to the information in the volume
+			 * table. This must have happened due to an unclean
+			 * reboot while the volume was being removed. Discard
+			 * these eraseblocks.
+			 */
+			dbg_vtbl("volume %d removal was interrupted, finish it",
+				 sv->vol_id);
+			ubi_scan_rm_volume(ubi, si, sv);
+			continue;
+		}
+
+		if (!sv)
+			continue;
+
+		err = check_sv(ubi, sv, vtr);
+		if (unlikely(err))
+			goto out;
+	}
+
+	/* Check that scanning information about internal UBI volumes is sane */
+	for (i = 0; i < UBI_INT_VOL_COUNT; i++) {
+		cond_resched();
+
+		vtr = get_ivol_vtr(ubi, i + UBI_INTERNAL_VOL_START);
+		ubi_assert(!IS_ERR(vtr));
+
+		sv = ubi_scan_find_sv(si, i + UBI_INTERNAL_VOL_START);
+
+		/*
+		 * If an internal volume was not found, the corresponding
+		 * UBI unit will handle this.
+		 */
+		if (!sv)
+			continue;
+
+		err = check_sv(ubi, sv, vtr);
+		if (unlikely(err))
+			goto out;
+	}
+
+	return 0;
+
+out:
+	return -EINVAL;
+}
+
+/**
+ * check_sv - check sanity of scanning information about a volume.
+ *
+ * @ubi: the UBI device description object
+ * @sv: volume scanning information
+ * @vtr: corresponding volume table record (supposed to be correct)
+ *
+ * This function returns zero if the volume scanning information is sane, and
+ * %-EINVAL if not.
+ */
+static int check_sv(const struct ubi_info *ubi,
+		    const struct ubi_scan_volume *sv,
+		    const struct ubi_vtbl_vtr *vtr)
+{
+	if (unlikely(sv->highest_lnum >= vtr->reserved_pebs)) {
+		dbg_err("bad highest_lnum");
+		goto bad;
+	}
+
+	if (unlikely(sv->leb_count > vtr->reserved_pebs)) {
+		dbg_err("bad leb_count");
+		goto bad;
+	}
+
+	if (unlikely(sv->vol_type != vtr->vol_type)) {
+		dbg_err("bad vol_type");
+		goto bad;
+	}
+
+	if (unlikely(sv->used_ebs > vtr->reserved_pebs)) {
+		dbg_err("bad used_ebs");
+		goto bad;
+	}
+
+	if (unlikely(sv->data_pad != vtr->data_pad)) {
+		dbg_err("bad data_pad");
+		goto bad;
+	}
+
+	return 0;
+
+bad:
+	ubi_err("scanning information is not consistent to volume table");
+	ubi_dbg_dump_sv(sv);
+	ubi_dbg_dump_vtr(vtr);
+	return -EINVAL;
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_VTBL
+
+/**
+ * paranoid_check_vtr - check a &struct ubi_vtbl_vtr object.
+ *
+ * @ubi: the UBI device description object
+ * @vtr: the object pointer to check
+ *
+ * This function returns zero if the volume table record is sane, and %1 if
+ * not.
+ */
+static int paranoid_check_vtr(const struct ubi_info *ubi,
+			      const struct ubi_vtbl_vtr *vtr)
+{
+	long long n;
+	const struct ubi_io_info *io = ubi->io;
+
+	if (vtr->reserved_pebs == 0)
+		return 0;
+
+	if (unlikely(vtr->reserved_pebs < 0 || vtr->alignment < 0 ||
+		     vtr->data_pad < 0 || vtr->name_len < 0)) {
+		ubi_err("negative values");
+		goto fail;
+	}
+
+	if (unlikely(vtr->alignment > io->leb_size)) {
+		ubi_err("too large alignment %d", vtr->alignment);
+		goto fail;
+	}
+
+	if (unlikely(vtr->alignment == 0)) {
+		ubi_err("zero alignment");
+		goto fail;
+	}
+
+	n = vtr->alignment % io->min_io_size;
+	if (vtr->alignment != 1 && unlikely(n)) {
+		ubi_err("alignment %d is not multiple of min I/O unit size",
+			vtr->alignment);
+		goto fail;
+	}
+
+	n = io->leb_size % vtr->alignment;
+	if (unlikely(vtr->data_pad != n)) {
+		ubi_err("bad data_pad %d, has to be %lld", vtr->data_pad, n);
+		goto fail;
+	}
+
+	if (unlikely(vtr->vol_type != UBI_DYNAMIC_VOLUME &&
+		     vtr->vol_type != UBI_STATIC_VOLUME)) {
+		ubi_err("bad vol_type %d", vtr->vol_type);
+		goto fail;
+	}
+
+	if (unlikely(vtr->upd_marker != 0 && vtr->upd_marker != 1)) {
+		ubi_err("zero upd_marker");
+		goto fail;
+	}
+
+	if (unlikely(vtr->reserved_pebs > io->good_peb_count)) {
+		ubi_err("too large reserved_pebs %d", vtr->reserved_pebs);
+		goto fail;
+	}
+
+	if (unlikely(vtr->usable_leb_size != io->leb_size - vtr->data_pad)) {
+		ubi_err("bad usable_leb_size %d, has to be %d",
+			vtr->usable_leb_size, io->leb_size - vtr->data_pad);
+		goto fail;
+	}
+
+	if (unlikely(vtr->name_len > UBI_VOL_NAME_MAX)) {
+		ubi_err("too long volume name %d, max is %d",
+			vtr->name_len, UBI_VOL_NAME_MAX);
+		goto fail;
+	}
+
+	if (unlikely(!vtr->name)) {
+		ubi_err("NULL volume name");
+		goto fail;
+	}
+
+	n = strnlen(vtr->name, vtr->name_len + 1);
+	if (unlikely(n != vtr->name_len)) {
+		ubi_err("bad name_len %d", vtr->name_len);
+		goto fail;
+	}
+
+	/* Check RAM-only fields */
+	n = vtr->used_ebs * vtr->usable_leb_size;
+	if (vtr->vol_type == UBI_DYNAMIC_VOLUME) {
+		if (unlikely(vtr->corrupted != 0)) {
+			ubi_err("bad corrupted");
+			goto fail;
+		}
+
+		if (unlikely(vtr->used_ebs != vtr->reserved_pebs)) {
+			ubi_err("bad used_ebs");
+			goto fail;
+		}
+
+		if (unlikely(vtr->last_eb_bytes != vtr->usable_leb_size)) {
+			ubi_err("bad last_eb_bytes");
+			goto fail;
+		}
+
+		if (unlikely(vtr->used_bytes != n)) {
+			ubi_err("bad used_bytes");
+			goto fail;
+		}
+	} else {
+		if (unlikely(vtr->corrupted != 0 && vtr->corrupted != 1)) {
+			ubi_err("bad corrupted");
+			goto fail;
+		}
+
+		if (unlikely(vtr->used_ebs < 0 ||
+			     vtr->used_ebs > vtr->reserved_pebs)) {
+			ubi_err("bad used_ebs");
+			goto fail;
+		}
+
+		if (unlikely(vtr->last_eb_bytes < 0 ||
+			     vtr->last_eb_bytes > vtr->usable_leb_size)) {
+			ubi_err("bad last_eb_bytes");
+			goto fail;
+		}
+
+		if (unlikely(vtr->used_bytes < 0 || vtr->used_bytes > n ||
+			     vtr->used_bytes < n - vtr->usable_leb_size)) {
+			ubi_err("bad used_bytes");
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	ubi_err("paranoid check failed");
+	ubi_dbg_dump_vtr(vtr);
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_VTBL */
