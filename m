Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbXITIPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbXITIPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXITIGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:34681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348AbXITIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=NSODprf5mAVZEyGe1UUx8WkClYsI2FdzK/x9eUWv6k6trw+f9KJzYlfjbatoCi67zJ6nWplJi8svid0syLdb035cR/7s9xsgV1evXsjQ8+rcdoVP8t5jnOjAY2FrNfqAOdVnWaywOl56StKsxgl5Jx8nQ4elK6OVmWV73OS+7gk=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 17/22] sysfs: s/sysfs_rename_mutex/sysfs_op_mutex/ and protect all tree modifying ops
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:41 +0900
Message-Id: <11902755413815-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename sysfs_rename_mutex to sysfs_op_mutex and protect operations
which modify tree with it.  ie.

  sysfs_op_mutex : above i_mutexes in the lock hierarchy and
		   guarantees exclusion against all tree
		   modifications.

  sysfs_mutex    : under i_mutexes in the lock hierarchy and protects
		   vfs tree walking from actual tree modification.

So, when one wants to modify tree structure, it should first grab
sysfs_op_mutex mutex, at which point tree structure is guaranteed to
not change beneath it, and then sysfs_mutex when it actually modifies
the tree.

This widened op mutex will be used to make using symlinks easier and
the extended mutex coverage won't add any noticeable contention (only
one extra locking and unlocking around sysfs_mutex in add/remove
paths), not that it would matter even if it actually does.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   38 +++++++++++++++++++++++++-------------
 fs/sysfs/sysfs.h |    2 +-
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a20beff..986718c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -18,8 +18,18 @@
 #error SYSFS mode flags out of S_IFMT
 #endif
 
+/* sysfs_op_mutex is above i_mutexes in the lock hierarchy and
+ * guarantees exclusion against operations which might change tree
+ * structure (add, remove and rename).  sysfs_mutex provide exclusion
+ * between tree modifying operations and vfs tree walking and is below
+ * i_mutexes in the lock hierarchy.
+ *
+ * If a thread is holding sysfs_op_mutex, no one else will change the
+ * tree structure beneath it.  When the thread actually wants to
+ * change the tree structure, it needs to grab sysfs_mutex too.
+ */
+DEFINE_MUTEX(sysfs_op_mutex);
 DEFINE_MUTEX(sysfs_mutex);
-DEFINE_MUTEX(sysfs_rename_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
@@ -87,7 +97,7 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  *	dentry for each step.
  *
  *	LOCKING:
- *	mutex_lock(sysfs_rename_mutex)
+ *	mutex_lock(sysfs_op_mutex)
  *
  *	RETURNS:
  *	Pointer to found dentry on success, ERR_PTR() value on error.
@@ -380,18 +390,19 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
  *
  *	This function is called when the caller is about to add or
  *	remove sysfs_dirents.  This function initializes @acxt and
- *	acquires sysfs_mutex.  @acxt is used to keep and pass context
- *	to other addrm functions.
+ *	acquires sysfs_op_mutex and sysfs_mutex.  @acxt is used to
+ *	keep and pass context to other addrm functions.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep).  sysfs_mutex is locked on
- *	return.
+ *	Kernel thread context (may sleep).  sysfs_op_mutex and
+ *	sysfs_mutex are locked on return.
  */
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
 {
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->removed_tail = &acxt->removed;
 
+	mutex_lock(&sysfs_op_mutex);
 	mutex_lock(&sysfs_mutex);
 }
 
@@ -621,6 +632,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 	 */
 	sysfs_addrm_get_parent_inode(acxt, NULL);
 	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&sysfs_op_mutex);
 
 	/* kill removed sysfs_dirents */
 	while (acxt->removed) {
@@ -679,7 +691,7 @@ struct sysfs_dirent *sysfs_insert_one(struct sysfs_dirent *parent,
  *	Look for sysfs_dirent with name @name under @parent_sd.
  *
  *	LOCKING:
- *	mutex_lock(sysfs_mutex)
+ *	mutex_lock(sysfs_op_mutex) and/or mutex_lock(sysfs_mutex)
  *
  *	RETURNS:
  *	Pointer to sysfs_dirent if found, NULL if not.
@@ -944,7 +956,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	const char *dup_name = NULL;
 	int error;
 
-	mutex_lock(&sysfs_rename_mutex);
+	mutex_lock(&sysfs_op_mutex);
 
 	error = 0;
 	if (strcmp(sd->s_name, new_name) == 0)
@@ -997,7 +1009,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 	dput(old_dentry);
 	dput(new_dentry);
  out:
-	mutex_unlock(&sysfs_rename_mutex);
+	mutex_unlock(&sysfs_op_mutex);
 	return error;
 }
 
@@ -1009,7 +1021,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	int error;
 
-	mutex_lock(&sysfs_rename_mutex);
+	mutex_lock(&sysfs_op_mutex);
 	BUG_ON(!sd->s_parent);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : sysfs_root;
 
@@ -1068,7 +1080,7 @@ again:
 	dput(new_parent);
 	dput(old_dentry);
 	dput(new_dentry);
-	mutex_unlock(&sysfs_rename_mutex);
+	mutex_unlock(&sysfs_op_mutex);
 	return error;
 }
 
@@ -1151,9 +1163,9 @@ int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
 	struct iattr newattrs;
 	int rc;
 
-	mutex_lock(&sysfs_rename_mutex);
+	mutex_lock(&sysfs_op_mutex);
 	dentry = sysfs_get_dentry(sd);
-	mutex_unlock(&sysfs_rename_mutex);
+	mutex_unlock(&sysfs_op_mutex);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c5593f9..16ecd6a 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -87,8 +87,8 @@ extern struct kmem_cache *sysfs_dir_cachep;
 /*
  * dir.c
  */
+extern struct mutex sysfs_op_mutex;
 extern struct mutex sysfs_mutex;
-extern struct mutex sysfs_rename_mutex;
 extern spinlock_t sysfs_assoc_lock;
 
 extern const struct file_operations sysfs_dir_operations;
-- 
1.5.0.3


