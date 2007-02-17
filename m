Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXBQQ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXBQQ5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXBQQ4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:56:50 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52473 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965346AbXBQQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:44 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:00 +0200
Message-Id: <20070217165600.5845.37863.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/44 take 2] [UBI] volume table unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:59.0749 (UTC) FILETIME=[7FF1C350:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185246-63ECBBB0-4593BCBD/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/vtbl.h tmp-to/drivers/mtd/ubi/vtbl.h
--- tmp-from/drivers/mtd/ubi/vtbl.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/vtbl.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,302 @@
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
+ */
+
+/*
+ * The volume table unit.
+ *
+ * This unit is responsible for maintaining the volume table. The volume table
+ * is an on-flash table containing volume meta-data like volume name, number of
+ * reserved physical eraseblocks for this volume, volume type, etc. The volume
+ * table is stored in the so-called "layout volume".
+ *
+ * The layout volume is an internal volume where the volume table is stored.
+ * Actually, there are 2 equivalent copies of the volume table in the layout
+ * volume. The layout volume it organized as follows. It consists of two
+ * logical eraseblocks - LEB 0 and LEB 1. Each logical eraseblock stores a copy
+ * the volume table, i.e. LEB 0 and LEB 1 duplicate each other. This redundancy
+ * guarantees robustness and tolerance to unclean reboots. The volume table is
+ * a mere array of so-called "volume table records". Each record contains full
+ * information about the volume and is protected by a CRC checksum.
+ *
+ * The volume table is changed as follows. It is first changed in RAM. Then LEB
+ * 0 is erased, and the updated volume table is written back to LEB 0. The same
+ * is done with LEB 1. This scheme guarantees recoverability from unclean
+ * reboots.
+ *
+ * At this UBI implementation the on-flash volume table does not contain about
+ * how many data a static volume actually stores. This information may be found
+ * out while scanning (from the EB headers) so we do not store it in the
+ * on-flash volume table. So, as long as we have an unscalable UBI
+ * implementation which uses scanning, we may live without that. In case of a
+ * scalable implementation, this would be required.
+ *
+ * But it would be beneficial to store this information in the volume table.
+ * For example, suppose we have a static volume X, and all its physical
+ * eraseblocks have gone bad for some reasons. Suppose we are attaching the
+ * corresponding MTD device, the scanning unit finds no logical eraseblocks
+ * corresponding to the volume X. According to the volume table volume X does
+ * exist. So we don't know whether it is just empty or all its physical
+ * eraseblocks went bad. So we cannot alarm the user about this corruption.
+ *
+ * Note, although we don't store this information in the on-flash volume table,
+ * we keep it in the in-RAM copy of this table just because it is quite
+ * convenient.
+ *
+ * The volume table also stores so-called "update marker" which is used to
+ * implement the update operation. Before updating the volume, the update
+ * marker is set, after the update operation is finished, the update marker is
+ * cleared. So if the update operation was interrupted (e.g. by an unclean
+ * reboot) - the update marker is still there and we know that the volume's
+ * contents is damaged.
+ *
+ * Note, in this implementation we do not support concurrent updates and only
+ * one volume at a time may be updated.
+ */
+
+#ifndef __UBI_VTBL_H__
+#define __UBI_VTBL_H__
+
+#include <linux/mutex.h>
+#include <mtd/ubi-header.h>
+
+struct ubi_info;
+struct ubi_scan_info;
+struct ubi_vtbl_vtr;
+
+/**
+ * ubi_vtbl_mkvol - create volume table record for a new volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the new volume
+ * @vtr: volume table record of the new volume
+ *
+ * This function adds a volume described in @vtr to the volume table. This
+ * function uses only @vtr->reserved_pebs, @vtr->alignment, @vtr->data_pad,
+ * @vtr->vol_type, and @vtr->name_len fields of the @vtr object. The
+ * @vtr->usable_leb_size is calculated automatically. The data-related fields
+ * are set to zero for static volumes ant to volume size for dynamic ones.
+ *
+ * This function returns zero in case of success and a negative error code in
+ */
+int ubi_vtbl_mkvol(const struct ubi_info *ubi, int vol_id,
+		   const struct ubi_vtbl_vtr *vtr);
+
+/**
+ * ubi_vtbl_rmvol - clear the volume table record of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to remove
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_vtbl_rmvol(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vtbl_rsvol - change volume size in the volume table record.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: re-sized volume's ID
+ * @reserved_pebs: new size, i.e. new number of reserved eraseblocks.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_vtbl_rsvol(const struct ubi_info *ubi, int vol_id, int reserved_pebs);
+
+/**
+ * ubi_vtbl_set_upd_marker - set the update marker flag.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume
+ *
+ * This function sets the update marker flag for volumr @vol_id. Returns zero
+ * in case of success and a negative error code in case of failure.
+ */
+int ubi_vtbl_set_upd_marker(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vtbl_clear_upd_marker - clear the update marker flag.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume
+ * @bytes: new data size in bytes
+ *
+ * This function clears the update marker for volume @vol_id, sets new volume
+ * data size and cleans the "corrupted" flag (static volume s only). This
+ * function returns zero in case of success and a negative error code in case
+ * of failure.
+ */
+int ubi_vtbl_clear_upd_marker(const struct ubi_info *ubi, int vol_id,
+			      long long bytes);
+
+/**
+ * ubi_vtbl_set_corrupted - mark a volume as 'corrupted'.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to mark
+ *
+ * This function marks volume @vol_id as corrupted. If the volume is not static
+ * it does nothing. Returns zero in case of success and a negative error code
+ * in case of failure.
+ */
+int ubi_vtbl_set_corrupted(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_vtbl_get_vtr - retrieve a volume table record.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the requested volume ID
+ *
+ * This function returns a pointer to the volume record or an error code.
+ * If the volume ID is incorrect, %-EINVAL is returned, if the volume does
+ * not exist, %-ENODEV is returned.
+ *
+ * This function does not access the flash media as retrieves the information
+ * from the in-RAM volume table copy. So it does not sleep.
+ */
+const struct ubi_vtbl_vtr *ubi_vtbl_get_vtr(const struct ubi_info *ubi,
+					    int vol_id);
+
+/**
+ * ubi_vtbl_get_compat - get compatibility flags of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ *
+ * This function returns compatibility flags of volumes. User volumes have no
+ * compatibility flags, so %0 is returned. The @vol_id must be correct.
+ */
+int ubi_vtbl_get_compat(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_is_ivol - check if a volume is an internal volume.
+ *
+ * @vol_id: ID of the volume to test
+ *
+ * If the volume is internal volume, %1 is returned, otherwise %0 is returned.
+ */
+static inline int ubi_is_ivol(int vol_id)
+{
+	return vol_id >= UBI_INTERNAL_VOL_START &&
+	       vol_id < UBI_INTERNAL_VOL_START + UBI_INT_VOL_COUNT;
+}
+
+/*
+ * ubi_ivol_is_known - check if this is a known internal volume.
+ *
+ * @vol_id: ID of the volume to check.
+ *
+ * This function returns non-zero if this is a known and supported internal
+ * volume and non-zero if not.
+ */
+static inline int ubi_ivol_is_known(int vol_id)
+{
+	return vol_id == UBI_LAYOUT_VOL_ID;
+}
+
+/**
+ * ubi_vtbl_init_scan - initialize the volume table unit using scanning
+ * information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_vtbl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_vtbl_close - close the volume table unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_vtbl_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_vtbl_vtr - in-memory representation of volume table records.
+ *
+ * @reserved_pebs: how many physical eraseblocks are reserved for this volume
+ * @alignment: volume alignment
+ * @data_pad: how many bytes are not used at the end of eraseblocks to
+ * satisfy the requested alignment
+ * @vol_type: volume type (%UBI_DYNAMIC_VOLUME or %UBI_STATIC_VOLUME)
+ * @name_len: volume name length
+ * @name: volume name
+ * @usable_leb_size: logical eraseblock size without padding
+ * @used_ebs: how many logical eraseblocks in this volume are contain data
+ * @last_eb_bytes: how many bytes are stored in the last logical eraseblock
+ * @used_bytes: how many bytes of data this volume contains
+ * @corrupted: non-zero if the data is corrupted (static volumes only)
+ * @upd_marker: non-zero if the update marker is set for this volume
+ *
+ * Note, the @usable_leb_size field is not stored on flash, as it is easily
+ * calculated with help of the @data_pad field. But it is just very handy, so
+ * we keep it in the in-RAM volume table record representation.
+ *
+ * Similar to the @used_ebs, @last_eb_bytes, @used_bytes and @corrupted. We do
+ * not store them in the on-flash volume table but keep handy in RAM.
+ *
+ * The @corrupted field indicates that the volume's contents is corrupted. And
+ * since UBI protects only the contents of static volumes, this field is only
+ * relevant to static volumes. In case of dynamic volumes it is user's
+ * responsibility to assure data integrity.
+ *
+ * The @upd_marker flag indicates that this volume is either being updated at
+ * the moment or is damaged because of an unclean reboot. Note, the @corrupted
+ * flag is always cleared if the @upd_marker flag is set.
+ */
+struct ubi_vtbl_vtr {
+	int reserved_pebs;
+	int alignment;
+	int data_pad;
+	int vol_type;
+	int name_len;
+	int usable_leb_size;
+	const char *name;
+	int used_ebs;
+	int last_eb_bytes;
+	long long used_bytes;
+	int corrupted;
+	int upd_marker;
+};
+
+/**
+ * struct ubi_vtbl_info - volume table unit description data structure.
+ *
+ * @vt_slots: how many volume table records are stored in the volume table
+ * @vt_size: size of the volume table in bytes
+ * @vt: the in-RAM copy of the volume table
+ * @mutex: serializes volume table changes
+ * @empty_rec: volume table record corresponding to an empty volume
+ * @ivol_vtrs: volume table records corresponding to internal volumes
+ */
+struct ubi_vtbl_info {
+	int vt_slots;                                     /* public  */
+	int vt_size;                                      /* private */
+	struct ubi_vtbl_vtr *vt;                          /* private */
+	struct mutex mutex;                               /* private */
+	const struct ubi_vol_tbl_record empty_rec;        /* private */
+	struct ubi_vtbl_vtr ivol_vtrs[UBI_INT_VOL_COUNT]; /* private */
+};
+
+#endif /* __UBI_VTBL_H__ */
