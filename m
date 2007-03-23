Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbXCWQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbXCWQsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbXCWQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:48:00 -0400
Received: from smtp.nokia.com ([131.228.20.172]:51354 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279AbXCWQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:47:57 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Fri, 23 Mar 2007 18:44:22 +0200
Message-Id: <20070323164422.8958.45275.sendpatchset@localhost.localdomain>
In-Reply-To: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
References: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/20 take 4] UBI: debugging stuff
X-OriginalArrivalTime: 23 Mar 2007 16:44:22.0583 (UTC) FILETIME=[82722C70:01C76D6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070323184423-202E6BB0-15429C9F/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/debug.c tmp-to/drivers/mtd/ubi/debug.c
--- tmp-from/drivers/mtd/ubi/debug.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.c	2007-03-23 18:20:01.000000000 +0200
@@ -0,0 +1,224 @@
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
+/*
+ * Here we keep all the UBI debugging stuff which should normally be disabled
+ * and compiled-out, but it is extremely helpful when hunting bugs or doing big
+ * changes.
+ */
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG
+
+#include "ubi.h"
+
+/**
+ * ubi_dbg_dump_ec_hdr - dump an erase counter header.
+ * @ec_hdr: the erase counter header to dump
+ */
+void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr)
+{
+	dbg_msg("erase counter header dump:");
+	dbg_msg("magic          %#08x", ubi32_to_cpu(ec_hdr->magic));
+	dbg_msg("version        %d",    (int)ec_hdr->version);
+	dbg_msg("ec             %llu",  (long long)ubi64_to_cpu(ec_hdr->ec));
+	dbg_msg("vid_hdr_offset %d",    ubi32_to_cpu(ec_hdr->vid_hdr_offset));
+	dbg_msg("data_offset    %d",    ubi32_to_cpu(ec_hdr->data_offset));
+	dbg_msg("hdr_crc        %#08x", ubi32_to_cpu(ec_hdr->hdr_crc));
+	dbg_msg("erase counter header hexdump:");
+	ubi_dbg_hexdump(ec_hdr, UBI_EC_HDR_SIZE);
+}
+
+/**
+ * ubi_dbg_dump_vid_hdr - dump a volume identifier header.
+ * @vid_hdr: the volume identifier header to dump
+ */
+void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr)
+{
+	dbg_msg("volume identifier header dump:");
+	dbg_msg("magic     %08x", ubi32_to_cpu(vid_hdr->magic));
+	dbg_msg("version   %d",   (int)vid_hdr->version);
+	dbg_msg("vol_type  %d",   (int)vid_hdr->vol_type);
+	dbg_msg("copy_flag %d",   (int)vid_hdr->copy_flag);
+	dbg_msg("compat    %d",   (int)vid_hdr->compat);
+	dbg_msg("vol_id    %d",   ubi32_to_cpu(vid_hdr->vol_id));
+	dbg_msg("lnum      %d",   ubi32_to_cpu(vid_hdr->lnum));
+	dbg_msg("leb_ver   %u",   ubi32_to_cpu(vid_hdr->leb_ver));
+	dbg_msg("data_size %d",   ubi32_to_cpu(vid_hdr->data_size));
+	dbg_msg("used_ebs  %d",   ubi32_to_cpu(vid_hdr->used_ebs));
+	dbg_msg("data_pad  %d",   ubi32_to_cpu(vid_hdr->data_pad));
+	dbg_msg("sqnum     %llu",
+		(unsigned long long)ubi64_to_cpu(vid_hdr->sqnum));
+	dbg_msg("hdr_crc   %08x", ubi32_to_cpu(vid_hdr->hdr_crc));
+	dbg_msg("volume identifier header hexdump:");
+}
+
+/**
+ * ubi_dbg_dump_vol_info- dump volume information.
+ * @vol: UBI volume description object
+ */
+void ubi_dbg_dump_vol_info(const struct ubi_volume *vol)
+{
+	dbg_msg("volume information dump:");
+	dbg_msg("vol_id          %d", vol->vol_id);
+	dbg_msg("reserved_pebs   %d", vol->reserved_pebs);
+	dbg_msg("alignment       %d", vol->alignment);
+	dbg_msg("data_pad        %d", vol->data_pad);
+	dbg_msg("vol_type        %d", vol->vol_type);
+	dbg_msg("name_len        %d", vol->name_len);
+	dbg_msg("usable_leb_size %d", vol->usable_leb_size);
+	dbg_msg("used_ebs        %d", vol->used_ebs);
+	dbg_msg("used_bytes      %lld", vol->used_bytes);
+	dbg_msg("last_eb_bytes   %d", vol->last_eb_bytes);
+	dbg_msg("corrupted       %d", vol->corrupted);
+	dbg_msg("upd_marker      %d", vol->upd_marker);
+
+	if (vol->name_len <= UBI_VOL_NAME_MAX &&
+	    strnlen(vol->name, vol->name_len + 1) == vol->name_len) {
+		dbg_msg("name          %s", vol->name);
+	} else {
+		dbg_msg("the 1st 5 characters of the name: %c%c%c%c%c",
+			vol->name[0], vol->name[1], vol->name[2],
+			vol->name[3], vol->name[4]);
+	}
+}
+
+/**
+ * ubi_dbg_dump_vtbl_record - dump a &struct ubi_vtbl_record object.
+ * @r: the object to dump
+ * @idx: volume table index
+ */
+void ubi_dbg_dump_vtbl_record(const struct ubi_vtbl_record *r, int idx)
+{
+	int name_len = ubi16_to_cpu(r->name_len);
+
+	dbg_msg("volume table record %d dump:", idx);
+	dbg_msg("reserved_pebs   %d", ubi32_to_cpu(r->reserved_pebs));
+	dbg_msg("alignment       %d", ubi32_to_cpu(r->alignment));
+	dbg_msg("data_pad        %d", ubi32_to_cpu(r->data_pad));
+	dbg_msg("vol_type        %d", (int)r->vol_type);
+	dbg_msg("upd_marker      %d", (int)r->upd_marker);
+	dbg_msg("name_len        %d", name_len);
+
+	if (r->name[0] == '\0') {
+		dbg_msg("name          NULL");
+		return;
+	}
+
+	if (name_len <= UBI_VOL_NAME_MAX &&
+	    strnlen(&r->name[0], name_len + 1) == name_len) {
+		dbg_msg("name          %s", &r->name[0]);
+	} else {
+		dbg_msg("1st 5 characters of the name: %c%c%c%c%c",
+			r->name[0], r->name[1], r->name[2], r->name[3],
+			r->name[4]);
+	}
+	dbg_msg("crc             %#08x", ubi32_to_cpu(r->crc));
+}
+
+/**
+ * ubi_dbg_dump_sv - dump a &struct ubi_scan_volume object.
+ * @sv: the object to dump
+ */
+void ubi_dbg_dump_sv(const struct ubi_scan_volume *sv)
+{
+	dbg_msg("volume scanning information dump:");
+	dbg_msg("vol_id         %d", sv->vol_id);
+	dbg_msg("highest_lnum   %d", sv->highest_lnum);
+	dbg_msg("leb_count      %d", sv->leb_count);
+	dbg_msg("compat         %d", sv->compat);
+	dbg_msg("vol_type       %d", sv->vol_type);
+	dbg_msg("used_ebs       %d", sv->used_ebs);
+	dbg_msg("last_data_size %d", sv->last_data_size);
+	dbg_msg("data_pad       %d", sv->data_pad);
+}
+
+/**
+ * ubi_dbg_dump_seb - dump a &struct ubi_scan_leb object.
+ * @seb: the object to dump
+ * @type: object type: 0 - not corrupted, 1 - corrupted
+ */
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type)
+{
+	dbg_msg("eraseblock scanning information dump:");
+	dbg_msg("ec       %d", seb->ec);
+	dbg_msg("pnum     %d", seb->pnum);
+	if (type == 0) {
+		dbg_msg("lnum     %d", seb->lnum);
+		dbg_msg("scrub    %d", seb->scrub);
+		dbg_msg("sqnum    %llu", seb->sqnum);
+		dbg_msg("leb_ver  %u", seb->leb_ver);
+	}
+}
+
+/**
+ * ubi_dbg_dump_mkvol_req - dump a &struct ubi_mkvol_req object.
+ * @req: the object to dump
+ */
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req)
+{
+	char nm[17];
+
+	dbg_msg("volume creation request dump:");
+	dbg_msg("vol_id    %d",   req->vol_id);
+	dbg_msg("alignment %d",   req->alignment);
+	dbg_msg("bytes     %lld", (long long)req->bytes);
+	dbg_msg("vol_type  %d",   req->vol_type);
+	dbg_msg("name_len  %d",   req->name_len);
+
+	memcpy(nm, req->name, 16);
+	nm[16] = 0;
+	dbg_msg("the 1st 16 characters of the name: %s", nm);
+}
+
+#define BYTES_PER_LINE 32
+
+/**
+ * ubi_dbg_hexdump - dump a buffer.
+ * @ptr: the buffer to dump
+ * @size: buffer size which must be multiple of 4 bytes
+ */
+void ubi_dbg_hexdump(const void *ptr, int size)
+{
+	int i, k = 0, rows, columns;
+	const uint8_t *p = ptr;
+
+	size = ALIGN(size, 4);
+	rows = size/BYTES_PER_LINE + size % BYTES_PER_LINE;
+	for (i = 0; i < rows; i++) {
+		int j;
+
+		cond_resched();
+		columns = min(size - k, BYTES_PER_LINE) / 4;
+		if (columns == 0)
+			break;
+		printk(KERN_DEBUG "%5d:  ", i * BYTES_PER_LINE);
+		for (j = 0; j < columns; j++) {
+			int n, N;
+
+			N = size - k > 4 ? 4 : size - k;
+			for (n = 0; n < N; n++)
+				printk("%02x", p[k++]);
+			printk(" ");
+		}
+		printk("\n");
+	}
+}
+
+#endif /* CONFIG_MTD_UBI_DEBUG_MSG */
diff -auNrp tmp-from/drivers/mtd/ubi/debug.h tmp-to/drivers/mtd/ubi/debug.h
--- tmp-from/drivers/mtd/ubi/debug.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.h	2007-03-23 18:20:01.000000000 +0200
@@ -0,0 +1,161 @@
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
+#ifndef __UBI_DEBUG_H__
+#define __UBI_DEBUG_H__
+
+#ifdef CONFIG_MTD_UBI_DEBUG
+#include <linux/random.h>
+
+#define ubi_assert(expr)  BUG_ON(!(expr))
+#define dbg_err(fmt, ...) ubi_err(fmt, ##__VA_ARGS__)
+#else
+#define ubi_assert(expr)  ({})
+#define dbg_err(fmt, ...) ({})
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_DISABLE_BGT
+#define DBG_DISABLE_BGT 1
+#else
+#define DBG_DISABLE_BGT 0
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG
+/* Generic debugging message */
+#define dbg_msg(fmt, ...) \
+	printk(KERN_DEBUG "UBI DBG: %s: " fmt "\n", __FUNCTION__, ##__VA_ARGS__)
+
+#define ubi_dbg_dump_stack() dump_stack()
+
+struct ubi_ec_hdr;
+struct ubi_vid_hdr;
+struct ubi_volume;
+struct ubi_vtbl_record;
+struct ubi_scan_volume;
+struct ubi_scan_leb;
+struct ubi_mkvol_req;
+
+void ubi_dbg_print(int type, const char *func, const char *fmt, ...);
+void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr);
+void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr);
+void ubi_dbg_dump_vol_info(const struct ubi_volume *vol);
+void ubi_dbg_dump_vtbl_record(const struct ubi_vtbl_record *r, int idx);
+void ubi_dbg_dump_sv(const struct ubi_scan_volume *sv);
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type);
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req);
+void ubi_dbg_hexdump(const void *buf, int size);
+
+#else
+
+#define dbg_msg(fmt, ...)    ({})
+#define ubi_dbg_dump_stack() ({})
+#define ubi_dbg_print(func, fmt, ...)    ({})
+#define ubi_dbg_dump_ec_hdr(ec_hdr)      ({})
+#define ubi_dbg_dump_vid_hdr(vid_hdr)    ({})
+#define ubi_dbg_dump_vol_info(vol)       ({})
+#define ubi_dbg_dump_vtbl_record(r, idx) ({})
+#define ubi_dbg_dump_sv(sv)              ({})
+#define ubi_dbg_dump_seb(seb, type)      ({})
+#define ubi_dbg_dump_mkvol_req(req)      ({})
+#define ubi_dbg_hexdump(buf, size)       ({})
+
+#endif /* CONFIG_MTD_UBI_DEBUG_MSG */
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_EBA
+/* Messages from the eraseblock association unit */
+#define dbg_eba(fmt, ...) \
+	printk(KERN_DEBUG "UBI DBG eba: %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+#else
+#define dbg_eba(fmt, ...) ({})
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_WL
+/* Messages from the wear-leveling unit */
+#define dbg_wl(fmt, ...) \
+	printk(KERN_DEBUG "UBI DBG wl: %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+#else
+#define dbg_wl(fmt, ...) ({})
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_IO
+/* Messages from the input/output unit */
+#define dbg_io(fmt, ...) \
+	printk(KERN_DEBUG "UBI DBG io: %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+#else
+#define dbg_io(fmt, ...) ({})
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_BLD
+/* Initialization and build messages */
+#define dbg_bld(fmt, ...) \
+	printk(KERN_DEBUG "UBI DBG bld: %s: " fmt "\n", __FUNCTION__, \
+	       ##__VA_ARGS__)
+#else
+#define dbg_bld(fmt, ...) ({})
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_BITFLIPS
+/**
+ * ubi_dbg_is_bitflip - if it is time to emulate a bit-flip.
+ *
+ * Returns non-zero if a bit-flip should be emulated, otherwise returns zero.
+ */
+static inline int ubi_dbg_is_bitflip(void)
+{
+	return !(random32() % 200);
+}
+#else
+#define ubi_dbg_is_bitflip() 0
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES
+/**
+ * ubi_dbg_is_write_failure - if it is time to emulate a write failure.
+ *
+ * Returns non-zero if a write failure should be emulated, otherwise returns
+ * zero.
+ */
+static inline int ubi_dbg_is_write_failure(void)
+{
+	return !(random32() % 500);
+}
+#else
+#define ubi_dbg_is_write_failure() 0
+#endif
+
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES
+/**
+ * ubi_dbg_is_erase_failure - if its time to emulate an erase failure.
+ *
+ * Returns non-zero if an erase failure should be emulated, otherwise returns
+ * zero.
+ */
+static inline int ubi_dbg_is_erase_failure(void)
+{
+		return !(random32() % 400);
+}
+#else
+#define ubi_dbg_is_erase_failure() 0
+#endif
+
+#endif /* !__UBI_DEBUG_H__ */
