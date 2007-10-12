Return-Path: <linux-kernel-owner+w=401wt.eu-S933487AbXJLWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbXJLWbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932466AbXJLWTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:53237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXJLWTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/75] sysfs: make sysfs_add/remove_one() call link/unlink_sibling() implictly
Date: Fri, 12 Oct 2007 15:16:27 -0700
Message-Id: <11922275462233-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275413548-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

When adding or removing a sysfs_dirent, the user used to be required
to call link/unlink separately.  It was for two reasons - code looked
like that before sysfs_addrm_cxt conversion and to avoid looping
through parent_sd->children list twice during removal.

Performance optimization during removal just isn't worth it.  Make
sysfs_add/remove_one() call sysfs_link/unlink_sibing() implicitly.
This makes code simpler albeit slightly less efficient.  This change
doesn't introduce any noticeable behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   21 ++++++++++-----------
 fs/sysfs/file.c    |    4 +---
 fs/sysfs/inode.c   |   17 ++++-------------
 fs/sysfs/symlink.c |    4 +---
 fs/sysfs/sysfs.h   |    2 --
 5 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 9504d4c..354675a 100644
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
index b21d11b..ea0e494 100644
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
index 45128b7..efb4062 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -189,25 +189,16 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
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
index 9048453..c129f30 100644
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
1.5.3.4

