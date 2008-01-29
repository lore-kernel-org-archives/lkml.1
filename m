Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbYA2STu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbYA2STu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbYA2SSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:18:49 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128AbYA2SSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:18:47 -0500
Message-Id: <20080129181827.188439899@szeredi.hu>
References: <20080129181750.616092886@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 29 Jan 2008 19:17:52 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 2/3] fuse: save space in struct fuse_req
Content-Disposition: inline; filename=fuse_move_to_union.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the fields 'dentry' and 'vfsmount' into the request specific
union, since these are only used for the RELEASE request.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-01-29 17:12:56.000000000 +0100
+++ linux/fs/fuse/file.c	2008-01-29 17:13:06.000000000 +0100
@@ -77,8 +77,8 @@ static struct fuse_file *fuse_file_get(s
 
 static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	dput(req->dentry);
-	mntput(req->vfsmount);
+	dput(req->misc.release.dentry);
+	mntput(req->misc.release.vfsmount);
 	fuse_put_request(fc, req);
 }
 
@@ -86,7 +86,8 @@ static void fuse_file_put(struct fuse_fi
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
-		struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
+		struct inode *inode = req->misc.release.dentry->d_inode;
+		struct fuse_conn *fc = get_fuse_conn(inode);
 		req->end = fuse_release_end;
 		request_send_background(fc, req);
 		kfree(ff);
@@ -137,7 +138,7 @@ int fuse_open_common(struct inode *inode
 void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 {
 	struct fuse_req *req = ff->reserved_req;
-	struct fuse_release_in *inarg = &req->misc.release_in;
+	struct fuse_release_in *inarg = &req->misc.release.in;
 
 	inarg->fh = ff->fh;
 	inarg->flags = flags;
@@ -153,13 +154,14 @@ int fuse_release_common(struct inode *in
 	struct fuse_file *ff = file->private_data;
 	if (ff) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
+		struct fuse_req *req = ff->reserved_req;
 
 		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
 				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 		/* Hold vfsmount and dentry until release is finished */
-		ff->reserved_req->vfsmount = mntget(file->f_path.mnt);
-		ff->reserved_req->dentry = dget(file->f_path.dentry);
+		req->misc.release.vfsmount = mntget(file->f_path.mnt);
+		req->misc.release.dentry = dget(file->f_path.dentry);
 
 		spin_lock(&fc->lock);
 		list_del(&ff->write_entry);
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2008-01-29 17:12:56.000000000 +0100
+++ linux/fs/fuse/fuse_i.h	2008-01-29 17:13:06.000000000 +0100
@@ -215,7 +215,11 @@ struct fuse_req {
 	/** Data for asynchronous requests */
 	union {
 		struct fuse_forget_in forget_in;
-		struct fuse_release_in release_in;
+		struct {
+			struct fuse_release_in in;
+			struct vfsmount *vfsmount;
+			struct dentry *dentry;
+		} release;
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
 		struct fuse_read_in read_in;
@@ -238,12 +242,6 @@ struct fuse_req {
 	/** File used in the request (or NULL) */
 	struct fuse_file *ff;
 
-	/** vfsmount used in release */
-	struct vfsmount *vfsmount;
-
-	/** dentry used in release */
-	struct dentry *dentry;
-
 	/** Request completion callback */
 	void (*end)(struct fuse_conn *, struct fuse_req *);
 

--
