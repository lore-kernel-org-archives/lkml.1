Return-Path: <linux-kernel-owner+w=401wt.eu-S965826AbXD1NoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbXD1NoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXD1Nki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbXD1Nj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=LpJr7bbUHVKnDCFFdvXbzEHAsp3rXwC5Oho4KSYraU8unsM+rLFoFSHCvDzRioA0YpYkbct2aEGLL1VS9VPoxQY4YGnaSBMVZ09OJaCU+PlJjPC85A6tY2h431GKTq8dJMsNqO/wFY8I6QmMjrVchnAmbvVtNpQzKBlnsD/b5Gw=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/21] sysfs: flatten and fix sysfs_rename_dir() error handling
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:41 +0900
Message-Id: <11777675813047-git-send-email-htejun@gmail.com>
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

Error handling in sysfs_rename_dir() was broken.

* When lookup_one_len() fails, 0 is returned.

* If parent inode check fails, returns with inode mutex and rename
  rwsem held.

This patch fixes the above bugs and flattens error handling such that
it's more readable and easier to modify.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   73 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0dca2c4..df057da 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -434,8 +434,9 @@ void sysfs_remove_dir(struct kobject * kobj)
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 		     const char *new_name)
 {
-	int error = 0;
+	int error;
 	struct dentry * new_dentry;
+	struct sysfs_dirent *sd, *parent_sd;
 
 	if (!new_parent)
 		return -EFAULT;
@@ -444,40 +445,48 @@ int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
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
1.5.0.3


