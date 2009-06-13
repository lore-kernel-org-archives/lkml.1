Return-Path: <linux-kernel-owner+w=401wt.eu-S1765398AbZFMN2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765398AbZFMN2E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764339AbZFMN0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:26:38 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:37936 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762970AbZFMN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JQjgpVoIA8LEZakevS1IeCJQ0psTelbnn1C3hBkVMVnVLzMR8zNh1rUx4Y5ViRMlff
         MwOF5C3X6rGI9oHwzH/ANOZ/rVu3+oBBm4CILLM9sIaiEuxl6BbBFty5sd6pcRttiNY8
         D9ZeyzDBWD669gSWfLPwPqAHEAw/g0ynOvsws=
Message-ID: <4A33A821.4070605@gmail.com>
Date: Sat, 13 Jun 2009 15:22:41 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 11/14] Pramfs: Symbolic link operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Symbolic link operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/symlink.c linux-2.6.30/fs/pramfs/symlink.c
--- linux-2.6.30-orig/fs/pramfs/symlink.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/symlink.c	2009-06-13 12:54:07.000000000 +0200
@@ -0,0 +1,73 @@
+/*
+ * FILE NAME fs/pramfs/symlink.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * Symlink operations
+ *
+ * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include "pram_fs.h"
+
+int pram_block_symlink(struct inode *inode, const char *symname, int len)
+{
+	struct super_block *sb = inode->i_sb;
+	off_t block;
+	char *blockp;
+	int err;
+	unsigned long flags;
+
+	flags = 0;
+
+	err = pram_alloc_blocks(inode, 0, 1);
+	if (err)
+		return err;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+
+	pram_lock_block(sb, blockp, flags);
+	memcpy(blockp, symname, len);
+	blockp[len] = '\0';
+	pram_unlock_block(sb, blockp, flags);
+	return 0;
+}
+
+static int pram_readlink(struct dentry *dentry, char *buffer, int buflen)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	off_t block;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	return vfs_readlink(dentry, buffer, buflen, blockp);
+}
+
+static void *pram_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	off_t block;
+	int status;
+	char *blockp;
+
+	block = pram_find_data_block(inode, 0);
+	blockp = pram_get_block(sb, block);
+	status = vfs_follow_link(nd, blockp);
+	return ERR_PTR(status);
+}
+
+struct inode_operations pram_symlink_inode_operations = {
+	.readlink	= pram_readlink,
+	.follow_link	= pram_follow_link,
+};



