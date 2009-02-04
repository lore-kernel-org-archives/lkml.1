Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZBDOUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZBDOUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBDOTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:31 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55373 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZBDOT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:29 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 6/7] Integrity: IMA file free imbalance
Date: Wed,  4 Feb 2009 09:07:02 -0500
Message-Id: <2bd1490053fed6bd59633d77f20700b7ac8f8880.1233750617.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of calls to ima_path_check()/ima_file_free()
should be balanced.  An extra call to fput(), indicates
the file could have been accessed without first being
measured.

Although f_count is incremented/decremented in places other
than fget/fput, like fget_light/fput_light and get_file, the
current task must already hold a file refcnt.  The call to
__fput() is delayed until the refcnt becomes 0, resulting
in ima_file_free() flagging any changes.

- add hook to increment opencount for IPC shared memory(SYSV),
  shmat files, and /dev/zero
- moved NULL iint test in opencount_get()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/include/linux/ima.h b/include/linux/ima.h
index dcc3664..6db30a3 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -19,6 +19,7 @@ extern void ima_inode_free(struct inode *inode);
 extern int ima_path_check(struct path *path, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern void ima_shm_check(struct file *file);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -50,5 +51,10 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
 {
 	return 0;
 }
+
+static inline void ima_shm_check(struct file *file)
+{
+	return;
+}
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/ipc/shm.c b/ipc/shm.c
index 38a0557..d39bd76 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -39,6 +39,7 @@
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
+#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 
@@ -381,6 +382,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto no_file;
+	ima_shm_check(file);
 
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
@@ -888,6 +890,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
+	ima_shm_check(file);
 
 	file->private_data = sfd;
 	file->f_mapping = shp->shm_file->f_mapping;
diff --git a/mm/shmem.c b/mm/shmem.c
index f1b0d48..dd5588f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -51,6 +51,7 @@
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
+#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
@@ -2600,6 +2601,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
+	ima_shm_check(file);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 42706b5..e3c16a2 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -97,6 +97,7 @@ static inline unsigned long ima_hash_key(u8 *digest)
 
 /* iint cache flags */
 #define IMA_MEASURED		1
+#define IMA_IINT_DUMP_STACK	512
 
 /* integrity data associated with an inode */
 struct ima_iint_cache {
@@ -106,6 +107,7 @@ struct ima_iint_cache {
 	struct mutex mutex;	/* protects: version, flags, digest */
 	long readcount;		/* measured files readcount */
 	long writecount;	/* measured files writecount */
+	long opencount;		/* opens reference count */
 	struct kref refcount;	/* ima_iint_cache reference count */
 	struct rcu_head rcu;
 };
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 750db3c..1f035e8 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -126,6 +126,7 @@ struct ima_iint_cache *ima_iint_find_insert_get(struct inode *inode)
 
 	return iint;
 }
+EXPORT_SYMBOL_GPL(ima_iint_find_insert_get);
 
 /* iint_free - called when the iint refcount goes to zero */
 void iint_free(struct kref *kref)
@@ -134,6 +135,21 @@ void iint_free(struct kref *kref)
 						   refcount);
 	iint->version = 0;
 	iint->flags = 0UL;
+	if (iint->readcount != 0) {
+		printk(KERN_INFO "%s: readcount: %ld\n", __FUNCTION__,
+		       iint->readcount);
+		iint->readcount = 0;
+	}
+	if (iint->writecount != 0) {
+		printk(KERN_INFO "%s: writecount: %ld\n", __FUNCTION__,
+		       iint->writecount);
+		iint->writecount = 0;
+	}
+	if (iint->opencount != 0) {
+		printk(KERN_INFO "%s: opencount: %ld\n", __FUNCTION__,
+		       iint->opencount);
+		iint->opencount = 0;
+	}
 	kref_set(&iint->refcount, 1);
 	kmem_cache_free(iint_cache, iint);
 }
@@ -174,6 +190,7 @@ static void init_once(void *foo)
 	mutex_init(&iint->mutex);
 	iint->readcount = 0;
 	iint->writecount = 0;
+	iint->opencount = 0;
 	kref_set(&iint->refcount, 1);
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 871e356..f4e7266 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -66,6 +66,19 @@ void ima_file_free(struct file *file)
 		return;
 
 	mutex_lock(&iint->mutex);
+	if (iint->opencount <= 0) {
+		printk(KERN_INFO
+		       "%s: %s open/free imbalance (r:%ld w:%ld o:%ld f:%ld)\n",
+		       __FUNCTION__, file->f_dentry->d_name.name,
+		       iint->readcount, iint->writecount,
+		       iint->opencount, atomic_long_read(&file->f_count));
+		if (!(iint->flags & IMA_IINT_DUMP_STACK)) {
+			dump_stack();
+			iint->flags |= IMA_IINT_DUMP_STACK;
+		}
+	}
+	iint->opencount--;
+
 	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		iint->readcount--;
 
@@ -119,6 +132,7 @@ static int get_path_measurement(struct ima_iint_cache *iint, struct file *file,
 		pr_info("%s dentry_open failed\n", filename);
 		return rc;
 	}
+	iint->opencount++;
 	iint->readcount++;
 
 	rc = ima_collect_measurement(iint, file);
@@ -159,6 +173,7 @@ int ima_path_check(struct path *path, int mask)
 		return 0;
 
 	mutex_lock(&iint->mutex);
+	iint->opencount++;
 	if ((mask & MAY_WRITE) || (mask == 0))
 		iint->writecount++;
 	else if (mask & (MAY_READ | MAY_EXEC))
@@ -219,6 +234,21 @@ out:
 	return rc;
 }
 
+static void opencount_get(struct file *file)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ima_iint_cache *iint;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return;
+	iint = ima_iint_find_insert_get(inode);
+	if (!iint)
+		return;
+	mutex_lock(&iint->mutex);
+	iint->opencount++;
+	mutex_unlock(&iint->mutex);
+}
+
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured (May be NULL)
@@ -242,6 +272,18 @@ int ima_file_mmap(struct file *file, unsigned long prot)
 	return 0;
 }
 
+/*
+ * ima_shm_check - IPC shm and shmat create/fput a file
+ *
+ * Maintain the opencount for these files to prevent unnecessary
+ * imbalance messages.
+ */
+void ima_shm_check(struct file *file)
+{
+	opencount_get(file);
+	return;
+}
+
 /**
  * ima_bprm_check - based on policy, collect/store measurement.
  * @bprm: contains the linux_binprm structure
-- 
1.5.6.6

