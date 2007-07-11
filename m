Return-Path: <linux-kernel-owner+w=401wt.eu-S935681AbXGKXmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681AbXGKXmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935048AbXGKXe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbXGKXe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/61] sysfs: move release_sysfs_dirent() to dir.c
Date: Wed, 11 Jul 2007 16:31:41 -0700
Message-Id: <11841968431153-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968392043-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

There is no reason this function should be inlined and soon to follow
sysfs object reference simplification will make it heavier.  Move it
to dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   12 ++++++++++++
 fs/sysfs/sysfs.h |   13 +------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c4342a0..2544aae 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,6 +15,18 @@
 DECLARE_RWSEM(sysfs_rename_sem);
 spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
 
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
index 502c949..687d959 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -18,6 +18,7 @@ extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
+extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
 				umode_t, int);
@@ -99,18 +100,6 @@ static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
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
1.5.2.2

