Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZD1ScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZD1ScZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZD1ScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:32:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46991 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZD1ScP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:32:15 -0400
Subject: integrity: nfsd imbalance bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, James Morris <jmorris@namei.org>,
       david safford <safford@watson.ibm.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:32:14 -0400
Message-Id: <1240943534.4143.55.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of calls to ima_path_check()/ima_file_free()
should be balanced.  An extra call to fput(), indicates
the file could have been accessed without first being
measured.

An nfsd exported file is opened/closed by the kernel
causing an integrity imbalance message.

- rename and export opencount_get to ima_opencount_get
- replace ima_shm_check calls with ima_opencount_get
- add call to increment opencount for files opened by nfsd.
- add call to measure exported files in nfsd_permission().
- export ima_path_check

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/fs/nfsd/vfs.c
===================================================================
--- security-testing-2.6.orig/fs/nfsd/vfs.c
+++ security-testing-2.6/fs/nfsd/vfs.c
@@ -55,6 +55,7 @@
 #include <linux/security.h>
 #endif /* CONFIG_NFSD_V4 */
 #include <linux/jhash.h>
+#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 
@@ -735,6 +736,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 			    flags, cred);
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
+	else
+		ima_opencount_get(*filp);
 out_nfserr:
 	err = nfserrno(host_err);
 out:
@@ -2096,7 +2099,13 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
 		err = inode_permission(inode, MAY_EXEC);
+	if (err)
+		goto nfsd_out;
 
+	err = ima_path_check(&exp->ex_path,
+			     acc & (MAY_READ | MAY_WRITE | MAY_EXEC));
+	return err;
+nfsd_out:
 	return err? nfserrno(err) : 0;
 }
 
Index: security-testing-2.6/security/integrity/ima/ima_main.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_main.c
+++ security-testing-2.6/security/integrity/ima/ima_main.c
@@ -206,6 +206,7 @@ out:
 	kref_put(&iint->refcount, iint_free);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ima_path_check);
 
 static int process_measurement(struct file *file, const unsigned char *filename,
 			       int mask, int function)
@@ -234,7 +235,16 @@ out:
 	return rc;
 }
 
-static void opencount_get(struct file *file)
+/*
+ * ima_opencount_get - incr opencount for files opened by the kernel
+ *
+ * - IPC shm and shmat create/fput a file.
+ * - nfsd opens/closes exported files.
+ *
+ * Increment the opencount for these files to prevent unnecessary
+ * imbalance messages.
+ */
+void ima_opencount_get(struct file *file)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ima_iint_cache *iint;
@@ -248,6 +258,7 @@ static void opencount_get(struct file *f
 	iint->opencount++;
 	mutex_unlock(&iint->mutex);
 }
+EXPORT_SYMBOL_GPL(ima_opencount_get);
 
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
@@ -272,18 +283,6 @@ int ima_file_mmap(struct file *file, uns
 	return 0;
 }
 
-/*
- * ima_shm_check - IPC shm and shmat create/fput a file
- *
- * Maintain the opencount for these files to prevent unnecessary
- * imbalance messages.
- */
-void ima_shm_check(struct file *file)
-{
-	opencount_get(file);
-	return;
-}
-
 /**
  * ima_bprm_check - based on policy, collect/store measurement.
  * @bprm: contains the linux_binprm structure
Index: security-testing-2.6/include/linux/ima.h
===================================================================
--- security-testing-2.6.orig/include/linux/ima.h
+++ security-testing-2.6/include/linux/ima.h
@@ -20,7 +20,7 @@ extern void ima_inode_free(struct inode 
 extern int ima_path_check(struct path *path, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
-extern void ima_shm_check(struct file *file);
+extern void ima_opencount_get(struct file *file);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -53,7 +53,7 @@ static inline int ima_file_mmap(struct f
 	return 0;
 }
 
-static inline void ima_shm_check(struct file *file)
+static inline void ima_opencount_get(struct file *file)
 {
 	return;
 }
Index: security-testing-2.6/ipc/shm.c
===================================================================
--- security-testing-2.6.orig/ipc/shm.c
+++ security-testing-2.6/ipc/shm.c
@@ -384,7 +384,7 @@ static int newseg(struct ipc_namespace *
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto no_file;
-	ima_shm_check(file);
+	ima_opencount_get(file);
 
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
@@ -891,7 +891,7 @@ long do_shmat(int shmid, char __user *sh
 	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
-	ima_shm_check(file);
+	ima_opencount_get(file);
 
 	file->private_data = sfd;
 	file->f_mapping = shp->shm_file->f_mapping;
Index: security-testing-2.6/mm/shmem.c
===================================================================
--- security-testing-2.6.orig/mm/shmem.c
+++ security-testing-2.6/mm/shmem.c
@@ -2680,7 +2680,7 @@ int shmem_zero_setup(struct vm_area_stru
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ima_shm_check(file);
+	ima_opencount_get(file);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;


