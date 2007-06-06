Return-Path: <linux-kernel-owner+w=401wt.eu-S934717AbXFFRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717AbXFFRz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbXFFRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:55:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:54681 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746AbXFFRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=IGqeqXot/kqD4+BjdvFZztu//r1CBeJQVfiVW+vVHPBCiLqg9UU2vJrgty2kV8tbkO6umBp/cs9XnynwRieQSJnePzEurdopf8iH+r2CydC41RU6ZZ+M1F/PhNDd4cMeWvb60Y6IjHWtekYyTDbHQoKlyJNZVjySCn9ZKtGC+/g=
Date: Wed, 6 Jun 2007 21:53:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UDF: fix deadlock on inode being dropped
Message-ID: <20070606175351.GA8397@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents from deadlock on inode being dropped.
The deadlock is caused by inderect call of mark_inode_dirty()
within udf_drop_inode() but inode lock is already kept
by the kernel. So moving code from udf_drop_inode() to
udf_delete_inode() we save its functionality and avoid
deadlock.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Andrew the patch is over Jan's two patches you have dropped.
AFAIS a such code moving is quite safe but I'm waiting for
Jan's comments anyway.

 fs/udf/inode.c |   20 ++++++++------------
 fs/udf/super.c |    1 -
 2 files changed, 8 insertions(+), 13 deletions(-)


diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 9fcd76c..ae56f25 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -83,6 +83,14 @@ static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
  */
 void udf_delete_inode(struct inode *inode)
 {
+	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
+		lock_kernel();
+		/* Discard preallocation for directories, symlinks, etc. */
+		udf_discard_prealloc(inode);
+		udf_truncate_tail_extent(inode);
+		unlock_kernel();
+	}
+
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (is_bad_inode(inode))
@@ -102,18 +110,6 @@ no_delete:
 	clear_inode(inode);
 }
 
-void udf_drop_inode(struct inode *inode)
-{
-	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
-		lock_kernel();
-		/* Discard preallocation for directories, symlinks, etc. */
-		udf_discard_prealloc(inode);
-		udf_truncate_tail_extent(inode);
-		unlock_kernel();
-	}
-	generic_drop_inode(inode);
-}
-
 void udf_clear_inode(struct inode *inode)
 {
 	kfree(UDF_I_DATA(inode));
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b02d2c2..deb0d29 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -166,7 +166,6 @@ static const struct super_operations udf_sb_ops = {
 	.write_inode		= udf_write_inode,
 	.delete_inode		= udf_delete_inode,
 	.clear_inode		= udf_clear_inode,
-	.drop_inode		= udf_drop_inode,
 	.put_super		= udf_put_super,
 	.write_super		= udf_write_super,
 	.statfs			= udf_statfs,
