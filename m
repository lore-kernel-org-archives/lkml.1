Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXJANPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXJANPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXJANKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:10:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXJANKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:10:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/30] IGET: Stop FreeVXFS from using iget() and read_inode()
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:10:38 +0100
Message-ID: <20071001131038.29339.93719.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the FreeVXFS filesystem from using iget() and read_inode().  Replace
vxfs_read_inode() with vxfs_iget(), and call that instead of iget().
vxfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

vxfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/freevxfs/vxfs_extern.h |    2 +-
 fs/freevxfs/vxfs_inode.c  |   45 +++++++++++++++++++++++++++++----------------
 fs/freevxfs/vxfs_lookup.c |    6 +++---
 fs/freevxfs/vxfs_super.c  |   10 +++++++---
 4 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/fs/freevxfs/vxfs_extern.h b/fs/freevxfs/vxfs_extern.h
index 91ccee8..f307694 100644
--- a/fs/freevxfs/vxfs_extern.h
+++ b/fs/freevxfs/vxfs_extern.h
@@ -58,7 +58,7 @@ extern struct inode *		vxfs_get_fake_inode(struct super_block *,
 extern void			vxfs_put_fake_inode(struct inode *);
 extern struct vxfs_inode_info *	vxfs_blkiget(struct super_block *, u_long, ino_t);
 extern struct vxfs_inode_info *	vxfs_stiget(struct super_block *, ino_t);
-extern void			vxfs_read_inode(struct inode *);
+extern struct inode *		vxfs_iget(struct super_block *, unsigned long);
 extern void			vxfs_clear_inode(struct inode *);
 
 /* vxfs_lookup.c */
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index d1f7c5b..aefda0e 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -129,7 +129,7 @@ fail:
  * Description:
  *  Search the for inode number @ino in the filesystem
  *  described by @sbp.  Use the specified inode table (@ilistp).
- *  Returns the matching VxFS inode on success, else a NULL pointer.
+ *  Returns the matching VxFS inode on success, else an error code.
  */
 static struct vxfs_inode_info *
 __vxfs_iget(ino_t ino, struct inode *ilistp)
@@ -157,12 +157,12 @@ __vxfs_iget(ino_t ino, struct inode *ilistp)
 	}
 
 	printk(KERN_WARNING "vxfs: error on page %p\n", pp);
-	return NULL;
+	return ERR_PTR(PTR_ERR(pp));
 
 fail:
 	printk(KERN_WARNING "vxfs: unable to read inode %ld\n", (unsigned long)ino);
 	vxfs_put_page(pp);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
@@ -178,7 +178,10 @@ fail:
 struct vxfs_inode_info *
 vxfs_stiget(struct super_block *sbp, ino_t ino)
 {
-        return __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
+	struct vxfs_inode_info *vip;
+
+        vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
+	return IS_ERR(vip) ? NULL : vip;
 }
 
 /**
@@ -282,23 +285,32 @@ vxfs_put_fake_inode(struct inode *ip)
 }
 
 /**
- * vxfs_read_inode - fill in inode information
- * @ip:		inode pointer to fill
+ * vxfs_iget - get an inode
+ * @sbp:	the superblock to get the inode for
+ * @ino:	the number of the inode to get
  *
  * Description:
- *  vxfs_read_inode reads the disk inode for @ip and fills
- *  in all relevant fields in @ip.
+ *  vxfs_read_inode creates an inode, reads the disk inode for @ino and fills
+ *  in all relevant fields in the new inode.
  */
-void
-vxfs_read_inode(struct inode *ip)
+struct inode *
+vxfs_iget(struct super_block *sbp, ino_t ino)
 {
-	struct super_block		*sbp = ip->i_sb;
 	struct vxfs_inode_info		*vip;
 	const struct address_space_operations	*aops;
-	ino_t				ino = ip->i_ino;
-
-	if (!(vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_ilist)))
-		return;
+	struct inode *ip;
+
+	ip = iget_locked(sbp, ino);
+	if (!ip)
+		return ERR_PTR(-ENOMEM);
+	if (!(ip->i_state & I_NEW))
+		return ip;
+
+	vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_ilist);
+	if (IS_ERR(vip)) {
+		iget_failed(ip);
+		return ERR_PTR(PTR_ERR(vip));
+	}
 
 	vxfs_iinit(ip, vip);
 
@@ -323,7 +335,8 @@ vxfs_read_inode(struct inode *ip)
 	} else
 		init_special_inode(ip, ip->i_mode, old_decode_dev(vip->vii_rdev));
 
-	return;
+	unlock_new_inode(ip);
+	return ip;
 }
 
 /**
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index bf86e54..5e08418 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -213,10 +213,10 @@ vxfs_lookup(struct inode *dip, struct dentry *dp, struct nameidata *nd)
 	lock_kernel();
 	ino = vxfs_inode_by_name(dip, dp);
 	if (ino) {
-		ip = iget(dip->i_sb, ino);
-		if (!ip) {
+		ip = vxfs_iget(dip->i_sb, ino);
+		if (IS_ERR(ip)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_PTR(PTR_ERR(ip));
 		}
 	}
 	unlock_kernel();
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 4f95572..1dacda8 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -60,7 +60,6 @@ static int		vxfs_statfs(struct dentry *, struct kstatfs *);
 static int		vxfs_remount(struct super_block *, int *, char *);
 
 static const struct super_operations vxfs_super_ops = {
-	.read_inode =		vxfs_read_inode,
 	.clear_inode =		vxfs_clear_inode,
 	.put_super =		vxfs_put_super,
 	.statfs =		vxfs_statfs,
@@ -153,6 +152,7 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 	struct buffer_head	*bp = NULL;
 	u_long			bsize;
 	struct inode *root;
+	int ret = -EINVAL;
 
 	sbp->s_flags |= MS_RDONLY;
 
@@ -219,7 +219,11 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 	}
 
 	sbp->s_op = &vxfs_super_ops;
-	root = iget(sbp, VXFS_ROOT_INO);
+	root = vxfs_iget(sbp, VXFS_ROOT_INO);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
 	sbp->s_root = d_alloc_root(root);
 	if (!sbp->s_root) {
 		iput(root);
@@ -236,7 +240,7 @@ out_free_ilist:
 out:
 	brelse(bp);
 	kfree(infp);
-	return -EINVAL;
+	return ret;
 }
 
 /*

