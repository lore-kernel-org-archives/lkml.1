Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXCNPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXCNPVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXCNPVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:42 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23382 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667AbXCNPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:50 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:24 +0200
Message-Id: <20070314152024.1112.15655.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/22 take 3] UBI: EBA unit
X-OriginalArrivalTime: 14 Mar 2007 15:20:24.0662 (UTC) FILETIME=[49E4AF60:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/eba.c tmp-to/drivers/mtd/ubi/eba.c
--- tmp-from/drivers/mtd/ubi/eba.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/eba.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,1735 @@
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
+ * This unit maintains the Eraseblock Association Table (EBA table). The EBA
+ * table is a data structure which maps (volume ID, logical eraseblock number)
+ * pairs to physical eraseblock numbers.
+ *
+ * All the UBI input/output goes via the EBA unit. The only reservation is made
+ * for the initialization time when different units may directly do
+ * input/output from physical eraseblocks.
+ *
+ * Although in this implementation the EBA table is fully kept and managed in
+ * RAM, which assumes poor UBI scalability, it might be (partially) maintained
+ * on flash in future implementations.
+ *
+ * The EBA unit implements per-logical eraseblock locking. Before accessing a
+ * logical eraseblock it is locked for reading or writing. The per-logical
+ * eraseblock locking is implemented by means of a lock tree. The lock tree is
+ * an RB-tree which refers all the currently locked logical eraseblocks. The
+ * lock tree elements are &struct ubi_eba_ltree_entry objects. They are indexed
+ * by (@vol_id, @lnum) pairs.
+ *
+ * EBA also maintains the global sequence counter which is incremented each
+ * time a logical eraseblock is mapped to a physical eraseblock and it is
+ * stored in the volume identifier header. This means that each VID header has
+ * a unique sequence number. The sequence number is only increased an we assume
+ * 64 bits is enough to never overflow.
+ */
+
+#include <linux/slab.h>
+#include <linux/crc32.h>
+#include <linux/err.h>
+#include "ubi.h"
+
+/**
+ * struct ubi_eba_tbl_rec - a record in the eraseblock association table.
+ *
+ * @pnum: physical eraseblock number
+ * @leb_ver: LEB version (obsolete)
+ *
+ * This structure represents a record in the eraseblock association table.
+ */
+struct ubi_eba_tbl_rec {
+	int pnum;
+	uint32_t leb_ver; /* FIXME: obsolete, to be removed */
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
+ * @rb: links RB-tree nodes
+ * @vol_id: volume ID of the locked logical eraseblock
+ * @lnum: locked logical eraseblock number
+ * @users: how many tasks are using this logical eraseblock or wait for it
+ * @mutex: a read/write mutex to implement read/write access serialization to
+ * the (@vol_id, @lnum) logical eraseblock
+ *
+ * When a logical eraseblock is being locked - corresponding &struct
+ * ubi_eba_ltree_entry object is inserted to the lock tree (@eba->ltree).
+ */
+struct ubi_eba_ltree_entry {
+	struct rb_node rb;
+	int vol_id;
+	int lnum;
+	int users;
+	struct rw_semaphore mutex;
+};
+
+/*
+ * The top-most bit in logical-to-physical eraseblock mappings is used to
+ * indicate that the logical eraseblock is not mapped.
+ */
+#define NOT_MAPPED 0x80000000
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_EBA
+static int paranoid_check_leb(const struct ubi_info *ubi, int pnum, int vol_id,
+			      int lnum, const struct ubi_vid_hdr *vid_hdr);
+static int paranoid_check_leb_locked(struct ubi_info *ubi, int vol_id,
+				     int lnum);
+#else
+#define paranoid_check_leb(ubi, vol_id, pnum, lnum, vid_hdr) 0
+#define paranoid_check_leb_locked(ubi, vol_id, lnum)
+#endif
+
+/* Slab cache for lock-tree entries */
+static struct kmem_cache *eba_ltree_entry_slab;
+
+/**
+ * vol_id2idx - turn volume ID to the EBA table index.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ */
+static inline int vol_id2idx(const struct ubi_info *ubi, int vol_id)
+{
+	if (vol_id >= UBI_INTERNAL_VOL_START)
+		return vol_id - UBI_INTERNAL_VOL_START + ubi->vtbl.vt_slots;
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
+	if (idx >= ubi->vtbl.vt_slots)
+		return idx - ubi->vtbl.vt_slots + UBI_INTERNAL_VOL_START;
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
+ * The logical eraseblock has to be locked. Note, all this leb_ver stuff is
+ * obsolete and will be removed eventually. FIXME: to be removed together with
+ * leb_ver support.
+ */
+static inline int leb_get_ver(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx, leb_ver;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs);
+	leb_ver = ubi->eba.eba_tbl[idx].recs[lnum].leb_ver;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	return leb_ver;
+}
+
+/**
+ * next_sqnum - get next sequence number.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns next sequence number to use, which is just the current
+ * global sequence counter value. It also increases the global sequence
+ * counter.
+ */
+static unsigned long long next_sqnum(struct ubi_info *ubi)
+{
+	unsigned long long sqnum;
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	sqnum = ubi->eba.global_sq_cnt++;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	return sqnum;
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
+static inline void leb_map(struct ubi_info *ubi, int vol_id, int lnum, int pnum)
+{
+	int idx;
+
+	idx = vol_id2idx(ubi, vol_id);
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs[lnum].pnum < 0);
+	ubi->eba.eba_tbl[idx].recs[lnum].pnum = pnum;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+}
+
+/**
+ * leb_unmap - un-map a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number to unmap
+ *
+ * This function un-maps a logical eraseblock and increases its version. The
+ * logical eraseblock has to be locked.
+ */
+static inline void leb_unmap(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs[lnum].pnum >= 0);
+	ubi->eba.eba_tbl[idx].recs[lnum].pnum |= NOT_MAPPED;
+	ubi->eba.eba_tbl[idx].recs[lnum].leb_ver += 1;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+}
+
+/**
+ * leb2peb - get physical eraseblock number by logical eraseblock number.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID
+ * @lnum: the logical eraseblock number
+ *
+ * If the logical eraseblock is mapped, this function returns a positive
+ * physical eraseblock number. If it is not mapped, this function returns
+ * a negative number.
+ */
+static inline int leb2peb(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int idx, pnum;
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(ubi->eba.eba_tbl[idx].recs);
+	pnum = ubi->eba.eba_tbl[idx].recs[lnum].pnum;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	return pnum;
+}
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
+int ubi_eba_mkvol(struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int i, idx, sz;
+	struct ubi_eba_tbl_rec *new_ebs;
+	struct ubi_eba_tbl_volume *eba_tbl = ubi->eba.eba_tbl;
+
+	dbg_eba("create volume %d, size %d", vol_id, reserved_pebs);
+
+	ubi_assert(vol_id >= 0);
+	ubi_assert(reserved_pebs > 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->vtbl.vt_slots);
+
+	if (ubi->io.ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	sz = reserved_pebs * sizeof(struct ubi_eba_tbl_rec);
+	new_ebs = kmalloc(sz, GFP_KERNEL);
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
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(!eba_tbl[idx].recs);
+	eba_tbl[idx].recs = new_ebs;
+	eba_tbl[idx].leb_count = reserved_pebs;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	return 0;
+}
+
+/**
+ * ubi_eba_rmvol - remove EBA mapping of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to be removed
+ *
+ * This function removes a volume from the EBA table. It un-maps all the
+ * logical eraseblocks and the corresponding physical eraseblocks are scheduled
+ * for erasure. Returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_rmvol(struct ubi_info *ubi, int vol_id)
+{
+	int err = 0, i, idx, to_put;
+	struct ubi_eba_tbl_rec *rm_ebs;
+	struct ubi_eba_tbl_volume *eba_tbl = ubi->eba.eba_tbl;
+
+	dbg_eba("remove volume %d", vol_id);
+
+	ubi_assert(vol_id >= 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->vtbl.vt_slots);
+
+	if (ubi->io.ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	idx = vol_id2idx(ubi, vol_id);
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	ubi_assert(eba_tbl[idx].recs);
+	to_put = eba_tbl[idx].leb_count;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	for (i = 0; i < to_put; i++) {
+		err = ubi_eba_unmap_leb(ubi, vol_id, i);
+		if (err)
+			break;
+	}
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	rm_ebs = eba_tbl[idx].recs;
+	eba_tbl[idx].recs = NULL;
+	eba_tbl[idx].leb_count = 0;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	kfree(rm_ebs);
+	return err;
+}
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
+int ubi_eba_rsvol(struct ubi_info *ubi, int vol_id, int reserved_pebs)
+{
+	int err = 0, i, idx, min, to_put, sz;
+	struct ubi_eba_tbl_rec *new_ebs, *old_ebs;
+	struct ubi_eba_tbl_volume *eba_tbl = ubi->eba.eba_tbl;
+
+	dbg_eba("re-size volume %d to %d PEBs", vol_id, reserved_pebs);
+
+	ubi_assert(vol_id >= 0);
+	ubi_assert(!ubi_is_ivol(vol_id));
+	ubi_assert(vol_id < ubi->vtbl.vt_slots);
+	ubi_assert(reserved_pebs > 0);
+
+	if (ubi->io.ro_mode) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	sz = reserved_pebs * sizeof(struct ubi_eba_tbl_rec);
+	new_ebs = kmalloc(sz, GFP_KERNEL);
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
+	spin_lock(&ubi->eba.eba_tbl_lock);
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
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	for (i = 0; i < to_put; i++) {
+		err = ubi_eba_unmap_leb(ubi, vol_id, i);
+		if (err)
+			break;
+	}
+
+	spin_lock(&ubi->eba.eba_tbl_lock);
+	old_ebs = eba_tbl[idx].recs;
+	eba_tbl[idx].recs = new_ebs;
+	eba_tbl[idx].leb_count = reserved_pebs;
+	spin_unlock(&ubi->eba.eba_tbl_lock);
+
+	kfree(old_ebs);
+	return err;
+}
+
+/**
+ * ltree_lookup - look up the lock tree.
+ *
+ * @eba: the EBA unit description data structure
+ * @vol_id: volume ID of the logical eraseblock to look up
+ * @lnum: the logical eraseblock to look up
+ *
+ * This function returns a pointer to the corresponding
+ * &struct ubi_eba_ltree_entry object if the logical eraseblock is locked and
+ * %NULL if it is not. The @ubi->eba.ltree_lock has to be locked.
+ */
+static struct ubi_eba_ltree_entry *ltree_lookup(struct ubi_info *ubi,
+						int vol_id, int lnum)
+{
+	struct rb_node *p;
+
+	p = ubi->eba.ltree.rb_node;
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
+/**
+ * ltree_add_entry - add new entry to the lock tree.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID of the logical eraseblock
+ * @lnum: logical eraseblock number
+ *
+ * This function adds new entry for logical eraseblock (@vol_id, @lnum) to the
+ * lock tree. If such entry is already there, its usage counter is increased.
+ * Returns a pointer to the lock tree entry or %-ENOMEM if memory allocation
+ * failed.
+ */
+static struct ubi_eba_ltree_entry *ltree_add_entry(struct ubi_info *ubi,
+						   int vol_id, int lnum)
+{
+	struct ubi_eba_ltree_entry *le, *le1, *le_free;
+
+	le = kmem_cache_alloc(eba_ltree_entry_slab, GFP_KERNEL);
+	if (unlikely(!le))
+		return ERR_PTR(-ENOMEM);
+
+	le->vol_id = vol_id;
+	le->lnum = lnum;
+
+	spin_lock(&ubi->eba.ltree_lock);
+	le1 = ltree_lookup(ubi, vol_id, lnum);
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
+		 * @ubi->eba.ltree RB-tree.
+		 */
+		le_free = NULL;
+
+		p = &ubi->eba.ltree.rb_node;
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
+		rb_insert_color(&le->rb, &ubi->eba.ltree);
+	}
+	le->users += 1;
+	spin_unlock(&ubi->eba.ltree_lock);
+
+	if (le_free)
+		kmem_cache_free(eba_ltree_entry_slab, le_free);
+
+	return le;
+}
+
+/**
+ * leb_read_lock - lock logical eraseblock for reading.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to lock
+ *
+ * This function locks a logical eraseblock for reading. Returns zero in case
+ * of success and a negative error code in case of failure.
+ */
+static int leb_read_lock(struct ubi_info *ubi, int vol_id, int lnum)
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
+/**
+ * leb_read_unlock - unlock logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to unlock
+ */
+static void leb_read_unlock(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int free = 0;
+	struct ubi_eba_ltree_entry *le;
+
+	spin_lock(&ubi->eba.ltree_lock);
+	le = ltree_lookup(ubi, vol_id, lnum);
+	le->users -= 1;
+	ubi_assert(le->users >= 0);
+	if (le->users == 0) {
+		rb_erase(&le->rb, &ubi->eba.ltree);
+		free = 1;
+	}
+	spin_unlock(&ubi->eba.ltree_lock);
+
+	up_read(&le->mutex);
+	if (free)
+		kmem_cache_free(eba_ltree_entry_slab, le);
+}
+
+/**
+ * leb_write_lock - lock logical eraseblock for writing.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to lock
+ *
+ * This function locks a logical eraseblock for writing. Returns zero in case
+ * of success and a negative error code in case of failure.
+ */
+static int leb_write_lock(struct ubi_info *ubi, int vol_id, int lnum)
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
+/**
+ * leb_write_unlock - unlock logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to unlock
+ */
+static void leb_write_unlock(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int free;
+	struct ubi_eba_ltree_entry *le;
+
+	spin_lock(&ubi->eba.ltree_lock);
+	le = ltree_lookup(ubi, vol_id, lnum);
+	le->users -= 1;
+	ubi_assert(le->users >= 0);
+	if (le->users == 0) {
+		rb_erase(&le->rb, &ubi->eba.ltree);
+		free = 1;
+	} else
+		free = 0;
+	spin_unlock(&ubi->eba.ltree_lock);
+
+	up_write(&le->mutex);
+	if (free)
+		kmem_cache_free(eba_ltree_entry_slab, le);
+}
+
+/**
+ * ubi_eba_unmap_leb - un-map a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to erase
+ *
+ * This function un-maps the logical eraseblock and schedules corresponding
+ * physical eraseblock for erasure. Returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_eba_unmap_leb(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	int err, pnum;
+
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->vtbl.vt_slots || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].recs);
+	ubi_assert(lnum < ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	cond_resched();
+
+	if (unlikely(ubi->io.ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = leb_write_lock(ubi, vol_id, lnum);
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
+	leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+/**
+ * ubi_eba_read_leb - read data from a logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID from where to read
+ * @lnum: the logical eraseblock to read from
+ * @buf: buffer to store the read data
+ * @offset: offset within the logical eraseblock from where to read
+ * @len: how many bytes to read
+ * @check: data CRC check flag
+ *
+ * If the logical eraseblock @lnum is unmapped, @buf is filled with 0xFF
+ * bytes. The @check flag only makes sense for static volumes and forces
+ * eraseblock data CRC checking.
+ *
+ * In case of success this function returns zero. In case of a static volume,
+ * id data CRC mismatches - %-EBADMSG is returned. %-EBADMSG may also be
+ * returned for any volume type if an ECC error was detected by the MTD device
+ * driver. Other negative error cored may be returned in case of other errors.
+ */
+int ubi_eba_read_leb(struct ubi_info *ubi, int vol_id, int lnum, void *buf,
+		     int offset, int len, int check)
+{
+	int err, pnum, scrub = 0;
+	const struct ubi_vtbl_vtr *vtr;
+	uint32_t data_crc;
+	struct ubi_vid_hdr *vid_hdr;
+
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->vtbl.vt_slots || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(offset >= 0);
+	ubi_assert(len > 0);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(offset + len <= ubi->io.leb_size - vtr->data_pad);
+	ubi_assert(lnum < ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	cond_resched();
+
+	err = leb_read_lock(ubi, vol_id, lnum);
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
+		leb_read_unlock(ubi, vol_id, lnum);
+		ubi_assert(vtr->vol_type != UBI_STATIC_VOLUME);
+		memset(buf, 0xFF, len);
+		return 0;
+	}
+
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
+					ubi_ro_mode(ubi);
+			}
+			goto out_free;
+		} else if (unlikely(err == UBI_IO_BITFLIPS))
+			scrub = 1;
+
+		err = paranoid_check_leb(ubi, pnum, vol_id, lnum, vid_hdr);
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
+	leb_read_unlock(ubi, vol_id, lnum);
+	return err;
+
+out_free:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_unlock:
+	leb_read_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+/**
+ * recover_peb - recover from write failure.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock to recover
+ * @vol_id: volume ID
+ * @lnum: logical eraseblock number
+ * @buf: data which was not written because of a write failure
+ * @offset: offset of the failed write
+ * @len: how many bytes should have been written
+ *
+ * This function is called in case of a write failure and moves all good data
+ * foam the potentially bad physical eraseblock to a good physical eraseblock.
+ * This function also writes the data which was not written due to the failure.
+ * Returns new physical eraseblock number in case of success, and a negative
+ * error code in case of failure.
+ */
+int recover_peb(struct ubi_info *ubi, int pnum, int vol_id, int lnum,
+		const void *buf, int offset, int len)
+{
+	int err, new_pnum, data_size, tries = 0;
+	struct ubi_vid_hdr *vid_hdr;
+	unsigned char *new_buf;
+
+	ubi_assert(ubi->io.bad_allowed);
+
+retry:
+	new_pnum = ubi_wl_get_peb(ubi, UBI_DATA_UNKNOWN);
+	if (new_pnum < 0)
+		return new_pnum;
+
+	ubi_msg("recover PEB %d, move data to PEB %d", pnum, new_pnum);
+
+	/* At first recover the VID header */
+
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (!vid_hdr) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	err = ubi_io_read_vid_hdr(ubi, pnum, vid_hdr, 1);
+	if (err && err != UBI_IO_BITFLIPS) {
+		if (err > 0)
+			err = -EIO;
+		goto out_free;
+	}
+
+	vid_hdr->leb_ver = cpu_to_ubi32(ubi32_to_cpu(vid_hdr->leb_ver) + 1);
+	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
+	if (err)
+		goto write_error;
+
+	/* Now recover the data */
+
+	data_size = offset + len;
+	new_buf = kmalloc(data_size, GFP_KERNEL);
+	if (unlikely(!new_buf)) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+	memset(new_buf + offset, 0xFF, len);
+
+	/* Read everything before the area where the write failure happened */
+	if (offset > 0) {
+		err = ubi_io_read_data(ubi, new_buf, pnum, 0, offset);
+		if (err && err != UBI_IO_BITFLIPS) {
+			kfree(new_buf);
+			goto out_free;
+		}
+	}
+
+	/*
+	 * Now we assume that before the failed write the (offset, offset+len)
+	 * area contained all 0xFF bytes. This is true for NAND. This is not
+	 * always true for NOR, but NOR don't admit of bad PEBs.
+	 */
+	memcpy(new_buf + offset, buf, len);
+
+	err = ubi_io_write_data(ubi, new_buf, new_pnum, 0, data_size);
+	if (err) {
+		kfree(new_buf);
+		goto write_error;
+	}
+
+	kfree(new_buf);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi_eba_leb_remap(ubi, vol_id, lnum, new_pnum);
+	ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_msg("data was successfully recovered");
+	return 0;
+
+out_free:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_put:
+	ubi_wl_put_peb(ubi, new_pnum, 1);
+	return err;
+
+write_error:
+	/*
+	 * Bad luck? This physical eraseblock is bad too? Crud. Let's try to
+	 * get another one.
+	 */
+	ubi_warn("failed to write to PEB %d", new_pnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi_wl_put_peb(ubi, new_pnum, 1);
+	if (++tries > 5)
+		/* We've tried too many times */
+		return err;
+	ubi_msg("try again");
+	goto retry;
+}
+
+/**
+ * ubi_eba_write_leb - write data to logical eraseblock of a dynamic volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: the volume ID where to write
+ * @lnum: the logical eraseblock number to write
+ * @buf: the data to write
+ * @offset: the offset within the logical eraseblock where to write
+ * @len: how many bytes to write
+ * @dtype: data type
+ *
+ * This function writes data to logical eraseblock @lnum of a dynamic volume
+ * @vol_id. Returns zero in case of success and a negative error code in case
+ * of failure. In case of an error, it is possible that something was still
+ * written to the flash media, but may be some garbage.
+ */
+int ubi_eba_write_leb(struct ubi_info *ubi, int vol_id, int lnum,
+		      const void *buf, int offset, int len,
+		      enum ubi_data_type dtype)
+{
+	int err, pnum, tries = 0;
+	uint32_t leb_ver;
+	uint64_t sqnum;
+	struct ubi_vid_hdr *vid_hdr;
+	const struct ubi_vtbl_vtr *vtr;
+
+retry:
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->vtbl.vt_slots || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(offset >= 0);
+	ubi_assert(len >= 0);
+	ubi_assert(dtype == UBI_DATA_LONGTERM || dtype == UBI_DATA_SHORTTERM ||
+		   dtype == UBI_DATA_UNKNOWN);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(offset + len <= ubi->io.leb_size - vtr->data_pad);
+	ubi_assert(lnum < ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+	ubi_assert(len % ubi->io.min_io_size == 0);
+	ubi_assert(offset % ubi->io.min_io_size == 0);
+	ubi_assert(vtr->vol_type == UBI_DYNAMIC_VOLUME);
+
+	cond_resched();
+
+	if (unlikely(ubi->io.ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		return err;
+
+	pnum = leb2peb(ubi, vol_id, lnum);
+	if (pnum >= 0) {
+		dbg_eba("write %d bytes at offset %d of LEB %d:%d, PEB %d",
+			len, offset, vol_id, lnum, pnum);
+
+		if (len != 0) {
+			err = ubi_io_write_data(ubi, buf, pnum, offset, len);
+			if (unlikely(err))
+				goto data_write_error;
+		}
+		leb_write_unlock(ubi, vol_id, lnum);
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
+	sqnum = next_sqnum(ubi);
+	leb_ver = leb_get_ver(ubi, vol_id, lnum);
+
+	vid_hdr->vol_type = UBI_VID_DYNAMIC;
+	vid_hdr->sqnum = cpu_to_ubi64(sqnum);
+	vid_hdr->leb_ver = cpu_to_ubi32(leb_ver);
+	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
+	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
+	vid_hdr->data_pad = cpu_to_ubi32(vtr->data_pad);
+
+	pnum = ubi_wl_get_peb(ubi, dtype);
+	if (unlikely(pnum < 0)) {
+		err = pnum;
+		ubi_free_vid_hdr(ubi, vid_hdr);
+		goto out_unlock;
+	}
+
+	dbg_eba("write VID hdr and %d bytes at offset %d of LEB %d:%d, PEB %d",
+		len, offset, vol_id, lnum, pnum);
+
+	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
+	if (unlikely(err)) {
+		ubi_warn("failed to write VID header to PEB %d", pnum);
+		ubi_free_vid_hdr(ubi, vid_hdr);
+		if (err != -EIO || !ubi->io.bad_allowed)
+			goto no_bad_eraseblocks;
+
+		/*
+		 * Fortunately, we did not write any data there yet, so just put this
+		 * physical eraseblock and request a new one. We assume that if this
+		 * physical eraseblock went bad, the erase code will handle that.
+		 */
+		ubi_msg("try to recover form the error");
+		err = ubi_wl_put_peb(ubi, pnum, 1);
+		leb_write_unlock(ubi, vol_id, lnum);
+		if (err || ++tries > 5) {
+			ubi_ro_mode(ubi);
+			return err;
+		}
+		goto retry;
+	}
+
+	leb_map(ubi, vol_id, lnum, pnum);
+
+	if (len != 0) {
+		err = ubi_io_write_data(ubi, buf, pnum, offset, len);
+		if (unlikely(err)) {
+			ubi_free_vid_hdr(ubi, vid_hdr);
+			goto data_write_error;
+		}
+	}
+
+	leb_write_unlock(ubi, vol_id, lnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return 0;
+
+out_unlock:
+	leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/* Failed to write data */
+data_write_error:
+	ubi_warn("failed to write data to PEB %d", pnum);
+	if (err != -EIO || !ubi->io.bad_allowed)
+		goto no_bad_eraseblocks;
+
+	err = recover_peb(ubi, pnum, vol_id, lnum, buf, offset, len);
+	if (err)
+		ubi_ro_mode(ubi);
+	leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/*
+	 * This flash device does not admit of bad eraseblocks or something
+	 * nasty and unexpected happened. Switch to read-only mode just in
+	 * case.
+	 */
+no_bad_eraseblocks:
+	ubi_ro_mode(ubi);
+	leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+}
+
+/**
+ * ubi_eba_write_leb_st - write data to a logical eraseblock of a static
+ * volume.
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
+int ubi_eba_write_leb_st(struct ubi_info *ubi, int vol_id, int lnum,
+			 const void *buf, int len, enum ubi_data_type dtype,
+			 int used_ebs)
+{
+	int err, pnum, tries = 0, data_size = len;
+	uint32_t leb_ver, crc;
+	uint64_t sqnum;
+	struct ubi_vid_hdr *vid_hdr;
+	const struct ubi_vtbl_vtr *vtr;
+
+retry:
+	ubi_assert(vol_id >= 0);
+	ubi_assert(vol_id < ubi->vtbl.vt_slots || ubi_is_ivol(vol_id));
+	ubi_assert(lnum >= 0);
+	ubi_assert(len > 0);
+	ubi_assert(dtype == UBI_DATA_LONGTERM || dtype == UBI_DATA_SHORTTERM ||
+		   dtype == UBI_DATA_UNKNOWN);
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+	ubi_assert(!IS_ERR(vtr));
+	ubi_assert(lnum < ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
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
+		ubi_assert(len <= ubi->io.leb_size - vtr->data_pad);
+		len = align_up(data_size, ubi->io.min_io_size);
+	} else {
+		ubi_assert(len == ubi->io.leb_size - vtr->data_pad);
+		ubi_assert(len % ubi->io.min_io_size == 0);
+	}
+
+	if (unlikely(ubi->io.ro_mode)) {
+		dbg_err("read-only mode");
+		return -EROFS;
+	}
+
+	err = leb_write_lock(ubi, vol_id, lnum);
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
+	sqnum = next_sqnum(ubi);
+	leb_ver = leb_get_ver(ubi, vol_id, lnum);
+
+	vid_hdr->sqnum = cpu_to_ubi64(sqnum);
+	vid_hdr->leb_ver = cpu_to_ubi32(leb_ver);
+	vid_hdr->vol_id = cpu_to_ubi32(vol_id);
+	vid_hdr->lnum = cpu_to_ubi32(lnum);
+	vid_hdr->compat = ubi_get_compat(ubi, vol_id);
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
+		ubi_free_vid_hdr(ubi, vid_hdr);
+		goto out_unlock;
+	}
+
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
+	leb_write_unlock(ubi, vol_id, lnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	return 0;
+
+out_unlock:
+	leb_write_unlock(ubi, vol_id, lnum);
+	return err;
+
+	/* Write failure */
+write_error:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	if (err != -EIO || !ubi->io.bad_allowed) {
+		/*
+		 * This flash device does not admit of bad eraseblocks or
+		 * something nasty and unexpected happened. Switch to read-only
+		 * mode just in case.
+		 */
+		ubi_ro_mode(ubi);
+		leb_write_unlock(ubi, vol_id, lnum);
+		return err;
+	}
+
+	/*
+	 * We assume that if this physical eraseblock went bad - the erase code
+	 * will handle that.
+	 */
+	ubi_msg("try to recover form the error");
+	err = ubi_wl_put_peb(ubi, pnum, 1);
+	leb_write_unlock(ubi, vol_id, lnum);
+	if (err || ++tries > 5) {
+		ubi_ro_mode(ubi);
+		return err;
+	}
+	goto retry;
+}
+
+/**
+ * ubi_eba_leb_is_mapped - check if a logical eraseblock is mapped.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID
+ * @lnum: the logical eraseblock to check
+ *
+ * This function checks if logical eraseblock @lnum is mapped to a physical
+ * eraseblock. Returns %1 if it is mapped, and %0 if not.
+ */
+int ubi_eba_leb_is_mapped(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	dbg_eba("check LEB %d:%d PEBs", vol_id, lnum);
+
+	ubi_assert(vol_id >= 0 && vol_id < ubi->vtbl.vt_slots);
+	ubi_assert(lnum >= 0);
+	ubi_assert(lnum < ubi->eba.eba_tbl[vol_id2idx(ubi, vol_id)].leb_count);
+
+	return leb2peb(ubi, vol_id, lnum) >= 0;
+}
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
+void ubi_eba_leb_remap(struct ubi_info *ubi, int vol_id, int lnum, int pnum)
+{
+	/* The logical eraseblock is supposed to be locked */
+	paranoid_check_leb_locked(ubi, vol_id, lnum);
+	leb_unmap(ubi, vol_id, lnum);
+	leb_map(ubi, vol_id, lnum, pnum);
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
+	struct ubi_eba_tbl_volume *eba_tbl = ubi->eba.eba_tbl;
+
+	for (idx = 0; idx < ubi->eba.num_volumes; idx++) {
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
+		eba_tbl[idx].recs = kmalloc(sz, GFP_KERNEL);
+		if (unlikely(!eba_tbl[idx].recs)) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < vtr->reserved_pebs; i++) {
+			ubi->eba.eba_tbl[idx].recs[i].pnum = NOT_MAPPED;
+			ubi->eba.eba_tbl[idx].recs[i].leb_ver = 0;
+		}
+
+		sv = ubi_scan_find_sv(si, idx2vol_id(ubi, idx));
+		if (!sv)
+			continue;
+
+		rb_for_each_entry(rb, seb, &sv->root, u.rb) {
+			ubi->eba.eba_tbl[idx].recs[seb->lnum].pnum = seb->pnum;
+			ubi->eba.eba_tbl[idx].recs[seb->lnum].leb_ver
+							= seb->leb_ver + 100;
+		}
+	}
+
+	return 0;
+
+out:
+	for (i = 0; i < ubi->eba.num_volumes; i++)
+		kfree(ubi->eba.eba_tbl[i].recs);
+
+	return err;
+}
+
+/**
+ * ltree_entry_ctor - lock tree entries slab cache constructor.
+ *
+ * @obj: the lock-tree entry to construct
+ * @cache: the lock tree entry slab cache
+ * @flag: constructor flags
+ */
+static void ltree_entry_ctor(void *obj, struct kmem_cache *cache,
+			     unsigned long flags)
+{
+	struct ubi_eba_ltree_entry *le = obj;
+
+	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) !=
+	    SLAB_CTOR_CONSTRUCTOR)
+		return;
+
+	le->users = 0;
+	init_rwsem(&le->mutex);
+}
+
+/**
+ * ubi_eba_init_scan - initialize the EBA unit using scanning information.
+ *
+ * @ubi: the UBI device description object
+ * @si: pointer to the scanning information
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_eba_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err, sz;
+
+	dbg_eba("initialize the EBA unit");
+
+	spin_lock_init(&ubi->eba.eba_tbl_lock);
+	spin_lock_init(&ubi->eba.ltree_lock);
+	ubi->eba.ltree = RB_ROOT;
+
+	if (ubis_num == 0) {
+		eba_ltree_entry_slab =
+			kmem_cache_create("ubi_eba_ltree_entry_slab",
+					  sizeof(struct ubi_eba_ltree_entry), 0,
+					  0, &ltree_entry_ctor, NULL);
+		if (!eba_ltree_entry_slab)
+			return -ENOMEM;
+	}
+
+	ubi->eba.global_sq_cnt = si->max_sqnum;
+
+	ubi->eba.num_volumes = ubi->vtbl.vt_slots + UBI_INT_VOL_COUNT;
+	sz = ubi->eba.num_volumes * sizeof(struct ubi_eba_tbl_volume);
+	ubi->eba.eba_tbl = kzalloc(sz, GFP_KERNEL);
+	if (!ubi->eba.eba_tbl)
+		goto out;
+
+	err = build_eba_tbl(ubi, si);
+	if (err)
+		goto out;
+
+	dbg_eba("the EBA unit is initialized");
+	return 0;
+
+out:
+	kfree(ubi->eba.eba_tbl);
+	if (ubis_num == 0)
+		kmem_cache_destroy(eba_ltree_entry_slab);
+	return err;
+}
+
+/**
+ * ubi_eba_close - close the EBA unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_eba_close(const struct ubi_info *ubi)
+{
+	unsigned int i;
+
+	dbg_eba("close EBA management unit");
+
+	for (i = 0; i < ubi->eba.num_volumes; i++)
+		kfree(ubi->eba.eba_tbl[i].recs);
+	if (ubis_num == 1)
+		kmem_cache_destroy(eba_ltree_entry_slab);
+}
+
+/**
+ * ubi_eba_copy_leb - copy logical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @from: physical eraseblock number from where to move
+ * @to: physical eraseblock number where to move
+ * @vid_hdr: VID header of the @from physical eraseblock
+ *
+ * This function copies logical eraseblock from physical eraseblock @from to
+ * physical eraseblock @to. The @vid_hdr buffer may be changed by this
+ * function. Returns zero in case of success, %UBI_IO_BITFLIPS if the operation
+ * was canceled because bit-flips were detected at the target PEB, and a
+ * negative error code in case of failure.
+ */
+int ubi_eba_copy_leb(struct ubi_info *ubi, int from, int to,
+		     struct ubi_vid_hdr *vid_hdr)
+{
+	int err, vol_id, lnum, data_size, aldata_size, pnum;
+	uint32_t crc;
+	unsigned long long sqnum;
+	void *buf;
+
+	vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	lnum = ubi32_to_cpu(vid_hdr->lnum);
+
+	dbg_eba("copy LEB %d:%d, PEB %d to PEB %d",
+		vol_id, lnum, from, to);
+
+	if (vid_hdr->vol_type == UBI_VID_STATIC) {
+		data_size = ubi32_to_cpu(vid_hdr->data_size);
+		aldata_size = align_up(data_size, ubi->io.min_io_size);
+	} else
+		data_size = aldata_size =
+			    ubi->io.leb_size - ubi32_to_cpu(vid_hdr->data_pad);
+
+	ubi_assert(aldata_size % ubi->io.min_io_size == 0);
+
+	buf = kmalloc(aldata_size, GFP_KERNEL);
+	if (unlikely(!buf))
+		return -ENOMEM;
+
+	/*
+	 * We do not want anybody to write to this logical eraseblock while we
+	 * are moving it, so we lock it.
+	 */
+	err = leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		goto out_free;
+
+	/*
+	 * But the logical eraseblock might have been put by this time.
+	 * Cancel if it is true.
+	 */
+	pnum = leb2peb(ubi, vol_id, lnum);
+	if (pnum != from) {
+		dbg_eba("LEB %d:%d is no longer mapped to PEB %d, mapped to "
+			"PEB %d, cancel", vol_id, lnum, from, pnum);
+		goto out_unlock;
+	}
+
+	/*
+	 * OK, now the LEB is locked and we can safely start moving it.
+	 */
+
+	dbg_eba("read %d bytes of data", aldata_size);
+
+	err = ubi_io_read_data(ubi, buf, from, 0, aldata_size);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		ubi_warn("error %d while reading data from PEB %d",
+			 err, from);
+		goto out_unlock;
+	}
+
+	/*
+	 * Now we have got to calculate how much data we have to to copy. In
+	 * case of a static volume it is fairly easy - the VID header contains
+	 * the data size. In case of a dynamic volume it is more difficult - we
+	 * have to read the contents, cut 0xFF bytes from the end and copy only
+	 * the first part. We must do this to avoid writing 0xFF bytes as it
+	 * may have some side-effects. And not only this. It is important not
+	 * to include those 0xFFs to CRC because later the they may be filled
+	 * by data.
+	 */
+	if (vid_hdr->vol_type == UBI_VID_DYNAMIC)
+		aldata_size = data_size =
+				ubi_calc_data_len(ubi, buf, data_size);
+
+	cond_resched();
+	crc = crc32(UBI_CRC32_INIT, buf, data_size);
+	cond_resched();
+
+	/*
+	 * It may turn out that the whole @from physical eraseblock contains
+	 * only 0xFF bytes. Then we have to only write the VID header and do
+	 * not write any data. This also means we should not set
+	 * @vid_hdr->copy_flag, @vid_hdr->data_size, and @vid_hdr->data_crc.
+	 */
+	if (likely(data_size > 0)) {
+		vid_hdr->copy_flag = 1;
+		vid_hdr->data_size = cpu_to_ubi32(data_size);
+		vid_hdr->data_crc = cpu_to_ubi32(crc);
+	}
+	vid_hdr->leb_ver = cpu_to_ubi32(ubi32_to_cpu(vid_hdr->leb_ver) + 1);
+	sqnum = next_sqnum(ubi);
+	vid_hdr->sqnum = cpu_to_ubi64(sqnum);
+
+	err = ubi_io_write_vid_hdr(ubi, to, vid_hdr);
+	if (unlikely(err))
+		goto out_unlock;
+
+	cond_resched();
+
+	/* Read the VID header back and check if it was written correctly */
+	err = ubi_io_read_vid_hdr(ubi, to, vid_hdr, 1);
+	if (unlikely(err)) {
+		if (err != UBI_IO_BITFLIPS)
+			ubi_warn("cannot read VID header back from PEB %d", to);
+		goto out_unlock;
+	}
+
+	if (likely(data_size > 0)) {
+		void *buf1;
+
+		err = ubi_io_write_data(ubi, buf, to, 0, aldata_size);
+		if (unlikely(err))
+			goto out_unlock;
+
+		/*
+		 * We've written the data and are going to read it back to make
+		 * sure it was written correctly.
+		 */
+		buf1 = kmalloc(aldata_size, GFP_KERNEL);
+		if (unlikely(!buf1)) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+
+		cond_resched();
+
+		err = ubi_io_read_data(ubi, buf1, to, 0, aldata_size);
+		if (unlikely(err)) {
+			kfree(buf1);
+			if (err != UBI_IO_BITFLIPS)
+				ubi_warn("cannot read data back from PEB %d",
+					 to);
+			goto out_unlock;
+		}
+
+		cond_resched();
+
+		if (unlikely(memcmp(buf, buf1, aldata_size))) {
+			ubi_warn("read data back from PEB %d - it is different",
+				 to);
+			kfree(buf1);
+			goto out_unlock;
+		}
+		kfree(buf1);
+	}
+
+	ubi_eba_leb_remap(ubi, vol_id, lnum, to);
+	leb_write_unlock(ubi, vol_id, lnum);
+	kfree(buf);
+
+	return 0;
+
+out_unlock:
+	leb_write_unlock(ubi, vol_id, lnum);
+out_free:
+	kfree(buf);
+	return err;
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
+ * @vid_hdr: volume identifier header to check
+ *
+ * This function returns zero if the headers are all right, %1 if not, and a
+ * negative error code in case of error.
+ */
+static int paranoid_check_leb(const struct ubi_info *ubi, int pnum, int vol_id,
+			      int lnum, const struct ubi_vid_hdr *vid_hdr)
+{
+	int err, hdr_vol_id, hdr_lnum;
+	struct ubi_ec_hdr *ec_hdr;
+
+	/* Check the EC header */
+	ec_hdr = kzalloc(ubi->io.ec_hdr_alsize, GFP_KERNEL);
+	if (unlikely(!ec_hdr))
+		return -ENOMEM;
+
+	err = ubi_io_read_ec_hdr(ubi, pnum, ec_hdr, 1);
+	kfree(ec_hdr);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		if (err < 0)
+			return err;
+		goto fail;
+	}
+
+	hdr_vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	hdr_lnum = ubi32_to_cpu(vid_hdr->lnum);
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
+static int paranoid_check_leb_locked(struct ubi_info *ubi, int vol_id, int lnum)
+{
+	struct ubi_eba_ltree_entry *le;
+
+	spin_lock(&ubi->eba.ltree_lock);
+	le = ltree_lookup(ubi, vol_id, lnum);
+	spin_unlock(&ubi->eba.ltree_lock);
+	if (likely(le))
+		return 0;
+
+	ubi_err("paranoid check failed");
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_EBA */
