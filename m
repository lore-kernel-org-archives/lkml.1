Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbXCNPXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbXCNPXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXCNPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:36 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23396 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422665AbXCNPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:51 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:34 +0200
Message-Id: <20070314152034.1112.54484.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/22 take 3] UBI: update functionality
X-OriginalArrivalTime: 14 Mar 2007 15:20:34.0724 (UTC) FILETIME=[4FE40640:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/upd.c tmp-to/drivers/mtd/ubi/upd.c
--- tmp-from/drivers/mtd/ubi/upd.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/upd.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,359 @@
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
+/*
+ * This is a part of the user interfaces unit which implements volume update
+ * functionality.
+ *
+ * The update operation is based on the per-volume update marker which is
+ * stored in the volume table. The update marker is set before the update
+ * starts, and removed after the update has been finished. So if the update was
+ * interrupted by an unclean re-boot or due to some other reasons, the update
+ * marker stays on the flash media and UBI finds it when it attaches the MTD
+ * device next time. If there is a set update marker exist for a volume, the
+ * volume is treated as damaged and most I/O operations are prohibited. Only a
+ * new update operation is allowed.
+ *
+ * We do not do any serialization here because the volume update operation is
+ * serialized by opening the volume in the exclusive mode.
+ *
+ * Note, in general it is possible to implement the update operation as a
+ * transaction with a possibility to roll-back. But this is far more complex.
+ * May be in future.
+ */
+
+#include <linux/err.h>
+#include <asm/uaccess.h>
+#include <asm/div64.h>
+#include "ubi.h"
+
+/**
+ * ubi_wipe_out_volume - wipe out an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to free
+ *
+ * This function erases all eraseblocks of a volume. Returns zero in case of
+ * success, and a negative error code in case of failure.
+ */
+static int ubi_wipe_out_volume(struct ubi_info *ubi, int vol_id)
+{
+	int i, err;
+	const struct ubi_vtbl_vtr *vtr;
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	for (i = 0; i < vtr->reserved_pebs; i++) {
+		err = ubi_eba_unmap_leb(ubi, vol_id, i);
+		if (unlikely(err))
+			return err;
+	}
+
+	return ubi_wl_flush(ubi);
+}
+
+
+/**
+ * ubi_upd_start - start volume update operation.
+ *
+ * @vol: volume description object
+ * @bytes: how many bytes will be written to the volume
+ *
+ * This function starts a volume update operation. If @bytes is zero, the
+ * volume is just wiped out. This function returns zero in case of success and
+ * a negative error code in case of failure.
+ */
+int ubi_upd_start(struct ubi_uif_volume *vol, long long bytes)
+{
+	int err, rem, vol_id = vol->vol_id;
+	uint64_t tmp;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = vol->ubi;
+
+	dbg_uif("start update of volume %d, %llu bytes", vol_id, bytes);
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(bytes >= 0);
+	ubi_assert(bytes <= vtr->usable_leb_size * vtr->reserved_pebs);
+
+	vol->updating = 1;
+
+	/* Set the update marker first */
+	err = ubi_vtbl_set_upd_marker(ubi, vol_id);
+	if (err)
+		return err;
+
+	/* Before updating - wipe out the volume */
+	err = ubi_wipe_out_volume(ubi, vol_id);
+	if (err)
+		return err;
+
+	if (bytes == 0) {
+		/* Zero bytes means the volume just has to be erased */
+		err = ubi_vtbl_clear_upd_marker(ubi, vol_id, 0);
+		if (!err)
+			vol->updating = 0;
+		return err;
+	}
+
+	vol->upd_buf = kmalloc(ubi->io.leb_size, GFP_KERNEL);
+	if (!vol->upd_buf)
+		return -ENOMEM;
+
+	tmp = bytes;
+	rem = do_div(tmp, vtr->usable_leb_size);
+	vol->upd_ebs = tmp + !!rem;
+	vol->upd_bytes = bytes;
+	vol->upd_received = 0;
+
+	return 0;
+}
+
+/**
+ * write_leb - write update data to a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to write to
+ * @lnum: logical eraseblock number to write
+ * @buf: data to write
+ * @len: how many bytes to write
+ * @used_ebs: how many logical eraseblocks will this volume contain (static
+ * volumes only)
+ *
+ * This function writes update data to corresponding logical eraseblock. In
+ * case of a dynamic volume, this function checks if the data contains 0xFF
+ * bytes at the end. If yes, the 0xFF bytes are cut and not written. So if the
+ * whole buffer contains only 0xFF bytes, the LEB is left unmapped.
+ *
+ * The reason why we skip the ending 0xFF bytes in case of dynamic volumes is
+ * that we want to make sure that more data may be appended to these logical
+ * eraseblocks in future. Indeed, writing 0xFF bytes may have side effects and
+ * this PEB won't be writable anymore. So if, say, one writes the file-system
+ * image to the UBI volume where 0xFFs mean free space - UBI makes sure this
+ * free space is writable after the update.
+ *
+ * We do not do this for static volumes because they are read-only. But this
+ * also cannot be done because we have to store per-LEB CRC and the correct
+ * data length.
+ *
+ * The data buffer must always contain @vtr->usable_leb_size bytes, unless this
+ * is the last logical eraseblock.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int write_leb(struct ubi_info *ubi, int vol_id, int lnum, void *buf,
+		     int len, int used_ebs)
+{
+	int err;
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(len >= 0 && len <= vtr->usable_leb_size);
+	ubi_assert(used_ebs >= 0 && used_ebs <= vtr->reserved_pebs);
+
+	if (vtr->vol_type == UBI_DYNAMIC_VOLUME) {
+		int l;
+
+		l = align_up(len, ubi->io.min_io_size);
+		memset(buf + len, 0xFF, l - len);
+
+		l = ubi_calc_data_len(ubi, buf, l);
+		if (l == 0) {
+			dbg_uif("all %d bytes contain 0xFF - skip", len);
+			return 0;
+		}
+		if (len != l)
+			dbg_uif("skip last %d bytes (0xFF)", len - l);
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
+
+/**
+ * ubi_upd_write_data - write more data.
+ *
+ * @vol: volume description object
+ * @buf: the data to write (user-space memory buffer)
+ * @count: how much bytes to write
+ *
+ * This function writes more data to the volume which is being updated. It may
+ * be called arbitrary number of times until all of the update data arrive.
+ * This function returns %0 in case of success, a positive number of bytes
+ * written at during this last call if the whole volume update was successfully
+ * finished, and a negative error code in case of failure.
+ */
+int ubi_upd_write_data(struct ubi_uif_volume *vol, const void __user *buf,
+		       int count)
+{
+	uint64_t tmp;
+	const struct ubi_vtbl_vtr *vtr;
+	struct ubi_info *ubi = vol->ubi;
+	int lnum, offs, err = 0, len, to_write = count, vol_id = vol->vol_id;
+
+	dbg_uif("write %d bytes requested", count);
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+	ubi_assert(count >= 0);
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	if (unlikely(count == 0))
+		return 0;
+
+	ubi_assert(vol->updating == 1);
+	ubi_assert(vol->upd_received >= 0);
+	ubi_assert(vol->upd_received < vol->upd_bytes);
+
+	tmp = vol->upd_received;
+	offs = do_div(tmp, vtr->usable_leb_size);
+	lnum = tmp;
+
+	if (vol->upd_received + count > vol->upd_bytes)
+		to_write = count = vol->upd_bytes - vol->upd_received;
+
+	/*
+	 * When updating volumes, we accumulate whole logical eraseblock data
+	 * and write it at once.
+	 */
+
+	if (offs != 0) {
+		/*
+		 * This is a write to the middle of the logical eraseblock. We
+		 * copy the data to our update buffer and wait for more data or
+		 * flush it if the whole eraseblock is written or the update
+		 * is finished.
+		 */
+
+		len = vtr->usable_leb_size - offs;
+		if (len > count)
+			len = count;
+
+		dbg_uif("copy more %d bytes of data", len);
+
+		err = copy_from_user(vol->upd_buf + offs, buf, len);
+		if (unlikely(err)) {
+			dbg_err("memory access error");
+			return -EFAULT;
+		}
+
+		if (offs + len == vtr->usable_leb_size ||
+		    vol->upd_received + len == vol->upd_bytes) {
+			int flush_len = offs + len;
+
+			/*
+			 * OK, we gathered either the whole eraseblock or this
+			 * is the last chunk, it's time to flush our buffer.
+			 */
+
+			ubi_assert(flush_len <= vtr->usable_leb_size);
+
+			err = write_leb(ubi, vol_id, lnum, vol->upd_buf,
+					flush_len, vol->upd_ebs);
+			if (err)
+				return err;
+		}
+
+		vol->upd_received += len;
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
+		if (count > vtr->usable_leb_size)
+			len = vtr->usable_leb_size;
+		else
+			len = count;
+
+		dbg_uif("copy %d bytes of user data", len);
+		err = copy_from_user(vol->upd_buf, buf, len);
+		if (unlikely(err)) {
+			dbg_err("memory access error");
+			return -EFAULT;
+		}
+
+		if (len == vtr->usable_leb_size ||
+		    vol->upd_received + len == vol->upd_bytes) {
+			err = write_leb(ubi, vol_id, lnum, vol->upd_buf, len,
+					vol->upd_ebs);
+			if (unlikely(err))
+				break;
+		}
+
+		vol->upd_received += len;
+		count -= len;
+		lnum += 1;
+		buf += len;
+	}
+
+	ubi_assert(vol->upd_received <= vol->upd_bytes);
+	if (vol->upd_received == vol->upd_bytes) {
+		/* The update is finished, clear the update marker */
+		err = ubi_vtbl_clear_upd_marker(ubi, vol_id, vol->upd_bytes);
+		if (err == 0) {
+			err = to_write;
+			kfree(vol->upd_buf);
+			vol->updating = 0;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * ubi_upd_abort - abort volume update.
+ *
+ * @vol: volume description object
+ */
+void ubi_upd_abort(struct ubi_uif_volume *vol)
+{
+	ubi_warn("update of volume %d was not finished, volume is damaged",
+		 vol->vol_id);
+	vol->updating = 0;
+	kfree(vol->upd_buf);
+}
