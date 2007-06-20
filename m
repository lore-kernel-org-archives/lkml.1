Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXFTSjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXFTSjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbXFTSbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758058AbXFTSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:14 -0400
Message-Id: <20070620183013.967063205@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:41 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [34/37] Large blocksize support in ramfs
Content-Disposition: inline; filename=vps_filesystem_ramfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The simplest file system to use for larg blocksize support is ramfs.
Add a mount parameter that specifies the page order of the pages
that ramfs should use.

Note that ramfs does not use the lower layers (buffer I/O etc) so this
case is useful for initial testing of changes to large buffer size
support if one just wants to exercise the higher layers.

If you apply this patch and then you can f.e. try this:

	mount -tramfs -o10 none /media

Mounts a ramfs filesystem with order 10 pages (4 MB)

	cp linux-2.6.21-rc7.tar.gz /media

Populate the ramfs. Note that we allocate 14 pages of 4M each
instead of 13508..

umount /media

Gets rid of the large pages again

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ramfs/inode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/ramfs/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ramfs/inode.c	2007-06-19 19:34:10.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ramfs/inode.c	2007-06-19 20:01:04.000000000 -0700
@@ -60,7 +60,8 @@ struct inode *ramfs_get_inode(struct sup
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_setup(inode->i_mapping, GFP_HIGHUSER,
+				sb->s_blocksize_bits - PAGE_SHIFT);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
 		default:
@@ -164,10 +165,15 @@ static int ramfs_fill_super(struct super
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

-- 
