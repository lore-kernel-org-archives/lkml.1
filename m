Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZGFQza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZGFQza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZGFQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:55:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZGFQzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:55:20 -0400
Date: Mon, 6 Jul 2009 18:55:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [rfc][patch 2/3] fs: make use of new helper functions
Message-ID: <20090706165522.GR2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706165438.GQ2714@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update some fs code to make use of new helper functions introduced
in the previous patch. Should be no significant change in behaviour
(except CIFS now calls send_sig under i_lock, via inode_truncate_ok).

---
 fs/buffer.c           |   10 +--------
 fs/cifs/inode.c       |   51 ++++++++-----------------------------------------
 fs/fuse/dir.c         |   13 +++---------
 fs/fuse/fuse_i.h      |    2 -
 fs/fuse/inode.c       |   10 ---------
 fs/nfs/inode.c        |   52 +++++++++++---------------------------------------
 fs/ramfs/file-nommu.c |   18 ++++-------------
 7 files changed, 33 insertions(+), 123 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -2228,16 +2228,10 @@ int generic_cont_expand_simple(struct in
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
 	void *fsdata;
-	unsigned long limit;
 	int err;
 
-	err = -EFBIG;
-        limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && size > (loff_t)limit) {
-		send_sig(SIGXFSZ, current, 0);
-		goto out;
-	}
-	if (size > inode->i_sb->s_maxbytes)
+	err = inode_truncate_ok(inode, size);
+	if (err)
 		goto out;
 
 	err = pagecache_write_begin(NULL, mapping, size, 0,
Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c
+++ linux-2.6/fs/cifs/inode.c
@@ -1645,57 +1645,24 @@ static int cifs_truncate_page(struct add
 
 static int cifs_vmtruncate(struct inode *inode, loff_t offset)
 {
-	struct address_space *mapping = inode->i_mapping;
-	unsigned long limit;
+	loff_t oldsize;
+	int err;
 
 	spin_lock(&inode->i_lock);
-	if (inode->i_size < offset)
-		goto do_expand;
-	/*
-	 * truncation of in-use swapfiles is disallowed - it would cause
-	 * subsequent swapout to scribble on the now-freed blocks.
-	 */
-	if (IS_SWAPFILE(inode)) {
+	err = inode_truncate_ok(inode, offset);
+	if (err) {
 		spin_unlock(&inode->i_lock);
-		goto out_busy;
+		goto out;
 	}
-	i_size_write(inode, offset);
-	spin_unlock(&inode->i_lock);
-	/*
-	 * unmap_mapping_range is called twice, first simply for efficiency
-	 * so that truncate_inode_pages does fewer single-page unmaps. However
-	 * after this first call, and before truncate_inode_pages finishes,
-	 * it is possible for private pages to be COWed, which remain after
-	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
-	 * call must be made for correctness.
-	 */
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, offset);
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	goto out_truncate;
 
-do_expand:
-	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && offset > limit) {
-		spin_unlock(&inode->i_lock);
-		goto out_sig;
-	}
-	if (offset > inode->i_sb->s_maxbytes) {
-		spin_unlock(&inode->i_lock);
-		goto out_big;
-	}
+	oldsize = inode->i_size;
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
-out_truncate:
+	truncate_pagecache(inode, oldsize, offset);
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
-	return 0;
-out_sig:
-	send_sig(SIGXFSZ, current, 0);
-out_big:
-	return -EFBIG;
-out_busy:
-	return -ETXTBSY;
+out:
+	return err;
 }
 
 static int
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c
+++ linux-2.6/fs/fuse/dir.c
@@ -1225,14 +1225,9 @@ static int fuse_do_setattr(struct dentry
 		return 0;
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		unsigned long limit;
-		if (IS_SWAPFILE(inode))
-			return -ETXTBSY;
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-		if (limit != RLIM_INFINITY && attr->ia_size > (loff_t) limit) {
-			send_sig(SIGXFSZ, current, 0);
-			return -EFBIG;
-		}
+		err = inode_truncate_ok(inode, attr->ia_size);
+		if (err)
+			return err;
 		is_truncate = true;
 	}
 
@@ -1300,7 +1295,7 @@ static int fuse_do_setattr(struct dentry
 	 */
 	if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
 		if (outarg.attr.size < oldsize)
-			fuse_truncate(inode->i_mapping, outarg.attr.size);
+			truncate_pagecache(inode, oldsize, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
 
Index: linux-2.6/fs/nfs/inode.c
===================================================================
--- linux-2.6.orig/fs/nfs/inode.c
+++ linux-2.6/fs/nfs/inode.c
@@ -427,49 +427,21 @@ nfs_setattr(struct dentry *dentry, struc
  */
 static int nfs_vmtruncate(struct inode * inode, loff_t offset)
 {
-	if (i_size_read(inode) < offset) {
-		unsigned long limit;
+	loff_t oldsize;
+	int err;
 
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-		if (limit != RLIM_INFINITY && offset > limit)
-			goto out_sig;
-		if (offset > inode->i_sb->s_maxbytes)
-			goto out_big;
-		spin_lock(&inode->i_lock);
-		i_size_write(inode, offset);
-		spin_unlock(&inode->i_lock);
-	} else {
-		struct address_space *mapping = inode->i_mapping;
+	err = inode_truncate_ok(inode, offset);
+	if (err)
+		goto out;
 
-		/*
-		 * truncation of in-use swapfiles is disallowed - it would
-		 * cause subsequent swapout to scribble on the now-freed
-		 * blocks.
-		 */
-		if (IS_SWAPFILE(inode))
-			return -ETXTBSY;
-		spin_lock(&inode->i_lock);
-		i_size_write(inode, offset);
-		spin_unlock(&inode->i_lock);
+	spin_lock(&inode->i_lock);
+	oldsize = inode->i_size;
+	i_size_write(inode, offset);
+	spin_unlock(&inode->i_lock);
 
-		/*
-		 * unmap_mapping_range is called twice, first simply for
-		 * efficiency so that truncate_inode_pages does fewer
-		 * single-page unmaps.  However after this first call, and
-		 * before truncate_inode_pages finishes, it is possible for
-		 * private pages to be COWed, which remain after
-		 * truncate_inode_pages finishes, hence the second
-		 * unmap_mapping_range call must be made for correctness.
-		 */
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, offset);
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	}
-	return 0;
-out_sig:
-	send_sig(SIGXFSZ, current, 0);
-out_big:
-	return -EFBIG;
+	truncate_pagecache(inode, oldsize, offset);
+out:
+	return err;
 }
 
 /**
Index: linux-2.6/fs/ramfs/file-nommu.c
===================================================================
--- linux-2.6.orig/fs/ramfs/file-nommu.c
+++ linux-2.6/fs/ramfs/file-nommu.c
@@ -68,14 +68,11 @@ int ramfs_nommu_expand_for_mapping(struc
 	/* make various checks */
 	order = get_order(newsize);
 	if (unlikely(order >= MAX_ORDER))
-		goto too_big;
+		return -EFBIG;
 
-	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && newsize > limit)
-		goto fsize_exceeded;
-
-	if (newsize > inode->i_sb->s_maxbytes)
-		goto too_big;
+	ret = inode_truncate_ok(inode, newsize);
+	if (ret)
+		return ret;
 
 	i_size_write(inode, newsize);
 
@@ -117,12 +114,7 @@ int ramfs_nommu_expand_for_mapping(struc
 
 	return 0;
 
- fsize_exceeded:
-	send_sig(SIGXFSZ, current, 0);
- too_big:
-	return -EFBIG;
-
- add_error:
+add_error:
 	while (loop < npages)
 		__free_page(pages + loop++);
 	return ret;
Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h
+++ linux-2.6/fs/fuse/fuse_i.h
@@ -588,8 +588,6 @@ void fuse_change_attributes(struct inode
 void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 				   u64 attr_valid);
 
-void fuse_truncate(struct address_space *mapping, loff_t offset);
-
 /**
  * Initialize the client device
  */
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c
+++ linux-2.6/fs/fuse/inode.c
@@ -115,14 +115,6 @@ static int fuse_remount_fs(struct super_
 	return 0;
 }
 
-void fuse_truncate(struct address_space *mapping, loff_t offset)
-{
-	/* See vmtruncate() */
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, offset);
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-}
-
 void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 				   u64 attr_valid)
 {
@@ -181,7 +173,7 @@ void fuse_change_attributes(struct inode
 
 	if (S_ISREG(inode->i_mode) && oldsize != attr->size) {
 		if (attr->size < oldsize)
-			fuse_truncate(inode->i_mapping, attr->size);
+			truncate_pagecache(inode, oldsize, attr->size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
 }
