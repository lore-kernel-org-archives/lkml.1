Return-Path: <linux-kernel-owner+w=401wt.eu-S1751320AbXCNPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbXCNPZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXCNPY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:24:56 -0400
Received: from smtp.nokia.com ([131.228.20.171]:57693 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXCNPYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:24:18 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:09 +0200
Message-Id: <20070314152009.1112.38444.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/22 take 3] UBI: I/O unit
X-OriginalArrivalTime: 14 Mar 2007 15:20:09.0651 (UTC) FILETIME=[40F23030:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172028-508EABB0-059508BC/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/io.c tmp-to/drivers/mtd/ubi/io.c
--- tmp-from/drivers/mtd/ubi/io.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/io.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,1445 @@
+/*
+ * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (C) Nokia Corporation, 2006, 2007
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
+ * UBI input/output unit.
+ *
+ * This unit provides a uniform way to work with all kinds of the underlying
+ * MTD devices. It also implements handy functions for reading and writing UBI
+ * headers.
+ *
+ * We are trying to have a paranoid mindset and not to trust to what we read
+ * from the flash media in order to be more secure and robust. So this unit
+ * validates every single header it reads from the flash media.
+ *
+ * Some words about how the eraseblock headers are stored.
+ *
+ * The erase counter header is always stored at offset zero. By default, the
+ * VID header is stored after the EC header at the closest aligned offset
+ * (i.e. aligned to the minimum I/O unit size). Data starts next to the VID
+ * header at the closest aligned offset. But this default layout may be
+ * changed. For example, for different reasons (e.g., optimization) UBI may be
+ * asked to put the VID header at further offset, and even at an unaligned
+ * offset. Of course, if the offset of the VID header is unaligned, UBI adds
+ * proper padding in front of it. Data offset may also be changed but it has to
+ * be aligned.
+ *
+ * About minimal I/O units. In general, UBI assumes flash device model where
+ * there is only one minimal I/O unit size. E.g., in case of NOR flash it is 1,
+ * in case of NAND flash it is a NAND page, etc. This is reported by MTD in the
+ * @io.mtd->writesize field. But as an exception, UBI admits of using another
+ * (smaller) minimal I/O unit size for EC and VID headers to make it possible
+ * to do different optimizations.
+ *
+ * This is extremely useful in case of NAND flashes which admit of several
+ * write operations to one NAND page. In this case UBI can fit EC and VID
+ * headers at one NAND page. Thus, UBI may use "sub-page" size as the minimal
+ * I/O unit for the headers (the @io.hdrs_min_io_size field). But it still
+ * reports NAND page size (@io.min_io_size) as a minimal I/O unit for the UBI
+ * users.
+ *
+ * Example: some Samsung NANDs with 2KiB pages allow 4x 512-byte writes, so
+ * although the minimal I/O unit is 2K, UBI uses 512 bytes for EC and VID
+ * headers.
+ *
+ * Q: why not just to treat sub-page as a minimal I/O unit of this flash
+ * device, e.g., make @io.min_io_size = 512 in the example above?
+ *
+ * A: because when writing a sub-page, MTD still writes a full 2K page but the
+ * bytes which are no relevant to the sub-page are 0xFF. So, basically, writing
+ * 4x512 sub-pages is 4 times slower then writing one 2KiB NAND page. Thus, we
+ * prefer to use sub-pages only for EV and VID headers.
+ *
+ * As it was noted above, the VID header may start at a non-aligned offset.
+ * For example, in case of a 2KiB page NAND flash with a 512 bytes sub-page,
+ * the VID header may reside at offset 1984 which is the last 64 bytes of the
+ * last sub-page (EC header is always at offset zero). This causes some
+ * difficulties when reading and writing VID headers.
+ *
+ * Suppose we have a 64-byte buffer and we read a VID header at it. We change
+ * the data and want to write this VID header out. As we can only write in
+ * 512-byte chunks, we have to allocate one more buffer and copy our VID header
+ * to offset 448 of this buffer.
+ *
+ * The I/O unit does the following trick in order to avoid this extra copy.
+ * It always allocates a @io.vid_hdr_alsize bytes buffer for the VID header and
+ * returns a pointer to offset @io.vid_hdr_shift of this buffer. When the VID
+ * header is being written out, it shifts the VID header pointer back and
+ * writes the whole sub-page.
+ */
+
+#include <linux/crc32.h>
+#include <linux/err.h>
+#include "ubi.h"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_IO
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
+#endif
+
+/*
+ * In case of an input/output error, UBI tries to repeat the operation several
+ * times before returning error. The below constant defines how many times
+ * UBI re-tries.
+ */
+#define IO_RETRIES 3
+
+/**
+ * ubi_io_read - read data from a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @buf: buffer where to store the read data
+ * @pnum: physical eraseblock number to read from
+ * @offset: offset within the physical eraseblock from where to read
+ * @len: how many bytes to read
+ *
+ * This function reads data from offset @offset of physical eraseblock @pnum
+ * and stores the read data in the @buf buffer. The following return codes are
+ * possible:
+ *
+ * o %0 if all the requested data were successfully read;
+ * o %UBI_IO_BITFLIPS if all the requested data were successfully read, but
+ *   correctable bit-flips were detected; this is harmless but may indicate
+ *   that this eraseblock may become bad soon (but do not have to);
+ * o %-EBADMSG if the MTD subsystem reported about data data integrity
+ *   problems, for example it can me an ECC error in case of NAND; this most
+ *   probably means that the data is corrupted;
+ * o %-EIO if some I/O error occurred;
+ * o other negative error codes in case of other errors.
+ */
+int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
+		int len)
+{
+	int err, retries = 0;
+	size_t read;
+	loff_t addr;
+
+	dbg_io("read %d bytes from PEB %d:%d", len, pnum, offset);
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
+	ubi_assert(offset >= 0 && offset + len <= ubi->io.peb_size);
+	ubi_assert(len > 0);
+
+	err = paranoid_check_not_bad(ubi, pnum);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
+	addr = (loff_t)pnum * ubi->io.peb_size + offset;
+retry:
+	err = ubi->io.mtd->read(ubi->io.mtd, addr, len, &read, buf);
+	if (unlikely(err)) {
+		if (err == -EUCLEAN) {
+			/*
+			 * -EUCLEAN is reported if there was a bit-flip which
+			 * was corrected, so this is harmless.
+			 */
+			dbg_io("bit-flip occurred");
+			ubi_assert(len == read);
+			return UBI_IO_BITFLIPS;
+		}
+
+		if (read != len && retries++ < IO_RETRIES) {
+			dbg_io("error %d while reading %d bytes from PEB %d:%d, "
+			       "read only %zd bytes, retry",
+			       err, len, pnum, offset, read);
+			yield();
+			goto retry;
+		}
+
+		ubi_err("error %d while reading %d bytes from PEB %d:%d, "
+			"read %zd bytes", err, len, pnum, offset, read);
+		ubi_dbg_dump_stack();
+	} else {
+		ubi_assert(len == read);
+
+		if (ubi_dbg_is_bitflip()) {
+			dbg_io("emulate bit-flip");
+			err = UBI_IO_BITFLIPS;
+		}
+	}
+
+	return err;
+}
+
+/**
+ * ubi_io_write - write data to a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @buf: buffer with the data to write
+ * @pnum: physical eraseblock number to write to
+ * @offset: offset within the physical eraseblock where to write
+ * @len: how many bytes to write
+ *
+ * This function writes @len bytes of data from buffer @buf to offset @offset
+ * of physical eraseblock @pnum. If all the data were successfully written,
+ * zero is returned. If an error occurred, this function returns a negative
+ * error code. If %-EIO is returned, the physical eraseblock most probably went
+ * bad.
+ *
+ * Note, in case of an error, it is possible that something was still written
+ * to the flash media, but may be some garbage.
+ */
+int ubi_io_write(const struct ubi_info *ubi, const void *buf, int pnum,
+		 int offset, int len)
+{
+	int err;
+	size_t written;
+	loff_t addr;
+
+	dbg_io("write %d bytes to PEB %d:%d", len, pnum, offset);
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
+	ubi_assert(offset >= 0 && offset + len <= ubi->io.peb_size);
+	ubi_assert(offset % ubi->io.hdrs_min_io_size == 0);
+	ubi_assert(len > 0 && len % ubi->io.hdrs_min_io_size == 0);
+
+	if (unlikely(ubi->io.ro_mode)) {
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
+	if (offset >= ubi->io.leb_start) {
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
+	if (ubi_dbg_is_write_failure()) {
+		ubi_err("cannot write %d bytes to PEB %d:%d "
+			"(emulated)", len, pnum, offset);
+		ubi_dbg_dump_stack();
+		return -EIO;
+	}
+
+	addr = (loff_t)pnum * ubi->io.peb_size + offset;
+	err = ubi->io.mtd->write(ubi->io.mtd, addr, len, &written, buf);
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
+/**
+ * erase_callback - MTD erasure call-back.
+ *
+ * @ei: MTD erase information object.
+ *
+ * Note, even though MTD erase interface is asynchronous, all the current
+ * implementations are synchronous anyway.
+ */
+static void erase_callback(struct erase_info *ei)
+{
+	wake_up_interruptible((wait_queue_head_t *)ei->priv);
+}
+
+/**
+ * do_sync_erase - synchronously erase a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to erase
+ *
+ * This function synchronously erases physical eraseblock @pnum and returns
+ * zero in case of success and a negative error code in case of failure. If
+ * %-EIO is returned, the physical eraseblock most probably went bad.
+ */
+static int do_sync_erase(const struct ubi_info *ubi, int pnum)
+{
+	int err, retries = 0;
+	struct erase_info ei;
+	wait_queue_head_t wq;
+
+	dbg_io("erase PEB %d", pnum);
+
+retry:
+	init_waitqueue_head(&wq);
+	memset(&ei, 0, sizeof(struct erase_info));
+
+	ei.mtd      = ubi->io.mtd;
+	ei.addr     = pnum * ubi->io.peb_size;
+	ei.len      = ubi->io.peb_size;
+	ei.callback = erase_callback;
+	ei.priv     = (unsigned long)&wq;
+
+	err = ubi->io.mtd->erase(ubi->io.mtd, &ei);
+	if (unlikely(err)) {
+		if (retries++ < IO_RETRIES) {
+			dbg_io("error %d while erasing PEB %d, retry",
+			       err, pnum);
+			yield();
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
+		if (retries++ < IO_RETRIES) {
+			dbg_io("error while erasing PEB %d, retry", pnum);
+			yield();
+			goto retry;
+		}
+		ubi_err("cannot erase PEB %d", pnum);
+		ubi_dbg_dump_stack();
+		return -EIO;
+	}
+
+	err = paranoid_check_all_ff(ubi, pnum, 0, ubi->io.peb_size);
+	if (unlikely(err))
+		return err > 0 ? -EINVAL : err;
+
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
+ * torture_peb - test a supposedly bad physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to test
+ *
+ * This function returns %-EIO if the physical eraseblock did not pass the
+ * test, a positive number of erase operations done if the test was
+ * successfully passed, and other negative error codes in case of other errors.
+ */
+static int torture_peb(const struct ubi_info *ubi, int pnum)
+{
+	void *buf;
+	int err, i, patt_count;
+
+	buf = kmalloc(ubi->io.peb_size, GFP_KERNEL);
+	if (unlikely(!buf))
+		return -ENOMEM;
+
+	patt_count = ARRAY_SIZE(patterns);
+	ubi_assert(patt_count > 0);
+
+	for (i = 0; i < patt_count; i++) {
+		err = do_sync_erase(ubi, pnum);
+		if (unlikely(err))
+			goto out;
+
+		/* Make sure the PEB contains only 0xFF bytes */
+		err = ubi_io_read(ubi, buf, pnum, 0, ubi->io.peb_size);
+		if (unlikely(err))
+			goto out;
+
+		err = ubi_buf_all_ff(buf, ubi->io.peb_size);
+		if (unlikely(err == 0)) {
+			ubi_err("erased PEB %d, but a non-0xFF byte found",
+				pnum);
+			err = -EIO;
+			goto out;
+		}
+
+		/* Write a pattern and check it */
+		memset(buf, patterns[i], ubi->io.peb_size);
+		err = ubi_io_write(ubi, buf, pnum, 0, ubi->io.peb_size);
+		if (unlikely(err))
+			goto out;
+
+		memset(buf, ~patterns[i], ubi->io.peb_size);
+		err = ubi_io_read(ubi, buf, pnum, 0, ubi->io.peb_size);
+		if (unlikely(err))
+			goto out;
+
+		err = ubi_check_pattern(buf, patterns[i], ubi->io.peb_size);
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
+		 * has not passed because it happened on a freshly erased
+		 * physical eraseblock which means something is wrong with it.
+		 */
+		err = -EIO;
+	kfree(buf);
+	return err;
+}
+
+/**
+ * ubi_io_sync_erase - synchronously erase a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock number to erase
+ * @torture: if this physical eraseblock has to be tortured
+ *
+ * This function synchronously erases physical eraseblock @pnum. If @torture
+ * flag is not zero, the physical eraseblock is checked by means of writing
+ * different patterns to it and reading them back. If the torturing is enabled,
+ * the physical eraseblock is erased more then once.
+ *
+ * This function returns the number of erasures made in case of success, %-EIO
+ * if the erasure failed or the torturing test failed, and other negative error
+ * codes in case of other errors. Note, %-EIO means that the physical
+ * eraseblock is bad.
+ */
+int ubi_io_sync_erase(const struct ubi_info *ubi, int pnum, int torture)
+{
+	int err, ret = 0;
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
+
+	err = paranoid_check_not_bad(ubi, pnum);
+	if (unlikely(err != 0))
+		return err > 0 ? -EINVAL : err;
+
+	if (unlikely(ubi->io.ro_mode)) {
+		ubi_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (torture) {
+		ret = torture_peb(ubi, pnum);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	err = do_sync_erase(ubi, pnum);
+	if (unlikely(err))
+		return err;
+
+	return ret + 1;
+}
+
+/**
+ * ubi_io_is_bad - check if a physical eraseblock is bad.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to check
+ *
+ * This function returns a positive number if the physical eraseblock is bad,
+ * zero if not, and a negative error code if an error occurred.
+ */
+int ubi_io_is_bad(const struct ubi_info *ubi, int pnum)
+{
+	struct mtd_info *mtd = ubi->io.mtd;
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
+
+	if (ubi->io.bad_allowed) {
+		int ret;
+
+		ret = mtd->block_isbad(mtd, (loff_t)pnum * ubi->io.peb_size);
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
+/**
+ * ubi_io_mark_bad - mark a physical eraseblock as bad.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to mark
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_io_mark_bad(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+	struct mtd_info *mtd = ubi->io.mtd;
+
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
+
+	if (unlikely(ubi->io.ro_mode)) {
+		ubi_err("read-only mode");
+		return -EROFS;
+	}
+
+	if (!ubi->io.bad_allowed)
+		return 0;
+
+	err = mtd->block_markbad(mtd, (loff_t)pnum * ubi->io.peb_size);
+	if (unlikely(err))
+		ubi_err("cannot mark PEB %d bad, error %d", pnum, err);
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
+	if (unlikely(vid_hdr_offset != ubi->io.vid_hdr_offset)) {
+		ubi_err("bad VID header offset %d, expected %d",
+			vid_hdr_offset, ubi->io.vid_hdr_offset);
+		goto bad;
+	}
+
+	if (unlikely(leb_start != ubi->io.leb_start)) {
+		ubi_err("bad data offset %d, expected %d",
+			leb_start, ubi->io.leb_start);
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
+ * ubi_io_read_ec_hdr - read and check an erase counter header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock to read from
+ * @ec_hdr: a &struct ubi_ec_hdr object where to store the read erase counter
+ * header
+ * @verbose: be verbose if the header is corrupted or was not found
+ *
+ * This function reads erase counter header from physical eraseblock @pnum and
+ * stores it in @ec_hdr. This function also checks CRC checksum of the read
+ * erase counter header. The following codes may be returned:
+ *
+ * o %0 if the CRC checksum is correct and the header was successfully read;
+ * o %UBI_IO_BITFLIPS if the CRC is correct, but bit-flips were detected
+ *   and corrected by the flash driver; this is harmless but may indicate that
+ *   this eraseblock may become bad soon (but may be not);
+ * o %UBI_IO_BAD_EC_HDR if the erase counter header is corrupted (a CRC error);
+ * o %UBI_IO_PEB_EMPTY if the physical eraseblock is empty;
+ * o a negative error code in case of failure.
+ */
+int ubi_io_read_ec_hdr(const struct ubi_info *ubi, int pnum,
+		       struct ubi_ec_hdr *ec_hdr, int verbose)
+{
+	int err, read_err = 0;
+	uint32_t crc, magic, hdr_crc;
+
+	dbg_io("read EC header from PEB %d", pnum);
+	ubi_assert(pnum >= 0 && pnum < ubi->io.peb_count);
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
+		 * have a CRC check-sum and we will detect this. If the EC
+		 * header is still OK, we just report this as there was a
+		 * bit-flip.
+		 */
+		read_err = err;
+	}
+
+	magic = ubi32_to_cpu(ec_hdr->magic);
+	if (unlikely(magic != UBI_EC_HDR_MAGIC)) {
+		/*
+		 * The magic field is wrong. Let's check if we have read all
+		 * 0xFF. If yes, this physical eraseblock is assumed to be
+		 * empty.
+		 *
+		 * But if there was a read error, we do not test it for all
+		 * 0xFFs. Even if it does contain all 0xFFs, this error
+		 * indicates that something is still wrong with this physical
+		 * eraseblock and we anyway cannot treat it as empty.
+		 */
+		if (read_err != -EBADMSG &&
+		    ubi_buf_all_ff(ec_hdr, UBI_EC_HDR_SIZE)) {
+			/* The physical eraseblock is supposedly empty */
+
+			/*
+			 * The below is just a paranoid check, it has to be
+			 * compiled out if paranoid checks are disabled.
+			 */
+			err = paranoid_check_all_ff(ubi, pnum, 0,
+						    ubi->io.peb_size);
+			if (unlikely(err))
+				return err > 0 ? UBI_IO_BAD_EC_HDR : err;
+
+			if (verbose)
+				ubi_warn("no EC header found at PEB %d, "
+					 "only 0xFF bytes", pnum);
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
+	/* And of course validate what has just been read from the media */
+	err = validate_ec_hdr(ubi, ec_hdr);
+	if (unlikely(err)) {
+		ubi_err("validation failed for PEB %d", pnum);
+		return -EINVAL;
+	}
+
+	return read_err ? UBI_IO_BITFLIPS : 0;
+}
+
+/**
+ * ubi_io_write_ec_hdr - write an erase counter header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock to write to
+ * @ec_hdr: the erase counter header to write
+ *
+ * This function writes erase counter header described by @ec_hdr to physical
+ * eraseblock @pnum. It also fills most fields of @ec_hdr before writing, so
+ * the caller do not have to fill them. Callers must only fill the @ec_hdr->ec
+ * field.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. If %-EIO is returned, the physical eraseblock most probably
+ * went bad.
+ */
+int ubi_io_write_ec_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_ec_hdr *ec_hdr)
+{
+	int err;
+	uint32_t crc;
+
+	dbg_io("write EC header to PEB %d", pnum);
+	ubi_assert(pnum >= 0 &&  pnum < ubi->io.peb_count);
+
+	ec_hdr->magic = cpu_to_ubi32(UBI_EC_HDR_MAGIC);
+	ec_hdr->version = UBI_VERSION;
+	ec_hdr->vid_hdr_offset = cpu_to_ubi32(ubi->io.vid_hdr_offset);
+	ec_hdr->data_offset = cpu_to_ubi32(ubi->io.leb_start);
+	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
+	ec_hdr->hdr_crc = cpu_to_ubi32(crc);
+
+	err = paranoid_check_ec_hdr(ubi, pnum, ec_hdr);
+	if (unlikely(err))
+		return -EINVAL;
+
+	err = ubi_io_write(ubi, ec_hdr, pnum, 0, ubi->io.ec_hdr_alsize);
+	return err;
+}
+
+/**
+ * validate_vid_hdr - validate a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @vid_hdr: the volume identifier header to check
+ *
+ * This function checks that data stored in the volume identifier header
+ * @vid_hdr. Returns zero if the VID header is OK and %1 if not.
+ */
+static int validate_vid_hdr(const struct ubi_info *ubi,
+			    const struct ubi_vid_hdr *vid_hdr)
+{
+	int vol_type = vid_hdr->vol_type;
+	int copy_flag = vid_hdr->copy_flag;
+	int vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	int lnum = ubi32_to_cpu(vid_hdr->lnum);
+	int compat = vid_hdr->compat;
+	int data_size = ubi32_to_cpu(vid_hdr->data_size);
+	int used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
+	int data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+	int data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+	int usable_leb_size = ubi->io.leb_size - data_pad;
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
+	if (unlikely(data_pad >= ubi->io.leb_size / 2)) {
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
+/**
+ * ubi_io_read_vid_hdr - read and check a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock number to read from
+ * @vid_hdr: &struct ubi_vid_hdr object where to store the read volume
+ * identifier header
+ * @verbose: be verbose if the header is corrupted or wasn't found
+ *
+ * This function reads the volume identifier header from physical eraseblock
+ * @pnum and stores it in @vid_hdr. It also checks CRC checksum of the read
+ * volume identifier header. The following codes may be returned:
+ *
+ * o %0 if the CRC checksum is correct and the header was successfully read;
+ * o %UBI_IO_BITFLIPS if the CRC is correct, but bit-flips were detected
+ *   and corrected by the flash driver; this is harmless but may indicate that
+ *   this eraseblock may become bad soon;
+ * o %UBI_IO_BAD_VID_HRD if the volume identifier header is corrupted (a CRC
+ *   error detected);
+ * o %UBI_IO_PEB_FREE if the physical eraseblock is free (i.e., there is no VID
+ *   header there);
+ * o a negative error code in case of failure.
+ */
+int ubi_io_read_vid_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_vid_hdr *vid_hdr, int verbose)
+{
+	int err, read_err = 0;
+	uint32_t crc, magic, hdr_crc;
+	void *p;
+
+	dbg_io("read VID header from PEB %d", pnum);
+	ubi_assert(pnum >= 0 &&  pnum < ubi->io.peb_count);
+
+	p = (char *)vid_hdr - ubi->io.vid_hdr_shift;
+	err = ubi_io_read(ubi, p, pnum, ubi->io.vid_hdr_aloffset,
+			  ubi->io.vid_hdr_alsize);
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
+		 * eraseblock and it cannot be regarded as free.
+		 */
+		if (likely(read_err != -EBADMSG) &&
+		    ubi_buf_all_ff(vid_hdr, UBI_VID_HDR_SIZE)) {
+			/* The physical eraseblock is supposedly free */
+
+			/*
+			 * The below is just a paranoid check, it has to be
+			 * compiled out if paranoid checks are disabled.
+			 */
+			err = paranoid_check_all_ff(ubi, pnum, ubi->io.leb_start,
+						    ubi->io.leb_size);
+			if (unlikely(err))
+				return err > 0 ? UBI_IO_BAD_VID_HDR : err;
+
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
+/**
+ * ubi_io_write_vid_hdr - write a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to write to
+ * @vid_hdr: the volume identifier header to write
+ *
+ * This function writes the volume identifier header described by @vid_hdr to
+ * physical eraseblock @pnum. This function automatically fills the
+ * @vid_hdr->magic and the @vid_hdr->version fields, as well as calculates
+ * header CRC checksum and stores it at vid_hdr->hdr_crc.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. If %-EIO is returned, the physical eraseblock probably went
+ * bad.
+ */
+int ubi_io_write_vid_hdr(const struct ubi_info *ubi, int pnum,
+			 struct ubi_vid_hdr *vid_hdr)
+{
+	int err;
+	uint32_t crc;
+	void *p;
+
+	dbg_io("write VID header to PEB %d", pnum);
+	ubi_assert(pnum >= 0 &&  pnum < ubi->io.peb_count);
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
+	p = (char *)vid_hdr - ubi->io.vid_hdr_shift;
+	err = ubi_io_write(ubi, p, pnum, ubi->io.vid_hdr_aloffset,
+			   ubi->io.vid_hdr_alsize);
+	return err;
+}
+
+/**
+ * ubi_io_init - initialize the UBI I/O unit for a given UBI device.
+ *
+ * @ubi: the UBI device description object
+ * @mtd_num: the underlying MTD device number
+ * @vid_hdr_offset: volume identifier header offset
+ * @data_offset: logical eraseblock data offset
+ *
+ * If the @vid_hdr_offset and @data_offset parameters are zero, the default
+ * offsets are assumed:
+ *   o the EC header is always at offset zero - this cannot be changed;
+ *   o the VID header starts just after the EC header at the closest address
+ *     aligned to @io->@hdrs_min_io_size;
+ *   o data starts just after the VID header at the closest address aligned to
+ *     @io->@min_io_size
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_io_init(struct ubi_info *ubi, int mtd_num, int vid_hdr_offset,
+		int data_offset)
+{
+	int err;
+	struct mtd_info *mtd;
+
+	dbg_io("initialize the UBI I/O unit for MTD device %d, VID hdr offset "
+	       "%d data offset %d", mtd_num, vid_hdr_offset, data_offset);
+
+	mtd = ubi->io.mtd = get_mtd_device(NULL, mtd_num);
+	if (IS_ERR(mtd)) {
+		ubi_err("cannot open MTD device %d", mtd_num);
+		return PTR_ERR(mtd);
+	}
+	ubi->io.mtd_num = mtd_num;
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
+	ubi->io.mtd_name   = mtd->name;
+	ubi->io.peb_size   = mtd->erasesize;
+	ubi->io.peb_count  = mtd->size / mtd->erasesize;
+	ubi->io.flash_size = mtd->size;
+
+	if (mtd->block_isbad && mtd->block_markbad)
+		ubi->io.bad_allowed = 1;
+
+	ubi->io.min_io_size = mtd->writesize;
+	ubi->io.hdrs_min_io_size = mtd->writesize >> mtd->subpage_sft;
+
+	ubi_assert(ubi->io.hdrs_min_io_size > 0);
+	ubi_assert(ubi->io.hdrs_min_io_size <= ubi->io.min_io_size);
+	ubi_assert(ubi->io.min_io_size % ubi->io.hdrs_min_io_size == 0);
+
+	/* Calculate default aligned sizes of EC and VID headers */
+	ubi->io.ec_hdr_alsize = align_up(UBI_EC_HDR_SIZE,
+					 ubi->io.hdrs_min_io_size);
+	ubi->io.vid_hdr_alsize = align_up(UBI_VID_HDR_SIZE,
+					  ubi->io.hdrs_min_io_size);
+
+	dbg_io("min_io_size      %d", ubi->io.min_io_size);
+	dbg_io("hdrs_min_io_size %d", ubi->io.hdrs_min_io_size);
+	dbg_io("ec_hdr_alsize    %d", ubi->io.ec_hdr_alsize);
+	dbg_io("vid_hdr_alsize   %d", ubi->io.vid_hdr_alsize);
+
+	if (vid_hdr_offset == 0)
+		/* Default offset */
+		ubi->io.vid_hdr_offset = ubi->io.vid_hdr_aloffset =
+					 ubi->io.ec_hdr_alsize;
+	else {
+		ubi->io.vid_hdr_offset = vid_hdr_offset;
+		ubi->io.vid_hdr_aloffset = align_down(vid_hdr_offset,
+						      ubi->io.hdrs_min_io_size);
+		ubi->io.vid_hdr_shift = vid_hdr_offset -
+						ubi->io.vid_hdr_aloffset;
+	}
+
+	/* Similar for the data offset */
+	if (data_offset == 0) {
+		ubi->io.leb_start = ubi->io.vid_hdr_offset
+					+ ubi->io.vid_hdr_alsize;
+		ubi->io.leb_start = align_up(ubi->io.leb_start,
+					     ubi->io.min_io_size);
+	} else
+		ubi->io.leb_start = data_offset;
+
+	dbg_io("vid_hdr_offset   %d", ubi->io.vid_hdr_offset);
+	dbg_io("vid_hdr_aloffset %d", ubi->io.vid_hdr_aloffset);
+	dbg_io("vid_hdr_shift    %d", ubi->io.vid_hdr_shift);
+	dbg_io("leb_start        %d", ubi->io.leb_start);
+
+	/* The shift must be aligned to 32-bit boundary */
+	if (ubi->io.vid_hdr_shift % 4) {
+		ubi_err("unaligned VID header shift %d",
+			ubi->io.vid_hdr_shift);
+		goto out_mtd;
+	}
+
+	/* Check sanity */
+	if (ubi->io.vid_hdr_offset < UBI_EC_HDR_SIZE ||
+	    ubi->io.leb_start < ubi->io.vid_hdr_offset + UBI_VID_HDR_SIZE ||
+	    ubi->io.leb_start > ubi->io.peb_size - UBI_VID_HDR_SIZE ||
+	    ubi->io.leb_start % ubi->io.min_io_size) {
+		ubi_err("bad VID header (%d) or data offsets (%d)",
+			ubi->io.vid_hdr_offset, ubi->io.leb_start);
+		goto out_mtd;
+	}
+
+	/*
+	 * It may happen that EC and VID headers are situated in one minimal
+	 * I/O unit. In this case we can only accept this UBI image in
+	 * read-only mode.
+	 */
+	if (ubi->io.vid_hdr_offset + UBI_VID_HDR_SIZE <=
+						ubi->io.hdrs_min_io_size) {
+		ubi_warn("EC and VID headers are in the same minimal I/O unit, "
+			 "switch to read-only mode");
+		ubi->io.ro_mode = 1;
+	}
+
+	ubi->io.leb_size = ubi->io.peb_size - ubi->io.leb_start;
+
+	if (!(mtd->flags & MTD_WRITEABLE)) {
+		ubi_msg("MTD device %d is write-protected, attach in "
+			"read-only mode", mtd_num);
+		ubi->io.ro_mode = 1;
+	}
+
+	dbg_io("leb_size         %d", ubi->io.leb_size);
+	dbg_io("ro_mode          %d", ubi->io.ro_mode);
+
+	/*
+	 * FIXME: ideally, we have to initialize ubi->io.bad_peb_count here. But
+	 * unfortunately, MTD does not provide this information. We should loop
+	 * over all physical eraseblocks and invoke mtd->block_is_bad() which
+	 * is not optimal. So, we skip ubi->io.bad_peb_count uninitialized and
+	 * let the scanning unit to initialize it. This is not nice.
+	 */
+
+	dbg_io("the UBI I/O unit is initialized");
+	return 0;
+
+out_mtd:
+	put_mtd_device(mtd);
+	return err;
+}
+
+/**
+ * ubi_io_close - close the UBI I/O unit for a given UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_io_close(const struct ubi_info *ubi)
+{
+	dbg_io("close the UBI I/O unit for mtd device %d", ubi->io.mtd_num);
+	put_mtd_device(ubi->io.mtd);
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
+	ec_hdr = kzalloc(ubi->io.ec_hdr_alsize, GFP_KERNEL);
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
+	kfree(ec_hdr);
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
+	void *p;
+
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (unlikely(!vid_hdr))
+		return -ENOMEM;
+
+	p = (char *)vid_hdr - ubi->io.vid_hdr_shift;
+	err = ubi_io_read(ubi, p, pnum, ubi->io.vid_hdr_aloffset,
+			  ubi->io.vid_hdr_alsize);
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
+	loff_t addr = (loff_t)pnum * ubi->io.peb_size + offset;
+
+	buf = kzalloc(len, GFP_KERNEL);
+	if (unlikely(!buf))
+		return -ENOMEM;
+
+	err = ubi->io.mtd->read(ubi->io.mtd, addr, len, &read, buf);
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
+	kfree(buf);
+	return 0;
+
+fail:
+	ubi_err("paranoid check failed for PEB %d", pnum);
+	dbg_err("hex dump of the %d-%d region", offset, offset + len);
+	ubi_dbg_hexdump(buf, len);
+	err = 1;
+error:
+	ubi_dbg_dump_stack();
+	kfree(buf);
+	return err;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_IO */
