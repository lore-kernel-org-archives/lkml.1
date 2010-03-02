Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0CBX3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:52 -0500
Received: from kroah.org ([198.145.64.141]:38700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0CBX3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/62] sysfs: Pass super_block to sysfs_get_inode
Date: Tue,  2 Mar 2010 15:28:52 -0800
Message-Id: <1267572541-410-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs_get_inode magically returns an inode on
sysfs_sb.  Make the super_block parameter explicit and
the code becomes clearer.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |    5 +++--
 fs/sysfs/mount.c |    2 +-
 fs/sysfs/sysfs.h |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 481fdec..5907178 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -645,7 +645,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(sd);
+	inode = sysfs_get_inode(dir->i_sb, sd);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0d09f6c..082daae 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -283,6 +283,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 /**
  *	sysfs_get_inode - get inode for sysfs_dirent
+ *	@sb: super block
  *	@sd: sysfs_dirent to allocate inode for
  *
  *	Get inode for @sd.  If such inode doesn't exist, a new inode
@@ -295,11 +296,11 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
+struct inode * sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sysfs_sb, sd->s_ino);
+	inode = iget_locked(sb, sd->s_ino);
 	if (inode && (inode->i_state & I_NEW))
 		sysfs_init_inode(sd, inode);
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..89db07e 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -54,7 +54,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(&sysfs_root);
+	inode = sysfs_get_inode(sb, &sysfs_root);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 5a3192a..7593d71 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -172,7 +172,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_permission(struct inode *inode, int mask);
-- 
1.7.0.1

