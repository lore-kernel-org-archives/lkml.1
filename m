Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbXITIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbXITIMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXITIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33382 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbXITIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=LqCaijvmH6e4H1XCWQvdaGts/UXSv4tn9qYAq0KqSwlFYWREoAWbms17qwp8ZlUtzaJH3Mf2cMsLsQMbx2MQaof6PxqCHDRDbPpJPUDNlpzJF8sDZvM+0E6WZ7tjgvL6rr/0ID1XzyE3jXscn71GIBoRVVXzwTrtXKCDpT6yD+Q=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 15/22] sysfs: implement sysfs_dirent based link interface
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:41 +0900
Message-Id: <11902755414149-git-send-email-htejun@gmail.com>
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

sysfs_add_link() takes parent sd, name, mode and the target sd and
creates a link accordingly.  Currently, sysfs links can only point to
directories but this limitiation is artificial to avoid inflating the
sysfs_dirent structure by one pointer with future changes and can be
easily removed.

Kobject based sysfs_create_link() is reimplemented using
sysfs_add_link().

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/kobject.c    |   47 +++++++++++++++++++++++++++
 fs/sysfs/symlink.c    |   83 +++++++++++++++++-------------------------------
 include/linux/sysfs.h |   10 ++++++
 3 files changed, 87 insertions(+), 53 deletions(-)

diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index a34c54e..7400575 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -355,6 +355,53 @@ void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
 
+/*
+ * kobject link interface
+ */
+
+/**
+ *	sysfs_create_link - create symlink between two objects.
+ *	@kobj:	object whose directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ */
+int sysfs_create_link(struct kobject *kobj, struct kobject *target,
+		      const char *name)
+{
+	struct sysfs_dirent *parent_sd, *target_sd, *sd;
+
+	BUG_ON(!name);
+
+	if (!kobj)
+		parent_sd = sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	if (!parent_sd)
+		return -EFAULT;
+
+	/* target->sd can go away beneath us but is protected with
+	 * sysfs_assoc_lock.  Fetch target_sd from it.
+	 */
+	spin_lock(&sysfs_assoc_lock);
+	target_sd = NULL;
+	if (target->sd)
+		target_sd = sysfs_get(target->sd);
+	spin_unlock(&sysfs_assoc_lock);
+
+	if (!target_sd)
+		return -ENOENT;
+
+	sd = sysfs_add_link(parent_sd, name, SYSFS_COPY_NAME, target_sd);
+
+	sysfs_put(target_sd);
+
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_link);
+
 /**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 2c3e4f7..42ecb69 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -5,7 +5,6 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/module.h>
-#include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/mutex.h>
 
@@ -45,64 +44,45 @@ static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
 }
 
 /**
- *	sysfs_create_link - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
+ *	sysfs_add_link - add a new sysfs symlink
+ *	@parent: sysfs_dirent to add symlink under
+ *	@name: name of the symlink
+ *	@mode: SYSFS_* flags for the new symlink
+ *	@target: target of the symlink
+ *
+ *	Add a new symlink which points to @target under @parent with
+ *	the specified parameters.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
+ *	error.
  */
-int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
+struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
+				    const char *name, mode_t mode,
+				    struct sysfs_dirent *target)
 {
-	struct sysfs_dirent *parent_sd = NULL;
-	struct sysfs_dirent *target_sd = NULL;
-	struct sysfs_dirent *sd = NULL;
-	struct sysfs_addrm_cxt acxt;
-	int error;
-
-	BUG_ON(!name);
-
-	if (!kobj)
-		parent_sd = sysfs_root;
-	else
-		parent_sd = kobj->sd;
+	struct sysfs_dirent *sd;
 
-	error = -EFAULT;
-	if (!parent_sd)
-		goto out_put;
-
-	/* target->sd can go away beneath us but is protected with
-	 * sysfs_assoc_lock.  Fetch target_sd from it.
+	/* Only symlink to directories are allowed.  This is an
+	 * artificial limitation.  If ever needed, allowing symlinks
+	 * to point to other types of sysfs nodes isn't difficult.
 	 */
-	spin_lock(&sysfs_assoc_lock);
-	if (target->sd)
-		target_sd = sysfs_get(target->sd);
-	spin_unlock(&sysfs_assoc_lock);
-
-	error = -ENOENT;
-	if (!target_sd)
-		goto out_put;
+	if (sysfs_type(target) != SYSFS_DIR)
+		return ERR_PTR(-EINVAL);
 
-	error = -ENOMEM;
-	sd = sysfs_new_dirent(name, S_IRWXUGO | SYSFS_COPY_NAME, SYSFS_LINK);
+	/* allocate & initialize */
+	sd = sysfs_new_dirent(name, mode | S_IRWXUGO, SYSFS_LINK);
 	if (!sd)
-		goto out_put;
-
-	sd->s_link.target = target_sd;
-	target_sd = NULL;	/* reference is now owned by the symlink */
+		return ERR_PTR(-ENOMEM);
 
-	sysfs_addrm_start(&acxt);
-	error = sysfs_add_one(&acxt, parent_sd, sd);
-	sysfs_addrm_finish(&acxt);
+	sd->s_link.target = sysfs_get(target);
 
-	if (error)
-		goto out_put;
-
-	return 0;
-
- out_put:
-	sysfs_put(target_sd);
-	sysfs_put(sd);
-	return error;
+	return sysfs_insert_one(parent, sd);
 }
+EXPORT_SYMBOL_GPL(sysfs_add_link);
 
 static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
 				 struct sysfs_dirent * target_sd, char *path)
@@ -162,6 +142,3 @@ const struct inode_operations sysfs_link_inode_operations = {
 	.follow_link = sysfs_follow_link,
 	.put_link = sysfs_put_link,
 };
-
-
-EXPORT_SYMBOL_GPL(sysfs_create_link);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index dfb6bd7..08ed1b0 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -60,6 +60,9 @@ struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
 struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 			const char *name, mode_t mode, size_t size,
 			const struct sysfs_bin_ops *bops, void *data);
+struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
+			const char *name, mode_t mode,
+			struct sysfs_dirent *target);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
@@ -94,6 +97,13 @@ static inline struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
+			const char *name, mode_t mode,
+			struct sysfs_dirent *target)
+{
+	return NULL;
+}
+
 static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 						    const char *name)
 {
-- 
1.5.0.3


