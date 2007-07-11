Return-Path: <linux-kernel-owner+w=401wt.eu-S935857AbXGKXo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935857AbXGKXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935167AbXGKXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:33305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935160AbXGKXes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/61] sysfs: flatten and fix sysfs_rename_dir() error handling
Date: Wed, 11 Jul 2007 16:31:46 -0700
Message-Id: <11841968643630-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196860992-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Error handling in sysfs_rename_dir() was broken.

* When lookup_one_len() fails, 0 is returned.

* If parent inode check fails, returns with inode mutex and rename
  rwsem held.

This patch fixes the above bugs and flattens error handling such that
it's more readable and easier to modify.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b4c4824..90bed5d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -452,8 +452,9 @@ void sysfs_remove_dir(struct kobject * kobj)
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 		     const char *new_name)
 {
-	int error = 0;
+	int error;
 	struct dentry * new_dentry;
+	struct sysfs_dirent *sd, *parent_sd;
 
 	if (!new_parent)
 		return -EFAULT;
@@ -462,40 +463,48 @@ int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 	mutex_lock(&new_parent->d_inode->i_mutex);
 
 	new_dentry = lookup_one_len(new_name, new_parent, strlen(new_name));
-	if (!IS_ERR(new_dentry)) {
-		/* By allowing two different directories with the
-		 * same d_parent we allow this routine to move
-		 * between different shadows of the same directory
-		 */
-		if (kobj->dentry->d_parent->d_inode != new_parent->d_inode)
-			return -EINVAL;
-		else if (new_dentry->d_parent->d_inode != new_parent->d_inode)
-			error = -EINVAL;
-		else if (new_dentry == kobj->dentry)
-			error = -EINVAL;
-		else if (!new_dentry->d_inode) {
-			error = kobject_set_name(kobj, "%s", new_name);
-			if (!error) {
-				struct sysfs_dirent *sd, *parent_sd;
-
-				d_add(new_dentry, NULL);
-				d_move(kobj->dentry, new_dentry);
-
-				sd = kobj->dentry->d_fsdata;
-				parent_sd = new_parent->d_fsdata;
-
-				list_del_init(&sd->s_sibling);
-				list_add(&sd->s_sibling, &parent_sd->s_children);
-			}
-			else
-				d_drop(new_dentry);
-		} else
-			error = -EEXIST;
-		dput(new_dentry);
+	if (IS_ERR(new_dentry)) {
+		error = PTR_ERR(new_dentry);
+		goto out_unlock;
 	}
+
+	/* By allowing two different directories with the same
+	 * d_parent we allow this routine to move between different
+	 * shadows of the same directory
+	 */
+	error = -EINVAL;
+	if (kobj->dentry->d_parent->d_inode != new_parent->d_inode ||
+	    new_dentry->d_parent->d_inode != new_parent->d_inode ||
+	    new_dentry == kobj->dentry)
+		goto out_dput;
+
+	error = -EEXIST;
+	if (new_dentry->d_inode)
+		goto out_dput;
+
+	error = kobject_set_name(kobj, "%s", new_name);
+	if (error)
+		goto out_drop;
+
+	d_add(new_dentry, NULL);
+	d_move(kobj->dentry, new_dentry);
+
+	sd = kobj->dentry->d_fsdata;
+	parent_sd = new_parent->d_fsdata;
+
+	list_del_init(&sd->s_sibling);
+	list_add(&sd->s_sibling, &parent_sd->s_children);
+
+	error = 0;
+	goto out_unlock;
+
+ out_drop:
+	d_drop(new_dentry);
+ out_dput:
+	dput(new_dentry);
+ out_unlock:
 	mutex_unlock(&new_parent->d_inode->i_mutex);
 	up_write(&sysfs_rename_sem);
-
 	return error;
 }
 
-- 
1.5.2.2

