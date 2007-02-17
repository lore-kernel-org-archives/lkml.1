Return-Path: <linux-kernel-owner+w=401wt.eu-S2992462AbXBQQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992462AbXBQQzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992465AbXBQQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:55:39 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52202 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992462AbXBQQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:55:38 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Sat, 17 Feb 2007 18:55:25 +0200
Message-Id: <20070217165525.5845.78155.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/44 take 2] [UBI] allocation unit implementation
X-OriginalArrivalTime: 17 Feb 2007 16:54:52.0241 (UTC) FILETIME=[57B4DC10:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185149-63EC2BB0-516C5DAB/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/drivers/mtd/ubi/alloc.c tmp-to/drivers/mtd/ubi/alloc.c
--- tmp-from/drivers/mtd/ubi/alloc.c	1970-01-01 02:00:00.000000000 +0200
+++ tmp-to/drivers/mtd/ubi/alloc.c	2007-02-17 18:07:26.000000000 +0200
@@ -0,0 +1,369 @@
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
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+#include <mtd/ubi-header.h>
+#include "ubi.h"
+#include "alloc.h"
+#include "io.h"
+#include "background.h"
+#include "wl.h"
+#include "debug.h"
+#include "eba.h"
+#include "scan.h"
+
+#define BGT_WORK_SLAB_NAME        "ubi_bgt_work_slab"
+#define WL_ERASE_WORK_SLAB_NAME   "ubi_wl_erase_work_slab"
+#define WL_ENTRY_SLAB_NAME        "ubi_wl_entry_slab"
+#define WL_PROT_ENTRY_SLAB_NAME   "ubi_wl_prow_entry_slab"
+#define EBA_LTREE_ENTRY_SLAB_NAME "ubi_eba_ltree_entry_slab"
+#define SCAN_EB_SLAB_NAME         "ubi_scan_leb"
+#define SCAN_VOLUME_SLAB_NAME     "ubi_scan_volume"
+
+static struct kmem_cache *bgt_work_slab;
+static struct kmem_cache *wl_erase_work_slab;
+static struct kmem_cache *wl_entries_slab;
+static struct kmem_cache *wl_prot_entry_slab;
+static struct kmem_cache *eba_ltree_entry_slab;
+static struct kmem_cache *scan_eb_slab;
+static struct kmem_cache *scan_volume_slab;
+
+void *ubi_kzalloc(size_t size)
+{
+	void *ret;
+
+	ret = kzalloc(size, GFP_KERNEL);
+	if (unlikely(!ret)) {
+		ubi_err("cannot allocate %zd bytes", size);
+		dump_stack();
+		return NULL;
+	}
+
+	return ret;
+}
+
+void *ubi_kmalloc(size_t size)
+{
+	void *ret;
+
+	ret = kmalloc(size, GFP_KERNEL);
+	if (unlikely(!ret)) {
+		ubi_err("cannot allocate %zd bytes", size);
+		dump_stack();
+		return NULL;
+	}
+
+	return ret;
+}
+
+void ubi_kfree(const void *obj)
+{
+	if (unlikely(!obj))
+		return;
+	kfree(obj);
+}
+
+struct ubi_ec_hdr *ubi_zalloc_ec_hdr(const struct ubi_info *ubi)
+{
+	struct ubi_ec_hdr *ec_hdr;
+	const struct ubi_io_info *io = ubi->io;
+
+	ec_hdr = kzalloc(io->ec_hdr_alsize, GFP_KERNEL);
+	if (unlikely(!ec_hdr)) {
+		ubi_err("cannot allocate %d bytes", io->ec_hdr_alsize);
+		dump_stack();
+		return NULL;
+	}
+
+	return ec_hdr;
+}
+
+void ubi_free_ec_hdr(const struct ubi_info *ubi, struct ubi_ec_hdr *ec_hdr)
+{
+	if (unlikely(!ec_hdr))
+		return;
+	kfree(ec_hdr);
+}
+
+struct ubi_vid_hdr *ubi_zalloc_vid_hdr(const struct ubi_info *ubi)
+{
+	char *vid_hdr;
+	const struct ubi_io_info *io = ubi->io;
+
+	vid_hdr = kzalloc(io->vid_hdr_alsize, GFP_KERNEL);
+	if (unlikely(!vid_hdr)) {
+		ubi_err("cannot allocate %d bytes", io->vid_hdr_alsize);
+		dump_stack();
+		return NULL;
+	}
+
+	/*
+	 * If VID headers are stored at non-aligned addresses, we have to shift
+	 * the pointer.
+	 */
+	if (likely(vid_hdr))
+		vid_hdr = vid_hdr + io->vid_hdr_shift;
+
+	return (struct ubi_vid_hdr *)vid_hdr;
+}
+
+void ubi_free_vid_hdr(const struct ubi_info *ubi, struct ubi_vid_hdr *vid_hdr)
+{
+	if (unlikely(!vid_hdr))
+		return;
+	vid_hdr = (struct ubi_vid_hdr *)((char *)vid_hdr - ubi->io->vid_hdr_shift);
+	kfree(vid_hdr);
+}
+
+struct ubi_bgt_work *ubi_alloc_bgt_work(void)
+{
+	struct ubi_bgt_work *wrk;
+
+	wrk = kmem_cache_alloc(bgt_work_slab, GFP_KERNEL);
+	if (unlikely(!wrk)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+	return wrk;
+}
+
+void ubi_free_bgt_work(struct ubi_bgt_work *wrk)
+{
+	if (unlikely(!wrk))
+		return;
+	kmem_cache_free(bgt_work_slab, wrk);
+}
+
+struct ubi_wl_erase_work *ubi_alloc_wl_erase_work(void)
+{
+	struct ubi_wl_erase_work *wrk;
+
+	wrk = kmem_cache_alloc(wl_erase_work_slab, GFP_KERNEL);
+	if (unlikely(!wrk)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+	return wrk;
+}
+
+void ubi_free_wl_erase_work(struct ubi_wl_erase_work *wrk)
+{
+	if (unlikely(!wrk))
+		return;
+	kmem_cache_free(wl_erase_work_slab, wrk);
+}
+
+struct ubi_wl_entry *ubi_alloc_wl_entry(void)
+{
+	struct ubi_wl_entry *wle;
+
+	wle = kmem_cache_alloc(wl_entries_slab, GFP_KERNEL);
+	if (unlikely(!wle)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+	return wle;
+}
+
+void ubi_free_wl_entry(struct ubi_wl_entry *wle)
+{
+	if (unlikely(!wle))
+		return;
+	kmem_cache_free(wl_entries_slab, wle);
+}
+
+struct ubi_wl_prot_entry *ubi_alloc_wl_prot_entry(void)
+{
+	struct ubi_wl_prot_entry *pe;
+
+	pe = kmem_cache_alloc(wl_prot_entry_slab, GFP_KERNEL);
+	if (unlikely(!pe)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+	return pe;
+}
+
+void ubi_free_wl_prot_entry(struct ubi_wl_prot_entry *pe)
+{
+	if (unlikely(!pe))
+		return;
+	kmem_cache_free(wl_prot_entry_slab, pe);
+}
+
+struct ubi_eba_ltree_entry *ubi_alloc_eba_ltree_entry(void)
+{
+	struct ubi_eba_ltree_entry *le;
+
+	le = kmem_cache_alloc(eba_ltree_entry_slab, GFP_KERNEL);
+	if (unlikely(!le)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+	return le;
+}
+
+void ubi_free_eba_ltree_entry(struct ubi_eba_ltree_entry *le)
+{
+	if (unlikely(!le))
+		return;
+	kmem_cache_free(eba_ltree_entry_slab, le);
+}
+
+struct ubi_scan_leb *ubi_alloc_scan_leb(void)
+{
+	struct ubi_scan_leb *seb;
+
+	seb = kmem_cache_alloc(scan_eb_slab, GFP_KERNEL);
+	if (unlikely(!seb)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+
+	return seb;
+}
+
+void ubi_free_scan_leb(struct ubi_scan_leb *seb)
+{
+	if (unlikely(!seb))
+		return;
+	kmem_cache_free(scan_eb_slab, seb);
+}
+
+struct ubi_scan_volume *ubi_alloc_scan_volume(void)
+{
+	struct ubi_scan_volume *sv;
+
+	sv = kmem_cache_alloc(scan_volume_slab, GFP_KERNEL);
+	if (unlikely(!sv)) {
+		ubi_err("failed to allocate memory");
+		dump_stack();
+		return NULL;
+	}
+
+	return sv;
+}
+
+void ubi_free_scan_volume(struct ubi_scan_volume *sv)
+{
+	if (unlikely(!sv))
+		return;
+	kmem_cache_free(scan_volume_slab, sv);
+}
+
+static void ltree_entry_ctor(void *obj, struct kmem_cache *cache,
+			     unsigned long flags);
+
+int __init ubi_alloc_init(void)
+{
+	const char *name;
+	size_t size;
+
+	name = BGT_WORK_SLAB_NAME;
+	size = sizeof(struct ubi_bgt_work);
+	bgt_work_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!bgt_work_slab)
+		goto out;
+
+	name = WL_ERASE_WORK_SLAB_NAME;
+	size = sizeof(struct ubi_wl_erase_work);
+	wl_erase_work_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!wl_erase_work_slab)
+		goto out;
+
+	name = WL_ENTRY_SLAB_NAME;
+	size = sizeof(struct ubi_wl_entry);
+	wl_entries_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!wl_entries_slab)
+		goto out;
+
+	name = WL_PROT_ENTRY_SLAB_NAME;
+	size = sizeof(struct ubi_wl_prot_entry);
+	wl_prot_entry_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!wl_prot_entry_slab)
+		goto out;
+
+	name = EBA_LTREE_ENTRY_SLAB_NAME;
+	size = sizeof(struct ubi_eba_ltree_entry);
+	eba_ltree_entry_slab = kmem_cache_create(name, size, 0, 0,
+						 &ltree_entry_ctor, NULL);
+	if (!eba_ltree_entry_slab)
+		goto out;
+
+	name = SCAN_EB_SLAB_NAME;
+	size = sizeof(struct ubi_scan_leb);
+	scan_eb_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!scan_eb_slab)
+		goto out;
+
+	name = SCAN_VOLUME_SLAB_NAME;
+	size = sizeof(struct ubi_scan_volume);
+	scan_volume_slab = kmem_cache_create(name, size, 0, 0, NULL, NULL);
+	if (!scan_volume_slab)
+		goto out;
+
+	return 0;
+
+out:
+	ubi_err("cannot create \"%s\" slab", name);
+	ubi_alloc_close();
+	return -ENOMEM;
+}
+
+void ubi_alloc_close(void)
+{
+	if (scan_volume_slab)
+		kmem_cache_destroy(scan_volume_slab);
+	if (scan_eb_slab)
+		kmem_cache_destroy(scan_eb_slab);
+	if (eba_ltree_entry_slab)
+		kmem_cache_destroy(eba_ltree_entry_slab);
+	if (wl_prot_entry_slab)
+		kmem_cache_destroy(wl_prot_entry_slab);
+	if (wl_entries_slab)
+		kmem_cache_destroy(wl_entries_slab);
+	if (wl_erase_work_slab)
+		kmem_cache_destroy(wl_erase_work_slab);
+	if (bgt_work_slab)
+		kmem_cache_destroy(bgt_work_slab);
+}
+
+/* Lock tree entries slab cache constructor */
+static void ltree_entry_ctor(void *obj, struct kmem_cache *cache,
+			     unsigned long flags)
+{
+	struct ubi_eba_ltree_entry *le = obj;
+
+	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) !=
+	    SLAB_CTOR_CONSTRUCTOR)
+		return;
+
+	le->users = 0;
+	init_rwsem(&le->mutex);
+}
