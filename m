Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXBQRGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXBQRGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXBQRAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:00:38 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52825 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992475AbXBQQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:59:16 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:55:40 +0200
Message-Id: <20070217165540.5845.31238.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/44 take 2] [UBI] scanning unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:39.0624 (UTC) FILETIME=[73F2EE80:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185206-63EC8BB0-37A72958/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/scan.h tmp-to/drivers/mtd/ubi/scan.h
--- tmp-from/drivers/mtd/ubi/scan.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/scan.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,279 @@
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
+ * UBI scanning unit.
+ *
+ * This unit is responsible for scanning the flash media, checking UBI
+ * headers and providing complete information about the UBI flash image.
+ */
+
+#ifndef __UBI_SCAN_H__
+#define __UBI_SCAN_H__
+
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
+/* The erase counter of this eraseblock is unknown */
+#define NAND_SCAN_UNKNOWN_EC (-1)
+
+struct ubi_info;
+struct ubi_scan_info;
+struct ubi_scan_volume;
+struct ubi_scan_leb;
+struct ubi_vid_hdr;
+
+/**
+ * ubi_scan_add_peb - add information about a physical eraseblock to the
+ * scanning information.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ * @ec: erase counter
+ * @vid_hdr: the volume identifier header
+ * @bitflips: if a bit-flips were detected while reading this physical
+ * eraseblock
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubi_scan_add_peb(const struct ubi_info *ubi, struct ubi_scan_info *si,
+		     int pnum, int ec, const struct ubi_vid_hdr *vid_hdr,
+		     int bitflips);
+
+/**
+ * ubi_scan_add_corr_peb - add a physical eraseblock to the list of corrupted
+ * physical eraseblocks.
+ *
+ * @si: a pointer to the scanning information
+ * @pnum: the physical eraseblock number
+ * @ec: erase counter of this physical eraseblock
+ *
+ * If @ec is not known, %NAND_SCAN_UNKNOWN_EC has to be passed and mean erase
+ * counter will be used. This function returns zero in case of success and a
+ * negative error code in case of failure.
+ */
+int ubi_scan_add_corr_peb(struct ubi_scan_info *si, int pnum, int ec);
+
+/**
+ * ubi_scan_find_sv - find information about a particular volume in the
+ * scanning information.
+ *
+ * @si: a pointer to the scanning information
+ * @vol_id: the requested volume ID
+ *
+ * This function returns a pointer to the volume description or %NULL if there
+ * are no data about this volume in the scanning information.
+ */
+struct ubi_scan_volume *ubi_scan_find_sv(const struct ubi_scan_info *si,
+					 int vol_id);
+
+/**
+ * ubi_scan_find_seb - find information about a particular logical
+ * eraseblock in the volume scanning information.
+ *
+ * @sv: a pointer to the volume scanning information
+ * @lnum: the requested logical eraseblock
+ *
+ * This function returns a pointer to the scanning logical eraseblock or %NULL
+ * if there are no data about it in the scanning volume information.
+ */
+struct ubi_scan_leb *ubi_scan_find_seb(const struct ubi_scan_volume *sv,
+				       int lnum);
+
+/**
+ * ubi_scan_erase_peb - erase a physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @pnum: physical eraseblock number to erase;
+ * @ec: erase counter value to write (%NAND_SCAN_UNKNOWN_EC if it is unknown)
+ *
+ * This function erases physical eraseblock 'pnum', and writes the erase
+ * counter header to it. This function should only be used on UBI device
+ * initialization stages, when the EBA unit had not been yet initialized. This
+ * function returns zero in case of success and a negative error code in case
+ * of failure.
+ */
+int ubi_scan_erase_peb(const struct ubi_info *ubi,
+		       const struct ubi_scan_info *si, int pnum, int ec);
+
+/**
+ * ubi_scan_get_free_peb - get a free physical eraseblock.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ *
+ * This function returns a free physical eraseblock. It is supposed to be
+ * called on the UBI initialization stages when the wear-leveling unit is not
+ * initialized yet. This function picks a physical eraseblocks from one of the
+ * lists, writes the EC header if it is needed, and removes it from the list.
+ *
+ * This function returns scanning physical eraseblock information in case of
+ * success and an error code in case of failure.
+ */
+struct ubi_scan_leb *ubi_scan_get_free_peb(const struct ubi_info *ubi,
+					   struct ubi_scan_info *si);
+
+/**
+ * ubi_scan_rm_volume - delete scanning information about a volume.
+ *
+ * @ubi: the UBI device description object
+ * @si: a pointer to the scanning information
+ * @sv: the volume scanning information to delete
+ */
+void ubi_scan_rm_volume(const struct ubi_info *ubi, struct ubi_scan_info *si,
+			struct ubi_scan_volume *sv);
+
+/**
+ * ubi_scan - scan an MTD device.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function does full scanning of an MTD device and returns complete
+ * information about it. In case of failure, an error code is returned.
+ */
+struct ubi_scan_info *ubi_scan(struct ubi_info *ubi);
+
+/**
+ * ubi_scan_destroy_si - destroy scanning information.
+ *
+ * @si: a pointer to the scanning information
+ */
+void ubi_scan_destroy_si(struct ubi_scan_info *si);
+
+/**
+ * struct ubi_scan_volume - scanning information about a volume.
+ *
+ * @vol_id: volume ID
+ * @highest_lnum: the highest logical eraseblock number found in this volume
+ * @leb_count: the number of found logical eraseblocks belonging to this volume
+ * @vol_type: volume type
+ * @data_pad: how many bytes at the end of logical eraseblocks of this volume
+ * are not used (due to the volume alignment)
+ * @used_ebs: the number of used logical eraseblocks in this volume (only for
+ * static volumes)
+ * @last_data_size: amount of data in the last found logical eraseblock of this
+ * volume (always equivalent to the usable logical eraseblock size fro dynamic
+ * volumes)
+ * @data_size: how many bytes of data logical eraseblock contain (only for static
+ * volumes, invalid for the last logical eraseblock)
+ * @compat: compatibility flags of the volume
+ * @rb: link in the volume RB-tree
+ * @root: the root of RB-tree containing all the found eraseblock belonging to
+ * this volume (&struct ubi_scan_leb objects)
+ */
+struct ubi_scan_volume {
+	int vol_id;
+	int highest_lnum;
+	int leb_count;
+	int vol_type;
+	int used_ebs;
+	int last_data_size;
+	int data_pad;
+	int compat;
+	struct rb_node rb;
+	struct rb_root root;
+};
+
+/**
+ * struct ubi_scan_leb - scanning information about a physical eraseblock.
+ *
+ * @ec: erase counter (%NAND_SCAN_UNKNOWN_EC if it is unknown)
+ * @pnum: physical eraseblock number
+ * @lnum: logical eraseblock number
+ * @scrub: if this physical eraseblock needs scrubbing
+ * @leb_ver: version of this logical eraseblock
+ * @u.rb: link in the per-volume RB-tree of &struct ubi_scan_leb objects
+ * @u.list: link in one of the eraseblock lists
+ *
+ * One object of this type is allocated for each physical eraseblock during
+ * scanning.
+ */
+struct ubi_scan_leb {
+	int ec;
+	int pnum;
+	int lnum;
+	int scrub;
+	uint32_t leb_ver;
+	union {
+		struct rb_node rb;
+		struct list_head list;
+	} u;
+};
+
+/**
+ * struct ubi_scan_info - UBI scanning information.
+ *
+ * @volumes: root of the volume RB-tree
+ * @corr: list of corrupted eraseblocks
+ * @free: list of free eraseblocks
+ * @erase: list of eraseblocks which have to be erased
+ * @alien: count of physical eraseblocks which should not be used by UBI (e.g.,
+ * those belonging to "preserve"-compatible internal volumes)
+ * @vols_found: total count of volumes found during scanning
+ * @highest_vol_id: highest volume ID found during scanning
+ * @bad_peb_count: count of bad physical eraseblocks found during scanning
+ * @alien_peb_count: count of physical eraseblocks in the @@alien list
+ * @is_empty: a flag indicating whether the flash device is empty or not
+ * @min_ec: the lowest found erase counter value
+ * @max_ec: the highest found erase counter value
+ * @mean_ec: mean erase counter value
+ * @ec_sum: a temporary variable used when calculating @mean_ec
+ * @ec_count: a temporary variable used when calculating @mean_ec
+ *
+ * This data structure contains the result of scanning and may be used by other
+ * UBI units to build final UBI data structures, further error-recovery and so
+ * on.
+ *
+ * Information about found volumes is represented by &struct ubi_scan_volume
+ * objects which are kept in volume RB-tree with root at the @volumes field. The
+ * RB-tree is indexed by the volume ID.
+ *
+ * Found logical eraseblocks are represented by &struct ubi_scan_leb objects.
+ * These objects are kept in per-volume RB-trees with the root at the
+ * corresponding &struct ubi_scan_volume object. To put it differently, we keep
+ * an RB-tree of per-volume objects and each of these objects is the root of
+ * RB-tree of per-eraseblock objects.
+ *
+ * Corrupted physical eraseblocks are put to the @corr list, free physical
+ * eraseblocks are put to the @free list and the physical eraseblock to be
+ * erased are put to the @erase list.
+ */
+struct ubi_scan_info {
+	struct rb_root volumes;  /* public  */
+	struct list_head corr;   /* public  */
+	struct list_head free;   /* public  */
+	struct list_head erase;  /* public  */
+	struct list_head alien;  /* public  */
+	int vols_found;          /* public  */
+	int highest_vol_id;      /* public  */
+	int bad_peb_count;       /* public  */
+	int alien_peb_count;     /* public  */
+	int is_empty;            /* public  */
+	int min_ec;              /* public  */
+	int max_ec;              /* public  */
+	int mean_ec;             /* public  */
+	int ec_sum;              /* private */
+	int ec_count;            /* private */
+};
+
+#endif /* !__UBI_SCAN_H__ */
