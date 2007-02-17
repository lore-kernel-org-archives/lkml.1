Return-Path: <linux-kernel-owner+w=401wt.eu-S2992951AbXBQRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992951AbXBQRf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992953AbXBQRf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:35:28 -0500
Received: from smtp.nokia.com ([131.228.20.173]:39839 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992951AbXBQRf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:35:26 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:35 +0200
Message-Id: <20070217165635.5845.78040.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 26/44 take 2] [UBI] EBA unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:02.0847 (UTC) FILETIME=[81CA7AF0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185307-0B11ABB0-6DFC423B/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/eba.c tmp-to/drivers/mtd/ubi/eba.c
--- tmp-from/drivers/mtd/ubi/eba.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/eba.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,1212 @@
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
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/crc32.h>
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "eba.h"
+#include "badeb.h"
+#include "io.h"
+#include "wl.h"
+#include "volmgmt.h"
+#include "vtbl.h"
+#include "account.h"
+#include "background.h"
+#include "scan.h"
+#include "misc.h"
+#include "debug.h"
+
+/*
+ * The highest bit in logical-to-physical eraseblock mappings is used to
+ * indicate that the logical eraseblock is not mapped.
+ */
+#define NOT_MAPPED 0x80000000
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_EBA
+static int paranoid_check_leb(const struct ubi_info *ubi, int pnum, int vol_id,
+			      int lnum, int leb_ver,
+			      const struct ubi_vid_hdr *vid_hdr);
+static int paranoid_check_leb_locked(const struct ubi_info *ubi, int vol_id,
+				     int lnum);
+#else
+#define paranoid_check_leb(ubi, vol_id, pnum, lnum, leb_ver, vid_hdr) 0
+#define paranoid_check_leb_locked(ubi, vol_id, lnum)
+#endif
+
+/**
+ * vol_id2idx - turn a volume ID to the EBA table index.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ */
+static inline int vol_id2idx(const struct ubi_info *ubi, int vol_id)
+{
+	const struct ubi_acc_info *acc = ubi->acc;
+
+	if (vol_id >= UBI_INTERNAL_VOL_START)
+		return vol_id - UBI_INTERNAL_VOL_START + acc->max_volumes;
+	else
+		return vol_id;
+}
+
+/**
+ * idx2vol_id - turn an EBA table index to the volume ID.
+ *
+ * @ubi: the UBI device description object
+ * @idx: the EBA table index
+ */
+static inline int idx2vol_id(const struct ubi_info *ubi, int idx)
+{
+	const struct ubi_acc_info *acc = ubi->acc;
+
+	if (idx >= acc->max_volumes)
+		return idx - acc->max_volumes + UBI_INTERNAL_VOL_START;
+	else
+		return idx;
+}
+
+/**
+ * leb_get_ver - get logical eraseblock version.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number
+ *
+ * The logical eraseblock has to be locked.
+ */
+static inline int leb_get_ver(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx, leb_ver;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba->eba_tbl[idx].recs);
+	leb_ver = eba->eba_tbl[idx].recs[lnum].leb_ver;
+	spin_unlock(&eba->eba_tbl_lock);
+	return leb_ver;
+}
+
+/**
+ * leb_map - map a logical eraseblock to a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number
+ * @pnum: the physical eraseblock
+ *
+ * The logical eraseblock has to be locked.
+ */
+static inline void leb_map(const struct ubi_info *ubi, int vol_id, int lnum,
+			   int pnum)
+{
+	int idx;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba->eba_tbl[idx].recs);
+	ubi_assert(eba->eba_tbl[idx].recs[lnum].pnum < 0);
+	eba->eba_tbl[idx].recs[lnum].pnum = pnum;
+	spin_unlock(&eba->eba_tbl_lock);
+}
+
+/**
+ * leb_unmap - unmap a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to unmap
+ *
+ * This function unmaps a logical eraseblock and increases its version. The
+ * logical eraseblock has to be locked.
+ */
+static inline void leb_unmap(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba->eba_tbl[idx].recs);
+	ubi_assert(eba->eba_tbl[idx].recs[lnum].pnum >= 0);
+
+	eba->eba_tbl[idx].recs[lnum].pnum |= NOT_MAPPED;
+	eba->eba_tbl[idx].recs[lnum].leb_ver += 1;
+	spin_unlock(&eba->eba_tbl_lock);
+}
+
+/**
+ * leb2peb - get physical eraseblock number the logical eraseblock is mapped
+ * to.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number
+ *
+ * If the logical eraseblock is mapped, this function returns a positive
+ * physical eraseblock number. If it is not mapped, this function returns
+ * a negative number.
+ */
+static inline int leb2peb(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx, pnum;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba->eba_tbl[idx].recs);
+	pnum = eba->eba_tbl[idx].recs[lnum].pnum;
+	spin_unlock(&eba->eba_tbl_lock);
+
+	return pnum;
+}
+
+int ubi_eba_mkvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int i, idx, sz;
+	struct ubi_eba_tbl_rec *new_ebs;
+	struct ubi_eba_info *eba = ubi->eba;
+	struct ubi_eba_tbl_volume *eba_tbl = eba->eba_tbl;
+
+	dbg_eba("create volume %d, size %d", vol_id, reserved_pebs);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(reserved_pebs > 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->acc->max_volumes);
+
+	if (ubi->io->ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	sz = reserved_pebs * sizeof(struct ubi_eba_tbl_rec);
+	new_ebs = ubi_kmalloc(sz);
+	if (!new_ebs)
+		return -ENOMEM;
+
+	for (i = 0; i < reserved_pebs; i++) {
+		new_ebs[i].pnum = NOT_MAPPED;
+		new_ebs[i].leb_ver = 0xFFFFFFF0;
+	}
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(!eba_tbl[idx].recs);
+	eba_tbl[idx].recs = new_ebs;
+	eba_tbl[idx].leb_count = reserved_pebs;
+	spin_unlock(&eba->eba_tbl_lock);
+
+	return 0;
+}
+
+int ubi_eba_rmvol(const struct ubi_info *ubi, int vol_id)
+{
+	int err = 0, i, idx, to_put;
+	struct ubi_eba_tbl_rec *rm_ebs;
+	struct ubi_eba_info *eba = ubi->eba;
+	struct ubi_eba_tbl_volume *eba_tbl = eba->eba_tbl;
+
+	dbg_eba("remove volume %d", vol_id);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->acc->max_volumes);
+
+	if (ubi->io->ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba_tbl[idx].recs);
+	rm_ebs = eba_tbl[idx].recs;
+	to_put = eba_tbl[idx].leb_count;
+	eba_tbl[idx].recs = NULL;
+	eba_tbl[idx].leb_count = 0;
+	spin_unlock(&eba->eba_tbl_lock);
+
+	for (i = 0; i < to_put; i++)
+		if (rm_ebs[i].pnum >= 0) {
+			err = ubi_wl_put_peb(ubi, rm_ebs[i].pnum, 0);
+			if (err)
+				break;
+		}
+
+	ubi_kfree(rm_ebs);
+	return err;
+}
+
+int ubi_eba_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int err = 0, i, idx, min, to_put, sz;
+	struct ubi_eba_tbl_rec *new_ebs, *old_ebs;
+	struct ubi_eba_info *eba = ubi->eba;
+	struct ubi_eba_tbl_volume *eba_tbl = eba->eba_tbl;
+
+	dbg_eba("re-size volume %d to %d PEBs", vol_id, reserved_pebs);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->acc->max_volumes);
+	ubi_assert(reserved_pebs > 0);
+
+	if (ubi->io->ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	sz = reserved_pebs * sizeof(struct ubi_eba_tbl_rec);
+	new_ebs = ubi_kmalloc(sz);
+	if (!new_ebs)
+		return -ENOMEM;
+
+	for (i = 0; i < reserved_pebs; i++) {
+		new_ebs[i].pnum = NOT_MAPPED;
+		new_ebs[i].leb_ver = 0;
+	}
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&eba->eba_tbl_lock);
+	ubi_assert(eba_tbl[idx].recs);
+
+	if (reserved_pebs < eba_tbl[idx].leb_count) {
+		min = reserved_pebs;
+		to_put = eba_tbl[idx].leb_count - reserved_pebs;
+	} else {
+		min = eba_tbl[idx].leb_count;
+		to_put = 0;
+	}
+
+	for (i = 0; i < min; i++) {
+		new_ebs[i].pnum = eba_tbl[idx].recs[i].pnum;
+		new_ebs[i].leb_ver = eba_tbl[idx].recs[i].leb_ver;
+	}
+	old_ebs = eba_tbl[idx].recs;
+	eba_tbl[idx].recs = new_ebs;
+	eba_tbl[idx].leb_count = reserved_pebs;
+	spin_unlock(&eba->eba_tbl_lock);
+
+	for (i = 0; i < to_put; i++)
+		if (old_ebs[i].pnum >= 0) {
+			err = ubi_wl_put_peb(ubi, old_ebs[i].pnum, 0);
+			if (err)
+				break;
+		}
+
+	ubi_kfree(old_ebs);
+	return err;
+}
+
+int ubi_eba_erase_leb(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int err, pnum;
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->acc->max_volumes || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].recs);
+	ubi_assert(lnum < ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	cond_resched();
+
+	if (unlikely(ubi->io->ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = ubi_eba_leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	pnum = leb2peb(ubi, vol_id, lnum);
+	if (pnum < 0) {
+		/* This logical eraseblock is already unmapped */
+		dbg_eba("erase LEB %d:%d (unmapped)", vol_id, lnum);
+		goto out_unlock;
+	}
+	dbg_eba("erase LEB %d:%d, PEB %d", vol_id, lnum, pnum);
+
+	leb_unmap(ubi, vol_id, lnum);
+
+	err = ubi_wl_put_peb(ubi, pnum, 0);
+
+out_unlock:
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+int ubi_eba_read_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		     void *buf, int offset, int len, int check)
+{
+	int err, pnum, scrub = 0;
+	const struct ubi_vtbl_vtr *vtr;
+	uint32_t data_crc;
+	struct ubi_vid_hdr *vid_hdr;
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->acc->max_volumes || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(offset >= 0);
+	ubi_assert(len > 0);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(offset + len <= ubi->io->leb_size - vtr->data_pad);
+	ubi_assert(lnum < ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	cond_resched();
+
+	err = ubi_eba_leb_read_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	pnum = leb2peb(ubi, vol_id, lnum);
+
+	if (pnum < 0) {
+		/*
+		 * The logical eraseblock is not mapped, fill the whole buffer
+		 * by 0xFF bytes. The exception is static volumes for which it
+		 * is an error to read unmapped logical eraseblocks.
+		 */
+		dbg_eba("read %d bytes from offset %d of LEB %d:%d (unmapped)",
+			len, offset, vol_id, lnum);
+		ubi_eba_leb_read_unlock(ubi, vol_id, lnum);
+		ubi_assert(vtr->vol_type != UBI_STATIC_VOLUME);
+		memset(buf, 0xFF, len);
+		return 0;
+	}
+	dbg_eba("read %d bytes from offset %d of LEB %d:%d, PEB %d",
+		len, offset, vol_id, lnum, pnum);
+
+	if (vtr->vol_type == UBI_DYNAMIC_VOLUME)
+		/* In case of dynamic volumes no checking is needed */
+		check = 0;
+
+	if (check) {
+		vid_hdr = ubi_zalloc_vid_hdr(ubi);
+		if (unlikely(!vid_hdr)) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+
+		err = ubi_io_read_vid_hdr(ubi, pnum, vid_hdr, 1);
+		if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+			if (err > 0) {
+				/*
+				 * The header is either absent or corrupted.
+				 * The former case means there is a bug -
+				 * switch to read-only mode just in case.
+				 * The latter case means a real corruption - we
+				 * may try to recover data. FIXME: but this is
+				 * not implemented.
+				 */
+				if (err == UBI_IO_BAD_VID_HDR) {
+					ubi_warn("bad VID header at PEB %d, LEB"
+						 "%d:%d", pnum, vol_id, lnum);
+					err = -EBADMSG;
+				} else
+					ubi_eba_ro_mode(ubi);
+			}
+			goto out_free;
+		} else if (unlikely(err == UBI_IO_BITFLIPS))
+			scrub = 1;
+
+		err = paranoid_check_leb(ubi, pnum, vol_id, lnum,
+					 leb_get_ver(ubi, vol_id, lnum),
+					 vid_hdr);
+		if (unlikely(err)) {
+			if (err > 0)
+				err = -EINVAL;
+			goto out_free;
+		}
+
+		ubi_assert(lnum < ubi32_to_cpu(vid_hdr->used_ebs));
+		ubi_assert(len == ubi32_to_cpu(vid_hdr->data_size));
+
+		data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+		ubi_free_vid_hdr(ubi, vid_hdr);
+	}
+
+	err = ubi_io_read_data(ubi, buf, pnum, offset, len);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS)
+		goto out_unlock;
+	else if (unlikely(err == UBI_IO_BITFLIPS)) {
+		scrub = 1;
+		err = 0;
+	}
+
+	if (check) {
+		uint32_t crc;
+
+		crc = crc32(UBI_CRC32_INIT, buf, len);
+		if (unlikely(crc != data_crc)) {
+			ubi_warn("CRC error: calculated %#08x, must be %#08x",
+				 crc, data_crc);
+			err = -EBADMSG;
+			goto out_unlock;
+		}
+
+		if (err)
+			dbg_eba("error %d while reading, but data CRC is OK, "
+				"ignore the error", err);
+		err = 0;
+		dbg_eba("data is OK, CRC matches");
+	}
+
+	if (unlikely(err))
+		goto out_unlock;
+
+	if (unlikely(scrub))
+		err = ubi_wl_scrub_peb(ubi, pnum);
+
+	ubi_eba_leb_read_unlock(ubi, vol_id, lnum);
+	return err;
+
+out_free:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_unlock:
+	ubi_eba_leb_read_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+int ubi_eba_write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		      const void *buf, int offset, int len,
+		      enum ubi_data_type dtype)
+{
+	int err, pnum, tries = 0;
+	uint32_t leb_ver;
+	struct ubi_vid_hdr *vid_hdr;
+	const struct ubi_vtbl_vtr *vtr;
+	const struct ubi_io_info *io = ubi->io;
+
+retry:
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->acc->max_volumes || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(offset >= 0);
+	ubi_assert(len >= 0);
+	ubi_assert(dtype == UBI_DATA_LONGTERM || dtype == UBI_DATA_SHORTTERM ||
+		   dtype == UBI_DATA_UNKNOWN);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(offset + len <= io->leb_size - vtr->data_pad);
+	ubi_assert(lnum < ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+	ubi_assert(len % io->min_io_size == 0);
+	ubi_assert(offset % io->min_io_size == 0);
+	ubi_assert(vtr->vol_type == UBI_DYNAMIC_VOLUME);
+
+	cond_resched();
+
+	if (unlikely(ubi->io->ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = ubi_eba_leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	pnum = leb2peb(ubi, vol_id, lnum);
+	leb_ver = leb_get_ver(ubi, vol_id, lnum);
+	if (pnum >= 0) {
+		dbg_eba("write %d bytes at offset %d of LEB %d:%d, PEB %d",
+			len, offset, vol_id, lnum, pnum);
+
+		if (len != 0) {
+			err = ubi_io_write_data(ubi, buf, pnum, offset, len);
+			if (unlikely(err))
+				goto data_write_error;
+		}
+		ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+		return err;
+	}
+
+	/*
+	 * The logical eraseblock is not mapped. We have to get a free physical
+	 * eraseblock and write the volume identifier header there first.
+	 */
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (unlikely(!vid_hdr)) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	vid_hdr->vol_type = UBI_VID_DYNAMIC;
+	vid_hdr->leb_ver = cpu_to_ubi32(leb_ver);
+	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
+	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->compat = ubi_vtbl_get_compat(ubi, vol_id);
+	vid_hdr->data_pad = cpu_to_ubi32(vtr->data_pad);
+
+	pnum = ubi_wl_get_peb(ubi, dtype);
+	if (unlikely(pnum < 0)) {
+		err = pnum;
+		goto out_vid_hdr;
+	}
+	dbg_eba("write VID hdr and %d bytes at offset %d of LEB %d:%d, PEB %d",
+		len, offset, vol_id, lnum, pnum);
+
+	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
+	if (unlikely(err))
+		goto hdr_write_error;
+
+	leb_map(ubi, vol_id, lnum, pnum);
+
+	if (len != 0) {
+		err = ubi_io_write_data(ubi, buf, pnum, offset, len);
+		if (unlikely(err))
+			goto data_write_error_free;
+	}
+
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return 0;
+
+out_vid_hdr:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_unlock:
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/* Failed to write the volume identifier header */
+hdr_write_error:
+	ubi_warn("failed to write VID header to PEB %d", pnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	if (err != -EIO || !io->bad_allowed)
+		goto no_bad_eraseblocks;
+
+	/*
+	 * Fortunately, we did not write any data there yet, so just put this
+	 * physical eraseblock and request a new one. We assume that if this
+	 * physical eraseblock went bad, the erase code will handle that.
+	 */
+	ubi_msg("try to recover form the error");
+	err = ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	if (err || ++tries > 5)
+		return err;
+	goto retry;
+
+	/* Failed to write data */
+data_write_error_free:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+data_write_error:
+	ubi_warn("failed to write data to PEB %d", pnum);
+	if (err != -EIO || !io->bad_allowed)
+		goto no_bad_eraseblocks;
+
+	err = ubi_beb_recover_peb(ubi, pnum, vol_id, lnum, buf, offset, len);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/*
+	 * This flash device does not admit of bad eraseblocks or something
+	 * nasty and unexpected happened. Switch to read-only mode just in
+	 * case.
+	 */
+no_bad_eraseblocks:
+	ubi_eba_ro_mode(ubi);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+int ubi_eba_write_leb_st(const struct ubi_info *ubi, int vol_id, int lnum,
+			 const void *buf, int len, enum ubi_data_type dtype,
+			 int used_ebs)
+{
+	int err, pnum, tries = 0, data_size = len;
+	uint32_t leb_ver, crc;
+	struct ubi_vid_hdr *vid_hdr;
+	const struct ubi_vtbl_vtr *vtr;
+	const struct ubi_io_info *io = ubi->io;
+
+retry:
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->acc->max_volumes || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(len > 0);
+	ubi_assert(dtype == UBI_DATA_LONGTERM || dtype == UBI_DATA_SHORTTERM ||
+		   dtype == UBI_DATA_UNKNOWN);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(lnum < ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+	ubi_assert(lnum < used_ebs);
+	ubi_assert(used_ebs >= 0);
+	ubi_assert(vtr->vol_type == UBI_STATIC_VOLUME);
+
+	cond_resched();
+
+	if (lnum == used_ebs - 1) {
+		/*
+		 * If this is the last logical eraseblock of a static
+		 * volume, @len may be unaligned.
+		 */
+		ubi_assert(len <= io->leb_size - vtr->data_pad);
+		len = align_up(data_size, io->min_io_size);
+	} else {
+		ubi_assert(len == io->leb_size - vtr->data_pad);
+		ubi_assert(len % io->min_io_size == 0);
+	}
+
+	if (unlikely(ubi->io->ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = ubi_eba_leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	ubi_assert(leb2peb(ubi, vol_id, lnum) < 0);
+
+	/*
+	 * Get a free physical eraseblock and write the volume identifier
+	 * header.
+	 */
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (unlikely(!vid_hdr)) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	leb_ver = leb_get_ver(ubi, vol_id, lnum);
+	vid_hdr->leb_ver = cpu_to_ubi32(leb_ver);
+	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
+	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->compat = ubi_vtbl_get_compat(ubi, vol_id);
+	vid_hdr->data_pad = cpu_to_ubi32(vtr->data_pad);
+
+	crc = crc32(UBI_CRC32_INIT, buf, data_size);
+	vid_hdr->vol_type = UBI_VID_STATIC;
+	vid_hdr->data_size = cpu_to_ubi32(data_size);
+	vid_hdr->used_ebs = cpu_to_ubi32(used_ebs);
+	vid_hdr->data_crc = cpu_to_ubi32(crc);
+
+	pnum = ubi_wl_get_peb(ubi, dtype);
+	if (unlikely(pnum < 0)) {
+		err = pnum;
+		goto out_vid_hdr;
+	}
+	dbg_eba("write VID hdr and %d bytes at of LEB %d:%d, PEB %d",
+		len, vol_id, lnum, pnum);
+
+	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
+	if (unlikely(err)) {
+		ubi_warn("failed to write VID header to PEB %d", pnum);
+		goto write_error;
+	}
+
+	leb_map(ubi, vol_id, lnum, pnum);
+
+	err = ubi_io_write_data(ubi, buf, pnum, 0, len);
+	if (unlikely(err)) {
+		ubi_warn("failed to write data to PEB %d", pnum);
+		goto write_error;
+	}
+
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return 0;
+
+out_vid_hdr:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_unlock:
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/* Write failure */
+write_error:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	if (err != -EIO || !io->bad_allowed)
+		goto no_bad_eraseblocks;
+
+	/*
+	 * We assume that if this physical eraseblock went bad - the erase code
+	 * will handle that.
+	 */
+	ubi_msg("try to recover form the error");
+	err = ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	if (err || ++tries > 5)
+		return err;
+	goto retry;
+
+	/*
+	 * This flash device does not admit of bad eraseblocks or something
+	 * nasty and unexpected happened. Switch to read-only mode just in
+	 * case.
+	 */
+no_bad_eraseblocks:
+	ubi_eba_ro_mode(ubi);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+int ubi_eba_leb_is_mapped(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	dbg_eba("check LEB %d:%d PEBs", vol_id, lnum);
+
+	/* Input arguments sanity check */
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->acc->max_volumes);
+	ubi_assert(lnum >= 0);
+	ubi_assert(lnum < ubi->eba->eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	return leb2peb(ubi, vol_id, lnum) >= 0;
+}
+
+void ubi_eba_ro_mode(const struct ubi_info *ubi)
+{
+	ubi_bgt_disable(ubi);
+	ubi->io->ro_mode = 1;
+	ubi_warn("switched to read-only mode");
+}
+
+/**
+ * ltree_lookup - look up the lock tree.
+ *
+ * @eba: the EBA unit description data structure
+ * @vol_id: volume ID of the logical eraseblock to look up
+ * @lnum: the logical eraseblock number to look up
+ *
+ * This function returns a pointer to the corresponding &struct ubi_eba_info
+ * object if the logical eraseblock is locked and %NULL if it is not locked.
+ *
+ * The @eba->ltree_lock has to be locked.
+ *
+ * This is a helper function for the logical eraseblock locking/unlocking
+ * functions.
+ */
+static inline struct ubi_eba_ltree_entry *
+ltree_lookup(struct ubi_eba_info *eba, int vol_id, int lnum)
+{
+	struct rb_node *p;
+
+	p = eba->ltree.rb_node;
+	while (p) {
+		struct ubi_eba_ltree_entry *le;
+
+		le = rb_entry(p, struct ubi_eba_ltree_entry, rb);
+
+		if (vol_id < le->vol_id)
+			p = p->rb_left;
+		else if (vol_id > le->vol_id)
+			p = p->rb_right;
+		else {
+			if (lnum < le->lnum)
+				p = p->rb_left;
+			else if (lnum > le->lnum)
+				p = p->rb_right;
+			else
+				return le;
+		}
+	}
+
+	return NULL;
+}
+
+static struct ubi_eba_ltree_entry *ltree_add_entry(const struct ubi_info *ubi,
+						   int vol_id, int lnum);
+
+int ubi_eba_leb_read_lock(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	struct ubi_eba_ltree_entry *le;
+
+	le = ltree_add_entry(ubi, vol_id, lnum);
+	if (unlikely(IS_ERR(le)))
+		return PTR_ERR(le);
+	down_read(&le->mutex);
+	return 0;
+}
+
+int ubi_eba_leb_write_lock(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	struct ubi_eba_ltree_entry *le;
+
+	le = ltree_add_entry(ubi, vol_id, lnum);
+	if (unlikely(IS_ERR(le)))
+		return PTR_ERR(le);
+	down_write(&le->mutex);
+	return 0;
+}
+
+void ubi_eba_leb_read_unlock(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int free = 0;
+	struct ubi_eba_ltree_entry *le;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	spin_lock(&eba->ltree_lock);
+	le = ltree_lookup(ubi->eba, vol_id, lnum);
+	le->users -= 1;
+	ubi_assert(le->users >= 0);
+	if (le->users == 0) {
+		rb_erase(&le->rb, &eba->ltree);
+		free = 1;
+	}
+	spin_unlock(&eba->ltree_lock);
+
+	up_read(&le->mutex);
+	if (free)
+		ubi_free_eba_ltree_entry(le);
+}
+
+void ubi_eba_leb_write_unlock(const struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int free;
+	struct ubi_eba_ltree_entry *le;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	spin_lock(&eba->ltree_lock);
+	le = ltree_lookup(ubi->eba, vol_id, lnum);
+	le->users -= 1;
+	ubi_assert(le->users >= 0);
+	if (le->users == 0) {
+		rb_erase(&le->rb, &eba->ltree);
+		free = 1;
+	} else
+		free = 0;
+	spin_unlock(&eba->ltree_lock);
+
+	up_write(&le->mutex);
+	if (free)
+		ubi_free_eba_ltree_entry(le);
+}
+
+void ubi_eba_leb_remap(const struct ubi_info *ubi, int vol_id, int lnum,
+		       int pnum)
+{
+	/* The logical eraseblock is supposed to be locked */
+	paranoid_check_leb_locked(ubi, vol_id, lnum);
+	leb_unmap(ubi, vol_id, lnum);
+	leb_map(ubi, vol_id, lnum, pnum);
+}
+
+static int build_eba_tbl(const struct ubi_info *ubi,
+			 const struct ubi_scan_info *si);
+
+int ubi_eba_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err, sz;
+	struct ubi_eba_info *eba;
+	struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_eba("initialize the EBA unit");
+
+	eba = ubi_kzalloc(sizeof(struct ubi_eba_info));
+	if (!eba)
+		return -ENOMEM;
+	ubi->eba = eba;
+
+	spin_lock_init(&eba->eba_tbl_lock);
+	spin_lock_init(&eba->ltree_lock);
+	eba->ltree = RB_ROOT;
+
+	eba->num_volumes = acc->max_volumes + acc->ivol_count;
+	sz = eba->num_volumes * sizeof(struct ubi_eba_tbl_volume);
+	eba->eba_tbl = ubi_kzalloc(sz);
+	if (!eba->eba_tbl) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = build_eba_tbl(ubi, si);
+	if (err)
+		goto out;
+
+	dbg_eba("the EBA unit is initialized");
+	return 0;
+
+out:
+	ubi_kfree(eba->eba_tbl);
+	ubi_kfree(eba);
+	return err;
+}
+
+void ubi_eba_close(const struct ubi_info *ubi)
+{
+	unsigned int i;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	dbg_eba("close EBA management unit");
+
+
+	for (i = 0; i < eba->num_volumes; i++)
+		ubi_kfree(eba->eba_tbl[i].recs);
+	ubi_kfree(eba->eba_tbl);
+	ubi_kfree(eba);
+}
+
+/**
+ * build_eba_tbl - build the eraseblock association table.
+ *
+ * @ubi: the UBI device description object
+ * @si: scanning info
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int build_eba_tbl(const struct ubi_info *ubi,
+			 const struct ubi_scan_info *si)
+{
+	int i, err, idx;
+	struct ubi_eba_info *eba = ubi->eba;
+	struct ubi_eba_tbl_volume *eba_tbl = eba->eba_tbl;
+
+	for (idx = 0; idx < eba->num_volumes; idx++) {
+		struct rb_node *rb;
+		struct ubi_scan_leb *seb;
+		struct ubi_scan_volume *sv;
+		const struct ubi_vtbl_vtr *vtr;
+		int sz;
+
+		cond_resched();
+
+		vtr = ubi_vtbl_get_vtr(ubi, idx2vol_id(ubi, idx));
+		if (IS_ERR(vtr))
+			continue;
+
+		dbg_eba("found volume %d (idx %d)", idx2vol_id(ubi, idx), idx);
+
+		eba_tbl[idx].leb_count = vtr->reserved_pebs;
+
+		sz = vtr->reserved_pebs * sizeof(struct ubi_eba_tbl_rec);
+		eba_tbl[idx].recs = ubi_kmalloc(sz);
+		if (unlikely(!eba_tbl[idx].recs)) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < vtr->reserved_pebs; i++) {
+			eba->eba_tbl[idx].recs[i].pnum = NOT_MAPPED;
+			eba->eba_tbl[idx].recs[i].leb_ver = 0;
+		}
+
+		sv = ubi_scan_find_sv(si, idx2vol_id(ubi, idx));
+		if (!sv)
+			continue;
+
+		rb_for_each_entry(rb, seb, &sv->root, u.rb) {
+			eba->eba_tbl[idx].recs[seb->lnum].pnum = seb->pnum;
+			eba->eba_tbl[idx].recs[seb->lnum].leb_ver = seb->leb_ver;
+		}
+	}
+
+	return 0;
+
+out:
+	for (i = 0; i < eba->num_volumes; i++)
+		ubi_kfree(eba->eba_tbl[i].recs);
+
+	return err;
+}
+
+/**
+ * ltree_add_entry - add new entry to the lock tree.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID of the logical eraseblock
+ * @lnum: the logical eraseblock number
+ *
+ * This function add new lock tree entry for logical eraseblock
+ * (@vol_id,@lnum). If the corresponding entry is already there, its usage
+ * counter is increased. This function returns a pointer to the lock tree
+ * entry.
+ */
+static struct ubi_eba_ltree_entry *ltree_add_entry(const struct ubi_info *ubi,
+						   int vol_id, int lnum)
+{
+	struct ubi_eba_info *eba = ubi->eba;
+	struct ubi_eba_ltree_entry *le, *le1, *le_free;
+
+	le = ubi_alloc_eba_ltree_entry();
+	if (unlikely(!le))
+		return ERR_PTR(-ENOMEM);
+
+	le->vol_id = vol_id;
+	le->lnum = lnum;
+
+	spin_lock(&eba->ltree_lock);
+	le1 = ltree_lookup(eba, vol_id, lnum);
+
+	if (le1) {
+		/*
+		 * This logical eraseblock is already locked. The newly
+		 * allocated lock entry is not needed.
+		 */
+		le_free = le;
+		le = le1;
+	} else {
+		struct rb_node **p, *parent = NULL;
+
+		/*
+		 * No lock entry, add the newly allocated one to the
+		 * @eba->ltree RB-tree.
+		 */
+		le_free = NULL;
+
+		p = &eba->ltree.rb_node;
+		while (*p) {
+			parent = *p;
+			le1 = rb_entry(parent, struct ubi_eba_ltree_entry, rb);
+
+			if (vol_id < le1->vol_id)
+				p = &(*p)->rb_left;
+			else if (vol_id > le1->vol_id)
+				p = &(*p)->rb_right;
+			else {
+				ubi_assert(lnum != le1->lnum);
+				if (lnum < le1->lnum)
+					p = &(*p)->rb_left;
+				else
+					p = &(*p)->rb_right;
+			}
+		}
+
+		rb_link_node(&le->rb, parent, p);
+		rb_insert_color(&le->rb, &eba->ltree);
+	}
+	le->users += 1;
+	spin_unlock(&eba->ltree_lock);
+
+	if (le_free)
+		ubi_free_eba_ltree_entry(le_free);
+
+	return le;
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_EBA
+
+/**
+ * paranoid_check_leb - check that a logical eraseblock has correct erase
+ * counter and volume identifier headers.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number
+ * @vol_id: the volume ID to check
+ * @lnum: the logical eraseblock number to check
+ * @leb_ver: the logical eraseblock version to check
+ * @vid_hdr: volume identifier header to check
+ *
+ * This function returns zero if the headers are all right, %1 if not, and a
+ * negative error code in case of error.
+ */
+static int paranoid_check_leb(const struct ubi_info *ubi, int pnum, int vol_id,
+			      int lnum, int leb_ver,
+			      const struct ubi_vid_hdr *vid_hdr)
+{
+	int err, hdr_vol_id, hdr_lnum, hdr_leb_ver;
+	struct ubi_ec_hdr *ec_hdr;
+
+	/* Check the EC header */
+	ec_hdr = ubi_zalloc_ec_hdr(ubi);
+	if (unlikely(!ec_hdr))
+		return -ENOMEM;
+
+	err = ubi_io_read_ec_hdr(ubi, pnum, ec_hdr, 1);
+	ubi_free_ec_hdr(ubi, ec_hdr);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		if (err < 0)
+			return err;
+		goto fail;
+	}
+
+	hdr_vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	hdr_lnum = ubi32_to_cpu(vid_hdr->lnum);
+	hdr_leb_ver = ubi32_to_cpu(vid_hdr->leb_ver);
+
+	if (unlikely(vol_id != hdr_vol_id)) {
+		ubi_err("bad vol_id %d, should be %d", hdr_vol_id, vol_id);
+		goto fail;
+	}
+
+	if (unlikely(lnum != hdr_lnum)) {
+		ubi_err("bad lnum %d, should be %d", hdr_lnum, lnum);
+		goto fail;
+	}
+
+	if (unlikely(leb_ver != hdr_leb_ver)) {
+		ubi_err("bad leb_ver %d, should be %d", hdr_leb_ver, leb_ver);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	ubi_err("paranoid check failed");
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+/**
+ * paranoid_check_leb_locked - ensure that a logical eraseblock is locked.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID to check
+ * @lnum: the logical eraseblock number to check
+ *
+ * This function returns zero if the logical eraseblock is locked and %1 if
+ * not.
+ */
+static int paranoid_check_leb_locked(const struct ubi_info *ubi, int vol_id,
+				     int lnum)
+{
+	struct ubi_eba_ltree_entry *le;
+	struct ubi_eba_info *eba = ubi->eba;
+
+	spin_lock(&eba->ltree_lock);
+	le = ltree_lookup(ubi->eba, vol_id, lnum);
+	spin_unlock(&eba->ltree_lock);
+	if (likely(le))
+		return 0;
+
+	ubi_err("paranoid check failed");
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_EBA */
