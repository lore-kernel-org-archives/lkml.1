Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbZFMN0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbZFMN0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763632AbZFMNZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:25:36 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49807 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763573AbZFMNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=WLtxmiDxP5B8L8O4+UsgxIHe2M7nl3yKbL6XmGrwB4IGWvZaIpMRtHId4XArilV+so
         h9RT1US1P1pYuGHIlC2Ze+skY2iecly9l7ISlZxuU31qwT5+GVrbbf22pp7gDBzLNAjH
         79X41e5SnTgIJWNk3OvdgxcU668XeNZOc1cdA=
Message-ID: <4A33A7E2.9020803@gmail.com>
Date: Sat, 13 Jun 2009 15:21:38 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 05/14] Pramfs: File operations for files
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

File operations for files.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/file.c linux-2.6.30/fs/pramfs/file.c
--- linux-2.6.30-orig/fs/pramfs/file.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/file.c	2009-06-13 12:52:56.000000000 +0200
@@ -0,0 +1,141 @@
+/*
+ * FILE NAME fs/pramfs/file.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * File operations for files.
+ *
+ * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include "pram_fs.h"
+#include "xip.h"
+
+static int pram_open_file(struct inode *inode, struct file *filp)
+{
+#ifndef CONFIG_PRAMFS_XIP
+	/* Without XIP we force to use Direct IO */
+	filp->f_flags |= O_DIRECT;
+#endif
+	return generic_file_open(inode, filp);
+}
+
+/*
+ * Called when an inode is released. Note that this is different
+ * from pram_open_file: open gets called at every open, but release
+ * gets called only when /all/ the files are closed.
+ */
+static int pram_release_file(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+ssize_t __pram_direct_IO(int rw, struct kiocb *iocb,
+		   const struct iovec *iov,
+		   loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	int progress = 0;
+	ssize_t retval = 0;
+	struct pram_inode *pi;
+	void *tmp = NULL;
+	unsigned long flags;
+	unsigned long blocknr, blockoff;
+	int num_blocks, blocksize_mask, blocksize, blocksize_bits;
+	char __user *buf = iov->iov_base;
+	size_t length = iov->iov_len;
+
+	flags = 0;
+
+	if (length < 0)
+		return -EINVAL;
+	if ((rw == READ) && (offset + length > inode->i_size))
+		length = inode->i_size - offset;
+	if (!length)
+		goto out;
+
+	blocksize_bits = inode->i_sb->s_blocksize_bits;
+	blocksize = 1 << blocksize_bits;
+	blocksize_mask = blocksize - 1;
+
+	/* find starting block number to access */
+	blocknr = offset >> blocksize_bits;
+	/* find starting offset within starting block */
+	blockoff = offset & blocksize_mask;
+	/* find number of blocks to access */
+	num_blocks = (blockoff + length + blocksize_mask) >> blocksize_bits;
+
+	if (rw == WRITE) {
+		/* prepare a temporary buffer to hold a user data block
+		   for writing. */
+		tmp = kmalloc(blocksize, GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+		/* now allocate the data blocks we'll need */
+		retval = pram_alloc_blocks(inode, blocknr, num_blocks);
+		if (retval)
+			goto fail;
+	}
+
+	pi = pram_get_inode(inode->i_sb, inode->i_ino);
+
+	while (length) {
+		int count;
+		off_t block = pram_find_data_block(inode, blocknr++);
+		u8 *bp = (u8 *)pram_get_block(sb, block);
+		if (!bp)
+			goto fail;
+
+		count = blockoff + length > blocksize ?
+			blocksize - blockoff : length;
+
+		if (rw == READ) {
+			copy_to_user(buf, &bp[blockoff], count);
+		} else {
+			copy_from_user(tmp, buf, count);
+
+			pram_lock_block(inode->i_sb, bp, flags);
+			memcpy(&bp[blockoff], tmp, count);
+			pram_unlock_block(inode->i_sb, bp, flags);
+		}
+
+		progress += count;
+		buf += count;
+		length -= count;
+		blockoff = 0;
+	}
+
+	retval = progress;
+ fail:
+	kfree(tmp);
+ out:
+	return retval;
+}
+
+struct file_operations pram_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= pram_read,
+	.write		= pram_write,
+	.aio_read	= pram_aio_read,
+	.aio_write	= pram_aio_write,
+	.mmap		= pram_mmap,
+	.open		= pram_open_file,
+	.release	= pram_release_file,
+	.fsync		= simple_sync_file,
+};
+
+struct inode_operations pram_file_inode_operations = {
+	.truncate	= pram_truncate,
+};

