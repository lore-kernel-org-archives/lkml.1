Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575Ab0ATUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0ATUf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558Ab0ATUf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:35:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37678 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0ATUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:35:55 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
Date: Wed, 20 Jan 2010 15:35:40 -0500
Message-Id: <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "Untangling ima mess, part 2 with counters" patch messed
up the counters.  Based on conversations with Al Viro, this patch
streamlines ima_path_check() by removing the counter maintaince.
The counters are now updated independently, from measuring the file,
in __dentry_open() and alloc_file() by calling ima_counts_get().
ima_path_check() is called from nfsd and do_filp_open().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/namei.c                        |    4 +-
 include/linux/ima.h               |    4 +-
 security/integrity/ima/ima_main.c |  234 ++++++++++++++-----------------------
 3 files changed, 94 insertions(+), 148 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fabd939..a89ebc3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1730,7 +1730,7 @@ do_last:
 		if (nd.root.mnt)
 			path_put(&nd.root);
 		if (!IS_ERR(filp)) {
-			error = ima_path_check(&filp->f_path, filp->f_mode &
+			error = ima_path_check(filp, filp->f_mode &
 				       (MAY_READ | MAY_WRITE | MAY_EXEC));
 			if (error) {
 				fput(filp);
@@ -1791,7 +1791,7 @@ ok:
 	}
 	filp = nameidata_to_filp(&nd, open_flag);
 	if (!IS_ERR(filp)) {
-		error = ima_path_check(&filp->f_path, filp->f_mode &
+		error = ima_path_check(filp, filp->f_mode &
 			       (MAY_READ | MAY_WRITE | MAY_EXEC));
 		if (error) {
 			fput(filp);
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 99dc6d5..aa55a8f 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -17,7 +17,7 @@ struct linux_binprm;
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_inode_alloc(struct inode *inode);
 extern void ima_inode_free(struct inode *inode);
-extern int ima_path_check(struct path *path, int mask);
+extern int ima_path_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
@@ -38,7 +38,7 @@ static inline void ima_inode_free(struct inode *inode)
 	return;
 }
 
-static inline int ima_path_check(struct path *path, int mask)
+static inline int ima_path_check(struct file *file, int mask)
 {
 	return 0;
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a89f44d..1ffa54e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -84,6 +84,36 @@ out:
 	return found;
 }
 
+/* ima_read_write_check - reflect possible reading/writing errors in the PCR.
+ *
+ * When opening a file for read, if the file is already open for write,
+ * the file could change, resulting in a file measurement error.
+ *
+ * Opening a file for write, if the file is already open for read, results
+ * in a time of measure, time of use (ToMToU) error.
+ *
+ * In either case invalidate the PCR.
+ */
+enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
+static void ima_read_write_check(enum iint_pcr_error error,
+				 struct ima_iint_cache *iint,
+				 struct inode *inode,
+				 const unsigned char *filename)
+{
+	switch (error) {
+	case TOMTOU:
+		if (iint->readcount > 0)
+			ima_add_violation(inode, filename, "invalid_pcr",
+					  "ToMToU");
+		break;
+	case OPEN_WRITERS:
+		if (iint->writecount > 0)
+			ima_add_violation(inode, filename, "invalid_pcr",
+					  "open_writers");
+		break;
+	}
+}
+
 /*
  * Update the counts given an fmode_t
  */
@@ -99,6 +129,47 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
 }
 
 /*
+ * ima_counts_get - increment file counts
+ *
+ * Maintain read/write counters for all files, but only
+ * invalidate the PCR for measured files:
+ * 	- Opening a file for write when already open for read,
+ *	  results in a time of measure, time of use (ToMToU) error.
+ *	- Opening a file for read when already open for write,
+ * 	  could result in a file measurement error.
+ *
+ */
+void ima_counts_get(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	fmode_t mode = file->f_mode;
+	struct ima_iint_cache *iint;
+	int rc;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return;
+	iint = ima_iint_find_get(inode);
+	if (!iint)
+		return;
+	mutex_lock(&iint->mutex);
+	rc = ima_must_measure(iint, inode, MAY_READ, PATH_CHECK);
+	if (rc < 0)
+		goto out;
+
+	if (mode & FMODE_WRITE) {
+		ima_read_write_check(TOMTOU, iint, inode, dentry->d_name.name);
+		goto out;
+	}
+	ima_read_write_check(OPEN_WRITERS, iint, inode, dentry->d_name.name);
+out:
+	ima_inc_counts(iint, file->f_mode);
+	mutex_unlock(&iint->mutex);
+
+	kref_put(&iint->refcount, iint_free);
+}
+
+/*
  * Decrement ima counts
  */
 static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
@@ -153,123 +224,6 @@ void ima_file_free(struct file *file)
 	kref_put(&iint->refcount, iint_free);
 }
 
-/* ima_read_write_check - reflect possible reading/writing errors in the PCR.
- *
- * When opening a file for read, if the file is already open for write,
- * the file could change, resulting in a file measurement error.
- *
- * Opening a file for write, if the file is already open for read, results
- * in a time of measure, time of use (ToMToU) error.
- *
- * In either case invalidate the PCR.
- */
-enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
-static void ima_read_write_check(enum iint_pcr_error error,
-				 struct ima_iint_cache *iint,
-				 struct inode *inode,
-				 const unsigned char *filename)
-{
-	switch (error) {
-	case TOMTOU:
-		if (iint->readcount > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "ToMToU");
-		break;
-	case OPEN_WRITERS:
-		if (iint->writecount > 0)
-			ima_add_violation(inode, filename, "invalid_pcr",
-					  "open_writers");
-		break;
-	}
-}
-
-static int get_path_measurement(struct ima_iint_cache *iint, struct file *file,
-				const unsigned char *filename)
-{
-	int rc = 0;
-
-	ima_inc_counts(iint, file->f_mode);
-
-	rc = ima_collect_measurement(iint, file);
-	if (!rc)
-		ima_store_measurement(iint, file, filename);
-	return rc;
-}
-
-/**
- * ima_path_check - based on policy, collect/store measurement.
- * @path: contains a pointer to the path to be measured
- * @mask: contains MAY_READ, MAY_WRITE or MAY_EXECUTE
- *
- * Measure the file being open for readonly, based on the
- * ima_must_measure() policy decision.
- *
- * Keep read/write counters for all files, but only
- * invalidate the PCR for measured files:
- * 	- Opening a file for write when already open for read,
- *	  results in a time of measure, time of use (ToMToU) error.
- *	- Opening a file for read when already open for write,
- * 	  could result in a file measurement error.
- *
- * Always return 0 and audit dentry_open failures.
- * (Return code will be based upon measurement appraisal.)
- */
-int ima_path_check(struct path *path, int mask)
-{
-	struct inode *inode = path->dentry->d_inode;
-	struct ima_iint_cache *iint;
-	struct file *file = NULL;
-	int rc;
-
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
-		return 0;
-	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return 0;
-
-	mutex_lock(&iint->mutex);
-
-	rc = ima_must_measure(iint, inode, MAY_READ, PATH_CHECK);
-	if (rc < 0)
-		goto out;
-
-	if ((mask & MAY_WRITE) || (mask == 0))
-		ima_read_write_check(TOMTOU, iint, inode,
-				     path->dentry->d_name.name);
-
-	if ((mask & (MAY_WRITE | MAY_READ | MAY_EXEC)) != MAY_READ)
-		goto out;
-
-	ima_read_write_check(OPEN_WRITERS, iint, inode,
-			     path->dentry->d_name.name);
-	if (!(iint->flags & IMA_MEASURED)) {
-		struct dentry *dentry = dget(path->dentry);
-		struct vfsmount *mnt = mntget(path->mnt);
-
-		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
-				   current_cred());
-		if (IS_ERR(file)) {
-			int audit_info = 0;
-
-			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
-					    dentry->d_name.name,
-					    "add_measurement",
-					    "dentry_open failed",
-					    1, audit_info);
-			file = NULL;
-			goto out;
-		}
-		rc = get_path_measurement(iint, file, dentry->d_name.name);
-	}
-out:
-	mutex_unlock(&iint->mutex);
-	if (file)
-		fput(file);
-	kref_put(&iint->refcount, iint_free);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ima_path_check);
-
 static int process_measurement(struct file *file, const unsigned char *filename,
 			       int mask, int function)
 {
@@ -297,33 +251,6 @@ out:
 	return rc;
 }
 
-/*
- * ima_counts_get - increment file counts
- *
- * - for IPC shm and shmat file.
- * - for nfsd exported files.
- *
- * Increment the counts for these files to prevent unnecessary
- * imbalance messages.
- */
-void ima_counts_get(struct file *file)
-{
-	struct inode *inode = file->f_dentry->d_inode;
-	struct ima_iint_cache *iint;
-
-	if (!ima_initialized || !S_ISREG(inode->i_mode))
-		return;
-	iint = ima_iint_find_get(inode);
-	if (!iint)
-		return;
-	mutex_lock(&iint->mutex);
-	ima_inc_counts(iint, file->f_mode);
-	mutex_unlock(&iint->mutex);
-
-	kref_put(&iint->refcount, iint_free);
-}
-EXPORT_SYMBOL_GPL(ima_counts_get);
-
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured (May be NULL)
@@ -369,6 +296,25 @@ int ima_bprm_check(struct linux_binprm *bprm)
 	return 0;
 }
 
+/**
+ * ima_path_check - based on policy, collect/store measurement.
+ * @file: pointer to the file to be measured
+ * @mask: contains MAY_READ, MAY_WRITE or MAY_EXECUTE
+ *
+ * Measure files based on the ima_must_measure() policy decision.
+ *
+ * Always return 0 and audit dentry_open failures.
+ * (Return code will be based upon measurement appraisal.)
+ */
+int ima_path_check(struct file *file, int mask)
+{
+	int rc;
+
+	rc = process_measurement(file, file->f_dentry->d_name.name,
+				 mask, PATH_CHECK);
+	return 0;
+}
+
 static int __init init_ima(void)
 {
 	int error;
-- 
1.6.0.6

