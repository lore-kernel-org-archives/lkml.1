Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXITIH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXITIH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXITIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42005 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbXITIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=PgMGOvlq5DjRlB7/nrt78JIrD7ecK5d8ql06lAfqWAs3oZ/cURIUlgsydycub2QoUMKTXbd0k6+CQZ6po73FxcefnuWD9J2h5AcEDg771fzipyYlH1sF+Y1HkR0G3pa3T9qTbkd8ZHJKTBwgpFheBcvXXtfYWG3uJhsLMUtBhbA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/22] sysfs: make sysfs_root a pointer
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755393172-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the upcoming new sysfs interface, sysfs_root will be exported.  To
ease usage and make dummy declaration easier, make sysfs_root a
pointer.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |    4 ++--
 fs/sysfs/mount.c   |    8 +++++---
 fs/sysfs/symlink.c |    2 +-
 fs/sysfs/sysfs.h   |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index fe8270c..ba631eb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -651,7 +651,7 @@ int sysfs_create_dir(struct kobject * kobj)
 	if (kobj->parent)
 		parent_sd = kobj->parent->sd;
 	else
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root;
 
 	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
 	if (!error)
@@ -832,7 +832,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 
 	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
+	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : sysfs_root;
 
 	error = 0;
 	if (sd->s_parent == new_parent_sd)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 465902c..d00d4b9 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -23,7 +23,7 @@ static const struct super_operations sysfs_ops = {
 	.drop_inode	= generic_delete_inode,
 };
 
-struct sysfs_dirent sysfs_root = {
+static struct sysfs_dirent sysfs_root_storage = {
 	.s_name		= "",
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_DIR,
@@ -31,6 +31,8 @@ struct sysfs_dirent sysfs_root = {
 	.s_ino		= 1,
 };
 
+struct sysfs_dirent * const sysfs_root = &sysfs_root_storage;
+
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
@@ -44,7 +46,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sysfs_sb = sb;
 
 	/* get root inode, initialize and unlock it */
-	inode = sysfs_get_inode(&sysfs_root);
+	inode = sysfs_get_inode(sysfs_root);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
@@ -57,7 +59,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 		iput(inode);
 		return -ENOMEM;
 	}
-	root->d_fsdata = &sysfs_root;
+	root->d_fsdata = sysfs_root;
 	sb->s_root = root;
 	return 0;
 }
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index ffa82e9..6b3358e 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -61,7 +61,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	BUG_ON(!name);
 
 	if (!kobj)
-		parent_sd = &sysfs_root;
+		parent_sd = sysfs_root;
 	else
 		parent_sd = kobj->sd;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 58f517b..9180e2c 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -78,7 +78,7 @@ struct sysfs_addrm_cxt {
 /*
  * mount.c
  */
-extern struct sysfs_dirent sysfs_root;
+extern struct sysfs_dirent * const sysfs_root;
 extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 
-- 
1.5.0.3


