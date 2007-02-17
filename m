Return-Path: <linux-kernel-owner+w=401wt.eu-S2992702AbXBQRD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702AbXBQRD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992704AbXBQRDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:03:23 -0500
Received: from smtp.nokia.com ([131.228.20.173]:33876 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992591AbXBQRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:30 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:15 +0200
Message-Id: <20070217165715.5845.15165.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 34/44 take 2] [UBI] volume management unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:43.0127 (UTC) FILETIME=[99CCB870:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185346-0B110BB0-305C46C2/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/volmgmt.c tmp-to/drivers/mtd/ubi/volmgmt.c
--- tmp-from/drivers/mtd/ubi/volmgmt.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/volmgmt.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,374 @@
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
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "io.h"
+#include "wl.h"
+#include "upd.h"
+#include "volmgmt.h"
+#include "vtbl.h"
+#include "misc.h"
+#include "eba.h"
+#include "account.h"
+#include "scan.h"
+#include "debug.h"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_VMT
+static int paranoid_check_vtr(const struct ubi_info *ubi,
+			 const struct ubi_vtbl_vtr *vtr);
+#else
+#define paranoid_check_vtr(ubi, vtr) 0
+#endif
+
+static int find_vacant_vol_id(const struct ubi_info *ubi);
+
+int ubi_vmt_mkvol(const struct ubi_info *ubi, int vol_id,
+		  const struct ubi_vtbl_vtr *vtr)
+{
+	int i, err = 0;
+	struct ubi_vmt_info *vmt = ubi->vmt;
+	const struct ubi_vtbl_vtr *vtr_ck;
+
+	dbg_vmt("create volume ID %d, reserved_pebs %d, type %d, name %s",
+		vol_id, vtr->reserved_pebs, vtr->vol_type, vtr->name);
+
+	mutex_lock(&vmt->mutex);
+
+	if (vol_id == UBI_VOL_NUM_AUTO) {
+		vol_id = find_vacant_vol_id(ubi);
+		if (vol_id < 0) {
+			err = vol_id;
+			goto out_unlock;
+		}
+	} else
+		ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+
+	err = paranoid_check_vtr(ubi, vtr);
+	if (err) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
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
+	for (i = 0; i < ubi->acc->max_volumes; i++) {
+		cond_resched();
+
+		vtr_ck = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr_ck))
+			continue;
+
+		if (unlikely(vtr->name_len == vtr_ck->name_len &&
+			     !strcmp(vtr->name, vtr_ck->name))) {
+			dbg_err("not unique name \"%s\", volume %d has it",
+				vtr->name, i);
+			goto out_unlock;
+		}
+	}
+
+	err = ubi_acc_mkvol(ubi, vtr->reserved_pebs);
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
+	mutex_unlock(&vmt->mutex);
+	return vol_id;
+
+out_eba:
+	ubi_eba_rmvol(ubi, vol_id);
+out_acc:
+	ubi_acc_rmvol(ubi, vtr->reserved_pebs);
+out_unlock:
+	mutex_unlock(&vmt->mutex);
+	return err;
+}
+
+int ubi_vmt_rmvol(const struct ubi_info *ubi, int vol_id)
+{
+	int err, reserved_pebs;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_vmt_info *vmt = ubi->vmt;
+
+	dbg_vmt("remove volume %d", vol_id);
+	ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+
+	mutex_lock(&vmt->mutex);
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
+	ubi_acc_rmvol(ubi, reserved_pebs);
+
+out_unlock:
+	mutex_unlock(&vmt->mutex);
+	return err;
+}
+
+int ubi_vmt_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int err, pebs, old_reserved_pebs;
+	struct ubi_vmt_info *vmt = ubi->vmt;
+	const struct ubi_vtbl_vtr *vtr;
+
+	dbg_vmt("re-size volume %d to %d PEBs", vol_id, reserved_pebs);
+	ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+	ubi_assert(reserved_pebs > 0);
+
+	mutex_lock(&vmt->mutex);
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
+	/* If the size is the same, we have nathing to do */
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
+	mutex_unlock(&vmt->mutex);
+	return err;
+}
+
+int ubi_vmt_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err;
+	struct ubi_vmt_info *vmt;
+
+	dbg_vmt("initialize the volume management unit");
+
+	vmt = ubi_kzalloc(sizeof(struct ubi_vmt_info));
+	if (!vmt)
+		return -ENOMEM;
+	ubi->vmt = vmt;
+
+	mutex_init(&vmt->mutex);
+
+	err = ubi_vtbl_init_scan(ubi, si);
+	if (err)
+		goto out_vmt;
+
+	err = ubi_acc_init_scan(ubi, si);
+	if (err)
+		goto out_vtbl;
+
+	err = ubi_upd_init_scan(ubi, si);
+	if (err)
+		goto out_acc;
+
+	dbg_vmt("the volume management unit is initialized");
+	return 0;
+
+out_acc:
+	ubi_acc_close(ubi);
+out_vtbl:
+	ubi_vtbl_close(ubi);
+out_vmt:
+	ubi_kfree(vmt);
+	return err;
+}
+
+void ubi_vmt_close(const struct ubi_info *ubi)
+{
+	dbg_vmt("close the volume management unit");
+	ubi_upd_close(ubi);
+	ubi_acc_close(ubi);
+	ubi_vtbl_close(ubi);
+	ubi_kfree(ubi->vmt);
+}
+
+/**
+ * find_vacant_vol_id - find an unused volume ID.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns a positive volume ID or %-ENOSPC if there are no free
+ * volume IDs.
+ */
+static int find_vacant_vol_id(const struct ubi_info *ubi)
+{
+	int i;
+
+	for (i = 0; i < ubi->acc->max_volumes; i++) {
+		const struct ubi_vtbl_vtr *vtr;
+
+		cond_resched();
+
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr)) {
+			dbg_vmt("found volume ID %d", i);
+			return i;
+		}
+	}
+
+	dbg_vmt("vacant volume ID not found");
+	return -ENOSPC;
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_VMT
+
+/**
+ * paranoid_check_vtr - check sanity of a &struct ubi_vtbl_vtr object.
+ *
+ * @ubi: the UBI device description object
+ * @vtr: an object to check
+ *
+ * This function returns zero if the volume table record is sane, and %1 if
+ * not.
+ */
+static int paranoid_check_vtr(const struct ubi_info *ubi,
+			      const struct ubi_vtbl_vtr *vtr)
+{
+	int n;
+	const struct ubi_io_info *io = ubi->io;
+
+	if (vtr->reserved_pebs == 0)
+		return 0;
+
+	if (unlikely(vtr->reserved_pebs < 0 || vtr->alignment < 0 ||
+		     vtr->data_pad < 0 || vtr->name_len < 0)) {
+		ubi_err("negative values");
+		goto bad;
+	}
+
+	if (unlikely(vtr->alignment > io->leb_size)) {
+		ubi_err("too large alignment");
+		goto bad;
+	}
+
+	if (unlikely(vtr->alignment == 0)) {
+		ubi_err("zero alignment");
+		goto bad;
+	}
+
+	n = vtr->alignment % io->min_io_size;
+	if (vtr->alignment != 1 && unlikely(n)) {
+		ubi_err("alignment is not multiple of min I/O unit size");
+		goto bad;
+	}
+
+	n = io->leb_size % vtr->alignment;
+	if (unlikely(vtr->data_pad != n)) {
+		ubi_err("bad data_pad, has to be %d", n);
+		goto bad;
+	}
+
+	if (unlikely(vtr->vol_type != UBI_DYNAMIC_VOLUME &&
+		     vtr->vol_type != UBI_STATIC_VOLUME)) {
+		ubi_err("bad vol_type");
+		goto bad;
+	}
+
+	if (unlikely(vtr->name_len > UBI_VOL_NAME_MAX)) {
+		ubi_err("too long volume name, max is %d", UBI_VOL_NAME_MAX);
+		goto bad;
+	}
+
+	if (unlikely(!vtr->name)) {
+		ubi_err("NULL volume name");
+		goto bad;
+	}
+
+	n = strnlen(vtr->name, vtr->name_len + 1);
+	if (unlikely(n != vtr->name_len)) {
+		ubi_err("bad name_len");
+		goto bad;
+	}
+
+	return 0;
+
+bad:
+	ubi_err("volume table record paranoid check failed");
+	ubi_dbg_dump_vtr(vtr);
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_VMT */
