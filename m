Return-Path: <linux-kernel-owner+w=401wt.eu-S2992732AbXBQRIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992732AbXBQRIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992728AbXBQRIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:08:30 -0500
Received: from smtp.nokia.com ([131.228.20.171]:55126 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965347AbXBQQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:47 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:25 +0200
Message-Id: <20070217165625.5845.54721.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 24/44 take 2] [UBI] wear-leveling unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:52.0769 (UTC) FILETIME=[7BC8B310:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185416-3C65FBB0-04F3B3C7/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/wl.c tmp-to/drivers/mtd/ubi/wl.c
--- tmp-from/drivers/mtd/ubi/wl.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/wl.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,1684 @@
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
+ * Authors: Artem B. Bityutskiy, Thomas Gleixner
+ */
+
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/wait.h>
+#include <linux/crc32.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "wl.h"
+#include "badeb.h"
+#include "io.h"
+#include "account.h"
+#include "eba.h"
+#include "background.h"
+#include "scan.h"
+#include "misc.h"
+#include "debug.h"
+
+/* Number of physical eraseblocks reserved for wear-leveling purposes */
+#define WL_RESERVED_PEBS 1
+
+/*
+ * How many erase cycles are short term, unknown, and long term physical
+ * eraseblocks protected.
+ */
+#define ST_PROTECTION 16
+#define U_PROTECTION  10
+#define LT_PROTECTION 4
+
+/*
+ * Maximum difference between two erase counters. If this threshold is
+ * exceeded, the WL unit starts moving data from used physical eraseblocks with
+ * low erase counter to free physical eraseblocks with high erase counter.
+ */
+#define UBI_WL_THRESHOLD CONFIG_MTD_UBI_WL_THRESHOLD
+
+/*
+ * When a physical eraseblock is moved, the WL unit has to pick the target
+ * physical eraseblock to move to. The simplest way would be just to pick the
+ * one with the highest erase counter. But in certain workload this could lead
+ * to an unbounded wearing of one or few physical eraseblock. Indeed, imagine a
+ * situation when the picked physical eraseblock is constantly erased after the
+ * data is written to it. So, we have a constant which limits the highest
+ * erase counter of the free physical eraseblock to pick. Namely, the WL unit
+ * does not pick eraseblocks with erase counter greater then the lowest erase
+ * counter plus %WL_FREE_MAX_DIFF.
+ */
+#define WL_FREE_MAX_DIFF (2*UBI_WL_THRESHOLD)
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_WL
+static int paranoid_check_ec(const struct ubi_info *ubi, int pnum, int ec);
+static int paranoid_check_in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root);
+#else
+#define paranoid_check_ec(ubi, pnum, ec) 0
+#define paranoid_check_in_wl_tree(e, root)
+#endif
+
+/**
+ * tree_empty - a helper function to check if an RB-tree is empty.
+ *
+ * @root: the root of the tree
+ *
+ * This function returns non-zero if the tree is empty and zero if not.
+ */
+static inline int tree_empty(struct rb_root *root)
+{
+	return root->rb_node == NULL;
+}
+
+static void wl_tree_add(struct ubi_wl_entry *e, struct rb_root *root);
+
+/* Functions to add and delete wear-leveling entries from different trees */
+
+static inline void free_tree_add(struct ubi_wl_info *wl,
+				 struct ubi_wl_entry *e)
+{
+	wl_tree_add(e, &wl->free);
+}
+static inline void used_tree_add(struct ubi_wl_info *wl,
+				 struct ubi_wl_entry *e)
+{
+	wl_tree_add(e, &wl->used);
+}
+static inline void scrub_tree_add(struct ubi_wl_info *wl,
+				  struct ubi_wl_entry *e)
+{
+	wl_tree_add(e, &wl->scrub);
+}
+
+static inline void free_tree_del(struct ubi_wl_info *wl,
+				 struct ubi_wl_entry *e)
+{
+	paranoid_check_in_wl_tree(e, &wl->free);
+	rb_erase(&e->rb, &wl->free);
+}
+static inline void used_tree_del(struct ubi_wl_info *wl,
+				 struct ubi_wl_entry *e)
+{
+	paranoid_check_in_wl_tree(e, &wl->used);
+	rb_erase(&e->rb, &wl->used);
+}
+static inline void scrub_tree_del(struct ubi_wl_info *wl,
+				  struct ubi_wl_entry *e)
+{
+	paranoid_check_in_wl_tree(e, &wl->scrub);
+	rb_erase(&e->rb, &wl->scrub);
+}
+
+static int produce_free(const struct ubi_info *ubi);
+static struct ubi_wl_entry *pick_long_term(struct ubi_wl_info *wl);
+static struct ubi_wl_entry *pick_unknown(struct ubi_wl_info *wl);
+static struct ubi_wl_entry *pick_short_term(struct ubi_wl_info *wl);
+static void prot_tree_add(struct ubi_wl_info *wl, struct ubi_wl_entry *e,
+			  struct ubi_wl_prot_entry *pe, int abs_ec);
+
+int ubi_wl_get_peb(const struct ubi_info *ubi, enum ubi_data_type dtype)
+{
+	int err, protect;
+	struct ubi_wl_entry *e;
+	struct ubi_wl_info *wl = ubi->wl;
+	struct ubi_wl_prot_entry *pe;
+
+	might_sleep();
+
+	/* Input arguments sanity check */
+	ubi_assert(dtype == UBI_DATA_LONGTERM || dtype == UBI_DATA_SHORTTERM ||
+		   dtype == UBI_DATA_UNKNOWN);
+
+	pe = ubi_alloc_wl_prot_entry();
+	if (unlikely(!pe))
+		return -ENOMEM;
+
+retry:
+	spin_lock(&wl->lock);
+	if (unlikely(tree_empty(&wl->free))) {
+		if (unlikely(wl->erase_pending == 0)) {
+			ubi_err("no free eraseblocks");
+			spin_unlock(&wl->lock);
+			ubi_free_wl_prot_entry(pe);
+			return -ENOSPC;
+		}
+		spin_unlock(&wl->lock);
+
+		err = produce_free(ubi);
+		if (unlikely(err < 0)) {
+			ubi_free_wl_prot_entry(pe);
+			return err;
+		}
+		goto retry;
+	}
+
+	switch (dtype) {
+		case UBI_DATA_LONGTERM:
+			e = pick_long_term(wl);
+			protect = LT_PROTECTION;
+			break;
+		case UBI_DATA_UNKNOWN:
+			e = pick_unknown(wl);
+			protect = U_PROTECTION;
+			break;
+		case UBI_DATA_SHORTTERM:
+			e = pick_short_term(wl);
+			protect = ST_PROTECTION;
+			break;
+		default:
+			protect = 0;
+			e = NULL;
+			BUG();
+	}
+
+	/*
+	 * Move the physical eraseblock to the protection trees where it will
+	 * be protected from being moved for some time.
+	 */
+	free_tree_del(wl, e);
+	prot_tree_add(wl, e, pe, protect);
+
+	dbg_wl("PEB %d EC %d, protection %d", e->pnum, e->ec, protect);
+	spin_unlock(&wl->lock);
+
+	return e->pnum;
+}
+
+static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root);
+static int schedule_erase(const struct ubi_info *ubi, struct ubi_wl_entry *e,
+			  int torture);
+static void check_protection_over(struct ubi_wl_info *wl);
+static void prot_tree_del(struct ubi_wl_info *wl, int pnum);
+
+int ubi_wl_put_peb(const struct ubi_info *ubi, int pnum, int torture)
+{
+	int err;
+	struct ubi_wl_entry *e;
+	struct ubi_wl_info *wl = ubi->wl;
+
+	dbg_wl("PEB %d", pnum);
+	might_sleep();
+
+	/* Input arguments sanity check */
+	ubi_assert(pnum >= 0);
+	ubi_assert(pnum < ubi->io->peb_count);
+
+	spin_lock(&wl->lock);
+	ubi_assert(wl->erase_pending >= 0);
+	wl->erase_pending += 1;
+
+	e = wl->lookuptbl[pnum];
+	if (unlikely(e == wl->move)) {
+		/*
+		 * User is putting a physical eraseblock which was selected to
+		 * be moved. We cancel the movement by setting @wl->move to
+		 * %NULL. The wear-leveling worker has to notice this and
+		 * cancel.
+		 *
+		 * Note, the physical eraseblock was removed from the @wl->used
+		 * tree by the wear-leveling worker and is not in any tree now.
+		 */
+		dbg_wl("cancel PEB %d movement", pnum);
+		wl->move = NULL;
+	} else {
+		if (in_wl_tree(e, &wl->used))
+			used_tree_del(wl, e);
+		else if (unlikely(in_wl_tree(e, &wl->scrub)))
+			scrub_tree_del(wl, e);
+		else
+			prot_tree_del(wl, e->pnum);
+	}
+	spin_unlock(&wl->lock);
+
+	err = schedule_erase(ubi, e, torture);
+	if (unlikely(err)) {
+		spin_lock(&wl->lock);
+		wl->erase_pending -= 1;
+		used_tree_add(wl, e);
+		spin_unlock(&wl->lock);
+	}
+
+	return err;
+}
+
+static int ensure_wear_leveling(const struct ubi_info *ubi);
+
+int ubi_wl_scrub_peb(const struct ubi_info *ubi, int pnum)
+{
+	struct ubi_wl_entry *e;
+	struct ubi_wl_info *wl = ubi->wl;
+
+	dbg_wl("schedule PEB %d for scrubbing", pnum);
+
+	spin_lock(&wl->lock);
+	e = wl->lookuptbl[pnum];
+	if (e == wl->move || in_wl_tree(e, &wl->scrub)) {
+		spin_unlock(&wl->lock);
+		return 0;
+	}
+
+	if (in_wl_tree(e, &wl->used))
+		used_tree_del(wl, e);
+	else
+		prot_tree_del(wl, pnum);
+
+	scrub_tree_add(wl, e);
+	spin_unlock(&wl->lock);
+
+	/*
+	 * Technically scrubbing is the same as wear-levelling, so it is done
+	 * by the WL worker. Schedule it.
+	 */
+	return ensure_wear_leveling(ubi);
+}
+
+static int erase_worker(const struct ubi_info *ubi, struct ubi_bgt_work *wrk,
+			int cancel);
+
+int ubi_wl_flush(const struct ubi_info *ubi)
+{
+	int err, pending_count;
+
+	pending_count = ubi->bgt->pending_works_count;
+
+	dbg_wl("flush (%d pending works)", pending_count);
+
+	/*
+	 * Erase while the pending works queue is not empty, but not more then
+	 * the number of currently pending works.
+	 */
+	while (pending_count-- > 0) {
+		err = ubi_bgt_do_work(ubi);
+		if (unlikely(err))
+			return err;
+	}
+
+	return 0;
+}
+
+static void tree_destroy(struct rb_root *root);
+
+int ubi_wl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err;
+	struct rb_node *rb1, *rb2;
+	struct ubi_scan_volume *sv;
+	struct ubi_scan_leb *seb, *tmp;
+	struct ubi_wl_entry *e;
+	struct ubi_wl_info *wl;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_wl("initialize the UBI wear-leveling unit");
+
+	wl = ubi_kzalloc(sizeof(struct ubi_wl_info));
+	if (!wl)
+		return -ENOMEM;
+	ubi->wl = wl;
+
+	wl->used = wl->free = wl->scrub = RB_ROOT;
+	wl->prot.pnum = wl->prot.aec = RB_ROOT;
+	spin_lock_init(&wl->lock);
+	wl->max_ec = si->max_ec;
+
+	err = -ENOMEM;
+	wl->lookuptbl = ubi_kzalloc(io->peb_count * sizeof(void *));
+	if (!wl->lookuptbl)
+		goto out_free;
+
+	/*
+	 * The way how we distinguish between older LEB and newer LEB is based
+	 * on the following principles:
+	 * 1 if we have LEB with versions A and B, A < B, then B is newer then
+	 *   A when abs(B - A) < %0x7FFFFFFF
+	 * 2 as the WL unit guarantees that the length of the pending works
+	 *   queue is shorter then %0x7FFFFFFF works, and the works are put at
+	 *   the tail of the queue and got from its head, the above algorithm
+	 *   works correctly.
+	 *
+	 * Now we've got a list of eraseblocks to erase, and they are now
+	 * out-of-order, which does not satisfy the 2nd item, so we've got to
+	 * erase them now instead of deferring this.
+	 */
+	list_for_each_entry_safe(seb, tmp, &si->erase, u.list) {
+		cond_resched();
+
+		dbg_wl("erase PEB %d", seb->pnum);
+		err = ubi_scan_erase_peb(ubi, si, seb->pnum, seb->ec + 1);
+		if (unlikely(err)) {
+			if (err != -EIO && err != -EROFS)
+				goto out_free;
+			list_del(&seb->u.list);
+			list_add_tail(&seb->u.list, &si->corr);
+		} else {
+			seb->ec += 1;
+			list_del(&seb->u.list);
+			list_add_tail(&seb->u.list, &si->free);
+		}
+	}
+
+	list_for_each_entry(seb, &si->free, u.list) {
+		cond_resched();
+
+		e = ubi_alloc_wl_entry();
+		if (unlikely(!e))
+			goto out_free;
+
+		e->pnum = seb->pnum;
+		e->ec = seb->ec;
+		ubi_assert(e->ec >= 0);
+		free_tree_add(wl, e);
+		wl->lookuptbl[e->pnum] = e;
+	}
+
+	list_for_each_entry(seb, &si->corr, u.list) {
+		cond_resched();
+
+		e = ubi_alloc_wl_entry();
+		if (unlikely(!e)) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		e->pnum = seb->pnum;
+		e->ec = seb->ec;
+		wl->lookuptbl[e->pnum] = e;
+		wl->erase_pending += 1;
+		err = schedule_erase(ubi, e, 0);
+		if (unlikely(err)) {
+			ubi_free_wl_entry(e);
+			goto out_free;
+		}
+	}
+
+	rb_for_each_entry(rb1, sv, &si->volumes, rb) {
+		rb_for_each_entry(rb2, seb, &sv->root, u.rb) {
+			cond_resched();
+
+			e = ubi_alloc_wl_entry();
+			if (unlikely(!e))
+				goto out_free;
+
+			e->pnum = seb->pnum;
+			e->ec = seb->ec;
+			wl->lookuptbl[e->pnum] = e;
+			if (!seb->scrub) {
+				dbg_wl("add PEB %d EC %d to the used tree",
+				       e->pnum, e->ec);
+				used_tree_add(wl, e);
+			} else {
+				dbg_wl("add PEB %d EC %d to the scrub tree",
+				       e->pnum, e->ec);
+				scrub_tree_add(wl, e);
+			}
+		}
+	}
+
+	err = ubi_acc_reserve(ubi, WL_RESERVED_PEBS);
+	if (err)
+		goto out_free;
+
+	/* Schedule wear-leveling if needed */
+	err = ensure_wear_leveling(ubi);
+	if (err)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	tree_destroy(&wl->used);
+	tree_destroy(&wl->free);
+	tree_destroy(&wl->scrub);
+	ubi_kfree(wl->lookuptbl);
+	ubi_kfree(wl);
+	return err;
+}
+
+static void protection_trees_destroy(struct ubi_wl_info *wl);
+
+void ubi_wl_close(struct ubi_info *ubi)
+{
+	struct ubi_wl_info *wl = ubi->wl;
+
+	dbg_wl("close the UBI wear-leveling unit");
+
+	protection_trees_destroy(wl);
+	tree_destroy(&wl->used);
+	tree_destroy(&wl->free);
+	tree_destroy(&wl->scrub);
+	ubi_kfree(wl->lookuptbl);
+	ubi_kfree(wl);
+}
+
+/**
+ * find_wl_entry - find a wl entry closest to certain erase counter.
+ *
+ * @root: the RB-tree where to look for
+ * @max: highest erase possible counter
+ *
+ * This function looks for a wear leveling entry erase counter closest to @max
+ * and less then @max.
+ */
+static struct ubi_wl_entry *find_wl_entry(struct rb_root *root, int max)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e;
+
+	e = rb_entry(rb_first(root), struct ubi_wl_entry, rb);
+	max += e->ec;
+
+	p = root->rb_node;
+	while (p) {
+		struct ubi_wl_entry *e1;
+
+		e1 = rb_entry(p, struct ubi_wl_entry, rb);
+		if (e1->ec >= max)
+			p = p->rb_left;
+		else {
+			p = p->rb_right;
+			e = e1;
+		}
+	}
+
+	return e;
+}
+
+/**
+ * pick_long_term - select a "long-term" physical eraseblock.
+ *
+ * @wl: the wear-leveling unit description data structure
+ *
+ * This function returns the requested physical eraseblock. The wl->lock must
+ * be locked. The @wl->free list must not be empty.
+ */
+static struct ubi_wl_entry *pick_long_term(struct ubi_wl_info *wl)
+{
+	struct ubi_wl_entry *e;
+
+	/*
+	 * For long term data we pick a physical eraseblock with high erase
+	 * counter. But the highest erase counter we can pick is bounded by
+	 * the the lowest erase counter plus %WL_FREE_MAX_DIFF.
+	 */
+	e = find_wl_entry(&wl->free, WL_FREE_MAX_DIFF);
+	return e;
+}
+
+/**
+ * pick_unknown - select an "unknown" physical eraseblock.
+ *
+ * @wl: the wear-leveling unit description data structure
+ *
+ * This function returns the requested physical eraseblock. The wl->lock must
+ * be locked. The @wl->free list must not be empty.
+ */
+static struct ubi_wl_entry *pick_unknown(struct ubi_wl_info *wl)
+{
+	int medium_ec;
+	struct rb_node *p;
+	struct ubi_wl_entry *first, *last, *e;
+
+	/*
+	 * For unknown data we are trying to pick a physical eraseblock with
+	 * medium erase counter. But we by no means can pick a physical
+	 * eraseblock with erase counter greater or equivalent then the the
+	 * lowest erase counter plus %WL_FREE_MAX_DIFF.
+	 */
+
+	first = rb_entry(rb_first(&wl->free), struct ubi_wl_entry, rb);
+	last = rb_entry(rb_last(&wl->free), struct ubi_wl_entry, rb);
+
+	if (last->ec - first->ec < WL_FREE_MAX_DIFF)
+		return rb_entry(wl->free.rb_node, struct ubi_wl_entry, rb);
+
+	medium_ec = (first->ec + WL_FREE_MAX_DIFF)/2;
+	e = first;
+
+	p = wl->free.rb_node;
+	while (p) {
+		struct ubi_wl_entry *e1;
+
+		e1 = rb_entry(p, struct ubi_wl_entry, rb);
+		if (e1->ec >= medium_ec)
+			p = p->rb_left;
+		else {
+			p = p->rb_right;
+			e = e1;
+		}
+	}
+
+	return e;
+}
+
+/**
+ * pick_short_term - select a "short term" physical eraseblock.
+ *
+ * @wl: the wear-leveling unit description data structure
+ *
+ * This function returns the requested physical eraseblock. The wl->lock must
+ * be locked. The @wl->free list must not be empty.
+ */
+static struct ubi_wl_entry *pick_short_term(struct ubi_wl_info *wl)
+{
+	struct ubi_wl_entry *e;
+
+	/*
+	 * For short term data we pick a physical eraseblock with the lowest
+	 * erase counter as we expect it will be erased soon.
+	 */
+	e = rb_entry(rb_first(&wl->free), struct ubi_wl_entry, rb);
+	return e;
+}
+
+/**
+ * prot_tree_add - add a the physical eraseblock to the protection trees.
+ *
+ * @wl: the wear-leveling unit description data structure
+ * @e: the physical eraseblock to add
+ * @pe: a protection entry object to use
+ * @abs_ec: the absolute erase counter value when this physical eraseblock has
+ * to be removed from the protection trees.
+ *
+ * @wl->lock has to be locked.
+ */
+static void prot_tree_add(struct ubi_wl_info *wl, struct ubi_wl_entry *e,
+			  struct ubi_wl_prot_entry *pe, int abs_ec)
+{
+	struct rb_node **p, *parent = NULL;
+	struct ubi_wl_prot_entry *pe1;
+
+	pe->e = e;
+	pe->abs_ec = wl->abs_ec + abs_ec;
+
+	p = &wl->prot.pnum.rb_node;
+	while (*p) {
+		parent = *p;
+		pe1 = rb_entry(parent, struct ubi_wl_prot_entry, rb_pnum);
+
+		if (e->pnum < pe1->e->pnum)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&pe->rb_pnum, parent, p);
+	rb_insert_color(&pe->rb_pnum, &wl->prot.pnum);
+
+	p = &wl->prot.aec.rb_node;
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+		pe1 = rb_entry(parent, struct ubi_wl_prot_entry, rb_aec);
+
+		if (pe->abs_ec < pe1->abs_ec)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&pe->rb_aec, parent, p);
+	rb_insert_color(&pe->rb_aec, &wl->prot.aec);
+}
+
+/**
+ * check_protection_over - check if it is time to stop protecting some
+ * physical eraseblocks.
+ *
+ * @wl: the wear-leveling unit description data structure
+ *
+ * This function is called after each erase operation, when the absolute erase
+ * counter is incremented, to check if some physical eraseblock  have not to be
+ * protected any longer. These physical eraseblocks are moved from the
+ * protection trees to the used tree.
+ */
+static void check_protection_over(struct ubi_wl_info *wl)
+{
+	struct ubi_wl_prot_entry *pe;
+
+	/*
+	 * There may be several protected physical eraseblock to remove,
+	 * process them all.
+	 */
+	while (1) {
+		spin_lock(&wl->lock);
+		if (tree_empty(&wl->prot.aec)) {
+			spin_unlock(&wl->lock);
+			break;
+		}
+
+		pe = rb_entry(rb_first(&wl->prot.aec),
+			      struct ubi_wl_prot_entry, rb_aec);
+
+		if (pe->abs_ec > wl->abs_ec) {
+			spin_unlock(&wl->lock);
+			break;
+		}
+
+		dbg_wl("PEB %d protection over, abs_ec %llu, PEB abs_ec %llu",
+		       pe->e->pnum, wl->abs_ec, pe->abs_ec);
+		rb_erase(&pe->rb_aec, &wl->prot.aec);
+		rb_erase(&pe->rb_pnum, &wl->prot.pnum);
+		used_tree_add(wl, pe->e);
+		spin_unlock(&wl->lock);
+
+		ubi_free_wl_prot_entry(pe);
+		cond_resched();
+	}
+}
+
+/**
+ * prot_tree_del - remove a physical eraseblock from the protection trees
+ *
+ * @wl: the wear-leveling unit description data structure
+ * @pnum: the physical eraseblock number to remove
+ */
+static void prot_tree_del(struct ubi_wl_info *wl, int pnum)
+{
+	struct rb_node *p;
+	struct ubi_wl_prot_entry *pe = NULL;
+
+	p = wl->prot.pnum.rb_node;
+	while (p) {
+
+		pe = rb_entry(p, struct ubi_wl_prot_entry, rb_pnum);
+
+		if (pnum == pe->e->pnum)
+			break;
+
+		if (pnum < pe->e->pnum)
+			p = p->rb_left;
+		else
+			p = p->rb_right;
+	}
+
+	ubi_assert(pe->e->pnum == pnum);
+	rb_erase(&pe->rb_aec, &wl->prot.aec);
+	rb_erase(&pe->rb_pnum, &wl->prot.pnum);
+	ubi_free_wl_prot_entry(pe);
+}
+
+static int wear_leveling_worker(const struct ubi_info *ubi,
+				struct ubi_bgt_work *wrk, int cancel);
+
+/**
+ * ensure_wear_leveling - schedule wear-leveling if it is needed.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function checks if it is time to start wear-leveling and schedules it
+ * if yes. This function returns zero in case of success and a negative error
+ * code in case of failure.
+ */
+static int ensure_wear_leveling(const struct ubi_info *ubi)
+{
+	int err = 0;
+	struct ubi_wl_entry *e1;
+	struct ubi_wl_entry *e2;
+	struct ubi_bgt_work *wrk;
+	struct ubi_wl_info *wl = ubi->wl;
+
+	spin_lock(&wl->lock);
+	if (wl->wl_scheduled)
+		/* Wear-leveling is already in the work queue */
+		goto out_unlock;
+
+	/*
+	 * If the wl->scrub tree is not empty, scrubbing is needed, and the the
+	 * WL worker has to be scheduled anyway.
+	 */
+	if (tree_empty(&wl->scrub)) {
+		if (tree_empty(&wl->used) || tree_empty(&wl->free))
+			/* No physical eraseblocks - no deal */
+			goto out_unlock;
+
+		/*
+		 * We schedule wear-leveling only if the difference between the
+		 * lowest erase counter of used physical eraseblocks and a high
+		 * erase counter of free physical eraseblocks is greater then
+		 * %UBI_WL_THRESHOLD.
+		 */
+		e1 = rb_entry(rb_first(&wl->used), struct ubi_wl_entry, rb);
+		e2 = find_wl_entry(&wl->free, WL_FREE_MAX_DIFF);
+
+		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD))
+			goto out_unlock;
+		dbg_wl("schedule wear-leveling");
+	} else
+		dbg_wl("schedule scrubbing");
+
+	wl->wl_scheduled = 1;
+	spin_unlock(&wl->lock);
+
+	wrk = ubi_alloc_bgt_work();
+	if (unlikely(!wrk)) {
+		err = -ENOMEM;
+		goto out_cancel;
+	}
+
+	wrk->func = &wear_leveling_worker;
+	err = ubi_bgt_schedule(ubi, wrk);
+	if (unlikely(err)) {
+		/*
+		 * The background was thread is killed, don't clear the
+		 * @wl->wl_scheduled flag to prevent this error from happening
+		 * again and again. And switch to read-only mode.
+		 */
+		ubi_free_bgt_work(wrk);
+		ubi_eba_ro_mode(ubi);
+	}
+	return err;
+
+out_unlock:
+	spin_unlock(&wl->lock);
+	return err;
+
+out_cancel:
+	spin_lock(&wl->lock);
+	wl->wl_scheduled = 0;
+	spin_unlock(&wl->lock);
+	return err;
+}
+
+/**
+ * schedule_erase - schedule an erase work.
+ *
+ * @ubi: the UBI device description object
+ * @e: the WL entry of the physical eraseblock to erase
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ *
+ * Note: @wl->erase_pending must be incremented before this function is called.
+ */
+static int schedule_erase(const struct ubi_info *ubi, struct ubi_wl_entry *e,
+			  int torture)
+{
+	int err;
+	struct ubi_wl_erase_work *wl_wrk;
+
+	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
+	       e->pnum, e->ec, torture);
+
+	wl_wrk = ubi_alloc_wl_erase_work();
+	if (unlikely(!wl_wrk))
+		return -ENOMEM;
+
+	wl_wrk->wrk.func = &erase_worker;
+	wl_wrk->wrk.priv = wl_wrk;
+	wl_wrk->e = e;
+	wl_wrk->torture = torture;
+
+	err = ubi_bgt_schedule(ubi, &wl_wrk->wrk);
+	if (unlikely(err)) {
+		/*
+		 * The background thread was killed, but we really need it. We
+		 * can only work in read-only mode without it.
+		 */
+		ubi_free_wl_erase_work(wl_wrk);
+		ubi_eba_ro_mode(ubi);
+	}
+	return err;
+}
+
+static int sync_erase(const struct ubi_info *ubi, struct ubi_wl_entry *e,
+		      int torture);
+
+/**
+ * erase_worker - physical eraseblock erase worker function.
+ *
+ * @ubi: the UBI device description object
+ * @wrk: the work object
+ * @cancel: non-zero if the worker has to free memory and exit
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure. This function also takes care about marking the physical
+ * eraseblock bad if it cannot be erased.
+ */
+static int erase_worker(const struct ubi_info *ubi, struct ubi_bgt_work *wrk,
+			int cancel)
+{
+	int err;
+	struct ubi_wl_info *wl = ubi->wl;
+	struct ubi_wl_erase_work *wl_wrk = wrk->priv;
+	struct ubi_wl_entry *e = wl_wrk->e;
+	int pnum = e->pnum;
+
+	if (unlikely(cancel)) {
+		dbg_wl("cancel erasure of PEB %d EC %d", pnum, e->ec);
+		ubi_free_wl_erase_work(wl_wrk);
+		ubi_free_wl_entry(e);
+		return 0;
+	}
+
+	dbg_wl("erase PEB %d EC %d", pnum, e->ec);
+
+	err = sync_erase(ubi, e, wl_wrk->torture);
+	if (likely(!err)) {
+		/* Fine, we've erased it successfully */
+		ubi_free_wl_erase_work(wl_wrk);
+
+		spin_lock(&wl->lock);
+		wl->erase_pending -= 1;
+		ubi_assert(wl->erase_pending >= 0);
+		wl->abs_ec += 1;
+		free_tree_add(wl, e);
+		spin_unlock(&wl->lock);
+
+		/*
+		 * One more erase operation has happened, take care about protected
+		 * physical eraseblocks.
+		 */
+		check_protection_over(wl);
+
+		/* And take care about wear-leveling */
+		err = ensure_wear_leveling(ubi);
+		return err;
+	}
+
+	/*
+	 * Some error occurred during erasure. If this is something like
+	 * %-EINTR, we just re-schedule this physical eraseblock for
+	 * erasure.
+	 */
+
+	if (err == -EINTR || err == -EAGAIN || err == -ENOMEM ||
+	    err == -EBUSY) {
+		ubi_bgt_reschedule(ubi, wrk); /* Must not return error */
+		return err;
+	}
+
+	ubi_free_wl_erase_work(wl_wrk);
+	ubi_free_wl_entry(e);
+
+	spin_lock(&wl->lock);
+	wl->erase_pending -= 1;
+	spin_unlock(&wl->lock);
+
+	/*
+	 * If this is not %-EIO, we have no idea what to do. Scheduling
+	 * this physical eraseblock for erasure again will cause repeated
+	 * errors.
+	 */
+	if (err != -EIO) {
+		ubi_eba_ro_mode(ubi);
+		return err;
+	}
+
+	/* It is %-EIO, the PEB went bad */
+
+	if (!ubi->io->bad_allowed) {
+		ubi_err("flash device may be severly bad");
+		ubi_eba_ro_mode(ubi);
+		err = -EIO;
+	} else {
+		err = ubi_beb_mark_bad(ubi, pnum);
+		if (err)
+			ubi_eba_ro_mode(ubi);
+	}
+	return err;
+}
+
+/**
+ * wear_leveling_worker - wear-leveling worker function.
+ *
+ * @ubi: the UBI device description object
+ * @wrk: the work object
+ * @cancel: non-zero if the worker has to free memory and exit
+ *
+ * This function copies a less worn out physical eraseblock to a more worn out
+ * one. Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+static int wear_leveling_worker(const struct ubi_info *ubi,
+				struct ubi_bgt_work *wrk, int cancel)
+{
+	int err, vol_id, lnum, scrub = 0, data_size, aldata_size;
+	struct ubi_wl_entry *e1, *e2;
+	struct ubi_vid_hdr *vid_hdr;
+	void *buf;
+	uint32_t crc;
+	struct ubi_wl_info *wl = ubi->wl;
+	struct ubi_wl_prot_entry *pe;
+	const struct ubi_io_info *io = ubi->io;
+
+	ubi_free_bgt_work(wrk);
+
+	if (unlikely(cancel))
+		return 0;
+
+	spin_lock(&wl->lock);
+	if (tree_empty(&wl->free) ||
+	    (tree_empty(&wl->used) && tree_empty(&wl->scrub))) {
+		/*
+		 * No free physical eraseblocks? Well, we cancel wear-leveling
+		 * then. It will be triggered again when a free physical
+		 * eraseblock appears.
+		 *
+		 * No used physical eraseblocks? They must be temporarily
+		 * protected from being moved. They will be moved to the
+		 * @wl->used tree later and the wear-leveling will be
+		 * triggered again.
+		 */
+		dbg_wl("cancel WL, a list is empty: free %d, used %d",
+		       tree_empty(&wl->free), tree_empty(&wl->used));
+		goto out;
+	}
+
+	if (tree_empty(&wl->scrub)) {
+		/*
+		 * Now pick the least worn-out used physical eraseblock and a
+		 * highly worn-out free physical eraseblock. If the erase
+		 * counters differ much enough, start wear-leveling.
+		 */
+		e1 = rb_entry(rb_first(&wl->used), struct ubi_wl_entry, rb);
+		e2 = find_wl_entry(&wl->free, WL_FREE_MAX_DIFF);
+
+		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD)) {
+			dbg_wl("no WL needed: min used EC %d, max free EC %d",
+			       e1->ec, e2->ec);
+			goto out;
+		}
+		used_tree_del(wl, e1);
+		dbg_wl("move PEB %d EC %d to PEB %d EC %d",
+		       e1->pnum, e1->ec, e2->pnum, e2->ec);
+	} else {
+		scrub = 1;
+		e1 = rb_entry(rb_first(&wl->scrub), struct ubi_wl_entry, rb);
+		e2 = find_wl_entry(&wl->free, WL_FREE_MAX_DIFF);
+		scrub_tree_del(wl, e1);
+		dbg_wl("scrub PEB %d to PEB %d", e1->pnum, e2->pnum);
+	}
+
+	free_tree_del(wl, e2);
+	wl->move = e1;
+	spin_unlock(&wl->lock);
+
+	vid_hdr = ubi_zalloc_vid_hdr(ubi);
+	if (unlikely(!vid_hdr)) {
+		err = -ENOMEM;
+		goto out_err_cancel;
+	}
+
+	/*
+	 * Now we are going to copy physical eraseblock @e1->pnum to @e2->pnum.
+	 * We've selected a victim (@e1) and @wl->move refers it. But, user may
+	 * call 'ubi_wl_put_peb()' for @e1, and the movement has to be
+	 * canceled.
+	 *
+	 * We so far do not know which logical eraseblock our physical
+	 * eraseblock (@e1) belongs to. This means we cannot lock it. We have
+	 * to read the volume identifier header first. But if @e1 is put, it is
+	 * scheduled for erasure, and we may have a race with the erasure.
+	 * So, we may easily get an I/O error when we read the VID header.
+	 * This does not necessarily mean something nasty.
+	 */
+
+	err = ubi_io_read_vid_hdr(ubi, e1->pnum, vid_hdr, 0);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		/* OK, error. If the movement was canceled, don't panic */
+		spin_lock(&wl->lock);
+		if (!wl->move) {
+			spin_unlock(&wl->lock);
+			/* This physical eraseblock was put meanwhile */
+			goto out_cancel_wl;
+		}
+		spin_unlock(&wl->lock);
+		/* Well, this means there is a problem */
+		dbg_wl("VID hdr read error (%d)", err);
+		goto vid_hdr_read_error;
+	}
+
+	if (vid_hdr->vol_type == UBI_VID_STATIC) {
+		data_size = ubi32_to_cpu(vid_hdr->data_size);
+		aldata_size = align_up(data_size, io->min_io_size);
+	} else
+		data_size = aldata_size =
+			    io->leb_size - ubi32_to_cpu(vid_hdr->data_pad);
+
+	ubi_assert(aldata_size % io->min_io_size == 0);
+
+	buf = ubi_kmalloc(aldata_size);
+	if (unlikely(!buf)) {
+		err = -ENOMEM;
+		goto out_err_cancel_vid_hdr;
+	}
+
+	vol_id = ubi32_to_cpu(vid_hdr->vol_id);
+	lnum = ubi32_to_cpu(vid_hdr->lnum);
+
+	/*
+	 * We do not want anybody to write to this physical eraseblock while
+	 * we are copying it, so we lock it.
+	 */
+	err = ubi_eba_leb_write_lock(ubi, vol_id, lnum);
+	if (unlikely(err))
+		goto out_err_cancel_buf;
+
+	spin_lock(&wl->lock);
+	if (!wl->move)
+		/* This physical eraseblock was put meanwhile, cancel */
+		goto out_cancel_wl_unlock;
+	spin_unlock(&wl->lock);
+
+	/*
+	 * From now on nobody can access this physical eraseblock as we locked
+	 * the corresponding logical eraseblock.
+	 */
+	dbg_wl("read %d bytes of data", aldata_size);
+	err = ubi_io_read_data(ubi, buf, e1->pnum, 0, aldata_size);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		ubi_warn("error %d while reading data from PEB %d",
+			 err, e1->pnum);
+		goto data_read_error;
+	}
+
+	/*
+	 * Now we have got to calculate how much data we have to to copy. In
+	 * case of a static volume it is fairly easy - the VID header contains
+	 * the data size. In case of a dynamic volume it is more difficult - we
+	 * have to read the contents, cut 0xFF bytes from the end and copy only
+	 * the first part. We must do this to avoid writing 0xFF bytes as it
+	 * may have some side-effects. And not only this. It is important not
+	 * to include those 0xFFs to CRC because later the user may fill them
+	 * by his data!
+	 */
+	if (vid_hdr->vol_type == UBI_VID_DYNAMIC)
+		aldata_size = data_size =
+				ubi_calc_data_len(ubi, buf, data_size);
+
+	cond_resched();
+	crc = crc32(UBI_CRC32_INIT, buf, data_size);
+
+	/*
+	 * It may turn out that the whole @e1->pnum physical eraseblock
+	 * contains only 0xFF bytes. Then we have to only write the VID header
+	 * and do not write any data. This also means we should not set
+	 * @vid_hdr->copy_flag, @vid_hdr->data_size, and @vid_hdr->data_crc.
+	 */
+	if (likely(data_size > 0)) {
+		vid_hdr->copy_flag = 1;
+		vid_hdr->data_size = cpu_to_ubi32(data_size);
+		vid_hdr->data_crc = cpu_to_ubi32(crc);
+	}
+	vid_hdr->leb_ver = cpu_to_ubi32(ubi32_to_cpu(vid_hdr->leb_ver) + 1);
+
+	cond_resched();
+	err = ubi_io_write_vid_hdr(ubi, e2->pnum, vid_hdr);
+	if (unlikely(err))
+		goto write_error;
+
+	/* Read the VID header back and check if it was written correctly */
+	cond_resched();
+	err = ubi_io_read_vid_hdr(ubi, e2->pnum, vid_hdr, 1);
+	if (unlikely(err)) {
+		if (err != UBI_IO_BITFLIPS) {
+			ubi_warn("cannot read VID header back from PEB %d", e2->pnum);
+			goto write_error;
+		}
+		goto bitflip;
+	}
+
+	if (likely(data_size > 0)) {
+		void *buf1;
+
+		err = ubi_io_write_data(ubi, buf, e2->pnum, 0, aldata_size);
+		if (unlikely(err))
+			goto write_error;
+
+		/*
+		 * We've written the data and are going to read it back to make
+		 * sure it was written correctly.
+		 */
+		buf1 = ubi_kmalloc(aldata_size);
+		if (unlikely(!buf1)) {
+			err = -ENOMEM;
+			goto write_error;
+		}
+
+		cond_resched();
+		err = ubi_io_read_data(ubi, buf1, e2->pnum, 0, aldata_size);
+		if (unlikely(err)) {
+			ubi_kfree(buf1);
+			if (err != UBI_IO_BITFLIPS) {
+				ubi_warn("cannot read data back from PEB %d",
+					 e2->pnum);
+				goto write_error;
+			}
+			goto bitflip;
+		}
+
+		cond_resched();
+		if (unlikely(memcmp(buf, buf1, aldata_size))) {
+			ubi_warn("read data back from PEB %d - it is different",
+				 e2->pnum);
+			err = -EINVAL;
+			ubi_kfree(buf1);
+			goto write_error;
+		}
+		ubi_kfree(buf1);
+	}
+
+	/*
+	 * Re-map the logical eraseblock to the new physical eraseblock
+	 * (@e2->pnum).
+	 */
+	ubi_eba_leb_remap(ubi, vol_id, lnum, e2->pnum);
+
+	/*
+	 * The physical eraseblock was successfully copied and re-mapped. Add
+	 * the new copy to the @wl->used tree and schedule the old one for
+	 * erasure.
+	 */
+	spin_lock(&wl->lock);
+	wl->erase_pending += 1;
+	used_tree_add(wl, e2);
+	wl->wl_scheduled = 0;
+	ubi_assert(wl->move);
+	wl->move = NULL;
+	spin_unlock(&wl->lock);
+
+	/* Unlock the logical eraseblock */
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+
+	ubi_kfree(buf);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+
+	/*
+	 * Note, we do not check if more wear-leveling is needed here. We
+	 * schedule the physical eraseblock for erasure so we know that the
+	 * erase worker will take care about that.
+	 */
+	err = schedule_erase(ubi, e1, 0);
+	if (unlikely(err)) {
+		/* This may only happen if there is no memory */
+		ubi_free_wl_entry(e1);
+		ubi_eba_ro_mode(ubi);
+	}
+	dbg_wl("done");
+	return err;
+
+out:
+	wl->wl_scheduled = 0;
+	spin_unlock(&wl->lock);
+	return 0;
+
+	/*
+	 * The physical eraseblock we have selected was put. It was scheduled
+	 * for erasure and removed from the @wl->used tree, so we only need to
+	 * return @e2 back to the @wl->free tree.
+	 */
+out_cancel_wl_unlock:
+	spin_unlock(&wl->lock);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	ubi_kfree(buf);
+out_cancel_wl:
+	dbg_wl("PEB %d was put, don't move it, cancel", e1->pnum);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	spin_lock(&wl->lock);
+	ubi_assert(wl->move == NULL);
+	free_tree_add(wl, e2);
+	wl->wl_scheduled = 0;
+	spin_unlock(&wl->lock);
+	return 0;
+
+	/*
+	 * Some non-I/O error occurred. Neither @e1 nor @e2 were changed, just
+	 * get them back to the lists they were taken from.
+	 */
+out_err_cancel_buf:
+	ubi_kfree(buf);
+out_err_cancel_vid_hdr:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_err_cancel:
+	spin_lock(&wl->lock);
+	wl->wl_scheduled = 0;
+	if (wl->move) {
+		if (scrub)
+			scrub_tree_add(wl, e1);
+		else
+			used_tree_add(wl, e1);
+		wl->move = NULL;
+	}
+	free_tree_add(wl, e2);
+	spin_unlock(&wl->lock);
+	return err;
+
+	/*
+	 * Failed to read from the @e1->pnum physical eraseblock. Something
+	 * nasty happened. We don't want to move this physical eraseblock.
+	 * We also don't want this physical eraseblock to be repeatedly
+	 * selected for wear-leveling, so protect it.
+	 *
+	 * FIXME: It would be better to notify upper layers about this and let
+	 * them handle this. But this is not implemented.
+	 */
+data_read_error:
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+	ubi_kfree(buf);
+vid_hdr_read_error:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	spin_lock(&wl->lock);
+	free_tree_add(wl, e2);
+	spin_unlock(&wl->lock);
+
+	pe = ubi_alloc_wl_prot_entry();
+	if (!pe) {
+		spin_lock(&wl->lock);
+		wl->wl_scheduled = 0;
+		if (wl->move)
+			used_tree_add(wl, e1);
+		wl->move = NULL;
+		spin_unlock(&wl->lock);
+		return -ENOMEM;
+	}
+	spin_lock(&wl->lock);
+	wl->wl_scheduled = 0;
+	if (wl->move) {
+		prot_tree_add(wl, e1, pe, ST_PROTECTION);
+		wl->move = NULL;
+		spin_unlock(&wl->lock);
+	} else {
+		spin_unlock(&wl->lock);
+		ubi_free_wl_prot_entry(pe);
+	}
+	return 0;
+
+	/*
+	 * An error occurred during writing. Something was written to @e2-pnum,
+	 * so we cannot treat it as free any longer. Put @e1 back to the
+	 * @wl->used tree and schedule @e2->pnum for erasure.
+	 *
+	 * Normally, this happens if @e2->pnum went bad - then it will be
+	 * handled in the erase function. But if the flash does not admit of
+	 * bad physical eraseblock, we switch to read-only mode.
+	 */
+write_error:
+	ubi_kfree(buf);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+
+	spin_lock(&wl->lock);
+	wl->wl_scheduled = 0;
+	ubi_assert(wl->move);
+	used_tree_add(wl, e1);
+	wl->move = NULL;
+	spin_unlock(&wl->lock);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+
+	if (ubi->io->bad_allowed) {
+		int err1;
+
+		spin_lock(&wl->lock);
+		wl->erase_pending += 1;
+		spin_unlock(&wl->lock);
+		err1 = schedule_erase(ubi, e2, 1);
+		if (err1) {
+			/* No memory - bad, switch to read-only mode */
+			ubi_free_wl_entry(e2);
+			spin_lock(&wl->lock);
+			wl->erase_pending -= 1;
+			spin_unlock(&wl->lock);
+			ubi_eba_ro_mode(ubi);
+			err = err1;
+		}
+	} else {
+		ubi_err("flash device may be severly bad");
+		ubi_free_wl_entry(e2);
+		ubi_eba_ro_mode(ubi);
+	}
+	return err;
+
+	/*
+	 * We successfully wrote the data to @e2->pnum, but when we red it back
+	 * we detected a bit-flip. So we cancel the operation.
+	 */
+bitflip:
+	dbg_wl("bit-flip at the copied data, cancel");
+	ubi_kfree(buf);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+
+	spin_lock(&wl->lock);
+	wl->wl_scheduled = 0;
+	ubi_assert(wl->move);
+	if (scrub)
+		scrub_tree_add(wl, e1);
+	else
+		used_tree_add(wl, e1);
+	wl->move = NULL;
+	spin_unlock(&wl->lock);
+	ubi_eba_leb_write_unlock(ubi, vol_id, lnum);
+
+	spin_lock(&wl->lock);
+	wl->erase_pending += 1;
+	spin_unlock(&wl->lock);
+	err = schedule_erase(ubi, e2, 0);
+	if (err) {
+		/* No memory - bad, switch to read-only mode */
+		ubi_free_wl_entry(e2);
+		spin_lock(&wl->lock);
+		wl->erase_pending -= 1;
+		spin_unlock(&wl->lock);
+		ubi_eba_ro_mode(ubi);
+	}
+
+	return err;
+
+}
+
+/**
+ * sync_erase - synchronously erase a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @e: the the physical eraseblock to erase
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int sync_erase(const struct ubi_info *ubi, struct ubi_wl_entry *e,
+		      int torture)
+{
+	int err;
+	struct ubi_ec_hdr *ec_hdr;
+	struct ubi_wl_info *wl = ubi->wl;
+	uint64_t ec = e->ec;
+
+	dbg_wl("erase PEB %d, old EC %llu", e->pnum, (unsigned long long)ec);
+
+	err = paranoid_check_ec(ubi, e->pnum, e->ec);
+	if (unlikely(err > 0))
+		return -EINVAL;
+
+	ec_hdr = ubi_zalloc_ec_hdr(ubi);
+	if (unlikely(!ec_hdr))
+		return -ENOMEM;
+
+	err = ubi_io_sync_erase(ubi, e->pnum, torture);
+	if (unlikely(err < 0))
+		goto out_free;
+
+	ec += err;
+	if (unlikely(ec > UBI_MAX_ERASECOUNTER)) {
+		/*
+		 * Erase counter overflow. Upgrade UBI and use 64-bit
+		 * erase counters internally.
+		 */
+		ubi_err("erase counter overflow at PEB %d, EC %llu",
+			e->pnum, (unsigned long long)ec);
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	dbg_wl("erased PEB %d, new EC %llu", e->pnum, (unsigned long long)ec);
+
+	ec_hdr->ec = cpu_to_ubi64(ec);
+
+	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
+	if (unlikely(err))
+		goto out_free;
+
+	e->ec = ec;
+	if (e->ec > wl->max_ec)
+		wl->max_ec = e->ec;
+
+out_free:
+	ubi_free_ec_hdr(ubi, ec_hdr);
+	return err;
+}
+
+/**
+ * produce_free - produce a free physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function tries to make a free PEB by means of syncronoes execution of
+ * pending works. This may be neede if, for example the background thread is
+ * disabled. Returns zero in case of success and a negative error code in case
+ * of failure.
+ */
+static int produce_free(const struct ubi_info *ubi)
+{
+	int err;
+	struct ubi_wl_info *wl = ubi->wl;
+
+	spin_lock(&wl->lock);
+	while (tree_empty(&wl->free)) {
+		spin_unlock(&wl->lock);
+
+		dbg_wl("do one work synchronously");
+		err = ubi_bgt_do_work(ubi);
+		if (unlikely(err))
+			return err;
+
+		spin_lock(&wl->lock);
+	}
+	spin_unlock(&wl->lock);
+
+	return 0;
+}
+
+/**
+ * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
+ *
+ * @e: the wear-leveling entry to add
+ * @root: the root of the tree
+ *
+ * Note, we use (erase counter, physical eraseblock number) pairs as keys in
+ * the @wl->used and @wl->free RB-trees.
+ */
+static void wl_tree_add(struct ubi_wl_entry *e, struct rb_root *root)
+{
+	struct rb_node **p, *parent = NULL;
+
+	p = &root->rb_node;
+	while (*p) {
+		struct ubi_wl_entry *e1;
+
+		parent = *p;
+		e1 = rb_entry(parent, struct ubi_wl_entry, rb);
+
+		if (e->ec < e1->ec)
+			p = &(*p)->rb_left;
+		else if (e->ec > e1->ec)
+			p = &(*p)->rb_right;
+		else {
+			ubi_assert(e->pnum != e1->pnum);
+			if (e->pnum < e1->pnum)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+		}
+	}
+
+	rb_link_node(&e->rb, parent, p);
+	rb_insert_color(&e->rb, root);
+}
+
+/**
+ * in_wl_tree - check if a wear-leveling entry is present in a WL RB-tree.
+ *
+ * @e: the wear-leveling entry to check
+ * @root: the root of the tree
+ *
+ * This function returns non-zero if @e is in the @root RB-tree and zero if it
+ * is not.
+ */
+static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
+{
+	struct rb_node *p;
+
+	p = root->rb_node;
+	while (p) {
+		struct ubi_wl_entry *e1;
+
+		e1 = rb_entry(p, struct ubi_wl_entry, rb);
+
+		if (e->pnum == e1->pnum) {
+			ubi_assert(e == e1);
+			return 1;
+		}
+
+		if (e->ec < e1->ec)
+			p = p->rb_left;
+		else if (e->ec > e1->ec)
+			p = p->rb_right;
+		else {
+			ubi_assert(e->pnum != e1->pnum);
+			if (e->pnum < e1->pnum)
+				p = p->rb_left;
+			else
+				p = p->rb_right;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * tree_destroy - destroy an RB-tree.
+ *
+ * @root: the root of the tree to destroy
+ */
+static void tree_destroy(struct rb_root *root)
+{
+	struct rb_node *rb;
+	struct ubi_wl_entry *e;
+
+	rb = root->rb_node;
+	while (rb) {
+		if (rb->rb_left)
+			rb = rb->rb_left;
+		else if (rb->rb_right)
+			rb = rb->rb_right;
+		else {
+			e = rb_entry(rb, struct ubi_wl_entry, rb);
+
+			rb = rb_parent(rb);
+			if (rb) {
+				if (rb->rb_left == &e->rb)
+					rb->rb_left = NULL;
+				else
+					rb->rb_right = NULL;
+			}
+
+			ubi_free_wl_entry(e);
+		}
+	}
+}
+
+/**
+ * protection_trees_destroy - destroy the protection RB-trees.
+ *
+ * @wl: the wear-leveling unit description data structure
+ */
+static void protection_trees_destroy(struct ubi_wl_info *wl)
+{
+	struct rb_node *rb;
+	struct ubi_wl_prot_entry *pe;
+
+	rb = wl->prot.aec.rb_node;
+	while (rb) {
+		if (rb->rb_left)
+			rb = rb->rb_left;
+		else if (rb->rb_right)
+			rb = rb->rb_right;
+		else {
+			pe = rb_entry(rb, struct ubi_wl_prot_entry, rb_aec);
+
+			rb = rb_parent(rb);
+			if (rb) {
+				if (rb->rb_left == &pe->rb_aec)
+					rb->rb_left = NULL;
+				else
+					rb->rb_right = NULL;
+			}
+
+			ubi_free_wl_entry(pe->e);
+			ubi_free_wl_prot_entry(pe);
+		}
+	}
+}
+
+#ifdef CONFIG_MTD_UBI_DEBUG_PARANOID_WL
+
+/**
+ * paranoid_check_ec - make sure that the erase counter of a physical eraseblock
+ * is correct.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to check
+ * @ec: the erase counter to check
+ *
+ * This function returns zero if the erase counter of physical eraseblock @pnum
+ * is equivalent to @ec, %1 if not, and a negative error code if an error
+ * occurred.
+ */
+static int paranoid_check_ec(const struct ubi_info *ubi, int pnum, int ec)
+{
+	int err;
+	long long read_ec;
+	struct ubi_ec_hdr *ec_hdr;
+
+	ec_hdr = ubi_zalloc_ec_hdr(ubi);
+	if (unlikely(!ec_hdr))
+		return -ENOMEM;
+
+	err = ubi_io_read_ec_hdr(ubi, pnum, ec_hdr, 0);
+	if (unlikely(err) && err != UBI_IO_BITFLIPS) {
+		/* The header does not have to exist */
+		err = 0;
+		goto out_free;
+	}
+
+	read_ec = ubi64_to_cpu(ec_hdr->ec);
+	if (unlikely(ec != read_ec)) {
+		ubi_err("paranoid check failed for PEB %d", pnum);
+		ubi_err("read EC is %lld, should be %d", read_ec, ec);
+		ubi_dbg_dump_stack();
+		err = 1;
+	} else
+		err = 0;
+
+out_free:
+	ubi_free_ec_hdr(ubi, ec_hdr);
+	return err;
+}
+
+/**
+ * paranoid_check_in_wl_tree - make sure that a wear-leveling entry is present
+ * in a WL RB-tree.
+ *
+ * @e: the wear-leveling entry to check
+ * @root: the root of the tree
+ *
+ * This function returns zero if @e is in the @root RB-tree and %1 if it
+ * is not.
+ */
+static int paranoid_check_in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
+{
+	if (likely(in_wl_tree(e, root)))
+		return 0;
+
+	ubi_err("paranoid check failed for PEB %d, EC %d, RB-tree %p ",
+		e->pnum, e->ec, root);
+	ubi_dbg_dump_stack();
+	return 1;
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_PARANOID_WL */
