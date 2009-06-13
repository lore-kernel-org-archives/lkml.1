Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZFMN27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZFMN27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZFMN1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:27:08 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:37936 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbZFMN1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qfi83OxJWhgWrGYzdQ1LbuGxEpDGtie1HR8oke1cfIEjI35tIDNHm5cAPSx8pqsjU+
         arHSZAWJvHj3SZsOSXyJCYVtgZW7GjftM3XY24xheDT2FXlGyYRirFYJVwoy/YNgzVTc
         9rxTmDoQrVxCoV0zi1oa9CdYRFdh61FDW4SxQ=
Message-ID: <4A33A841.6080902@gmail.com>
Date: Sat, 13 Jun 2009 15:23:13 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 14/14] Pramfs: XIP operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

XIP operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/xip.c linux-2.6.30/fs/pramfs/xip.c
--- linux-2.6.30-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/xip.c	2009-06-13 12:54:26.000000000 +0200
@@ -0,0 +1,90 @@
+/*
+ * FILE NAME fs/pramfs/xip.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/buffer_head.h>
+#include "pram_fs.h"
+#include "xip.h"
+
+static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
+				     sector_t *data_block, int create)
+{
+	int err = -EIO;
+	off_t block;
+
+	lock_kernel();
+
+	block = pram_find_data_block(inode, iblock);
+
+	if (!block) {
+		if (!create) {
+			err = -ENODATA;
+			goto err;
+		}
+
+		err = pram_alloc_blocks(inode, iblock, 1);
+		if (err)
+			goto err;
+
+		block = pram_find_data_block(inode, iblock);
+		if (!block) {
+			err = -ENODATA;
+			goto err;
+		}
+	}
+
+	*data_block = block;
+	err = 0;
+
+ err:
+	unlock_kernel();
+	return err;
+}
+
+
+static int __pram_get_block(struct inode *inode, pgoff_t pgoff, int create,
+		   sector_t *result)
+{
+	int rc = 0;
+	sector_t iblock;
+
+	/* find starting block number to access */
+	iblock = (sector_t)pgoff << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	rc = pram_find_and_alloc_blocks(inode, iblock, result, create);
+
+	if (rc == -ENODATA)
+		BUG_ON(create);
+
+	return rc;
+}
+
+int pram_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
+				void **kmem, unsigned long *pfn)
+{
+	int rc;
+	sector_t block;
+
+	/* first, retrieve the block */
+	rc = __pram_get_block(mapping->host, pgoff, create, &block);
+	if (rc)
+		goto exit;
+
+	*kmem = pram_get_block(mapping->host->i_sb, block);
+	*pfn = page_to_pfn(virt_to_page((unsigned long)*kmem));
+
+exit:
+	return rc;
+}
diff -uprN linux-2.6.30-orig/fs/pramfs/xip.h linux-2.6.30/fs/pramfs/xip.h
--- linux-2.6.30-orig/fs/pramfs/xip.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/xip.h	2009-03-28 14:59:13.000000000 +0100
@@ -0,0 +1,25 @@
+/*
+ * FILE NAME fs/pramfs/xip.h
+ *
+ * BRIEF DESCRIPTION
+ *
+ * XIP operations.
+ *
+ * Author: Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef CONFIG_PRAMFS_XIP
+
+int pram_get_xip_mem(struct address_space *, pgoff_t, int, void **,
+							      unsigned long *);
+
+#else
+
+#define pram_get_xip_mem NULL
+
+#endif
+

