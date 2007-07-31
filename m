Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXGaKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXGaKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXGaKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:15:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:29714 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbXGaKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Ef5R0UZsysDUJclhrBmWtI7SMcLXaCYjfB9bCBNNyK69MB1X0i4xMUsSH+1z1f9IyKh8GAYbI2elh58XNT8t15f4eWSfoqsGdh/E9+uE+ViCMuIlVc61tzi0AMqd/axC+CTfa69DDpWZz7KRFFgAuJ1TD7t0TPdgtUY+AFJcTf8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/7] sysfs: make sysfs_add/remove_one() call link/unlink_sibling() implictly
In-Reply-To: <11858769082982-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 31 Jul 2007 19:15:08 +0900
Message-Id: <11858769082486-git-send-email-htejun@gmail.com>
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

When adding or removing a sysfs_dirent, the user used to be required
to call link/unlink separately.  It was for two reasons - code looked
like that before sysfs_addrm_cxt conversion and to avoid looping
through parent_sd->children list twice during removal.

Performance optimization during removal just isn't worth it.  Make
sysfs_add/remove_one() call sysfs_link/unlink_sibing() implicitly.
This makes code simpler albeit slightly less efficient.  This change
doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   21 ++++++++++-----------
 fs/sysfs/file.c    |    4 +---
 fs/sysfs/inode.c   |   17 ++++-------------
 fs/sysfs/symlink.c |    4 +---
 fs/sysfs/sysfs.h   |    2 --
 5 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0fe6aa3..8ce3ffb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -30,7 +30,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	Locking:
  *	mutex_lock(sysfs_mutex)
  */
-void sysfs_link_sibling(struct sysfs_dirent *sd)
+static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd = sd->s_parent;
 
@@ -49,7 +49,7 @@ void sysfs_link_sibling(struct sysfs_dirent *sd)
  *	Locking:
  *	mutex_lock(sysfs_mutex)
  */
-void sysfs_unlink_sibling(struct sysfs_dirent *sd)
+static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent **pos;
 
@@ -500,6 +500,8 @@ void sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		inc_nlink(acxt->parent_inode);
 
 	acxt->cnt++;
+
+	sysfs_link_sibling(sd);
 }
 
 /**
@@ -521,7 +523,9 @@ void sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	BUG_ON(sd->s_sibling || (sd->s_flags & SYSFS_FLAG_REMOVED));
+	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
+
+	sysfs_unlink_sibling(sd);
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
@@ -697,10 +701,8 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
 
-	if (!sysfs_find_dirent(parent_sd, name)) {
+	if (!sysfs_find_dirent(parent_sd, name))
 		sysfs_add_one(&acxt, sd);
-		sysfs_link_sibling(sd);
-	}
 
 	if (!sysfs_addrm_finish(&acxt)) {
 		sysfs_put(sd);
@@ -821,7 +823,6 @@ static void remove_dir(struct sysfs_dirent *sd)
 	struct sysfs_addrm_cxt acxt;
 
 	sysfs_addrm_start(&acxt, sd->s_parent);
-	sysfs_unlink_sibling(sd);
 	sysfs_remove_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 }
@@ -846,11 +847,9 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) && sysfs_type(sd) != SYSFS_DIR) {
-			*pos = sd->s_sibling;
-			sd->s_sibling = NULL;
+		if (sysfs_type(sd) && sysfs_type(sd) != SYSFS_DIR)
 			sysfs_remove_one(&acxt, sd);
-		} else
+		else
 			pos = &(*pos)->s_sibling;
 	}
 	sysfs_addrm_finish(&acxt);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3e1cc06..fcd065e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -405,10 +405,8 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 
 	sysfs_addrm_start(&acxt, dir_sd);
 
-	if (!sysfs_find_dirent(dir_sd, attr->name)) {
+	if (!sysfs_find_dirent(dir_sd, attr->name))
 		sysfs_add_one(&acxt, sd);
-		sysfs_link_sibling(sd);
-	}
 
 	if (!sysfs_addrm_finish(&acxt)) {
 		sysfs_put(sd);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 9671164..f05cda9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -190,25 +190,16 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos, *sd;
+	struct sysfs_dirent *sd;
 
 	if (!dir_sd)
 		return -ENOENT;
 
 	sysfs_addrm_start(&acxt, dir_sd);
 
-	for (pos = &dir_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
-		sd = *pos;
-
-		if (!sysfs_type(sd))
-			continue;
-		if (!strcmp(sd->s_name, name)) {
-			*pos = sd->s_sibling;
-			sd->s_sibling = NULL;
-			sysfs_remove_one(&acxt, sd);
-			break;
-		}
-	}
+	sd = sysfs_find_dirent(dir_sd, name);
+	if (sd)
+		sysfs_remove_one(&acxt, sd);
 
 	if (sysfs_addrm_finish(&acxt))
 		return 0;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 4ce687f..8f70ca7 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -92,10 +92,8 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	sysfs_addrm_start(&acxt, parent_sd);
 
-	if (!sysfs_find_dirent(parent_sd, name)) {
+	if (!sysfs_find_dirent(parent_sd, name))
 		sysfs_add_one(&acxt, sd);
-		sysfs_link_sibling(sd);
-	}
 
 	if (!sysfs_addrm_finish(&acxt)) {
 		error = -EEXIST;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index b55e510..32b8b64 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -56,8 +56,6 @@ extern struct sysfs_dirent sysfs_root;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
-extern void sysfs_link_sibling(struct sysfs_dirent *sd);
-extern void sysfs_unlink_sibling(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 extern void sysfs_put_active(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
-- 
1.5.0.3


