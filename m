Return-Path: <linux-kernel-owner+w=401wt.eu-S933431AbXJLWaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbXJLWaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXJLWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:49682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429AbXJLWTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/75] sysfs: simplify sysfs_rename_dir()
Date: Fri, 12 Oct 2007 15:16:26 -0700
Message-Id: <11922275413548-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275371856-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

With the shadow directories gone, sysfs_rename_dir() can be simplified.

* parent doesn't need to be grabbed separately.  Just access
  old_dentry->d_parent.

* parent sd can never change.  Remove code to move under the new
  parent.

* Massage comments a bit.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5da8da8..9504d4c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -883,14 +883,10 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	struct sysfs_dirent *sd;
 	struct dentry *parent = NULL;
 	struct dentry *old_dentry = NULL, *new_dentry = NULL;
-	struct sysfs_dirent *parent_sd;
 	const char *dup_name = NULL;
 	int error;
 
-	if (!kobj->parent)
-		return -EINVAL;
-
-	/* get dentries */
+	/* get the original dentry */
 	sd = kobj->sd;
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
@@ -898,12 +894,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 		goto out_dput;
 	}
 
-	parent_sd = kobj->parent->sd;
-	parent = sysfs_get_dentry(parent_sd);
-	if (IS_ERR(parent)) {
-		error = PTR_ERR(parent);
-		goto out_dput;
-	}
+	parent = old_dentry->d_parent;
 
 	/* lock parent and get dentry for new name */
 	mutex_lock(&parent->d_inode->i_mutex);
@@ -933,22 +924,14 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 		goto out_drop;
 
 	mutex_lock(&sysfs_mutex);
-
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
+	mutex_unlock(&sysfs_mutex);
 
-	/* move under the new parent */
+	/* rename */
 	d_add(new_dentry, NULL);
 	d_move(sd->s_dentry, new_dentry);
 
-	sysfs_unlink_sibling(sd);
-	sysfs_get(parent_sd);
-	sysfs_put(sd->s_parent);
-	sd->s_parent = parent_sd;
-	sysfs_link_sibling(sd);
-
-	mutex_unlock(&sysfs_mutex);
-
 	error = 0;
 	goto out_unlock;
 
@@ -958,7 +941,6 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	mutex_unlock(&parent->d_inode->i_mutex);
  out_dput:
 	kfree(dup_name);
-	dput(parent);
 	dput(old_dentry);
 	dput(new_dentry);
 	return error;
-- 
1.5.3.4

