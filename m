Return-Path: <linux-kernel-owner+w=401wt.eu-S965416AbXCNNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbXCNNio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXCNNin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:38:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbXCNNik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:38:40 -0400
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Message-Id: <20070314112553.13798.73980.sendpatchset@linux.site>
In-Reply-To: <20070314112529.13798.35417.sendpatchset@linux.site>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
Subject: [patch 3/5] fs: convert some simple filesystems
Date: Wed, 14 Mar 2007 14:38:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement new aops for some of the simpler filesystems.

 fs/configfs/inode.c |    4 ++--
 fs/sysfs/inode.c    |    4 ++--
 mm/shmem.c          |   16 ++++++++++------
 3 files changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -1419,10 +1419,14 @@ static const struct inode_operations shm
  * lets a tmpfs file be used read-write below the loop driver.
  */
 static int
-shmem_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	return shmem_getpage(inode, page->index, &page, SGP_WRITE, NULL);
+shmem_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, int intr,
+			struct page **pagep, void **fsdata)
+{
+	struct inode *inode = mapping->host;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	*pagep = NULL;
+	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
 }
 
 static ssize_t
@@ -2319,8 +2323,8 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
-	.prepare_write	= shmem_prepare_write,
-	.commit_write	= simple_commit_write,
+	.write_begin	= shmem_write_begin,
+	.write_end	= simple_write_end,
 #endif
 	.migratepage	= migrate_page,
 };
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -40,8 +40,8 @@ extern struct super_block * configfs_sb;
 
 static const struct address_space_operations configfs_aops = {
 	.readpage	= simple_readpage,
-	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
 };
 
 static struct backing_dev_info configfs_backing_dev_info = {
Index: linux-2.6/fs/sysfs/inode.c
===================================================================
--- linux-2.6.orig/fs/sysfs/inode.c
+++ linux-2.6/fs/sysfs/inode.c
@@ -20,8 +20,8 @@ extern struct super_block * sysfs_sb;
 
 static const struct address_space_operations sysfs_aops = {
 	.readpage	= simple_readpage,
-	.prepare_write	= simple_prepare_write,
-	.commit_write	= simple_commit_write
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
 };
 
 static struct backing_dev_info sysfs_backing_dev_info = {
