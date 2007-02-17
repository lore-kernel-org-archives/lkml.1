Return-Path: <linux-kernel-owner+w=401wt.eu-S2992483AbXBQQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992483AbXBQQ6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXBQQ6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:58:08 -0500
Received: from smtp.nokia.com ([131.228.20.173]:32988 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992471AbXBQQ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:57:42 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:55 +0200
Message-Id: <20070217165555.5845.39430.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/44 take 2] [UBI] build unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:55:22.0427 (UTC) FILETIME=[69B2E0B0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185224-0B11ABB0-20253032/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/build.c tmp-to/drivers/mtd/ubi/build.c
--- tmp-from/drivers/mtd/ubi/build.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/build.c	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,191 @@
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
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "io.h"
+#include "wl.h"
+#include "volmgmt.h"
+#include "account.h"
+#include "background.h"
+#include "vtbl.h"
+#include "eba.h"
+#include "build.h"
+#include "uif.h"
+#include "scan.h"
+#include "badeb.h"
+#include "misc.h"
+#include "debug.h"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_DISABLE_BGT
+#define ENABLE_BGT 0
+#else
+#define ENABLE_BGT 1
+#endif
+
+static int attach_by_scanning(struct ubi_info *ubi);
+
+int ubi_bld_attach_mtd_dev(struct ubi_info *ubi, int mtd_num,
+			   int vid_hdr_offset, int data_offset)
+{
+	int err;
+	const struct ubi_io_info *io;
+	const struct ubi_acc_info *acc;
+
+	dbg_bld("attaching mtd%d to ubi%d", mtd_num, ubi->ubi_num);
+
+	err = ubi_io_init(ubi, mtd_num, vid_hdr_offset, data_offset);
+	if (err) {
+		dbg_err("failed to initialize I/O unit, error %d", err);
+		return err;
+	}
+
+	err = ubi_bgt_init(ubi);
+	if (err) {
+		dbg_err("failed to initialize background thread unit, error %d",
+			err);
+		goto out_io;
+	}
+
+	err = attach_by_scanning(ubi);
+	if (err) {
+		dbg_err("failed to attach MTD device, error %d", err);
+		goto out_bgt;
+	}
+
+	err = ubi_beb_init(ubi);
+	if (err) {
+		dbg_err("failed to initialize bad eraseblock handling unit, "
+			"error %d", err);
+		goto out_detach;
+	}
+
+	err = ubi_uif_init(ubi);
+	if (err) {
+		dbg_err("failed to initialize user interfaces unit for UBI "
+			"device %d, error %d", ubi->ubi_num, err);
+		goto out_beb;
+	}
+
+	io = ubi->io;
+	acc = ubi->acc;
+
+	ubi_msg("attached mtd%d to ubi%d", mtd_num, ubi->ubi_num);
+	ubi_msg("MTD device name:            \"%s\"", io->mtd_name);
+	ubi_msg("MTD device size:            %llu MiB", io->flash_size >> 20);
+	ubi_msg("physical eraseblock size:   %d bytes (%d KiB)",
+		io->peb_size, io->peb_size >> 10);
+	ubi_msg("logical eraseblock size:    %d bytes", io->leb_size);
+	ubi_msg("number of good PEBs:        %d", io->good_peb_count);
+	ubi_msg("number of bad PEBs:         %d", io->bad_peb_count);
+	ubi_msg("smallest flash I/O unit:    %d", io->min_io_size);
+	ubi_msg("VID header offset:          %d (aligned %d)",
+		io->vid_hdr_offset, io->vid_hdr_aloffset);
+	ubi_msg("data offset:                %d", io->leb_start);
+	ubi_msg("max. allowed volumes:       %d", acc->max_volumes);
+	ubi_msg("wear-levelling threshold:   %d", CONFIG_MTD_UBI_WL_THRESHOLD);
+	ubi_msg("number of internal volumes: %d", acc->ivol_count);
+	ubi_msg("number of user volumes:     %d", acc->uvol_count);
+	ubi_msg("available PEBs:             %d", acc->avail_pebs);
+	ubi_msg("total number of reserved PEBs: %d", acc->rsvd_pebs);
+	ubi_msg("number of PEBs reserved for bad PEB handling: %d",
+		ubi->beb->reserved_pebs);
+
+	if (!ENABLE_BGT && !io->ro_mode)
+		ubi_bgt_enable(ubi);
+
+	return 0;
+
+out_beb:
+	ubi_beb_close(ubi);
+out_detach:
+	ubi_eba_close(ubi);
+	ubi_wl_close(ubi);
+	ubi_vmt_close(ubi);
+out_bgt:
+	ubi_bgt_kill_thread(ubi);
+	ubi_bgt_close(ubi);
+out_io:
+	ubi_io_close(ubi);
+	return err;
+}
+
+void ubi_bld_detach_mtd_dev(struct ubi_info *ubi)
+{
+	int mtd_num = ubi->io->mtd_num, ubi_num = ubi->ubi_num;
+
+	dbg_bld("detaching mtd%d from ubi%d", mtd_num, ubi_num);
+
+	ubi_bgt_kill_thread(ubi);
+	ubi_uif_close(ubi);
+	ubi_beb_close(ubi);
+	ubi_eba_close(ubi);
+	ubi_wl_close(ubi);
+	ubi_vmt_close(ubi);
+	ubi_bgt_close(ubi);
+	ubi_io_close(ubi);
+	ubi_msg("detached mtd%d from ubi%d", mtd_num, ubi_num);
+}
+
+/**
+ * attach_by_scanning - attach a MTD device using scanning method.
+ *
+ * @ubi: UBI device descriptor
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int attach_by_scanning(struct ubi_info *ubi)
+{
+	int err;
+	struct ubi_scan_info *si;
+
+	dbg_bld("attach mtd device by scanning");
+
+	si = ubi_scan(ubi);
+	if (IS_ERR(si))
+		return PTR_ERR(si);
+
+	err = ubi_vmt_init_scan(ubi, si);
+	if (err)
+		goto out_si;
+
+	err = ubi_wl_init_scan(ubi, si);
+	if (err)
+		goto out_vmt;
+
+	err = ubi_eba_init_scan(ubi, si);
+	if (err)
+		goto out_wl;
+
+	ubi_msg("mean erase counter:         %d", si->mean_ec);
+	ubi_scan_destroy_si(si);
+	return 0;
+
+out_wl:
+	ubi_wl_close(ubi);
+out_vmt:
+	ubi_vmt_close(ubi);
+out_si:
+	ubi_scan_destroy_si(si);
+	return err;
+}
