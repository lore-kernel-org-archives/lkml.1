Return-Path: <linux-kernel-owner+w=401wt.eu-S2992458AbXBQQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992458AbXBQQzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992462AbXBQQzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:55:17 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52118 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992458AbXBQQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:55:15 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:54:44 +0200
Message-Id: <20070217165444.5845.9892.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/44 take 2] [UBI] kernel-spce API header
X-OriginalArrivalTime: 17 Feb 2007 16:54:11.0993 (UTC) FILETIME=[3FB78090:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185117-5EAEEBB0-4D79D370/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/include/linux/mtd/ubi.h tmp-to/include/linux/mtd/ubi.h
--- tmp-from/include/linux/mtd/ubi.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/include/linux/mtd/ubi.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,391 @@
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
+#ifndef __LINUX_UBI_H__
+#define __LINUX_UBI_H__
+
+#include <linux/types.h>
+#include <asm/ioctl.h>
+#include <mtd/ubi-user.h>
+
+/**
+ * enum ubi_data_type - UBI data type hint constants.
+ *
+ * @UBI_DATA_LONGTERM: long-term data
+ * @UBI_DATA_SHORTTERM: short-term data
+ * @UBI_DATA_UNKNOWN: data persistence is unknown
+ *
+ * These constants are used when data is written to UBI volumes in order to
+ * help the UBI wear-leveling unit to find more appropriate physical
+ * eraseblocks.
+ */
+enum ubi_data_type {
+	UBI_DATA_LONGTERM = 1,
+	UBI_DATA_SHORTTERM,
+	UBI_DATA_UNKNOWN
+};
+
+/**
+ * enum ubi_open_mode - UBI volume open mode constants.
+ *
+ * @UBI_READONLY: read-only mode
+ * @UBI_READWRITE: read-write mode
+ * @UBI_EXCLUSIVE: exclusive mode
+ */
+enum ubi_open_mode {
+	UBI_READONLY = 1,
+	UBI_READWRITE,
+	UBI_EXCLUSIVE
+};
+
+/**
+ * struct ubi_vol_info - UBI volume description data structure.
+ *
+ * @vol_id: volume ID
+ * @ubi_num: UBI device number this volume belongs to
+ * @size: how many physical eraseblocks are reserved for this volume
+ * @used_bytes: how many bytes of data this volume contains
+ * @used_ebs: how many physical eraseblocks of this volume actually contain any
+ * data
+ * @vol_type: volume type (%UBI_DYNAMIC_VOLUME or %UBI_STATIC_VOLUME)
+ * @corrupted: non-zero if the volume is corrupted (static volumes only)
+ * @upd_marker: non-zero if the volume has update marker set
+ * @alignment: volume alignment
+ * @usable_leb_size: how many bytes are available in logical eraseblocks of
+ * this volume
+ * @name_len: volume name length
+ * @name: volume name
+ * @cdev: UBI volume character device major and minor numbers
+ *
+ * The @corrupted flag is only relevant to static volumes and is always zero
+ * for dynamic ones. This is because UBI does not care about dynamic volume
+ * data protection and only cares about protecting static volume data.
+ *
+ * The @upd_marker flag is set if the volume update operation was interrupted.
+ * Before touching the volume data during the update operation, UBI first sets
+ * the update marker flag for this volume. If the volume update operation was
+ * further interrupted, the update marker indicates this. If the update marker
+ * is set, the contents of the volume is certainly damaged and a new volume
+ * update operation has to be started.
+ *
+ * To put it differently, @corrupted and @upd_marker fields have different
+ * semantics:
+ *     o the @corrupted flag means that this static volume is corrupted for some
+ *       reasons, but not because an interrupted volume update
+ *     o the @@upd_marker field means that the volume is damaged because of an
+ *       interrupted update operation.
+ *
+ * I.e., the @corrupted flag is never set if the @upd_marker flag is set.
+ *
+ * The @used_bytes and @used_ebs fields are only really needed for static volumes
+ * and contain the number of bytes stored in this static volume and how many
+ * eraseblock this data occupies. In case of dynamic volumes, the @used_bytes
+ * field is equivalent to @size*@usable_leb_size, and the @used_ebs field is
+ * equivalent to @size.
+ *
+ * In general, logical eraseblock size is a property of the UBI device, not
+ * of the UBI volume. Indeed, the logical eraseblock size depends on the
+ * physical eraseblock size and on how much bytes UBI headers consume. But
+ * because of the volume alignment (@alignment), the usable size of logical
+ * eraseblocks if a volume may be less. The following equation is true:
+ * 	@usable_leb_size = LEB size - (LEB size mod @alignment),
+ * where LEB size is the logical eraseblock size defined by the UBI device.
+ *
+ * The alignment is multiple to the minimal flash input/output unit size or %1
+ * if all the available space is used.
+ *
+ * To put this differently, alignment may be considered is a way to change
+ * volume logical eraseblock sizes.
+ *
+ */
+struct ubi_vol_info {
+	int ubi_num;
+	int vol_id;
+	int size;
+	long long used_bytes;
+	int used_ebs;
+	int vol_type;
+	int corrupted;
+	int upd_marker;
+	int alignment;
+	int usable_leb_size;
+	int name_len;
+	const char *name;
+	dev_t cdev;
+};
+
+/**
+ * struct ubi_dev_info - UBI device description data structure.
+ *
+ * @ubi_num: ubi device number
+ * @leb_size: logical eraseblock size on this UBI device
+ * @min_io_size: minimal I/O unit size
+ * @ro_mode: if this device is in read-only mode
+ * @cdev: UBI character device major and minor numbers
+ *
+ * Note, @leb_size is the logical eraseblock size offered by the UBI device.
+ * Volumes of this UBI device may have smaller logical eraseblock size if their
+ * alignment is not equivalent to %1.
+ */
+struct ubi_dev_info {
+	int ubi_num;
+	int leb_size;
+	int min_io_size;
+	int ro_mode;
+	dev_t cdev;
+};
+
+/**
+ * ubi_get_device_info - get information about an UBI device.
+ *
+ * @ubi_num: UBI device number
+ * @di: the volume information is returned here
+ *
+ * This function returns 0 in case of success and a %-ENODEV if there is no
+ * such UBI device.
+ */
+int ubi_get_device_info(int ubi_num, struct ubi_dev_info *di);
+
+/* UBI descriptor given to users when they open UBI volumes */
+struct ubi_vol_desc;
+
+/**
+ * ubi_get_volume_info - get information about an UBI volume.
+ *
+ * @udesc: volume descriptor
+ * @vi: the volume information is returned here
+ */
+void ubi_get_volume_info(struct ubi_vol_desc *udesc, struct ubi_vol_info *vi);
+
+/*
+ * ubi_open_volume - open an UBI volume.
+ *
+ * @ubi_num: the UBI device number
+ * @vol_id: ID of the volume to open
+ * @mode: volume open mode
+ *
+ * This function opens a UBI volume. The @mode parameter specifies if the
+ * volume is opened in read-only mode, read-write mode, or exclusive mode. The
+ * exclusive mode means that nobody else will be allowed to open this volume.
+ * Note, UBI allows to have many volume readers and one writer at a time. And
+ * note, static volumes may only be opened in read-only mode.
+ *
+ * In case of success, this function returns an UBI volume descriptor. In case
+ * of failure, the following error codes may be returned:
+ *
+ * o %-EBUSY if the volume is busy (it is being updated, or it is already
+ *   opened in exclusive or read-write mode by somebody else);
+ * o %-EINVAL if the input arguments are invalid;
+ * o %-ENODEV if this volume does not exist or the UBI device does not exist;
+ * o other negative error codes in case of other errors.
+ *
+ * Additional node: if the volume is being opened for the first time since the
+ * last boot, it is fully checked by this function. It's a feature of current
+ * implementation.
+ */
+struct ubi_vol_desc *ubi_open_volume(int ubi_num, int vol_id,
+				     enum ubi_open_mode mode);
+
+/*
+ * ubi_open_volume_nm - open an UBI volume by volume name.
+ *
+ * @ubi_num: the UBI device number
+ * @name: volume name
+ * @mode: volume open mode
+ *
+ * This function is similar to the 'ubi_open_volume()' function, but opens UBI
+ * volumes by name.
+ */
+struct ubi_vol_desc *ubi_open_volume_nm(int ubi_num, const char *name,
+					enum ubi_open_mode mode);
+
+/**
+ * ubi_close_volume - close an UBI volume.
+ *
+ * @udesc: UBI volume descriptor
+ */
+void ubi_close_volume(struct ubi_vol_desc *udesc);
+
+/**
+ * ubi_eraseblock_read - read data from a logical eraseblock.
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to read from
+ * @buf: a buffer where to store the read data
+ * @offset: the offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ * @check: whether UBI has to check the read data's CRC or not.
+ *
+ * This function reads data from offset @offset of the logical eraseblock @lnum
+ * and stores the read data at @buf. When reading from static volumes, @check
+ * may be used to specify whether the read data has to be checked or not. If
+ * checking is requested, the whole logical eraseblock will be read and its CRC
+ * checksum will be checked, so checking may substantially slow down the read
+ * speed. The @check argument is ignored in case of dynamic volumes.
+ *
+ * In case of success, this function returns zero. In case of error, this
+ * function returns a negative error code. A special %-EBADMSG error code is
+ * returned:
+ *
+ * o for both static and dynamic volumes if the MTD driver has detected a data
+ * integrity problem, unrecoverable ECC checksum mismatch in case of NAND;
+ * o for static volumes if the data CRC mismatches.
+ *
+ * If a corrupted static volume is read (i.e., the @corrupted flag is set in
+ * its description object), but the data were read from flash without errors
+ * because this particular eraseblock is not corrupted, this function returns
+ * %-EUCLEAN, not zero. This just indicates that the read static volume is
+ * corrupted. But the read data is actually OK.
+ *
+ * Note, if a volume is damaged because of an interrupted update (the
+ * @upd_marker flag is set) this function just returns immediately with %-EBADF
+ * error code. In other words, volumes like that cannot be read before re-doing
+ * the update operation.
+ */
+int ubi_eraseblock_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
+			int offset, int len, int check);
+
+/**
+ * ubi_read - read data from an logical eraseblock (simplified).
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to read from
+ * @buf: a buffer where to store the read data
+ * @offset: the offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ *
+ * This function is the same as the 'ubi_eraseblock_read()' function, but it
+ * does not provide the checking capability.
+ */
+static inline int ubi_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
+			   int offset, int len)
+{
+	return ubi_eraseblock_read(udesc, lnum, buf, offset, len, 0);
+}
+
+/**
+ * ubi_eraseblock_write - write data to a logical eraseblock.
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to write to
+ * @buf: the data to write
+ * @offset: offset within the logical eraseblock where to write
+ * @len: how many bytes from @buf to write
+ * @dtype: expected data type
+ *
+ * This function writes @len bytes of data from buffer @buf to offset @offset
+ * of logical eraseblock @lnum. The @dtype argument describes the expected
+ * lifetime of the data being written.
+ *
+ * Note, this function takes care about write failures. If a write to the physical
+ * eraseblock (the one this logical eraseblock is mapped to) fails, the logical
+ * eraseblock is re-mapped to another physical eraseblock, the data is
+ * recovered, and the write finishes.
+ *
+ * If all the data were successfully written, zero is returned. If an error
+ * occurred, this function returns a negative error code. Note, in case of an
+ * error, it is possible that something was still written to the flash media,
+ * but may be some garbage.
+ */
+int ubi_eraseblock_write(struct ubi_vol_desc *udesc, int lnum, const void *buf,
+			 int offset, int len, enum ubi_data_type dtype);
+
+/**
+ * ubi_write - write data to a logical eraseblock (simplified).
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to write to
+ * @buf: the data to write
+ * @offset: offset within the logical eraseblock where to write
+ * @len: how many bytes from @buf to write
+ *
+ * This function is the same as the 'ubi_eraseblock_write()' functions, but it
+ * does not have the data type argument.
+ */
+static inline int ubi_write(struct ubi_vol_desc *udesc, int lnum,
+			    const void *buf, int offset, int len)
+{
+	return ubi_eraseblock_write(udesc, lnum, buf, offset, len,
+				    UBI_DATA_UNKNOWN);
+}
+
+/**
+ * ubi_eraseblock_erase - erase a logical eraseblock.
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to erase
+ *
+ * This function un-maps logical eraseblock @lnum and synchronously erases the
+ * correspondent physical eraseblock. Returns zero in case of success and a
+ * negative error code in case of failure.
+ *
+ *
+ * Note, UBI erases eraseblocks asynchronously. This means that this function
+ * will basically un-map this logical eraseblock from its physical eraseblock,
+ * schedule the physical eraseblock for erasure and return.
+ */
+int ubi_eraseblock_erase(struct ubi_vol_desc *udesc, int lnum);
+
+/**
+ * ubi_eraseblock_unmap - unmap a logical eraseblock.
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to unmap
+ *
+ * This function un-maps logical eraseblock @lnum and schedules the
+ * corresponding physical eraseblock for erasure, so that it will eventually be
+ * physically erased, probably in background. So this operation is much faster
+ * then the synchronous erase.
+ *
+ * Unlike the synchronous erase, the unmap operation does not guarantee that
+ * the logical eraseblock will contain all 0xFF bytes when UBI is initialized
+ * again. For example, if several logical eraseblocks are unmapped, then an
+ * unclean reboot happens, the logical eraseblocks will not necessarily be
+ * unmapped again. They may actually be mapped to the same physical eraseblocks
+ * again. So, this call has to be used with care.
+ *
+ * The main and obvious use-case of this call is re-writing the contents of a
+ * logical eraseblock. Then it is much efficient to first unmap it, then write
+ * new data, rather the first erase it, then write new data. Note, once new
+ * data is written to the logical eraseblock, UBI guarantees that the old
+ * contents has forever gone. In other words, if an unclean reboot happens
+ * after the logical eraseblock was unmapped and then written to, it will
+ * contain the last written data.
+ */
+int ubi_eraseblock_unmap(struct ubi_vol_desc *udesc, int lnum);
+
+/**
+ * ubi_eraseblock_is_mapped - check if a logical eraseblock is mapped.
+ *
+ * @udesc: volume descriptor
+ * @lnum: the logical eraseblock number to erase
+ *
+ * This function checks if a logical eraseblock is mapped to a physical
+ * eraseblock. Unmapped logical eraseblocks are equivalent to erased logical
+ * eraseblocks and contain only 0xFF bytes. Mapped logical eraseblocks are
+ * those that were explicitly written to. They may also contain only 0xFF
+ * bytes if these were written.
+ *
+ * This function returns %1 if the LEB is mapped, %0 if not, and a negative
+ * error code in case of failure.
+ */
+int ubi_eraseblock_is_mapped(struct ubi_vol_desc *udesc, int lnum);
+
+#endif /* !__LINUX_UBI_H__ */
