Return-Path: <linux-kernel-owner+w=401wt.eu-S2992704AbXBQRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992704AbXBQRD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992707AbXBQRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:03:20 -0500
Received: from smtp.nokia.com ([131.228.20.170]:53062 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992596AbXBQRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:31 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:54:54 +0200
Message-Id: <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/44 take 2] [UBI] startup code
X-OriginalArrivalTime: 17 Feb 2007 16:54:22.0055 (UTC) FILETIME=[45B6D770:01C752B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/init.c tmp-to/drivers/mtd/ubi/init.c
--- tmp-from/drivers/mtd/ubi/init.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/init.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,371 @@
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
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/sched.h>
+#include <linux/stringify.h>
+#include <linux/types.h>
+#include <linux/stat.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "uif.h"
+#include "io.h"
+#include "build.h"
+#include "debug.h"
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
+static struct mtd_dev_param mtd_dev_param[UBI_MAX_INSTANCES];
+
+/* Number of UBI devices in system */
+int ubis_num;
+
+/* All the UBI devices in system */
+struct ubi_info *ubis[UBI_MAX_INSTANCES];
+
+/* UBI headers must take 64 bytes. The below is a hacky way to ensure this */
+static int __ubi_check_ec_hdr_size[(UBI_EC_HDR_SIZE == 64) - 1]
+    __attribute__ ((__unused__));
+static int __ubi_check_ec_hdr_size[(UBI_VID_HDR_SIZE == 64) - 1]
+    __attribute__ ((__unused__));
+
+static int ubi_attach_mtd_dev(const char *mtd_dev, int vid_hdr_offset,
+			      int data_offset);
+static void ubi_destroy_dev(int ubi_num);
+
+static int __init ubi_init(void)
+{
+	int err, i, k;
+
+	if (mtd_devs > UBI_MAX_INSTANCES) {
+		printk("UBI error: too many MTD devices, max. is %d\n",
+		       UBI_MAX_INSTANCES);
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
+	err = ubi_alloc_init();
+	if (err) {
+		dbg_err("failed to initialize memory allocation unit, "
+			"error %d", err);
+		goto out_dbg;
+	}
+
+	/* Initialize the user interface unit */
+	err = ubi_uif_global_init();
+	if (err) {
+		dbg_err("failed to initialize user interfaces unit, error %d",
+			err);
+		goto out_alloc;
+	}
+
+	/* Attach MTD devices */
+	for (i = 0; i < mtd_devs; i++) {
+		struct mtd_dev_param *p = &mtd_dev_param[i];
+
+		cond_resched();
+		err = -EINVAL;
+
+		/* First suppose this is MTD device name */
+		err = ubi_attach_mtd_dev(p->name, p->vid_hdr_offs,
+					 p->data_offs);
+		if (err)
+			goto out_detach;
+	}
+
+	return 0;
+
+out_detach:
+	for (k = 0; k < i; k++)
+		ubi_destroy_dev(k);
+	ubi_uif_global_close();
+out_alloc:
+	ubi_alloc_close();
+out_dbg:
+	ubi_dbg_close();
+	return err;
+}
+module_init(ubi_init);
+
+static void __exit ubi_exit(void)
+{
+	int i;
+
+	for (i = 0; i < ubis_num; i++)
+		ubi_destroy_dev(i);
+	ubi_uif_global_close();
+	ubi_alloc_close();
+	ubi_dbg_close();
+}
+module_exit(ubi_exit);
+
+/**
+ * ubi_attach_mtd_dev - attach an MTD device.
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
+static int ubi_attach_mtd_dev(const char *mtd_dev, int vid_hdr_offset,
+			      int data_offset)
+{
+	struct mtd_info *mtd;
+	int i, err, mtd_num, ubi_num;
+
+	if (!mtd_dev)
+		return -EINVAL;
+
+	if (ubis_num == UBI_MAX_INSTANCES) {
+		ubi_err("too many UBI devices, max. is %d", UBI_MAX_INSTANCES);
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
+	put_mtd_device(mtd);
+
+	/* Check is we already have the same MTD device attached */
+	for (i = 0; i < ubis_num; i++)
+		if (ubis[i]->io->mtd_num == mtd_num) {
+			ubi_err("mtd%d is already attached to ubi%d",
+				mtd_num, i);
+			return -EINVAL;
+		}
+
+	ubi_num = ubis_num++;
+
+	ubis[ubi_num] = ubi_kzalloc(sizeof(struct ubi_info));
+	if (!ubis[ubi_num])
+		return -ENOMEM;
+
+	ubis[ubi_num]->ubi_num = ubi_num;
+
+	err = ubi_bld_attach_mtd_dev(ubis[ubi_num], mtd_num, vid_hdr_offset,
+				     data_offset);
+	if (err)
+		goto out_free;
+
+	if (ubi_num == ubis_num)
+		ubis_num += 1;
+
+	return 0;
+
+out_free:
+	ubi_kfree(ubis[i]);
+	return -ENODEV;
+}
+
+/**
+ * ubi_destroy_dev - destroy an UBI device.
+ *
+ * @ubi_num: UBI device number to destroy
+ *
+ * In current UBI implementation UBI devices are static and cannot dynamically
+ * go and come. So this function is only used when UBI is de-initialized.
+ */
+static void ubi_destroy_dev(int ubi_num)
+{
+	ubi_bld_detach_mtd_dev(ubis[ubi_num]);
+	ubi_kfree(ubis[ubi_num]);
+}
+
+static int __init bytes_str_to_int(const char *str);
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
+	if (mtd_devs == UBI_MAX_INSTANCES) {
+		printk("UBI error: too many parameters, max. is %d\n",
+		       UBI_MAX_INSTANCES);
+		return -EINVAL;
+	}
+
+	len = strnlen(val, UBI_MTD_PARAM_LEN_MAX);
+	if (len > UBI_MTD_PARAM_LEN_MAX) {
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
+
+	return 0;
+}
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
