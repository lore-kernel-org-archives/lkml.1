Return-Path: <linux-kernel-owner+w=401wt.eu-S1030853AbXCNNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbXCNNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030850AbXCNNjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:39:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:59574 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030581AbXCNNiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:38:54 -0400
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Message-Id: <20070314112603.13798.75394.sendpatchset@linux.site>
In-Reply-To: <20070314112529.13798.35417.sendpatchset@linux.site>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
Subject: [patch 4/5] ext2: convert to new aops
Date: Wed, 14 Mar 2007 14:38:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement new aops for ext2.

 fs/ext2/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -643,6 +643,16 @@ ext2_readpages(struct file *file, struct
 }
 
 static int
+ext2_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, int intr,
+		struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+	return block_write_begin(file, mapping, pos, len, intr, pagep, fsdata,
+							ext2_get_block);
+}
+
+static int
 ext2_prepare_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
@@ -689,6 +699,8 @@ const struct address_space_operations ex
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_writepage,
 	.sync_page		= block_sync_page,
+	.write_begin		= ext2_write_begin,
+	.write_end		= block_write_end,
 	.prepare_write		= ext2_prepare_write,
 	.commit_write		= generic_commit_write,
 	.bmap			= ext2_bmap,
