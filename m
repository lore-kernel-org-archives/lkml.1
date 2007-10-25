Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXJYQjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXJYQjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXJYQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:35:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbXJYQfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:35:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/31] IGET: Stop CIFS from using iget() and read_inode() [try
	#5]
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 25 Oct 2007 17:34:43 +0100
Message-ID: <20071025163443.5057.28282.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the CIFS filesystem from using iget() and read_inode().  Replace
cifs_read_inode() with cifs_iget(), and call that instead of iget().
cifs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

cifs_read_super() now returns any error incurred when getting the root inode
instead of ENOMEM.

cifs_iget() needs examining.  The comment "can not call macro FreeXid here
since in a void func" is no longer true.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cifs/cifsfs.c |    8 ++++----
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/inode.c  |   22 +++++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a6fbea5..c802ea0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -122,10 +122,11 @@ cifs_read_super(struct super_block *sb, void *data,
 #endif
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
-	inode = iget(sb, ROOT_I);
+	inode = cifs_iget(sb, ROOT_I);
 
-	if (!inode) {
-		rc = -ENOMEM;
+	if (IS_ERR(inode)) {
+		rc = PTR_ERR(inode);
+		inode = NULL;
 		goto out_no_root;
 	}
 
@@ -477,7 +478,6 @@ static int cifs_remount(struct super_block *sb, int *flags, char *data)
 }
 
 static const struct super_operations cifs_super_ops = {
-	.read_inode = cifs_read_inode,
 	.put_super = cifs_put_super,
 	.statfs = cifs_statfs,
 	.alloc_inode = cifs_alloc_inode,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 5574ba3..f85e07d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -43,6 +43,7 @@ extern void cifs_read_inode(struct inode *);
 
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
+extern struct inode *cifs_iget(struct super_block *, unsigned long);
 extern int cifs_create(struct inode *, struct dentry *, int,
 		       struct nameidata *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5e8b388..6e9c364 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -580,10 +580,18 @@ static const struct inode_operations cifs_ipc_inode_ops = {
 };
 
 /* gets root inode */
-void cifs_read_inode(struct inode *inode)
+struct inode *cifs_iget(struct super_block *sb, unsigned long ino)
 {
-	int xid, rc;
+	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct inode *inode;
+	long rc;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 	xid = GetXid();
@@ -600,10 +608,18 @@ void cifs_read_inode(struct inode *inode)
 		inode->i_fop = &simple_dir_operations;
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
+		_FreeXid(xid);
+		iget_failed(inode);
+		return ERR_PTR(rc);
 	}
 
-	/* can not call macro FreeXid here since in a void func */
+	unlock_new_inode(inode);
+
+	/* can not call macro FreeXid here since in a void func
+	 * TODO: This is no longer true
+	 */
 	_FreeXid(xid);
+	return inode;
 }
 
 int cifs_unlink(struct inode *inode, struct dentry *direntry)

