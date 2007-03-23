Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXCWQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXCWQqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXCWQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:46:09 -0400
Received: from smtp.nokia.com ([131.228.20.171]:47209 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXCWQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:46:07 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Fri, 23 Mar 2007 18:44:17 +0200
Message-Id: <20070323164417.8958.52103.sendpatchset@localhost.localdomain>
In-Reply-To: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
References: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/20 take 4] UBI: misc stuff
X-OriginalArrivalTime: 23 Mar 2007 16:44:17.0586 (UTC) FILETIME=[7F77B120:01C76D6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070323184420-1C7B2BB0-32A46CC3/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/misc.c tmp-to/drivers/mtd/ubi/misc.c
--- tmp-from/drivers/mtd/ubi/misc.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/misc.c	2007-03-23 18:20:01.000000000 +0200
@@ -0,0 +1,105 @@
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
+ * Author: Artem Bityutskiy (Битюцкий Артём)
+ */
+
+/* Here we keep miscellaneous functions which are used all over the UBI code */
+
+#include "ubi.h"
+
+/**
+ * calc_data_len - calculate how much real data is stored in a buffer.
+ * @ubi: UBI device description object
+ * @buf: a buffer with the contents of the physical eraseblock
+ * @length: the buffer length
+ *
+ * This function calculates how much "real data" is stored in @buf and returnes
+ * the length. Continuous 0xFF bytes at the end of the buffer are not
+ * considered as "real data".
+ */
+int ubi_calc_data_len(const struct ubi_device *ubi, const void *buf,
+		      int length)
+{
+	int i;
+
+	ubi_assert(length % ubi->min_io_size == 0);
+
+	for (i = length - 1; i >= 0; i--)
+		if (((const uint8_t *)buf)[i] != 0xFF)
+			break;
+
+	/* The resulting length must be aligned to the minimum flash I/O size */
+	length = ubi_align_up(i + 1, ubi->min_io_size);
+	return length;
+}
+
+/**
+ * ubi_check_volume - check the contents of a static volume.
+ * @ubi: UBI device description object
+ * @vol_id: ID of the volume to check
+ *
+ * This function checks if static volume @vol_id is corrupted by fully reading
+ * it and checking data CRC. This function returns %0 if the volume is not
+ * corrupted, %1 if it is corrupted and a negative error code in case of
+ * failure. Dynamic volumes are not checked and zero is returned immediately.
+ */
+int ubi_check_volume(struct ubi_device *ubi, int vol_id)
+{
+	void *buf;
+	int err = 0, i;
+	struct ubi_volume *vol = ubi->volumes[vol_id];
+
+	if (vol->vol_type != UBI_STATIC_VOLUME)
+		return 0;
+
+	buf = kmalloc(vol->usable_leb_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < vol->used_ebs; i++) {
+		int size;
+
+		if (i == vol->used_ebs - 1)
+			size = vol->last_eb_bytes;
+		else
+			size = vol->usable_leb_size;
+
+		err = ubi_eba_read_leb(ubi, vol_id, i, buf, 0, size, 1);
+		if (err) {
+			if (err == -EBADMSG)
+				err = 1;
+			break;
+		}
+	}
+
+	kfree(buf);
+	return err;
+}
+
+/**
+ * ubi_calculate_rsvd_pool - calculate how many PEBs must be reserved for bad
+ * eraseblock handling.
+ * @ubi: UBI device description object
+ */
+void ubi_calculate_reserved(struct ubi_device *ubi)
+{
+	ubi->beb_rsvd_level = ubi->good_peb_count/100;
+	ubi->beb_rsvd_level *= CONFIG_MTD_UBI_BEB_RESERVE;
+	if (ubi->beb_rsvd_level < MIN_RESEVED_PEBS)
+		ubi->beb_rsvd_level = MIN_RESEVED_PEBS;
+}
