Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbYB0XPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbYB0XPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763099AbYB0XPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:15:08 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:49817 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763064AbYB0XPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:15:07 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH 06/11] SELinux: Add new labeling type native labels
Date: Wed, 27 Feb 2008 15:39:41 -0500
Message-Id: <1204144786-3502-7-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There currently doesn't exist a labeling type that is adequate for use with
labeled nfs. Since NFS doesn't really support xattrs we can't use the use xattr
labeling behavior. For this we developed a new labeling type. The native
labeling type is used solely by NFS to ensure nfs inodes are labeled at runtime
by the NFS code instead of relying on the SELinux security server on the client
end.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 security/selinux/hooks.c            |   20 ++++++++++++--------
 security/selinux/include/security.h |    2 ++
 security/selinux/ss/policydb.c      |    5 ++++-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a56b21a..ebe4e18 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -300,13 +300,14 @@ extern int ss_initialized;
 
 /* The file system's label must be initialized prior to use. */
 
-static char *labeling_behaviors[6] = {
+static char *labeling_behaviors[7] = {
 	"uses xattr",
 	"uses transition SIDs",
 	"uses task SIDs",
 	"uses genfs_contexts",
 	"not configured for labeling",
 	"uses mountpoint labeling",
+	"uses native labels",
 };
 
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry);
@@ -660,14 +661,15 @@ static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
 	if (strcmp(sb->s_type->name, "proc") == 0)
 		sbsec->proc = 1;
 
-	/* Determine the labeling behavior to use for this filesystem type. */
-	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
-	if (rc) {
-		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __FUNCTION__, sb->s_type->name, rc);
-		goto out;
+	if (!sbsec->behavior) {
+		/* Determine the labeling behavior to use for this filesystem type. */
+		rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
+		if (rc) {
+			printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
+			       __FUNCTION__, sb->s_type->name, rc);
+			goto out;
+		}
 	}
-
 	/* sets the context of the superblock for the fs being mounted. */
 	if (fscontext_sid) {
 
@@ -1103,6 +1105,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	}
 
 	switch (sbsec->behavior) {
+	case SECURITY_FS_USE_NATIVE:
+		break;
 	case SECURITY_FS_USE_XATTR:
 		if (!inode->i_op->getxattr) {
 			isec->sid = sbsec->def_sid;
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 837ce42..e788c7a 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -114,6 +114,8 @@ int security_get_allow_unknown(void);
 #define SECURITY_FS_USE_GENFS		4 /* use the genfs support */
 #define SECURITY_FS_USE_NONE		5 /* no labeling support */
 #define SECURITY_FS_USE_MNTPOINT	6 /* use mountpoint labeling */
+#define SECURITY_FS_USE_NATIVE		7 /* use native label support */
+#define SECURITY_FS_USE_MAX		7 /* Highest SECURITY_FS_USE_XXX */
 
 int security_fs_use(const char *fstype, unsigned int *behavior,
 	u32 *sid);
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index bd7d6a0..3d9e30e 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1756,7 +1756,10 @@ int policydb_read(struct policydb *p, void *fp)
 				if (rc < 0)
 					goto bad;
 				c->v.behavior = le32_to_cpu(buf[0]);
-				if (c->v.behavior > SECURITY_FS_USE_NONE)
+				/* Determined at runtime, not in policy DB. */
+				if (c->v.behavior == SECURITY_FS_USE_MNTPOINT)
+					goto bad;
+				if (c->v.behavior > SECURITY_FS_USE_MAX)
 					goto bad;
 				len = le32_to_cpu(buf[1]);
 				c->u.name = kmalloc(len + 1,GFP_KERNEL);
-- 
1.5.3.8

