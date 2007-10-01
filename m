Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbXJANUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbXJANUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXJANMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:12:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbXJANMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:12:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/30] IGET: Stop HPPFS from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:11:50 +0100
Message-ID: <20071001131150.29339.92417.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the HPPFS filesystem from using iget() and read_inode().  Provide an
hppfs_iget(), and call that instead of iget().  hppfs_iget() then uses
iget_locked() directly and returns a proper error code instead of an inode in
the event of an error.

hppfs_fill_sb_common() returns any error incurred when getting the root inode
instead of EINVAL.

Note that the contents of hppfs_kern.c need to be examined:

 (*) The HPPFS inode retains a pointer to the proc dentry it is shadowing, but
     whilst it does appear to retain a reference to it, it doesn't appear to
     destroy the reference if the inode goes away.

 (*) hppfs_iget() should perhaps subsume init_inode() and hppfs_read_inode().

 (*) It would appear that all hppfs inodes are the same inode because iget()
     was being called with inode number 0, which forms the lookup key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/hppfs/hppfs_kern.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/hppfs/hppfs_kern.c b/fs/hppfs/hppfs_kern.c
index affb741..a1e1f0f 100644
--- a/fs/hppfs/hppfs_kern.c
+++ b/fs/hppfs/hppfs_kern.c
@@ -155,6 +155,20 @@ static void hppfs_read_inode(struct inode *ino)
 	ino->i_blocks = proc_ino->i_blocks;
 }
 
+static struct inode *hppfs_iget(struct super_block *sb)
+{
+	struct inode *inode;
+
+	inode = iget_locked(sb, 0);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		hppfs_read_inode(inode);
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
 static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
                                   struct nameidata *nd)
 {
@@ -190,9 +204,11 @@ static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
 	if(IS_ERR(proc_dentry))
 		return(proc_dentry);
 
-	inode = iget(ino->i_sb, 0);
-	if(inode == NULL)
+	inode = hppfs_iget(ino->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out_dput;
+	}
 
 	err = init_inode(inode, proc_dentry);
 	if(err)
@@ -652,7 +668,6 @@ static void hppfs_destroy_inode(struct inode *inode)
 static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
-	.read_inode	= hppfs_read_inode,
 	.delete_inode	= hppfs_delete_inode,
 	.statfs		= hppfs_statfs,
 };
@@ -745,9 +760,11 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
 	sb->s_magic = HPPFS_SUPER_MAGIC;
 	sb->s_op = &hppfs_sbops;
 
-	root_inode = iget(sb, 0);
-	if(root_inode == NULL)
+	root_inode = hppfs_iget(sb);
+	if (IS_ERR(root_inode)) {
+		err = PTR_ERR(root_inode);
 		goto out;
+	}
 
 	err = init_inode(root_inode, proc_sb->s_root);
 	if(err)

