Return-Path: <linux-kernel-owner+w=401wt.eu-S2992482AbXBQQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992482AbXBQQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992470AbXBQQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:59:12 -0500
Received: from smtp.nokia.com ([131.228.20.172]:56788 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXBQQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:58:52 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:55:30 +0200
Message-Id: <20070217165530.5845.68877.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/44 take 2] [UBI] I/O unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:29.0547 (UTC) FILETIME=[6DF14DB0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185248-03D70BB0-1B911ED5/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/io.h tmp-to/drivers/mtd/ubi/io.h
--- tmp-from/drivers/mtd/ubi/io.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/io.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,419 @@
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
+/*
+ * UBI input/output unit.
+ *
+ * This unit provides a uniform way to work with all kinds of the underlying
+ * MTD devices. It also implements handy functions for reading and writing UBI
+ * headers.
+ *
+ * We are trying to have a paranoid mindset and not to trust to what we read
+ * from the flash media in order to be more secure and robust. For example, we
+ * do not want to have vulnerability when attackers feed us with an
+ * inconsistent image end ends up with a buffer overflow. This is especially
+ * important if UBI is ever used on removable media. So, UBI validates every
+ * single node it reads from the flash media.
+ */
+
+#ifndef __UBI_IO_H__
+#define __UBI_IO_H__
+
+struct ubi_info;
+struct ubi_ec_hdr;
+struct ubi_vid_hdr;
+struct ubi_io_info;
+struct mtd_info;
+
+/*
+ * Error codes returned by this unit.
+ *
+ * @UBI_IO_PEB_EMPTY: the physical eraseblock is empty, i.e. it contains only
+ * %0xFF bytes
+ * @UBI_IO_PEB_FREE: the physical eraseblock is free, i.e. it contains only a
+ * valid erase counter header, and the rest are %0xFF bytes
+ * @UBI_IO_BAD_EC_HDR: the erase counter header is corrupted (bad magic or CRC)
+ * @UBI_IO_BAD_VID_HDR: the volume identifier header is corrupted (bad magic or
+ * CRC)
+ * @UBI_IO_BITFLIPS: bit-flips were detected and corrected
+ */
+enum {
+	UBI_IO_PEB_EMPTY = 1,
+	UBI_IO_PEB_FREE,
+	UBI_IO_BAD_EC_HDR,
+	UBI_IO_BAD_VID_HDR,
+	UBI_IO_BITFLIPS
+};
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
+ *   that this eraseblock may become bad soon;
+ * o %-EBADMSG if the MTD subsystem reported about data data integrity
+ *   problems, for example it can me an ECC error in case of NAND; this most
+ *   probably means that the data is corrupted;
+ * o %-EIO if some I/O error occurred;
+ * o Other negative error codes in case of other errors.
+ */
+int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
+		int len);
+
+/**
+ * ubi_io_read_data - read logical eraseblock data from a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @buf: buffer where to store the read data
+ * @pnum: physical eraseblock number to read from
+ * @offset: offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ *
+ * This function is equivalent to 'ubi_io_read()', but @offset is relative to
+ * the beginning of the logical eraseblock, not to the beginning of the
+ * physical eraseblock.
+ */
+#define ubi_io_read_data(ubi, buf, pnum, offset, len)  ({                    \
+	int __err;                                                           \
+	ubi_assert((offset) >= 0);                                           \
+	__err = ubi_io_read(ubi, buf, pnum, (offset) + (ubi)->io->leb_start, \
+			    len);                                            \
+	__err = __err;                                                       \
+})
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
+		 int offset, int len);
+
+/**
+ * ubi_io_write_data - write logical eraseblock data to a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @buf: buffer with the data to write
+ * @pnum: physical eraseblock number to write to
+ * @offset: offset within the logical eraseblock where to write
+ * @len: how many bytes to write
+ *
+ * This function is equivalent to 'ubi_io_write()', but @offset is relative to
+ * the beginning of the logical eraseblock, not to the beginning of the
+ * physical eraseblock.
+ */
+#define ubi_io_write_data(ubi, buf, pnum, offset, len) ({                     \
+	int __err;                                                            \
+	ubi_assert((offset) >= 0);                                            \
+	__err = ubi_io_write(ubi, buf, pnum, (offset) + (ubi)->io->leb_start, \
+			     len);                                            \
+	__err = __err;                                                        \
+})
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
+ * different patterns and reading them back. If the torturing is enabled, the
+ * physical eraseblock is erased more then once.
+ *
+ * This function returns the number of erasures made in case of success, %-EIO
+ * if erasure failed or the torturing test failed, and other negative error
+ * codes in case of other errors. Note, %-EIO most probably means that the
+ * physical eraseblock is bad.
+ */
+int ubi_io_sync_erase(const struct ubi_info *ubi, int pnum, int torture);
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
+int ubi_io_is_bad(const struct ubi_info *ubi, int pnum);
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
+int ubi_io_mark_bad(const struct ubi_info *ubi, int pnum);
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
+ *   this eraseblock may become bad soon;
+ * o %UBI_IO_BAD_EC_HDR if the erase counter header is corrupted (a CRC error);
+ * o %UBI_IO_PEB_EMPTY if the physical eraseblock is empty;
+ * o %-EIO if an input/output error occurred and this function failed to read
+ *   the erase counter header; this may indicate serious problems;
+ * o other negative values in case of other errors.
+ */
+int ubi_io_read_ec_hdr(const struct ubi_info *ubi, int pnum,
+		       struct ubi_ec_hdr *ec_hdr, int verbose);
+
+/**
+ * ubi_io_write_ec_hdr - write an erase counter header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock to write to
+ * @ec_hdr: the erase counter header to write
+ *
+ * This function writes the erase counter header described by @ec_hdr to
+ * physical eraseblock @pnum. This function also fills most fields of @ec_hdr
+ * before writing, so the caller do not have to fill them. Callers must only fill
+ * the @ec_hdr->ec field.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. If %-EIO is returned, the physical eraseblock most probably
+ * went bad.
+ */
+int ubi_io_write_ec_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_ec_hdr *ec_hdr);
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
+ * o %-EIO if an input/output error occurred and this function failed to read
+ *   the erase counter header; this indicates some serious problems;
+ * o other negative values in case of other errors.
+ */
+int ubi_io_read_vid_hdr(const struct ubi_info *ubi, int pnum,
+			struct ubi_vid_hdr *vid_hdr, int verbose);
+
+/**
+ * ubi_io_write_vid_hdr - write a volume identifier header.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to write to
+ * @vid_hdr: the contents of the volume identifier header
+ *
+ * This function writes the volume identifier header described by @vid_hdr to
+ * physical eraseblock @pnum. Callers do not have to fill all the fields of the
+ * passed volume identifier header object as this function fills many of them
+ * automatically. Callers have to fill only @vid_hdr->vol_type,
+ * @vid_hdr->leb_ver, @vid_hdr->vol_id, @vid_hdr->lnum, @vid_hdr->compat,
+ * @vid_hdr->data_size, @vid_hdr->used_ebs, and @vid_hdr->data_pad fields.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. If %-EIO is returned, the physical eraseblock probably went
+ * bad.
+ */
+int ubi_io_write_vid_hdr(const struct ubi_info *ubi, int pnum,
+			 struct ubi_vid_hdr *vid_hdr);
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
+ *   o the EC header is always at offset zero - this cannot be changed
+ *   o the VID header starts after the EC header at the closest address aligned
+ *   to @io->@hdrs_min_io_size
+ *   o data starts after the VID header at the closest address aligned to
+ *   @io->@min_io_size
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_io_init(struct ubi_info *ubi, int mtd_num, int vid_hdr_offset,
+		int data_offset);
+
+/**
+ * ubi_io_close - close the UBI I/O unit for a given UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_io_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_io_info - UBI I/O unit description data structure.
+ *
+ * @flash_size: the underlying MTD device size (in bytes)
+ * @peb_count: count of physical eraseblocks on the MTD device
+ * @peb_size: physical eraseblock size
+ * @bad_peb_count: count of bad physical eraseblocks
+ * @good_peb_count: count of good physical eraseblocks
+ * @min_io_size: minimal input/output unit size of the underlying MTD device
+ * @hdrs_min_io_size: minimal I/O unit size used for VID and EC headers
+ * @ro_mode: if the UBI device is in read-only mode
+ * @leb_size: logical eraseblock size
+ * @leb_start: starting offset of logical eraseblocks within physical
+ * eraseblocks
+ * @ec_hdr_alsize: size of the EC header aligned to @hdrs_min_io_size
+ * @vid_hdr_alsize: size of the VID header aligned to @hdrs_min_io_size
+ * @vid_hdr_offset: starting offset of the volume identifier header (might be
+ * unaligned)
+ * @vid_hdr_aloffset: starting offset of the VID header aligned to
+ * @hdrs_min_io_size
+ * @vid_hdr_shift: contains @vid_hdr_offset - @vid_hdr_aloffset
+ * @bad_allowed: whether the underlying MTD device admits of bad physical
+ * eraseblocks or not
+ * @mtd_num: the underlying MTD device number
+ * @mtd_name: the underlying MTD device name
+ * @mtd: the underlying MTD device descriptor
+ *
+ * The erase counter header is always stored at offset zero. By default, the
+ * VID header is stored after the EC header at the closest aligned offset
+ * (note, aligned means aligned to the minimum I/O unit size in this context).
+ * Data starts next to the VID header at the closest aligned offset. But for
+ * different reasons (e.g., optimization), UBI may be asked to put the VID
+ * header at another offset, and even at an unaligned offset. Of course, if the
+ * offset of the VID header is unaligned, UBI adds proper padding before it.
+ *
+ * About minimal I/O units. In general, UBI assumes flash device model where
+ * there is only one minimal I/O unit size. E.g., in case of NOR flash it is 1,
+ * in case of NAND flash it is a NAND page, etc. This is reported by MTD in the
+ * @writesize field. But as an exception, UBI admits of using another
+ * (smaller) minimal I/O unit size for EC and VID headers to make it possible
+ * to do different optimizations.
+ *
+ * For example, this is extremely useful in case of NAND flashes which admit of
+ * several write operations to one NAND page. In this case UBI can fit EC and
+ * VID headers at one NAND page. So, in case of such NAND flashes UBI uses
+ * "sub-page" size as the minimal I/O unit for the headers (the
+ * @hdrs_min_io_size field). But it still reports NAND page size (min_io_size)
+ * as a minimal I/O unit for the UBI users.
+ *
+ * Example: some Samsung NANDs with 2KiB pages allow 4x 512-byte writes, so
+ * although the minimal I/O unit is 2K, UBI uses 512 bytes for UBI and VID
+ * headers.
+ *
+ * Q: why not just to treat sub-page as a minimal I/O unit of this flash
+ * device, e.g., make @min_io_size = 512 in the example above?
+ *
+ * A: because when writing a sub-page, MTD still writes a full 2K page but the
+ * bytes which are no relevant to the sub-page are 0xFF. So, basically, writing
+ * 4x512 sub-pages is 4x times slower then writing one 2KiB NAND page. Thus, we
+ * prefer to use sub-pages only for EV and VID headers.
+ *
+ * As it was noted above, the VID header may start at an non-aligned offset.
+ * For example, in case of a 2KiB-PER-page NAND flash with a 512 bytes
+ * sub-page, the VID header may reside at offset 1984 which is the last 64
+ * bytes of the last sub-page (EC header is always at offset zero). This causes
+ * some difficulties when reading and writing VID headers.
+ *
+ * Suppose we have a 64-byte buffer and we read VID header at it. We change the
+ * data and wand to write this VID header to some eraseblock. As we can only
+ * write in 512-byte chunks, we have to allocate one more buffer and copy our
+ * VID header to offset 448 of this buffer.
+ *
+ * The I/O unit, together with the memory allocation unit do the following
+ * trick in order to avoid this extra copy. The memory allocation allocates
+ * a @vid_hdr_alsize bytes buffer for the VID header and returns a pointer to
+ * offset @vid_hdr_shift of this buffer. When write VID headers, we shift the
+ * VID header pointed back and write the whole sub-page.
+ */
+struct ubi_io_info {
+	long long flash_size; /* public  */
+	int peb_count;        /* public  */
+	int peb_size;         /* public  */
+	int bad_peb_count;    /* public  */
+	int good_peb_count;   /* public  */
+	int min_io_size;      /* public  */
+	int hdrs_min_io_size; /* public  */
+	int ro_mode;          /* public  */
+	int leb_size;         /* public  */
+	int leb_start;        /* public  */
+	int ec_hdr_alsize;    /* public  */
+	int vid_hdr_alsize;   /* public  */
+	int vid_hdr_offset;   /* public  */
+	int vid_hdr_aloffset; /* public  */
+	int vid_hdr_shift;    /* public  */
+	int bad_allowed;      /* public  */
+	int mtd_num;          /* public  */
+	const char *mtd_name; /* public  */
+	struct mtd_info *mtd; /* private */
+};
+
+#endif /* !__UBI_IO_H__ */
