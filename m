Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZLKWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZLKWdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZLKWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:32:49 -0500
Received: from kroah.org ([198.145.64.141]:32829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762744AbZLKWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/27] sysfs: In sysfs_chmod_file lazily propagate the mode change.
Date: Fri, 11 Dec 2009 14:24:43 -0800
Message-Id: <1260570289-6997-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sysfs_getattr and sysfs_permission refresh the vfs
inode there is no need to immediatly push the mode change
into the vfs cache.  Reducing the amount of work needed and
simplifying the locking.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index faa1a80..dc30d9e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -579,38 +579,23 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
  */
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
-	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	struct inode * inode;
+	struct sysfs_dirent *sd;
 	struct iattr newattrs;
 	int rc;
 
-	rc = -ENOENT;
-	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
-	if (!victim_sd)
-		goto out;
+	mutex_lock(&sysfs_mutex);
 
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
+	rc = -ENOENT;
+	sd = sysfs_find_dirent(kobj->sd, attr->name);
+	if (!sd)
 		goto out;
-	}
-
-	inode = victim->d_inode;
 
-	mutex_lock(&inode->i_mutex);
-
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE;
-	rc = sysfs_setattr(victim, &newattrs);
+	rc = sysfs_sd_setattr(sd, &newattrs);
 
-	mutex_unlock(&inode->i_mutex);
  out:
-	dput(victim);
-	sysfs_put(victim_sd);
+	mutex_unlock(&sysfs_mutex);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
-- 
1.6.5.5

