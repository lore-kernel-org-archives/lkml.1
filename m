Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYFRRK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYFRRK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbYFRRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:09:33 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60161 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbYFRRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:09:31 -0400
Message-Id: <20080618170730.853353875@theryb.frec.bull.fr>
References: <20080618170729.808539948@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Wed, 18 Jun 2008 19:08:19 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 05/11] sysfs: sysfs_chmod_file handle multiple superblocks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs: sysfs_chmod_file handle multiple superblocks

Teach sysfs_chmod_file how to handle multiple sysfs
superblocks.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 fs/sysfs/file.c |   54 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

Index: linux-mm/fs/sysfs/file.c
===================================================================
--- linux-mm.orig/fs/sysfs/file.c
+++ linux-mm/fs/sysfs/file.c
@@ -573,7 +573,8 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_grou
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
 	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
+	struct super_block *sb;
+	struct dentry *victim;
 	struct inode * inode;
 	struct iattr newattrs;
 	int rc;
@@ -584,31 +585,36 @@ int sysfs_chmod_file(struct kobject *kob
 		goto out;
 
 	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(sysfs_sb, victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
-	}
-
-	inode = victim->d_inode;
+	sysfs_grab_supers();
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		victim = sysfs_get_dentry(sb, victim_sd);
+		if (victim == ERR_PTR(-EXDEV))
+			continue;
+		if (IS_ERR(victim)) {
+			rc = PTR_ERR(victim);
+			victim = NULL;
+			goto out_unlock;
+		}
+
+		inode = victim->d_inode;
+		mutex_lock(&inode->i_mutex);
+		newattrs.ia_mode = (mode & S_IALLUGO) |
+				   (inode->i_mode & ~S_IALLUGO);
+		newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+		rc = notify_change(victim, &newattrs);
+		if (rc == 0) {
+			mutex_lock(&sysfs_mutex);
+			victim_sd->s_mode = newattrs.ia_mode;
+			mutex_unlock(&sysfs_mutex);
+		}
+		mutex_unlock(&inode->i_mutex);
 
-	mutex_lock(&inode->i_mutex);
-
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(victim, &newattrs);
-
-	if (rc == 0) {
-		mutex_lock(&sysfs_mutex);
-		victim_sd->s_mode = newattrs.ia_mode;
-		mutex_unlock(&sysfs_mutex);
+		dput(victim);
 	}
-
-	mutex_unlock(&inode->i_mutex);
- out:
-	dput(victim);
+out_unlock:
+	sysfs_release_supers();
+	mutex_unlock(&sysfs_rename_mutex);
+out:
 	sysfs_put(victim_sd);
 	return rc;
 }

-- 
