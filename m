Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXCNP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXCNP0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXCNP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:26:32 -0400
Received: from smtp.nokia.com ([131.228.20.173]:63910 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXCNPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:22 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:05 +0200
Message-Id: <20070314152105.1112.13626.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/22 take 3] UBI: misc stuff
X-OriginalArrivalTime: 14 Mar 2007 15:21:04.0911 (UTC) FILETIME=[61E231F0:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/misc.c tmp-to/drivers/mtd/ubi/misc.c
--- tmp-from/drivers/mtd/ubi/misc.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/misc.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,167 @@
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
+ * Here we keep miscellaneous functions which are used all over the UBI code and
+ * do not really belong to any particular unit.
+ */
+
+#include "ubi.h"
+
+/**
+ * ubi_buf_all_ff - check if buffer contains only 0xFF bytes.
+ *
+ * @buf: buffer to check
+ * @size: buffer size in bytes
+ *
+ * This function returns %1 if there are only 0xFF bytes in @buf, and %2 if
+ * something else was also found.
+ */
+int ubi_buf_all_ff(const void *buf, int size)
+{
+	int i;
+
+	for (i = 0; i < size / sizeof(unsigned int); i++)
+		if (((const unsigned int *)buf)[i] != ~0)
+			return 0;
+
+	for (i = i; i < size; i++)
+		if (((const uint8_t *)buf)[i] != 0xFF)
+			return 0;
+
+	return 1;
+}
+
+/**
+ * ubi_buf_all_zeroes - check if buffer contains only zeroes.
+ *
+ * @buf: buffer to check
+ * @size: buffer size in bytes
+ *
+ * This function returns %1 in there are only zero bytes in @buf, and %0 if
+ * something else was also found.
+ */
+int ubi_buf_all_zeroes(const void *buf, int size)
+{
+	int i;
+
+	for (i = 0; i < size / sizeof(unsigned int); i++)
+		if (((const unsigned int *)buf)[i] != 0)
+			return 0;
+
+	for (i = i; i < size; i++)
+		if (((const uint8_t *)buf)[i] != 0)
+			return 0;
+
+	return 1;
+}
+
+/**
+ * ubi_check_pattern - check if buffer contains only a certain byte pattern.
+ *
+ * @buf: buffer to check
+ * @patt: the pattern to check
+ * @size: buffer size in bytes
+ *
+ * This function returns %1 in there are only @patt bytes in @buf, and %0 if
+ * something else was also found.
+ */
+int ubi_check_pattern(const void *buf, uint8_t patt, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (((const uint8_t *)buf)[i] != patt)
+			return 0;
+	return 1;
+}
+
+/**
+ * calc_data_len - calculate how much real data is stored in a buffer.
+ *
+ * @ubi: the UBI device description object
+ * @buf: a buffer with the contents of the physical eraseblock
+ * @length: the buffer length
+ *
+ * This function calculates how much "real data" is stored in @buf and returnes
+ * the length. Continuous 0xFF bytes at the end of the buffer are not
+ * considered as "real data".
+ */
+int ubi_calc_data_len(const struct ubi_info *ubi, const void *buf,
+		      int length)
+{
+	int i;
+
+	ubi_assert(length % ubi->io.min_io_size == 0);
+
+	for (i = length - 1; i >= 0; i--)
+		if (((const uint8_t *)buf)[i] != 0xFF)
+			break;
+
+	/* The resulting length must be aligned to the minimum flash I/O size */
+	length = align_up(i + 1, ubi->io.min_io_size);
+	return length;
+}
+
+/**
+ * ubi_check_volume - check the contents of a static volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the volume to check
+ *
+ * This function checks if static volume @vol_id is corrupted by fully reading
+ * it and checking data CRC. This function returns %0 if the volume is not
+ * corrupted, %1 if it is corrupted and a negative error code in case of
+ * failure. Dynamic volumes are not checked and zero is returned immediately.
+ */
+int ubi_check_volume(struct ubi_info *ubi, int vol_id)
+{
+	void *buf;
+	int err = 0, i;
+	const struct ubi_vtbl_vtr *vtr;
+
+	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
+
+	if (vtr->vol_type != UBI_STATIC_VOLUME)
+		return 0;
+
+	buf = kmalloc(vtr->usable_leb_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < vtr->used_ebs; i++) {
+		int size;
+
+		if (i == vtr->used_ebs - 1)
+			size = vtr->last_eb_bytes;
+		else
+			size = vtr->usable_leb_size;
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
