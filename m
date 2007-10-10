Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbXJJVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbXJJVrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXJJVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:44:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbXJJVoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:44:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/31] IGET: Stop CIFS from using iget() and read_inode() [try
	#3]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Wed, 10 Oct 2007 22:43:59 +0100
Message-ID: <20071010214359.17535.70806.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk>
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

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cifs/cifsfs.c |    8 ++++----
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/inode.c  |   35 ++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cabb6a5..1cb13f5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -126,10 +126,11 @@ cifs_read_super(struct super_block *sb, void *data,
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
 
@@ -481,7 +482,6 @@ static int cifs_remount(struct super_block *sb, int *flags, char *data)
 }
 
 static const struct super_operations cifs_super_ops = {
-	.read_inode = cifs_read_inode,
 	.put_super = cifs_put_super,
 	.statfs = cifs_statfs,
 	.alloc_inode = cifs_alloc_inode,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index a20de77..74a3190 100644
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
index dd41677..48966b9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -576,20 +576,37 @@ int cifs_get_inode_info(struct inode **pinode,
 }
 
 /* gets root inode */
-void cifs_read_inode(struct inode *inode)
+struct inode *cifs_iget(struct super_block *sb, unsigned long ino)
 {
 	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct inode *inode;
+	long ret;
 
-	cifs_sb = CIFS_SB(inode->i_sb);
-	xid = GetXid();
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		cifs_sb = CIFS_SB(inode->i_sb);
+		xid = GetXid();
 
-	if (cifs_sb->tcon->unix_ext)
-		cifs_get_inode_info_unix(&inode, "", inode->i_sb, xid);
-	else
-		cifs_get_inode_info(&inode, "", NULL, inode->i_sb, xid);
-	/* can not call macro FreeXid here since in a void func */
-	_FreeXid(xid);
+		if (cifs_sb->tcon->unix_ext)
+			ret = cifs_get_inode_info_unix(&inode, "", inode->i_sb,
+						       xid);
+		else
+			ret = cifs_get_inode_info(&inode, "", NULL, inode->i_sb,
+						  xid);
+		/* can not call macro FreeXid here since in a void func */
+		_FreeXid(xid);
+		if (ret < 0) {
+			iget_failed(inode);
+			inode = ERR_PTR(ret);
+		} else {
+			unlock_new_inode(inode);
+		}
+	}
+
+	return inode;
 }
 
 int cifs_unlink(struct inode *inode, struct dentry *direntry)

