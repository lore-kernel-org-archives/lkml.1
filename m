Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbXD1Nnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbXD1Nnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXD1Nkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbXD1Nj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=D5eYRTp+Fg6DejfYqb3Idgc5/GffIx9i9rOMhOF6fL9Y5utYg5ZylBX5KwtOewNXUyc0BJyonG/5yGYWX8vM7RWyoamT2D47j2+MSJ+OtDP7dNWYYXEnxAxqf4Gb4cSzjfgQy5JDj4b+p6mqdJuLLqSF57KIeO6Nq2UmPCsh/dc=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 05/21] sysfs: allocate inode number using ida
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:40 +0900
Message-Id: <117776758093-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Inode number handling was incorrect in two ways.

1. sysfs uses the inode number allocated by new_inode() and never
   hashes it.  When reporting the inode number, it uses iunique() if
   inode is inaccessible.  This is incorrect because iunique() assumes
   the inodes are hashed.  This can cause duplicate inode numbers and
   the condition is likely to happen because new_inode() and iunique()
   use separate increasing static counters to scan for empty slot.

2. sysfs_dirent->s_dentry can go away anytime and can't be referenced
   unless the caller knows the dentry is not and not going to be
   deleted.

This patch adds sysfs_dirent->s_ino and uses ida to give each sd a
unique inode number on allocation which is freed when the sd is
released.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   43 ++++++++++++++++++++++++++++++++++++++-----
 fs/sysfs/inode.c |    1 +
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4dc4322..ada8405 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -9,11 +9,41 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
+#include <linux/idr.h>
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
 
+static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_IDA(sysfs_ino_ida);
+
+int sysfs_alloc_ino(ino_t *pino)
+{
+	int ino, rc;
+
+ retry:
+	spin_lock(&sysfs_ino_lock);
+	rc = ida_get_new_above(&sysfs_ino_ida, 2, &ino);
+	spin_unlock(&sysfs_ino_lock);
+
+	if (rc == -EAGAIN) {
+		if (ida_pre_get(&sysfs_ino_ida, GFP_KERNEL))
+			goto retry;
+		rc = -ENOMEM;
+	}
+
+	*pino = ino;
+	return rc;
+}
+
+static void sysfs_free_ino(ino_t ino)
+{
+	spin_lock(&sysfs_ino_lock);
+	ida_remove(&sysfs_ino_ida, ino);
+	spin_unlock(&sysfs_ino_lock);
+}
+
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
@@ -23,6 +53,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		kfree(sl);
 	}
 	kfree(sd->s_iattr);
+	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 }
 
@@ -53,6 +84,11 @@ static struct sysfs_dirent * __sysfs_new_dirent(void * element)
 	if (!sd)
 		return NULL;
 
+	if (sysfs_alloc_ino(&sd->s_ino)) {
+		kmem_cache_free(sysfs_dir_cachep, sd);
+		return NULL;
+	}
+
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
@@ -521,7 +557,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = parent_sd->s_ino;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -550,10 +586,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
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
index 4de5c6b..7c1f4e8 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -140,6 +140,7 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = sd->s_ino;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 23a48a3..c1bafef 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -32,6 +32,7 @@ static struct sysfs_dirent sysfs_root = {
 	.s_children	= LIST_HEAD_INIT(sysfs_root.s_children),
 	.s_element	= NULL,
 	.s_type		= SYSFS_ROOT,
+	.s_ino		= 1,
 	.s_iattr	= NULL,
 };
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3b8aae0..1d61027 100644
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
1.5.0.3


