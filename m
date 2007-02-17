Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXBQRDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXBQRDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992702AbXBQRDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:03:15 -0500
Received: from smtp.nokia.com ([131.228.20.170]:53306 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992617AbXBQRC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:02:58 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:20 +0200
Message-Id: <20070217165620.5845.96750.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 23/44 take 2] [UBI] wear-leveling unit header
X-OriginalArrivalTime: 17 Feb 2007 16:56:20.0029 (UTC) FILETIME=[8C083ED0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185247-63ECBBB0-24B2563B/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/wl.h tmp-to/drivers/mtd/ubi/wl.h
--- tmp-from/drivers/mtd/ubi/wl.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/wl.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,284 @@
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
+/*
+ * UBI wear-leveling unit.
+ *
+ * This unit is responsible for wear-leveling. This unit works in terms of
+ * physical eraseblocks and erase counters and knows nothing about logical
+ * eraseblocks, volumes, etc (with one exception). From this unit's perspective
+ * all physical eraseblocks are of two types - used and free. Used physical
+ * eraseblocks are those that were "get" by the 'ubi_wl_get_peb()' function,
+ * and free physical eraseblocks are those that were put by the
+ * 'ubi_wl_put_peb()' function. Actually, the above two functions are the main
+ * in this unit.
+ *
+ * Physical eraseblocks returned by 'ubi_wl_get_peb()' have only the erase
+ * counter header. The rest of the physical eraseblock contains only 0xFF bytes.
+ *
+ * When physical eraseblocks are returned to the WL unit by means of the
+ * 'ubi_wl_put_peb()' function, they are scheduled for erasure. The erasure is
+ * not done synchronously. Instead, it is done in background in context of the
+ * per-UBI device background thread (see the background thread unit). Actually,
+ * the WL unit strongly depends on the background thread and cannot operate
+ * without it.
+ *
+ * The wear-leveling is ensured by means of moving the contents of used
+ * physical eraseblocks with low erase counter to free physical eraseblocks
+ * with high erase counter. The movement is also done in background.
+ *
+ * When eraseblocks are moved, the WL unit cooperates with the EBA unit to
+ * provide proper eraseblock locking. This means, the WL unit uses the EBA unit
+ * to lock the logical eraseblock corresponding to the physical eraseblock
+ * which is being moved. This is the only place where the WL unit "knows" about
+ * logical eraseblocks and volume identifier headers.
+ *
+ * The 'ubi_wl_get_peb()' function accepts data type hints which help to pick
+ * an "optimal" physical eraseblock. Indeed, for example, when it knows that
+ * the physical eraseblock will be "put" soon, it may pick a free physical
+ * eraseblock with low erase counter, and so forth.
+ *
+ * If the WL unit fails to erase a physical eraseblock, it marks the physical
+ * eraseblock as bad (using the bad eraseblock handling unit).
+ *
+ * This unit is also responsible for scrubbing. If a bit-flip is detected in a
+ * physical eraseblock, it has to be moved. Technically this is the same as
+ * moving it for wear-leveling reasons.
+ *
+ * As it was said, for the UBI unit all physical eraseblocks are either "free"
+ * or "used". Free eraseblock are kept in the @wl->free RB-tree, while used
+ * eraseblocks are kept in a set of different RB-trees: @wl->used,
+ * @wl->prot.pnum, @wl->prot.aec, and @wl->scrub.
+ *
+ * Note, in this implementation, we keep a small in-RAM object for each physical
+ * eraseblock. This is surely not a scalable solution. But it appears to be good
+ * enough for moderately large flashes and it is simple. In future, one may
+ * re-work this unit and make it more scalable.
+ */
+
+#ifndef __UBI_WL_H__
+#define __UBI_WL_H__
+
+#include <linux/rbtree.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/mtd/ubi.h>
+#include "background.h"
+
+struct ubi_info;
+struct ubi_scan_info;
+
+/**
+ * ubi_wl_get_peb - get a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @dtype: type of data which will be stored in this physical eraseblock
+ *
+ * This function returns a physical eraseblock in case of success and a
+ * negative error code in case of failure. Might sleep.
+ */
+int ubi_wl_get_peb(const struct ubi_info *ubi, enum ubi_data_type dtype);
+
+/**
+ * ubi_wl_put_peb - return a physical eraseblock to the wear-leveling
+ * unit.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: physical eraseblock to return
+ * @torture: if this physical eraseblock has to be tortured
+ *
+ * If an error occurred during I/O to @pnum, and the caller suspects @pnum to be
+ * bad, it will be tested for badness if @torture flag is not zero. This function
+ * returns zero in case of success and a negative error code in case of
+ * failure. Might sleep.
+ */
+int ubi_wl_put_peb(const struct ubi_info *ubi, int pnum, int torture);
+
+/**
+ * ubi_wl_flush - flush all pending works.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_wl_flush(const struct ubi_info *ubi);
+
+/**
+ * ubi_wl_scrub_peb - schedule a physical eraseblock for scrubbing.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock to schedule
+ *
+ * If a bit-flip in a physical eraseblock is detected, this physical eraseblock
+ * needs scrubbing. This function schedules a physical eraseblock for
+ * scrubbing which is done in background. This function returns zero in case of
+ * success and a negative error code in case of failure.
+ */
+int ubi_wl_scrub_peb(const struct ubi_info *ubi, int pnum);
+
+/**
+ * ubi_wl_init_scan - initialize the wear-leveling unit using scanning
+ * information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_wl_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_wl_close - close the wear-leveling unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_wl_close(struct ubi_info *ubi);
+
+/**
+ * struct ubi_wl_entry - a wear-leveling entry.
+ *
+ * @rb: link in the corresponding RB-tree
+ * @ec: erase counter
+ * @pnum: physical eraseblock number
+ *
+ * Each physical eraseblock has a corresponding &struct wl_entry object which
+ * may be kept in different RB-trees.
+ */
+struct ubi_wl_entry {
+	struct rb_node rb;
+	int ec;
+	int pnum;
+};
+
+/**
+ * struct ubi_wl_prot_entry - a protection entry.
+ *
+ * @rb_pnum: link in the @wl->prot.pnum RB-tree
+ * @rb_aec: link in the @wl->prot.aec RB-tree
+ * @abs_ec: the absolute erase counter value when the protection ends
+ * @e: the wear-levelling entry of the physical eraseblock under protection
+ *
+ * When the WL unit returns a physical eraseblock, the physical eraseblock is
+ * protected from being moved for some "time". For this reason, the physical
+ * eraseblock is not directly moved from the @wl->free tree to the @wl->used
+ * tree. There is one more tree in between where this physical eraseblock is
+ * temporarily stored (@wl->prot).
+ *
+ * All this protection stuff is needed because:
+ *  o we don't want to move physical eraseblocks just after we have given them
+ *    to the user; instead, we first want to let users fill them up with data;
+ *
+ *  o there is a chance that the user will put the physical eraseblock very
+ *    soon, so it makes sense not to move it for some time, but wait; this is
+ *    especially important in case of "short term" physical eraseblocks.
+ *
+ * Physical eraseblocks stay protected only for limited time. But the "time" is
+ * measured in erase cycles in this case. This is implemented with help of the
+ * absolute erase counter (@wl->abs_ec). When it reaches certain value, the
+ * physical eraseblocks are moved from the protection trees (@wl->prot.*) to
+ * the @wl->used tree.
+ *
+ * Protected physical eraseblocks are searched by physical eraseblock number
+ * (when they are put) and by the absolute erase counter (to check if it is
+ * time to move them to the @wl->used tree). So there are actually 2 RB-trees
+ * storing the protected physical eraseblocks: @wl->prot.pnum and
+ * @wl->prot.aec. They are referred to as the "protection" trees. The
+ * first one is indexed by the physical eraseblock number. The second one is
+ * indexed by the absolute erase counter. Both trees store
+ * &struct ubi_wl_prot_entry objects.
+ */
+struct ubi_wl_prot_entry {
+	struct rb_node rb_pnum;
+	struct rb_node rb_aec;
+	unsigned long long abs_ec;
+	struct ubi_wl_entry *e;
+};
+
+/**
+ * struct ubi_wl_erase_work - physical eraseblock erasure work description data
+ * structure.
+ *
+ * @wrk: the background thread work descriptor
+ * @e: the physical eraseblock to erase
+ * @torture: if the physical eraseblock has to be tortured
+ *
+ * This data structure is used for erasure background works. The @torture flag
+ * indicates whether the physical eraseblock should be tested. Testing physical
+ * eraseblocks may be needed if an error occurred and they are likely to become
+ * bad.
+ */
+struct ubi_wl_erase_work {
+	struct ubi_bgt_work wrk;
+	struct ubi_wl_entry *e;
+	int torture;
+};
+
+/**
+ * struct ubi_wl_info - the UBI WL unit description data structure.
+ *
+ * @used: RB-tree of used physical eraseblocks
+ * @free: RB-tree of free physical eraseblocks
+ * @scrub: RB-tree of physical eraseblocks which need scrubbing
+ * @prot.pnum: the protection tree indexed by physical eraseblock numbers
+ * @prot: embraces protection trees
+ * @prot.aec: the protection tree indexed the absolute erase counter
+ * @lock: protects the @used, @free, @prot, @lookuptbl, @abs_ec, @move,
+ * @wl_scheduled, and @erase_pending fields
+ * @wl_scheduled: non-zero if the wear leveling was scheduled
+ * @lookuptbl: a table to quickly find a &struct ubi_wl_entry object for any
+ * physical eraseblock
+ * @erase_pending: how many physical eraseblock are waiting for erasure
+ * @abs_ec: the absolute erase counter
+ * @move: if a physical eraseblock is being moved, it is referred to here
+ * @max_ec: current highest erase counter value
+ *
+ * Each physical eraseblock has 2 main states: free and used. The former state
+ * corresponds to the @free RB-tree. The latter state is split up on several
+ * sub-states:
+ * o the WL movement is allowed (@used RB-tree);
+ * o the WL movement is temporarily prohibited (@prot.pnum and @prot.aec
+ * RB-trees);
+ * o scrubbing is needed (@scrub RB-tree),
+ *
+ * Depending on the sub-state, wear-levelling entries of the used physical
+ * eraseblocks may be kept in one of those trees.
+ */
+struct ubi_wl_info {
+	struct rb_root used;             /* private */
+	struct rb_root free;             /* private */
+	struct rb_root scrub;            /* private */
+	struct {
+		struct rb_root pnum;     /* private */
+		struct rb_root aec;      /* private */
+	} prot;
+	spinlock_t lock;                 /* private */
+	int wl_scheduled;                /* private */
+	struct ubi_wl_entry **lookuptbl; /* private */
+	int erase_pending;               /* private */
+	unsigned long long abs_ec;       /* public  */
+	struct ubi_wl_entry *move;       /* private */
+	int max_ec;                      /* public  */
+};
+
+#endif /* __UBI_WL_H__ */
