Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbXH1TTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbXH1TTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbXH1TIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760829AbXH1THo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:44 -0400
Message-Id: <20070828190735.757226879@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:24 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [33/36] Large blocksize support in ramfs
Content-Disposition: inline; filename=0033-Large-blocksize-support-in-ramfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The simplest file system to use for large blocksize support is ramfs.

Note that ramfs does not use the lower layers (buffer I/O etc) so this
case is useful for initial testing of changes to large buffer size
support if one just wants to exercise the higher layers.

The patch adds the ability to specify a mount parameter to modify the
order for the pages that are allocated by ramfs.

Here is an example of how to mount a volume with order 10 pages:

	mount -tramfs -o10 none /media

Mounts a ramfs filesystem with 4MB sized pages. Then copy
a file onto it.

	cp linux-2.6.21-rc7.tar.gz /media

This will populate the ramfs volume. Note that we allocated 14 pages
of 4M each instead of 13508.

Get rid of the large pages again

	umount /media


Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ramfs/inode.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index ef2b46d..b317f80 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -60,7 +60,8 @@ struct inode *ramfs_get_inode(struct super_block *sb, int mode, dev_t dev)
 		inode->i_blocks = 0;
 		inode->i_mapping->a_ops = &ramfs_aops;
 		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
-		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_setup(inode->i_mapping, GFP_HIGHUSER,
+				sb->s_blocksize_bits - PAGE_SHIFT);
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
 		default:
@@ -164,10 +165,15 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
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
1.5.2.4

-- 
