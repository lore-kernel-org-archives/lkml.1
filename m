Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbXBQRMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbXBQRMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXBQRMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:12:46 -0500
Received: from smtp.nokia.com ([131.228.20.172]:59296 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbXBQRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:12:44 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:50 +0200
Message-Id: <20070217165650.5845.96957.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 29/44 take 2] [UBI] update unit header
X-OriginalArrivalTime: 17 Feb 2007 16:56:50.0246 (UTC) FILETIME=[9E0AFE60:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185514-03D78BB0-2866A3BB/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/upd.h tmp-to/drivers/mtd/ubi/upd.h
--- tmp-from/drivers/mtd/ubi/upd.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/upd.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,136 @@
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
+ * The update unit.
+ *
+ * This unit implements the volume update operation. In the current
+ * implementation we use an update marker for this. The update marker is
+ * per-volume and is stored in the volume table. The update marker is set
+ * before the update starts, and removed after the update has been finished.
+ * So, if the update was interrupted by an unclean re-boot or due to some other
+ * reasons, the update marker is found and we know that the volume is damaged.
+ *
+ * Note, in general it is possible to implement the update operation as a
+ * transaction with a possibility to roll-back. But this is far more complex.
+ *
+ * This implementation does not support concurrent updates but it is not
+ * difficult to implement this.
+ */
+
+#ifndef __UBI_UPD_H__
+#define __UBI_UPD_H__
+
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+struct ubi_info;
+struct ubi_scan_info;
+
+/**
+ * ubi_upd_start - start update operation.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: volume ID to start update for
+ * @bytes: how many bytes will be written to the volume
+ *
+ * This function starts a volume update operation. If @bytes is zero, the
+ * volume will just be fully erased. This function returns zero in case of
+ * success and a negative error code in case of error.
+ *
+ * Note, this function does not check if the volume is being used by some other
+ * user. The (upper) calling layer has to do this.
+ */
+int ubi_upd_start(const struct ubi_info *ubi, int vol_id, long long bytes);
+
+/**
+ * ubi_upd_write_data - write more data.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume under update
+ * @buf: the data to write
+ * @count: how much bytes to write
+ *
+ * This function writes more data to the volume which is being updated. It may
+ * be called arbitrary number of times until all of the update bytes arrive.
+ * This function returns %0 in case of success, %1 if the update was
+ * successfully finished, and a negative error code in case of failure.
+ */
+int ubi_upd_write_data(const struct ubi_info *ubi, int vol_id,
+		       const void __user *buf, int count);
+
+/**
+ * ubi_upd_abort - abort an update operation.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to abort update operation for
+ *
+ * This function aborts an update operation. Returns zero in case of success
+ * and a negative error code in case of failure.
+ *
+ * If an update operation is aborted, the update marker stays on the flash
+ * media. A new successful update operation is required to make this volume
+ * usable.
+ */
+int ubi_upd_abort(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_upd_init_scan - initialize the update volume unit using scanning
+ * information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_upd_init_scan(struct ubi_info *ubi, struct ubi_scan_info *si);
+
+/**
+ * ubi_upd_close - close the update volume unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_upd_close(const struct ubi_info *ubi);
+
+/**
+ * struct ubi_upd_info - UBI update unit description data structure.
+ *
+ * @updating: if any volume is being updated at the moment
+ * @vol_id: which volume utilizes the update marker at the moment
+ * @upd_ebs: how many eraseblocks are going to be updated
+ * @upd_received: how many bytes were already received by the update unit
+ * @upd_bytes: how many more bytes are expected to be received
+ * @upd_buf: a buffer which is used to collect update data during the update
+ * operation
+ * @mutex: serializes access to the volume update capability
+ */
+struct ubi_upd_info {
+	int updating;                        /* public  */
+	int vol_id;                          /* private */
+	int upd_ebs;                         /* private */
+	long long upd_received;              /* private */
+	long long upd_bytes;                 /* private */
+	void *upd_buf;                       /* private */
+	struct mutex mutex;                  /* private */
+};
+
+#endif /* !__UBI_UPD_H__ */
