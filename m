Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXDGI2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXDGI2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXDGIYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:60687 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525AbXDGIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=sYCuNcHIfBATaFcMqg7RKapTL9NeXlDZJZQNjdFaev6aj/y5czgBZ6GbC1UhGM2H64pDZEXB6CSq28e4WIapWWeG5FsmVDfm3AUJjB87Aq90msWhu/wTusvy7UnEarJ0XJK2cswP/7y9xItIPRetlyrUc0J3cbQf6+G5OqTik5Q=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 03/14] sysfs: move sysfs_get_kobject() and release_sysfs_dirent() to dir.c
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:46 +0900
Message-Id: <11759342263487-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason these functions should be inlined and soon to
follow sysfs object reference simplification will make these functions
heavier.  Move them to dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   30 ++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h |   32 ++------------------------------
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5112f88..8b1a00a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,6 +14,36 @@
 
 DECLARE_RWSEM(sysfs_rename_sem);
 
+struct kobject *sysfs_get_kobject(struct dentry *dentry)
+{
+	struct kobject * kobj = NULL;
+
+	spin_lock(&dcache_lock);
+	if (!d_unhashed(dentry)) {
+		struct sysfs_dirent * sd = dentry->d_fsdata;
+		if (sd->s_type & SYSFS_KOBJ_LINK) {
+			struct sysfs_symlink * sl = sd->s_element;
+			kobj = kobject_get(sl->target_kobj);
+		} else
+			kobj = kobject_get(sd->s_element);
+	}
+	spin_unlock(&dcache_lock);
+
+	return kobj;
+}
+
+void release_sysfs_dirent(struct sysfs_dirent * sd)
+{
+	if (sd->s_type & SYSFS_KOBJ_LINK) {
+		struct sysfs_symlink * sl = sd->s_element;
+		kfree(sl->link_name);
+		kobject_put(sl->target_kobj);
+		kfree(sl);
+	}
+	kfree(sd->s_iattr);
+	kmem_cache_free(sysfs_dir_cachep, sd);
+}
+
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a77c57e..812c8c3 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,6 +17,8 @@ extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
+extern struct kobject *sysfs_get_kobject(struct dentry *dentry);
+extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
 				umode_t, int);
@@ -79,36 +81,6 @@ static inline struct bin_attribute * to_bin_attr(struct dentry * dentry)
 	return ((struct bin_attribute *) sd->s_element);
 }
 
-static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
-{
-	struct kobject * kobj = NULL;
-
-	spin_lock(&dcache_lock);
-	if (!d_unhashed(dentry)) {
-		struct sysfs_dirent * sd = dentry->d_fsdata;
-		if (sd->s_type & SYSFS_KOBJ_LINK) {
-			struct sysfs_symlink * sl = sd->s_element;
-			kobj = kobject_get(sl->target_kobj);
-		} else
-			kobj = kobject_get(sd->s_element);
-	}
-	spin_unlock(&dcache_lock);
-
-	return kobj;
-}
-
-static inline void release_sysfs_dirent(struct sysfs_dirent * sd)
-{
-	if (sd->s_type & SYSFS_KOBJ_LINK) {
-		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
-		kobject_put(sl->target_kobj);
-		kfree(sl);
-	}
-	kfree(sd->s_iattr);
-	kmem_cache_free(sysfs_dir_cachep, sd);
-}
-
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
-- 
1.5.0.3


