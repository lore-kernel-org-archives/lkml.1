Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbXEUSRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbXEUSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXEUSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:17:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbXEUSRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:17:45 -0400
Message-ID: <4651E0C9.3080609@redhat.com>
Date: Mon, 21 May 2007 13:11:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <htejun@gmail.com>, Maneesh Soni <maneesh@in.ibm.com>,
       stable@kernel.org
Subject: [stable] [PATCH] - fix oops in sysfs_readdir
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a non-ida backport of Tejun's patch in -mm at:
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
for the 2.6.16 -stable tree - it follows the same scheme of using s_ino to safely
store & retrieve the inode number of sysfs entries for use in sysfs_readdir,
but uses a brain-dead-simple inode nr allocator rather than ida, which would
bring along a lot of newer, more complex code.

No, this doesn't guarantee uniqueness of sysfs inode numbers, but then
the code in -stable today doesn't either - and with this change, at least
it shouldn't oops.

Comments?

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.16.51/fs/sysfs/dir.c
===================================================================
--- linux-2.6.16.51.orig/fs/sysfs/dir.c
+++ linux-2.6.16.51/fs/sysfs/dir.c
@@ -29,6 +29,14 @@ static struct dentry_operations sysfs_de
 	.d_iput		= sysfs_d_iput,
 };
 
+static unsigned int sysfs_inode_counter;
+ino_t sysfs_get_inum(void)
+{
+	if (unlikely(sysfs_inode_counter < 3))
+		sysfs_inode_counter = 3;
+	return sysfs_inode_counter++;
+}
+
 /*
  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
  */
@@ -385,7 +393,7 @@ static int sysfs_readdir(struct file * f
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -415,10 +423,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = next->s_ino;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
Index: linux-2.6.16.51/fs/sysfs/inode.c
===================================================================
--- linux-2.6.16.51.orig/fs/sysfs/inode.c
+++ linux-2.6.16.51/fs/sysfs/inode.c
@@ -119,6 +119,7 @@ struct inode * sysfs_new_inode(mode_t mo
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 
 		if (sd->s_iattr) {
 			/* sysfs_dirent has non-default attributes
Index: linux-2.6.16.51/fs/sysfs/mount.c
===================================================================
--- linux-2.6.16.51.orig/fs/sysfs/mount.c
+++ linux-2.6.16.51/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ static struct sysfs_dirent sysfs_root = 
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
Index: linux-2.6.16.51/include/linux/sysfs.h
===================================================================
--- linux-2.6.16.51.orig/include/linux/sysfs.h
+++ linux-2.6.16.51/include/linux/sysfs.h
@@ -72,6 +72,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 };


