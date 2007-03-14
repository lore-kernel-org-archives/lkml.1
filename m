Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbXCNPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbXCNPYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXCNPVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:33 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23402 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422669AbXCNPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:52 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:20:39 +0200
Message-Id: <20070314152039.1112.31606.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/22 take 3] UBI: accounting unit
X-OriginalArrivalTime: 14 Mar 2007 15:20:39.0869 (UTC) FILETIME=[52F516D0:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172041-5061ABB0-3C4C1960/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/account.c tmp-to/drivers/mtd/ubi/account.c
--- tmp-from/drivers/mtd/ubi/account.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/account.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,233 @@
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
+ * UBI accounting unit.
+ *
+ * This unit is responsible for maintaining physical eraseblock accounting to
+ * prevent overcommitment.
+ */
+
+#include <linux/err.h>
+#include "ubi.h"
+
+/* The lowest number PEBs reserved for bad PEB handling */
+#define MIN_RESEVED_PEBS 1
+
+/**
+ * ubi_acc_reserve - reserve a number of physical eraseblocks.
+ *
+ * @ubi: the UBI device description object
+ * @pebs: how many physical eraseblocks to reserve
+ *
+ * This function returns zero in case of success and %-ENOSPC if there is no
+ * enough physical eraseblocks.
+ */
+int ubi_acc_reserve(struct ubi_info *ubi, int pebs)
+{
+	ubi_assert(pebs > 0);
+
+	spin_lock(&ubi->acc.lock);
+	ubi_assert(ubi->acc.avail_pebs >= 0);
+	if (pebs > ubi->acc.avail_pebs) {
+		dbg_err("not enough PEBs: requested %d, available %d",
+			pebs, ubi->acc.avail_pebs);
+		spin_unlock(&ubi->acc.lock);
+		return -ENOSPC;
+	}
+	ubi->acc.avail_pebs -= pebs;
+	ubi->acc.rsvd_pebs += pebs;
+	spin_unlock(&ubi->acc.lock);
+	return 0;
+}
+
+/**
+ * ubi_acc_free - free a number of reserved physical eraseblocks.
+ *
+ * @ubi: the UBI device description object
+ * @pebs: how many physical eraseblocks to free
+ */
+void ubi_acc_free(struct ubi_info *ubi, int pebs)
+{
+	ubi_assert(pebs > 0);
+
+	spin_lock(&ubi->acc.lock);
+	ubi_assert(pebs <= ubi->acc.rsvd_pebs);
+	ubi->acc.rsvd_pebs -= pebs;
+	ubi->acc.avail_pebs += pebs;
+	ubi_assert(ubi->acc.rsvd_pebs >= 0);
+	spin_unlock(&ubi->acc.lock);
+}
+
+/**
+ * calculate_beb_rsvd_max - calculate how many PEBs must be reserved for bad
+ * eraseblock handling.
+ *
+ * @ubi: the UBI device description object
+ */
+static void calculate_beb_rsvd_max(struct ubi_info *ubi)
+{
+	ubi->acc.beb_rsvd_max = ubi->io.good_peb_count/100;
+	ubi->acc.beb_rsvd_max *= CONFIG_MTD_UBI_BEB_RESERVE;
+	if (ubi->acc.beb_rsvd_max < MIN_RESEVED_PEBS)
+		ubi->acc.beb_rsvd_max = MIN_RESEVED_PEBS;
+}
+
+/**
+ * ubi_acc_peb_marked_bad - a physical eraseblock was marked as bad,
+ * re-calculate accounting.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_acc_peb_marked_bad(struct ubi_info *ubi)
+{
+	int need;
+
+	ubi_assert(ubi->acc.beb_rsvd_pebs >= 0);
+
+	if (!ubi->io.bad_allowed)
+		return;
+
+	spin_lock(&ubi->acc.lock);
+	if (ubi->acc.beb_rsvd_pebs == 0) {
+		ubi_warn("no reserved physical eraseblocks");
+		ubi_ro_mode(ubi);
+	}
+	calculate_beb_rsvd_max(ubi);
+	ubi->acc.beb_rsvd_pebs -= 1;
+	need = ubi->acc.beb_rsvd_max = ubi->acc.beb_rsvd_pebs;
+	if (need > 0) {
+		int alloc;
+
+		alloc = ubi->acc.avail_pebs >= need ? need
+						    : ubi->acc.avail_pebs;
+		ubi->acc.avail_pebs -= alloc;
+		ubi->acc.rsvd_pebs += alloc;
+		ubi->acc.beb_rsvd_pebs += alloc;
+	}
+	if (ubi->acc.beb_rsvd_pebs == 0)
+		ubi_warn("last PEB from the reserved pool was used");
+	spin_unlock(&ubi->acc.lock);
+}
+
+/**
+ * acc_info_check - check sanity and consistency of accounting information.
+ *
+ * @ubi: the UBI device description object
+ *
+ * We do not trust data read from the flash media and we check that the
+ * accounting information is consistent, because it is formed using on-flash
+ * data. This function returns zero if everything is fine and %-EINVAL if some
+ * inconsistency was found.
+ */
+static int acc_info_check(const struct ubi_info *ubi)
+{
+	if (ubi->acc.avail_pebs < 0 || ubi->acc.rsvd_pebs < 0)
+		goto bad;
+
+	if (ubi->acc.avail_pebs > ubi->io.good_peb_count) {
+		dbg_err("bad avail_pebs");
+		goto bad;
+	}
+
+	if (ubi->acc.rsvd_pebs > ubi->io.good_peb_count ||
+	    ubi->acc.rsvd_pebs < ubi->vtbl.vol_count) {
+		dbg_err("bad rsvd_pebs");
+		goto bad;
+	}
+
+	if (ubi->acc.avail_pebs + ubi->acc.rsvd_pebs !=
+					ubi->io.good_peb_count) {
+		dbg_err("accounting error");
+		goto bad;
+	}
+
+	return 0;
+
+bad:
+	ubi_err("accounting check failed");
+	dbg_err("avail_pebs %d, rsvd_pebs %d, ubi->io.good_peb_count %d",
+		ubi->acc.avail_pebs, ubi->acc.rsvd_pebs,
+		ubi->io.good_peb_count);
+	return -EINVAL;
+}
+
+/**
+ * ubi_acc_init_scan - initialize the accounting unit using scanning
+ * information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_acc_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err, i;
+	const struct ubi_vtbl_vtr *vtr;
+
+	dbg_uif("initialize the accounting unit");
+
+	spin_lock_init(&ubi->acc.lock);
+
+	for (i = 0; i < UBI_INT_VOL_COUNT; i++) {
+		vtr = ubi_vtbl_get_vtr(ubi, UBI_INTERNAL_VOL_START + i);
+		ubi_assert(!IS_ERR(vtr));
+		ubi->acc.rsvd_pebs += vtr->reserved_pebs;
+	}
+
+	for (i = 0; i < ubi->vtbl.vt_slots; i++) {
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr))
+			continue;
+		ubi->acc.rsvd_pebs += vtr->reserved_pebs;
+	}
+
+	ubi->acc.rsvd_pebs += si->alien_peb_count;
+	ubi->acc.avail_pebs = ubi->io.good_peb_count - ubi->acc.rsvd_pebs;
+
+	if (ubi->io.bad_allowed) {
+		calculate_beb_rsvd_max(ubi);
+
+		if (ubi->acc.avail_pebs < ubi->acc.beb_rsvd_max) {
+			/* No enough free physical eraseblocks */
+			ubi->acc.beb_rsvd_pebs = ubi->acc.avail_pebs;
+			ubi_warn("cannot reserve enough PEBs for bad PEB "
+				 "handling, reserved %d, need %d",
+				 ubi->acc.beb_rsvd_pebs, ubi->acc.beb_rsvd_max);
+		} else
+			ubi->acc.beb_rsvd_pebs = ubi->acc.beb_rsvd_max;
+
+		ubi->acc.avail_pebs -= ubi->acc.beb_rsvd_pebs;
+		ubi->acc.rsvd_pebs  += ubi->acc.beb_rsvd_pebs;
+	}
+
+	/* Check accounting information sanity and consistency */
+	err = acc_info_check(ubi);
+	if (err)
+		return err;
+
+	dbg_uif("accounting unit is initialized");
+	dbg_uif("avail_pebs %d rsvd_pebs %d, max_volumes %d",
+		ubi->acc.avail_pebs, ubi->acc.rsvd_pebs, ubi->vtbl.vt_slots);
+
+	return 0;
+}
