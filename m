Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbXJLWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbXJLWrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbXJLWVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:49918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725AbXJLWV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/75] sysfs: Rewrite rename in terms of sysfs dirents
Date: Fri, 12 Oct 2007 15:16:53 -0700
Message-Id: <1192227671143-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276672660-git-send-email-gregkh@suse.de>
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
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch rewrites sysfs_rename_dir to perform it's checks
as much as possible on the underlying sysfs_dirents instead
of the contents of the dcache.  It turns out that this version
is a little simpler, and a little more like the rest of
the sysfs directory modification code.

tj: fixed double locking of sysfs_mutex

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 36b6c79..463c5e3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -770,7 +770,7 @@ void sysfs_remove_dir(struct kobject * kobj)
 
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
-	struct sysfs_dirent *sd;
+	struct sysfs_dirent *sd = kobj->sd;
 	struct dentry *parent = NULL;
 	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	const char *dup_name = NULL;
@@ -778,63 +778,57 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 
 	mutex_lock(&sysfs_rename_mutex);
 
+	error = 0;
+	if (strcmp(sd->s_name, new_name) == 0)
+		goto out;	/* nothing to rename */
+
 	/* get the original dentry */
-	sd = kobj->sd;
 	old_dentry = sysfs_get_dentry(sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
-		goto out_dput;
+		goto out;
 	}
 
 	parent = old_dentry->d_parent;
 
 	/* lock parent and get dentry for new name */
 	mutex_lock(&parent->d_inode->i_mutex);
+	mutex_lock(&sysfs_mutex);
 
-	new_dentry = lookup_one_len(new_name, parent, strlen(new_name));
-	if (IS_ERR(new_dentry)) {
-		error = PTR_ERR(new_dentry);
-		goto out_unlock;
-	}
-
-	error = -EINVAL;
-	if (old_dentry == new_dentry)
+	error = -EEXIST;
+	if (sysfs_find_dirent(sd->s_parent, new_name))
 		goto out_unlock;
 
-	error = -EEXIST;
-	if (new_dentry->d_inode)
+	error = -ENOMEM;
+	new_dentry = d_alloc_name(parent, new_name);
+	if (!new_dentry)
 		goto out_unlock;
 
 	/* rename kobject and sysfs_dirent */
 	error = -ENOMEM;
 	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
 	if (!new_name)
-		goto out_drop;
+		goto out_unlock;
 
 	error = kobject_set_name(kobj, "%s", new_name);
 	if (error)
-		goto out_drop;
+		goto out_unlock;
 
-	mutex_lock(&sysfs_mutex);
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
-	mutex_unlock(&sysfs_mutex);
 
 	/* rename */
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
 
 	error = 0;
-	goto out_unlock;
-
- out_drop:
-	d_drop(new_dentry);
  out_unlock:
+	mutex_unlock(&sysfs_mutex);
 	mutex_unlock(&parent->d_inode->i_mutex);
- out_dput:
 	kfree(dup_name);
 	dput(old_dentry);
 	dput(new_dentry);
+ out:
 	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
-- 
1.5.3.4

