Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYKCUSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYKCUSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYKCURt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:17:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYKCURs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:17:48 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 1/4] CAPABILITIES: add cpu endian vfs caps structure
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: sgrubb@redhat.com, morgan@kernel.org, serue@us.ibm.com,
       viro@ZenIV.linux.org.uk
Date: Mon, 03 Nov 2008 15:17:42 -0500
Message-ID: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a generic cpu endian caps structure and externally available
functions which retrieve fcaps information from disk.  This information is
necessary so fcaps information can be collected and recorded by the audit
system.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/capability.h |    7 ++
 security/commoncap.c       |  129 ++++++++++++++++++++++++--------------------
 2 files changed, 78 insertions(+), 58 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d1fe30..9d64a9c 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -96,6 +96,13 @@ typedef struct kernel_cap_struct {
 	__u32 cap[_KERNEL_CAPABILITY_U32S];
 } kernel_cap_t;
 
+/* exact same as vfs_cap_data but in cpu endian and always filled completely */
+struct cpu_vfs_cap_data {
+	__u32 magic_etc;
+	kernel_cap_t permitted;
+	kernel_cap_t inheritable;
+};
+
 #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 3976613..8bb95ed 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -202,17 +202,70 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(struct vfs_cap_data *caps,
-				struct linux_binprm *bprm, unsigned size)
+static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
+					  struct linux_binprm *bprm)
 {
+	unsigned i;
+	int ret = 0;
+
+	if (caps->magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+		bprm->cap_effective = true;
+	else
+		bprm->cap_effective = false;
+
+	CAP_FOR_EACH_U32(i) {
+		__u32 permitted = caps->permitted.cap[i];
+		__u32 inheritable = caps->inheritable.cap[i];
+
+		/*
+		 * pP' = (X & fP) | (pI & fI)
+		 */
+		bprm->cap_post_exec_permitted.cap[i] =
+			(current->cap_bset.cap[i] & permitted) |
+			(current->cap_inheritable.cap[i] & inheritable);
+
+		if (permitted & ~bprm->cap_post_exec_permitted.cap[i]) {
+			/*
+			 * insufficient to execute correctly
+			 */
+			ret = -EPERM;
+		}
+	}
+
+	/*
+	 * For legacy apps, with no internal support for recognizing they
+	 * do not have enough capabilities, we return an error if they are
+	 * missing some "forced" (aka file-permitted) capabilities.
+	 */
+	return bprm->cap_effective ? ret : 0;
+}
+
+int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
+{
+	struct inode *inode = dentry->d_inode;
 	__u32 magic_etc;
 	unsigned tocopy, i;
-	int ret;
+	int size;
+	struct vfs_cap_data caps;
+
+	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
+
+	if (!inode || !inode->i_op || !inode->i_op->getxattr)
+		return -ENODATA;
+
+	size = inode->i_op->getxattr((struct dentry *)dentry, XATTR_NAME_CAPS, &caps,
+				   XATTR_CAPS_SZ);
+	if (size == -ENODATA || size == -EOPNOTSUPP) {
+		/* no data, that's ok */
+		return -ENODATA;
+	}
+	if (size < 0)
+		return size;
 
 	if (size < sizeof(magic_etc))
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps->magic_etc);
+	cpu_caps->magic_etc = magic_etc = le32_to_cpu(caps.magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION_1:
@@ -229,46 +282,13 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 		return -EINVAL;
 	}
 
-	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE) {
-		bprm->cap_effective = true;
-	} else {
-		bprm->cap_effective = false;
-	}
-
-	ret = 0;
-
 	CAP_FOR_EACH_U32(i) {
-		__u32 value_cpu;
-
-		if (i >= tocopy) {
-			/*
-			 * Legacy capability sets have no upper bits
-			 */
-			bprm->cap_post_exec_permitted.cap[i] = 0;
-			continue;
-		}
-		/*
-		 * pP' = (X & fP) | (pI & fI)
-		 */
-		value_cpu = le32_to_cpu(caps->data[i].permitted);
-		bprm->cap_post_exec_permitted.cap[i] =
-			(current->cap_bset.cap[i] & value_cpu) |
-			(current->cap_inheritable.cap[i] &
-				le32_to_cpu(caps->data[i].inheritable));
-		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
-			/*
-			 * insufficient to execute correctly
-			 */
-			ret = -EPERM;
-		}
+		if (i >= tocopy)
+			break;
+		cpu_caps->permitted.cap[i] = le32_to_cpu(caps.data[i].permitted);
+		cpu_caps->inheritable.cap[i] = le32_to_cpu(caps.data[i].inheritable);
 	}
-
-	/*
-	 * For legacy apps, with no internal support for recognizing they
-	 * do not have enough capabilities, we return an error if they are
-	 * missing some "forced" (aka file-permitted) capabilities.
-	 */
-	return bprm->cap_effective ? ret : 0;
+	return 0;
 }
 
 /* Locate any VFS capabilities: */
@@ -276,8 +296,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
 	int rc = 0;
-	struct vfs_cap_data vcaps;
-	struct inode *inode;
+	struct cpu_vfs_cap_data vcaps;
 
 	bprm_clear_caps(bprm);
 
@@ -285,24 +304,18 @@ static int get_file_caps(struct linux_binprm *bprm)
 		return 0;
 
 	dentry = dget(bprm->file->f_dentry);
-	inode = dentry->d_inode;
-	if (!inode->i_op || !inode->i_op->getxattr)
-		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &vcaps,
-				   XATTR_CAPS_SZ);
-	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
-		/* no data, that's ok */
-		rc = 0;
+	rc = get_vfs_caps_from_disk(dentry, &vcaps);
+	if (rc < 0) {
+		if (rc == -EINVAL)
+			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
+				__func__, rc, bprm->filename);
+		else if (rc == -ENODATA)
+			rc = 0;
 		goto out;
 	}
-	if (rc < 0)
-		goto out;
 
-	rc = cap_from_disk(&vcaps, bprm, rc);
-	if (rc == -EINVAL)
-		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-		       __func__, rc, bprm->filename);
+	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
 
 out:
 	dput(dentry);

