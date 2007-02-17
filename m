Return-Path: <linux-kernel-owner+w=401wt.eu-S2992582AbXBQRBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992582AbXBQRBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992576AbXBQRBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:01:21 -0500
Received: from smtp.nokia.com ([131.228.20.172]:57290 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992571AbXBQRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:18 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:55 +0200
Message-Id: <20070217165655.5845.82676.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 30/44 take 2] [UBI] update unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:22.0987 (UTC) FILETIME=[8DCB99B0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185423-03D7FBB0-531D300D/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/upd.c tmp-to/drivers/mtd/ubi/upd.c
--- tmp-from/drivers/mtd/ubi/upd.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/upd.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,389 @@
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
+ *
+ * Jan 2007: Alexander Schmidt, hacked per-volume update.
+ */
+
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <asm/uaccess.h>
+#include <asm/div64.h>
+#include "ubi.h"
+#include "upd.h"
+#include "wl.h"
+#include "vtbl.h"
+#include "io.h"
+#include "eba.h"
+#include "misc.h"
+#include "account.h"
+#include "alloc.h"
+#include "scan.h"
+#include "debug.h"
+
+static int ubi_wipe_out_volume(const struct ubi_info *ubi, int vol_id);
+
+int ubi_upd_start(const struct ubi_info *ubi, int vol_id, long long bytes)
+{
+	int err, rem;
+	uint64_t tmp;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_upd_info *upd = ubi->upd;
+
+	dbg_upd("start update of volume %d, %llu bytes", vol_id, bytes);
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(bytes >= 0 &&
+		   bytes <= vtr->usable_leb_size * vtr->reserved_pebs);
+
+	mutex_lock(&upd->mutex);
+
+	if (upd->updating == 1) {
+		dbg_err("volume %d is being updated", upd->vol_id);
+		mutex_unlock(&upd->mutex);
+		return -EBUSY;
+	}
+
+	upd->updating = 1;
+	upd->vol_id = vol_id;
+
+	/* Set the update marker first */
+	err = ubi_vtbl_set_upd_marker(ubi, vol_id);
+	if (err)
+		goto out_unlock;
+
+	/* Before updating, we wipe out the volume */
+	err = ubi_wipe_out_volume(ubi, vol_id);
+	if (err)
+		goto out_unlock;
+
+	if (bytes == 0) {
+		/* Zero bytes means the volume just has to be erased */
+		err = ubi_vtbl_clear_upd_marker(ubi, vol_id, 0);
+		goto out_unlock;
+	}
+
+	tmp = bytes;
+	rem = do_div(tmp, vtr->usable_leb_size);
+	upd->upd_ebs = tmp + !!rem;
+	upd->upd_bytes = bytes;
+	upd->upd_received = 0;
+
+	mutex_unlock(&upd->mutex);
+	return 0;
+
+out_unlock:
+	upd->updating = 0;
+	mutex_unlock(&upd->mutex);
+	return err;
+}
+
+static int write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		     void *buf, int len, int used_ebs);
+
+int ubi_upd_write_data(const struct ubi_info *ubi, int vol_id,
+		       const void __user *buf, int count)
+{
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_upd_info *upd = ubi->upd;
+	int lnum, offs, err = 0, len;
+	uint64_t tmp;
+
+	dbg_upd("write %d bytes requested", count);
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+	ubi_assert(count >= 0);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(count == 0))
+		return 0;
+
+	mutex_lock(&upd->mutex);
+
+	if (unlikely(!upd->updating || upd->vol_id != vol_id)) {
+		dbg_err("volume %d update was not started", vol_id);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	ubi_assert(upd->upd_received >= 0 &&
+		   upd->upd_received < upd->upd_bytes);
+	tmp = upd->upd_received;
+	offs = do_div(tmp, vtr->usable_leb_size);
+	lnum = tmp;
+
+	if (upd->upd_received + count > upd->upd_bytes)
+		count = upd->upd_bytes - upd->upd_received;
+
+	/*
+	 * When updating volumes, we accumulate whole eraseblock and write
+	 * it at once.
+	 */
+
+	if (offs != 0) {
+
+		/*
+		 * This is a write to the middle of the logical eraseblock. We
+		 * copy the data to our update buffer and wait for more data or
+		 * flush it (if the whole eraseblock is written or the update
+		 * is finished).
+		 */
+
+		len = vtr->usable_leb_size - offs;
+		if (len > count)
+			len = count;
+
+		dbg_upd("copy more %d bytes of data", len);
+
+		err = copy_from_user(upd->upd_buf + offs, buf, len);
+		if (err) {
+			dbg_err("memory access error");
+			err = -EFAULT;
+			goto out_unlock;
+		}
+
+		if (offs + len == vtr->usable_leb_size ||
+		    upd->upd_received + len == upd->upd_bytes) {
+			int flush_len = offs + len;
+
+			/*
+			 * OK, we gathered either the whole eraseblock or this
+			 * is the last chunk, it's time to flush our buffer.
+			 */
+
+			ubi_assert(flush_len <= vtr->usable_leb_size);
+
+			err = write_leb(ubi, vol_id, lnum, upd->upd_buf, flush_len,
+					upd->upd_ebs);
+			if (err)
+				goto out_unlock;
+		}
+
+		upd->upd_received += len;
+		count -= len;
+		buf += len;
+		lnum += 1;
+	}
+
+	/*
+	 * If we've got more to write, let's continue. At this point we know we
+	 * are starting from the beginning of an eraseblock.
+	 */
+
+	while (count) {
+		cond_resched();
+
+		if (count > vtr->usable_leb_size)
+			len = vtr->usable_leb_size;
+		else
+			len = count;
+
+		dbg_upd("copy %d bytes of user data", len);
+		err = copy_from_user(upd->upd_buf, buf, len);
+		if (err) {
+			dbg_err("memory access error");
+			err = -EFAULT;
+			goto out_unlock;
+		}
+
+		if (len == vtr->usable_leb_size ||
+		    upd->upd_received + len == upd->upd_bytes) {
+			err = write_leb(ubi, vol_id, lnum, upd->upd_buf, len,
+					upd->upd_ebs);
+			if (unlikely(err))
+				break;
+		}
+
+		upd->upd_received += len;
+		count -= len;
+		lnum += 1;
+		buf += len;
+	}
+
+	ubi_assert(upd->upd_received <= upd->upd_bytes);
+	if (upd->upd_received == upd->upd_bytes) {
+		/* The update is finished, clear the update marker */
+		upd->updating = 0;
+		err = ubi_vtbl_clear_upd_marker(ubi, vol_id, upd->upd_bytes);
+		if (err == 0)
+			err = 1;
+	}
+
+out_unlock:
+	mutex_unlock(&upd->mutex);
+	return err;
+}
+
+int ubi_upd_abort(const struct ubi_info *ubi, int vol_id)
+{
+	int err = 0;
+	struct ubi_upd_info *upd = ubi->upd;
+
+	mutex_lock(&upd->mutex);
+	if (upd->updating && upd->vol_id == vol_id) {
+		dbg_upd("aborting volume %d update - it is damaged since now",
+			vol_id);
+		upd->updating = 0;
+	} else {
+		dbg_upd("volume %d is not under update", vol_id);
+		err = -EINVAL;
+	}
+	mutex_unlock(&upd->mutex);
+
+	return err;
+}
+
+int ubi_upd_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err;
+	struct ubi_upd_info *upd;
+
+	dbg_upd("initialize the update unit");
+
+	upd = ubi_kzalloc(sizeof(struct ubi_upd_info));
+	if (!upd)
+		return -ENOMEM;
+	ubi->upd = upd;
+
+	upd->upd_buf = ubi_kmalloc(ubi->io->leb_size);
+	if (!upd->upd_buf) {
+		err = -ENOMEM;
+		goto out_free_upd;
+	}
+
+	mutex_init(&upd->mutex);
+
+	dbg_upd("the update unit is initialized");
+
+	return 0;
+
+out_free_upd:
+	ubi_kfree(upd);
+	return err;
+}
+
+void ubi_upd_close(const struct ubi_info *ubi)
+{
+	dbg_upd("close the update unit");
+	ubi_kfree(ubi->upd->upd_buf);
+	ubi_kfree(ubi->upd);
+}
+
+/**
+ * ubi_wipe_out_volume - wipe out an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to free
+ *
+ * This function erases all the volume's eraseblocks. Returns zero in case of
+ * success, and a negative error code in case of failure.
+ */
+static int ubi_wipe_out_volume(const struct ubi_info *ubi, int vol_id)
+{
+	int i, err;
+	const struct ubi_vtbl_vtr *vtr;
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->acc->max_volumes);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	for (i = 0; i < vtr->reserved_pebs; i++) {
+		cond_resched();
+
+		err = ubi_eba_erase_leb(ubi, vol_id, i);
+		if (unlikely(err))
+			return err;
+	}
+
+	err = ubi_wl_flush(ubi);
+	return err;
+}
+
+/**
+ * write_leb - write a portion of update data to a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID to write to
+ * @lnum: the logical eraseblock number to write
+ * @buf: the data to write
+ * @len: how many bytes to write
+ * @used_ebs: how many logical eraseblocks will this volume contain
+ *
+ * This function writes a portion of update data to the corresponding logical
+ * eraseblock. If a dynamic volume is being updated, this function checks if
+ * the data contains 0xFF bytes at the end. If yes, the 0xFF bytes are not
+ * written. If the whole buffer contains only 0xFF bytes, the LEB is left
+ * unmapped.
+ *
+ * 0xFF bytes LEBs are skipped in case of dynamic volumes because writing of
+ * 0xFF bytes may have side effects and this PEB won't be writable anymore. In
+ * case of static volume 0xFF bytes are not got rid of because static volumes
+ * are treated specially in UBI: per-LEB CRC is calculated and checked and
+ * presence of all LEBs is taken care of. So we cannot cut amount of data
+ * written to LEBs of static volume or to skip some LEBs in case of static
+ * volumes.
+ */
+static int write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		     void *buf, int len, int used_ebs)
+{
+	int err;
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (vtr->vol_type == UBI_DYNAMIC_VOLUME) {
+		int l;
+
+		ubi_assert(len == vtr->usable_leb_size);
+
+		/* This is dynamic volume - skip the ending 0xFFs */
+		l = ubi_calc_data_len(ubi, buf, len);
+		if (l == 0) {
+			dbg_upd("LEB %d:%d contains only 0xFF bytes - skip",
+				vol_id, lnum);
+			return 0;
+		}
+		if (len != l)
+			dbg_upd("skip last %d bytes of data for LEB %d:%d",
+				len - l, vol_id, lnum);
+
+		err = ubi_eba_write_leb(ubi, vol_id, lnum, buf, 0, l,
+					UBI_DATA_UNKNOWN);
+	} else {
+		/*
+		 * When writing to static volumes, and this is the last logical
+		 * eraseblock, the length (@len) does not have to be aligned to
+		 * the minimal flash I/O unit. The 'ubi_eba_write_leb_st()'
+		 * function needs the exact (unaligned) length to store in the
+		 * VID header. And it will take care of proper alignment by
+		 * padding the buffer. Here we just make sure the padding will
+		 * contain zeros, not random trash.
+		 */
+		memset(buf + len, 0, vtr->usable_leb_size - len);
+		err = ubi_eba_write_leb_st(ubi, vol_id, lnum, buf, len,
+					   UBI_DATA_UNKNOWN, used_ebs);
+	}
+
+	return err;
+}
