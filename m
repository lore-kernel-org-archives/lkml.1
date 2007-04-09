Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXDIESy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXDIESy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDIESy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:18:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:51502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXDIESx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=fwx1oC6+u4UGyRYJbMZhL/MvJXBL5kHA2wIMrnKdbYLjfeghjE6GdWhB8zjehn+Hu6mf9HmWLt/wHExryvXqdtbROTa6cjrUyq1E2VUoTuanD/fkGFG87j2XVwgDsG/Cn6IarryuLElNtu1lkUwmN846ZjP9Ce+1kCMuGZhWvM8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 03/14] sysfs: move release_sysfs_dirent() to dir.c
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 9 Apr 2007 13:18:47 +0900
Message-Id: <11760923271435-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason this function should be inlined and soon to follow
sysfs object reference simplification will make it heavier.  Move it
to dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   12 ++++++++++++
 fs/sysfs/sysfs.h |   13 +------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5112f88..2d630bf 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,6 +14,18 @@
 
 DECLARE_RWSEM(sysfs_rename_sem);
 
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
index a77c57e..3b8aae0 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,6 +17,7 @@ extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
+extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
 				umode_t, int);
@@ -97,18 +98,6 @@ static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
 	return kobj;
 }
 
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


