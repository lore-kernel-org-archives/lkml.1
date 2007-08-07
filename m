Return-Path: <linux-kernel-owner+w=401wt.eu-S965970AbXHGVsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965970AbXHGVsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966141AbXHGV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:27:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33201 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966134AbXHGV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:27:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 12/25] sysfs: Introduce sysfs_rename_mutex
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:21:06 -0600
In-Reply-To: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:19:31 -0600")
Message-ID: <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 fs/sysfs/dir.c   |    8 +++++++-
 fs/sysfs/file.c  |    4 ++++
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1078e60..e0f49b7 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,6 +15,7 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
+DEFINE_MUTEX(sysfs_rename_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
@@ -774,7 +775,7 @@ static struct dentry *__sysfs_get_dentry(struct super_block *sb, struct sysfs_di
  *	down from there looking up dentry for each step.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep)
+ *	mutex_lock(sysfs_rename_mutex)
  *
  *	RETURNS:
  *	Pointer to found dentry on success, ERR_PTR() value on error.
@@ -859,6 +860,8 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	const char *dup_name = NULL;
 	int error;
 
+	mutex_lock(&sysfs_rename_mutex);
+
 	/* get the original dentry */
 	sd = kobj->sd;
 	old_dentry = sysfs_get_dentry(sd);
@@ -916,6 +919,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	kfree(dup_name);
 	dput(old_dentry);
 	dput(new_dentry);
+	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
@@ -927,6 +931,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	int error;
 
+	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
@@ -983,6 +988,7 @@ again:
 	dput(new_parent);
 	dput(old_dentry);
 	dput(new_dentry);
+	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 416351a..fe783ea 100644
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
index 8ed13cf..791b3ed 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -89,6 +89,7 @@ extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_assoc_lock;
 extern struct mutex sysfs_mutex;
+extern struct mutex sysfs_rename_mutex;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct file_operations sysfs_file_operations;
-- 
1.5.1.1.181.g2de0

