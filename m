Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYGGQzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYGGQzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYGGQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:34 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755494AbYGGQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:30 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] SELinux: allow fstype unknown to policy to use xattrs if present
Date: Tue,  8 Jul 2008 01:42:22 +0900
Message-Id: <1215448942-17581-21-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Currently if a FS is mounted for which SELinux policy does not define an
fs_use_* that FS will either be genfs labeled or not labeled at all.
This decision is based on the existence of a genfscon rule in policy and
is irrespective of the capabilities of the filesystem itself.  This
patch allows the kernel to check if the filesystem supports security
xattrs and if so will use those if there is no fs_use_* rule in policy.
An fstype with a no fs_use_* rule but with a genfs rule will use xattrs
if available and will follow the genfs rule.

This can be particularly interesting for things like ecryptfs which
actually overlays a real underlying FS.  If we define excryptfs in
policy to use xattrs we will likely get this wrong at times, so with
this path we just don't need to define it!

Overlay ecryptfs on top of NFS with no xattr support:
SELinux: initialized (dev ecryptfs, type ecryptfs), uses genfs_contexts
Overlay ecryptfs on top of ext4 with xattr support:
SELinux: initialized (dev ecryptfs, type ecryptfs), uses xattr

It is also useful as the kernel adds new FS we don't need to add them in
policy if they support xattrs and that is how we want to handle them.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c            |   22 +++++++++++++++++-----
 security/selinux/include/security.h |    2 +-
 security/selinux/ss/services.c      |   27 +++++++++++++++++++--------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4130d64..85f74f6 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -556,13 +556,15 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	struct task_security_struct *tsec = current->security;
 	struct superblock_security_struct *sbsec = sb->s_security;
 	const char *name = sb->s_type->name;
-	struct inode *inode = sbsec->sb->s_root->d_inode;
-	struct inode_security_struct *root_isec = inode->i_security;
+	struct dentry *root = sb->s_root;
+	struct inode *root_inode = root->d_inode;
+	struct inode_security_struct *root_isec = root_inode->i_security;
 	u32 fscontext_sid = 0, context_sid = 0, rootcontext_sid = 0;
 	u32 defcontext_sid = 0;
 	char **mount_options = opts->mnt_opts;
 	int *flags = opts->mnt_opts_flags;
 	int num_opts = opts->num_mnt_opts;
+	bool can_xattr = false;
 
 	mutex_lock(&sbsec->lock);
 
@@ -666,14 +668,24 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		goto out;
 	}
 
-	if (strcmp(sb->s_type->name, "proc") == 0)
+	if (strcmp(name, "proc") == 0)
 		sbsec->proc = 1;
 
+	/*
+	 * test if the fs supports xattrs, fs_use might make use of this if the
+	 * fs has no definition in policy.
+	 */
+	if (root_inode->i_op->getxattr) {
+		rc = root_inode->i_op->getxattr(root, XATTR_NAME_SELINUX, NULL, 0);
+		if (rc >= 0 || rc == -ENODATA)
+			can_xattr = true;
+	}
+
 	/* Determine the labeling behavior to use for this filesystem type. */
-	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
+	rc = security_fs_use(name, &sbsec->behavior, &sbsec->sid, can_xattr);
 	if (rc) {
 		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __func__, sb->s_type->name, rc);
+		       __func__, name, rc);
 		goto out;
 	}
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 7c54300..44cba2e 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -136,7 +136,7 @@ int security_get_allow_unknown(void);
 #define SECURITY_FS_USE_MNTPOINT	6 /* use mountpoint labeling */
 
 int security_fs_use(const char *fstype, unsigned int *behavior,
-	u32 *sid);
+	u32 *sid, bool can_xattr);
 
 int security_genfs_sid(const char *fstype, char *name, u16 sclass,
 	u32 *sid);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b52f923..8e42da1 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1934,7 +1934,8 @@ out:
 int security_fs_use(
 	const char *fstype,
 	unsigned int *behavior,
-	u32 *sid)
+	u32 *sid,
+	bool can_xattr)
 {
 	int rc = 0;
 	struct ocontext *c;
@@ -1948,6 +1949,7 @@ int security_fs_use(
 		c = c->next;
 	}
 
+	/* look for labeling behavior defined in policy */
 	if (c) {
 		*behavior = c->v.behavior;
 		if (!c->sid[0]) {
@@ -1958,14 +1960,23 @@ int security_fs_use(
 				goto out;
 		}
 		*sid = c->sid[0];
+		goto out;
+	}
+
+	/* labeling behavior not in policy, use xattrs if possible */
+	if (can_xattr) {
+		*behavior = SECURITY_FS_USE_XATTR;
+		*sid = SECINITSID_FS;
+		goto out;
+	}
+
+	/* no behavior in policy and can't use xattrs, try GENFS */
+	rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, sid);
+	if (rc) {
+		*behavior = SECURITY_FS_USE_NONE;
+		rc = 0;
 	} else {
-		rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, sid);
-		if (rc) {
-			*behavior = SECURITY_FS_USE_NONE;
-			rc = 0;
-		} else {
-			*behavior = SECURITY_FS_USE_GENFS;
-		}
+		*behavior = SECURITY_FS_USE_GENFS;
 	}
 
 out:
-- 
1.5.5.1

