Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbXJJVyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbXJJVyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXJJVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:45:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbXJJVpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:45:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/31] IGET: Stop HOSTFS from using iget() and read_inode()
	[try #3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:45:36 +0100
Message-ID: <20071010214536.17535.93189.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the HOSTFS filesystem from using iget() and read_inode().  Provide
hostfs_iget(), and call that instead of iget().  hostfs_iget() then uses
iget_locked() directly and returns a proper error code instead of an inode in
the event of an error.

hostfs_fill_sb_common() returns any error incurred when getting the root inode
instead of EINVAL.

Note that the contents of hostfs_kern.c need to be examined:

 (*) hostfs_iget() should perhaps subsume init_inode() and hostfs_read_inode().

 (*) It would appear that all hostfs inodes are the same inode because iget()
     was being called with inode number 0 - which forms the lookup key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/hostfs/hostfs_kern.c |   58 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index c778620..c6a456a 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -208,7 +208,7 @@ static char *follow_link(char *link)
 	return ERR_PTR(n);
 }
 
-static int read_inode(struct inode *ino)
+static int hostfs_read_inode(struct inode *ino)
 {
 	char *name;
 	int err = 0;
@@ -238,6 +238,25 @@ static int read_inode(struct inode *ino)
 	return err;
 }
 
+static struct inode *hostfs_iget(struct super_block *sb)
+{
+	struct inode *inode;
+	long ret;
+
+	inode = iget_locked(sb, 0);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		ret = hostfs_read_inode(inode);
+		if (ret < 0) {
+			iget_failed(inode);
+			return ERR_PTR(ret);
+		}
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
 int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 {
 	/* do_statfs uses struct statfs64 internally, but the linux kernel
@@ -305,17 +324,11 @@ static void hostfs_destroy_inode(struct inode *inode)
 	kfree(HOSTFS_I(inode));
 }
 
-static void hostfs_read_inode(struct inode *inode)
-{
-	read_inode(inode);
-}
-
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
 	.destroy_inode	= hostfs_destroy_inode,
-	.read_inode	= hostfs_read_inode,
 	.statfs		= hostfs_statfs,
 };
 
@@ -584,9 +597,11 @@ int hostfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	char *name;
 	int error, fd;
 
-	error = -ENOMEM;
-	inode = iget(dir->i_sb, 0);
-	if(inode == NULL) goto out;
+	inode = hostfs_iget(dir->i_sb);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto out;
+	}
 
 	error = init_inode(inode, dentry);
 	if(error)
@@ -627,10 +642,11 @@ struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
 	char *name;
 	int err;
 
-	err = -ENOMEM;
-	inode = iget(ino->i_sb, 0);
-	if(inode == NULL)
+	inode = hostfs_iget(ino->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out;
+	}
 
 	err = init_inode(inode, dentry);
 	if(err)
@@ -748,11 +764,13 @@ int hostfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
 	struct inode *inode;
 	char *name;
-	int err = -ENOMEM;
+	int err;
 
-	inode = iget(dir->i_sb, 0);
-	if(inode == NULL)
+	inode = hostfs_iget(dir->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out;
+	}
 
 	err = init_inode(inode, dentry);
 	if(err)
@@ -973,9 +991,11 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 
 	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
-	root_inode = iget(sb, 0);
-	if(root_inode == NULL)
+	root_inode = hostfs_iget(sb);
+	if (IS_ERR(root_inode)) {
+		err = PTR_ERR(root_inode);
 		goto out_free;
+	}
 
 	err = init_inode(root_inode, NULL);
 	if(err)
@@ -991,7 +1011,7 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	if(sb->s_root == NULL)
 		goto out_put;
 
-	err = read_inode(root_inode);
+	err = hostfs_read_inode(root_inode);
 	if(err){
 		/* No iput in this case because the dput does that for us */
 		dput(sb->s_root);

