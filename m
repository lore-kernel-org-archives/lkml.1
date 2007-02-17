Return-Path: <linux-kernel-owner+w=401wt.eu-S2992708AbXBQRD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992708AbXBQRD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992707AbXBQRDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:03:30 -0500
Received: from smtp.nokia.com ([131.228.20.170]:53411 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992607AbXBQRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:03:26 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:56:45 +0200
Message-Id: <20070217165645.5845.42053.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 28/44 take 2] [UBI] bad block handling unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:56:12.0925 (UTC) FILETIME=[87CC42D0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185318-63EC2BB0-4E9B6EEE/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/badeb.c tmp-to/drivers/mtd/ubi/badeb.c
--- tmp-from/drivers/mtd/ubi/badeb.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/badeb.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,234 @@
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
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "badeb.h"
+#include "debug.h"
+#include "io.h"
+#include "eba.h"
+#include "account.h"
+#include "wl.h"
+#include "misc.h"
+
+/* The lowest number PEBs reserved for bad PEB handling */
+#define MIN_RESEVED_PEBS 1
+
+static void calculate_reserved_max(const struct ubi_info *ubi);
+
+int ubi_beb_mark_bad(const struct ubi_info *ubi, int pnum)
+{
+	int err;
+	struct ubi_beb_info *beb = ubi->beb;
+
+	ubi_assert(ubi->io->bad_allowed);
+
+	ubi_msg("PEB %d wend bad, mark it as bad", pnum);
+
+	err = ubi_io_mark_bad(ubi, pnum);
+	if (err)
+		return err;
+
+	spin_lock(&beb->lock);
+	if (beb->reserved_pebs <= 0)
+		ubi_warn("no reserved physical eraseblocks!");
+	ubi->io->bad_peb_count += 1;
+	ubi->io->good_peb_count -= 1;
+	calculate_reserved_max(ubi);
+	beb->reserved_pebs -= 1;
+	if (beb->reserved_pebs < beb->reserved_max && !ubi_acc_reserve(ubi, 1))
+		beb->reserved_pebs += 1;
+	spin_unlock(&beb->lock);
+
+	return err;
+}
+
+void ubi_beb_maintain_reserved(const struct ubi_info *ubi)
+{
+	int err, i, needed;
+	struct ubi_beb_info *beb = ubi->beb;
+
+	if (!ubi->io->bad_allowed)
+		return;
+
+	spin_lock(&beb->lock);
+	needed = beb->reserved_max - beb->reserved_pebs;
+	for (i = needed; i > 0; i--) {
+		err = ubi_acc_reserve(ubi, i);
+		if (!err) {
+			ubi_msg("reserved %d PEBs for bad PEB handling", i);
+			beb->reserved_pebs += i;
+			break;
+		}
+	}
+	spin_unlock(&beb->lock);
+}
+
+int ubi_beb_recover_peb(const struct ubi_info *ubi, int pnum, int vol_id,
+			int lnum, const void *buf, int offset, int len)
+{
+	int err, new_pnum, data_size, tries = 0;
+	struct ubi_vid_hdr *vid_hdr;
+	unsigned char *new_buf;
+
+	ubi_assert(ubi->io->bad_allowed);
+
+retry:
+	new_pnum = ubi_wl_get_peb(ubi, UBI_DATA_UNKNOWN);
+	if (new_pnum < 0)
+		return new_pnum;
+
+	ubi_msg("recover PEB %d, move its data to PEB %d", pnum, new_pnum);
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
+		goto out_vid_hdr;
+	}
+
+	vid_hdr->leb_ver = cpu_to_ubi32(ubi32_to_cpu(vid_hdr->leb_ver) + 1);
+	err = ubi_io_write_vid_hdr(ubi, new_pnum, vid_hdr);
+	if (err)
+		goto vid_write_error;
+
+	/* Now recover the data */
+
+	data_size = offset + len;
+	new_buf = ubi_kmalloc(data_size);
+	if (unlikely(!new_buf)) {
+		err = -ENOMEM;
+		goto out_vid_hdr;
+	}
+	memset(new_buf + offset, 0xFF, len);
+
+	/* Read everything before the area where the write failure happened */
+	if (offset > 0) {
+		err = ubi_io_read_data(ubi, new_buf, pnum, 0, offset);
+		if (err && err != UBI_IO_BITFLIPS)
+			goto out_new_buf;
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
+	if (err)
+		goto vid_data_write_error;
+
+	ubi_kfree(new_buf);
+	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi_eba_leb_remap(ubi, vol_id, lnum, new_pnum);
+	ubi_wl_put_peb(ubi, pnum, 1);
+	ubi_msg("data was successfully recovered");
+	return 0;
+
+out_new_buf:
+	ubi_kfree(new_buf);
+out_vid_hdr:
+	ubi_free_vid_hdr(ubi, vid_hdr);
+out_put:
+	ubi_wl_put_peb(ubi, new_pnum, 1);
+	return err;
+
+vid_data_write_error:
+	ubi_kfree(new_buf);
+vid_write_error:
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
+int ubi_beb_init(struct ubi_info *ubi)
+{
+	int i;
+	struct ubi_beb_info *beb;
+	const struct ubi_io_info *io = ubi->io;
+
+	beb = ubi_kzalloc(sizeof(struct ubi_beb_info));
+	if (!beb)
+		return -ENOMEM;
+	ubi->beb = beb;
+
+	spin_lock_init(&beb->lock);
+
+	if (!io->bad_allowed)
+		return 0;
+
+	calculate_reserved_max(ubi);
+
+	for (i = beb->reserved_max; i > 0; i--)
+		if (!ubi_acc_reserve(ubi, i)) {
+			beb->reserved_pebs = i;
+			break;
+		}
+
+	if (beb->reserved_pebs < beb->reserved_max)
+		/* No enough free physical eraseblocks */
+		ubi_warn("cannot reserve enough PEBs");
+
+	return 0;
+}
+
+void ubi_beb_close(struct ubi_info *ubi)
+{
+	ubi_kfree(ubi->beb);
+}
+
+/**
+ * calculate_reserved_max - calculate how many PEBs must be reserved for bad
+ * eraseblock handling.
+ *
+ * @ubi: the UBI device description object
+ */
+static void calculate_reserved_max(const struct ubi_info *ubi)
+{
+	struct ubi_beb_info *beb = ubi->beb;
+
+	/* Reserve some amount of PEBs for bad PEB handling */
+	beb->reserved_max = ubi->io->good_peb_count/100;
+	beb->reserved_max *= CONFIG_MTD_UBI_BEB_RESERVE;
+	if (beb->reserved_max < MIN_RESEVED_PEBS)
+		beb->reserved_max = MIN_RESEVED_PEBS;
+}
