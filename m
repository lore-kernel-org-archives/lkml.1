Return-Path: <linux-kernel-owner+w=401wt.eu-S2992730AbXBQRGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992730AbXBQRGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992729AbXBQRGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:06:40 -0500
Received: from smtp.nokia.com ([131.228.20.170]:54126 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992727AbXBQRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:06:24 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:45 +0200
Message-Id: <20070217165545.5845.27214.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/44 take 2] [UBI] scanning unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:12.0365 (UTC) FILETIME=[63B389D0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185241-63ECBBB0-772305F4/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/scan.c tmp-to/drivers/mtd/ubi/scan.c
--- tmp-from/drivers/mtd/ubi/scan.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/scan.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,1383 @@
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
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/err.h>
+#include <linux/crc32.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "scan.h"
+#include "io.h"
+#include "misc.h"
+#include "vtbl.h"
+#include "debug.h"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_SCAN
+static int paranoid_check_si(const struct ubi_info *ubi,
+			     struct ubi_scan_info *si);
+#else
+#define paranoid_check_si(ubi, si) 0
+#endif
+
+static int process_eb(const struct ubi_info *ubi,
+		      struct ubi_scan_info *si, int pnum);
+static void commit_to_mean_value(struct ubi_scan_info *si);
+
+/* Temporary variables used during scanning */
+static struct ubi_ec_hdr *ech;
+static struct ubi_vid_hdr *vidh;
+
+struct ubi_scan_info *ubi_scan(struct ubi_info *ubi)
+{
+	int err, pnum;
+	struct rb_node *rb1, *rb2;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *seb;
+	struct ubi_scan_info *si;
+	struct ubi_io_info *io = ubi->io;
+
+	si = ubi_kzalloc(sizeof(struct ubi_scan_info));
+	if (!si)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&si->corr);
+	INIT_LIST_HEAD(&si->free);
+	INIT_LIST_HEAD(&si->erase);
+	INIT_LIST_HEAD(&si->alien);
+	si->volumes = RB_ROOT;
+	si->is_empty = 1;
+
+	err = -ENOMEM;
+	ech = ubi_zalloc_ec_hdr(ubi);
+	if (!ech)
+		goto out_si;
+
+	vidh = ubi_zalloc_vid_hdr(ubi);
+	if (!vidh)
+		goto out_ech;
+
+	for (pnum = 0; pnum < io->peb_count; pnum++) {
+		cond_resched();
+
+		err = process_eb(ubi, si, pnum);
+		if (unlikely(err < 0))
+			goto out_vidh;
+	}
+
+	dbg_scan("scanning is finished");
+
+	/* Finish mean erase counter calculations */
+	if (si->ec_count)
+		commit_to_mean_value(si);
+
+	/*
+	 * FIXME: this is actually duty of the I/O unit to initialize this, but
+	 * MTD does not provide enough information.
+	 */
+	io->bad_peb_count = si->bad_peb_count;
+	io->good_peb_count = io->peb_count - io->bad_peb_count;
+
+	if (si->is_empty)
+		ubi_msg("empty MTD device detected");
+
+	/*
+	 * In case of unknown erase counter we use the mean erase counter
+	 * value.
+	 */
+	rb_for_each_entry(rb1, sv, &si->volumes, rb) {
+		cond_resched();
+		rb_for_each_entry(rb2, seb, &sv->root, u.rb)
+			if (seb->ec == NAND_SCAN_UNKNOWN_EC)
+				seb->ec = si->mean_ec;
+	}
+
+	cond_resched();
+	list_for_each_entry(seb, &si->free, u.list)
+		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
+			seb->ec = si->mean_ec;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->corr, u.list)
+		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
+			seb->ec = si->mean_ec;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->erase, u.list)
+		if (seb->ec == NAND_SCAN_UNKNOWN_EC)
+			seb->ec = si->mean_ec;
+
+	err = paranoid_check_si(ubi, si);
+	if (err) {
+		if (err > 0)
+			err = -EINVAL;
+		goto out_vidh;
+	}
+
+	ubi_free_vid_hdr(ubi, vidh);
+	ubi_free_ec_hdr(ubi, ech);
+	return si;
+
+out_vidh:
+	ubi_free_vid_hdr(ubi, vidh);
+out_ech:
+	ubi_free_ec_hdr(ubi, ech);
+out_si:
+	ubi_scan_destroy_si(si);
+	return ERR_PTR(err);
+}
+
+static int vid_hdr_sanity_check(const struct ubi_info *ubi,
+				const struct ubi_vid_hdr *vid_hdr,
+				const struct ubi_scan_volume *sv, int pnum);
+
+static int add_to_erase(struct ubi_scan_info *si, int pnum, int ec);
+
+static struct ubi_scan_volume *add_volume(const struct ubi_info *ubi,
+					  struct ubi_scan_info *si, int vol_id,
+					  int pnum,
+					  const struct ubi_vid_hdr *vid_hdr);
+
+static int compare_lebs(const struct ubi_info *ubi,
+			const struct ubi_scan_leb *seb, int pnum,
+			const struct ubi_vid_hdr *vid_hdr);
+
+int ubi_scan_add_peb(const struct ubi_info *ubi, struct ubi_scan_info *si,
+		     int pnum, int ec, const struct ubi_vid_hdr *vid_hdr,
+		     int bitflips)
+{
+	int err, vol_id, lnum;
+	uint32_t leb_ver;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *seb;
+	struct rb_node **p, *parent = NULL;
+
+	vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	lnum = ubi32_to_cpu(vid_hdr->lnum);
+	leb_ver = ubi32_to_cpu(vid_hdr->leb_ver);
+
+	dbg_scan("PEB %d, LEB %d:%d, EC %d, LEB ver %u, bitflips %d",
+		 pnum, vol_id, lnum, ec, leb_ver, bitflips);
+
+	sv = add_volume(ubi, si, vol_id, pnum, vid_hdr);
+	if (unlikely(IS_ERR(sv)) < 0)
+		return PTR_ERR(sv);
+
+	/*
+	 * Walk the RB-tree of logical eraseblocks of volume @vol_id to look
+	 * if this is the first instance of this logical eraseblock or not.
+	 */
+	p = &sv->root.rb_node;
+	while (*p) {
+		int cmp_res;
+
+		parent = *p;
+		seb = rb_entry(parent, struct ubi_scan_leb, u.rb);
+
+		if (lnum != seb->lnum) {
+			if (lnum < seb->lnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+			continue;
+		}
+
+		/*
+		 * There is already a physical eraseblock describing the same
+		 * logical eraseblock present.
+		 */
+
+		dbg_scan("this LEB already exists: PEB %d, LEB ver %u, EC %d",
+			 seb->pnum, seb->leb_ver, seb->ec);
+
+		/*
+		 * Make sure that the logical eraseblocks have different
+		 * versions. Otherwise the image is bad.
+		 */
+		if (unlikely(seb->leb_ver == leb_ver)) {
+			ubi_err("two LEBs with same version %u", leb_ver);
+			ubi_dbg_dump_seb(seb, 0);
+			ubi_dbg_dump_vid_hdr(vid_hdr);
+			return -EINVAL;
+		}
+
+		/*
+		 * Now we have to drop the older one and preserve the newer
+		 * one.
+		 */
+		cmp_res = compare_lebs(ubi, seb, pnum, vid_hdr);
+		if (unlikely(cmp_res < 0))
+			return cmp_res;
+
+		if (cmp_res & 1) {
+			/*
+			 * This logical eraseblock is newer then the one
+			 * found earlier.
+			 */
+			err = vid_hdr_sanity_check(ubi, vid_hdr, sv,
+						   pnum);
+			if (unlikely(err))
+				return err;
+
+			if (cmp_res & 4)
+				err = ubi_scan_add_corr_peb(si, seb->pnum, seb->ec);
+			else
+				err = add_to_erase(si, seb->pnum, seb->ec);
+			if (unlikely(err))
+				return err;
+
+			seb->ec = ec;
+			seb->pnum = pnum;
+			seb->leb_ver = leb_ver;
+			seb->scrub = ((cmp_res & 2) || bitflips);
+
+			if (sv->highest_lnum == lnum)
+				sv->last_data_size =
+					ubi32_to_cpu(vid_hdr->data_size);
+
+			return 0;
+		} else {
+			/*
+			 * This logical eraseblock is older then the one found
+			 * previously.
+			 */
+			if (cmp_res & 4)
+				return ubi_scan_add_corr_peb(si, pnum, ec);
+			else
+				return add_to_erase(si, pnum, ec);
+		}
+	}
+
+	/*
+	 * We've met this logical eraseblock for the first time, add it to the
+	 * scanning information.
+	 */
+
+	err = vid_hdr_sanity_check(ubi, vid_hdr, sv, pnum);
+	if (unlikely(err))
+		return err;
+
+	seb = ubi_alloc_scan_leb();
+	if (unlikely(!seb))
+		return -ENOMEM;
+
+	seb->ec = ec;
+	seb->pnum = pnum;
+	seb->lnum = lnum;
+	seb->leb_ver = leb_ver;
+	seb->scrub = bitflips;
+
+	if (sv->highest_lnum <= lnum) {
+		sv->highest_lnum = lnum;
+		sv->last_data_size = ubi32_to_cpu(vid_hdr->data_size);
+	}
+
+	sv->leb_count += 1;
+	rb_link_node(&seb->u.rb, parent, p);
+	rb_insert_color(&seb->u.rb, &sv->root);
+	return 0;
+}
+
+int ubi_scan_add_corr_peb(struct ubi_scan_info *si, int pnum, int ec)
+{
+	struct ubi_scan_leb *seb;
+
+	dbg_scan("PEB %d (EC %d) is corrupted", pnum, ec);
+
+	seb = ubi_alloc_scan_leb();
+	if (unlikely(!seb))
+		return -ENOMEM;
+
+	seb->pnum = pnum;
+	seb->ec = ec;
+	list_add_tail(&seb->u.list, &si->corr);
+	return 0;
+}
+
+struct ubi_scan_volume *ubi_scan_find_sv(const struct ubi_scan_info *si,
+					 int vol_id)
+{
+	struct ubi_scan_volume *sv;
+	struct rb_node *p = si->volumes.rb_node;
+
+	while (p) {
+		sv = rb_entry(p, struct ubi_scan_volume, rb);
+
+		if (vol_id == sv->vol_id)
+			return sv;
+
+		if (vol_id > sv->vol_id)
+			p = p->rb_left;
+		else
+			p = p->rb_right;
+	}
+
+	return NULL;
+}
+
+struct ubi_scan_leb *ubi_scan_find_seb(const struct ubi_scan_volume *sv,
+				       int lnum)
+{
+	struct ubi_scan_leb *seb;
+	struct rb_node *p = sv->root.rb_node;
+
+	while (p) {
+		seb = rb_entry(p, struct ubi_scan_leb, u.rb);
+
+		if (lnum == seb->lnum)
+			return seb;
+
+		if (lnum > seb->lnum)
+			p = p->rb_left;
+		else
+			p = p->rb_right;
+	}
+
+	return NULL;
+}
+
+void ubi_scan_rm_volume(const struct ubi_info *ubi, struct ubi_scan_info *si,
+			struct ubi_scan_volume *sv)
+{
+	struct rb_node *rb;
+	struct ubi_scan_leb *seb;
+
+	dbg_scan("remove scanning information about volume %d", sv->vol_id);
+
+	while ((rb = rb_first(&sv->root))) {
+		cond_resched();
+
+		seb = rb_entry(rb, struct ubi_scan_leb, u.rb);
+
+		/* The physical eraseblock will be erased later */
+		rb_erase(&seb->u.rb, &sv->root);
+		list_add_tail(&seb->u.list, &si->erase);
+	}
+
+	rb_erase(&sv->rb, &si->volumes);
+	ubi_free_scan_volume(sv);
+	si->vols_found -= 1;
+}
+
+int ubi_scan_erase_peb(const struct ubi_info *ubi,
+		       const struct ubi_scan_info *si, int pnum, int ec)
+{
+	int err;
+	struct ubi_ec_hdr *ec_hdr;
+	uint64_t ec1 = ec;
+
+	ec_hdr = ubi_zalloc_ec_hdr(ubi);
+	if (!ec_hdr)
+		return -ENOMEM;
+
+	if (unlikely(ec1 >= UBI_MAX_ERASECOUNTER)) {
+		/*
+		 * Erase counter overflow. Upgrade UBI and use 64-bit
+		 * erase counters internally.
+		 */
+		ubi_err("erase counter overflow at PEB %d, EC %lld",
+			pnum, (long long)ec);
+		return -EINVAL;
+	}
+
+	ec_hdr->ec = cpu_to_ubi64(ec1);
+
+	err = ubi_io_sync_erase(ubi, pnum, 0);
+	if (unlikely(err < 0))
+		goto out_free;
+
+	err = ubi_io_write_ec_hdr(ubi, pnum, ec_hdr);
+
+out_free:
+	ubi_free_ec_hdr(ubi, ec_hdr);
+	return err;
+}
+
+struct ubi_scan_leb *ubi_scan_get_free_peb(const struct ubi_info *ubi,
+					   struct ubi_scan_info *si)
+{
+	int err = 0, i;
+	struct ubi_scan_leb *seb;
+
+	if (!list_empty(&si->free)) {
+		seb = list_entry(si->free.next, struct ubi_scan_leb,
+				 u.list);
+		list_del(&seb->u.list);
+		return seb;
+	}
+
+	if (unlikely(list_empty(&si->erase) && list_empty(&si->corr))) {
+		ubi_err("no vacant eraseblocks found");
+		return ERR_PTR(-ENOSPC);
+	}
+
+	for (i = 0; i < 2; i++) {
+		struct list_head *head;
+		struct ubi_scan_leb *tmp_seb;
+
+		if (i == 0)
+			head = &si->erase;
+		else
+			head = &si->corr;
+
+		/*
+		 * We try to erase the first physical eraseblock from the @head
+		 * list and pick it if we succeed, or try to erase the
+		 * next one if not. And so forth. We don't want to take care
+		 * about bad eraseblocks here - they'll be handled later.
+		 */
+		list_for_each_entry_safe(seb, tmp_seb, head, u.list) {
+			cond_resched();
+
+			if (seb->ec == NAND_SCAN_UNKNOWN_EC)
+				seb->ec = si->mean_ec;
+
+			err = ubi_scan_erase_peb(ubi, si, seb->pnum,
+						 seb->ec + 1);
+			if (unlikely(err))
+				continue;
+
+			seb->ec += 1;
+			list_del(&seb->u.list);
+			dbg_scan("return PEB %d, EC %d", seb->pnum, seb->ec);
+			return seb;
+		}
+	}
+
+	return ERR_PTR(err ? err : -ENOSPC);
+}
+
+static void destroy_sv(struct ubi_scan_volume *sv);
+
+void ubi_scan_destroy_si(struct ubi_scan_info *si)
+{
+	struct ubi_scan_leb *seb, *seb_tmp;
+	struct ubi_scan_volume *sv;
+	struct rb_node *rb;
+
+	list_for_each_entry_safe(seb, seb_tmp, &si->alien, u.list) {
+		list_del(&seb->u.list);
+		ubi_free_scan_leb(seb);
+	}
+	list_for_each_entry_safe(seb, seb_tmp, &si->erase, u.list) {
+		list_del(&seb->u.list);
+		ubi_free_scan_leb(seb);
+	}
+	list_for_each_entry_safe(seb, seb_tmp, &si->corr, u.list) {
+		list_del(&seb->u.list);
+		ubi_free_scan_leb(seb);
+	}
+	list_for_each_entry_safe(seb, seb_tmp, &si->free, u.list) {
+		list_del(&seb->u.list);
+		ubi_free_scan_leb(seb);
+	}
+
+	/* Destroy the volume RB-tree */
+	rb = si->volumes.rb_node;
+	while (rb) {
+		if (rb->rb_left)
+			rb = rb->rb_left;
+		else if (rb->rb_right)
+			rb = rb->rb_right;
+		else {
+			sv = rb_entry(rb, struct ubi_scan_volume, rb);
+
+			rb = rb_parent(rb);
+			if (rb) {
+				if (rb->rb_left == &sv->rb)
+					rb->rb_left = NULL;
+				else
+					rb->rb_right = NULL;
+			}
+
+			destroy_sv(sv);
+		}
+	}
+
+	ubi_kfree(si);
+}
+
+static int add_to_free(struct ubi_scan_info *si, int pnum, int ec);
+static int add_to_alien(struct ubi_scan_info *si, int pnum);
+
+/**
+ * process_eb - read UBI headers, check them and add corresponding data
+ * to the scanning information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ *
+ * This function returns a zero if the physical eraseblock was succesfully
+ * handled and a negative error code in case of failure.
+ */
+static int process_eb(const struct ubi_info *ubi,
+			     struct ubi_scan_info *si, int pnum)
+{
+	long long ec;
+	int err, bitflips = 0, vol_id, ec_corr = 0;
+
+	dbg_scan("scan PEB %d", pnum);
+
+	/* Skip bad physical eraseblocks */
+	err = ubi_io_is_bad(ubi, pnum);
+	if (unlikely(err < 0))
+		return err;
+	else if (err) {
+		si->bad_peb_count += 1;
+		return 0;
+	}
+
+	err = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
+	if (unlikely(err < 0))
+		return err;
+	else if (unlikely(err == UBI_IO_BITFLIPS))
+		bitflips = 1;
+	else if (err == UBI_IO_PEB_EMPTY)
+		return add_to_erase(si, pnum, NAND_SCAN_UNKNOWN_EC);
+	else if (err == UBI_IO_BAD_EC_HDR) {
+		/*
+		 * We have to also look at the VID header, possibly it is not
+		 * corrupted. Set %bitflips flag in order to make this PEB be
+		 * moved and EC be re-created.
+		 */
+		ec_corr = 1;
+		ec = NAND_SCAN_UNKNOWN_EC;
+		bitflips = 1;
+	}
+
+	si->is_empty = 0;
+
+	if (!ec_corr) {
+		/* Make sure UBI version is OK */
+		if (unlikely(ech->version != UBI_VERSION)) {
+			ubi_err("this UBI version is %d, image version is %d",
+				UBI_VERSION, (int)ech->version);
+			return -EINVAL;
+		}
+
+		ec = ubi64_to_cpu(ech->ec);
+		if (unlikely(ec > UBI_MAX_ERASECOUNTER)) {
+			/*
+			 * Erase counter overflow. The EC headers have 64 bits
+			 * reserved, but we anyway make use of only 31 bit
+			 * values, as this seems to be enough for any existing
+			 * flash. Upgrade UBI and use 64-bit erase counters
+			 * internally.
+			 */
+			ubi_err("erase counter overflow, max is %d",
+				UBI_MAX_ERASECOUNTER);
+			ubi_dbg_dump_ec_hdr(ech);
+			return -EINVAL;
+		}
+	}
+
+	/* OK, we've done with the EC header, let's look at the VID header */
+
+	err = ubi_io_read_vid_hdr(ubi, pnum, vidh, 0);
+	if (unlikely(err < 0))
+		return err;
+	else if (unlikely(err == UBI_IO_BITFLIPS))
+		bitflips = 1;
+	else if (unlikely(err == UBI_IO_BAD_VID_HDR ||
+		 (err == UBI_IO_PEB_FREE && ec_corr))) {
+		/* VID header is corrupted */
+		err = ubi_scan_add_corr_peb(si, pnum, ec);
+		if (err)
+			return err;
+		goto adjust_mean_ec;
+	} else if (err == UBI_IO_PEB_FREE) {
+		/* No VID header - the physical eraseblock is free */
+		err = add_to_free(si, pnum, ec);
+		if (unlikely(err))
+			return err;
+		goto adjust_mean_ec;
+	}
+
+	vol_id = ubi32_to_cpu(vidh->vol_id);
+	if (unlikely(!ubi_ivol_is_known(vol_id))) {
+		int lnum = ubi32_to_cpu(vidh->lnum);
+
+		/* Unsupported internal volume */
+		switch (vidh->compat) {
+		case UBI_COMPAT_DELETE:
+			ubi_msg("\"delete\" compatible internal volume %d:%d"
+				" found, remove it", vol_id, lnum);
+			err = ubi_scan_add_corr_peb(si, pnum, ec);
+			if (unlikely(err))
+				return err;
+			break;
+
+		case UBI_COMPAT_RO:
+			ubi_msg("read-only compatible internal volume %d:%d"
+				" found, switch to read-only mode",
+				vol_id, lnum);
+			ubi->io->ro_mode = 1;
+			break;
+
+		case UBI_COMPAT_PRESERVE:
+			ubi_msg("\"preserve\" compatible internal volume %d:%d"
+				" found", vol_id, lnum);
+			err = add_to_alien(si, pnum);
+			if (unlikely(err))
+				return err;
+			si->alien_peb_count += 1;
+			return 0;
+
+		case UBI_COMPAT_REJECT:
+			ubi_err("incompatible internal volume %d:%d found",
+				vol_id, lnum);
+			return -EINVAL;
+		}
+	}
+
+	/* Both UBI headers seem to be fine */
+	err = ubi_scan_add_peb(ubi, si, pnum, ec, vidh, bitflips);
+	if (unlikely(err))
+		return err;
+
+adjust_mean_ec:
+	if (!ec_corr) {
+		if (si->ec_sum + ec < ec) {
+			commit_to_mean_value(si);
+			si->ec_sum = 0;
+			si->ec_count = 0;
+		} else {
+			si->ec_sum += ec;
+			si->ec_count += 1;
+		}
+
+		if (ec > si->max_ec)
+			si->max_ec = ec;
+		if (ec < si->min_ec)
+			si->min_ec = ec;
+	}
+
+	return 0;
+}
+
+/**
+ * add_volume - add a volume tho the scanning information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @vol_id: ID of the volume to add
+ * @pnum: physical eraseblock number
+ * @vid_hdr: volume identifier header
+ * @vol_info: a pointer to the corresponding volume scanning information is
+ * returned here.
+ *
+ * If the volume corresponding to the @vid_hdr logical eraseblock is already
+ * present in the scanning information, this function does nothing. Otherwise
+ * it adds corresponding volume to the scanning information. Returns the a
+ * pointer to the scanning volume object in case of success and a negative
+ * error code in case of failure.
+ */
+static struct ubi_scan_volume  *add_volume(const struct ubi_info *ubi,
+					   struct ubi_scan_info *si, int vol_id,
+					   int pnum,
+					   const struct ubi_vid_hdr *vid_hdr)
+{
+	struct ubi_scan_volume *sv;
+	struct rb_node **p = &si->volumes.rb_node, *parent = NULL;
+
+	ubi_assert(vol_id == ubi32_to_cpu(vid_hdr->vol_id));
+
+	/*
+	 * Walk the volume RB-tree to look if a volume @vol_id is already
+	 * present there.
+	 */
+	while (*p) {
+		parent = *p;
+		sv = rb_entry(parent, struct ubi_scan_volume, rb);
+
+		if (vol_id == sv->vol_id)
+			return sv;
+
+		if (vol_id > sv->vol_id)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	/* The volume is absent - add it */
+
+	sv = ubi_alloc_scan_volume();
+	if (unlikely(!sv))
+		return ERR_PTR(-ENOMEM);
+
+	sv->highest_lnum = sv->leb_count = 0;
+	sv->vol_id = vol_id;
+	sv->root = RB_ROOT;
+	sv->used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
+	sv->data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+	sv->compat = vid_hdr->compat;
+	sv->vol_type = vid_hdr->vol_type == UBI_VID_DYNAMIC ? UBI_DYNAMIC_VOLUME
+							    : UBI_STATIC_VOLUME;
+	if (vol_id > si->highest_vol_id)
+		si->highest_vol_id = vol_id;
+
+	rb_link_node(&sv->rb, parent, p);
+	rb_insert_color(&sv->rb, &si->volumes);
+	si->vols_found += 1;
+	dbg_scan("added volume %d", vol_id);
+	return sv;
+}
+
+/**
+ * compare_lebs - find out which logical eraseblock is newer.
+ *
+ * @ubi: the UBI device description object
+ * @seb: the first logical eraseblock to compare
+ * @pnum: the physical eraseblock number of the second logical eraseblock to
+ * compare
+ * @vid_hdr: the volume identifier header of the second logical eraseblock
+ *
+ * This function compares versions of 2 copies of a LEB and informs which one
+ * is newer. In case of success this function returns a positive value, in case
+ * of error, a negative error code is returned. The success return codes use
+ * the following bits:
+ *     o bit 0 is cleared: the first PEB (described by @seb) is newer then the
+ *       second PEB (described by @pnum and @vid_hdr);
+ *     o bit 0 is set: the second PEB is newer;
+ *     o bit 1 is cleared: no bit-flips were detected in the newer PEB;
+ *     o bit 1 is set: bit-flips were detected in the newer PEB;
+ *     o bit 2 is cleared: the older PEB is not corrupted;
+ *     o bit 2 is set: the older PEB is not corrupted.
+ */
+static int compare_lebs(const struct ubi_info *ubi,
+			const struct ubi_scan_leb *seb, int pnum,
+			const struct ubi_vid_hdr *vid_hdr)
+{
+	void *buf;
+	int len, err, second_is_newer, bitflips = 0, corrupted = 0;
+	uint32_t data_crc, crc;
+	long long abs, v1 = seb->leb_ver, v2 = ubi32_to_cpu(vid_hdr->leb_ver);
+	struct ubi_vid_hdr *vidh = NULL;
+
+	/*
+	 * UBI constantly increases the logical eraseblock version number and
+	 * it can overflow. Thus, we have to bear in mind that versions that
+	 * are close to %0xFFFFFFFF are less then versions that are close to
+	 * %0.
+	 *
+	 * The UBI WL unit guarantees that the number of pending tasks is not
+	 * greater then %0x7FFFFFFF. So, if the difference between any two
+	 * versions is greater or equivalent to %0x7FFFFFFF, there was an
+	 * overflow and the logical eraseblock with lower version is actually
+	 * newer then the one with higher version.
+	 */
+
+	abs = v1 - v2;
+	if (abs < 0)
+		abs = -abs;
+
+	if (likely(abs < 0x7FFFFFFF))
+		/* Non-overflow situation */
+		second_is_newer = (v2 > v1);
+	else
+		second_is_newer = (v2 < v1);
+
+	/*
+	 * Now we know which copy is newer. If the copy flag of the PEB with
+	 * newer version is not set, then we just return, otherwise we have to
+	 * check data CRC. For the second PEB we already have the VID header,
+	 * for the first one - we'll need to re-read it from flash.
+	 *
+	 * FIXME: this may be optimized so that we wouldn't read twice.
+	 */
+
+	if (second_is_newer) {
+		if (!vid_hdr->copy_flag) {
+			/* It is not a copy, so it is newer */
+			dbg_scan("second PEB %d is newer, copy_flag is unset",
+				 pnum);
+			return 1;
+		}
+	} else {
+		pnum = seb->pnum;
+
+		vidh = ubi_zalloc_vid_hdr(ubi);
+		if (!vidh)
+			return -ENOMEM;
+
+		err = ubi_io_read_vid_hdr(ubi, pnum, vidh, 0);
+		if (unlikely(err)) {
+			if (err == UBI_IO_BITFLIPS)
+				bitflips = 1;
+			else {
+				dbg_err("VID of PEB %d header is bad, but it "
+					"was OK earlier", pnum);
+				if (err > 0)
+					err = -EIO;
+
+				goto out_free_vidh;
+			}
+		}
+
+		if (!vidh->copy_flag) {
+			/* It is not a copy, so it is newer */
+			dbg_scan("first PEB %d is newer, copy_flag is unset",
+				 pnum);
+			err = bitflips << 1;
+			goto out_free_vidh;
+		}
+
+		vid_hdr = vidh;
+	}
+
+	/* Read the data of the copy and check the CRC */
+
+	len = ubi32_to_cpu(vid_hdr->data_size);
+	buf = ubi_kmalloc(len);
+	if (unlikely(!buf)) {
+		err = -ENOMEM;
+		goto out_free_vidh;
+	}
+
+	err = ubi_io_read_data(ubi, buf, pnum, 0, len);
+	if (unlikely(err && err != UBI_IO_BITFLIPS))
+		goto out_free_buf;
+
+	data_crc = ubi32_to_cpu(vid_hdr->data_crc);
+	crc = crc32(UBI_CRC32_INIT, buf, len);
+	if (unlikely(crc != data_crc)) {
+		dbg_scan("PEB %d CRC error: calculated %#08x, must be %#08x",
+			 pnum, crc, data_crc);
+		corrupted = 1;
+		bitflips = 0;
+		second_is_newer = !second_is_newer;
+	} else {
+		dbg_scan("PEB %d CRC is OK", pnum);
+		bitflips = !!err;
+	}
+
+	ubi_kfree(buf);
+	ubi_free_vid_hdr(ubi, vidh);
+
+	if (second_is_newer)
+		dbg_scan("second PEB %d is newer, copy_flag is set", pnum);
+	else
+		dbg_scan("first PEB %d is newer, copy_flag is set", pnum);
+
+	return second_is_newer | (bitflips << 1) | (corrupted << 2);
+
+out_free_buf:
+	ubi_kfree(buf);
+out_free_vidh:
+	ubi_free_vid_hdr(ubi, vidh);
+	return err;
+}
+
+/**
+ * add_to_erase - add a physical eraseblock to the list of physical eraseblocks
+ * which have to be erased.
+ *
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ * @ec: erase counter of this physical eraseblock
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int add_to_erase(struct ubi_scan_info *si, int pnum, int ec)
+{
+	struct ubi_scan_leb *seb;
+
+	dbg_scan("PEB %d, EC %d", pnum, ec);
+
+	seb = ubi_alloc_scan_leb();
+	if (unlikely(!seb))
+		return -ENOMEM;
+
+	seb->pnum = pnum;
+	seb->ec = ec;
+	list_add_tail(&seb->u.list, &si->erase);
+	return 0;
+}
+
+/**
+ * add_to_alien - add a physical eraseblock to the @si->alien list.
+ *
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ *
+ * This function returns zero in case of success and a negative error
+ * code in case of failure.
+ */
+static int add_to_alien(struct ubi_scan_info *si, int pnum)
+{
+	struct ubi_scan_leb *seb;
+
+	dbg_scan("PEB %d is alien", pnum);
+
+	seb = ubi_alloc_scan_leb();
+	if (unlikely(!seb))
+		return -ENOMEM;
+
+	seb->pnum = pnum;
+	list_add_tail(&seb->u.list, &si->alien);
+	return 0;
+}
+
+/**
+ * add_to_free - add a physical eraseblock to the list of free physical
+ * eraseblocks.
+ *
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ * @ec: erase counter of this physical eraseblock
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int add_to_free(struct ubi_scan_info *si, int pnum, int ec)
+{
+	struct ubi_scan_leb *seb;
+
+	dbg_scan("PEB %d, EC %d", pnum, ec);
+	ubi_assert(ec >= 0);
+
+	seb = ubi_alloc_scan_leb();
+	if (unlikely(!seb))
+		return -ENOMEM;
+
+	seb->pnum = pnum;
+	seb->ec = ec;
+	list_add_tail(&seb->u.list, &si->free);
+	return 0;
+}
+
+/**
+ * destroy_sv - free the scanning volume information
+ *
+ * @sv: scanning volume information
+ *
+ * This function destroys the volume RB-tree (@sv->root) and the scanning
+ * volume information.
+ */
+static void destroy_sv(struct ubi_scan_volume *sv)
+{
+	struct ubi_scan_leb *seb;
+	struct rb_node *this = sv->root.rb_node;
+
+	while (this) {
+		if (this->rb_left)
+			this = this->rb_left;
+		else if (this->rb_right)
+			this = this->rb_right;
+		else {
+			seb = rb_entry(this, struct ubi_scan_leb, u.rb);
+			this = rb_parent(this);
+			if (this) {
+				if (this->rb_left == &seb->u.rb)
+					this->rb_left = NULL;
+				else
+					this->rb_right = NULL;
+			}
+
+			ubi_free_scan_leb(seb);
+		}
+	}
+	ubi_free_scan_volume(sv);
+}
+
+/**
+ * commit_to_mean_value - commit intermediate results to the final mean erase
+ * counter value.
+ *
+ * @si: the scanning information
+ *
+ * This function is a helper function which calculates partial mean value and
+ * adds it to the resulting mean value. As we can work only in integer
+ * arithmetic and we want to calculate the mean value of erase counter
+ * accurately, we first sum erase counter values in @si->ec_sum variable and
+ * count these components in @si->ec_count. If this temporary @si->ec_sum is
+ * going to overflow, we calculate the partial mean value
+ * (@si->ec_sum/@si->ec_count) and add it to @si->mean_ec.
+ */
+static void commit_to_mean_value(struct ubi_scan_info *si)
+{
+	int rem;
+
+	rem = si->ec_sum % si->ec_count;
+	si->ec_sum /= si->ec_count;
+	if (rem >= si->ec_count / 2)
+		si->mean_ec += 1;
+	si->mean_ec += si->ec_sum;
+}
+
+/**
+ * vid_hdr_sanity_check - check that a volume identifier header is sane.
+ *
+ * @ubi: the UBI device description object
+ * @vid_hdr: the volume identifier header to check
+ * @sv: information about the volume this logical eraseblock belongs to
+ * @pnum: the physical eraseblock number the VID header came from
+ *
+ * This function checks that data stored in the volume identifier header
+ * @vid_hdr is consistent. This function returns non-zero if an inconsistency
+ * was found and zero if not.
+ *
+ * Note, UBI does sanity check of everything it reads from the flash media.
+ * Most of the checks are done in the I/O unit. Here we check that the
+ * information in this VID header is consistent to information in other VID
+ * headers of the same volume.
+ */
+static int vid_hdr_sanity_check(const struct ubi_info *ubi,
+				const struct ubi_vid_hdr *vid_hdr,
+				const struct ubi_scan_volume *sv, int pnum)
+{
+	int vol_type = vid_hdr->vol_type;
+	int vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	int used_ebs = ubi32_to_cpu(vid_hdr->used_ebs);
+	int data_pad = ubi32_to_cpu(vid_hdr->data_pad);
+
+	if (sv->leb_count != 0) {
+		/*
+		 * This is not the first logical eraseblock belonging to this
+		 * volume. Ensure that the data in its VID header is consistent
+		 * to the data in previous logical eraseblocks' headers.
+		 */
+		int sv_vol_type;
+
+		if (unlikely(vol_id != sv->vol_id)) {
+			dbg_err("inconsistent vol_id");
+			goto bad;
+		}
+
+		if (sv->vol_type == UBI_STATIC_VOLUME)
+			sv_vol_type = UBI_VID_STATIC;
+		else
+			sv_vol_type = UBI_VID_DYNAMIC;
+
+		if (unlikely(vol_type != sv_vol_type)) {
+			dbg_err("inconsistent vol_type");
+			goto bad;
+		}
+
+		if (unlikely(used_ebs != sv->used_ebs)) {
+			dbg_err("inconsistent used_ebs");
+			goto bad;
+		}
+
+		if (unlikely(data_pad != sv->data_pad)) {
+			dbg_err("inconsistent data_pad");
+			goto bad;
+		}
+	}
+
+	return 0;
+
+bad:
+	ubi_err("bad VID header at PEB %d", pnum);
+	ubi_dbg_dump_vid_hdr(vid_hdr);
+	ubi_dbg_dump_sv(sv);
+	return -EINVAL;
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_SCAN
+
+/**
+ * paranoid_check_si - check if the scanning information is sane and correct.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero if the scanning information is all right, %1 if
+ * not and a negative error code if an error occurred.
+ */
+static int paranoid_check_si(const struct ubi_info *ubi,
+			     struct ubi_scan_info *si)
+{
+	int pnum, err, vols_found = 0;
+	struct rb_node *rb1, *rb2;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *seb, *last_seb;
+	const struct ubi_io_info *io = ubi->io;
+	uint8_t *buf;
+
+	/*
+	 * At first, check that scanning information is sane.
+	 */
+	rb_for_each_entry(rb1, sv, &si->volumes, rb) {
+		int leb_count = 0;
+
+		cond_resched();
+
+		vols_found += 1;
+
+		if (unlikely(si->is_empty)) {
+			ubi_err("bad is_empty flag");
+			goto bad_sv;
+		}
+
+		if (unlikely(sv->vol_id < 0 || sv->highest_lnum < 0 ||
+			     sv->leb_count < 0 || sv->vol_type < 0 ||
+			     sv->used_ebs < 0 || sv->data_pad < 0 ||
+			     sv->last_data_size < 0)) {
+			ubi_err("negative values");
+			goto bad_sv;
+		}
+
+		if (unlikely(sv->vol_id >= UBI_MAX_VOLUMES &&
+			     sv->vol_id < UBI_INTERNAL_VOL_START)) {
+			ubi_err("bad vol_id");
+			goto bad_sv;
+		}
+
+		if (unlikely(sv->vol_id > si->highest_vol_id)) {
+			ubi_err("highest_vol_id is %d, but vol_id %d is there",
+				si->highest_vol_id, sv->vol_id);
+			goto out;
+		}
+
+		if (unlikely(sv->vol_type != UBI_DYNAMIC_VOLUME &&
+			     sv->vol_type != UBI_STATIC_VOLUME)) {
+			ubi_err("bad vol_type");
+			goto bad_sv;
+		}
+
+		if (unlikely(sv->data_pad > io->leb_size / 2)) {
+			ubi_err("bad data_pad");
+			goto bad_sv;
+		}
+
+		last_seb = NULL;
+		rb_for_each_entry(rb2, seb, &sv->root, u.rb) {
+			cond_resched();
+
+			last_seb = seb;
+			leb_count += 1;
+
+			if (unlikely(seb->pnum < 0 || seb->ec < 0)) {
+				ubi_err("negative values");
+				goto bad_seb;
+			}
+
+			if (unlikely(seb->ec < si->min_ec)) {
+				ubi_err("bad si->min_ec (%d), %d found",
+					si->min_ec, seb->ec);
+				goto bad_seb;
+			}
+
+			if (unlikely(seb->ec > si->max_ec)) {
+				ubi_err("bad si->max_ec (%d), %d found",
+					si->max_ec, seb->ec);
+				goto bad_seb;
+			}
+
+			if (unlikely(seb->pnum >= io->peb_count)) {
+				ubi_err("too high PEB number %d, total PEBs %d",
+					seb->pnum, io->peb_count);
+				goto bad_seb;
+			}
+
+			if (sv->vol_type == UBI_STATIC_VOLUME) {
+				if (unlikely(seb->lnum >= sv->used_ebs)) {
+					ubi_err("bad lnum or used_ebs");
+					goto bad_seb;
+				}
+			} else {
+				if (unlikely(sv->used_ebs != 0)) {
+					ubi_err("non-zero used_ebs");
+					goto bad_seb;
+				}
+			}
+
+			if (unlikely(seb->lnum > sv->highest_lnum)) {
+				ubi_err("incorrect highest_lnum or lnum");
+				goto bad_seb;
+			}
+		}
+
+		if (unlikely(sv->leb_count != leb_count)) {
+			ubi_err("bad leb_count, %d objects in the tree",
+				leb_count);
+			goto bad_sv;
+		}
+
+		if (!last_seb)
+			continue;
+
+		seb = last_seb;
+
+		if (unlikely(seb->lnum != sv->highest_lnum)) {
+			ubi_err("bad highest_lnum");
+			goto bad_seb;
+		}
+	}
+
+	if (vols_found != si->vols_found) {
+		ubi_err("bad si->vols_found %d, should be %d",
+			si->vols_found, vols_found);
+		goto out;
+	}
+
+	/* Check that scanning information is correct */
+	rb_for_each_entry(rb1, sv, &si->volumes, rb) {
+		last_seb = NULL;
+		rb_for_each_entry(rb2, seb, &sv->root, u.rb) {
+			int vol_type;
+
+			cond_resched();
+
+			last_seb = seb;
+
+			err = ubi_io_read_vid_hdr(ubi, seb->pnum, vidh, 1);
+			if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+				ubi_err("VID header is not OK (%d)", err);
+				if (err > 0)
+					err = -EIO;
+				return err;
+			}
+
+			vol_type = vidh->vol_type == UBI_VID_DYNAMIC ?
+				   UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
+			if (unlikely(sv->vol_type != vol_type)) {
+				ubi_err("bad vol_type");
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(seb->leb_ver !=
+				     ubi32_to_cpu(vidh->leb_ver))) {
+				ubi_err("bad leb_ver %u", seb->leb_ver);
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(sv->vol_id !=
+				     ubi32_to_cpu(vidh->vol_id))) {
+				ubi_err("bad vol_id %d", sv->vol_id);
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(sv->compat != vidh->compat)) {
+				ubi_err("bad compat %d", vidh->compat);
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(seb->lnum !=
+				     ubi32_to_cpu(vidh->lnum))) {
+				ubi_err("bad lnum %d", seb->lnum);
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(sv->used_ebs !=
+				     ubi32_to_cpu(vidh->used_ebs))) {
+				ubi_err("bad used_ebs %d", sv->used_ebs);
+				goto bad_vid_hdr;
+			}
+
+			if (unlikely(sv->data_pad !=
+				     ubi32_to_cpu(vidh->data_pad))) {
+				ubi_err("bad data_pad %d", sv->data_pad);
+				goto bad_vid_hdr;
+			}
+		}
+
+		if (!last_seb)
+			continue;
+
+		if (unlikely(sv->highest_lnum != ubi32_to_cpu(vidh->lnum))) {
+			ubi_err("bad highest_lnum %d", sv->highest_lnum);
+			goto bad_vid_hdr;
+		}
+
+		if (unlikely(sv->last_data_size !=
+			     ubi32_to_cpu(vidh->data_size))) {
+			ubi_err("bad last_data_size %d", sv->last_data_size);
+			goto bad_vid_hdr;
+		}
+	}
+
+	/*
+	 * Make sure that all the physical eraseblocks are in one of the lists
+	 * or trees.
+	 */
+	buf = ubi_kmalloc(io->peb_count);
+	if (!buf)
+		return -ENOMEM;
+
+	memset(buf, 1, io->peb_count);
+	for (pnum = 0; pnum < io->peb_count; pnum++) {
+		err = ubi_io_is_bad(ubi, pnum);
+		if (unlikely(err < 0))
+			return err;
+		else if (err)
+			buf[pnum] = 0;
+	}
+
+	rb_for_each_entry(rb1, sv, &si->volumes, rb)
+		rb_for_each_entry(rb2, seb, &sv->root, u.rb)
+			buf[seb->pnum] = 0;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->free, u.list)
+		buf[seb->pnum] = 0;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->corr, u.list)
+		buf[seb->pnum] = 0;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->erase, u.list)
+		buf[seb->pnum] = 0;
+
+	cond_resched();
+	list_for_each_entry(seb, &si->alien, u.list)
+		buf[seb->pnum] = 0;
+
+	err = 0;
+	for (pnum = 0; pnum < io->peb_count; pnum++)
+		if (unlikely(buf[pnum])) {
+			ubi_err("PEB %d is not referred", pnum);
+			err = 1;
+		}
+
+	ubi_kfree(buf);
+	if (err)
+		goto out;
+	return 0;
+
+bad_seb:
+	ubi_err("bad scanning information about LEB %d", seb->lnum);
+	ubi_dbg_dump_seb(seb, 0);
+	ubi_dbg_dump_sv(sv);
+	goto out;
+
+bad_sv:
+	ubi_err("bad scanning information about volume %d", sv->vol_id);
+	ubi_dbg_dump_sv(sv);
+	goto out;
+
+bad_vid_hdr:
+	ubi_err("bad scanning information about volume %d", sv->vol_id);
+	ubi_dbg_dump_sv(sv);
+	ubi_dbg_dump_vid_hdr(vidh);
+
+out:
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_SCAN */
