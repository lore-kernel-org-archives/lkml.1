Return-Path: <linux-kernel-owner+w=401wt.eu-S2992699AbXBQRDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992699AbXBQRDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992704AbXBQRDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:03:16 -0500
Received: from smtp.nokia.com ([131.228.20.172]:57330 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992603AbXBQRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:01:31 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Feb 2007 18:58:01 +0200
Message-Id: <20070217165801.5845.3704.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
Subject: [PATCH 43/44 take 2] [UBI] JFFS2 UBI support
X-OriginalArrivalTime: 17 Feb 2007 16:58:00.0743 (UTC) FILETIME=[C80FFB70:01C752B4]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070217185519-03D78BB0-7B10945A/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -auNrp tmp-from/fs/jffs2/fs.c tmp-to/fs/jffs2/fs.c
--- tmp-from/fs/jffs2/fs.c	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/fs/jffs2/fs.c	2007-02-17 18:07:28.000000000 +0200
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
--- tmp-from/fs/jffs2/os-linux.h	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/fs/jffs2/os-linux.h	2007-02-17 18:07:28.000000000 +0200
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
--- tmp-from/fs/jffs2/wbuf.c	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/fs/jffs2/wbuf.c	2007-02-17 18:07:28.000000000 +0200
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
--- tmp-from/include/mtd/mtd-abi.h	2007-02-17 18:07:26.000000000 +0200
+++ tmp-to/include/mtd/mtd-abi.h	2007-02-17 18:07:28.000000000 +0200
@@ -24,6 +24,7 @@ struct mtd_oob_buf {
 #define MTD_NORFLASH		3
 #define MTD_NANDFLASH		4
 #define MTD_DATAFLASH		6
+#define MTD_UBIVOLUME		7
 
 #define MTD_WRITEABLE		0x400	/* Device is writeable */
 #define MTD_BIT_WRITEABLE	0x800	/* Single bits can be flipped */
