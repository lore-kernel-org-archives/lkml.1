Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbXJPC1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbXJPC1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbXJPC1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:27:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633AbXJPC1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:27:35 -0400
Date: Mon, 15 Oct 2007 21:27:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 1/2 -mm] capabilities: clean up file capability reading
Message-ID: <20071016022730.GA8925@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a simple cleanup which should probably be
applied to -mm (assuming I haven't messed it up).  The next
patch is an experimental patch which will require userspace
support and is just RFC at this point.

>From 9fc0782de6e1287aaeebe8ad653b008f09b22c11 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 15 Oct 2007 17:33:24 -0400
Subject: [PATCH 1/2] capabilities: clean up file capability reading

Simplify the vfs_cap_data structure.

Also fix get_file_caps which was declaring
__le32 v1caps[XATTR_CAPS_SZ] on the stack, but
XATTR_CAPS_SZ is already * sizeof(__le32).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    6 ++----
 security/commoncap.c       |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7a8d7ad..bb017ed 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -56,10 +56,8 @@ typedef struct __user_cap_data_struct {
 
 struct vfs_cap_data {
 	__u32 magic_etc;  /* Little endian */
-	struct {
-		__u32 permitted;    /* Little endian */
-		__u32 inheritable;  /* Little endian */
-	} data[1];
+	__u32 permitted;    /* Little endian */
+	__u32 inheritable;  /* Little endian */
 };
 
 #ifdef __KERNEL__
diff --git a/security/commoncap.c b/security/commoncap.c
index 43f9027..542bbe9 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -190,7 +190,8 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
+static inline int cap_from_disk(struct vfs_cap_data *caps,
+				struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
@@ -198,7 +199,7 @@ static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 	if (size != XATTR_CAPS_SZ)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps[0]);
+	magic_etc = le32_to_cpu(caps->magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
@@ -206,8 +207,8 @@ static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );
 		return 0;
 	default:
 		return -EINVAL;
@@ -219,7 +220,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
 	int rc = 0;
-	__le32 v1caps[XATTR_CAPS_SZ];
+	struct vfs_cap_data incaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -232,8 +233,14 @@ static int get_file_caps(struct linux_binprm *bprm)
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
-							XATTR_CAPS_SZ);
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (rc > 0) {
+		if (rc == XATTR_CAPS_SZ)
+			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
+						&incaps, XATTR_CAPS_SZ);
+		else
+			rc = -EINVAL;
+	}
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
 		/* no data, that's ok */
 		rc = 0;
@@ -242,7 +249,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(v1caps, bprm, rc);
+	rc = cap_from_disk(&incaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 			__FUNCTION__, rc, bprm->filename);
-- 
1.5.1.1.GIT

