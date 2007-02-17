Return-Path: <linux-kernel-owner+w=401wt.eu-S2992728AbXBQRN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992728AbXBQRN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992756AbXBQRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:13:26 -0500
Received: from smtp.nokia.com ([131.228.20.170]:55140 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992755AbXBQRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:13:24 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:57:05 +0200
Message-Id: <20070217165705.5845.13508.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 32/44 take 2] [UBI] accounting unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:33.0065 (UTC) FILETIME=[93CD6190:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185330-63EC2BB0-48866909/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/account.c tmp-to/drivers/mtd/ubi/account.c
--- tmp-from/drivers/mtd/ubi/account.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/account.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,286 @@
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
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "vtbl.h"
+#include "account.h"
+#include "scan.h"
+#include "alloc.h"
+#include "badeb.h"
+#include "io.h"
+#include "debug.h"
+
+int ubi_acc_mkvol(const struct ubi_info *ubi, int reserved_pebs)
+{
+	struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_acc("reserve %d PEBs for a new volume (uvol_count %d"
+		"rsvd_pebs %d, avail_pebs %d)", reserved_pebs,
+		acc->uvol_count, acc->rsvd_pebs, acc->avail_pebs);
+	ubi_assert(reserved_pebs > 0);
+
+	spin_lock(&acc->lock);
+	if (acc->uvol_count + 1 > acc->max_volumes) {
+		dbg_err("no room for the volume");
+		goto out;
+	}
+	if (reserved_pebs > acc->avail_pebs) {
+		dbg_err("no enough PEBs");
+		goto out;
+	}
+	acc->uvol_count += 1;
+	acc->avail_pebs -= reserved_pebs;
+	acc->rsvd_pebs += reserved_pebs;
+	ubi_assert(acc->avail_pebs >= 0);
+	spin_unlock(&acc->lock);
+	return 0;
+
+out:
+	spin_unlock(&acc->lock);
+	return -ENOSPC;
+}
+
+void ubi_acc_rmvol(const struct ubi_info *ubi, int reserved_pebs)
+{
+	struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_acc("remove volume and get back %d PEBs (uvol_count %d, "
+		"rsvd_pebs %d, avail_pebs %d)", reserved_pebs,
+		acc->uvol_count, acc->rsvd_pebs, acc->avail_pebs);
+	ubi_assert(reserved_pebs > 0 && reserved_pebs <= acc->rsvd_pebs);
+
+	spin_lock(&acc->lock);
+	acc->uvol_count -= 1;
+	acc->avail_pebs += reserved_pebs;
+	acc->rsvd_pebs -= reserved_pebs;
+	ubi_assert(acc->uvol_count >= 0);
+	ubi_assert(acc->rsvd_pebs >= 0);
+	spin_unlock(&acc->lock);
+
+	/* Take care about PEBs reserved for bad PEB handling */
+	ubi_beb_maintain_reserved(ubi);
+}
+
+int ubi_acc_reserve(const struct ubi_info *ubi, int pebs)
+{
+	struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_acc("reserve %d PEBs (rsvd_pebs %d, avail_pebs %d)",
+		pebs, acc->rsvd_pebs, acc->avail_pebs);
+	ubi_assert(pebs > 0);
+
+	spin_lock(&acc->lock);
+	if (unlikely(pebs > acc->avail_pebs)) {
+		dbg_err("no enough PEBs");
+		spin_unlock(&acc->lock);
+		return -ENOSPC;
+	}
+	acc->avail_pebs -= pebs;
+	acc->rsvd_pebs += pebs;
+	spin_unlock(&acc->lock);
+	return 0;
+}
+
+void ubi_acc_free(const struct ubi_info *ubi, int pebs)
+{
+	struct ubi_acc_info *acc = ubi->acc;
+
+	dbg_acc("free %d PEBs (rsvd_pebs %d, avail_pebs %d)",
+		pebs, acc->rsvd_pebs, acc->avail_pebs);
+	spin_lock(&acc->lock);
+	ubi_assert(pebs > 0 && pebs <= acc->rsvd_pebs);
+	acc->rsvd_pebs -= pebs;
+	acc->avail_pebs += pebs;
+	spin_unlock(&acc->lock);
+}
+
+static int acc_info_check(const struct ubi_info *ubi,
+			  const struct ubi_scan_info *si);
+
+int ubi_acc_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si)
+{
+	int err, i;
+	struct ubi_acc_info *acc;
+	const struct ubi_vtbl_vtr *vtr;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	const struct ubi_io_info *io = ubi->io;
+
+	dbg_acc("initialize the accounting unit");
+
+	acc = ubi_kzalloc(sizeof(struct ubi_acc_info));
+	if (!acc)
+		return -ENOMEM;
+	ubi->acc = acc;
+
+	spin_lock_init(&acc->lock);
+	acc->ivol_count = UBI_INT_VOL_COUNT;
+
+	for (i = 0; i < acc->ivol_count; i++) {
+		cond_resched();
+		vtr = ubi_vtbl_get_vtr(ubi, UBI_INTERNAL_VOL_START + i);
+		ubi_assert(!IS_ERR(vtr));
+		acc->rsvd_pebs += vtr->reserved_pebs;
+	}
+
+	/*
+	 * The maximum number of volumes may be less then the volume table
+	 * fits if there are too few available eraseblocks on the flash.
+	 */
+	acc->max_volumes = vtbl->vt_slots;
+	i = io->good_peb_count - acc->rsvd_pebs;
+	if (i <= 0) {
+		ubi_err("too small flash, at least %d good physical eraseblock"
+			" needed", acc->rsvd_pebs + 1);
+		err = -EINVAL;
+		goto out_acc;
+	}
+
+	if (acc->max_volumes > i)
+		acc->max_volumes = i;
+
+	for (i = 0; i < acc->max_volumes; i++) {
+		cond_resched();
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (IS_ERR(vtr))
+			continue;
+		acc->uvol_count += 1;
+		acc->rsvd_pebs += vtr->reserved_pebs;
+	}
+
+	acc->rsvd_pebs += si->alien_peb_count;
+	acc->avail_pebs = io->good_peb_count - acc->rsvd_pebs;
+
+	/* Check accounting information sanity and consistency */
+	err = acc_info_check(ubi, si);
+	if (err)
+		goto out_acc;
+
+	dbg_acc("uvol_count %d, ivol_count %d, avail_pebs %d rsvd_pebs %d "
+		"max_volumes %d", acc->uvol_count, acc->ivol_count,
+		acc->avail_pebs, acc->rsvd_pebs, acc->max_volumes);
+	return 0;
+
+out_acc:
+	ubi_kfree(acc);
+	return err;
+}
+
+void ubi_acc_close(const struct ubi_info *ubi)
+{
+	dbg_acc("close the accounting unit");
+	ubi_kfree(ubi->acc);
+}
+
+/**
+ * acc_info_check - check sanity and consistency of accounting information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information which must be consistent to accounting
+ * information
+ *
+ * As we try not to trust the data we read from the flash media, we have to
+ * check that the accounting information is sane and consistent, as it is
+ * formed using on-flash information. This function returns zero if all is fine
+ * and a negative error code if some inconsistency was found.
+ */
+static int acc_info_check(const struct ubi_info *ubi,
+			  const struct ubi_scan_info *si)
+{
+	int i;
+	const struct ubi_vtbl_vtr *vtr;
+	const struct ubi_acc_info *acc = ubi->acc;
+	const struct ubi_vtbl_info *vtbl = ubi->vtbl;
+	const struct ubi_io_info *io = ubi->io;
+
+	if (acc->avail_pebs < 0 || acc->rsvd_pebs < 0 || acc->uvol_count < 0 ||
+	    acc->ivol_count < 0) {
+		dbg_err("negative values");
+		goto bad;
+	}
+
+	if (acc->avail_pebs > io->good_peb_count) {
+		dbg_err("bad avail_pebs");
+		goto bad;
+	}
+
+	if (acc->rsvd_pebs > io->good_peb_count) {
+		dbg_err("bad rsvd_pebs");
+		goto bad;
+	}
+
+	if (acc->avail_pebs + acc->rsvd_pebs != io->good_peb_count) {
+		dbg_err("accounting error");
+		goto bad;
+	}
+
+	if (acc->max_volumes > vtbl->vt_slots) {
+		dbg_err("bad max_volumes");
+		goto bad;
+	}
+
+	if (acc->ivol_count + acc->uvol_count > acc->max_volumes) {
+		dbg_err("vol. count (%d + %d) > max_volumes",
+			acc->ivol_count, acc->uvol_count);
+		goto bad;
+	}
+
+	/*
+	 * Ensure that there are no volumes which exceed acc->max_volumes
+	 * exist.
+	 */
+	for (i = acc->max_volumes; i < vtbl->vt_slots; i++) {
+		cond_resched();
+		vtr = ubi_vtbl_get_vtr(ubi, i);
+		if (unlikely(!IS_ERR(vtr))) {
+			dbg_err("volume %d exists", i);
+			goto bad;
+		}
+	}
+
+	if (si->vols_found > acc->ivol_count + acc->uvol_count) {
+		dbg_err("scanning found volumes %d > %d + %d",
+			si->vols_found, acc->ivol_count, acc->uvol_count);
+		goto bad;
+	}
+
+	if (si->highest_vol_id >= acc->max_volumes &&
+	    si->highest_vol_id < UBI_INTERNAL_VOL_START) {
+		dbg_err("too large volume ID %d found by scanning",
+			si->highest_vol_id);
+		goto bad;
+	}
+
+	return 0;
+
+bad:
+	ubi_err("accounting check failed");
+	dbg_err("uvol_count %d, ivol_count %d, avail_pebs %d, rsvd_pebs %d "
+		"io->good_peb_count %d, max_volumes %d, vtbl->vt_slots %d",
+		acc->uvol_count, acc->ivol_count, acc->avail_pebs,
+		acc->rsvd_pebs, io->good_peb_count, acc->max_volumes,
+		vtbl->vt_slots);
+	return -EINVAL;
+}
