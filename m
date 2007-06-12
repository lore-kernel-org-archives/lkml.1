Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXFLXXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXFLXXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXFLXXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:23:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbXFLXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:23:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>,
       Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
Date: Tue, 12 Jun 2007 16:22:44 -0700
Message-Id: <11816905661989-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070612232159.GA12971@suse.de>
References: <20070612232159.GA12971@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

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

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 85a6686..17a8191 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -30,6 +30,14 @@ static struct dentry_operations sysfs_dentry_ops = {
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
@@ -41,6 +49,7 @@ static struct sysfs_dirent * __sysfs_new_dirent(void * element)
 	if (!sd)
 		return NULL;
 
+	sd->s_ino = sysfs_get_inum();
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
@@ -509,7 +518,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -538,10 +547,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = next->s_ino;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index bdd30e7..082e2d4 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -141,6 +141,7 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 23a48a3..00ab912 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -33,6 +33,7 @@ static struct sysfs_dirent sysfs_root = {
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
 	.s_iattr	= NULL,
+	.s_ino		= 1,
 };
 
 static void sysfs_clear_inode(struct inode *inode)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a77c57e..1966e1a 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -5,6 +5,7 @@ struct sysfs_dirent {
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
+	ino_t			s_ino;
 	struct dentry		* s_dentry;
 	struct iattr		* s_iattr;
 	atomic_t		s_event;
-- 
1.5.2.1

