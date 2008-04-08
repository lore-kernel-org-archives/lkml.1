Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYDHLYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYDHLYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYDHLT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35129 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYDHLT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:26 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 27/29] parisc: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:34 +0400
Message-Id: <1207653576-12640-27-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Kyle McMartin <kyle@parisc-linux.org>
CC: Matthew Wilcox <matthew@wil.cx>
CC: Grant Grundler <grundler@parisc-linux.org>
CC: linux-parisc@vger.kernel.org
---
 drivers/parisc/ccio-dma.c  |   14 +++++---------
 drivers/parisc/sba_iommu.c |   14 +++++---------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 3482b83..f2b2549 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1551,8 +1551,7 @@ static int __init ccio_probe(struct parisc_device *dev)
 {
 	int i;
 	struct ioc *ioc, **ioc_p = &ioc_list;
-	struct proc_dir_entry *info_entry, *bitmap_entry;
-	
+
 	ioc = kzalloc(sizeof(struct ioc), GFP_KERNEL);
 	if (ioc == NULL) {
 		printk(KERN_ERR MODULE_NAME ": memory allocation failure\n");
@@ -1580,13 +1579,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 	HBA_DATA(dev->dev.platform_data)->iommu = ioc;
 	
 	if (ioc_count == 0) {
-		info_entry = create_proc_entry(MODULE_NAME, 0, proc_runway_root);
-		if (info_entry)
-			info_entry->proc_fops = &ccio_proc_info_fops;
-
-		bitmap_entry = create_proc_entry(MODULE_NAME"-bitmap", 0, proc_runway_root);
-		if (bitmap_entry)
-			bitmap_entry->proc_fops = &ccio_proc_bitmap_fops;
+		proc_create(MODULE_NAME, 0, proc_runway_root,
+			    &ccio_proc_info_fops);
+		proc_create(MODULE_NAME"-bitmap", 0, proc_runway_root,
+			    &ccio_proc_bitmap_fops);
 	}
 
 	ioc_count++;
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 3890fe1..bc73b96 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1895,7 +1895,9 @@ sba_driver_callback(struct parisc_device *dev)
 	int i;
 	char *version;
 	void __iomem *sba_addr = ioremap_nocache(dev->hpa.start, SBA_FUNC_SIZE);
-	struct proc_dir_entry *info_entry, *bitmap_entry, *root;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *root;
+#endif
 
 	sba_dump_ranges(sba_addr);
 
@@ -1973,14 +1975,8 @@ sba_driver_callback(struct parisc_device *dev)
 		break;
 	}
 
-	info_entry = create_proc_entry("sba_iommu", 0, root);
-	bitmap_entry = create_proc_entry("sba_iommu-bitmap", 0, root);
-
-	if (info_entry)
-		info_entry->proc_fops = &sba_proc_fops;
-
-	if (bitmap_entry)
-		bitmap_entry->proc_fops = &sba_proc_bitmap_fops;
+	proc_create("sba_iommu", 0, root, &sba_proc_fops);
+	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
 #endif
 
 	parisc_vmerge_boundary = IOVP_SIZE;
-- 
1.5.3.rc5

