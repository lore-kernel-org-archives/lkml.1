Return-Path: <linux-kernel-owner+w=401wt.eu-S965346AbXBQQ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbXBQQ5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965355AbXBQQ4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:56:55 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52456 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343AbXBQQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:40 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:35 +0200
Message-Id: <20070217165535.5845.37685.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/44 take 2] [UBI] I/O unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:02.0287 (UTC) FILETIME=[5DB1C1F0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185159-63EC8BB0-40269E5B/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/io.c tmp-to/drivers/mtd/ubi/io.c
--- tmp-from/drivers/mtd/ubi/io.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/io.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,1297 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) Nokia Corporation, 2006,2007
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
+#include <linux/crc32.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <linux/mtd/mtd.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "io.h"
+#include "misc.h"
+#include "debug.h"
+
+/*
+ * In case of an input/output error, UBI tries to repeat the operation several
+ * times before returning error. The below constant defines how many times
+ * UBI re-tries.
+ */
+#define IO_RETRIES 3
+
+/*
+ * "Paranoid" checks of the UBI I/O unit. Note, they substantially slow down
+ * the system.
+ */
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_IO
+
+static int paranoid_check_not_bad(const struct ubi_info *ubi, int pnum);
+static int paranoid_check_peb_ec_hdr(const struct ubi_info *ubi, int pnum);
+static int paranoid_check_ec_hdr(const struct ubi_info *ubi, int pnum,
+				 const struct ubi_ec_hdr *ec_hdr);
+static int paranoid_check_peb_vid_hdr(const struct ubi_info *ubi, int pnum);
+static int paranoid_check_vid_hdr(const struct ubi_info *ubi, int pnum,
+				  const struct ubi_vid_hdr *vid_hdr);
+static int paranoid_check_all_ff(const struct ubi_info *ubi, int pnum,
+				 int offset, int len);
+#else
+#define paranoid_check_not_bad(ubi, pnum) 0
+#define paranoid_check_peb_ec_hdr(ubi, pnum)  0
+#define paranoid_check_ec_hdr(ubi, pnum, ec_hdr)  0
+#define paranoid_check_peb_vid_hdr(ubi, pnum) 0
+#define paranoid_check_vid_hdr(ubi, pnum, vid_hdr) 0
+#define paranoid_check_all_ff(ubi, pnum, offset, len) 0
+#endif /* !CONFIG_MTD_UBI_DEBUG_PARANOID_IO */
+
+/**
+ * mtd_read - read data from flash.
+ *
+ * @io: I/O unit description object
+ * @buf: a buffer where to store the read data
+ * @pnum: physical eraseblock number to read from
+ * @offset: offset to read from
+ * @len: how many bytes to read
+ * @read: how many bytes were actually read is returned here
+ *
+ * This is a simple wrapper over mtd->read().
+ */
+static inline int mtd_read(const struct ubi_io_info *io, void *buf,
+			   int pnum, int offset, int len, size_t *read)
+{
+	loff_t addr = (loff_t)pnum * io->peb_size + offset;
+
+	return io->mtd->read(io->mtd, addr, len, read, buf);
+}
+
+/**
+ * mtd_write - write data to flash.
+ *
+ * @io: I/O unit description object
+ * @buf: the data to write
+ * @pnum: physical eraseblock number to write to
+ * @offset: offset to write to
+ * @len: how many bytes to write
+ * @written: how many bytes were actually written
+ *
+ * This is a simple wrapper over mtd->write().
+ */
+static inline int mtd_write(const struct ubi_io_info *io, const void *buf,
+			    int pnum, int offset, int len, size_t *written)
+{
+	loff_t addr = (loff_t)pnum * io->peb_size + offset;
+
+	return io->mtd->write(io->mtd, addr, len, written, buf);
+}
+
+int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
+		int len)
+{
+	int err, tries = 0;
+	size_t read;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_io("read %d bytes from PEB %d:%d", len, pnum, offset);
+
+	ubi_assert(pnum >= 0 && pnum < io->peb_count);
+	ubi_assert(offset >= 0 && offset + len <= io->peb_size);
+	ubi_assert(len > 0);
+
+	err = paranoid_check_not_bad(ubi, pnum);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
+retry:
+	err = mtd_read(io, buf, pnum, offset, len, &read);
+	if (unlikely(err)) {
+		if (err == -EUCLEAN) {
+			/*
+			 * -EUCLEAN is reported if there was a bit-flip which
+			 * was corrected, so this is harmless.
+			 */
+			dbg_io("bit-flip occurred");
+			return UBI_IO_BITFLIPS;
+		}
+
+		if (read != len && tries++ < IO_RETRIES) {
+			yield();
+			dbg_io("error %d while reading %d bytes from PEB %d:%d, "
+			       "read only %zd bytes, retry",
+			       err, len, pnum, offset, read);
+			goto retry;
+		}
+
+		ubi_err("error %d while reading %d bytes from PEB %d:%d, "
+			"read %zd bytes", err, len, pnum, offset, read);
+		ubi_dbg_dump_stack();
+	} else {
+		ubi_assert(len == read);
+
+		/*
+		 * The below is just for debugging and is compiled out if
+		 * disabled.
+		 */
+		if (ubi_dbg_is_bitflip()) {
+			dbg_io("emulate bit-flip");
+			err = UBI_IO_BITFLIPS;
+		}
+	}
+
+	return err;
+}
+
+int ubi_io_write(const struct ubi_info *ubi, const void *buf, int pnum,
+		 int offset, int len)
+{
+	int err;
+	size_t written;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_io("write %d bytes to PEB %d:%d", len, pnum, offset);
+
+	ubi_assert(pnum >= 0 && pnum < io->peb_count);
+	ubi_assert(offset >= 0 && offset + len <= io->peb_size);
+	ubi_assert(offset % io->hdrs_min_io_size == 0);
+	ubi_assert(len > 0 && len % io->hdrs_min_io_size == 0);
+
+	if (unlikely(io->ro_mode)) {
+		ubi_err("read-only mode");
+		return -EROFS;
+	}
+
+	/* The below has to be compiled out if paranoid checks are disabled */
+
+	err = paranoid_check_not_bad(ubi, pnum);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
+	/* The area we are writing to has to contain all 0xFF bytes */
+	err = paranoid_check_all_ff(ubi, pnum, offset, len);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
+	if (offset >= io->leb_start) {
+		/*
+		 * We write to the data area of the physical eraseblock. Make
+		 * sure it has valid EC and VID headers.
+		 */
+		err = paranoid_check_peb_ec_hdr(ubi, pnum);
+		if (unlikely(err))
+			return err > 0 ? -EINVAL : err;
+		err = paranoid_check_peb_vid_hdr(ubi, pnum);
+		if (unlikely(err))
+			return err > 0 ? -EINVAL : err;
+	}
+
+	/* The below is just for debugging and is compiled out if disabled */
+	if (ubi_dbg_is_write_failure()) {
+		ubi_err("cannot write %d bytes to PEB %d:%d "
+			"(emulated)", len, pnum, offset);
+		ubi_dbg_dump_stack();
+		return -EIO;
+	}
+
+	err = mtd_write(io, buf, pnum, offset, len, &written);
+	if (unlikely(err)) {
+		ubi_err("error %d while writing %d bytes to PEB %d:%d, written"
+			" %zd bytes", err, len, pnum, offset, written);
+		ubi_dbg_dump_stack();
+	} else
+		ubi_assert(written == len);
+
+	return err;
+}
+
+static void erase_callback(struct erase_info *ei)
+{
+	wake_up_interruptible((wait_queue_head_t *)ei->priv);
+}
+
+static int sync_erase(const struct ubi_info *ubi, int pnum);
+static int ubi_io_torture_peb(const struct ubi_info *ubi, int pnum);
+
+int ubi_io_sync_erase(const struct ubi_info *ubi, int pnum, int torture)
+{
+	int err, ret = 0;
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io->peb_count);
+
+	if (unlikely(ubi->io->ro_mode)) {
+		ubi_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (torture) {
+		ret = ubi_io_torture_peb(ubi, pnum);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	err = sync_erase(ubi, pnum);
+	if (unlikely(err))
+		return err;
+
+	return ret + 1;
+}
+
+int ubi_io_is_bad(const struct ubi_info *ubi, int pnum)
+{
+	const struct ubi_io_info *io = ubi->io;
+	struct mtd_info *mtd = io->mtd;
+
+	ubi_assert(pnum >= 0 && pnum < io->peb_count);
+
+	if (io->bad_allowed) {
+		int ret;
+
+		ret = mtd->block_isbad(mtd, (loff_t)pnum * io->peb_size);
+		if (unlikely(ret < 0))
+			ubi_err("error %d while checking if PEB %d is bad",
+				ret, pnum);
+		else if (ret)
+			dbg_io("PEB %d is bad", pnum);
+		return ret;
+	}
+
+	return 0;
+}
+
+int ubi_io_mark_bad(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+	const struct ubi_io_info *io = ubi->io;
+	struct mtd_info *mtd = io->mtd;
+
+	ubi_assert(pnum >= 0 && pnum < io->peb_count);
+
+	if (unlikely(io->ro_mode)) {
+		ubi_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (!io->bad_allowed)
+		return 0;
+
+	err = mtd->block_markbad(mtd, (loff_t)pnum * io->peb_size);
+	if (unlikely(err))
+		ubi_err("cannot mark PEB %d bad, error %d", pnum, err);
+	return err;
+}
+
+static int validate_ec_hdr(const struct ubi_info *ubi,
+			   const struct ubi_ec_hdr *ec_hdr);
+
+int ubi_io_read_ec_hdr(const struct ubi_info *ubi, int pnum,
+		       struct ubi_ec_hdr *ec_hdr, int verbose)
+{
+	int err, read_err = 0;
+	uint32_t crc, magic, hdr_crc;
+
+	dbg_io("read EC header from PEB %d", pnum);
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io->peb_count);
+
+	err = ubi_io_read(ubi, ec_hdr, pnum, 0, UBI_EC_HDR_SIZE);
+	if (unlikely(err)) {
+		if (err != UBI_IO_BITFLIPS && err != -EBADMSG)
+			return err;
+
+		/*
+		 * We read all the data, but either a correctable bit-flip
+		 * occurred, or MTD reported about some data integrity error,
+		 * like an ECC error in case of NAND. The former is harmless,
+		 * the later may mean that the read data is corrupted. But we
+		 * have a CRC check-sum and we will identify this. If the EC
+		 * header is still OK, we just report this as there was a
+		 * bit-flip.
+		 */
+		read_err = err;
+	}
+
+	magic = ubi32_to_cpu(ec_hdr->magic);
+	if (unlikely(magic != UBI_EC_HDR_MAGIC)) {
+
+		/*
+		 * The magic field is wrong. Let's check if we have read all
+		 * 0xFF. If yes, this physical eraseblock is assumed to be
+		 * empty.
+		 *
+		 * But if there was a read error, we do not test it for all
+		 * 0xFFs. Even if it does contain all 0xFFs, this error
+		 * indicates that something is still wrong with this physical
+		 * eraseblock anyway.
+		 */
+		if (likely(read_err != -EBADMSG) &&
+		    ubi_buf_all_ff(ec_hdr, UBI_EC_HDR_SIZE)) {
+			/* The physical eraseblock is supposedly empty. But */
+
+			/*
+			 * The below is just a paranoid check, it has to be
+			 * compiled out if paranoid checks are disabled.
+			 */
+			err = paranoid_check_all_ff(ubi, pnum, 0,
+						    ubi->io->peb_size);
+			if (unlikely(err))
+				return err > 0 ? UBI_IO_BAD_EC_HDR : err;
+
+			if (verbose)
+				ubi_warn("no EC header found at PEB %d, "
+					 "only 0xFF bytes", pnum);
+
+			/*
+			 * We read all 0xFFs, so assume the eraseblock is
+			 * empty.
+			 */
+			return UBI_IO_PEB_EMPTY;
+		}
+
+		/*
+		 * This is not a valid erase counter header, and these are not
+		 * 0xFF bytes. Report that the header is corrupted.
+		 */
+		if (verbose) {
+			ubi_warn("bad magic number at PEB %d: %08x instead of "
+				 "%08x", pnum, magic, UBI_EC_HDR_MAGIC);
+			ubi_dbg_dump_ec_hdr(ec_hdr);
+		}
+		return UBI_IO_BAD_EC_HDR;
+	}
+
+	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
+	hdr_crc = ubi32_to_cpu(ec_hdr->hdr_crc);
+
+	if (unlikely(hdr_crc != crc)) {
+		if (verbose) {
+			ubi_warn("bad EC header CRC at PEB %d, calculated %#08x,"
+				 " read %#08x", pnum, crc, hdr_crc);
+			ubi_dbg_dump_ec_hdr(ec_hdr);
+		}
+		return UBI_IO_BAD_EC_HDR;
+	}
+
+	/* Validate what was read from the media */
+	err = validate_ec_hdr(ubi, ec_hdr);
+	if (unlikely(err > 0)) {
+		ubi_err("validation failed for PEB %d", pnum);
+		return -EINVAL;
+	}
+
+	return read_err ? UBI_IO_BITFLIPS : 0;
+}
+
+int ubi_io_write_ec_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_ec_hdr *ec_hdr)
+{
+	int err;
+	uint32_t crc;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_io("write EC header to PEB %d", pnum);
+
+	ubi_assert(pnum >= 0 &&  pnum < io->peb_count);
+
+	ec_hdr->magic = cpu_to_ubi32(UBI_EC_HDR_MAGIC);
+	ec_hdr->version = UBI_VERSION;
+	ec_hdr->vid_hdr_offset = cpu_to_ubi32(io->vid_hdr_offset);
+	ec_hdr->data_offset = cpu_to_ubi32(io->leb_start);
+	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
+	ec_hdr->hdr_crc = cpu_to_ubi32(crc);
+
+	err = paranoid_check_ec_hdr(ubi, pnum, ec_hdr);
+	if (unlikely(err))
+		return -EINVAL;
+
+	err = ubi_io_write(ubi, ec_hdr, pnum, 0, io->ec_hdr_alsize);
+	return err;
+}
+
+static int validate_vid_hdr(const struct ubi_info *ubi,
+			    const struct ubi_vid_hdr *vid_hdr);
+
+int ubi_io_read_vid_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_vid_hdr *vid_hdr, int verbose)
+{
+	int err, read_err = 0;
+	uint32_t crc, magic, hdr_crc;
+	const struct ubi_io_info *io = ubi->io;
+	void *p;
+
+	dbg_io("read VID header from PEB %d", pnum);
+
+	ubi_assert(pnum >= 0 &&  pnum < io->peb_count);
+
+	p = (char *)vid_hdr - io->vid_hdr_shift;
+	err = ubi_io_read(ubi, p, pnum, io->vid_hdr_aloffset,
+			  io->vid_hdr_alsize);
+	if (unlikely(err)) {
+		if (err != UBI_IO_BITFLIPS && err != -EBADMSG)
+			return err;
+
+		/*
+		 * We read all the data, but either a correctable bit-flip
+		 * occurred, or MTD reported about some data integrity error,
+		 * like an ECC error in case of NAND. The former is harmless,
+		 * the later may mean the read data is corrupted. But we have a
+		 * CRC check-sum and we will identify this. If the VID header is
+		 * still OK, we just report this as there was a bit-flip.
+		 */
+		read_err = err;
+	}
+
+	magic = ubi32_to_cpu(vid_hdr->magic);
+	if (unlikely(magic != UBI_VID_HDR_MAGIC)) {
+		/*
+		 * If we have read all 0xFF bytes, the VID header probably does
+		 * not exist and the physical eraseblock is assumed to be free.
+		 *
+		 * But if there was a read error, we do not test the data for
+		 * 0xFFs. Even if it does contain all 0xFFs, this error
+		 * indicates that something is still wrong with this physical
+		 * eraseblock.
+		 */
+		if (likely(read_err != -EBADMSG) &&
+		    ubi_buf_all_ff(vid_hdr, UBI_VID_HDR_SIZE)) {
+			/* The physical eraseblock is supposedly free */
+
+			/*
+			 * The below is just a paranoid check, it has to be
+			 * compiled out if paranoid checks are disabled.
+			 */
+			err = paranoid_check_all_ff(ubi, pnum, io->leb_start,
+						    io->leb_size);
+			if (unlikely(err))
+				return err > 0 ? UBI_IO_BAD_VID_HDR : err;
+
+			/*
+			 * We read all 0xFFs, so assume the eraseblock is
+			 * free.
+			 */
+			if (verbose)
+				ubi_warn("no VID header found at PEB %d, "
+					 "only 0xFF bytes", pnum);
+			return UBI_IO_PEB_FREE;
+		}
+
+		/*
+		 * This is not a valid VID header, and these are not 0xFF
+		 * bytes. Report that the header is corrupted.
+		 */
+		if (verbose) {
+			ubi_warn("bad magic number at PEB %d: %08x instead of "
+				 "%08x", pnum, magic, UBI_VID_HDR_MAGIC);
+			ubi_dbg_dump_vid_hdr(vid_hdr);
+		}
+		return UBI_IO_BAD_VID_HDR;
+	}
+
+	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_VID_HDR_SIZE_CRC);
+	hdr_crc = ubi32_to_cpu(vid_hdr->hdr_crc);
+
+	if (unlikely(hdr_crc != crc)) {
+		if (verbose) {
+			ubi_warn("bad CRC at PEB %d, calculated %#08x, "
+				 "read %#08x", pnum, crc, hdr_crc);
+			ubi_dbg_dump_vid_hdr(vid_hdr);
+		}
+		return UBI_IO_BAD_VID_HDR;
+	}
+
+	/* Validate the VID header that we have just read */
+	err = validate_vid_hdr(ubi, vid_hdr);
+	if (unlikely(err)) {
+		ubi_err("validation failed for PEB %d", pnum);
+		return -EINVAL;
+	}
+
+	return read_err ? UBI_IO_BITFLIPS : 0;
+}
+
+int ubi_io_write_vid_hdr(const struct ubi_info *ubi, int pnum,
+			 struct ubi_vid_hdr *vid_hdr)
+{
+	int err;
+	uint32_t crc;
+	const struct ubi_io_info *io = ubi->io;
+	void *p;
+
+	dbg_io("write VID header to PEB %d", pnum);
+
+	ubi_assert(pnum >= 0 &&  pnum < io->peb_count);
+
+	err = paranoid_check_peb_ec_hdr(ubi, pnum);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL: err;
+
+	vid_hdr->magic = cpu_to_ubi32(UBI_VID_HDR_MAGIC);
+	vid_hdr->version = UBI_VERSION;
+	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_VID_HDR_SIZE_CRC);
+	vid_hdr->hdr_crc = cpu_to_ubi32(crc);
+
+	err = paranoid_check_vid_hdr(ubi, pnum, vid_hdr);
+	if (unlikely(err))
+		return -EINVAL;
+
+	p = (char *)vid_hdr - io->vid_hdr_shift;
+	err = ubi_io_write(ubi, p, pnum, io->vid_hdr_aloffset,
+			   io->vid_hdr_alsize);
+	return err;
+}
+
+int ubi_io_init(struct ubi_info *ubi, int mtd_num, int vid_hdr_offset,
+		int data_offset)
+{
+	int err;
+	struct mtd_info *mtd;
+	struct ubi_io_info *io;
+
+	dbg_io("initialize the UBI I/O unit for MTD device %d, VID hdr offset "
+	       "%d data offset %d", mtd_num, vid_hdr_offset, data_offset);
+
+	io = ubi_kzalloc(sizeof(struct ubi_io_info));
+	if (!io)
+		return -ENOMEM;
+	ubi->io = io;
+
+	mtd = io->mtd = get_mtd_device(NULL, mtd_num);
+	if (IS_ERR(mtd)) {
+		ubi_err("cannot open MTD device %d", mtd_num);
+		err = PTR_ERR(mtd);
+		goto out_io;
+	}
+	io->mtd_num = mtd_num;
+
+	err = -EINVAL;
+	if (mtd->numeraseregions != 0) {
+		/*
+		 * Some flashes have several erase regions. Different regions
+		 * may have different eraseblock size and other
+		 * characteristics. It looks like mostly multi-region flashes
+		 * have one "main" region and one or more small regions to
+		 * store boot loader code or boot parameters or whatever. I
+		 * guess we should just pick the largest region. But this is
+		 * not implemented.
+		 */
+		ubi_err("multiple regions, not implemented");
+		goto out_mtd;
+	}
+
+	/*
+	 * Note, in this implementation we support MTD devices with 0x7FFFFFFF
+	 * physical eraseblocks maximum.
+	 */
+
+	io->mtd_name   = mtd->name;
+	io->peb_size   = mtd->erasesize;
+	io->peb_count  = mtd->size / mtd->erasesize;
+	io->flash_size = mtd->size;
+
+	if (mtd->block_isbad && mtd->block_markbad)
+		io->bad_allowed = 1;
+
+	io->min_io_size = mtd->writesize;
+	io->hdrs_min_io_size = mtd->writesize >> mtd->subpage_sft;
+
+	ubi_assert(io->hdrs_min_io_size > 0);
+	ubi_assert(io->hdrs_min_io_size <= io->min_io_size);
+	ubi_assert(io->min_io_size % io->hdrs_min_io_size == 0);
+
+	/* Calculate default aligned sizes of EC and VID headers */
+	io->ec_hdr_alsize = align_up(UBI_EC_HDR_SIZE, io->hdrs_min_io_size);
+	io->vid_hdr_alsize = align_up(UBI_VID_HDR_SIZE, io->hdrs_min_io_size);
+
+	dbg_io("min_io_size      %d", io->min_io_size);
+	dbg_io("hdrs_min_io_size %d", io->hdrs_min_io_size);
+	dbg_io("ec_hdr_alsize    %d", io->ec_hdr_alsize);
+	dbg_io("vid_hdr_alsize   %d", io->vid_hdr_alsize);
+
+	if (vid_hdr_offset == 0)
+		/* Default offset */
+		io->vid_hdr_offset = io->vid_hdr_aloffset = io->ec_hdr_alsize;
+	else {
+		io->vid_hdr_offset = vid_hdr_offset;
+		io->vid_hdr_aloffset = align_down(vid_hdr_offset,
+						  io->hdrs_min_io_size);
+		io->vid_hdr_shift = vid_hdr_offset - io->vid_hdr_aloffset;
+	}
+
+	/* Similar for the data offset */
+	if (data_offset == 0) {
+		io->leb_start = io->vid_hdr_offset + io->vid_hdr_alsize;
+		io->leb_start = align_up(io->leb_start, io->min_io_size);
+	} else
+		io->leb_start = data_offset;
+
+	dbg_io("vid_hdr_offset   %d", io->vid_hdr_offset);
+	dbg_io("vid_hdr_aloffset %d", io->vid_hdr_aloffset);
+	dbg_io("vid_hdr_shift    %d", io->vid_hdr_shift);
+	dbg_io("leb_start        %d", io->leb_start);
+
+	/* The shift must be aligned to 32-bit boundary */
+	if (io->vid_hdr_shift % 4) {
+		ubi_err("unaligned VID header shift %d",
+			io->vid_hdr_shift);
+		goto out_mtd;
+	}
+
+	/* Check sanity */
+	if (io->vid_hdr_offset < UBI_EC_HDR_SIZE ||
+	    io->leb_start < io->vid_hdr_offset + UBI_VID_HDR_SIZE ||
+	    io->leb_start > io->peb_size - UBI_VID_HDR_SIZE ||
+	    io->leb_start % io->min_io_size) {
+		ubi_err("bad VID header (%d) or data offsets (%d)",
+			io->vid_hdr_offset, io->leb_start);
+		goto out_mtd;
+	}
+
+	/*
+	 * It may happen that EC and VID headers are situated in one minimal
+	 * I/O unit. In this case we can only accept this UBI image in
+	 * read-only mode.
+	 */
+	if (io->vid_hdr_offset + UBI_VID_HDR_SIZE <= io->hdrs_min_io_size) {
+		ubi_warn("EC and VID headers are in the same minimal I/O unit, "
+			 "switch to read-only mode");
+		io->ro_mode = 1;
+	}
+
+	io->leb_size = io->peb_size - io->leb_start;
+
+	if (!(mtd->flags & MTD_WRITEABLE)) {
+		ubi_msg("MTD device %d is write-protected, attach in "
+			"read-only mode", mtd_num);
+		io->ro_mode = 1;
+	}
+
+	dbg_io("leb_size         %d", io->leb_size);
+	dbg_io("ro_mode          %d", io->ro_mode);
+
+	/*
+	 * FIXME: ideally, we have to initialize io->bad_peb_count here. But
+	 * unfortunately, MTD does not provide this information. We should loop
+	 * over all physical eraseblocks and invoke mtd->block_is_bad() which
+	 * is not optimal. So, we skip io->bad_peb_count uninitialized and let
+	 * the scanning unit to initialize it. This is not nice.
+	 */
+
+	dbg_io("the UBI I/O unit is initialized");
+	return 0;
+
+out_mtd:
+	put_mtd_device(mtd);
+out_io:
+	ubi_kfree(io);
+	return err;
+}
+
+void ubi_io_close(const struct ubi_info *ubi)
+{
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_io("close the UBI I/O unit for mtd device %d", io->mtd_num);
+	put_mtd_device(io->mtd);
+	ubi_kfree(io);
+}
+
+/**
+ * sync_erase - synchronously erase a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to erase
+ *
+ * This function synchronously erases physical eraseblock @pnum and returns
+ * zero in case of success and a negative error code in case of failure. If
+ * %-EIO is returned, the physical eraseblock went bad.
+ */
+static int sync_erase(const struct ubi_info *ubi, int pnum)
+{
+	int err, tries = 0;
+	struct erase_info ei;
+	wait_queue_head_t wq;
+	const struct ubi_io_info *io = ubi->io;
+
+	/*
+	 * Note, even though MTD erase interface is asynchronous, all the
+	 * current implementations are synchronous.
+	 */
+
+	dbg_io("erase PEB %d", pnum);
+
+	ubi_assert(pnum >= 0 && pnum < io->peb_count);
+
+	err = paranoid_check_not_bad(ubi, pnum);
+	if (unlikely(err != 0))
+		return err > 0 ? -EINVAL : err;
+
+retry:
+	init_waitqueue_head(&wq);
+	memset(&ei, 0, sizeof(struct erase_info));
+
+	ei.mtd      = io->mtd;
+	ei.addr     = pnum * io->peb_size;
+	ei.len      = io->peb_size;
+	ei.retries  = 2;
+	ei.callback = erase_callback;
+	ei.priv     = (unsigned long)&wq;
+
+	err = io->mtd->erase(io->mtd, &ei);
+	if (unlikely(err)) {
+		if (tries++ < IO_RETRIES) {
+			yield();
+			dbg_io("error %d while erasing PEB %d, retry",
+			       err, pnum);
+			goto retry;
+		}
+		ubi_err("cannot erase PEB %d, error %d", pnum, err);
+		ubi_dbg_dump_stack();
+		return err;
+	}
+
+	err = wait_event_interruptible(wq, ei.state == MTD_ERASE_DONE ||
+					   ei.state == MTD_ERASE_FAILED);
+	if (unlikely(err)) {
+		ubi_err("interrupted PEB %d erasure", pnum);
+		return -EINTR;
+	}
+
+	if (unlikely(ei.state == MTD_ERASE_FAILED)) {
+		if (tries++ < IO_RETRIES) {
+			yield();
+			dbg_io("error while erasing PEB %d, retry", pnum);
+			goto retry;
+		}
+		ubi_err("cannot erase PEB %d", pnum);
+		ubi_dbg_dump_stack();
+		return -EIO;
+	}
+
+	err = paranoid_check_all_ff(ubi, pnum, 0, io->peb_size);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
+	/* The below is just for debugging and is compiled out if disabled */
+	if (ubi_dbg_is_erase_failure() && !err) {
+		ubi_err("cannot erase PEB %d (emulated)", pnum);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* Patterns to write to a physical eraseblock when torturing it */
+static uint8_t patterns[] = {0xa5, 0x5a, 0x0};
+
+/**
+ * ubi_io_torture_peb - test a supposedly bad physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to test
+ *
+ * This function returns %-EIO if the physical eraseblock did not pass the
+ * test, a positive number of erase operations done if the test was
+ * successfully passed, and other negative error codes in case of other errors.
+ */
+static int ubi_io_torture_peb(const struct ubi_info *ubi, int pnum)
+{
+	void *buf;
+	int err, i, patt_count;
+	const struct ubi_io_info *io = ubi->io;
+
+	buf = ubi_kmalloc(io->peb_size);
+	if (unlikely(!buf))
+		return -ENOMEM;
+
+	patt_count = ARRAY_SIZE(patterns);
+	ubi_assert(patt_count > 0);
+
+	for (i = 0; i < patt_count; i++) {
+		err = sync_erase(ubi, pnum);
+		if (unlikely(err))
+			goto out;
+
+		/* Make sure the PEB contains only 0xFF bytes */
+		err = ubi_io_read(ubi, buf, pnum, 0, io->peb_size);
+		if (unlikely(err))
+			goto out;
+
+		err = ubi_buf_all_ff(buf, io->peb_size);
+		if (unlikely(err == 0)) {
+			ubi_err("erased PEB %d, but a non-0xFF byte found",
+				pnum);
+			err = -EIO;
+			goto out;
+		}
+
+		/* Write a pattern and check it */
+		memset(buf, patterns[i], io->peb_size);
+		err = ubi_io_write(ubi, buf, pnum, 0, io->peb_size);
+		if (unlikely(err))
+			goto out;
+
+		memset(buf, ~patterns[i], io->peb_size);
+		err = ubi_io_read(ubi, buf, pnum, 0, io->peb_size);
+		if (unlikely(err))
+			goto out;
+
+		err = ubi_check_pattern(buf, patterns[i], io->peb_size);
+		if (unlikely(err == 0)) {
+			ubi_err("pattern %x checking failed for PEB %d",
+				patterns[i], pnum);
+			err = -EIO;
+			goto out;
+		}
+	}
+
+	err = patt_count;
+
+out:
+	if (unlikely(err == UBI_IO_BITFLIPS || err == -EBADMSG))
+		/*
+		 * If a bit-flip or data integrity error was detected, the test
+		 * has not been passed.
+		 */
+		err = -EIO;
+	ubi_kfree(buf);
+	return err;
+}
+
+/**
+ * validate_ec_hdr - validate an erase counter header.
+ *
+ * @ubi: the UBI device description object
+ * @ec_hdr: the erase counter header to check
+ *
+ * This function returns zero if the erase counter header is OK, and %1 if
+ * not.
+ */
+static int validate_ec_hdr(const struct ubi_info *ubi,
+			   const struct ubi_ec_hdr *ec_hdr)
+{
+	long long ec;
+	int vid_hdr_offset, leb_start;
+	const struct ubi_io_info *io = ubi->io;
+
+	ec = ubi64_to_cpu(ec_hdr->ec);
+	vid_hdr_offset = ubi32_to_cpu(ec_hdr->vid_hdr_offset);
+	leb_start = ubi32_to_cpu(ec_hdr->data_offset);
+
+	if (unlikely(ec_hdr->version != UBI_VERSION)) {
+		ubi_err("node with incompatible UBI version found: "
+			"this UBI version is %d, image version is %d",
+			UBI_VERSION, (int)ec_hdr->version);
+		goto bad;
+	}
+
+	if (unlikely(vid_hdr_offset != io->vid_hdr_offset)) {
+		ubi_err("bad VID header offset %d, expected %d",
+			vid_hdr_offset, io->vid_hdr_offset);
+		goto bad;
+	}
+
+	if (unlikely(leb_start != io->leb_start)) {
+		ubi_err("bad data offset %d, expected %d",
+			leb_start, io->leb_start);
+		goto bad;
+	}
+
+	if (unlikely(ec < 0 || ec > UBI_MAX_ERASECOUNTER)) {
+		ubi_err("bad erase counter %lld", ec);
+		goto bad;
+	}
+
+	return 0;
+
+bad:
+	ubi_err("bad EC header");
+	ubi_dbg_dump_ec_hdr(ec_hdr);
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+/**
+ * validate_vid_hdr - validate a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @vid_hdr: the volume identifier header to check
+ *
+ * This function checks that data stored in the volume identifier header
+ * @vid_hdr is sane. This function returns zero if the VID header is OK and %1
+ * if not.
+ */
+static int validate_vid_hdr(const struct ubi_info *ubi,
+			    const struct ubi_vid_hdr *vid_hdr)
+{
+	const struct ubi_io_info *io = ubi->io;
+	int vol_type = vid_hdr->vol_type;
+	int copy_flag = vid_hdr->copy_flag;
+	int vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	int lnum = ubi32_to_cpu(vid_hdr->lnum);
+	int compat = vid_hdr->compat;
+	int data_size = ubi32_to_cpu(vid_hdr->data_size);
+	int used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
+	int data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+	int data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+	int usable_leb_size = io->leb_size - data_pad;
+
+	if (unlikely(copy_flag != 0 && copy_flag != 1)) {
+		dbg_err("bad copy_flag");
+		goto bad;
+	}
+
+	if (unlikely(vol_id < 0 || lnum < 0 || data_size < 0 || used_ebs < 0 ||
+		     data_pad < 0)) {
+		dbg_err("negative values");
+		goto bad;
+	}
+
+	if (unlikely(vol_id >= UBI_MAX_VOLUMES &&
+		     vol_id < UBI_INTERNAL_VOL_START)) {
+		dbg_err("bad vol_id");
+		goto bad;
+	}
+
+	if (unlikely(vol_id < UBI_INTERNAL_VOL_START && compat != 0)) {
+		dbg_err("bad compat");
+		goto bad;
+	}
+
+	if (unlikely(vol_id >= UBI_INTERNAL_VOL_START &&
+		     compat != UBI_COMPAT_DELETE &&
+		     compat != UBI_COMPAT_RO &&
+		     compat != UBI_COMPAT_PRESERVE &&
+		     compat != UBI_COMPAT_REJECT)) {
+		dbg_err("bad compat");
+		goto bad;
+	}
+
+	if (unlikely(vol_type != UBI_VID_DYNAMIC &&
+		     vol_type != UBI_VID_STATIC)) {
+		dbg_err("bad vol_type");
+		goto bad;
+	}
+
+	if (unlikely(data_pad >= io->leb_size / 2)) {
+		dbg_err("bad data_pad");
+		goto bad;
+	}
+
+	if (vol_type == UBI_VID_STATIC) {
+		/*
+		 * Although from high-level point of view static volumes may
+		 * contain zero bytes of data, but no VID headers can contain
+		 * zero at these fields, because they empty volumes do not have
+		 * mapped logical eraseblocks.
+		 */
+		if (unlikely(used_ebs == 0)) {
+			dbg_err("zero used_ebs");
+			goto bad;
+		}
+		if (unlikely(data_size == 0)) {
+			dbg_err("zero data_size");
+			goto bad;
+		}
+		if (lnum < used_ebs - 1) {
+			if (unlikely(data_size != usable_leb_size)) {
+				dbg_err("bad data_size");
+				goto bad;
+			}
+		} else if (lnum == used_ebs - 1) {
+			if (unlikely(data_size == 0)) {
+				dbg_err("bad data_size at last LEB");
+				goto bad;
+			}
+		} else {
+			dbg_err("too high lnum");
+			goto bad;
+		}
+	} else {
+		if (copy_flag == 0) {
+			if (unlikely(data_crc != 0)) {
+				dbg_err("non-zero data CRC");
+				goto bad;
+			}
+			if (unlikely(data_size != 0)) {
+				dbg_err("non-zero data_size");
+				goto bad;
+			}
+		} else {
+			if (unlikely(data_size == 0)) {
+				dbg_err("zero data_size of copy");
+				goto bad;
+			}
+		}
+		if (unlikely(used_ebs != 0)) {
+			dbg_err("bad used_ebs");
+			goto bad;
+		}
+	}
+
+	return 0;
+
+bad:
+	ubi_err("bad VID header");
+	ubi_dbg_dump_vid_hdr(vid_hdr);
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_IO
+
+/**
+ * paranoid_check_not_bad - ensure that a physical eraseblock is not bad.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock number to check
+ *
+ * This function returns zero if the physical eraseblock is good, a positive
+ * number if it is bad and a negative error code if an error occurred.
+ */
+static int paranoid_check_not_bad(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+
+	err = ubi_io_is_bad(ubi, pnum);
+	if (likely(!err))
+		return err;
+
+	ubi_err("paranoid check failed for PEB %d", pnum);
+	ubi_dbg_dump_stack();
+	return err;
+}
+
+/**
+ * paranoid_check_ec_hdr - check if an erase counter header is all right.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock number the erase counter header belongs to
+ * @ec_hdr: the erase counter header to check
+ *
+ * This function returns zero if the erase counter header contains valid
+ * values, and %1 if not.
+ */
+static int paranoid_check_ec_hdr(const struct ubi_info *ubi, int pnum,
+				 const struct ubi_ec_hdr *ec_hdr)
+{
+	int err;
+	uint32_t magic;
+
+	magic = ubi32_to_cpu(ec_hdr->magic);
+	if (unlikely(magic != UBI_EC_HDR_MAGIC)) {
+		ubi_err("bad magic %#08x, must be %#08x",
+			magic, UBI_EC_HDR_MAGIC);
+		goto fail;
+	}
+
+	err = validate_ec_hdr(ubi, ec_hdr);
+	if (unlikely(err)) {
+		ubi_err("paranoid check failed for PEB %d", pnum);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	ubi_dbg_dump_ec_hdr(ec_hdr);
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+/**
+ * paranoid_check_peb_ec_hdr - check that the erase counter header of a
+ * physical eraseblock is in-place and is all right.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to check
+ *
+ * This function returns zero if the erase counter header is all right, %1 if
+ * not, and a negative error code if an error occurred.
+ */
+static int paranoid_check_peb_ec_hdr(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+	uint32_t crc, hdr_crc;
+	struct ubi_ec_hdr *ec_hdr;
+
+	ec_hdr = ubi_zalloc_ec_hdr(ubi);
+	if (unlikely(!ec_hdr))
+		return -ENOMEM;
+
+	err = ubi_io_read(ubi, ec_hdr, pnum, 0, UBI_EC_HDR_SIZE);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS && err != -EBADMSG)
+		goto exit;
+
+	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
+	hdr_crc = ubi32_to_cpu(ec_hdr->hdr_crc);
+	if (unlikely(hdr_crc != crc)) {
+		ubi_err("bad CRC, calculated %#08x, read %#08x", crc, hdr_crc);
+		ubi_err("paranoid check failed for PEB %d", pnum);
+		ubi_dbg_dump_ec_hdr(ec_hdr);
+		ubi_dbg_dump_stack();
+		err = 1;
+		goto exit;
+	}
+
+	err = paranoid_check_ec_hdr(ubi, pnum, ec_hdr);
+
+exit:
+	ubi_free_ec_hdr(ubi, ec_hdr);
+	return err;
+}
+
+/**
+ * paranoid_check_vid_hdr - check that a volume identifier header is all right.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock number the volume identifier header belongs to
+ * @vid_hdr: the volume identifier header to check
+ *
+ * This function returns zero if the volume identifier header is all right, and
+ * %1 if not.
+ */
+static int paranoid_check_vid_hdr(const struct ubi_info *ubi, int pnum,
+				  const struct ubi_vid_hdr *vid_hdr)
+{
+	int err;
+	uint32_t magic;
+
+	magic = ubi32_to_cpu(vid_hdr->magic);
+	if (unlikely(magic != UBI_VID_HDR_MAGIC)) {
+		ubi_err("bad VID header magic %#08x at PEB %d, must be %#08x",
+			magic, pnum, UBI_VID_HDR_MAGIC);
+		goto fail;
+	}
+
+	err = validate_vid_hdr(ubi, vid_hdr);
+	if (unlikely(err)) {
+		ubi_err("paranoid check failed for PEB %d", pnum);
+		goto fail;
+	}
+
+	return err;
+
+fail:
+	ubi_err("paranoid check failed for PEB %d", pnum);
+	ubi_dbg_dump_vid_hdr(vid_hdr);
+	ubi_dbg_dump_stack();
+	return 1;
+
+}
+
+/**
+ * paranoid_check_peb_vid_hdr - check that the volume identifier header of a
+ * physical eraseblock is in-place and is all right.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to check
+ *
+ * This function returns zero if the volume identifier header is all right,
+ * %1 if not, and a negative error code if an error occurred.
+ */
+static int paranoid_check_peb_vid_hdr(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+	uint32_t crc, hdr_crc;
+	struct ubi_vid_hdr *vid_hdr;
+	const struct ubi_io_info *io = ubi->io;
+	void *p;
+
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (unlikely(!vid_hdr))
+		return -ENOMEM;
+
+	p = (char *)vid_hdr - io->vid_hdr_shift;
+	err = ubi_io_read(ubi, p, pnum, io->vid_hdr_aloffset,
+			  io->vid_hdr_alsize);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS && err != -EBADMSG)
+		goto exit;
+
+	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_EC_HDR_SIZE_CRC);
+	hdr_crc = ubi32_to_cpu(vid_hdr->hdr_crc);
+	if (unlikely(hdr_crc != crc)) {
+		ubi_err("bad VID header CRC at PEB %d, calculated %#08x, "
+			"read %#08x", pnum, crc, hdr_crc);
+		ubi_err("paranoid check failed for PEB %d", pnum);
+		ubi_dbg_dump_vid_hdr(vid_hdr);
+		ubi_dbg_dump_stack();
+		err = 1;
+		goto exit;
+	}
+
+	err = paranoid_check_vid_hdr(ubi, pnum, vid_hdr);
+
+exit:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return err;
+}
+
+/**
+ * paranoid_check_all_ff - check that a region of flash is empty.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to check
+ * @offset: the starting offset within the physical eraseblock to check
+ * @len: the length of the region to check
+ *
+ * This function returns zero if only 0xFF bytes are present at offset
+ * @offset of the physical eraseblock @pnum, %1 if not, and a negative error
+ * code if an error occurred.
+ */
+static int paranoid_check_all_ff(const struct ubi_info *ubi, int pnum,
+				 int offset, int len)
+{
+	size_t read;
+	int err;
+	void *buf;
+	const struct ubi_io_info *io = ubi->io;
+
+	buf = ubi_kzalloc(len);
+	if (unlikely(!buf))
+		return -ENOMEM;
+
+	err = mtd_read(io, buf, pnum, offset, len, &read);
+	if (unlikely(err && err != -EUCLEAN)) {
+		ubi_err("error %d while reading %d bytes from PEB %d:%d, "
+			"read %zd bytes", err, len, pnum, offset, read);
+		goto error;
+	}
+
+	err = ubi_buf_all_ff(buf, len);
+	if (unlikely(err == 0)) {
+		ubi_err("flash region at PEB %d:%d, length %d does not "
+			"contain all 0xFF bytes", pnum, offset, len);
+		goto fail;
+	}
+
+	ubi_kfree(buf);
+	return 0;
+
+fail:
+	ubi_err("paranoid check failed for PEB %d", pnum);
+	dbg_err("hex dump of the %d-%d region", offset, offset + len);
+	ubi_dbg_hexdump(buf, len);
+	err = 1;
+error:
+	ubi_dbg_dump_stack();
+	ubi_kfree(buf);
+	return err;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_IO */
