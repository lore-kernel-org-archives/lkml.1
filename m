Return-Path: <linux-kernel-owner+w=401wt.eu-S937076AbXHGV7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937076AbXHGV7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937517AbXHGVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:35:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56938 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937601AbXHGVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:35:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 22/25] sysfs: sysfs_uptdate_file handle multiple superblocks
References: <11860582832964-git-send-email-htejun@gmail.com>
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
	<m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mfghg9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx3ghdt.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:34:11 -0600
In-Reply-To: <m1myx3ghdt.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:32:46 -0600")
Message-ID: <m1ir7rghbg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Teach sysfs_update_file how to handle multiple sysfs
superblocks.  Again we are just iterating over the superblocks
to so all of the filesystem modification notifications work
as expected.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/file.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cff054f..1e6f9df 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -462,7 +462,8 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
 int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 {
 	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
+	struct super_block *sb;
+	struct dentry *victim;
 	int rc;
 
 	rc = -ENOENT;
@@ -471,21 +472,27 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 		goto out;
 
 	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
+	sysfs_grab_supers();
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		victim = sysfs_get_dentry(sb, victim_sd);
+		if (!victim)
+			continue;
+		if (IS_ERR(victim)) {
+			rc = PTR_ERR(victim);
+			victim = NULL;
+			goto out_unlock;
+		}
+		mutex_lock(&victim->d_inode->i_mutex);
+		victim->d_inode->i_mtime = CURRENT_TIME;
+		fsnotify_modify(victim);
+		mutex_unlock(&victim->d_inode->i_mutex);
+		rc = 0;
+		dput(victim);
 	}
-
-	mutex_lock(&victim->d_inode->i_mutex);
-	victim->d_inode->i_mtime = CURRENT_TIME;
-	fsnotify_modify(victim);
-	mutex_unlock(&victim->d_inode->i_mutex);
-	rc = 0;
+ out_unlock:
+	sysfs_release_supers();
+	mutex_unlock(&sysfs_rename_mutex);
  out:
-	dput(victim);
 	sysfs_put(victim_sd);
 	return rc;
 }
-- 
1.5.1.1.181.g2de0

