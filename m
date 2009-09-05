Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbZIEA1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbZIEA1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964927AbZIEA05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:26:57 -0400
Received: from kroah.org ([198.145.64.141]:42271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934656AbZIEAVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:55 2009
Message-Id: <20090905001455.382972737@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: [patch 52/71] vfs: add __destroy_inode
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=vfs-add-__destroy_inode.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

backport of upstream commit 2e00c97e2c1d2ffc9e26252ca26b237678b0b772

When we want to tear down an inode that lost the add to the cache race
in XFS we must not call into ->destroy_inode because that would delete
the inode that won the race from the inode cache radix tree.

This patch provides the __destroy_inode helper needed to fix this,
the actual fix will be in th next patch.  As XFS was the only reason
destroy_inode was exported we shift the export to the new __destroy_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/inode.c         |   10 +++++++---
 include/linux/fs.h |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -220,18 +220,22 @@ static struct inode *alloc_inode(struct 
 	return inode;
 }
 
-void destroy_inode(struct inode *inode)
+void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	ima_inode_free(inode);
 	security_inode_free(inode);
+}
+EXPORT_SYMBOL(__destroy_inode);
+
+void destroy_inode(struct inode *inode)
+{
+	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
 		kmem_cache_free(inode_cachep, (inode));
 }
-EXPORT_SYMBOL(destroy_inode);
-
 
 /*
  * These are initializations that only need to be done
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2162,6 +2162,7 @@ extern void __iget(struct inode * inode)
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
+extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);


