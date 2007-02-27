Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXB0XSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXB0XSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXB0XSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:00 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46572 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXB0XRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:17:37 -0500
Message-Id: <20070227231649.202463098@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 13/22] fuse: add list of writable files to fuse_inode
Content-Disposition: inline; filename=fuse_write_files.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Each WRITE request must carry a valid file descriptor.  When a page is
written back from a memory mapping, the file through which the page
was dirtied is not available, so a new mechananism is needed to find a
suitable file in ->writepage(s).

A list of fuse_files is added to fuse_inode.  The file is removed from
the list in fuse_release().  The addition of the file to the list is
in a later patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:11.000000000 +0100
@@ -53,6 +53,7 @@ struct fuse_file *fuse_file_alloc(void)
 			kfree(ff);
 			ff = NULL;
 		}
+		INIT_LIST_HEAD(&ff->write_entry);
 		atomic_set(&ff->count, 0);
 	}
 	return ff;
@@ -147,12 +148,18 @@ int fuse_release_common(struct inode *in
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
--- linux.orig/fs/fuse/fuse_i.h	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2007-02-27 14:41:11.000000000 +0100
@@ -65,6 +65,9 @@ struct fuse_inode {
 	/** Time in jiffies until the file attributes are valid */
 	u64 i_time;
 
+	/** Files usable in writepage.  Protected by fc->lock */
+	struct list_head write_files;
+
 	/** Semaphore for synchronizing writes with truncate */
 	struct rw_semaphore truncate_sem;
 };
@@ -79,6 +82,9 @@ struct fuse_file {
 
 	/** Refcount */
 	atomic_t count;
+
+	/** Entry on inode's write_files list */
+	struct list_head write_entry;
 };
 
 /** One input argument of a request */
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-27 14:41:11.000000000 +0100
@@ -55,6 +55,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	INIT_LIST_HEAD(&fi->write_files);
 	init_rwsem(&fi->truncate_sem);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
@@ -68,6 +69,7 @@ static struct inode *fuse_alloc_inode(st
 static void fuse_destroy_inode(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	BUG_ON(!list_empty(&fi->write_files));
 	if (fi->forget_req)
 		fuse_request_free(fi->forget_req);
 	kmem_cache_free(fuse_inode_cachep, inode);

--
