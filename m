Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXKJXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXKJXD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXKJXDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:03:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:56781 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbXKJXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:03:46 -0500
Date: Sat, 10 Nov 2007 17:02:19 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Trond.Myklebust@netapp.com
Subject: [PATCH] NFS: Fix the ustat() regression
Message-ID: <Pine.LNX.4.64.0711101701360.31912@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Since 2.6.18, the superblock sb->s_root has been a dummy dentry with a
dummy inode. This breaks ustat(), which actually uses sb->s_root in a
vfstat() call.

Fix this by making the s_root a dummy alias to the directory inode that was
used when creating the superblock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 fs/nfs/getroot.c |   81 ++++++++++++++++++------------------------------------
 1 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 522e5ad..0ee4384 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -43,6 +43,25 @@
 #define NFSDBG_FACILITY		NFSDBG_CLIENT

 /*
+ * Set the superblock root dentry.
+ * Note that this function frees the inode in case of error.
+ */
+static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *inode)
+{
+	/* The mntroot acts as the dummy root dentry for this superblock */
+	if (sb->s_root == NULL) {
+		sb->s_root = d_alloc_root(inode);
+		if (sb->s_root == NULL) {
+			iput(inode);
+			return -ENOMEM;
+		}
+		/* Circumvent igrab(): we know the inode is not being freed */
+		atomic_inc(&inode->i_count);
+	}
+	return 0;
+}
+
+/*
  * get an NFS2/NFS3 root dentry from the root filehandle
  */
 struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
@@ -54,33 +73,6 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 	struct inode *inode;
 	int error;

-	/* create a dummy root dentry with dummy inode for this superblock */
-	if (!sb->s_root) {
-		struct nfs_fh dummyfh;
-		struct dentry *root;
-		struct inode *iroot;
-
-		memset(&dummyfh, 0, sizeof(dummyfh));
-		memset(&fattr, 0, sizeof(fattr));
-		nfs_fattr_init(&fattr);
-		fattr.valid = NFS_ATTR_FATTR;
-		fattr.type = NFDIR;
-		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
-		fattr.nlink = 2;
-
-		iroot = nfs_fhget(sb, &dummyfh, &fattr);
-		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
-
-		root = d_alloc_root(iroot);
-		if (!root) {
-			iput(iroot);
-			return ERR_PTR(-ENOMEM);
-		}
-
-		sb->s_root = root;
-	}
-
 	/* get the actual root for this mount */
 	fsinfo.fattr = &fattr;

@@ -96,6 +88,10 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 		return ERR_PTR(PTR_ERR(inode));
 	}

+	error = nfs_superblock_set_dummy_root(sb, inode);
+	if (error != 0)
+		return ERR_PTR(error);
+
 	/* root dentries normally start off anonymous and get spliced in later
 	 * if the dentry tree reaches them; however if the dentry already
 	 * exists, we'll pick it up at this point and use it as the root
@@ -241,33 +237,6 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)

 	dprintk("--> nfs4_get_root()\n");

-	/* create a dummy root dentry with dummy inode for this superblock */
-	if (!sb->s_root) {
-		struct nfs_fh dummyfh;
-		struct dentry *root;
-		struct inode *iroot;
-
-		memset(&dummyfh, 0, sizeof(dummyfh));
-		memset(&fattr, 0, sizeof(fattr));
-		nfs_fattr_init(&fattr);
-		fattr.valid = NFS_ATTR_FATTR;
-		fattr.type = NFDIR;
-		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
-		fattr.nlink = 2;
-
-		iroot = nfs_fhget(sb, &dummyfh, &fattr);
-		if (IS_ERR(iroot))
-			return ERR_PTR(PTR_ERR(iroot));
-
-		root = d_alloc_root(iroot);
-		if (!root) {
-			iput(iroot);
-			return ERR_PTR(-ENOMEM);
-		}
-
-		sb->s_root = root;
-	}
-
 	/* get the info about the server and filesystem */
 	error = nfs4_server_capabilities(server, mntfh);
 	if (error < 0) {
@@ -289,6 +258,10 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
 		return ERR_PTR(PTR_ERR(inode));
 	}

+	error = nfs_superblock_set_dummy_root(sb, inode);
+	if (error != 0)
+		return ERR_PTR(error);
+
 	/* root dentries normally start off anonymous and get spliced in later
 	 * if the dentry tree reaches them; however if the dentry already
 	 * exists, we'll pick it up at this point and use it as the root
-- 
1.5.3.4

