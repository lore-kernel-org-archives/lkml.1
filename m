Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZJ2KRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZJ2KRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZJ2KRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:17:15 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:62348 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZJ2KRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=p+5vnluRsvuh8XR73bn+1lU3IehlcztCz5hh5cTzzH0XfpazSJJyStPy4ENAuTwAQI
         TZh6EHX69e8RZMijj2ETx6lHuuRwDJqI7Y+KqnSb9YcBLJLKcKg5eNW54kDTl2FGqLXr
         dCQVoWWvsMIGBLw8mopgQlUJBSNrr1VYEdy10=
Date: Thu, 29 Oct 2009 13:17:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: dushistov@mail.ru, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] ufs: NFS support
Message-ID: <20091029101718.GB27166@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ufs/super.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -66,6 +66,7 @@
  */
 
 
+#include <linux/exportfs.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 
@@ -96,6 +97,56 @@
 #include "swab.h"
 #include "util.h"
 
+static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
+{
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
+	struct inode *inode;
+
+	if (ino < UFS_ROOTINO || ino > uspi->s_ncg * uspi->s_ipg)
+		return ERR_PTR(-ESTALE);
+
+	inode = ufs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	return inode;
+}
+
+static struct dentry *ufs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type, ufs_nfs_get_inode);
+}
+
+static struct dentry *ufs_fh_to_parent(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type, ufs_nfs_get_inode);
+}
+
+static struct dentry *ufs_get_parent(struct dentry *child)
+{
+	struct qstr dot_dot = {
+		.name	= "..",
+		.len	= 2,
+	};
+	ino_t ino;
+
+	ino = ufs_inode_by_name(child->d_inode, &dot_dot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+	return d_obtain_alias(ufs_iget(child->d_inode->i_sb, ino));
+}
+
+static const struct export_operations ufs_export_ops = {
+	.fh_to_dentry	= ufs_fh_to_dentry,
+	.fh_to_parent	= ufs_fh_to_parent,
+	.get_parent	= ufs_get_parent,
+};
+
 #ifdef CONFIG_UFS_DEBUG
 /*
  * Print contents of ufs_super_block, useful for debugging
@@ -990,6 +1041,7 @@ magic_found:
 	 * Read ufs_super_block into internal data structures
 	 */
 	sb->s_op = &ufs_super_ops;
+	sb->s_export_op = &ufs_export_ops;
 	sb->dq_op = NULL; /***/
 	sb->s_magic = fs32_to_cpu(sb, usb3->fs_magic);
 
