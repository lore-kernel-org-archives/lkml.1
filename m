Return-Path: <linux-kernel-owner+w=401wt.eu-S2992470AbXBQQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992470AbXBQQ7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXBQQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:59:08 -0500
Received: from smtp.nokia.com ([131.228.20.171]:55383 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXBQQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:57 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:56 +0200
Message-Id: <20070217165756.5845.18011.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 42/44 take 2] [UBI] gluebi unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:57:23.0422 (UTC) FILETIME=[B1D13FE0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185547-3C659BB0-3C4257A5/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/gluebi.c tmp-to/drivers/mtd/ubi/gluebi.c
--- tmp-from/drivers/mtd/ubi/gluebi.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/gluebi.c	2007-02-17 18:07:28.000000000 +0200
@@ -0,0 +1,363 @@
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
+ * Author: Artem B. Bityutskiy (based on code written by Joern Engel)
+ */
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/ubi.h>
+#include <asm/div64.h>
+#include "ubi.h"
+#include "uif.h"
+#include "gluebi.h"
+#include "vtbl.h"
+#include "misc.h"
+#include "debug.h"
+#include "alloc.h"
+#include "io.h"
+#include "eba.h"
+#include "wl.h"
+
+static int gluebi_get_device(struct mtd_info *mtd);
+static void gluebi_put_device(struct mtd_info *mtd);
+static int gluebi_read(struct mtd_info *mtd, loff_t from, size_t len,
+		       size_t *retlen, unsigned char *buf);
+static int gluebi_write(struct mtd_info *mtd, loff_t to, size_t len,
+		       size_t *retlen, const u_char *buf);
+static int gluebi_erase(struct mtd_info *mtd, struct erase_info *instr);
+
+/**
+ * mtd2vol - take the user interface volume description object by an MTD object.
+ *
+ * @mtd: the MTD object
+ *
+ * This function returns the user interface volume description object
+ * corresponding to the @mtd object.
+ */
+static inline struct ubi_uif_volume *mtd2vol(struct mtd_info *mtd)
+{
+	struct ubi_gluebi_volume *gluebi_vol;
+	struct ubi_uif_volume *vol;
+
+	gluebi_vol = container_of(mtd, struct ubi_gluebi_volume, mtd);
+	vol = container_of(gluebi_vol, struct ubi_uif_volume, gluebi_vol);
+	return vol;
+}
+
+int ubi_gluebi_vol_init(const struct ubi_info *ubi, struct ubi_uif_volume *vol)
+{
+	int err;
+	struct mtd_info *mtd = &vol->gluebi_vol.mtd;
+	const struct ubi_vtbl_vtr *vtr;
+	const struct ubi_io_info *io = ubi->io;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol->vol_id);
+	ubi_assert(!IS_ERR(vtr));
+
+	mtd->name = strdup_len(vtr->name, vtr->name_len);
+	if (!mtd->name)
+		return -ENOMEM;
+
+	mtd->type = MTD_UBIVOLUME;
+	if (!io->ro_mode)
+		mtd->flags = MTD_WRITEABLE;
+	mtd->writesize  = io->min_io_size;
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
+	dbg_gluebi("added mtd%d (\"%s\"), size %u, EB size %u",
+		   mtd->index, mtd->name, mtd->size, mtd->erasesize);
+
+	return 0;
+
+out_free:
+	ubi_kfree(mtd->name);
+	return err;
+}
+
+int ubi_gluebi_vol_close(struct ubi_uif_volume *vol)
+{
+	int err;
+	struct mtd_info *mtd = &vol->gluebi_vol.mtd;
+
+	dbg_gluebi("remove mtd%d", mtd->index);
+
+	err = del_mtd_device(mtd);
+	if (err)
+		return err;
+
+	ubi_kfree(mtd->name);
+	return 0;
+}
+
+/**
+ * gluebi_get_device - get MTD device reference.
+ *
+ * @mtd: the MTD device description object
+ *
+ * This function is called every time the MTD device is being got. Returns
+ * zero in case of success and a negative error code in case of failure.
+ */
+static int gluebi_get_device(struct mtd_info *mtd)
+{
+	struct ubi_uif_volume *vol = mtd2vol(mtd);
+	struct ubi_gluebi_volume *gluebi_vol = &vol->gluebi_vol;
+
+	/*
+	 * We do not introduce locks for gluebi reference count because the
+	 * get_device()/put_device() calls are already serialized.
+	 */
+	if (gluebi_vol->refcount > 0) {
+		/*
+		 * The MTD device is already referenced and this is just one
+		 * more reference. MTD allows opening many users to open the
+		 * same volume simultaniously and do not distinguish between
+		 * readers/writers/exclusive openers as UBI does. So we do not
+		 * open the UBI volume again - just increase the reference
+		 * counter and return.
+		 */
+		gluebi_vol->refcount += 1;
+		return 0;
+	}
+
+	/*
+	 * This is the first reference to this UBI volume via the MTD device
+	 * interface. Open the corresponding volume in read-write mode.
+	 */
+	gluebi_vol->desc = ubi_open_volume(vol->ubi->ubi_num, vol->vol_id,
+					   UBI_READWRITE);
+	if (IS_ERR(gluebi_vol->desc))
+		return PTR_ERR(gluebi_vol->desc);
+	gluebi_vol->refcount += 1;
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
+	struct ubi_gluebi_volume *gluebi_vol = &mtd2vol(mtd)->gluebi_vol;
+
+	gluebi_vol->refcount -= 1;
+	ubi_assert(gluebi_vol->refcount >= 0);
+	if (gluebi_vol->refcount == 0)
+		ubi_close_volume(gluebi_vol->desc);
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
+	struct ubi_uif_volume *vol;
+	const struct ubi_info *ubi;
+
+	dbg_gluebi("read %zd bytes from offset %lld", len, from);
+
+	if (unlikely(len < 0 || from < 0 || from + len > mtd->size))
+		return -EINVAL;
+
+	vol = mtd2vol(mtd);
+	ubi = vol->ubi;
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
+		dbg_gluebi("read %zd bytes from LEB %d:%d, offset %d",
+			   to_read, vol->vol_id, lnum, offs);
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
+	struct ubi_uif_volume *vol;
+	const struct ubi_info *ubi;
+
+	dbg_gluebi("write %zd bytes to offset %lld", len, to);
+
+	if (unlikely(len < 0 || to < 0 || len + to > mtd->size))
+		return -EINVAL;
+
+	vol = mtd2vol(mtd);
+	ubi = vol->ubi;
+
+	if (unlikely(ubi->io->ro_mode))
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
+		dbg_gluebi("write %zd bytes to LEB %d:%d, offset %d",
+			   to_write, vol->vol_id, lnum, offs);
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
+	struct ubi_uif_volume *vol;
+	const struct ubi_info *ubi;
+
+	dbg_gluebi("erase %u bytes at offset %u", instr->len, instr->addr);
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
+	vol = mtd2vol(mtd);
+	ubi = vol->ubi;
+
+	if (unlikely(ubi->io->ro_mode))
+		return -EROFS;
+
+	for (i = 0; i < count; i++) {
+		dbg_gluebi("erase LEB %d", lnum);
+
+		err = ubi_eba_erase_leb(ubi, vol->vol_id, lnum + i);
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
