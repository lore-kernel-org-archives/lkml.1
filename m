Return-Path: <linux-kernel-owner+w=401wt.eu-S2992858AbXBQRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992858AbXBQRkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992965AbXBQRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:40:55 -0500
Received: from smtp.nokia.com ([131.228.20.171]:62227 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992858AbXBQRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:40:54 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:30 +0200
Message-Id: <20070217165630.5845.70279.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 25/44 take 2] [UBI] EBA unit header
X-OriginalArrivalTime: 17 Feb 2007 16:56:30.0107 (UTC) FILETIME=[920A06B0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185428-3C65FBB0-3BA0588D/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/eba.h tmp-to/drivers/mtd/ubi/eba.h
--- tmp-from/drivers/mtd/ubi/eba.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/eba.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,362 @@
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
+/*
+ * The UBI Eraseblock Association (EBA) unit.
+ *
+ * The main goal of this unit is to maintain the Eraseblock Association Table
+ * (EBA table). The EBA table is a data structure which maps (volume ID,
+ * logical eraseblock number) pairs to physical eraseblock numbers.
+ *
+ * Note, it is supposed that all the UBI input/output goes via the EBA unit.
+ * The only reservation should be made for the initialization time when
+ * different units may directly do input/output from physical eraseblocks.
+ *
+ * Although in this implementation the EBA table is fully kept and managed in
+ * RAM, which assumes poor UBI scalability, it might be (partially) maintained
+ * on flash in future implementations.
+ */
+
+#ifndef __UBI_EBA_H__
+#define __UBI_EBA_H__
+
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+#include <linux/rbtree.h>
+#include <linux/mtd/ubi.h>
+
+struct ubi_info;
+struct ubi_scan_info;
+
+/**
+ * ubi_eba_mkvol - create EBA mapping for a new volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the new volume
+ * @leb_count: how many eraseblocks are reserved for this volume
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_mkvol(const struct ubi_info *ubi, int vol_id, int leb_count);
+
+/**
+ * ubi_eba_rmvol - remove EBA mapping for a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to be removed
+ *
+ * This function removes a volume from the EBA table. This function un-maps all
+ * the logical eraseblocks and the corresponding physical eraseblocks will be
+ * scheduled for erasure. This function returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_eba_rmvol(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_eba_rsvol - re-size EBA mapping for a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to be re-sized
+ * @reserved_pebs: new count of physical eraseblocks in this volume
+ *
+ * This function changes the EBA table accordingly to the volume re-size
+ * operation. If the volume is actually shrunken, the dropped logical
+ * eraseblocks are got unmapped an thus, the corresponding physical eraseblocks
+ * are scheduled for erasure. This function returns zero in case of success and
+ * a negative error code in case of failure.
+ */
+int ubi_eba_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs);
+
+/**
+ * ubi_eba_erase_leb - erase a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock number to erase
+ *
+ * This function un-maps the logical eraseblock and schedules the physical
+ * eraseblock for erasure.
+ *
+ * Note, the physical eraseblock is just scheduled for erasure, not actually
+ * erased by this function. So there is no guarantee that after an unclean
+ * reboot (or even a regular UBI shut down) this logical eraseblock stays
+ * un-mapped. It may become mapped to the same physical eraseblock again if it
+ * had not been erased by the time the unclean reboot happened.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_erase_leb(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_read_leb - read data from a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID from where to read
+ * @lnum: the logical eraseblock number to read from
+ * @buf: the buffer to store the read data
+ * @offset: the offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ * @check: data CRC check flag
+ *
+ * If the logical eraseblock @lnum is unmapped, @buf is filled by 0xFF bytes.
+ * The @check flag only makes sense for static volumes and forces eraseblock
+ * data CRC checking.
+ *
+ * In case of success this function returns zero. If the @check flag is set,
+ * @vol_id is a static volume, and the data CRC mismatches - %-EBADMSG is
+ * returned. %-EBADMSG may also be returned for any volume type if an ECC error
+ * was detected by the MTD device driver.
+ *
+ * Other negative error cored may be returned in case of other errors.
+ */
+int ubi_eba_read_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		     void *buf, int offset, int len, int check);
+
+/**
+ * ubi_eba_write_leb - write data to a logical eraseblock of a dynamic volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID where to write
+ * @lnum: the logical eraseblock number to write
+ * @buf: the data to write
+ * @offset: the offset within the logical eraseblock where to write
+ * @len: how many bytes to write
+ * @dtype: data type
+ *
+ * This function writes data to a logical eraseblock of a dynamic volume.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
+ *
+ * Note, in case of an error, it is possible that something was still written
+ * to the flash media, but may be some garbage.
+ */
+int ubi_eba_write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
+		      const void *buf, int offset, int len,
+		      enum ubi_data_type dtype);
+
+/**
+ * ubi_eba_write_leb_st - write data to a logical eraseblock of a static volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID where to write
+ * @lnum: the logical eraseblock number to write
+ * @buf: the data to write
+ * @len: how many bytes to write
+ * @dtype: data type
+ * @used_ebs: how many logical eraseblocks will this volume contain (used only
+ * for static volumes)
+ *
+ * This function writes data to a logical eraseblock of a static volume. The
+ * @used_ebs argument should contain total number of logical eraseblock which
+ * will contain any data in this static volume.
+ *
+ * When writing to the last logical eraseblock of a static volume, the @len
+ * argument doesn't have to be aligned to the minimal I/O unit size. Instead,
+ * it has to be equivalent to the real data size, although the @buf buffer has
+ * to contain the alignment. In all other cases, @len has to be aligned.
+ *
+ * Note, it is prohibited to write more then once to logical eraseblocks of
+ * static volumes.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_write_leb_st(const struct ubi_info *ubi, int vol_id, int lnum,
+			 const void *buf, int len, enum ubi_data_type dtype,
+			 int used_ebs);
+
+/**
+ * ubi_eba_leb_is_mapped - check if a logical eraseblock is mapped.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to check
+ *
+ * This function checks if a logical eraseblock is mapped to a physical
+ * eraseblock. Returns %1 if it is mapped, %0 if not, and a negative error
+ * code in case of failure.
+ */
+int ubi_eba_leb_is_mapped(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_leb_read_lock - lock a logical eraseblock for reading.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to lock
+ *
+ * This function locks a logical eraseblock for reading which means that all
+ * writers will be locked waiting while the logical eraseblock is stopped being
+ * used.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_leb_read_lock(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_leb_write_lock - lock a logical eraseblock for writing.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to lock
+ *
+ * This function locks a logical eraseblock for writing which means that all
+ * further readers and writers will be locked waiting while the logical
+ * eraseblock is stopped being used.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_leb_write_lock(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_leb_read_unlock - unlock a logical eraseblock locked for reading.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to unlock
+ */
+void ubi_eba_leb_read_unlock(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_leb_write_unlock - unlock a logical eraseblock locked for writing.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to unlock
+ */
+void ubi_eba_leb_write_unlock(const struct ubi_info *ubi, int vol_id, int lnum);
+
+/**
+ * ubi_eba_leb_remap - re-map a logical eraseblock to another physical
+ * eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number
+ * @pnum: new physical eraseblock to map to
+ *
+ * The logical eraseblock must be locked before re-mapping.
+ */
+void ubi_eba_leb_remap(const struct ubi_info *ubi, int vol_id, int lnum,
+		       int pnum);
+
+/**
+ * ubi_eba_ro_mode - switch to read-only mode.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_eba_ro_mode(const struct ubi_info *ubi);
+
+/**
+ * ubi_eba_init_scan - initialize the EBA unit using scanning information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_eba_close - close the EBA unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_eba_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_eba_tbl_rec - a record in the eraseblock association table.
+ *
+ * @pnum: physical eraseblock number
+ * @leb_ver: logical eraseblock version
+ *
+ * This structure represents a record in the eraseblock association table.
+ */
+struct ubi_eba_tbl_rec {
+	int pnum;
+	uint32_t leb_ver;
+};
+
+/**
+ * struct ubi_eba_tbl_volume - a volume in the the eraseblock association
+ * table.
+ *
+ * @recs: an array of per-logical eraseblock records (for each logical
+ * eraseblock of this volume)
+ * @leb_count: how many logical eraseblock this volume has
+ */
+struct ubi_eba_tbl_volume {
+	struct ubi_eba_tbl_rec *recs;
+	int leb_count;
+};
+
+/**
+ * struct ubi_eba_ltree_entry - an entry in the lock tree.
+ *
+ * @rb: link in the RB-tree
+ * @vol_id: volume ID of the locked logical eraseblock
+ * @lnum: the locked logical eraseblock number
+ * @users: how many tasks are using this logical eraseblock or wait for it
+ * @mutex: a read/write mutex to implement read/write access serialization to
+ * the (@vol_id, @lnum) logical eraseblock
+ *
+ * This data structured is used to lock a logical eraseblock - a corresponding
+ * &struct ubi_eba_ltree_entry is created and inserted to the lock tree
+ * (@eba->ltree).
+ */
+struct ubi_eba_ltree_entry {
+	struct rb_node rb;
+	int vol_id;
+	int lnum;
+	int users;
+	struct rw_semaphore mutex;
+};
+
+/**
+ * struct ubi_eba_info - UBI EBA unit description data structure.
+ *
+ * @eba_tbl: the eraseblock association table
+ * @eba_tbl_lock: protects the EBA table
+ * @ltree: the lock tree
+ * @ltree_lock: protects the lock tree
+ * @num_volumes: number of volumes mapped by the EBA table
+ *
+ * The EBA unit implements per-logical eraseblock locking. Before accessing a
+ * logical eraseblock it is locked for reading or writing. The per-logical
+ * eraseblock locking is implemented by means of the lock tree.
+ *
+ * The lock tree is an RB-tree which refers all the currently locked logical
+ * eraseblocks. The lock tree elements are &struct ubi_eba_ltree_entry objects.
+ * They are indexed by (@vol_id,@lnum) pairs.
+ */
+struct ubi_eba_info {
+	struct ubi_eba_tbl_volume *eba_tbl; /* private */
+	spinlock_t eba_tbl_lock;            /* private */
+	struct rb_root ltree;               /* private */
+	spinlock_t ltree_lock;              /* private */
+	int num_volumes;                    /* private */
+};
+
+#endif /* !__UBI_EBA_H__ */
