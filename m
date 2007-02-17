Return-Path: <linux-kernel-owner+w=401wt.eu-S965349AbXBQQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbXBQQ4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXBQQ4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:56:46 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52478 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965349AbXBQQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:45 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:55:20 +0200
Message-Id: <20070217165520.5845.29806.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/44 take 2] [UBI] allocation unit header
X-OriginalArrivalTime: 17 Feb 2007 16:55:19.0500 (UTC) FILETIME=[67F440C0:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185211-63ECBBB0-1FEB6A13/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/alloc.h tmp-to/drivers/mtd/ubi/alloc.h
--- tmp-from/drivers/mtd/ubi/alloc.h	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/alloc.h	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,235 @@
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
+ * UBI memory allocation unit.
+ *
+ * This unit provides memory allocation/deallocation calls and wrappers.
+ */
+
+#ifndef __UBI_ALLOC_H__
+#define __UBI_ALLOC_H__
+
+#include <linux/init.h>
+
+struct ubi_info;
+struct ubi_ec_hdr;
+struct ubi_vid_hdr;
+struct ubi_bgt_work;
+struct ubi_wl_erase_work;
+struct ubi_wl_entry;
+struct ubi_wl_prot_entry;
+struct ubi_eba_ltree_entry;
+struct ubi_scan_leb;
+struct ubi_scan_volume;
+
+/**
+ * ubi_kmalloc - allocate memory.
+ *
+ * @size: how many bytes to allocate
+ *
+ * This function is just a wrapper over the standard Linux 'kmalloc()'
+ * function with %GFP_KERNEL argument.
+ */
+void *ubi_kmalloc(size_t size);
+
+/**
+ * ubi_kzalloc - allocate and zero memory.
+ *
+ * @size: how many bytes to allocate
+ *
+ * This function is just a wrapper over the standard Linux 'kzalloc()'
+ * function with %GFP_KERNEL argument.
+ */
+void *ubi_kzalloc(size_t size);
+
+/**
+ * ubi_kfree - free memory allocated by 'ubi_kmalloc()' or 'ubi_kzalloc()'.
+ *
+ * @obj: a pointer to the object to free
+ *
+ * This is just a wrapper over the standard Linux 'kfree()' function.
+ */
+void ubi_kfree(const void *obj);
+
+/**
+ * ubi_zalloc_ec_hdr - allocate a &struct ubi_ec_hdr object.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns a pointer to the newly allocated and zero-filled erase
+ * counter header object in case of success and %NULL in case of failure.
+ */
+struct ubi_ec_hdr *ubi_zalloc_ec_hdr(const struct ubi_info *ubi);
+
+/**
+ * ubi_free_ec_hdr - free a &struct ubi_ec_hdr object.
+ *
+ * @ubi: the UBI device description object
+ * @ec_hdr: a pointer to the object to free
+ */
+void ubi_free_ec_hdr(const struct ubi_info *ubi, struct ubi_ec_hdr *ec_hdr);
+
+/**
+ * ubi_zalloc_vid_hdr - allocate a &struct ubi_vid_hdr object.
+ *
+ * @ubi: the UBI device description object
+ *
+ * This function returns a pointer to the newly allocated and zero-filled
+ * volume identifier header object in case of success and %NULL in case of
+ * failure.
+ */
+struct ubi_vid_hdr *ubi_zalloc_vid_hdr(const struct ubi_info *ubi);
+
+/**
+ * ubi_free_vid_hdr - free a &struct ubi_vid_hdr object.
+ *
+ * @ubi: the UBI device description object
+ * @vid_hdr: a pointer to the object to free
+ */
+void ubi_free_vid_hdr(const struct ubi_info *ubi, struct ubi_vid_hdr *vid_hdr);
+
+/**
+ * ubi_alloc_bgt_work - allocate a &struct ubi_bgt_work object.
+ *
+ * This function returns a pointer to the newly allocated &struct ubi_bgt_work
+ * object in case of success and %NULL in case of failure. The allocated object
+ * is not zeroed.
+ */
+struct ubi_bgt_work *ubi_alloc_bgt_work(void);
+
+/**
+ * ubi_free_bgt_work - free a &struct ubi_bgt_work object.
+ *
+ * @wrk: a pointer to the object to free
+ */
+void ubi_free_bgt_work(struct ubi_bgt_work *wrk);
+
+/**
+ * ubi_alloc_wl_erase_work - allocate a &struct ubi_wl_erase_work object.
+ *
+ * This function returns a pointer to the newly allocated &struct ubi_wl_erase_work
+ * object in case of success and %NULL in case of failure. The allocated object
+ * is not zeroed.
+ */
+struct ubi_wl_erase_work *ubi_alloc_wl_erase_work(void);
+
+/**
+ * ubi_free_wl_erase_work - free a &struct ubi_wl_erase_work object.
+ *
+ * @wrk: a pointer to the object to free
+ */
+void ubi_free_wl_erase_work(struct ubi_wl_erase_work *wrk);
+
+/**
+ * ubi_alloc_wl_entry - allocate a &struct ubi_wl_entry object.
+ *
+ * This function returns a pointer to the newly allocated &struct ubi_wl_entry
+ * object in case of success and %NULL in case of failure. The allocated object
+ * is not zeroed.
+ */
+struct ubi_wl_entry *ubi_alloc_wl_entry(void);
+
+/**
+ * ubi_free_wl_entry - free a &struct ubi_wl_entry object.
+ *
+ * @wle: a pointer to the object to free
+ */
+void ubi_free_wl_entry(struct ubi_wl_entry *wle);
+
+/**
+ * ubi_alloc_wl_prot_entry - allocate a &struct ubi_wl_prot_entry object.
+ *
+ * This function returns a pointer to the newly allocated
+ * &struct ubi_wl_prot_entry object in case of success and %NULL in case of
+ * failure. The allocated object is not zeroed.
+ */
+struct ubi_wl_prot_entry *ubi_alloc_wl_prot_entry(void);
+
+/**
+ * ubi_free_wl_prot_entry - free a &struct ubi_wl_prot_entry object.
+ *
+ * @pe: a pointer to the object to free
+ */
+void ubi_free_wl_prot_entry(struct ubi_wl_prot_entry *pe);
+
+/**
+ * ubi_alloc_eba_ltree_entry - allocate a &struct ubi_eba_ltree_entry object.
+ *
+ * This function returns a pointer to the newly allocated
+ * &struct ubi_eba_ltree_entry object in case of success and %NULL in case of
+ * failure. The allocated object is not zeroed, but the @users and @mutex
+ * fields are initialized by slab constructor.
+ */
+struct ubi_eba_ltree_entry *ubi_alloc_eba_ltree_entry(void);
+
+/**
+ * ubi_free_eba_ltree_entry - free a &struct ubi_eba_ltree_entry object.
+ *
+ * @le: a pointer to the object to free
+ */
+void ubi_free_eba_ltree_entry(struct ubi_eba_ltree_entry *le);
+
+/**
+ * ubi_alloc_scan_leb - allocate a &struct ubi_scan_leb object.
+ *
+ * This function returns a pointer to the newly allocated &struct ubi_scan_leb
+ * object in case of success, or %NULL in case of failure. The allocated object
+ * is not zeroed.
+ */
+struct ubi_scan_leb *ubi_alloc_scan_leb(void);
+
+/**
+ * ubi_free_scan_leb - free a &struct ubi_scan_leb object.
+ *
+ * @seb: a pinter to the &struct ubi_scan_leb object to free
+ */
+void ubi_free_scan_leb(struct ubi_scan_leb *seb);
+
+/**
+ * ubi_alloc_scan_volume - allocate a &struct ubi_scan_volume object.
+ *
+ * This function returns a pointer to the newly allocated &struct
+ * ubi_scan_volume object in cases of success, or %NULL in case of failure. The
+ * allocated object is not zeroed.
+ */
+struct ubi_scan_volume *ubi_alloc_scan_volume(void);
+
+/**
+ * ubi_free_scan_volume - free a &struct ubi_scan_volume object.
+ *
+ * @sv: a pinter to the &struct ubi_scan_volume object to free
+ */
+void ubi_free_scan_volume(struct ubi_scan_volume *sv);
+
+/**
+ * ubi_alloc_init - initialize the UBI memory allocation unit.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int __init ubi_alloc_init(void);
+
+/**
+ * ubi_alloc_close - close the UBI memory allocation unit.
+ */
+void ubi_alloc_close(void);
+
+#endif /* !__UBI_ALLOC_H__ */
