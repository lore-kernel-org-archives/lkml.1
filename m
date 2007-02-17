Return-Path: <linux-kernel-owner+w=401wt.eu-S2992845AbXBQRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992845AbXBQRUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992847AbXBQRUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:20:43 -0500
Received: from smtp.nokia.com ([131.228.20.170]:56278 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992845AbXBQRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:20:41 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:56:40 +0200
Message-Id: <20070217165640.5845.32772.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 27/44 take 2] [UBI] bad block handling unit header
X-OriginalArrivalTime: 17 Feb 2007 16:56:40.0184 (UTC) FILETIME=[980BA780:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185317-63EC2BB0-5D870BF9/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/badeb.h tmp-to/drivers/mtd/ubi/badeb.h
--- tmp-from/drivers/mtd/ubi/badeb.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/badeb.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,108 @@
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
+ * Bad eraseblock handling unit.
+ *
+ * This unit is responsible for marking physical eraseblocks as bad and for
+ * recovering data from supposedly bad physical eraseblocks.
+ */
+
+#ifndef __UBI_BADEB_H__
+#define __UBI_BADEB_H__
+
+#include <linux/spinlock.h>
+
+/**
+ * ubi_beb_mark_bad - mark a physical eraseblock as bad.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock number to mark
+ *
+ * This function returns error in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_beb_mark_bad(const struct ubi_info *ubi, int pnum);
+
+/**
+ * ubi_beb_maintain_reserved - maintain a certain level of reserved physical
+ * eraseblock.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function tries to maintain a fixed number of reserved physical
+ * eraseblocks for bad eraseblock handling. This number is configurable.
+ */
+void ubi_beb_maintain_reserved(const struct ubi_info *ubi);
+
+/**
+ * ubi_beb_recover_peb - recover a physical eraseblock after a write failure.
+ *
+ * @ubi: the UBI device description object
+ * @pnum: the physical eraseblock to recover
+ * @vol_id: volume ID this LEB belongs to
+ * @lnum: logical eraseblock number
+ * @buf: the data which was not be written because of a write failure
+ * @offset: offset of the failed write
+ * @len: how many bytes are should have been written
+ *
+ * This function has to be called in case of a write failure to move all the
+ * good data foam the potentially bad physical eraseblock to a good physical
+ * eraseblock. This function also writes the data which was not written due to
+ * the failure. This function returns the new physical eraseblock number in
+ * case of success, and a negative error code in case of failure.
+ */
+int ubi_beb_recover_peb(const struct ubi_info *ubi, int pnum, int vol_id,
+			int lnum, const void *buf, int offset, int len);
+
+/**
+ * ubi_beb_init - initialize the bad eraseblock handling unit.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns zero in case of success, and a negative error code in
+ * case of failure.
+ */
+int ubi_beb_init(struct ubi_info *ubi);
+
+/**
+ * ubi_beb_close - close the bad eraseblock handling unit.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_beb_close(struct ubi_info *ubi);
+
+/**
+ * struct ubi_beb_info - UBI bad PEB handling unit description data structure.
+ *
+ * @reserved_pebs: how many physical eraseblocks are reserved for bad PEB
+ * handling
+ * @reserved_max: how many PEBs have to be reserved for bad PEB handling, i.e.,
+ * the normal level of reserved PEBs
+ * @lock: protects @reserved_pebs
+ */
+struct ubi_beb_info {
+	int reserved_pebs; /* public  */
+	int reserved_max;  /* public  */
+	spinlock_t lock;   /* private */
+};
+
+#endif /* !__UBI_BADEB_H__ */
