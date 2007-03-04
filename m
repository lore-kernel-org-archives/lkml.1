Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXCDWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXCDWTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 17:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXCDWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 17:19:44 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60325 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbXCDWTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 17:19:43 -0500
Date: Sun, 4 Mar 2007 16:19:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bill O'Donnell" <billodo@sgi.com>,
       Chris Friedhoff <chris@friedhoff.org>
Subject: [PATCH -mm] file capabilities: accomodate future 64-bit caps
Message-ID: <20070304221939.GA16081@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH -mm] file capabilities: accomodate future 64-bit caps

(Changelog: fixed syntax error in dummy version of check_cap_sanity())

As the capability set changes and distributions start tagging
binaries with capabilities, we would like for running an older
kernel to not necessarily make those binaries unusable.

	(0. Enable the CONFIG_SECURITY_FS_CAPABILITIES option
	   when CONFIG_SECURITY=n.)
	(1. Rename CONFIG_SECURITY_FS_CAPABILITIES to
	   CONFIG_SECURITY_FILE_CAPABILITIES)
	2. Introduce CONFIG_SECURITY_FILE_CAPABILITIES_STRICTXATTR
	   which, when set, prevents loading binaries with capabilities
	   set which the kernel doesn't know about.  When not set,
	   such capabilities run, ignoring the unknown caps.
	3. To accomodate 64-bit caps, specify that capabilities are
	   stored as
	   	u32 version; u32 eff0; u32 perm0; u32 inh0;
		u32 eff1; u32 perm1; u32 inh1; (etc)

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |   23 ++++++-
 security/Kconfig           |   14 ++++-
 security/commoncap.c       |  155 ++++++++++++++++++++++++++++----------------
 3 files changed, 131 insertions(+), 61 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 2776886..4dbfef3 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -44,11 +44,28 @@ typedef struct __user_cap_data_struct {
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+
+/* size of caps that we work with */
+#define XATTR_CAPS_SZ (4*sizeof(__le32))
+
+/*
+ * data[] is organized as:
+ *   effective[0]
+ *   permitted[0]
+ *   inheritable[0]
+ *   effective[1]
+ *   ...
+ * this way we can just read as much of the on-disk capability as
+ * we know should exist and know we'll get the data we'll need.
+ */
 struct vfs_cap_data_disk {
 	__le32 version;
-	__le32 effective;
-	__le32 permitted;
-	__le32 inheritable;
+	__le32 data[];  /* eff[0], perm[0], inh[0], eff[1], ... */
+};
+
+struct vfs_cap_data_disk_v1 {
+	__le32 version;
+	__le32 data[3];  /* eff[0], perm[0], inh[0] */
 };
 
 #ifdef __KERNEL__
diff --git a/security/Kconfig b/security/Kconfig
index 6d77f68..3d5de26 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -88,9 +88,9 @@ config SECURITY_CAPABILITIES
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
 
-config SECURITY_FS_CAPABILITIES
+config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities"
-	depends on SECURITY=n || SECURITY_CAPABILITIES=y
+	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
@@ -98,6 +98,16 @@ config SECURITY_FS_CAPABILITIES
 
 	  If in doubt, answer N.
 
+config SECURITY_FILE_CAPABILITIES_STRICTXATTR
+	bool "Refuse to run files with unknown caps"
+	depends on SECURITY_FILE_CAPABILITIES
+	default y
+	help
+	  Refuse to run files which have unknown capabilities set
+	  in the security.capability xattr.  This could prevent
+	  running important binaries from an updated distribution
+	  on an older kernel.
+
 config SECURITY_ROOTPLUG
 	tristate "Root Plug Support"
 	depends on USB && SECURITY
diff --git a/security/commoncap.c b/security/commoncap.c
index be86acb..3e336ea 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -110,36 +110,73 @@ void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
 	target->cap_permitted = *permitted;
 }
 
-#ifdef CONFIG_SECURITY_FS_CAPABILITIES
-static inline void cap_from_disk(struct vfs_cap_data_disk *dcap,
-					struct vfs_cap_data *cap)
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES_STRICTXATTR
+static int check_cap_sanity(struct vfs_cap_data_disk *dcap, int size)
 {
-	cap->version = le32_to_cpu(dcap->version);
-	cap->effective = le32_to_cpu(dcap->effective);
-	cap->permitted = le32_to_cpu(dcap->permitted);
-	cap->inheritable = le32_to_cpu(dcap->inheritable);
+	int word, bit;
+	u32 eff, inh, perm;
+	int sz = (size-1)/3;
+
+	word = CAP_NUMCAPS / 32;
+	bit = CAP_NUMCAPS % 32;
+
+	eff  = le32_to_cpu(dcap->data[3*word]);
+	perm = le32_to_cpu(dcap->data[3*word+1]);
+	inh  = le32_to_cpu(dcap->data[3*word+2]);
+
+	while (word < sz) {
+		if (bit == 32) {
+			bit = 0;
+			word++;
+			if (word >= sz)
+				break;
+			eff  = le32_to_cpu(dcap->data[3*word]);
+			perm = le32_to_cpu(dcap->data[3*word+1]);
+			inh  = le32_to_cpu(dcap->data[3*word+2]);
+			continue;
+		}
+		if (eff & CAP_TO_MASK(bit))
+			return -EINVAL;
+		if (inh & CAP_TO_MASK(bit))
+			return -EINVAL;
+		if (perm & CAP_TO_MASK(bit))
+			return -EINVAL;
+		bit++;
+	}
+
+	return 0;
 }
+#else
+static int check_cap_sanity(struct vfs_cap_data_disk *dcap, int sz)
+{ return 0; }
+#endif
 
-static int check_cap_sanity(struct vfs_cap_data *cap)
+static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
+					struct linux_binprm *bprm, int size)
 {
-	int i;
+	int rc, version;
 
-	if (cap->version != _LINUX_CAPABILITY_VERSION)
-		return -EPERM;
+	version = le32_to_cpu(dcap->version);
+	if (version != _LINUX_CAPABILITY_VERSION)
+		return -EINVAL;
 
-	for (i = CAP_NUMCAPS; i < 8*sizeof(cap->effective); i++) {
-		if (cap->effective & CAP_TO_MASK(i))
-			return -EPERM;
-	}
-	for (i = CAP_NUMCAPS; i < 8*sizeof(cap->permitted); i++) {
-		if (cap->permitted & CAP_TO_MASK(i))
-			return -EPERM;
-	}
-	for (i = CAP_NUMCAPS; i < 8*sizeof(cap->inheritable); i++) {
-		if (cap->inheritable & CAP_TO_MASK(i))
-			return -EPERM;
+	size /= sizeof(u32);
+	if ((size-1)%3) {
+		printk(KERN_WARNING "%s: size is an invalid size (%d)\n",
+						__FUNCTION__, size);
+		return -EINVAL;
 	}
 
+	rc = check_cap_sanity(dcap, size);
+	if (rc)
+		return rc;
+
+	bprm->cap_effective = le32_to_cpu(dcap->data[0]);
+	bprm->cap_permitted = le32_to_cpu(dcap->data[1]);
+	bprm->cap_inheritable = le32_to_cpu(dcap->data[2]);
+
 	return 0;
 }
 
@@ -147,52 +184,58 @@ static int check_cap_sanity(struct vfs_cap_data *cap)
 static int set_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
-	ssize_t rc;
-	struct vfs_cap_data_disk dcaps;
-	struct vfs_cap_data caps;
+	int rc;
+	struct vfs_cap_data_disk_v1 v1caps;
+	struct vfs_cap_data_disk *dcaps;
 	struct inode *inode;
-	int err;
 
+	dcaps = (struct vfs_cap_data_disk *)&v1caps;
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
 		return 0;
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-	if (!inode->i_op || !inode->i_op->getxattr) {
-		dput(dentry);
-		return 0;
+	rc = 0;
+	if (!inode->i_op || !inode->i_op->getxattr)
+		goto out;
+
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+							XATTR_CAPS_SZ);
+	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
+		rc = 0;
+		goto out;
 	}
-
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &dcaps,
-						sizeof(dcaps));
-	dput(dentry);
-
-	if (rc == -ENODATA)
-		return 0;
-
-	if (rc < 0) {
-		printk(KERN_NOTICE "%s: Error (%zd) getting xattr\n",
-				__FUNCTION__, rc);
-		return rc;
+	if (rc == -ERANGE) {
+		int size;
+		size = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+		if (size <= 0) {  /* shouldn't ever happen */
+			rc = -EINVAL;
+			goto out;
+		}
+		dcaps = kmalloc(size, GFP_KERNEL);
+		if (!dcaps) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+							size);
 	}
-
-	if (rc != sizeof(dcaps)) {
-		printk(KERN_NOTICE "%s: got wrong size for getxattr (%zd)\n",
-					__FUNCTION__, rc);
-		return -EPERM;
+	if (rc < 0)
+		goto out;
+	if (rc < sizeof(struct vfs_cap_data_disk_v1)) {
+		rc = -EINVAL;
+		goto out;
 	}
 
-	cap_from_disk(&dcaps, &caps);
-	err = check_cap_sanity(&caps);
-	if (err)
-		return err;
-
-	bprm->cap_effective = caps.effective;
-	bprm->cap_permitted = caps.permitted;
-	bprm->cap_inheritable = caps.inheritable;
+	rc = cap_from_disk(dcaps, bprm, rc);
 
-	return 0;
+out:
+	dput(dentry);
+	if ((void *)dcaps != (void *)&v1caps)
+		kfree(dcaps);
+	return rc;
 }
+
 #else
 static inline int set_file_caps(struct linux_binprm *bprm)
 {
@@ -399,7 +442,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 	return 0;
 }
 
-#ifdef CONFIG_SECURITY_FS_CAPABILITIES
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 /*
  * Rationale: code calling task_setscheduler, task_setioprio, and
  * task_setnice, assumes that
-- 
1.4.4.2

