Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXJLJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXJLJUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXJLJJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:09:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXJLJJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:09:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/31] IGET: Stop ROMFS from using iget() and read_inode()
	[try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:09:16 +0100
Message-ID: <20071012090916.3442.77735.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the ROMFS filesystem from using iget() and read_inode().  Replace
romfs_read_inode() with romfs_iget(), and call that instead of iget().
romfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

romfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/romfs/inode.c |   45 +++++++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index dae7945..5071c9a 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -84,6 +84,8 @@ struct romfs_inode_info {
 	struct inode vfs_inode;
 };
 
+static struct inode *romfs_iget(struct super_block *, unsigned long);
+
 /* instead of private superblock data */
 static inline unsigned long romfs_maxsize(struct super_block *sb)
 {
@@ -117,7 +119,7 @@ static int romfs_fill_super(struct super_block *s, void *data, int silent)
 	struct buffer_head *bh;
 	struct romfs_super_block *rsb;
 	struct inode *root;
-	int sz;
+	int sz, ret = -EINVAL;
 
 	/* I would parse the options here, but there are none.. :) */
 
@@ -157,10 +159,13 @@ static int romfs_fill_super(struct super_block *s, void *data, int silent)
 	     & ROMFH_MASK;
 
 	s->s_op	= &romfs_ops;
-	root = iget(s, sz);
-	if (!root)
+	root = romfs_iget(s, sz);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto out;
+	}
 
+	ret = -ENOMEM;
 	s->s_root = d_alloc_root(root);
 	if (!s->s_root)
 		goto outiput;
@@ -173,7 +178,7 @@ outiput:
 out:
 	brelse(bh);
 outnobh:
-	return -EINVAL;
+	return ret;
 }
 
 /* That's simple too. */
@@ -389,8 +394,11 @@ romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 
-	if ((inode = iget(dir->i_sb, offset)))
-		goto outi;
+	inode = romfs_iget(dir->i_sb, offset);
+	if (IS_ERR(inode)) {
+		res = PTR_ERR(inode);
+		goto out;
+	}
 
 	/*
 	 * it's a bit funky, _lookup needs to return an error code
@@ -402,7 +410,7 @@ romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	 */
 
 out0:	inode = NULL;
-outi:	res = 0;
+	res = 0;
 	d_add (dentry, inode);
 
 out:	unlock_kernel();
@@ -478,20 +486,28 @@ static mode_t romfs_modemap[] =
 	S_IFBLK+0600, S_IFCHR+0600, S_IFSOCK+0644, S_IFIFO+0644
 };
 
-static void
-romfs_read_inode(struct inode *i)
+static struct inode *
+romfs_iget(struct super_block *sb, unsigned long ino)
 {
-	int nextfh, ino;
+	int nextfh;
 	struct romfs_inode ri;
+	struct inode *i;
+
+	ino &= ROMFH_MASK;
+	i = iget_locked(sb, ino);
+	if (!i)
+		return ERR_PTR(-ENOMEM);
+	if (!(i->i_state & I_NEW))
+		return i;
 
-	ino = i->i_ino & ROMFH_MASK;
 	i->i_mode = 0;
 
 	/* Loop for finding the real hard link */
 	for(;;) {
 		if (romfs_copyfrom(i, &ri, ino, ROMFH_SIZE) <= 0) {
-			printk("romfs: read error for inode 0x%x\n", ino);
-			return;
+			printk("romfs: read error for inode 0x%lx\n", ino);
+			iget_failed(i);
+			return ERR_PTR(-EIO);
 		}
 		/* XXX: do romfs_checksum here too (with name) */
 
@@ -548,6 +564,8 @@ romfs_read_inode(struct inode *i)
 			init_special_inode(i, ino,
 					MKDEV(nextfh>>16,nextfh&0xffff));
 	}
+	unlock_new_inode(i);
+	return i;
 }
 
 static struct kmem_cache * romfs_inode_cachep;
@@ -599,7 +617,6 @@ static int romfs_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations romfs_ops = {
 	.alloc_inode	= romfs_alloc_inode,
 	.destroy_inode	= romfs_destroy_inode,
-	.read_inode	= romfs_read_inode,
 	.statfs		= romfs_statfs,
 	.remount_fs	= romfs_remount,
 };

