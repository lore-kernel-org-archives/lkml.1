Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbXHBMiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbXHBMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXHBMiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:38:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:17297 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbXHBMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=AzOUnH5hOM6mHcMr9viIb9SlluFfEVOrhHz25Y9uvwIyM8C18WnLOHy2yqi/UoHUhumm4SDvZL5sNJ+21vuZuNrAEe6i1I0dgonCoR0XJK/dWU8den7ITVzhjnGOjUbi6IAeBy8i4T35kLganq5GWhHRObs2OTMeWBkmonqvHGk=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/5] sysfs: simplify sysfs_rename_dir()
In-Reply-To: <11860582821512-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 2 Aug 2007 21:38:02 +0900
Message-Id: <11860582821949-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the shadow directories gone, sysfs_rename_dir() can be simplified.

* parent doesn't need to be grabbed separately.  Just access
  old_dentry->d_parent.

* parent sd can never change.  Remove code to move under the new
  parent.

* Massage comments a bit.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 fs/sysfs/dir.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 026ea70..0fe6aa3 100644
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
1.5.0.3


