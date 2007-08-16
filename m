Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXHPIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXHPIbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbXHPI2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:28:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbXHPI2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:28:46 -0400
Message-Id: <20070816074628.012251000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:39 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 14/23] mtd: clean up the backing_dev_info usage
Content-Disposition: inline; filename=mtd-bdi-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Give each mtd device its own backing_dev_info instance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtdcore.c   |    8 +++++---
 include/linux/mtd/mtd.h |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/mtd/mtdcore.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdcore.c
+++ linux-2.6/drivers/mtd/mtdcore.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/proc_fs.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
 #include "internal.h"
@@ -53,15 +54,16 @@ int add_mtd_device(struct mtd_info *mtd)
 	if (!mtd->backing_dev_info) {
 		switch (mtd->type) {
 		case MTD_RAM:
-			mtd->backing_dev_info = &mtd_bdi_rw_mappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_rw_mappable;
 			break;
 		case MTD_ROM:
-			mtd->backing_dev_info = &mtd_bdi_ro_mappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_ro_mappable;
 			break;
 		default:
-			mtd->backing_dev_info = &mtd_bdi_unmappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_unmappable;
 			break;
 		}
+		mtd->backing_dev_info = &mtd->mtd_backing_dev_info;
 	}
 	err = bdi_init(mtd->backing_dev_info);
 	if (err)
Index: linux-2.6/include/linux/mtd/mtd.h
===================================================================
--- linux-2.6.orig/include/linux/mtd/mtd.h
+++ linux-2.6/include/linux/mtd/mtd.h
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/compatmac.h>
 #include <mtd/mtd-abi.h>
@@ -154,6 +155,7 @@ struct mtd_info {
 	 * - provides mmap capabilities
 	 */
 	struct backing_dev_info *backing_dev_info;
+	struct backing_dev_info mtd_backing_dev_info;
 
 
 	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf);

--

