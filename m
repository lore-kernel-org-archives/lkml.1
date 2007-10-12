Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXJLWbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXJLWbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbXJLWT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:49697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467AbXJLWT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/75] sysfs: make sysfs_add_one() automatically check for duplicate entry
Date: Fri, 12 Oct 2007 15:16:28 -0700
Message-Id: <1192227551156-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275462233-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Make sysfs_add_one() check for duplicate entry and return -EEXIST if
such entry exists.  This simplifies node addition code a bit.

This patch doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   26 +++++++++++++++++---------
 fs/sysfs/file.c    |   12 +++++-------
 fs/sysfs/symlink.c |    9 +++------
 fs/sysfs/sysfs.h   |    2 +-
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 354675a..6206032 100644
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
index ea0e494..33bb340 100644
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
index c129f30..a6b13f1 100644
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
1.5.3.4

