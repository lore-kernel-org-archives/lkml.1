Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXJBPzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXJBPzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXJBPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:39 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58997 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbXJBPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:36 -0400
Message-Id: <20071002155222.373341208@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 09/12] fuse: add list of writable files to fuse_inode
Content-Disposition: inline; filename=fuse_write_files.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Each WRITE request must carry a valid file descriptor.  When a page is
written back from a memory mapping, the file through which the page
was dirtied is not available, so a new mechananism is needed to find a
suitable file in ->writepage(s).

A list of fuse_files is added to fuse_inode.  The file is removed from
the list in fuse_release().

This patch is in preparation for writable mmap support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-01 22:42:26.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-01 22:42:27.000000000 +0200
@@ -56,6 +56,7 @@ struct fuse_file *fuse_file_alloc(void)
 			kfree(ff);
 			ff = NULL;
 		}
+		INIT_LIST_HEAD(&ff->write_entry);
 		atomic_set(&ff->count, 0);
 	}
 	return ff;
@@ -150,12 +151,18 @@ int fuse_release_common(struct inode *in
 {
 	struct fuse_file *ff = file->private_data;
 	if (ff) {
+		struct fuse_conn *fc = get_fuse_conn(inode);
+
 		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
 				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
 		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
 		ff->reserved_req->dentry = dget(file->f_path.dentry);
+
+		spin_lock(&fc->lock);
+		list_del(&ff->write_entry);
+		spin_unlock(&fc->lock);
 		/*
 		 * Normally this will send the RELEASE request,
 		 * however if some asynchronous READ or WRITE requests
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-10-01 22:42:24.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-10-01 22:43:15.000000000 +0200
@@ -70,6 +70,9 @@ struct fuse_inode {
 
 	/** Version of last attribute change */
 	u64 attr_version;
+
+	/** Files usable in writepage.  Protected by fc->lock */
+	struct list_head write_files;
 };
 
 /** FUSE specific file data */
@@ -82,6 +85,9 @@ struct fuse_file {
 
 	/** Refcount */
 	atomic_t count;
+
+	/** Entry on inode's write_files list */
+	struct list_head write_entry;
 };
 
 /** One input argument of a request */
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-10-01 22:42:24.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-10-01 22:42:27.000000000 +0200
@@ -56,6 +56,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	INIT_LIST_HEAD(&fi->write_files);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
 		kmem_cache_free(fuse_inode_cachep, inode);
@@ -68,6 +69,7 @@ static struct inode *fuse_alloc_inode(st
 static void fuse_destroy_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	BUG_ON(!list_empty(&fi->write_files));
 	if (fi->forget_req)
 		fuse_request_free(fi->forget_req);
 	kmem_cache_free(fuse_inode_cachep, inode);

--
