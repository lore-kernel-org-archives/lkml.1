Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXJLWp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXJLWp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbXJLWVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:53413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXJLWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/75] sysfs: Introduce sysfs_rename_mutex
Date: Fri, 12 Oct 2007 15:16:50 -0700
Message-Id: <11922276572176-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227653165-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Looking carefully at the rename code we have a subtle dependency
that the structure of sysfs not change while we are performing
a rename.  If the parent directory of the object we are renaming
changes while the rename is being performed nasty things could
happen when we go to release our locks.

So introduce a sysfs_rename_mutex to prevent this highly
unlikely theoretical issue.

In addition hold sysfs_rename_mutex over all calls to
sysfs_get_dentry. Allowing sysfs_get_dentry to be simplified
in the future.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    8 +++++++-
 fs/sysfs/file.c  |    4 ++++
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1af963e..9fe83d2 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,6 +15,7 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
+DEFINE_MUTEX(sysfs_rename_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
@@ -82,7 +83,7 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  *	down from there looking up dentry for each step.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep)
+ *	mutex_lock(sysfs_rename_mutex)
  *
  *	RETURNS:
  *	Pointer to found dentry on success, ERR_PTR() value on error.
@@ -858,6 +859,8 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	const char *dup_name = NULL;
 	int error;
 
+	mutex_lock(&sysfs_rename_mutex);
+
 	/* get the original dentry */
 	sd = kobj->sd;
 	old_dentry = sysfs_get_dentry(sd);
@@ -915,6 +918,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	kfree(dup_name);
 	dput(old_dentry);
 	dput(new_dentry);
+	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
@@ -926,6 +930,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	int error;
 
+	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
@@ -982,6 +987,7 @@ again:
 	dput(new_parent);
 	dput(old_dentry);
 	dput(new_dentry);
+	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 16f39c3..ff93c92 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -470,7 +470,9 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 	if (!victim_sd)
 		goto out;
 
+	mutex_lock(&sysfs_rename_mutex);
 	victim = sysfs_get_dentry(victim_sd);
+	mutex_unlock(&sysfs_rename_mutex);
 	if (IS_ERR(victim)) {
 		rc = PTR_ERR(victim);
 		victim = NULL;
@@ -509,7 +511,9 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 	if (!victim_sd)
 		goto out;
 
+	mutex_lock(&sysfs_rename_mutex);
 	victim = sysfs_get_dentry(victim_sd);
+	mutex_unlock(&sysfs_rename_mutex);
 	if (IS_ERR(victim)) {
 		rc = PTR_ERR(victim);
 		victim = NULL;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 77253aa..179e6a2 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -90,6 +90,7 @@ extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_assoc_lock;
 extern struct mutex sysfs_mutex;
+extern struct mutex sysfs_rename_mutex;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct file_operations sysfs_file_operations;
-- 
1.5.3.4

