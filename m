Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbZFMNY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbZFMNY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbZFMNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:24:46 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51715 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760139AbZFMNYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=a/AV0HH+wrWR8urDVgsFeBc4i4VxrdQa6ChDZyufGHaKmuO0wUGVqV6U7+aZCu/fOT
         aIUk/bZKvs3YzMfD1hMq9TmKtePtxAmXj46yGOJ1dDkoO7hMY2L3wgMzG7vo/FtJLXbI
         aBz+o/dRpx44KGnP2JMX7cyWjSyDTv4N6uzVE=
Message-ID: <4A33A7B2.8040401@gmail.com>
Date: Sat, 13 Jun 2009 15:20:50 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 01/14] Pramfs: Block operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Block allocation and deallocation routines.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/balloc.c
linux-2.6.30/fs/pramfs/balloc.c
--- linux-2.6.30-orig/fs/pramfs/balloc.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/balloc.c	2009-06-13 12:51:24.000000000 +0200
@@ -0,0 +1,157 @@
+/*
+ * FILE NAME fs/pramfs/balloc.c
+ *
+ * BRIEF MODULE DESCRIPTION
+ *
+ * The blocks allocation and deallocation routines.
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
+#include <linux/quotaops.h>
+#include <linux/bitops.h>
+#include "pram_fs.h"
+
+/*
+ * This just marks in-use the blocks that make up the bitmap.
+ * The bitmap must be writeable before calling.
+ */
+void pram_init_bitmap(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	u32 *bitmap = pram_get_bitmap(sb);
+	int blocks = ps->s_bitmap_blocks;
+
+	memset(bitmap, 0, blocks<<sb->s_blocksize_bits);
+
+	while (blocks >= 32) {
+		*bitmap++ = 0xffffffff;
+		blocks -= 32;
+	}
+
+	if (blocks)
+		*bitmap = (1<<blocks) - 1;
+}
+
+
+/* Free absolute blocknr */
+void pram_free_block(struct super_block *sb, int blocknr)
+{
+	struct pram_super_block *ps;
+	off_t bitmap_block;
+	int bitmap_bnr;
+	void *bitmap;
+	void *bp;
+	unsigned long flags;
+
+	flags = 0;
+
+	lock_super(sb);
+
+	bitmap = pram_get_bitmap(sb);
+	/*
+	 * find the block within the bitmap that contains the inuse bit
+	 * for the block we need to free. We need to unlock this bitmap
+	 * block to clear the inuse bit.
+	 */
+	bitmap_bnr = blocknr >> (3 + sb->s_blocksize_bits);
+	bitmap_block = pram_get_block_off(sb, bitmap_bnr);
+	bp = pram_get_block(sb, bitmap_block);
+
+	pram_lock_block(sb, bp, flags);
+	clear_bit(blocknr, bitmap); /* mark the block free */
+	pram_unlock_block(sb, bp, flags);
+
+	ps = pram_get_super(sb);
+	pram_lock_super(ps, flags);
+	if (blocknr < ps->s_free_blocknr_hint)
+		ps->s_free_blocknr_hint = blocknr;
+	ps->s_free_blocks_count++;
+	pram_unlock_super(ps, flags);
+
+	unlock_super(sb);
+}
+
+
+/*
+ * allocate a block and return it's absolute blocknr. Zeroes out the
+ * block if zero set.
+ */
+int pram_new_block(struct super_block *sb, int *blocknr, int zero)
+{
+	struct pram_super_block *ps;
+	off_t bitmap_block;
+	int bnr, bitmap_bnr, errval;
+	void *bitmap;
+	void *bp;
+	unsigned long flags;
+
+	flags = 0;
+
+	lock_super(sb);
+	ps = pram_get_super(sb);
+	bitmap = pram_get_bitmap(sb);
+
+	if (ps->s_free_blocks_count) {
+		/* find the oldest unused block */
+		bnr = find_next_zero_bit(bitmap,
+					 ps->s_blocks_count,
+					 ps->s_free_blocknr_hint);
+
+		if (bnr < ps->s_bitmap_blocks || bnr >= ps->s_blocks_count) {
+			pram_err("no free blocks found!\n");
+			errval = -ENOSPC;
+			goto fail;
+		}
+
+		pram_dbg("allocating blocknr %d\n", bnr);
+		pram_lock_super(ps, flags);
+		ps->s_free_blocks_count--;
+		ps->s_free_blocknr_hint =
+			(bnr < ps->s_blocks_count-1) ? bnr+1 : 0;
+		pram_unlock_super(ps, flags);
+	} else {
+		pram_err("all blocks allocated\n");
+		errval = -ENOSPC;
+		goto fail;
+	}
+
+	/*
+	 * find the block within the bitmap that contains the inuse bit
+	 * for the unused block we just found. We need to unlock it to
+	 * set the inuse bit.
+	 */
+	bitmap_bnr = bnr >> (3 + sb->s_blocksize_bits);
+	bitmap_block = pram_get_block_off(sb, bitmap_bnr);
+	bp = pram_get_block(sb, bitmap_block);
+
+	pram_lock_block(sb, bp, flags);
+	set_bit(bnr, bitmap); /* mark the new block in use */
+	pram_unlock_block(sb, bp, flags);
+
+	if (zero) {
+		bp = pram_get_block(sb, pram_get_block_off(sb, bnr));
+		pram_lock_block(sb, bp, flags);
+		memset(bp, 0, sb->s_blocksize);
+		pram_unlock_block(sb, bp, flags);
+	}
+
+	*blocknr = bnr;
+	errval = 0;
+ fail:
+	unlock_super(sb);
+	return errval;
+}
+
+unsigned long pram_count_free_blocks(struct super_block *sb)
+{
+	struct pram_super_block *ps = pram_get_super(sb);
+	return ps->s_free_blocks_count;
+}

