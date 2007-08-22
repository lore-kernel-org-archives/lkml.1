Return-Path: <linux-kernel-owner+w=401wt.eu-S934621AbXHVWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbXHVWVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934433AbXHVWVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:21:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934574AbXHVWVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:21:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] sysfs: fix locking in sysfs_lookup() and sysfs_rename_dir()
Date: Wed, 22 Aug 2007 15:10:16 -0700
Message-Id: <1187820620110-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <20070822220747.GA30603@kroah.com>
References: <20070822220747.GA30603@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sd children list walking in sysfs_lookup() and sd renaming in
sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
conversion.  Fix them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 048e605..83e76b3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -762,12 +762,15 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
+	struct dentry *ret = NULL;
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent * sd;
 	struct bin_attribute *bin_attr;
 	struct inode *inode;
 	int found = 0;
 
+	mutex_lock(&sysfs_mutex);
+
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
 		if (sysfs_type(sd) &&
 		    !strcmp(sd->s_name, dentry->d_name.name)) {
@@ -778,14 +781,14 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	/* no such entry */
 	if (!found)
-		return NULL;
+		goto out_unlock;
 
 	/* attach dentry and inode */
 	inode = sysfs_get_inode(sd);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_lock(&sysfs_mutex);
+	if (!inode) {
+		ret = ERR_PTR(-ENOMEM);
+		goto out_unlock;
+	}
 
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
@@ -815,9 +818,9 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
+ out_unlock:
 	mutex_unlock(&sysfs_mutex);
-
-	return NULL;
+	return ret;
 }
 
 const struct inode_operations sysfs_dir_inode_operations = {
@@ -942,6 +945,8 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	if (error)
 		goto out_drop;
 
+	mutex_lock(&sysfs_mutex);
+
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
@@ -949,8 +954,6 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	d_add(new_dentry, NULL);
 	d_move(sd->s_dentry, new_dentry);
 
-	mutex_lock(&sysfs_mutex);
-
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
-- 
1.5.3.rc5

