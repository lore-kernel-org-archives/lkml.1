Return-Path: <linux-kernel-owner+w=401wt.eu-S967431AbXHGVxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967431AbXHGVxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966051AbXHGVaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:30:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50028 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966237AbXHGVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:30:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 19/25] sysfs: sysfs_get_dentry add a sb parameter
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
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:29:23 -0600
In-Reply-To: <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:28:10 -0600")
Message-ID: <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In preparation for multiple mounts of sysfs add a superblock parameter to
sysfs_get_dentry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |   12 +++++++-----
 fs/sysfs/file.c  |    4 ++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 94d705a..ac45523 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -805,6 +805,7 @@ out:
 
 /**
  *	sysfs_get_dentry - get dentry for the given sysfs_dirent
+ *	@sb: superblock of the dentry to return
  *	@sd: sysfs_dirent of interest
  *
  *	Get dentry for @sd.  Dentry is looked up if currently not
@@ -817,8 +818,9 @@ out:
  *
  *	RETURNS:
  *	Pointer to found dentry on success, ERR_PTR() value on error.
+ *	NULL if the sysfs dentry does not appear in the specified superblock
  */
-struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
+struct dentry *sysfs_get_dentry(struct super_block *sb, struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *cur;
 	struct dentry *parent_dentry, *dentry;
@@ -827,7 +829,7 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 	 */
 	dentry = NULL;
 	cur = sd;
-	while (!(dentry = __sysfs_get_dentry(sysfs_sb, cur))) {
+	while (!(dentry = __sysfs_get_dentry(sb, cur))) {
 		if (cur->s_flags & SYSFS_FLAG_REMOVED) {
 			dentry = ERR_PTR(-ENOENT);
 			break;
@@ -868,7 +870,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 		goto out;	/* nothing to rename */
 
 	/* get the original dentry */
-	old_dentry = sysfs_get_dentry(sd);
+	old_dentry = sysfs_get_dentry(sysfs_sb, sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
 		goto out;
@@ -937,14 +939,14 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 		goto out;	/* nothing to move */
 
 	/* get dentries */
-	old_dentry = sysfs_get_dentry(sd);
+	old_dentry = sysfs_get_dentry(sysfs_sb, sd);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
 		goto out;
 	}
 	old_parent = old_dentry->d_parent;
 
-	new_parent = sysfs_get_dentry(new_parent_sd);
+	new_parent = sysfs_get_dentry(sysfs_sb, new_parent_sd);
 	if (IS_ERR(new_parent)) {
 		error = PTR_ERR(new_parent);
 		goto out;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fe783ea..f954b9f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -471,7 +471,7 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 		goto out;
 
 	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
+	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
 	mutex_unlock(&sysfs_rename_mutex);
 	if (IS_ERR(victim)) {
 		rc = PTR_ERR(victim);
@@ -512,7 +512,7 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 		goto out;
 
 	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
+	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
 	mutex_unlock(&sysfs_rename_mutex);
 	if (IS_ERR(victim)) {
 		rc = PTR_ERR(victim);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 8156ccb..6de7e2b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -63,7 +63,7 @@ extern struct file_system_type sysfs_fs_type;
 void sysfs_grab_supers(void);
 void sysfs_release_supers(void);
 
-extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
+extern struct dentry *sysfs_get_dentry(struct super_block *sb, struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 extern void sysfs_put_active(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
-- 
1.5.1.1.181.g2de0

