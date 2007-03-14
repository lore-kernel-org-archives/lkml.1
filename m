Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXCNP2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXCNP2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXCNP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:28:11 -0400
Received: from smtp.nokia.com ([131.228.20.170]:65139 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXCNP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:27:53 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Wed, 14 Mar 2007 17:21:15 +0200
Message-Id: <20070314152115.1112.86256.sendpatchset@localhost.localdomain>
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/22 take 3] UBI: JFFS2 UBI support
X-OriginalArrivalTime: 14 Mar 2007 15:21:14.0973 (UTC) FILETIME=[67E188D0:01C7664C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/fs/jffs2/fs.c tmp-to/fs/jffs2/fs.c
--- tmp-from/fs/jffs2/fs.c	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/fs/jffs2/fs.c	2007-03-14 17:15:50.000000000 +0200
@@ -672,6 +672,13 @@ static int jffs2_flash_setup(struct jffs
 			return ret;
 	}
 
+	/* and an UBI volume */
+	if (jffs2_ubivol(c)) {
+		ret = jffs2_ubivol_setup(c);
+		if (ret)
+			return ret;
+	}
+
 	return ret;
 }
 
@@ -690,4 +697,9 @@ void jffs2_flash_cleanup(struct jffs2_sb
 	if (jffs2_nor_wbuf_flash(c)) {
 		jffs2_nor_wbuf_flash_cleanup(c);
 	}
+
+	/* and an UBI volume */
+	if (jffs2_ubivol(c)) {
+		jffs2_ubivol_cleanup(c);
+	}
 }
diff -auNrp tmp-from/fs/jffs2/os-linux.h tmp-to/fs/jffs2/os-linux.h
--- tmp-from/fs/jffs2/os-linux.h	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/fs/jffs2/os-linux.h	2007-03-14 17:15:50.000000000 +0200
@@ -98,6 +98,9 @@ static inline void jffs2_init_inode_info
 #define jffs2_nor_wbuf_flash(c) (0)
 #define jffs2_nor_wbuf_flash_setup(c) (0)
 #define jffs2_nor_wbuf_flash_cleanup(c) do {} while (0)
+#define jffs2_ubivol(c) (0)
+#define jffs2_ubivol_setup(c) (0)
+#define jffs2_ubivol_cleanup(c) do {} while (0)
 
 #else /* NAND and/or ECC'd NOR support present */
 
@@ -133,6 +136,9 @@ void jffs2_nand_flash_cleanup(struct jff
 #define jffs2_dataflash(c) (c->mtd->type == MTD_DATAFLASH)
 int jffs2_dataflash_setup(struct jffs2_sb_info *c);
 void jffs2_dataflash_cleanup(struct jffs2_sb_info *c);
+#define jffs2_ubivol(c) (c->mtd->type == MTD_UBIVOLUME)
+int jffs2_ubivol_setup(struct jffs2_sb_info *c);
+void jffs2_ubivol_cleanup(struct jffs2_sb_info *c);
 
 #define jffs2_nor_wbuf_flash(c) (c->mtd->type == MTD_NORFLASH && ! (c->mtd->flags & MTD_BIT_WRITEABLE))
 int jffs2_nor_wbuf_flash_setup(struct jffs2_sb_info *c);
diff -auNrp tmp-from/fs/jffs2/wbuf.c tmp-to/fs/jffs2/wbuf.c
--- tmp-from/fs/jffs2/wbuf.c	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/fs/jffs2/wbuf.c	2007-03-14 17:15:50.000000000 +0200
@@ -1274,3 +1274,27 @@ int jffs2_nor_wbuf_flash_setup(struct jf
 void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c) {
 	kfree(c->wbuf);
 }
+
+int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
+	c->cleanmarker_size = 0;
+
+	if (c->mtd->writesize == 1)
+		/* We do not need write-buffer */
+		return 0;
+
+	init_rwsem(&c->wbuf_sem);
+
+	c->wbuf_pagesize =  c->mtd->writesize;
+	c->wbuf_ofs = 0xFFFFFFFF;
+	c->wbuf = kmalloc(c->wbuf_pagesize, GFP_KERNEL);
+	if (!c->wbuf)
+		return -ENOMEM;
+
+	printk(KERN_INFO "JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n", c->wbuf_pagesize, c->sector_size);
+
+	return 0;
+}
+
+void jffs2_ubivol_cleanup(struct jffs2_sb_info *c) {
+	kfree(c->wbuf);
+}
diff -auNrp tmp-from/include/mtd/mtd-abi.h tmp-to/include/mtd/mtd-abi.h
--- tmp-from/include/mtd/mtd-abi.h	2007-03-14 17:15:49.000000000 +0200
+++ tmp-to/include/mtd/mtd-abi.h	2007-03-14 17:15:50.000000000 +0200
@@ -24,6 +24,7 @@ struct mtd_oob_buf {
 #define MTD_NORFLASH		3
 #define MTD_NANDFLASH		4
 #define MTD_DATAFLASH		6
+#define MTD_UBIVOLUME		7
 
 #define MTD_WRITEABLE		0x400	/* Device is writeable */
 #define MTD_BIT_WRITEABLE	0x800	/* Single bits can be flipped */
