Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464Ab0AZWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0AZWCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0AZWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:02:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50870 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0AZWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:02:48 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] ima: rename ima_path_check to ima_file_check
Date: Tue, 26 Jan 2010 17:02:40 -0500
Message-Id: <1264543361-3999-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_path_check actually deals with files!  call it ima_file_check instead.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 fs/namei.c                        |    4 ++--
 fs/nfsd/vfs.c                     |    2 +-
 include/linux/ima.h               |    4 ++--
 security/integrity/ima/ima_main.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8b243e4..1e62a3f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1737,7 +1737,7 @@ do_last:
 		if (nd.root.mnt)
 			path_put(&nd.root);
 		if (!IS_ERR(filp)) {
-			error = ima_path_check(filp, acc_mode);
+			error = ima_file_check(filp, acc_mode);
 			if (error) {
 				fput(filp);
 				filp = ERR_PTR(error);
@@ -1797,7 +1797,7 @@ ok:
 	}
 	filp = nameidata_to_filp(&nd);
 	if (!IS_ERR(filp)) {
-		error = ima_path_check(filp, acc_mode);
+		error = ima_file_check(filp, acc_mode);
 		if (error) {
 			fput(filp);
 			filp = ERR_PTR(error);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a9e3b83..7afb0e9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -752,7 +752,7 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 			    flags, current_cred());
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
-	host_err = ima_path_check(*filp, access);
+	host_err = ima_file_check(*filp, access);
 out_nfserr:
 	err = nfserrno(host_err);
 out:
diff --git a/include/linux/ima.h b/include/linux/ima.h
index aa55a8f..c2e5cf0 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -17,7 +17,7 @@ struct linux_binprm;
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_inode_alloc(struct inode *inode);
 extern void ima_inode_free(struct inode *inode);
-extern int ima_path_check(struct file *file, int mask);
+extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
@@ -38,7 +38,7 @@ static inline void ima_inode_free(struct inode *inode)
 	return;
 }
 
-static inline int ima_path_check(struct file *file, int mask)
+static inline int ima_file_check(struct file *file)
 {
 	return 0;
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 75aee18..bab392e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -14,7 +14,7 @@
  *
  * File: ima_main.c
  *	implements the IMA hooks: ima_bprm_check, ima_file_mmap,
- *	and ima_path_check.
+ *	and ima_file_check.
  */
 #include <linux/module.h>
 #include <linux/file.h>
@@ -306,7 +306,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
  * Always return 0 and audit dentry_open failures.
  * (Return code will be based upon measurement appraisal.)
  */
-int ima_path_check(struct file *file, int mask)
+int ima_file_check(struct file *file, int mask)
 {
 	int rc;
 
@@ -315,7 +315,7 @@ int ima_path_check(struct file *file, int mask)
 				 PATH_CHECK);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ima_path_check);
+EXPORT_SYMBOL_GPL(ima_file_check);
 
 static int __init init_ima(void)
 {
-- 
1.6.0.6

