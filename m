Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbXJLWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbXJLWlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbXJLWUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbXJLWUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/75] sysfs: Move all of inode initialization into sysfs_init_inode
Date: Fri, 12 Oct 2007 15:16:43 -0700
Message-Id: <11922276254051-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276201219-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   37 -------------------------------------
 fs/sysfs/inode.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/sysfs/mount.c |    5 -----
 3 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 54ca4bc..5a70a93 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -748,24 +748,12 @@ int sysfs_create_dir(struct kobject * kobj)
 	return error;
 }
 
-static int sysfs_count_nlink(struct sysfs_dirent *sd)
-{
-	struct sysfs_dirent *child;
-	int nr = 0;
-
-	for (child = sd->s_children; child; child = child->s_sibling)
-		if (sysfs_type(child) == SYSFS_DIR)
-			nr++;
-	return nr + 2;
-}
-
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
 	struct dentry *ret = NULL;
 	struct sysfs_dirent *parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent *sd;
-	struct bin_attribute *bin_attr;
 	struct inode *inode;
 
 	mutex_lock(&sysfs_mutex);
@@ -785,31 +773,6 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	if (inode->i_state & I_NEW) {
-		/* initialize inode according to type */
-		switch (sysfs_type(sd)) {
-		case SYSFS_DIR:
-			inode->i_op = &sysfs_dir_inode_operations;
-			inode->i_fop = &sysfs_dir_operations;
-			inode->i_nlink = sysfs_count_nlink(sd);
-			break;
-		case SYSFS_KOBJ_ATTR:
-			inode->i_size = PAGE_SIZE;
-			inode->i_fop = &sysfs_file_operations;
-			break;
-		case SYSFS_KOBJ_BIN_ATTR:
-			bin_attr = sd->s_elem.bin_attr.bin_attr;
-			inode->i_size = bin_attr->size;
-			inode->i_fop = &bin_fops;
-			break;
-		case SYSFS_KOBJ_LINK:
-			inode->i_op = &sysfs_symlink_inode_operations;
-			break;
-		default:
-			BUG();
-		}
-	}
-
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e22db6c..200e1bf 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -122,8 +122,22 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
  */
 static struct lock_class_key sysfs_inode_imutex_key;
 
+static int sysfs_count_nlink(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *child;
+	int nr = 0;
+
+	for (child = sd->s_children; child; child = child->s_sibling)
+		if (sysfs_type(child) == SYSFS_DIR)
+			nr++;
+
+	return nr + 2;
+}
+
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
+	struct bin_attribute *bin_attr;
+
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
@@ -139,6 +153,37 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		set_inode_attr(inode, sd->s_iattr);
 	} else
 		set_default_inode_attr(inode, sd->s_mode);
+
+
+	/* initialize inode according to type */
+	switch (sysfs_type(sd)) {
+	case SYSFS_ROOT:
+		inode->i_op = &sysfs_dir_inode_operations;
+		inode->i_fop = &sysfs_dir_operations;
+		inc_nlink(inode); /* directory, account for "." */
+		break;
+	case SYSFS_DIR:
+		inode->i_op = &sysfs_dir_inode_operations;
+		inode->i_fop = &sysfs_dir_operations;
+		inode->i_nlink = sysfs_count_nlink(sd);
+		break;
+	case SYSFS_KOBJ_ATTR:
+		inode->i_size = PAGE_SIZE;
+		inode->i_fop = &sysfs_file_operations;
+		break;
+	case SYSFS_KOBJ_BIN_ATTR:
+		bin_attr = sd->s_elem.bin_attr.bin_attr;
+		inode->i_size = bin_attr->size;
+		inode->i_fop = &bin_fops;
+		break;
+	case SYSFS_KOBJ_LINK:
+		inode->i_op = &sysfs_symlink_inode_operations;
+		break;
+	default:
+		BUG();
+	}
+
+	unlock_new_inode(inode);
 }
 
 /**
@@ -180,9 +225,6 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	BUG_ON(!dentry || dentry->d_inode);
 
-	if (inode->i_state & I_NEW)
-		unlock_new_inode(inode);
-
 	d_instantiate(dentry, inode);
 }
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 119f39d..92f407f 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -49,11 +49,6 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 	}
 
-	inode->i_op = &sysfs_dir_inode_operations;
-	inode->i_fop = &sysfs_dir_operations;
-	inc_nlink(inode); /* directory, account for "." */
-	unlock_new_inode(inode);
-
 	/* instantiate and link root dentry */
 	root = d_alloc_root(inode);
 	if (!root) {
-- 
1.5.3.4

