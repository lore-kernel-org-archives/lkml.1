Return-Path: <linux-kernel-owner+w=401wt.eu-S2992695AbXBQRCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992695AbXBQRCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXBQRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:01:57 -0500
Received: from smtp.nokia.com ([131.228.20.172]:57374 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992680AbXBQRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:54 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:04 +0200
Message-Id: <20070217165504.5845.83050.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/44 take 2] [UBI] misc unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:54:32.0117 (UTC) FILETIME=[4BB62E50:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185227-03D70BB0-41058836/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/misc.c tmp-to/drivers/mtd/ubi/misc.c
--- tmp-from/drivers/mtd/ubi/misc.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/misc.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,138 @@
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
+#include <linux/string.h>
+#include <linux/sched.h>
+#include "ubi.h"
+#include "misc.h"
+#include "vtbl.h"
+#include "debug.h"
+#include "eba.h"
+#include "alloc.h"
+#include "io.h"
+#include "account.h"
+#include "background.h"
+
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
+char *strdup_len(const char *str, int len)
+{
+	char *dup;
+
+	ubi_assert(strnlen(str, len + 1) == len);
+
+	dup = ubi_kmalloc(len + 1);
+	if (!dup)
+		return NULL;
+
+	memcpy(dup, str, len);
+	dup[len] = '\0';
+
+	return dup;
+}
+
+int ubi_calc_data_len(const struct ubi_info *ubi, const void *buf,
+		      int length)
+{
+	int i;
+
+	ubi_assert(length % ubi->io->min_io_size == 0);
+
+	for (i = length - 1; i >= 0; i--)
+		if (((const uint8_t *)buf)[i] != 0xFF)
+			break;
+
+	/* The resulting length must be aligned to the minimum flash I/O size */
+	length = align_up(i + 1, ubi->io->min_io_size);
+	return length;
+}
+
+int ubi_check_volume(const struct ubi_info *ubi, int vol_id)
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
+	buf = ubi_kmalloc(vtr->usable_leb_size);
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
+	ubi_kfree(buf);
+	return err;
+}
