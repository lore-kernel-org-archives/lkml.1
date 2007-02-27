Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXB0XWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXB0XWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXB0XWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:22:00 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:50975 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXB0XRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:17:24 -0500
Message-Id: <20070227231639.540732468@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 11/22] fuse: add truncation semaphore
Content-Disposition: inline; filename=fuse_truncate_sem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new semaphore to prevent asynchronous page writeback during the
TRUNCATE request.

Using i_alloc_sem would almost work, but it has to be released before
invalidating the truncated pages, so it's easier to define a separate
one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/dir.c	2007-02-27 14:41:10.000000000 +0100
@@ -981,19 +981,9 @@ static void iattr_to_fattr(struct iattr 
 
 static void fuse_vmtruncate(struct inode *inode, loff_t offset)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	int need_trunc;
-
-	spin_lock(&fc->lock);
-	need_trunc = inode->i_size > offset;
-	i_size_write(inode, offset);
-	spin_unlock(&fc->lock);
-
-	if (need_trunc) {
-		struct address_space *mapping = inode->i_mapping;
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, offset);
-	}
+	struct address_space *mapping = inode->i_mapping;
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(mapping, offset);
 }
 
 /*
@@ -1037,6 +1027,9 @@ static int fuse_setattr(struct dentry *e
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	if (is_truncate)
+		down_write(&fi->truncate_sem);
+
 	memset(&inarg, 0, sizeof(inarg));
 	iattr_to_fattr(attr, &inarg);
 	req->in.h.opcode = FUSE_SETATTR;
@@ -1050,20 +1043,41 @@ static int fuse_setattr(struct dentry *e
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err) {
-		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
-			err = -EIO;
-		} else {
-			if (is_truncate)
-				fuse_vmtruncate(inode, outarg.attr.size);
-			fuse_change_attributes(inode, &outarg.attr);
-			fi->i_time = time_to_jiffies(outarg.attr_valid,
-						     outarg.attr_valid_nsec);
-		}
-	} else if (err == -EINTR)
+	if (err == -EINTR)
 		fuse_invalidate_attr(inode);
+	if (err)
+		goto out_err;
 
+	err = -EIO;
+	if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
+		make_bad_inode(inode);
+		goto out_err;
+	}
+
+	if (is_truncate) {
+		int need_trunc;
+
+		spin_lock(&fc->lock);
+		need_trunc = inode->i_size > outarg.attr.size;
+		i_size_write(inode, outarg.attr.size);
+		spin_unlock(&fc->lock);
+
+		/*
+		 * Lock ordering is: page-lock -> truncate_sem, because
+		 * writepage is called with a locked page.  So release
+		 * truncate_sem before truncating the mapping
+		 */
+		up_write(&fi->truncate_sem);
+		if (need_trunc)
+			fuse_vmtruncate(inode, outarg.attr.size);
+	}
+	fuse_change_attributes(inode, &outarg.attr);
+	fi->i_time = time_to_jiffies(outarg.attr_valid, outarg.attr_valid_nsec);
+	return 0;
+
+ out_err:
+	if (is_truncate)
+		up_write(&fi->truncate_sem);
 	return err;
 }
 
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 14:41:10.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/backing-dev.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -63,6 +64,9 @@ struct fuse_inode {
 
 	/** Time in jiffies until the file attributes are valid */
 	u64 i_time;
+
+	/** Semaphore for synchronizing writes with truncate */
+	struct rw_semaphore truncate_sem;
 };
 
 /** FUSE specific file data */
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-27 14:41:10.000000000 +0100
@@ -55,6 +55,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	init_rwsem(&fi->truncate_sem);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
 		kmem_cache_free(fuse_inode_cachep, inode);

--
