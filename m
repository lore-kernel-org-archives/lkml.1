Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXDGIXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXDGIXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXDGIXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:23:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXDGIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=OAPsuyajS377+s3ozQ4aJSZ6Aokn/4FoSKy+o7YrkW9LlzoATvs6bfVO22zfQoLJVYAfmInbyByLHao9lBnrz8PRCFG6AqY+Vo43C1vc3b1F00Na30Sis13x1h5X+89aNLXIhbtzJ2gKhAb1N3QcWzbONkG65hX4nKzdoe3kuF0=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/14] sysfs: fix i_ino handling in sysfs
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:46 +0900
Message-Id: <11759342261596-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
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

This patch makes sysfs report the pointer to sysfs_dirent as ino.
ino_t is always as big as or larger than unsigned long && sysfs_dirent
hierarchy is the internal representation of the sysfs tree, so it
makes sense and simple to implement.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   11 ++++-------
 fs/sysfs/inode.c |    1 +
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 85a6686..5112f88 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -504,19 +504,19 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->s_sibling;
-	ino_t ino;
+	unsigned long ino;
 	int i = filp->f_pos;
 
 	switch (i) {
 		case 0:
-			ino = dentry->d_inode->i_ino;
+			ino = (unsigned long)parent_sd;
 			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = parent_ino(dentry);
+			ino = (unsigned long)dentry->d_parent->d_fsdata;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -538,10 +538,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = (unsigned long)next;
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4de5c6b..b8b010c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -140,6 +140,7 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
 		inode->i_mapping->a_ops = &sysfs_aops;
 		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 		inode->i_op = &sysfs_inode_operations;
+		inode->i_ino = (unsigned long)sd;
 		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 		if (sd->s_iattr) {
-- 
1.5.0.3


