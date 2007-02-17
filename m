Return-Path: <linux-kernel-owner+w=401wt.eu-S2992464AbXBQQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992464AbXBQQzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992465AbXBQQzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:55:43 -0500
Received: from smtp.nokia.com ([131.228.20.171]:54975 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992464AbXBQQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:55:40 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:14 +0200
Message-Id: <20070217165514.5845.31845.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/44 take 2] [UBI] debug unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:54:42.0179 (UTC) FILETIME=[51B58530:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185305-3C652BB0-5EA84C4D/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/debug.c tmp-to/drivers/mtd/ubi/debug.c
--- tmp-from/drivers/mtd/ubi/debug.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/debug.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,634 @@
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
+#include <stdarg.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/stat.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/random.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "debug.h"
+#include "vtbl.h"
+#include "scan.h"
+
+/* Level of UBI debugging prints */
+#define UBI_DBG_LEVEL KERN_DEBUG
+
+/* Prefixes of debugging messages */
+#define UBI_DBG_VB_ERR_PREF  "[UBI DBG error]"
+#define UBI_DBG_UIF_PREF     "[UBI DBG uif]"
+#define UBI_DBG_CDEV_PREF    "[UBI DBG cdev]"
+#define UBI_DBG_GLUEBI_PREF  "[UBI DBG gluebi]"
+#define UBI_DBG_VMT_PREF     "[UBI DBG vmt]"
+#define UBI_DBG_UPD_PREF     "[UBI DBG upd]"
+#define UBI_DBG_VTBL_PREF    "[UBI DBG vtbl]"
+#define UBI_DBG_ACC_PREF     "[UBI DBG acc]"
+#define UBI_DBG_EBA_PREF     "[UBI DBG eba]"
+#define UBI_DBG_WL_PREF      "[UBI DBG wl]"
+#define UBI_DBG_BGT_PREF     "[UBI DBG bgt]"
+#define UBI_DBG_ALLOC_PREF   "[UBI DBG alloc]"
+#define UBI_DBG_IO_PREF      "[UBI DBG io]"
+#define UBI_DBG_BLD_PREF     "[UBI DBG bld]"
+#define UBI_DBG_SCAN_PREF    "[UBI DBG scan]"
+
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_VB_ERR
+static int vb_err_prints = 1;
+#else
+static int vb_err_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_UIF
+static int uif_prints = 1;
+#else
+static int uif_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_CDEV
+static int cdev_prints = 1;
+#else
+static int cdev_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_GLUEBI
+static int gluebi_prints = 1;
+#else
+static int gluebi_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_VMT
+static int vmt_prints = 1;
+#else
+static int vmt_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_UPD
+static int upd_prints = 1;
+#else
+static int upd_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_VTBL
+static int vtbl_prints = 1;
+#else
+static int vtbl_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_ACC
+static int acc_prints = 1;
+#else
+static int acc_prints;
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
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_BGT
+static int bgt_prints = 1;
+#else
+static int bgt_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_IO
+static int io_prints = 1;
+#else
+static int io_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_BLD
+static int bld_prints = 1;
+#else
+static int bld_prints;
+#endif
+#ifdef CONFIG_MTD_UBI_DEBUG_MSG_SCAN
+static int scan_prints = 1;
+#else
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
+/* <debugfs>/ubi/log */
+static struct dentry *debugfs_vb_err_prints;
+/* <debugfs>/ubi/uif_prints */
+static struct dentry *debugfs_uif_prints;
+/* <debugfs>/ubi/cdev_prints */
+static struct dentry *debugfs_cdev_prints;
+/* <debugfs>/ubi/gluebi_prints */
+static struct dentry *debugfs_gluebi_prints;
+/* <debugfs>/ubi/vmt_prints */
+static struct dentry *debugfs_vmt_prints;
+/* <debugfs>/ubi/upd_prints */
+static struct dentry *debugfs_upd_prints;
+/* <debugfs>/ubi/vtbl_prints */
+static struct dentry *debugfs_vtbl_prints;
+/* <debugfs>/ubi/acc_prints */
+static struct dentry *debugfs_acc_prints;
+/* <debugfs>/ubi/eba_prints */
+static struct dentry *debugfs_eba_prints;
+/* <debugfs>/ubi/wl_prints */
+static struct dentry *debugfs_wl_prints;
+/* <debugfs>/ubi/bgt_prints */
+static struct dentry *debugfs_bgt_prints;
+/* <debugfs>/ubi/io_prints */
+static struct dentry *debugfs_io_prints;
+/* <debugfs>/ubi/bld_prints */
+static struct dentry *debugfs_bld_prints;
+/* <debugfs>/ubi/scan_prints */
+static struct dentry *debugfs_scan_prints;
+
+/* Serializes prints */
+static spinlock_t dbg_prints_lock = SPIN_LOCK_UNLOCKED;
+
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
+	debugfs_vb_err_prints = debugfs_create_bool("vb_err_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &vb_err_prints);
+	if (!debugfs_vb_err_prints || IS_ERR(debugfs_vb_err_prints))
+		goto out_root;
+
+	debugfs_uif_prints = debugfs_create_bool("uif_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &uif_prints);
+	if (!debugfs_uif_prints || IS_ERR(debugfs_uif_prints))
+		goto out_vb_err;
+
+	debugfs_cdev_prints = debugfs_create_bool("cdev_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &cdev_prints);
+	if (!debugfs_cdev_prints || IS_ERR(debugfs_cdev_prints))
+		goto out_uif;
+
+	debugfs_gluebi_prints = debugfs_create_bool("gluebi_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &gluebi_prints);
+	if (!debugfs_gluebi_prints || IS_ERR(debugfs_gluebi_prints))
+		goto out_cdev;
+
+	debugfs_vmt_prints = debugfs_create_bool("vmt_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &vmt_prints);
+	if (!debugfs_vmt_prints || IS_ERR(debugfs_vmt_prints))
+		goto out_gluebi;
+
+	debugfs_upd_prints = debugfs_create_bool("upd_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &upd_prints);
+	if (!debugfs_upd_prints || IS_ERR(debugfs_upd_prints))
+		goto out_vmt;
+
+	debugfs_vtbl_prints = debugfs_create_bool("vtbl_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &vtbl_prints);
+	if (!debugfs_vtbl_prints || IS_ERR(debugfs_vtbl_prints))
+		goto out_upd;
+
+	debugfs_acc_prints = debugfs_create_bool("acc_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &acc_prints);
+	if (!debugfs_acc_prints || IS_ERR(debugfs_acc_prints))
+		goto out_vtbl;
+
+	debugfs_eba_prints = debugfs_create_bool("eba_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &eba_prints);
+	if (!debugfs_eba_prints || IS_ERR(debugfs_eba_prints))
+		goto out_acc;
+
+	debugfs_wl_prints = debugfs_create_bool("wl_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &wl_prints);
+	if (!debugfs_wl_prints || IS_ERR(debugfs_wl_prints))
+		goto out_eba;
+
+	debugfs_bgt_prints = debugfs_create_bool("bgt_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &bgt_prints);
+	if (!debugfs_bgt_prints || IS_ERR(debugfs_bgt_prints))
+		goto out_wl;
+
+	debugfs_io_prints = debugfs_create_bool("io_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &io_prints);
+	if (!debugfs_io_prints || IS_ERR(debugfs_io_prints))
+		goto out_bgt;
+
+	debugfs_bld_prints = debugfs_create_bool("bld_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &bld_prints);
+	if (!debugfs_bld_prints || IS_ERR(debugfs_bld_prints))
+		goto out_io;
+
+	debugfs_scan_prints = debugfs_create_bool("scan_prints",
+		S_IFREG | S_IRUGO | S_IWUGO, debugfs_root, &scan_prints);
+	if (!debugfs_scan_prints || IS_ERR(debugfs_scan_prints))
+		goto out_bld;
+
+	return 0;
+
+out_bld:
+	debugfs_remove(debugfs_bld_prints);
+out_io:
+	debugfs_remove(debugfs_io_prints);
+out_bgt:
+	debugfs_remove(debugfs_bgt_prints);
+out_wl:
+	debugfs_remove(debugfs_wl_prints);
+out_eba:
+	debugfs_remove(debugfs_eba_prints);
+out_acc:
+	debugfs_remove(debugfs_acc_prints);
+out_vtbl:
+	debugfs_remove(debugfs_vtbl_prints);
+out_upd:
+	debugfs_remove(debugfs_upd_prints);
+out_vmt:
+	debugfs_remove(debugfs_vmt_prints);
+out_gluebi:
+	debugfs_remove(debugfs_gluebi_prints);
+out_cdev:
+	debugfs_remove(debugfs_cdev_prints);
+out_uif:
+	debugfs_remove(debugfs_uif_prints);
+out_vb_err:
+	debugfs_remove(debugfs_vb_err_prints);
+out_root:
+        debugfs_remove(debugfs_root);
+out:
+	return err;
+}
+
+void __exit ubi_dbg_close(void)
+{
+	debugfs_remove(debugfs_scan_prints);
+	debugfs_remove(debugfs_bld_prints);
+	debugfs_remove(debugfs_io_prints);
+	debugfs_remove(debugfs_bgt_prints);
+	debugfs_remove(debugfs_wl_prints);
+	debugfs_remove(debugfs_eba_prints);
+	debugfs_remove(debugfs_acc_prints);
+	debugfs_remove(debugfs_vtbl_prints);
+	debugfs_remove(debugfs_upd_prints);
+	debugfs_remove(debugfs_vmt_prints);
+	debugfs_remove(debugfs_gluebi_prints);
+	debugfs_remove(debugfs_cdev_prints);
+	debugfs_remove(debugfs_uif_prints);
+	debugfs_remove(debugfs_vb_err_prints);
+	debugfs_remove(debugfs_root);
+}
+
+static void ubi_dbg_vprint_nolock(int type, const char *func, const char *fmt,
+				  va_list args);
+
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
+	case UBI_DBG_VB_ERR:
+		if (!vb_err_prints)
+			return;
+		prefix = UBI_DBG_VB_ERR_PREF;
+		break;
+	case UBI_DBG_UIF:
+		if (!uif_prints)
+			return;
+		prefix = UBI_DBG_UIF_PREF;
+		break;
+	case UBI_DBG_CDEV:
+		if (!cdev_prints)
+			return;
+		prefix = UBI_DBG_CDEV_PREF;
+		break;
+	case UBI_DBG_GLUEBI:
+		if (!gluebi_prints)
+			return;
+		prefix = UBI_DBG_GLUEBI_PREF;
+		break;
+	case UBI_DBG_VMT:
+		if (!vmt_prints)
+			return;
+		prefix = UBI_DBG_VMT_PREF;
+		break;
+	case UBI_DBG_UPD:
+		if (!upd_prints)
+			return;
+		prefix = UBI_DBG_UPD_PREF;
+		break;
+	case UBI_DBG_VTBL:
+		if (!vtbl_prints)
+			return;
+		prefix = UBI_DBG_VTBL_PREF;
+		break;
+	case UBI_DBG_ACC:
+		if (!acc_prints)
+			return;
+		prefix = UBI_DBG_ACC_PREF;
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
+	case UBI_DBG_BGT:
+		if (!bgt_prints)
+			return;
+		prefix = UBI_DBG_BGT_PREF;
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
+	ubi_msg("hdr_crc   %08x", ubi32_to_cpu(vid_hdr->hdr_crc));
+	ubi_msg("volume identifier header hexdump:");
+	spin_unlock(&dbg_prints_lock);
+	ubi_dbg_hexdump(vid_hdr, UBI_VID_HDR_SIZE_CRC);
+}
+
+void ubi_dbg_dump_vtr(const struct ubi_vtbl_vtr *vtr)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume table record dump:");
+	ubi_msg("reserved_pebs   %d", vtr->reserved_pebs);
+	ubi_msg("alignment       %d", vtr->alignment);
+	ubi_msg("data_pad        %d", vtr->data_pad);
+	ubi_msg("vol_type        %d", vtr->vol_type);
+	ubi_msg("name_len        %d", vtr->name_len);
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
+	ubi_msg("usable_leb_size %d",   vtr->usable_leb_size);
+	ubi_msg("used_ebs        %d",   vtr->used_ebs);
+	ubi_msg("used_bytes      %lld", (long long)vtr->used_bytes);
+	ubi_msg("last_eb_bytes   %d",   vtr->last_eb_bytes);
+	ubi_msg("corrupted       %d",   vtr->corrupted);
+	ubi_msg("upd_marker      %d",   vtr->upd_marker);
+	spin_unlock(&dbg_prints_lock);
+}
+
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
+void ubi_dbg_dump_seb(const struct ubi_scan_leb *seb, int type)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("eraseblock scanning information dump:");
+	ubi_msg("ec       %d", seb->ec);
+	ubi_msg("pnum     %d", seb->pnum);
+	switch (type) {
+		case 0:
+			ubi_msg("lnum     %d", seb->lnum);
+			ubi_msg("leb_ver  %u", seb->leb_ver);
+			break;
+		case 1:
+			break;
+	}
+	spin_unlock(&dbg_prints_lock);
+}
+
+void ubi_dbg_dump_mkvol_req(const struct ubi_mkvol_req *req, const char *name)
+{
+	spin_lock(&dbg_prints_lock);
+	ubi_msg("volume creation request dump:");
+	ubi_msg("vol_id    %d",   req->vol_id);
+	ubi_msg("alignment %d",   req->alignment);
+	ubi_msg("bytes     %lld", (long long)req->bytes);
+	ubi_msg("vol_type  %d",   req->vol_type);
+	ubi_msg("name_len  %d",   req->name_len);
+
+	if (name == NULL) {
+		ubi_msg("name      NULL");
+		spin_unlock(&dbg_prints_lock);
+		return;
+	}
+
+	if (req->name_len <= UBI_VOL_NAME_MAX &&
+	    strnlen(name, req->name_len + 1) == req->name_len) {
+		ubi_msg("name      %s", name);
+	} else {
+		ubi_msg("the 1st 5 characters of the name: %c%c%c%c%c",
+			name[0], name[1], name[2], name[3], name[4]);
+	}
+	spin_unlock(&dbg_prints_lock);
+}
+
+
+#define BYTES_PER_LINE 32
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
+int ubi_dbg_is_bitflip(void)
+{
+	if (emulate_bitflips)
+		return !(random32() % 50);
+	else
+		return 0;
+}
+
+int ubi_dbg_is_write_failure(void)
+{
+	if (emulate_write_failures)
+		return !(random32() % 100);
+	else
+		return 0;
+}
+
+int ubi_dbg_is_erase_failure(void)
+{
+	if (emulate_erase_failures)
+		return !(random32() % 100);
+	else
+		return 0;
+}
