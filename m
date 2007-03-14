Return-Path: <linux-kernel-owner+w=401wt.eu-S1422664AbXCNPUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422664AbXCNPUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXCNPUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:20:44 -0400
Received: from smtp.nokia.com ([131.228.20.171]:55376 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161338AbXCNPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:20:23 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:19:59 +0200
Message-Id: <20070314151959.1112.90035.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/22 take 3] UBI: startup code
X-OriginalArrivalTime: 14 Mar 2007 15:19:59.0589 (UTC) FILETIME=[3AF2D950:01C7664C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070314172004-508E0BB0-7497440A/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/build.c tmp-to/drivers/mtd/ubi/build.c
--- tmp-from/drivers/mtd/ubi/build.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/build.c	2007-03-14 17:15:50.000000000 +0200
@@ -0,0 +1,467 @@
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
+ * Author: Artem B. Bityutskiy,
+ *         Frank Haverkamp
+ */
+
+/*
+ * UBI build unit.
+ *
+ * This unit is responsible for UBI initialization and for building UBI
+ * devices. At the moment UBI only one build method - scanning. But in futire
+ * we may add on-flash EBA table support and implement better build method.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/stringify.h>
+#include <linux/stat.h>
+#include "ubi.h"
+
+/* Maximum MTD device specification parameter length */
+#define UBI_MTD_PARAM_LEN_MAX 64
+
+/**
+ * struct mtd_dev_param - MTD device parameter description data structure.
+ *
+ * @name: MTD device name or number string
+ * @vid_hdr_offs: VID header offset
+ * @data_offs: data offset
+ */
+struct mtd_dev_param
+{
+	char name[UBI_MTD_PARAM_LEN_MAX];
+	int vid_hdr_offs;
+	int data_offs;
+};
+
+/* Numbers of elements set in the @mtd_dev_param array. */
+static int mtd_devs = 0;
+
+/* MTD devices specification parameters */
+static struct mtd_dev_param mtd_dev_param[UBI_MAX_DEVICES];
+
+/* Number of UBI devices in system */
+int ubis_num;
+
+/* All the UBI devices in system */
+struct ubi_info *ubis[UBI_MAX_DEVICES];
+
+/**
+ * attach_by_scanning - attach a MTD device using scanning method.
+ *
+ * @ubi: UBI device descriptor
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ *
+ * Note, currently this is the only method to attach UBI devices. Hopefully in
+ * the future we'll have more scalable attaching methods and avoid full media
+ * scanning. In this case scanning could be used as a fall-back attaching
+ * method.
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
+	err = ubi_vtbl_init_scan(ubi, si);
+	if (err)
+		goto out_si;
+
+	err = ubi_acc_init_scan(ubi, si);
+	if (err)
+		goto out_vtbl;
+
+	err = ubi_wl_init_scan(ubi, si);
+	if (err)
+		goto out_vtbl;
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
+out_vtbl:
+	ubi_vtbl_close(ubi);
+out_si:
+	ubi_scan_destroy_si(si);
+	return err;
+}
+
+/**
+ * detach_mtd_dev - detach an MTD device.
+ *
+ * @ubi: the UBI device description object
+ */
+static void detach_mtd_dev(struct ubi_info *ubi)
+{
+	int mtd_num = ubi->io.mtd_num, ubi_num = ubi->ubi_num;
+
+	dbg_bld("detaching mtd%d from ubi%d", mtd_num, ubi_num);
+
+	ubi_uif_close(ubi);
+	ubi_eba_close(ubi);
+	ubi_wl_close(ubi);
+	ubi_vtbl_close(ubi);
+	ubi_io_close(ubi);
+	kfree(ubis[ubi_num]);
+	ubis[ubi_num] = NULL;
+	ubis_num -= 1;
+	ubi_assert(ubis_num >= 0);
+
+	ubi_msg("detached mtd%d from ubi%d", mtd_num, ubi_num);
+}
+
+/**
+ * attach_mtd_dev - attach an MTD device.
+ *
+ * @mtd_dev: MTD device name or number string to attach
+ * @vid_hdr_offset: volume identifier header offset in physical eraseblocks
+ * @data_offset: data offset in physical eraseblock
+ *
+ * This function attaches an MTD device to UBI. It first treats @mtd_dev as the
+ * MTD device name, and tries to open it by this name. If it is unable to open,
+ * it tries to convert @mtd_dev to an integer and open the MTD device by its
+ * number. Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+static int attach_mtd_dev(const char *mtd_dev, int vid_hdr_offset,
+			  int data_offset)
+{
+	struct mtd_info *mtd;
+	int i, err, mtd_num, ubi_num = ubis_num;
+	struct ubi_info *ubi;
+
+	if (ubis_num == UBI_MAX_DEVICES) {
+		ubi_err("too many UBI devices, max. is %d", UBI_MAX_DEVICES);
+		return -EINVAL;
+	}
+
+	mtd = get_mtd_device_nm(mtd_dev);
+	if (IS_ERR(mtd)) {
+		char *endp;
+
+		if (PTR_ERR(mtd) != -ENODEV)
+			return PTR_ERR(mtd);
+
+		/*
+		 * Probably this is not MTD device name but MTD device number -
+		 * check it out.
+		 */
+		mtd_num = simple_strtoul(mtd_dev, &endp, 0);
+		if (*endp != '\0' || mtd_dev == endp) {
+			ubi_err("incorrect MTD device: \"%s\"", mtd_dev);
+			return -ENODEV;
+		}
+
+		mtd = get_mtd_device(NULL, mtd_num);
+		if (IS_ERR(mtd))
+			return PTR_ERR(mtd);
+	}
+
+	mtd_num = mtd->index;
+
+	/*
+	 * Ok, now we know MTD device number. Close it and let I/O unit to deal
+	 * with it later.
+	 */
+	put_mtd_device(mtd);
+
+	/* Check if we already have the same MTD device attached */
+	for (i = 0; i < ubis_num; i++)
+		if (ubis[i]->io.mtd_num == mtd_num) {
+			ubi_err("mtd%d is already attached to ubi%d",
+				mtd_num, i);
+			return -EINVAL;
+		}
+
+	ubi = ubis[ubi_num] = kzalloc(sizeof(struct ubi_info), GFP_KERNEL);
+	if (!ubis[ubi_num])
+		return -ENOMEM;
+
+	ubi->ubi_num = ubi_num;
+
+	dbg_bld("attaching mtd%d to ubi%d", mtd_num, ubi_num);
+
+	err = ubi_io_init(ubi, mtd_num, vid_hdr_offset, data_offset);
+	if (err) {
+		dbg_err("failed to initialize I/O unit, error %d", err);
+		goto out_free;
+	}
+
+	err = attach_by_scanning(ubi);
+	if (err) {
+		dbg_err("failed to attach MTD device, error %d", err);
+		goto out_io;
+	}
+
+	err = ubi_uif_init(ubi);
+	if (err) {
+		dbg_err("failed to initialize user interfaces unit, error %d",
+			err);
+		goto out_detach;
+	}
+
+	ubis_num += 1;
+
+	ubi_msg("attached mtd%d to ubi%d", mtd_num, ubi_num);
+	ubi_msg("MTD device name:            \"%s\"", ubi->io.mtd_name);
+	ubi_msg("MTD device size:            %llu MiB",
+		ubi->io.flash_size >> 20);
+	ubi_msg("physical eraseblock size:   %d bytes (%d KiB)",
+		ubi->io.peb_size, ubi->io.peb_size >> 10);
+	ubi_msg("logical eraseblock size:    %d bytes", ubi->io.leb_size);
+	ubi_msg("number of good PEBs:        %d", ubi->io.good_peb_count);
+	ubi_msg("number of bad PEBs:         %d", ubi->io.bad_peb_count);
+	ubi_msg("smallest flash I/O unit:    %d", ubi->io.min_io_size);
+	ubi_msg("VID header offset:          %d (aligned %d)",
+		ubi->io.vid_hdr_offset, ubi->io.vid_hdr_aloffset);
+	ubi_msg("data offset:                %d", ubi->io.leb_start);
+	ubi_msg("max. allowed volumes:       %d", ubi->vtbl.vt_slots);
+	ubi_msg("wear-leveling threshold:    %d", CONFIG_MTD_UBI_WL_THRESHOLD);
+	ubi_msg("number of internal volumes: %d", UBI_INT_VOL_COUNT);
+	ubi_msg("number of user volumes:     %d", ubi->vtbl.vol_count);
+	ubi_msg("available PEBs:             %d", ubi->acc.avail_pebs);
+	ubi_msg("total number of reserved PEBs: %d", ubi->acc.rsvd_pebs);
+	ubi_msg("number of PEBs reserved for bad PEB handling: %d",
+		ubi->acc.beb_rsvd_pebs);
+
+	ubi_wl_enable_thread(ubi);
+
+	return 0;
+
+out_detach:
+	ubi_eba_close(ubi);
+	ubi_wl_close(ubi);
+	ubi_vtbl_close(ubi);
+out_io:
+	ubi_io_close(ubi);
+out_free:
+	kfree(ubi);
+	ubis[ubi_num] = NULL;
+	return err;
+}
+
+static int __init ubi_init(void)
+{
+	int err, i, k;
+
+	if (mtd_devs > UBI_MAX_DEVICES) {
+		printk("UBI error: too many MTD devices, max. is %d\n",
+		       UBI_MAX_DEVICES);
+		return -EINVAL;
+	}
+
+	err = ubi_dbg_init();
+	if (err) {
+		printk("UBI error: failed to initialize debugging unit, "
+		       "error %d", err);
+		return err;
+	}
+
+	err = ubi_sysfs_infr_init();
+	if (err) {
+		ubi_err("failed to initialize sysfs infrastructure, error %d",
+			err);
+		goto out_dbg;
+	}
+
+	/* Attach MTD devices */
+	for (i = 0; i < mtd_devs; i++) {
+		struct mtd_dev_param *p = &mtd_dev_param[i];
+
+		cond_resched();
+
+		if (!p->name) {
+			dbg_err("empty name");
+			err = -EINVAL;
+			goto out_detach;
+		}
+
+		err = attach_mtd_dev(p->name, p->vid_hdr_offs, p->data_offs);
+		if (err)
+			goto out_detach;
+	}
+
+	return 0;
+
+out_detach:
+	for (k = 0; k < i; k++)
+		detach_mtd_dev(ubis[k]);
+	ubi_sysfs_infr_close();
+out_dbg:
+	ubi_dbg_close();
+	return err;
+}
+module_init(ubi_init);
+
+static void __exit ubi_exit(void)
+{
+	int i, n = ubis_num;
+
+	for (i = 0; i < n; i++)
+		detach_mtd_dev(ubis[i]);
+	ubi_sysfs_infr_close();
+	ubi_dbg_close();
+}
+module_exit(ubi_exit);
+
+/*
+ * bytes_str_to_int - convert a string representing a number of bytes to an
+ * integer.
+ *
+ * @str: the string to convert
+ *
+ * This function returns positive resulting integer in case of success and a
+ * negative error code in case of failure.
+ */
+static int __init bytes_str_to_int(const char *str)
+{
+	char *endp;
+	unsigned long result;
+
+	result = simple_strtoul(str, &endp, 0);
+	if (str == endp || result < 0) {
+		printk("UBI error: incorrect bytes count: \"%s\"\n", str);
+		return -EINVAL;
+	}
+
+	switch (*endp) {
+	case 'G':
+		result *= 1024;
+	case 'M':
+		result *= 1024;
+	case 'K':
+	case 'k':
+		result *= 1024;
+		if (endp[1] == 'i' && (endp[2] == '\0' ||
+			  endp[2] == 'B'  || endp[2] == 'b'))
+			endp += 2;
+	case '\0':
+		break;
+	default:
+		printk("UBI error: incorrect bytes count: \"%s\"\n", str);
+		return -EINVAL;
+	}
+
+	return result;
+}
+
+/**
+ * ubi_mtd_param_parse - parse the "mtd" UBI parameter.
+ *
+ * @val: the parameter value to parse
+ * @kp: not used
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of error.
+ */
+static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
+{
+	int i, len;
+	struct mtd_dev_param *p;
+	char buf[UBI_MTD_PARAM_LEN_MAX];
+	char *pbuf = &buf[0];
+	char *tokens[3] = {NULL, NULL, NULL};
+
+	/* Ensure EC and VID headers have correct size */
+	BUILD_BUG_ON(sizeof(struct ubi_ec_hdr) != 64);
+	BUILD_BUG_ON(sizeof(struct ubi_vid_hdr) != 64);
+
+	if (mtd_devs == UBI_MAX_DEVICES) {
+		printk("UBI error: too many parameters, max. is %d\n",
+		       UBI_MAX_DEVICES);
+		return -EINVAL;
+	}
+
+	len = strnlen(val, UBI_MTD_PARAM_LEN_MAX);
+	if (len == UBI_MTD_PARAM_LEN_MAX) {
+		printk("UBI error: parameter \"%s\" is too long, max. is %d\n",
+		       val, UBI_MTD_PARAM_LEN_MAX);
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		printk("UBI warning: empty \"mtd\" parameter - ignored\n");
+		return 0;
+	}
+
+	strcpy(buf, val);
+
+	/* Get rid of the final newline */
+	if (buf[len - 1] == '\n')
+		buf[len - 1] = 0;
+
+	for (i = 0; i < 3; i++)
+		tokens[i] = strsep(&pbuf, ",");
+
+	if (pbuf) {
+		printk("UBI error: too many arguments at \"%s\"\n", val);
+		return -EINVAL;
+	}
+
+	if (tokens[0] == '\0')
+		return -EINVAL;
+
+	p = &mtd_dev_param[mtd_devs];
+	strcpy(&p->name[0], tokens[0]);
+
+	if (tokens[1])
+		p->vid_hdr_offs = bytes_str_to_int(tokens[1]);
+	if (tokens[2])
+		p->data_offs = bytes_str_to_int(tokens[2]);
+
+	if (p->vid_hdr_offs < 0)
+		return p->vid_hdr_offs;
+	if (p->data_offs < 0)
+		return p->data_offs;
+
+	mtd_devs += 1;
+	return 0;
+}
+
+module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 000);
+MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
+		      "mtd=<name|num>[,<vid_hdr_offs>,<data_offs>]. "
+		      "Multiple \"mtd\" parameters may be specified.\n"
+		      "MTD devices may be specified by their number or name. "
+		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
+		      "specify UBI VID header position and data starting "
+		      "position to be used by UBI.\n"
+		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
+		      "with name content using VID header offset 1984 and data "
+		      "start 2048, and MTD device number 4 using default "
+		      "offsets");
+
+MODULE_VERSION(__stringify(UBI_VERSION));
+MODULE_DESCRIPTION("UBI - Unsorted Block Images");
+MODULE_AUTHOR("Artem B. Bityutskiy");
+MODULE_LICENSE("GPL");
