Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbYEOTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbYEOTxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYEOTvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57977 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762137AbYEOTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:29 -0400
Message-Id: <20080515195109.463292559@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:24 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 5/9] fuse: prepare lookup for nfs export
Content-Disposition: inline; filename=fuse_nfs_export_prep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Use d_splice_alias() instead of d_add() in fuse lookup code, to allow
NFS exporting.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2008-05-09 14:04:16.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2008-05-09 14:04:49.000000000 +0200
@@ -239,18 +239,20 @@ int fuse_valid_type(int m)
  * Add a directory inode to a dentry, ensuring that no other dentry
  * refers to this inode.  Called with fc->inst_mutex.
  */
-static int fuse_d_add_directory(struct dentry *entry, struct inode *inode)
+static struct dentry *fuse_d_add_directory(struct dentry *entry,
+					   struct inode *inode)
 {
 	struct dentry *alias = d_find_alias(inode);
-	if (alias) {
+	if (alias && !(alias->d_flags & DCACHE_DISCONNECTED)) {
 		/* This tries to shrink the subtree below alias */
 		fuse_invalidate_entry(alias);
 		dput(alias);
 		if (!list_empty(&inode->i_dentry))
-			return -EBUSY;
+			return ERR_PTR(-EBUSY);
+	} else {
+		dput(alias);
 	}
-	d_add(entry, inode);
-	return 0;
+	return d_splice_alias(inode, entry);
 }
 
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
@@ -259,6 +261,7 @@ static struct dentry *fuse_lookup(struct
 	int err;
 	struct fuse_entry_out outarg;
 	struct inode *inode = NULL;
+	struct dentry *newent;
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct fuse_req *req;
 	struct fuse_req *forget_req;
@@ -303,21 +306,22 @@ static struct dentry *fuse_lookup(struct
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		mutex_lock(&fc->inst_mutex);
-		err = fuse_d_add_directory(entry, inode);
+		newent = fuse_d_add_directory(entry, inode);
 		mutex_unlock(&fc->inst_mutex);
-		if (err) {
+		if (IS_ERR(newent)) {
 			iput(inode);
-			return ERR_PTR(err);
+			return newent;
 		}
 	} else
-		d_add(entry, inode);
+		newent = d_splice_alias(inode, entry);
 
+	entry = newent ? newent : entry;
 	entry->d_op = &fuse_dentry_operations;
 	if (!err)
 		fuse_change_entry_timeout(entry, &outarg);
 	else
 		fuse_invalidate_entry_cache(entry);
-	return NULL;
+	return newent;
 }
 
 /*

--
