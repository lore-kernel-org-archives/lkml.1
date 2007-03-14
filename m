Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbXCNP00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbXCNP00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbXCNPVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:21 -0400
Received: from smtp.nokia.com ([131.228.20.173]:63835 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbXCNPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:13 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:00 +0200
Message-Id: <20070314152100.1112.37277.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/22 take 3] UBI: gluebi functionality
X-OriginalArrivalTime: 14 Mar 2007 15:20:59.0993 (UTC) FILETIME=[5EF3C490:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/gluebi.c tmp-to/drivers/mtd/ubi/gluebi.c
--- tmp-from/drivers/mtd/ubi/gluebi.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/gluebi.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,361 @@
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
+ * Author: Artem B. Bityutskiy, Joern Engel
+ */
+
+/*
+ * This is a part of the user interfaces unit. Here we implement fake MTD
+ * devices for each UBI volume. This sounds strange, but it is in fact quite
+ * useful to make MTD-oriented software (including all the legacy software) to
+ * work on top of UBI.
+ *
+ * Gluebi emulates MTD devices of "MTD_UBIVOLUME" type. Their minimal I/O unit
+ * size (mtd->writesize) is equivalent to the minimal I/O unit of the
+ * underlying (real) MTD device. The eraseblock size is equivalent to the
+ * logical eraseblock size of the volume.
+ */
+
+#include <asm/div64.h>
+#include "ubi.h"
+
+/**
+ * mtd2vol - find the user interface volume description object by an MTD
+ * object.
+ *
+ * @mtd: the MTD object
+ *
+ * This function returns the user interface volume description object
+ * corresponding to the @mtd object.
+ */
+static inline struct ubi_uif_volume *mtd2vol(struct mtd_info *mtd)
+{
+	return container_of(mtd, struct ubi_uif_volume, gluebi_mtd);
+}
+
+/**
+ * gluebi_get_device - get MTD device reference.
+ *
+ * @mtd: the MTD device description object
+ *
+ * This function is called every time the MTD device is being opened and
+ * implements the MTD get_device() operation. Returns zero in case of success
+ * and a negative error code in case of failure.
+ */
+static int gluebi_get_device(struct mtd_info *mtd)
+{
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+
+	/*
+	 * We do not introduce locks for gluebi reference count because the
+	 * get_device()/put_device() calls are already serialized at MTD.
+	 */
+	if (vol->gluebi_refcount > 0) {
+		/*
+		 * The MTD device is already referenced and this is just one
+		 * more reference. MTD allows many users to open the same
+		 * volume simultaneously and do not distinguish between
+		 * readers/writers/exclusive openers as UBI does. So we do not
+		 * open the UBI volume again - just increase the reference
+		 * counter and return.
+		 */
+		vol->gluebi_refcount += 1;
+		return 0;
+	}
+
+	/*
+	 * This is the first reference to this UBI volume via the MTD device
+	 * interface. Open the corresponding volume in read-write mode.
+	 */
+	vol->gluebi_desc = ubi_open_volume(vol->ubi->ubi_num, vol->vol_id,
+					   UBI_READWRITE);
+	if (IS_ERR(vol->gluebi_desc))
+		return PTR_ERR(vol->gluebi_desc);
+	vol->gluebi_refcount += 1;
+	return 0;
+}
+
+/**
+ * gluebi_put_device - put MTD device reference.
+ *
+ * @mtd: the MTD device description object
+ *
+ * This function is called every time the MTD device is being put. Returns
+ * zero in case of success and a negative error code in case of failure.
+ */
+static void gluebi_put_device(struct mtd_info *mtd)
+{
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+
+	vol->gluebi_refcount -= 1;
+	ubi_assert(vol->gluebi_refcount >= 0);
+	if (vol->gluebi_refcount == 0)
+		ubi_close_volume(vol->gluebi_desc);
+}
+
+/**
+ * gluebi_read - read operation of emulated MTD devices.
+ *
+ * @mtd: the MTD device description object
+ * @from: absolute offset from where to read
+ * @len: how many bytes to read
+ * @retlen: count of read bytes is returned here
+ * @buf: the buffer to store the data to
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int gluebi_read(struct mtd_info *mtd, loff_t from, size_t len,
+		       size_t *retlen, unsigned char *buf)
+{
+	int err = 0, lnum, offs, total_read;
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+	struct ubi_info *ubi = vol->ubi;
+
+	dbg_uif("read %zd bytes from offset %lld", len, from);
+
+	if (unlikely(len < 0 || from < 0 || from + len > mtd->size))
+		return -EINVAL;
+
+	offs = do_div(from, mtd->erasesize);
+	lnum = from;
+
+	total_read = len;
+	while (total_read) {
+		size_t to_read = mtd->erasesize - offs;
+
+		if (to_read > total_read)
+			to_read = total_read;
+
+		dbg_uif("read %zd bytes from LEB %d:%d, offset %d",
+			to_read, vol->vol_id, lnum, offs);
+
+		err = ubi_eba_read_leb(ubi, vol->vol_id, lnum, buf, offs,
+				       to_read, 0);
+		if (unlikely(err))
+			break;
+
+		lnum += 1;
+		offs = 0;
+		total_read -= to_read;
+		buf += to_read;
+	}
+
+	*retlen = len - total_read;
+	return err;
+}
+
+/**
+ * gluebi_write - write operation of emulated MTD devices.
+ *
+ * @mtd: the MTD device description object
+ * @to: absolute offset where to write
+ * @len: how many bytes to write
+ * @retlen: count of written bytes is returned here
+ * @buf: the buffer with data to write
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int gluebi_write(struct mtd_info *mtd, loff_t to, size_t len,
+		       size_t *retlen, const u_char *buf)
+{
+	int err = 0, lnum, offs, total_written;
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+	struct ubi_info *ubi = vol->ubi;
+
+	dbg_uif("write %zd bytes to offset %lld", len, to);
+
+	if (unlikely(len < 0 || to < 0 || len + to > mtd->size))
+		return -EINVAL;
+
+	if (unlikely(ubi->io.ro_mode))
+		return -EROFS;
+
+	offs = do_div(to, mtd->erasesize);
+	lnum = to;
+
+	if (unlikely(len % mtd->writesize || offs % mtd->writesize))
+		return -EINVAL;
+
+	total_written = len;
+	while (total_written) {
+		size_t to_write = mtd->erasesize - offs;
+
+		if (to_write > total_written)
+			to_write = total_written;
+
+		dbg_uif("write %zd bytes to LEB %d:%d, offset %d",
+			to_write, vol->vol_id, lnum, offs);
+
+		err = ubi_eba_write_leb(ubi, vol->vol_id, lnum, buf, offs,
+					to_write, UBI_DATA_UNKNOWN);
+		if (unlikely(err))
+			break;
+
+		lnum += 1;
+		offs = 0;
+		total_written -= to_write;
+		buf += to_write;
+	}
+
+	*retlen = len - total_written;
+	return err;
+}
+
+/**
+ * gluebi_erase - erase operation of emulated MTD devices.
+ *
+ * @mtd: the MTD device description object
+ * @instr: the erase operation description
+ *
+ * This function calls the erase callback when finishes. Returns zero in case
+ * of success and a negative error code in case of failure.
+ */
+static int gluebi_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	int err, i, lnum, count;
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+	struct ubi_info *ubi = vol->ubi;
+
+	dbg_uif("erase %u bytes at offset %u", instr->len, instr->addr);
+
+	if (unlikely(instr->addr < 0 ||
+		     instr->addr > mtd->size - mtd->erasesize))
+		return -EINVAL;
+
+	if (unlikely(instr->len < 0 ||
+		     instr->addr + instr->len > mtd->size))
+		return -EINVAL;
+
+	if (unlikely(instr->addr % mtd->writesize ||
+		     instr->len % mtd->writesize))
+		return -EINVAL;
+
+	lnum = instr->addr / mtd->erasesize;
+	count = instr->len / mtd->erasesize;
+
+	if (unlikely(ubi->io.ro_mode))
+		return -EROFS;
+
+	for (i = 0; i < count; i++) {
+		dbg_uif("erase LEB %d", lnum);
+
+		err = ubi_eba_unmap_leb(ubi, vol->vol_id, lnum + i);
+		if (unlikely(err))
+			goto out_err;
+	}
+
+	/*
+	 * MTD erase operations are synchronous, so we have to make sure the
+	 * physical eraseblock is wiped out.
+	 */
+	err = ubi_wl_flush(ubi);
+	if (unlikely(err))
+		goto out_err;
+
+        instr->state = MTD_ERASE_DONE;
+        mtd_erase_callback(instr);
+
+	return 0;
+
+out_err:
+	instr->state = MTD_ERASE_FAILED;
+	instr->fail_addr = lnum * mtd->erasesize;
+	return err;
+}
+
+/**
+ * ubi_gluebi_vol_init - initialize gluebi for an UBI volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol: user interfaces unit volume description object
+ *
+ * This function is called when an UBI volume is created in order to create
+ * corresponding fake MTD device. Returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_gluebi_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol)
+{
+	int err;
+	struct mtd_info *mtd = &vol->gluebi_mtd;
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol->vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	mtd->name = kmemdup(vtr->name, vtr->name_len + 1, GFP_KERNEL);
+	if (!mtd->name)
+		return -ENOMEM;
+
+	mtd->type = MTD_UBIVOLUME;
+	if (!ubi->io.ro_mode)
+		mtd->flags = MTD_WRITEABLE;
+	mtd->writesize  = ubi->io.min_io_size;
+	mtd->owner      = THIS_MODULE;
+	mtd->size       = vtr->usable_leb_size * vtr->reserved_pebs;
+	mtd->erasesize  = vtr->usable_leb_size;
+	mtd->read       = gluebi_read;
+	mtd->write      = gluebi_write;
+	mtd->erase      = gluebi_erase;
+	mtd->get_device = gluebi_get_device;
+	mtd->put_device = gluebi_put_device;
+
+	if (add_mtd_device(mtd)) {
+		ubi_err("cannot not add MTD device\n");
+
+		/*
+		 * Unfortunately, add_mtd_device() does not return sane error
+		 * code. So, let's name it -ENOMEM;
+		 */
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	dbg_uif("added mtd%d (\"%s\"), size %u, EB size %u",
+		mtd->index, mtd->name, mtd->size, mtd->erasesize);
+
+	return 0;
+
+out_free:
+	kfree(mtd->name);
+	return err;
+}
+
+/**
+ * ubi_gluebi_vol_close - close gluebi for an UBI volume.
+ *
+ * @vol: user interfaces unit volume description object
+ *
+ * This function is called when an UBI volume is removed in order to remove
+ * corresponding fake MTD device. Returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_gluebi_vol_close(struct ubi_uif_volume *vol)
+{
+	int err;
+	struct mtd_info *mtd = &vol->gluebi_mtd;
+
+	dbg_uif("remove mtd%d", mtd->index);
+
+	err = del_mtd_device(mtd);
+	if (err)
+		return err;
+
+	kfree(mtd->name);
+	return 0;
+}
