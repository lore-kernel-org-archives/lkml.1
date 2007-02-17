Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXBQQ5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXBQQ5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXBQQ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:57:31 -0500
Received: from smtp.nokia.com ([131.228.20.172]:56436 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992463AbXBQQ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:57:22 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:00 +0200
Message-Id: <20070217165700.5845.71318.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 31/44 take 2] [UBI] accounting unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:00.0308 (UTC) FILETIME=[A40A5540:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185419-03D78BB0-7F3C9864/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/account.h tmp-to/drivers/mtd/ubi/account.h
--- tmp-from/drivers/mtd/ubi/account.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/account.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,118 @@
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
+ * This unit is responsible for maintaining the correct physical eraseblock
+ * accounting to prevent overcommitment.
+ */
+
+#ifndef __UBI_ACCOUNT_H__
+#define __UBI_ACCOUNT_H__
+
+#include <linux/spinlock.h>
+
+struct ubi_info;
+struct ubi_scan_info;
+
+/**
+ * ubi_acc_mkvol - account creation of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @reserved_pebs: how many eraseblocks are reserved for the volume
+ *
+ * This function reserves @reserved_pebs physical eraseblocks for the newly
+ * created volume. Returns zero in case of success and a %-ENOSPC if there are
+ * no enough physical eraseblocks.
+ */
+int ubi_acc_mkvol(const struct ubi_info *ubi, int reserved_pebs);
+
+/**
+ * ubi_acc_rmvol - account removal of a volume.
+ *
+ * @ubi: the UBI device description object
+ * @reserved_pebs: how many eraseblocks were reserved for the volume
+ *
+ * This function reclaims the physical eraseblocks occupied by a volume. Note,
+ * UBI is trying to maintain a constant level of physical eraseblock reserved
+ * for bad PEB handling. So, if there is a lack of reserved physical
+ * eraseblock, this function will reserve them at once.
+ */
+void ubi_acc_rmvol(const struct ubi_info *ubi, int reserved_pebs);
+
+/**
+ * ubi_acc_reserve - reserve a number of physical eraseblocks.
+ *
+ * @ubi: the UBI device description object
+ * @pebs: how many physical eraseblocks to reserve
+ *
+ * This function returns zero in case of success and %-ENOSPC if there are no
+ * enough physical eraseblocks.
+ */
+int ubi_acc_reserve(const struct ubi_info *ubi, int pebs);
+
+/**
+ * ubi_acc_free - free a number of reserved physical eraseblocks.
+ *
+ * @ubi: the UBI device description object
+ * @pebs: how many physical eraseblocks to free
+ */
+void ubi_acc_free(const struct ubi_info *ubi, int pebs);
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
+int ubi_acc_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_acc_close - close the accounting unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_acc_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_acc_info - the UBI accounting unit's description data structure.
+ *
+ * @ivol_count: count of internal volumes
+ * @uvol_count: count of user volumes
+ * @rsvd_pebs: count of reserved physical eraseblocks
+ * @avail_pebs: count of available physical eraseblocks
+ * @max_volumes: maximum number of volumes that users may create
+ * @lock: protects the accounting data
+ */
+struct ubi_acc_info {
+	int ivol_count;  /* public  */
+	int uvol_count;  /* public  */
+	int rsvd_pebs;   /* public  */
+	int avail_pebs;  /* public  */
+	int max_volumes; /* public  */
+	spinlock_t lock; /* private */
+};
+
+#endif /* !__UBI_ACCOUNT_H__ */
