Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbYEOTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbYEOTyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762380AbYEOTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57989 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbYEOTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:36 -0400
Message-Id: <20080515195113.155972816@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:27 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 8/9] fuse: nfs export special lookups
Content-Disposition: inline; filename=fuse_nfs_export_lookup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement the get_parent export operation by sending a LOOKUP request
with ".." as the name.

Implement looking up an inode by node ID after it has been evicted
from the cache.  This is done by seding a LOOKUP request with "." as
the name (for all file types, not just directories).

The filesystem can set the FUSE_EXPORT_SUPPORT flag in the INIT reply,
to indicate that it supports these special lookups.

Thanks to John Muir for the original implementation of this feature.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/fuse_i.h     |    6 ++++
 fs/fuse/inode.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fuse.h |    3 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h	2008-05-15 21:13:52.000000000 +0200
+++ linux-2.6/fs/fuse/fuse_i.h	2008-05-15 21:13:53.000000000 +0200
@@ -363,6 +363,9 @@ struct fuse_conn {
 	/** Do not send separate SETATTR request before open(O_TRUNC)  */
 	unsigned atomic_o_trunc : 1;
 
+	/** Filesystem supports NFS exporting.  Only set in INIT */
+	unsigned export_support : 1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
@@ -473,6 +476,9 @@ struct inode *fuse_iget(struct super_blo
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version);
 
+int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
+		     struct fuse_entry_out *outarg, struct inode **inode);
+
 /**
  * Send FORGET command
  */
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2008-05-15 21:13:52.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2008-05-15 21:13:53.000000000 +0200
@@ -557,6 +557,7 @@ struct fuse_inode_handle
 static struct dentry *fuse_get_dentry(struct super_block *sb,
 				      struct fuse_inode_handle *handle)
 {
+	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct inode *inode;
 	struct dentry *entry;
 	int err = -ESTALE;
@@ -565,8 +566,27 @@ static struct dentry *fuse_get_dentry(st
 		goto out_err;
 
 	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
-	if (!inode)
-		goto out_err;
+	if (!inode) {
+		struct fuse_entry_out outarg;
+		struct qstr name;
+
+		if (!fc->export_support)
+			goto out_err;
+
+		name.len = 1;
+		name.name = ".";
+		err = fuse_lookup_name(sb, handle->nodeid, &name, &outarg,
+				       &inode);
+		if (err && err != -ENOENT)
+			goto out_err;
+		if (err || !inode) {
+			err = -ESTALE;
+			goto out_err;
+		}
+		err = -EIO;
+		if (get_node_id(inode) != handle->nodeid)
+			goto out_iput;
+	}
 	err = -ESTALE;
 	if (inode->i_generation != handle->generation)
 		goto out_iput;
@@ -654,11 +674,46 @@ static struct dentry *fuse_fh_to_parent(
 	return fuse_get_dentry(sb, &parent);
 }
 
+static struct dentry *fuse_get_parent(struct dentry *child)
+{
+	struct inode *child_inode = child->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(child_inode);
+	struct inode *inode;
+	struct dentry *parent;
+	struct fuse_entry_out outarg;
+	struct qstr name;
+	int err;
+
+	if (!fc->export_support)
+		return ERR_PTR(-ESTALE);
+
+	name.len = 2;
+	name.name = "..";
+	err = fuse_lookup_name(child_inode->i_sb, get_node_id(child_inode),
+			       &name, &outarg, &inode);
+	if (err && err != -ENOENT)
+		return ERR_PTR(err);
+	if (err || !inode)
+		return ERR_PTR(-ESTALE);
+
+	parent = d_alloc_anon(inode);
+	if (!parent) {
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	if (get_node_id(inode) != FUSE_ROOT_ID) {
+		parent->d_op = &fuse_dentry_operations;
+		fuse_invalidate_entry_cache(parent);
+	}
+
+	return parent;
+}
 
 static const struct export_operations fuse_export_operations = {
 	.fh_to_dentry	= fuse_fh_to_dentry,
 	.fh_to_parent	= fuse_fh_to_parent,
 	.encode_fh	= fuse_encode_fh,
+	.get_parent	= fuse_get_parent,
 };
 
 static const struct super_operations fuse_super_operations = {
@@ -690,6 +745,11 @@ static void process_init_reply(struct fu
 				fc->no_lock = 1;
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
+			if (arg->minor >= 9) {
+				/* LOOKUP has dependency on proto version */
+				if (arg->flags & FUSE_EXPORT_SUPPORT)
+					fc->export_support = 1;
+			}
 			if (arg->flags & FUSE_BIG_WRITES)
 				fc->big_writes = 1;
 		} else {
@@ -716,7 +776,7 @@ static void fuse_send_init(struct fuse_c
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
 	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
-		FUSE_BIG_WRITES;
+		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
Index: linux-2.6/include/linux/fuse.h
===================================================================
--- linux-2.6.orig/include/linux/fuse.h	2008-05-15 21:13:44.000000000 +0200
+++ linux-2.6/include/linux/fuse.h	2008-05-15 21:13:53.000000000 +0200
@@ -104,11 +104,14 @@ struct fuse_file_lock {
 
 /**
  * INIT request/reply flags
+ *
+ * FUSE_EXPORT_SUPPORT: filesystem handles lookups of "." and ".."
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
 #define FUSE_ATOMIC_O_TRUNC	(1 << 3)
+#define FUSE_EXPORT_SUPPORT	(1 << 4)
 #define FUSE_BIG_WRITES		(1 << 5)
 
 /**

--
