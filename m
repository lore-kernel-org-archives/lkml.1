Return-Path: <linux-kernel-owner+w=401wt.eu-S2992754AbXBQRMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992754AbXBQRMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992755AbXBQRMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:12:18 -0500
Received: from smtp.nokia.com ([131.228.20.173]:35972 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992754AbXBQRMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:12:15 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:57:20 +0200
Message-Id: <20070217165720.5845.20150.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 35/44 take 2] [UBI] user-interfaces unit header
X-OriginalArrivalTime: 17 Feb 2007 16:57:20.0448 (UTC) FILETIME=[B00B7400:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185350-0B110BB0-0C66F2BB/0-0/0-0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/uif.h tmp-to/drivers/mtd/ubi/uif.h
--- tmp-from/drivers/mtd/ubi/uif.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/uif.h	2007-02-17 18:07:27.000000000 +0200
@@ -0,0 +1,182 @@
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
+ * UBI user interface unit.
+ *
+ * This unit implements all the UBI user interfaces: kernel interfaces,
+ * character device interfaces, and sysfs interfaces.
+ *
+ * There are two kinds of character devices: UBI character devices and volume
+ * character devices. UBI character devices allow users to manipulate by whole
+ * volumes: create, remove, and resize them. Volume character devices provide
+ * volume read and update capabilities.
+ *
+ * Major and minor numbers are assigned dynamically to both UBI and volume
+ * character devices.
+ */
+
+#ifndef __UBI_UIF_H__
+#define __UBI_UIF_H__
+
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include "gluebi.h"
+
+#define UBI_NAME_STR "ubi"
+
+struct ubi_info;
+struct ubi_vol_desc;
+
+/**
+ * ubi_uif_mkvol - create a volume.
+ *
+ * @ubi: the UBI device description object
+ * @vol_id: ID of the new volume
+ *
+ * This functions creates all the user interface-related data structures of a
+ * new volume. Returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_uif_mkvol(const struct ubi_info *ubi, int vol_id);
+
+/**
+ * ubi_uif_close_and_rmvol - close a and remove a volume.
+ *
+ * @desc: volume descriptor
+ *
+ * This functions closes a volume and removes all the user interface-related
+ * data structures of this volume. Returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_uif_close_and_rmvol(struct ubi_vol_desc *desc);
+
+/**
+ * ubi_uif_init - initialize the UBI user interface unit for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_uif_init(struct ubi_info *ubi);
+
+/**
+ * ubi_uif_close - close the UBI user interface unit for an UBI device.
+ *
+ * @ubi: the UBI device description object
+ */
+void ubi_uif_close(const struct ubi_info *ubi);
+
+/**
+ * ubi_uif_global_init - initialize the UBI user interface unit.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int __init ubi_uif_global_init(void);
+
+/**
+ * ubi_uif_global_close - close the UBI user interface unit.
+ */
+void ubi_uif_global_close(void);
+
+/**
+ * struct ubi_uif_volume - a per-volume user interface data structure.
+ *
+ * @dev: a class device object to make use of the the Linux device model
+ * @cdev: a Linux character device object to create a character device of this
+ * volume
+ * @ubi: a reference to the UBI description object this volume belongs to
+ * @vol_id: volume ID
+ * @list: the link in the list of UIF volume information
+ * @readers: number of users who are using this volume in read-only mode
+ * @writers: number of users who are using this volume in read-write mode
+ * @exclusive: whether somebody is using this volume in exclusive mode
+ * @removed: if the volume was removed from the UBI device
+ * @checked: if this static volume was checked
+ * @vol_lock: protects the @readers, @writers, @exclusive, and @removed fields
+ * @updating: whether the volume is being updated
+ * @gluebi_vol: gluebi-specific information
+ */
+struct ubi_uif_volume {
+	struct class_device dev;
+	struct cdev cdev;
+	const struct ubi_info *ubi;
+	int vol_id;
+	struct list_head list;
+	int readers;
+	int writers;
+	int exclusive;
+	int removed;
+	int checked;
+	spinlock_t vol_lock;
+	int updating;
+	struct ubi_gluebi_volume gluebi_vol;
+};
+
+/**
+ * struct ubi_vol_desc - UBI opened volume descriptor
+ *
+ * @vol: reference to the corresponding volume description object
+ * @mode: volume open mode
+ */
+struct ubi_vol_desc {
+	struct ubi_uif_volume *vol;
+	enum ubi_open_mode mode;
+};
+
+/**
+ * struct ubi_uif_info - UBI user interfaces unit description structure.
+ *
+ * @cdev: a Linux character device object to create a character device of this
+ * UBI device
+ * @dev: the class device structure to use the the Linux device model
+ * @ubi: a reference to the UBI description structure this volume belongs to
+ * @major: major number of the UBI character device
+ * @ubi_name: name of this UBI device
+ * @volumes: a list of 'struct ubi_uif_volume' object for all existing volumes
+ * @volumes_list_lock: protects the the @volumes list
+ * @vol_check: serializes volume checking
+ *
+ * The @volumes_list_lock mutex protects the list of volumes of this UBI device
+ * from being changed. So it has to be locked when the @volumes list is being
+ * accessed.
+ *
+ * The @vol_check lock is used only when checking static volumes consistency to
+ * prevent from simultanious volume checks.
+ */
+struct ubi_uif_info {
+	struct cdev cdev;
+	struct class_device dev;
+	struct ubi_info *ubi;
+	int major;
+	char *ubi_name;
+	struct list_head volumes;
+	struct mutex volumes_list_lock;
+	struct mutex vol_check;
+};
+
+#endif /* !__UBI_UIF_H__ */
