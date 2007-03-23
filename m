Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbXCWQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbXCWQxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934281AbXCWQxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:53:24 -0400
Received: from smtp.nokia.com ([131.228.20.172]:52031 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934286AbXCWQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:53:23 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Frank Haverkamp <haver@vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Fri, 23 Mar 2007 18:44:27 +0200
Message-Id: <20070323164427.8958.54336.sendpatchset@localhost.localdomain>
In-Reply-To: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
References: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/20 take 4] UBI: JFFS2 UBI support
X-OriginalArrivalTime: 23 Mar 2007 16:44:27.0633 (UTC) FILETIME=[8574BE10:01C76D6A]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070323184442-22E1FBB0-6909E2B7/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/fs/jffs2/fs.c tmp-to/fs/jffs2/fs.c
--- tmp-from/fs/jffs2/fs.c	2007-03-23 18:20:01.000000000 +0200
+++ tmp-to/fs/jffs2/fs.c	2007-03-23 18:20:02.000000000 +0200
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
--- tmp-from/fs/jffs2/os-linux.h	2007-03-23 18:20:01.000000000 +0200
+++ tmp-to/fs/jffs2/os-linux.h	2007-03-23 18:20:02.000000000 +0200
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
--- tmp-from/fs/jffs2/wbuf.c	2007-03-23 18:20:01.000000000 +0200
+++ tmp-to/fs/jffs2/wbuf.c	2007-03-23 18:20:02.000000000 +0200
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
--- tmp-from/include/mtd/mtd-abi.h	2007-03-23 18:20:01.000000000 +0200
+++ tmp-to/include/mtd/mtd-abi.h	2007-03-23 18:20:02.000000000 +0200
@@ -24,6 +24,7 @@ struct mtd_oob_buf {
 #define MTD_NORFLASH		3
 #define MTD_NANDFLASH		4
 #define MTD_DATAFLASH		6
+#define MTD_UBIVOLUME		7
 
 #define MTD_WRITEABLE		0x400	/* Device is writeable */
 #define MTD_BIT_WRITEABLE	0x800	/* Single bits can be flipped */
