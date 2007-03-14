Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbXCNPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbXCNPWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbXCNPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:21:58 -0400
Received: from smtp.nokia.com ([131.228.20.170]:63496 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927AbXCNPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:21:37 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:10 +0200
Message-Id: <20070314152110.1112.89392.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/22 take 3] UBI: debugging stuff
X-OriginalArrivalTime: 14 Mar 2007 15:21:10.0071 (UTC) FILETIME=[64F58C70:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172116-1EAC7BB0-5A8E7AA6/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/debug.c tmp-to/drivers/mtd/ubi/debug.c
--- tmp-from/drivers/mtd/ubi/debug.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,546 @@
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
+/**
+ * Here we keep all the UBI debugging stuff which should normally be disabled
+ * and compiled-out, but it is extremly helpful when hunting bugs or doing big
+ * changes.
+ */
+
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/stat.h>
+#include <linux/random.h>
+#include "ubi.h"
+
+/* Level of UBI debugging prints */
+#define UBI_DBG_LEVEL KERN_DEBUG
+
+/* Prefixes of debugging messages */
+#define UBI_DBG_UIF_PREF     "[UBI DBG uif]"
+#define UBI_DBG_VTBL_PREF    "[UBI DBG vtbl]"
+#define UBI_DBG_EBA_PREF     "[UBI DBG eba]"
+#define UBI_DBG_WL_PREF      "[UBI DBG wl]"
+#define UBI_DBG_IO_PREF      "[UBI DBG io]"
+#define UBI_DBG_BLD_PREF     "[UBI DBG bld]"
+#define UBI_DBG_SCAN_PREF    "[UBI DBG scan]"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_UIF
+static int uif_prints = 1;
+#else
+static int uif_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_VTBL
+static int vtbl_prints = 1;
+#else
+static int vtbl_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_EBA
+static int eba_prints = 1;
+#else
+static int eba_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_WL
+static int wl_prints = 1;
+#else
+static int wl_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_IO
+static int io_prints = 1;
+#else
+static int io_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_BLD
+static int bld_prints = 1;
+static int scan_prints = 1;
+#else
+static int bld_prints;
+static int scan_prints;
+#endif
+
+/* If bit-flips should be emulated */
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_BITFLIPS
+static int emulate_bitflips = 1;
+#else
+static int emulate_bitflips;
+#endif
+
+/* If write failures should be emulated */
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES
+static int emulate_write_failures = 1;
+#else
+static int emulate_write_failures;
+#endif
+
+/* If erase failures should be emulated */
+#ifdef CONFIG_MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES
+static int emulate_erase_failures = 1;
+#else
+static int emulate_erase_failures;
+#endif
+
+/* Direntries of the UBI debugfs files */
+
+/* <debugfs>/ubi */
+static struct dentry *debugfs_root;
+/* <debugfs>/ubi/uif_prints */
+static struct dentry *debugfs_uif_prints;
+/* <debugfs>/ubi/vtbl_prints */
+static struct dentry *debugfs_vtbl_prints;
+/* <debugfs>/ubi/eba_prints */
+static struct dentry *debugfs_eba_prints;
+/* <debugfs>/ubi/wl_prints */
+static struct dentry *debugfs_wl_prints;
+/* <debugfs>/ubi/io_prints */
+static struct dentry *debugfs_io_prints;
+/* <debugfs>/ubi/bld_prints */
+static struct dentry *debugfs_bld_prints;
+
+/* Serializes prints */
+static spinlock_t dbg_prints_lock = SPIN_LOCK_UNLOCKED;
+
+/**
+ * ubi_dbg_init - initialize the debugging unit.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int __init ubi_dbg_init(void)
+{
+	int err = -ENODEV;
+
+	/* Create debugging files and directories */
+
+	debugfs_root = debugfs_create_dir("ubi", NULL);
+	if (!debugfs_root || IS_ERR(debugfs_root))
+		goto out;
+
+	debugfs_uif_prints = debugfs_create_bool("uif_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &uif_prints);
+	if (!debugfs_uif_prints || IS_ERR(debugfs_uif_prints))
+		goto out_root;
+
+	debugfs_vtbl_prints = debugfs_create_bool("vtbl_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &vtbl_prints);
+	if (!debugfs_vtbl_prints || IS_ERR(debugfs_vtbl_prints))
+		goto out_uif;
+
+	debugfs_eba_prints = debugfs_create_bool("eba_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &eba_prints);
+	if (!debugfs_eba_prints || IS_ERR(debugfs_eba_prints))
+		goto out_vtbl;
+
+	debugfs_wl_prints = debugfs_create_bool("wl_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &wl_prints);
+	if (!debugfs_wl_prints || IS_ERR(debugfs_wl_prints))
+		goto out_eba;
+
+	debugfs_io_prints = debugfs_create_bool("io_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &io_prints);
+	if (!debugfs_io_prints || IS_ERR(debugfs_io_prints))
+		goto out_wl;
+
+	debugfs_bld_prints = debugfs_create_bool("bld_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &bld_prints);
+	if (!debugfs_bld_prints || IS_ERR(debugfs_bld_prints))
+		goto out_io;
+
+	return 0;
+
+out_io:
+	debugfs_remove(debugfs_io_prints);
+out_wl:
+	debugfs_remove(debugfs_wl_prints);
+out_eba:
+	debugfs_remove(debugfs_eba_prints);
+out_vtbl:
+	debugfs_remove(debugfs_vtbl_prints);
+out_uif:
+	debugfs_remove(debugfs_uif_prints);
+out_root:
+        debugfs_remove(debugfs_root);
+out:
+	return err;
+}
+
+/**
+ * ubi_dbg_close - close the debugging unit.
+ */
+void __exit ubi_dbg_close(void)
+{
+	debugfs_remove(debugfs_bld_prints);
+	debugfs_remove(debugfs_io_prints);
+	debugfs_remove(debugfs_wl_prints);
+	debugfs_remove(debugfs_eba_prints);
+	debugfs_remove(debugfs_vtbl_prints);
+	debugfs_remove(debugfs_uif_prints);
+	debugfs_remove(debugfs_root);
+}
+
+static void ubi_dbg_vprint_nolock(int type, const char *func, const char *fmt,
+				  va_list args);
+
+/**
+ * ubi_dbg_print - print a message.
+ *
+ * @type: type of the message
+ * @func: printing function name
+ * @fmt: format string
+ *
+ * This function prints a message to the console, the debugging log, or both.
+ * Normal, warning, and error messages always go to both console and debugging
+ * log. Debugging messages always go to the debugging log, and if the
+ * corresponding option is enabled, they also go to the console.
+ */
+void ubi_dbg_print(int type, const char *func, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	spin_lock(&dbg_prints_lock);
+	ubi_dbg_vprint_nolock(type, func, fmt, args);
+	spin_unlock(&dbg_prints_lock);
+	va_end(args);
+}
+
+static void ubi_dbg_vprint_nolock(int type, const char *func, const char *fmt,
+				  va_list args)
+{
+	const char *prefix;
+
+	switch (type) {
+	case UBI_DBG_UIF:
+		if (!uif_prints)
+			return;
+		prefix = UBI_DBG_UIF_PREF;
+		break;
+	case UBI_DBG_VTBL:
+		if (!vtbl_prints)
+			return;
+		prefix = UBI_DBG_VTBL_PREF;
+		break;
+	case UBI_DBG_EBA:
+		if (!eba_prints)
+			return;
+		prefix = UBI_DBG_EBA_PREF;
+		break;
+	case UBI_DBG_WL:
+		if (!wl_prints)
+			return;
+		prefix = UBI_DBG_WL_PREF;
+		break;
+	case UBI_DBG_IO:
+		if (!io_prints)
+			return;
+		prefix = UBI_DBG_IO_PREF;
+		break;
+	case UBI_DBG_BLD:
+		if (!bld_prints)
+			return;
+		prefix = UBI_DBG_BLD_PREF;
+		break;
+	case UBI_DBG_SCAN:
+		if (!scan_prints)
+			return;
+		prefix = UBI_DBG_SCAN_PREF;
+		break;
+	default:
+		BUG();
+		return;
+	}
+
+	printk(UBI_DBG_LEVEL "%s (pid:%d) ", prefix, current->pid);
+	if (func)
+		printk("%s: ", func);
+	vprintk(fmt, args);
+	printk("\n");
+}
+
+/**
+ * ubi_dbg_dump_ec_hdr - dump an erase counter header.
+ *
+ * @ec_hdr: the erase counter header to dump
+ */
+void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("erase counter header dump:");
+	ubi_msg("magic          %#08x", ubi32_to_cpu(ec_hdr->magic));
+	ubi_msg("version        %d",    (int)ec_hdr->version);
+	ubi_msg("ec             %llu",  (long long)ubi64_to_cpu(ec_hdr->ec));
+	ubi_msg("vid_hdr_offset %d",    ubi32_to_cpu(ec_hdr->vid_hdr_offset));
+	ubi_msg("data_offset    %d",    ubi32_to_cpu(ec_hdr->data_offset));
+	ubi_msg("hdr_crc        %#08x", ubi32_to_cpu(ec_hdr->hdr_crc));
+	ubi_msg("erase counter header hexdump:");
+	spin_unlock(&dbg_prints_lock);
+	ubi_dbg_hexdump(ec_hdr, UBI_EC_HDR_SIZE);
+}
+
+/**
+ * ubi_dbg_dump_vid_hdr - dump a volume identifier header.
+ *
+ * @vid_hdr: the volume identifier header to dump
+ */
+void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume identifier header dump:");
+	ubi_msg("magic     %08x", ubi32_to_cpu(vid_hdr->magic));
+	ubi_msg("version   %d",   (int)vid_hdr->version);
+	ubi_msg("vol_type  %d",   (int)vid_hdr->vol_type);
+	ubi_msg("copy_flag %d",   (int)vid_hdr->copy_flag);
+	ubi_msg("compat    %d",   (int)vid_hdr->compat);
+	ubi_msg("vol_id    %d",   ubi32_to_cpu(vid_hdr->vol_id));
+	ubi_msg("lnum      %d",   ubi32_to_cpu(vid_hdr->lnum));
+	ubi_msg("leb_ver   %u",   ubi32_to_cpu(vid_hdr->leb_ver));
+	ubi_msg("data_size %d",   ubi32_to_cpu(vid_hdr->data_size));
+	ubi_msg("used_ebs  %d",   ubi32_to_cpu(vid_hdr->used_ebs));
+	ubi_msg("data_pad  %d",   ubi32_to_cpu(vid_hdr->data_pad));
+	ubi_msg("sqnum     %llu",
+		(unsigned long long)ubi64_to_cpu(vid_hdr->sqnum));
+	ubi_msg("hdr_crc   %08x", ubi32_to_cpu(vid_hdr->hdr_crc));
+	ubi_msg("volume identifier header hexdump:");
+	spin_unlock(&dbg_prints_lock);
+	ubi_dbg_hexdump(vid_hdr, UBI_VID_HDR_SIZE_CRC);
+}
+
+/**
+ * ubi_dbg_dump_vtr - dump a &struct ubi_vtbl_vtr object.
+ *
+ * @vtr: the object to dump
+ */
+void ubi_dbg_dump_vtr(const struct ubi_vtbl_vtr *vtr)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume table record dump:");
+	ubi_msg("reserved_pebs   %d", vtr->reserved_pebs);
+	ubi_msg("alignment       %d", vtr->alignment);
+	ubi_msg("data_pad        %d", vtr->data_pad);
+	ubi_msg("vol_type        %d", vtr->vol_type);
+	ubi_msg("name_len        %d", vtr->name_len);
+	ubi_msg("usable_leb_size %d", vtr->usable_leb_size);
+	ubi_msg("used_ebs        %d", vtr->used_ebs);
+	ubi_msg("used_bytes      %lld", vtr->used_bytes);
+	ubi_msg("last_eb_bytes   %d", vtr->last_eb_bytes);
+	ubi_msg("corrupted       %d", vtr->corrupted);
+	ubi_msg("upd_marker      %d", vtr->upd_marker);
+
+	if (vtr->name == NULL) {
+		ubi_msg("name          NULL");
+		spin_unlock(&dbg_prints_lock);
+		return;
+	}
+
+	if (vtr->name_len <= UBI_VOL_NAME_MAX &&
+	    strnlen(vtr->name, vtr->name_len + 1) == vtr->name_len) {
+		ubi_msg("name          %s", vtr->name);
+	} else {
+		ubi_msg("the 1st 5 characters of the name: %c%c%c%c%c",
+			vtr->name[0], vtr->name[1], vtr->name[2],
+			vtr->name[3], vtr->name[4]);
+	}
+
+	spin_unlock(&dbg_prints_lock);
+}
+
+/**
+ * ubi_dbg_dump_vol_tbl_record - dump a &struct ubi_vol_tbl_record object.
+ *
+ * @r: the object to dump
+ */
+void ubi_dbg_dump_vol_tbl_record(const struct ubi_vol_tbl_record *r)
+{
+	int name_len = ubi16_to_cpu(r->name_len);
+
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("raw volume table record dump:");
+	ubi_msg("reserved_pebs   %d", ubi32_to_cpu(r->reserved_pebs));
+	ubi_msg("alignment       %d", ubi32_to_cpu(r->alignment));
+	ubi_msg("data_pad        %d", ubi32_to_cpu(r->data_pad));
+	ubi_msg("vol_type        %d", (int)r->vol_type);
+	ubi_msg("upd_marker      %d", (int)r->upd_marker);
+	ubi_msg("name_len        %d", name_len);
+
+	if (r->name[0] == '\0') {
+		ubi_msg("name          NULL");
+		spin_unlock(&dbg_prints_lock);
+		return;
+	}
+
+	if (name_len <= UBI_VOL_NAME_MAX &&
+	    strnlen(&r->name[0], name_len + 1) == name_len) {
+		ubi_msg("name          %s", &r->name[0]);
+	} else {
+		ubi_msg("the 1st 5 characters of the name: %c%c%c%c%c",
+			r->name[0], r->name[1], r->name[2], r->name[3],
+			r->name[4]);
+	}
+	spin_unlock(&dbg_prints_lock);
+}
+
+/**
+ * ubi_dbg_dump_sv - dump a &struct ubi_scan_volume object.
+ *
+ * @sv: the object to dump
+ */
+void ubi_dbg_dump_sv(const struct ubi_scan_volume *sv)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume scanning information dump:");
+	ubi_msg("vol_id         %d", sv->vol_id);
+	ubi_msg("highest_lnum   %d", sv->highest_lnum);
+	ubi_msg("leb_count      %d", sv->leb_count);
+	ubi_msg("compat         %d", sv->compat);
+	ubi_msg("vol_type       %d", sv->vol_type);
+	ubi_msg("used_ebs       %d", sv->used_ebs);
+	ubi_msg("last_data_size %d", sv->last_data_size);
+	ubi_msg("data_pad       %d", sv->data_pad);
+	spin_unlock(&dbg_prints_lock);
+}
+
+/**
+ * ubi_dbg_dump_seb - dump a &struct ubi_scan_leb object.
+ *
+ * @seb: the object to dump
+ * @type: object type: 0 - not corrupted, 1 - corrupted
+ */
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("eraseblock scanning information dump:");
+	ubi_msg("ec       %d", seb->ec);
+	ubi_msg("pnum     %d", seb->pnum);
+	switch (type) {
+		case 0:
+			ubi_msg("lnum     %d", seb->lnum);
+			ubi_msg("scrub    %d", seb->scrub);
+			ubi_msg("sqnum    %llu", seb->sqnum);
+			ubi_msg("leb_ver  %u", seb->leb_ver);
+			break;
+		case 1:
+			break;
+	}
+	spin_unlock(&dbg_prints_lock);
+}
+
+/**
+ * ubi_dbg_dump_mkvol_req - dump a &struct ubi_mkvol_req object.
+ *
+ * @req: the object to dump
+ */
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req)
+{
+	char nm[17];
+
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume creation request dump:");
+	ubi_msg("vol_id    %d",   req->vol_id);
+	ubi_msg("alignment %d",   req->alignment);
+	ubi_msg("bytes     %lld", (long long)req->bytes);
+	ubi_msg("vol_type  %d",   req->vol_type);
+	ubi_msg("name_len  %d",   req->name_len);
+
+	memcpy(nm, req->name, 16);
+	nm[16] = 0;
+	ubi_msg("the 1st 16 characters of the name: %s", nm);
+	spin_unlock(&dbg_prints_lock);
+}
+
+#define BYTES_PER_LINE 32
+
+/**
+ * ubi_dbg_hexdump - dump a buffer.
+ *
+ * @buf: the buffer to dump
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
+
+		columns = min(size - k, BYTES_PER_LINE) / 4;
+		if (columns == 0)
+			break;
+
+		spin_lock(&dbg_prints_lock);
+		printk(UBI_DBG_LEVEL "%5d:  ", i * BYTES_PER_LINE);
+
+		for (j = 0; j < columns; j++) {
+			int n, N;
+
+			N = size - k > 4 ? 4 : size - k;
+			for (n = 0; n < N; n++)
+				printk("%02x", p[k++]);
+			printk(" ");
+		}
+		printk("\n");
+		spin_unlock(&dbg_prints_lock);
+	}
+}
+
+/**
+ * ubi_dbg_is_bitflip - if its time to emulate a bit-flip.
+ *
+ * Returns non-zero if a bit-flip should be emulated, otherwise returns zero.
+ */
+int ubi_dbg_is_bitflip(void)
+{
+	if (emulate_bitflips)
+		return !(random32() % 50);
+	else
+		return 0;
+}
+
+/**
+ * ubi_dbg_is_write_failure - if its time to emulate a write failure.
+ *
+ * Returns non-zero if a write failure should be emulated, otherwise returns
+ * zero.
+ */
+int ubi_dbg_is_write_failure(void)
+{
+	if (emulate_write_failures)
+		return !(random32() % 100);
+	else
+		return 0;
+}
+
+/**
+ * ubi_dbg_is_erase_failure - if its time to emulate an erase failure.
+ *
+ * Returns non-zero if an erase failure should be emulated, otherwise returns
+ * zero.
+ */
+int ubi_dbg_is_erase_failure(void)
+{
+	if (emulate_erase_failures)
+		return !(random32() % 100);
+	else
+		return 0;
+}
diff -auNrp tmp-from/drivers/mtd/ubi/debug.h tmp-to/drivers/mtd/ubi/debug.h
--- tmp-from/drivers/mtd/ubi/debug.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.h	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,146 @@
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
+#ifndef __UBI_DEBUG_H__
+#define __UBI_DEBUG_H__
+
+#ifdef CONFIG_MTD_UBI_DEBUG
+
+#ifdef CONFIG_MTD_UBI_DEBUG_DISABLE_BGT
+#define DBG_DISABLE_BGT 1
+#else
+#define DBG_DISABLE_BGT 0
+#endif
+#define UBI_DEBUG 1
+
+#define ubi_assert(expr) BUG_ON(!(expr))
+
+#define ubi_dbg_dump_stack() dump_stack()
+
+/* Debugging messages from different UBI units */
+
+/* A verbose error messages */
+#define dbg_err(fmt, ...) ubi_err(fmt, ##__VA_ARGS__)
+/* User interface unit */
+#define dbg_uif(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_UIF, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Volume table unit */
+#define dbg_vtbl(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_VTBL, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Eraseblock association unit */
+#define dbg_eba(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_EBA, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Wear-leveling unit */
+#define dbg_wl(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_WL, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Input/output unit */
+#define dbg_io(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_IO, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Build unit */
+#define dbg_bld(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_BLD, __FUNCTION__, fmt, ##__VA_ARGS__)
+/* Scanning unit */
+#define dbg_scan(fmt, ...) \
+	ubi_dbg_print(UBI_DBG_SCAN, __FUNCTION__, fmt, ##__VA_ARGS__)
+
+/**
+ * UBI message types.
+ *
+ * @UBI_DBG_UIF: a debugging message from the user interfaces unit
+ * @UBI_DBG_VTBL: a debugging message from the volume table unit
+ * @UBI_DBG_EBA: a debugging message from the eraseblock association unit
+ * @UBI_DBG_WL: a debugging message from the wear-leveling unit
+ * @UBI_DBG_IO: a debugging message from the input/output unit
+ * @UBI_DBG_BLD: a UBI build debugging message from the build unit
+ * @UBI_DBG_SCAN: a debugging message from the scanning unit
+ */
+enum {
+	UBI_DBG_UIF,
+	UBI_DBG_VTBL,
+	UBI_DBG_EBA,
+	UBI_DBG_WL,
+	UBI_DBG_IO,
+	UBI_DBG_BLD,
+	UBI_DBG_SCAN
+};
+
+struct ubi_ec_hdr;
+struct ubi_vid_hdr;
+struct ubi_vtbl_vtr;
+struct ubi_vol_tbl_record;
+struct ubi_scan_volume;
+struct ubi_scan_leb;
+struct ubi_mkvol_req;
+
+void ubi_dbg_print(int type, const char *func, const char *fmt, ...);
+void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr);
+void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr);
+void ubi_dbg_dump_vtr(const struct ubi_vtbl_vtr *vtr);
+void ubi_dbg_dump_vol_tbl_record(const struct ubi_vol_tbl_record *r);
+void ubi_dbg_dump_sv(const struct ubi_scan_volume *sv);
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type);
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req);
+void ubi_dbg_hexdump(const void *buf, int size);
+
+int ubi_dbg_is_bitflip(void);
+int ubi_dbg_is_write_failure(void);
+int ubi_dbg_is_erase_failure(void);
+
+int __init ubi_dbg_init(void);
+void __exit ubi_dbg_close(void);
+
+#else
+
+#define UBI_DEBUG 0
+
+#define DBG_DISABLE_BGT 0
+
+#define ubi_assert(expr) ({})
+
+#define dbg_err(fmt, ...)  ({})
+#define dbg_uif(fmt, ...)  ({})
+#define dbg_vtbl(fmt, ...) ({})
+#define dbg_eba(fmt, ...)  ({})
+#define dbg_wl(fmt, ...)   ({})
+#define dbg_io(fmt, ...)   ({})
+#define dbg_bld(fmt, ...)  ({})
+#define dbg_scan(fmt, ...) ({})
+
+#define ubi_dbg_print(func, fmt, ...)  ({})
+#define ubi_dbg_dump_stack()           ({})
+#define ubi_dbg_dump_ec_hdr(ec_hdr)    ({})
+#define ubi_dbg_dump_vid_hdr(vid_hdr)  ({})
+#define ubi_dbg_dump_vtr(vtr)          ({})
+#define ubi_dbg_dump_vol_tbl_record(r) ({})
+#define ubi_dbg_dump_sv(sv)            ({})
+#define ubi_dbg_dump_seb(seb, type)    ({})
+#define ubi_dbg_dump_mkvol_req(req)    ({})
+#define ubi_dbg_hexdump(buf, size)     ({})
+
+#define ubi_dbg_is_bitflip()       0
+#define ubi_dbg_is_write_failure() 0
+#define ubi_dbg_is_erase_failure() 0
+
+#define ubi_dbg_init()  0
+#define ubi_dbg_close()
+
+#endif /* !CONFIG_MTD_UBI_DEBUG */
+
+#endif /* !__UBI_DEBUG_H__ */
