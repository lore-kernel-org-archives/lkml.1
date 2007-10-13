Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbXJMOxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbXJMOxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbXJMOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:51 -0400
Received: from 1wt.eu ([62.212.114.60]:3026 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762034AbXJMOmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:49 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143514.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:57 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 35/35] sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
Content-Disposition: inline; filename=0001-sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readd.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Backport of
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch

For regular files in sysfs, sysfs_readdir wants to traverse
sysfs_dirent->s_dentry->d_inode->i_ino to get to the inode number.
But, the dentry can be reclaimed under memory pressure, and there is
no synchronization with readdir.  This patch follows Tejun's scheme of
allocating and storing an inode number in the new s_ino member of a
sysfs_dirent, when dirents are created, and retrieving it from there
for readdir, so that the pointer chain doesn't have to be traversed.

Tejun's upstream patch uses a new-ish "ida" allocator which brings
along some extra complexity; this -stable patch has a brain-dead
incrementing counter which does not guarantee uniqueness, but because
sysfs doesn't hash inodes as iunique expects, uniqueness wasn't
guaranteed today anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   16 +++++++++++-----
 fs/sysfs/inode.c |    1 +
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

Index: 2.6/fs/sysfs/dir.c
===================================================================
--- 2.6.orig/fs/sysfs/dir.c
+++ 2.6/fs/sysfs/dir.c
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
@@ -42,6 +50,7 @@ static struct sysfs_dirent * sysfs_new_d
 		return NULL;
 
 	memset(sd, 0, sizeof(*sd));
+	sd->s_ino = sysfs_get_inum();
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
@@ -461,7 +470,7 @@ static int sysfs_readdir(struct file * f
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -490,10 +499,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = next->s_ino;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
Index: 2.6/fs/sysfs/inode.c
===================================================================
--- 2.6.orig/fs/sysfs/inode.c
+++ 2.6/fs/sysfs/inode.c
@@ -129,6 +129,7 @@ struct inode * sysfs_new_inode(mode_t mo
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
Index: 2.6/fs/sysfs/mount.c
===================================================================
--- 2.6.orig/fs/sysfs/mount.c
+++ 2.6/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ static struct sysfs_dirent sysfs_root = 
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
Index: 2.6/include/linux/sysfs.h
===================================================================
--- 2.6.orig/include/linux/sysfs.h
+++ 2.6/include/linux/sysfs.h
@@ -73,6 +73,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;

-- 
