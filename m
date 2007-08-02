Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXHBMj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXHBMj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXHBMiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:38:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:17401 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbXHBMiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=B4TK+zK5LP5h/meMpBCjtW7LKCQmO+Mr4YP6D109t3yDI6LUG/J/kS/dkuCLsvYwehjQjRcebcaxMAXF30iSg5kCO5Oc0zMouvGwKqDpkoZqqpeWkKX2vN5GiTcxyYqh1DHG8D57hjfvNZ4wflgok/Lgo4OO5PVEZdCW9p4NiKg=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/5] sysfs: make sysfs_add_one() automatically check for duplicate entry
In-Reply-To: <11860582821512-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 2 Aug 2007 21:38:03 +0900
Message-Id: <11860582831609-git-send-email-htejun@gmail.com>
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

Make sysfs_add_one() check for duplicate entry and return -EEXIST if
such entry exists.  This simplifies node addition code a bit.

This patch doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 fs/sysfs/dir.c     |   26 +++++++++++++++++---------
 fs/sysfs/file.c    |   12 +++++-------
 fs/sysfs/symlink.c |    9 +++------
 fs/sysfs/sysfs.h   |    2 +-
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8ce3ffb..91934e1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -491,9 +491,16 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *
  *	LOCKING:
  *	Determined by sysfs_addrm_start().
+ *
+ *	RETURNS:
+ *	0 on success, -EEXIST if entry with the given name already
+ *	exists.
  */
-void sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
+		return -EEXIST;
+
 	sd->s_parent = sysfs_get(acxt->parent_sd);
 
 	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
@@ -502,6 +509,8 @@ void sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	acxt->cnt++;
 
 	sysfs_link_sibling(sd);
+
+	return 0;
 }
 
 /**
@@ -691,6 +700,7 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
+	int rc;
 
 	/* allocate */
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
@@ -700,17 +710,15 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
+	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_finish(&acxt);
 
-	if (!sysfs_find_dirent(parent_sd, name))
-		sysfs_add_one(&acxt, sd);
-
-	if (!sysfs_addrm_finish(&acxt)) {
+	if (rc == 0)
+		*p_sd = sd;
+	else
 		sysfs_put(sd);
-		return -EEXIST;
-	}
 
-	*p_sd = sd;
-	return 0;
+	return rc;
 }
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fcd065e..416351a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -397,6 +397,7 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
+	int rc;
 
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
@@ -404,16 +405,13 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	sd->s_elem.attr.attr = (void *)attr;
 
 	sysfs_addrm_start(&acxt, dir_sd);
+	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_finish(&acxt);
 
-	if (!sysfs_find_dirent(dir_sd, attr->name))
-		sysfs_add_one(&acxt, sd);
-
-	if (!sysfs_addrm_finish(&acxt)) {
+	if (rc)
 		sysfs_put(sd);
-		return -EEXIST;
-	}
 
-	return 0;
+	return rc;
 }
 
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 8f70ca7..f77ad61 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -91,14 +91,11 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
+	error = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_finish(&acxt);
 
-	if (!sysfs_find_dirent(parent_sd, name))
-		sysfs_add_one(&acxt, sd);
-
-	if (!sysfs_addrm_finish(&acxt)) {
-		error = -EEXIST;
+	if (error)
 		goto out_put;
-	}
 
 	return 0;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 32b8b64..bb3f0c9 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -62,7 +62,7 @@ extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 extern void sysfs_put_active_two(struct sysfs_dirent *sd);
 extern void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 			      struct sysfs_dirent *parent_sd);
-extern void sysfs_add_one(struct sysfs_addrm_cxt *acxt,
+extern int sysfs_add_one(struct sysfs_addrm_cxt *acxt,
 			  struct sysfs_dirent *sd);
 extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
 			     struct sysfs_dirent *sd);
-- 
1.5.0.3


