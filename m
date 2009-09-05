Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbZIEA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbZIEA1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbZIEA1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:27:22 -0400
Received: from kroah.org ([198.145.64.141]:42264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934654AbZIEAVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:55 2009
Message-Id: <20090905001455.221274331@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: [patch 51/71] vfs: fix inode_init_always calling convention
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=vfs-fix-inode_init_always-calling-convention.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

backport of upstream commit 54e346215e4fe2ca8c94c54e546cc61902060510

Currently inode_init_always calls into ->destroy_inode if the additional
initialization fails.  That's not only counter-intuitive because
inode_init_always did not allocate the inode structure, but in case of
XFS it's actively harmful as ->destroy_inode might delete the inode from
a radix-tree that has never been added.  This in turn might end up
deleting the inode for the same inum that has been instanciated by
another process and cause lots of cause subtile problems.

Also in the case of re-initializing a reclaimable inode in XFS it would
free an inode we still want to keep alive.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/inode.c         |   30 +++++++++++++++++-------------
 fs/xfs/xfs_iget.c  |   17 +++++------------
 include/linux/fs.h |    2 +-
 3 files changed, 23 insertions(+), 26 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -118,12 +118,11 @@ static void wake_up_inode(struct inode *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
  */
-struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
+int inode_init_always(struct super_block *sb, struct inode *inode)
 {
 	static const struct address_space_operations empty_aops;
 	static struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
-
 	struct address_space *const mapping = &inode->i_data;
 
 	inode->i_sb = sb;
@@ -150,7 +149,7 @@ struct inode *inode_init_always(struct s
 	inode->dirtied_when = 0;
 
 	if (security_inode_alloc(inode))
-		goto out_free_inode;
+		goto out;
 
 	/* allocate and initialize an i_integrity */
 	if (ima_inode_alloc(inode))
@@ -189,16 +188,12 @@ struct inode *inode_init_always(struct s
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 
-	return inode;
+	return 0;
 
 out_free_security:
 	security_inode_free(inode);
-out_free_inode:
-	if (inode->i_sb->s_op->destroy_inode)
-		inode->i_sb->s_op->destroy_inode(inode);
-	else
-		kmem_cache_free(inode_cachep, (inode));
-	return NULL;
+out:
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(inode_init_always);
 
@@ -211,9 +206,18 @@ static struct inode *alloc_inode(struct 
 	else
 		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
 
-	if (inode)
-		return inode_init_always(sb, inode);
-	return NULL;
+	if (!inode)
+		return NULL;
+
+	if (unlikely(inode_init_always(sb, inode))) {
+		if (inode->i_sb->s_op->destroy_inode)
+			inode->i_sb->s_op->destroy_inode(inode);
+		else
+			kmem_cache_free(inode_cachep, inode);
+		return NULL;
+	}
+
+	return inode;
 }
 
 void destroy_inode(struct inode *inode)
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -63,6 +63,10 @@ xfs_inode_alloc(
 	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
 	if (!ip)
 		return NULL;
+	if (inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
 
 	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
@@ -104,17 +108,6 @@ xfs_inode_alloc(
 #ifdef XFS_DIR2_TRACE
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
-	/*
-	* Now initialise the VFS inode. We do this after the xfs_inode
-	* initialisation as internal failures will result in ->destroy_inode
-	* being called and that will pass down through the reclaim path and
-	* free the XFS inode. This path requires the XFS inode to already be
-	* initialised. Hence if this call fails, the xfs_inode has already
-	* been freed and we should not reference it at all in the error
-	* handling.
-	*/
-	if (!inode_init_always(mp->m_super, VFS_I(ip)))
-		return NULL;
 
 	/* prevent anyone from using this yet */
 	VFS_I(ip)->i_state = I_NEW|I_LOCK;
@@ -166,7 +159,7 @@ xfs_iget_cache_hit(
 		 * errors cleanly, then tag it so it can be set up correctly
 		 * later.
 		 */
-		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		if (inode_init_always(mp->m_super, VFS_I(ip))) {
 			error = ENOMEM;
 			goto out_error;
 		}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2135,7 +2135,7 @@ extern loff_t default_llseek(struct file
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
-extern struct inode * inode_init_always(struct super_block *, struct inode *);
+extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);


