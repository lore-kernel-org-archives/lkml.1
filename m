Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYEaPkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYEaPkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYEaPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYEaPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:15 -0400
Message-Id: <20080531153511.075653384@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:18 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 5/7] cramfs: allow writing to existing files
Content-Disposition: inline; filename=0005-cramfs-allow-writing-to-existing-files.patch
X-Provags-ID: V01U2FsdGVkX185AQ6jU/oYVxm4aAXRnE0eGaZhJJy/+ChnrLD
 CLafFTGDAqyCXP0yoBvpjtABfUuiLh+8I2cS52LNl/Hoh/Gb5t
 f4+lA7CrMbeBYxGmwQ9VA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing files in cramfs basically become ramfs files,
and we use the ramfs_file_operations for them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 8c3e8bb..0d3ac80 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
+#include <linux/ramfs.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
 #include <linux/cramfs_fs.h>
@@ -50,7 +51,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
            contents.  1 yields the right result in GNU find, even
 	   without -noleaf option. */
 	if (S_ISREG(mode)) {
-		inode->i_fop = &generic_ro_fops;
+		inode->i_fop = &ramfs_file_operations;
 		inode->i_data.a_ops = &cramfs_aops;
 	} else if (S_ISDIR(mode)) {
 		inode->i_op = &cramfs_dir_inode_operations;
@@ -531,6 +532,11 @@ static int cramfs_readpage(struct file *file, struct page * page)
 	u32 maxblock, bytes_filled;
 	void *pgdata;
 
+	/* FIXME: not enough we also need to handle sparse files
+	 * that originally came from the disk */
+	if (!inode->i_private)
+		return simple_readpage(file, page);
+
 	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	bytes_filled = 0;
 	if (page->index < maxblock) {
@@ -568,7 +574,10 @@ static int cramfs_readpage(struct file *file, struct page * page)
 }
 
 static const struct address_space_operations cramfs_aops = {
-	.readpage = cramfs_readpage
+	.readpage	= cramfs_readpage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.set_page_dirty = __set_page_dirty_no_writeback,
 };
 
 /*
-- 
1.5.4.3

-- 

