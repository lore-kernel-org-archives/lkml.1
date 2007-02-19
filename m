Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXBSRBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXBSRBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 12:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbXBSRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 12:01:38 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55854 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbXBSRBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 12:01:37 -0500
Date: Mon, 19 Feb 2007 11:01:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: [RFC] [PATCH -mm] file caps: make on-disk capabilities future-proof
Message-ID: <20070219170133.GB28412@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley has pointed out that the current file capabilities
will eventually pose a problem.

As the capability set changes and distributions start tagging
binaries with capabilities, we would like for running an older
kernel to not necessarily make those binaries unusable.  The
following patch tries to address that.  Kaigai, if we went with
this patch, your userspace tools would need to be updated to
(a) insert a size parameter, and (b) update the
_LINUX_CAPABILITY_VERSION.

It would be nice to solve this before file caps hit mainline.

thanks,
-serge

From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [PATCH -mm] file caps: make on-disk capabilities future-proof

Stephen Smalley has pointed out that the current file capabilities
will eventually pose a problem.

As the capability set changes and distributions start tagging
binaries with capabilities, we would like for running an older
kernel to not necessarily make those binaries unusable.  To
that end,

	1. If capabilities are specified which we don't know
	   about, just ignore them, do not return -EPERM as we
	   were doing before.
	2. Specify a size with the on-disk capability implementation.
	   In this implementation the size is the number of __u32's
	   used for each of (eff,perm,inh).  For now, sz is 1.
	   When we move to 64-bit capabilities, it becomes 2.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/capability.h |   18 ++++++--
 security/commoncap.c       |  100 +++++++++++++++++++++++++-------------------
 2 files changed, 70 insertions(+), 48 deletions(-)

f4beca776d303bbb6348dc08e4d02c3bd37f3a83
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 2776886..1de7a85 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -27,7 +27,7 @@
    library since the draft standard requires the use of malloc/free
    etc.. */
  
-#define _LINUX_CAPABILITY_VERSION  0x19980330
+#define _LINUX_CAPABILITY_VERSION  0x20070215
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -44,11 +44,21 @@ typedef struct __user_cap_data_struct {
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+#define XATTR_CAPS_SZ (5*sizeof(__le32))
+/*
+ * sz is the # of __le32's in each set, 1 for now.
+ * data[] is organized as:
+ *   effective[0..sz-1]
+ *   permitted[0..sz-1]
+ *   inheritable[0..sz-1]
+ *   ...
+ * this way we can just read as much of the on-disk capability as
+ * we know should exist and know we'll get the data we'll need.
+ */
 struct vfs_cap_data_disk {
 	__le32 version;
-	__le32 effective;
-	__le32 permitted;
-	__le32 inheritable;
+	__le32 sz;
+	__le32 data[];  /* effective[sz], permitted[sz], inheritable[sz] */
 };
 
 #ifdef __KERNEL__
diff --git a/security/commoncap.c b/security/commoncap.c
index be86acb..dc8bf4f 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -111,35 +111,32 @@ void cap_capset_set (struct task_struct 
 }
 
 #ifdef CONFIG_SECURITY_FS_CAPABILITIES
-static inline void cap_from_disk(struct vfs_cap_data_disk *dcap,
-					struct vfs_cap_data *cap)
+static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
+					struct vfs_cap_data *cap, int size)
 {
+	__u32 sz;
+
 	cap->version = le32_to_cpu(dcap->version);
-	cap->effective = le32_to_cpu(dcap->effective);
-	cap->permitted = le32_to_cpu(dcap->permitted);
-	cap->inheritable = le32_to_cpu(dcap->inheritable);
+	sz = le32_to_cpu(dcap->sz);
+
+	if ((sz*3+2)*sizeof(__u32) != size) {
+		printk(KERN_NOTICE "%s: sz is %d, size is %d, should be %d\n", __FUNCTION__,
+			sz, size, (sz*3+2)*sizeof(__u32));
+		return -EINVAL;
+	}
+
+	cap->effective = le32_to_cpu(dcap->data[0]);
+	cap->permitted = le32_to_cpu(dcap->data[sz]);
+	cap->inheritable = le32_to_cpu(dcap->data[sz*2]);
+
+	return 0;
 }
 
 static int check_cap_sanity(struct vfs_cap_data *cap)
 {
-	int i;
-
 	if (cap->version != _LINUX_CAPABILITY_VERSION)
 		return -EPERM;
 
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
-	}
-
 	return 0;
 }
 
@@ -148,50 +145,65 @@ static int set_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	ssize_t rc;
-	struct vfs_cap_data_disk dcaps;
+	struct vfs_cap_data_disk *dcaps;
 	struct vfs_cap_data caps;
 	struct inode *inode;
-	int err;
 
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
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (rc == -ENODATA) {
+		rc = 0;
+		goto out;
+	}
+	if (rc < 0)
+		goto out;
+	if (rc < sizeof(struct vfs_cap_data_disk)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	dcaps = kmalloc(rc, GFP_KERNEL);
+	if (!dcaps) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+						XATTR_CAPS_SZ);
+	if (rc == -ENODATA) {
+		rc = 0;
+		goto out_free;
 	}
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &dcaps,
-						sizeof(dcaps));
-	dput(dentry);
-
-	if (rc == -ENODATA)
-		return 0;
-
 	if (rc < 0) {
 		printk(KERN_NOTICE "%s: Error (%zd) getting xattr\n",
 				__FUNCTION__, rc);
-		return rc;
+		goto out_free;
 	}
 
-	if (rc != sizeof(dcaps)) {
-		printk(KERN_NOTICE "%s: got wrong size for getxattr (%zd)\n",
-					__FUNCTION__, rc);
-		return -EPERM;
-	}
-
-	cap_from_disk(&dcaps, &caps);
-	err = check_cap_sanity(&caps);
-	if (err)
-		return err;
+	rc = cap_from_disk(dcaps, &caps, rc);
+	if (rc)
+		goto out_free;
+	rc = check_cap_sanity(&caps);
+	if (rc)
+		goto out_free;
 
 	bprm->cap_effective = caps.effective;
 	bprm->cap_permitted = caps.permitted;
 	bprm->cap_inheritable = caps.inheritable;
 
-	return 0;
+out_free:
+	kfree(dcaps);
+out:
+	dput(dentry);
+	return rc;
 }
 #else
 static inline int set_file_caps(struct linux_binprm *bprm)
-- 
1.1.6
