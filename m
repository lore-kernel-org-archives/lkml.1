Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbYKMDtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbYKMDtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYKMDsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:48:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41171 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYKMDsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:48:36 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 4/4] integrity: IMA radix tree
Date: Wed, 12 Nov 2008 22:47:14 -0500
Message-Id: <eb03c8958cecce6f38ff9d7ab562542ee1def143.1226547085.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version stores integrity information associated with an inode
in a radix tree in order to avoid bloating the in memory inode.
As entries can not be added to the radix tree at security_initcall,
this version removes the dual stage initialization.  Allocating and
freeing the memory continues to be done at inode_alloc and file_free,
respectively, except for inodes created before late_initcall.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bc6460c..0dcdd94 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -683,9 +683,6 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
-#ifdef CONFIG_INTEGRITY
-	void			*i_integrity;
-#endif
 	void			*i_private; /* fs or device private pointer */
 };
 
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index f3aced4..959ae66 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o
+	 ima_policy.o ima_iint.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 9a24305..09a5e1a 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -92,7 +92,6 @@ void ima_store_measurement(void *d);
 void ima_template_show(struct seq_file *m, void *e,
 		       enum integrity_show_type show);
 
-
 /*
  * used to protect h_table and sha_table
  */
@@ -109,7 +108,7 @@ extern struct ima_h_table ima_htable;
 
 static inline unsigned long IMA_HASH_KEY(u8 *digest)
 {
-	 return(hash_long(*digest, IMA_HASH_BITS));
+	return (hash_long(*digest, IMA_HASH_BITS));
 }
 
 /* TPM "Glue" definitions */
@@ -145,11 +144,36 @@ struct ima_iint_cache {
 	u8 hmac[IMA_DIGEST_SIZE];
 	u8 digest[IMA_DIGEST_SIZE];
 	struct mutex mutex;
+	atomic_t refcount;
 };
 #define IMA_IINT_INIT		1
 #define IMA_MUST_MEASURE	2
 #define IMA_MEASURED		4
 
+void ima_iint_init(void);
+struct ima_iint_cache * ima_iint_lookup(struct inode *inode);
+int ima_iint_insert(struct inode *inode);
+void ima_iint_delete(struct inode *inode);
+
+static inline void iint_get(struct ima_iint_cache *iint)
+{
+	atomic_inc(&iint->refcount);
+}
+
+/*
+ * When iint->refcounter goes to 0, free iint.
+ *
+ * When inode_alloc_integrity starts at late_initcall,
+ * iint can be NULl.
+ */
+static inline void iint_put(struct ima_iint_cache *iint)
+{
+	if (!iint)
+		return;
+	if (atomic_dec_and_test(&iint->refcount))
+		kfree(iint);
+}
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 504c195..5b0b2f9 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -266,9 +266,35 @@ int ima_must_measure(void *template_data)
 	if (skip_measurement(data->inode, data->mask))
 		return -EPERM;
 
-	iint = inode->i_integrity;
-	mutex_lock(&iint->mutex);
+	rcu_read_lock();
+	iint = ima_iint_lookup(inode);
+	if (iint)
+		iint_get(iint);
+	rcu_read_unlock();
+
+	if (!iint) {
+		int rc;
+
+		/* Most insertions are done at inode_alloc,
+		 * except those allocated before late_initcall.
+		 * Can't initialize at security_initcall,
+		 * got to wait at least until proc_init.
+		 */
+		rc = ima_iint_insert(inode);
+		if (rc < 0)
+			return rc;
+
+		rcu_read_lock();
+		iint = ima_iint_lookup(inode);
+		if (!iint) {
+			rcu_read_unlock();
+			return -ENOMEM;
+		}
+		iint_get(iint);
+		rcu_read_unlock();
+	}
 
+	mutex_lock(&iint->mutex);
 	/* short circuit out of here, if iint initialized
 	 * and either no measurement required or already measured.
 	 */
@@ -290,6 +316,7 @@ int ima_must_measure(void *template_data)
 		iint->flags |= IMA_IINT_INIT;
 	}
 	mutex_unlock(&iint->mutex);
+	iint_put(iint);
 	return must_measure;
 }
 
@@ -314,7 +341,15 @@ int ima_collect_measurement(void *template_data)
 	if (!inode || !dentry)
 		return -EINVAL;
 
-	iint = inode->i_integrity;
+	rcu_read_lock();
+	iint = ima_iint_lookup(inode);
+	if (!iint) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+	iint_get(iint);
+	rcu_read_unlock();
+
 	mutex_lock(&iint->mutex);
 	if (!(iint->flags & IMA_MEASURED)) {
 		memset(iint->digest, 0, IMA_DIGEST_SIZE);
@@ -322,6 +357,7 @@ int ima_collect_measurement(void *template_data)
 	} else
 		result = -EEXIST;
 	mutex_unlock(&iint->mutex);
+	iint_put(iint);
 	return result;
 }
 
@@ -344,7 +380,15 @@ void ima_store_measurement(void *template_data)
 		struct ima_args_data *data = &idata->data.args;
 		struct ima_iint_cache *iint;
 
-		iint = data->inode->i_integrity;
+		rcu_read_lock();
+		iint = ima_iint_lookup(data->inode);
+		if (!iint) {
+			rcu_read_unlock();
+			return;
+		}
+		iint_get(iint);
+		rcu_read_unlock();
+
 		mutex_lock(&iint->mutex);
 		if (iint->flags & IMA_MEASURED) {
 			mutex_unlock(&iint->mutex);
@@ -358,6 +402,7 @@ void ima_store_measurement(void *template_data)
 			iint->version = data->inode->i_version;
 		}
 		mutex_unlock(&iint->mutex);
+		iint_put(iint);
 	} else if (idata->type == IMA_TEMPLATE) {
 		struct ima_store_data *template = (struct ima_store_data *)
 		    &idata->data.template;
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
new file mode 100644
index 0000000..f7f6673
--- /dev/null
+++ b/security/integrity/ima/ima_iint.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2008 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: ima_iint.c
+ *             cache integrity information associated with an inode
+ *             using a radix tree.
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/radix-tree.h>
+#include "ima.h"
+
+static struct radix_tree_root ima_iint_store;
+DEFINE_SPINLOCK(ima_iint_lock);
+
+void ima_iint_init(void)
+{
+	INIT_RADIX_TREE(&ima_iint_store, GFP_ATOMIC);
+}
+
+/* Call with rcu_read_lock */
+struct ima_iint_cache * ima_iint_lookup(struct inode *inode)
+{
+	return radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
+}
+
+int ima_iint_insert(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+	int rc = 0;
+
+	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
+	if (!iint)
+		return -ENOMEM;
+	mutex_init(&iint->mutex);
+	atomic_set(&iint->refcount, 1);
+	iint->version = inode->i_version;
+
+	if ((rc = radix_tree_preload(GFP_KERNEL)) < 0) {
+		printk(KERN_INFO "%s: radix_tree_preload\n", __FUNCTION__);
+		kfree(iint);
+		return rc;
+	}
+
+	spin_lock(&ima_iint_lock);
+	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
+	spin_unlock(&ima_iint_lock);
+	radix_tree_preload_end();
+	return rc;
+}
+
+void ima_iint_delete(struct inode *inode)
+{
+	struct ima_iint_cache *iint;
+
+	spin_lock(&ima_iint_lock);
+	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
+	spin_unlock(&ima_iint_lock);
+	iint_put(iint);
+}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2b90df9..e36eef8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -28,7 +28,6 @@
 
 #include "ima.h"
 
-static bool ima_initialized = false;
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
 {
@@ -102,32 +101,32 @@ static void ima_file_free(struct file *file)
 		return;
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (atomic_read(&inode->i_writecount) == 1)) {
-		iint = inode->i_integrity;
+		rcu_read_lock();
+		iint = ima_iint_lookup(inode);
+		if (!iint) {
+			rcu_read_unlock();
+			return;
+		}
+		iint_get(iint);
+		rcu_read_unlock();
+
 		mutex_lock(&iint->mutex);
 		if (iint->version != inode->i_version)
 			iint->flags &= ~IMA_MEASURED;
 		mutex_unlock(&iint->mutex);
+		iint_put(iint);
 	}
 }
 
 /**
- * ima_alloc_integrity - allocate and attach an integrity structure
+ * ima_alloc_integrity - allocate and insert an integrity structure
  * @inode: the inode structure
  *
  * Returns 0 on success, -ENOMEM on failure
  */
 static int ima_inode_alloc_integrity(struct inode *inode)
 {
-	struct ima_iint_cache *iint;
-
-	iint = kzalloc(sizeof(*iint), GFP_KERNEL);
-	if (!iint)
-		return -ENOMEM;
-
-	mutex_init(&iint->mutex);
-	inode->i_integrity = iint;
-	iint->version = inode->i_version;
-	return 0;
+	return ima_iint_insert(inode);
 }
 
 /**
@@ -136,12 +135,7 @@ static int ima_inode_alloc_integrity(struct inode *inode)
  */
 static void ima_inode_free_integrity(struct inode *inode)
 {
-	struct ima_iint_cache *iint = inode->i_integrity;
-
-	if (iint) {
-		inode->i_integrity = NULL;
-		kfree(iint);
-	}
+	ima_iint_delete(inode);
 }
 
 /**
@@ -168,9 +162,6 @@ static int ima_nameidata_check_integrity(struct nameidata *nd, int mask)
 	struct dentry *dentry;
 	struct inode *inode;
 
-	if (!ima_initialized)
-		return 0;
-
 	memset(&idata, 0, sizeof idata);
 	ima_fixup_argsdata(data, NULL, &nd->path, mask, INODE_PERMISSION);
 	inode = data->inode;
@@ -238,8 +229,6 @@ static int ima_file_mmap(struct file *file, unsigned long prot)
 	struct ima_args_data *data = &idata.data.args;
 	int rc = 0;
 
-	if (!ima_initialized)
-		return 0;
 	if (!file || !file->f_dentry)
 		return rc;
 	if (!(prot & VM_EXEC))
@@ -279,8 +268,6 @@ static int ima_bprm_check_integrity(struct linux_binprm *bprm)
 	struct ima_args_data *data = &idata.data.args;
 	int rc = 0;
 
-	if (!ima_initialized)
-		return 0;
 	ima_fixup_argsdata(data, bprm->file, NULL, MAY_EXEC, BPRM_CHECK);
 	data->filename = bprm->filename;
 
@@ -309,30 +296,24 @@ static const struct integrity_operations ima_base_ops = {
 	.file_free_integrity = ima_file_free,
 };
 
-/* Register the integrity ops early so that i_integrity is
- * allocated at inode initialization.
+/* After the TPM is available, start IMA
  */
-static int __init init_ops(void)
+static int __init init_ima(void)
 {
 	int error;
 
+	ima_iint_init();	/* Can't register early when using radix_tree */
+	error = ima_init();
+	if (error)
+		goto out;
+
 	if (ima_base_hooks)
 		error = register_integrity(&ima_base_ops);
 	else
 		error = register_integrity(&ima_integrity_ops);
-	return error;
-}
-
-/* After the TPM is available, start IMA
- */
-static int __init init_ima(void)
-{
-	int error;
-
-	error = ima_init();
 	if (error)
 		goto out;
-	ima_initialized = true;
+
 	integrity_register_template("ima", &ima_template_ops);
 out:
 	return error;
@@ -345,7 +326,6 @@ static void __exit cleanup_ima(void)
 	ima_cleanup();
 }
 
-security_initcall(init_ops);	/* Register the integrity ops early */
 late_initcall(init_ima);	/* Start IMA after the TPM is available */
 module_exit(cleanup_ima);
 
-- 
1.5.5.1

