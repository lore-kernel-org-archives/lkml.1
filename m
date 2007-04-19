Return-Path: <linux-kernel-owner+w=401wt.eu-S1766865AbXDSQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766865AbXDSQfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766867AbXDSQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48177 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766865AbXDSQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:41 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 7/8] Enhance ramfs to support higher order pages
Date: Thu, 19 Apr 2007 09:35:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Add support to ramfs

The simplest file system to use is ramfs. Add a mount parameter that
specifies the page order of the pages that ramfs should use. If the
order is greater than zero then disable mmap functionality.

This could be removed if the VM would be changes to support faulting
higher order pages but for now we are content with buffered I/O on higher
order pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ramfs/file-mmu.c   |   11 +++++++++++
 fs/ramfs/inode.c      |   15 ++++++++++++---
 include/linux/ramfs.h |    1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc7/fs/ramfs/file-mmu.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/ramfs/file-mmu.c	2007-04-18 21:46:38.000000000 -0700
+++ linux-2.6.21-rc7/fs/ramfs/file-mmu.c	2007-04-18 22:02:03.000000000 -0700
@@ -45,6 +45,17 @@ const struct file_operations ramfs_file_
 	.llseek		= generic_file_llseek,
 };
 
+/* Higher order mappings do not support mmmap */
+const struct file_operations ramfs_file_higher_order_operations = {
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+	.fsync		= simple_sync_file,
+	.sendfile	= generic_file_sendfile,
+	.llseek		= generic_file_llseek,
+};
+
 const struct inode_operations ramfs_file_inode_operations = {
 	.getattr	= simple_getattr,
 };
Index: linux-2.6.21-rc7/fs/ramfs/inode.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/ramfs/inode.c	2007-04-18 21:46:38.000000000 -0700
+++ linux-2.6.21-rc7/fs/ramfs/inode.c	2007-04-18 22:02:03.000000000 -0700
@@ -61,6 +61,7 @@ struct inode *ramfs_get_inode(struct sup
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
+		inode->i_mapping->order = sb->s_blocksize_bits - PAGE_CACHE_SHIFT;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
 		default:
@@ -68,7 +69,10 @@ struct inode *ramfs_get_inode(struct sup
 			break;
 		case S_IFREG:
 			inode->i_op = &ramfs_file_inode_operations;
-			inode->i_fop = &ramfs_file_operations;
+			if (inode->i_mapping->order)
+				inode->i_fop = &ramfs_file_higher_order_operations;
+			else
+				inode->i_fop = &ramfs_file_operations;
 			break;
 		case S_IFDIR:
 			inode->i_op = &ramfs_dir_inode_operations;
@@ -164,10 +168,15 @@ static int ramfs_fill_super(struct super
 {
 	struct inode * inode;
 	struct dentry * root;
+	int order = 0;
+	char *options = data;
+
+	if (options && *options)
+		order = simple_strtoul(options, NULL, 10);
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	sb->s_blocksize = PAGE_CACHE_SIZE << order;
+	sb->s_blocksize_bits = order + PAGE_CACHE_SHIFT;
 	sb->s_magic = RAMFS_MAGIC;
 	sb->s_op = &ramfs_ops;
 	sb->s_time_gran = 1;
Index: linux-2.6.21-rc7/include/linux/ramfs.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/ramfs.h	2007-04-18 21:46:38.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/ramfs.h	2007-04-18 22:02:03.000000000 -0700
@@ -16,6 +16,7 @@ extern int ramfs_nommu_mmap(struct file 
 #endif
 
 extern const struct file_operations ramfs_file_operations;
+extern const struct file_operations ramfs_file_higher_order_operations;
 extern struct vm_operations_struct generic_file_vm_ops;
 extern int __init init_rootfs(void);
 
