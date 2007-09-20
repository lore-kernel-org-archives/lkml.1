Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXITINN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXITINN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbXITIGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33572 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbXITIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=HzwsSZyuv1qkLXlnq7BHD0+z606ghP7En57L70Z2mHSmyOX1pAz8BbvHWJNyDMXkD3uIPYQIupG2vrz9vgyC4iMAhYxV6+hJgDbeDSX1xNI0dUXmKvfC3EBqSbwODlDmqJnxc1OEvodXcUuJlApsYw8I7NZT1fU7L8eWOpMZQaM=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 19/22] sysfs: implement sysfs_dirent based rename - sysfs_rename()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:42 +0900
Message-Id: <1190275542331-git-send-email-htejun@gmail.com>
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

sysfs_rename() takes target @sd, @new_parent and @new_name and rename
@sd to @new_name and move it under @new_parent.  @new_parent and/or
@new_name can be NULL if the specific operation is not needed.

To handle both move and rename && prepare for multiple renames in one
shot for easier symlink handling and shadow dirents, sysfs_rename() is
implemented to be able to handle arbitrary number of rename/move
operations.

During sysfs_prep_rename(), it acquires all the resources it will need
during the operations including dentries and copied names.  After all
are acquired, all needed i_mutexes are locked.  Deadlock is avoided by
using trylock.  If any lock acquisition fails, it releases all
i_mutexes and retries after 1ms.  Because i_mutexes are used very
lightly in sysfs, almost like spinlocks just to satisfy VFS locking
rules, I don't think there will be any starvation issues.

This makes rename a heavy operation but sysfs_rename() may fail and
it's shady-side-of-the-moon cold path where programming convenience
dominates performance by all measures.

sysfs_rename() can be called on any type of sysfs_dirent and always
copies @new_name.

Kobject based sysfs_rename_dir() and sysfs_move_dir() are
reimplemented using sysfs_remove().

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |  433 +++++++++++++++++++++++++++++++++----------------
 fs/sysfs/kobject.c    |   31 ++++
 include/linux/sysfs.h |    9 +
 3 files changed, 337 insertions(+), 136 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 986718c..d0eb9bf 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -11,6 +11,7 @@
 #include <linux/idr.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 #include "sysfs.h"
 
 /* verify all mode flags are inside S_IFMT */
@@ -948,142 +949,6 @@ void sysfs_remove(struct sysfs_dirent *sd)
 }
 EXPORT_SYMBOL_GPL(sysfs_remove);
 
-int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
-{
-	struct sysfs_dirent *sd = kobj->sd;
-	struct dentry *parent = NULL;
-	struct dentry *old_dentry = NULL, *new_dentry = NULL;
-	const char *dup_name = NULL;
-	int error;
-
-	mutex_lock(&sysfs_op_mutex);
-
-	error = 0;
-	if (strcmp(sd->s_name, new_name) == 0)
-		goto out;	/* nothing to rename */
-
-	/* get the original dentry */
-	old_dentry = sysfs_get_dentry(sd);
-	if (IS_ERR(old_dentry)) {
-		error = PTR_ERR(old_dentry);
-		goto out;
-	}
-
-	parent = old_dentry->d_parent;
-
-	/* lock parent and get dentry for new name */
-	mutex_lock(&parent->d_inode->i_mutex);
-	mutex_lock(&sysfs_mutex);
-
-	error = -EEXIST;
-	if (sysfs_find_dirent(sd->s_parent, new_name))
-		goto out_unlock;
-
-	error = -ENOMEM;
-	new_dentry = d_alloc_name(parent, new_name);
-	if (!new_dentry)
-		goto out_unlock;
-
-	/* rename kobject and sysfs_dirent */
-	error = -ENOMEM;
-	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
-	if (!new_name)
-		goto out_unlock;
-
-	error = kobject_set_name(kobj, "%s", new_name);
-	if (error)
-		goto out_unlock;
-
-	dup_name = sd->s_name;
-	sd->s_name = new_name;
-
-	/* rename */
-	d_add(new_dentry, NULL);
-	d_move(old_dentry, new_dentry);
-
-	error = 0;
- out_unlock:
-	mutex_unlock(&sysfs_mutex);
-	mutex_unlock(&parent->d_inode->i_mutex);
-	kfree(dup_name);
-	dput(old_dentry);
-	dput(new_dentry);
- out:
-	mutex_unlock(&sysfs_op_mutex);
-	return error;
-}
-
-int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
-{
-	struct sysfs_dirent *sd = kobj->sd;
-	struct sysfs_dirent *new_parent_sd;
-	struct dentry *old_parent, *new_parent = NULL;
-	struct dentry *old_dentry = NULL, *new_dentry = NULL;
-	int error;
-
-	mutex_lock(&sysfs_op_mutex);
-	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : sysfs_root;
-
-	error = 0;
-	if (sd->s_parent == new_parent_sd)
-		goto out;	/* nothing to move */
-
-	/* get dentries */
-	old_dentry = sysfs_get_dentry(sd);
-	if (IS_ERR(old_dentry)) {
-		error = PTR_ERR(old_dentry);
-		goto out;
-	}
-	old_parent = old_dentry->d_parent;
-
-	new_parent = sysfs_get_dentry(new_parent_sd);
-	if (IS_ERR(new_parent)) {
-		error = PTR_ERR(new_parent);
-		goto out;
-	}
-
-again:
-	mutex_lock(&old_parent->d_inode->i_mutex);
-	if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
-		mutex_unlock(&old_parent->d_inode->i_mutex);
-		goto again;
-	}
-	mutex_lock(&sysfs_mutex);
-
-	error = -EEXIST;
-	if (sysfs_find_dirent(new_parent_sd, sd->s_name))
-		goto out_unlock;
-
-	error = -ENOMEM;
-	new_dentry = d_alloc_name(new_parent, sd->s_name);
-	if (!new_dentry)
-		goto out_unlock;
-
-	error = 0;
-	d_add(new_dentry, NULL);
-	d_move(old_dentry, new_dentry);
-	dput(new_dentry);
-
-	/* Remove from old parent's list and insert into new parent's list. */
-	sysfs_unlink_sibling(sd);
-	sysfs_get(new_parent_sd);
-	sysfs_put(sd->s_parent);
-	sd->s_parent = new_parent_sd;
-	sysfs_link_sibling(sd);
-
- out_unlock:
-	mutex_unlock(&sysfs_mutex);
-	mutex_unlock(&new_parent->d_inode->i_mutex);
-	mutex_unlock(&old_parent->d_inode->i_mutex);
- out:
-	dput(new_parent);
-	dput(old_dentry);
-	dput(new_dentry);
-	mutex_unlock(&sysfs_op_mutex);
-	return error;
-}
-
 /* Relationship between s_mode and the DT_xxx types */
 static inline unsigned char dt_type(struct sysfs_dirent *sd)
 {
@@ -1143,6 +1008,302 @@ const struct file_operations sysfs_dir_operations = {
 	.readdir	= sysfs_readdir,
 };
 
+/*
+ * Renaming a single node can result in renames of multiple nodes as
+ * symlinks pointing to the node are renamed together.  To rename
+ * multiple nodes atogether atomically, all resources including
+ * i_mutexes and dentries are grabbed before committing the operation.
+ *
+ * i_mutexes are recorded using sysfs_rcxt_mutex_ent as they might not
+ * correspond one to one to renames (e.g. two symlinks to the same
+ * target in the same directory).  All other resources are recorded in
+ * sysfs_rcxt_rename_ent.  Both are chained to sysfs_rename_context to
+ * be used later.
+ */
+struct sysfs_rcxt_rename_ent {
+	struct list_head	list;
+	struct sysfs_dirent	*sd;
+	struct sysfs_dirent	*new_parent;
+	const char		*old_name;
+	const char		*new_name;
+	int			old_name_copied;
+	int			new_name_copied;
+	struct dentry		*old_dentry;
+	struct dentry		*new_dentry;
+};
+
+struct sysfs_rcxt_mutex_ent {
+	struct list_head	list;
+	struct mutex		*mutex;
+	int			locked;
+};
+
+struct sysfs_rename_context {
+	struct list_head	mutexes;
+	struct list_head	renames;
+};
+
+static struct sysfs_rcxt_rename_ent *
+sysfs_rcxt_add(struct sysfs_rename_context *rcxt, struct sysfs_dirent *sd,
+	       struct sysfs_dirent *new_parent)
+{
+	struct sysfs_rcxt_rename_ent *rent;
+
+	rent = kzalloc(sizeof(*rent), GFP_KERNEL);
+	if (!rent)
+		return NULL;
+
+	rent->sd = sysfs_get(sd);
+	rent->new_parent = sysfs_get(new_parent);
+	rent->old_name = sd->s_name;
+	rent->old_name_copied = !!(sd->s_flags & SYSFS_FLAG_NAME_COPIED);
+
+	list_add_tail(&rent->list, &rcxt->renames);
+
+	return rent;
+}
+
+static int sysfs_rcxt_add_mutex(struct sysfs_rename_context *rcxt,
+				struct mutex *mutex)
+{
+	struct sysfs_rcxt_mutex_ent *ment;
+
+	list_for_each_entry(ment, &rcxt->mutexes, list)
+		if (ment->mutex == mutex)
+			return 0;
+
+	ment = kzalloc(sizeof(*ment), GFP_KERNEL);
+	if (!ment)
+		return -ENOMEM;
+
+	ment->mutex = mutex;
+
+	list_add_tail(&ment->list, &rcxt->mutexes);
+
+	return 0;
+}
+
+static int sysfs_rcxt_get_dentries(struct sysfs_rename_context *rcxt,
+				   struct sysfs_rcxt_rename_ent *rent)
+{
+	struct dentry *old_dentry, *new_parent_dentry, *new_dentry;
+	int rc;
+
+	/* get old dentry */
+	old_dentry = sysfs_get_dentry(rent->sd);
+	if (IS_ERR(old_dentry))
+		return PTR_ERR(old_dentry);
+	rent->old_dentry = old_dentry;
+
+	/* allocate new dentry */
+	new_parent_dentry = sysfs_get_dentry(rent->new_parent);
+	if (IS_ERR(new_parent_dentry))
+		return PTR_ERR(new_parent_dentry);
+
+	new_dentry = d_alloc_name(new_parent_dentry, rent->new_name);
+	dput(new_parent_dentry);
+	if (!new_dentry)
+		return -ENOMEM;
+	rent->new_dentry = new_dentry;
+
+	/* add i_mutexes to mutex list */
+	rc = sysfs_rcxt_add_mutex(rcxt, &old_dentry->d_parent->d_inode->i_mutex);
+	if (rc)
+		return rc;
+
+	rc = sysfs_rcxt_add_mutex(rcxt, &new_dentry->d_parent->d_inode->i_mutex);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static void sysfs_post_rename(struct sysfs_rename_context *rcxt, int error)
+{
+	struct sysfs_rcxt_mutex_ent *ment, *next_ment;
+	struct sysfs_rcxt_rename_ent *rent, *next_rent;
+
+	/* release all mutexes */
+	list_for_each_entry_safe(ment, next_ment, &rcxt->mutexes, list) {
+		if (ment->locked)
+			mutex_unlock(ment->mutex);
+
+		list_del(&ment->list);
+		kfree(ment);
+	}
+
+	/* release all renames */
+	list_for_each_entry_safe(rent, next_rent, &rcxt->renames, list) {
+		/* If rename succeeded, old name is unused; otherwise,
+		 * new name is unused.  Free accordingly.
+		 */
+		if (!error) {
+			if (rent->old_name_copied)
+				kfree(rent->old_name);
+		} else {
+			if (rent->new_name_copied)
+				kfree(rent->new_name);
+		}
+
+		dput(rent->old_dentry);
+		dput(rent->new_dentry);
+		sysfs_put(rent->sd);
+		sysfs_put(rent->new_parent);
+
+		list_del(&rent->list);
+		kfree(rent);
+	}
+}
+
+static int sysfs_prep_rename(struct sysfs_rename_context *rcxt,
+			     struct sysfs_dirent *sd,
+			     struct sysfs_dirent *new_parent,
+			     const char *new_name)
+{
+	struct sysfs_rcxt_rename_ent *rent;
+	struct sysfs_rcxt_mutex_ent *ment;
+	int rc;
+
+	INIT_LIST_HEAD(&rcxt->mutexes);
+	INIT_LIST_HEAD(&rcxt->renames);
+
+	/*
+	 * prep @sd
+	 */
+	rc = -ENOMEM;
+	rent = sysfs_rcxt_add(rcxt, sd, new_parent);
+	if (!rent)
+		goto err;
+
+	rc = -ENOMEM;
+	rent->new_name = kstrdup(new_name, GFP_KERNEL);
+	if (!rent->new_name)
+		goto err;
+	rent->new_name_copied = 1;
+
+	rc = sysfs_rcxt_get_dentries(rcxt, rent);
+	if (rc)
+		goto err;
+
+	/*
+	 * lock all i_mutexes
+	 */
+ try_lock:
+	list_for_each_entry(ment, &rcxt->mutexes, list) {
+		if (!mutex_trylock(ment->mutex)) {
+			/* unlock all and retry */
+			list_for_each_entry(ment, &rcxt->mutexes, list) {
+				if (ment->locked) {
+					mutex_unlock(ment->mutex);
+					ment->locked = 0;
+				}
+			}
+
+			/* No need to be over-anxious, let's take it
+			 * slow.  Sysfs i_mutexes are lightly loaded
+			 * and starvation is highly unlikely.
+			 */
+			msleep(1);
+			goto try_lock;
+		}
+
+		ment->locked = 1;
+	}
+
+	return 0;
+
+ err:
+	sysfs_post_rename(rcxt, rc);
+	return rc;
+}
+
+/**
+ *	sysfs_rename - rename and/or move sysfs node
+ *	@sd: sysfs_dirent to rename
+ *	@new_parent: new parent to move @sd under (NULL if only renaming)
+ *	@new_name: new name to rename @sd to (NULL if only moving)
+ *
+ *	Rename and/or move @sd.  If both @new_parent and @new_name are
+ *	specified, @sd is renamed to @new_name and moved under
+ *	@new_parent atomically.  If only one of the two is specified,
+ *	only the specified operation is performed.
+ *
+ *	Renaming and/or moving a sysfs node which is pointed to by
+ *	symlinks causes the symlinks to be renamed according to their
+ *	name formats.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success -errno on failure.
+ */
+int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+		 const char *new_name)
+{
+	struct sysfs_rename_context rcxt;
+	struct sysfs_rcxt_rename_ent *rent;
+	int error;
+
+	mutex_lock(&sysfs_op_mutex);
+
+	if (!new_parent)
+		new_parent = sd->s_parent;
+	if (!new_name)
+		new_name = sd->s_name;
+
+	error = 0;
+	if (sd->s_parent == new_parent && !strcmp(sd->s_name, new_name))
+		goto out;	/* nothing to rename */
+
+	error = sysfs_prep_rename(&rcxt, sd, new_parent, new_name);
+	if (error)
+		goto out;
+
+	/* check whether there are duplicate names */
+	error = -EEXIST;
+	list_for_each_entry(rent, &rcxt.renames, list)
+		if (sysfs_find_dirent(rent->new_parent, rent->new_name))
+			goto out_post;
+
+	mutex_lock(&sysfs_mutex);
+
+	/* rename sysfs_dirents and dentries */
+	list_for_each_entry(rent, &rcxt.renames, list) {
+		/* rename sd */
+		rent->sd->s_name = rent->new_name;
+		rent->sd->s_flags &= ~SYSFS_FLAG_NAME_COPIED;
+		if (rent->new_name_copied)
+			rent->sd->s_flags |= SYSFS_FLAG_NAME_COPIED;
+
+		/* move sd */
+		if (rent->sd->s_parent != rent->new_parent) {
+			sysfs_unlink_sibling(rent->sd);
+			sysfs_put(rent->sd->s_parent);
+			rent->sd->s_parent = sysfs_get(rent->new_parent);
+			sysfs_link_sibling(rent->sd);
+		}
+
+		/* update dcache and inode accordingly */
+		if (sysfs_type(rent->sd) == SYSFS_DIR) {
+			drop_nlink(rent->old_dentry->d_parent->d_inode);
+			inc_nlink(rent->new_dentry->d_parent->d_inode);
+		}
+		d_add(rent->new_dentry, NULL);
+		d_move(rent->old_dentry, rent->new_dentry);
+	}
+
+	mutex_unlock(&sysfs_mutex);
+	error = 0;
+	/* fall through */
+ out_post:
+	sysfs_post_rename(&rcxt, error);
+ out:
+	mutex_unlock(&sysfs_op_mutex);
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_rename);
+
 /**
  *	sysfs_chmod - chmod a sysfs_dirent
  *	@sd: sysfs_dirent to chmod
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 0a0d583..55b884b 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -75,6 +75,37 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove(sd, 0);
 }
 
+int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
+{
+	const char *dup_name;
+	int rc;
+
+	dup_name = kstrdup(new_name, GFP_KERNEL);
+	if (!dup_name)
+		return -ENOMEM;
+
+	rc = sysfs_rename(kobj->sd, NULL, new_name);
+	if (rc) {
+		kfree(dup_name);
+		return rc;
+	}
+
+	__kobject_set_name(kobj, dup_name);
+
+	return 0;
+}
+
+int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
+{
+	struct sysfs_dirent *sd = kobj->sd;
+	struct sysfs_dirent *new_parent_sd = new_parent_kobj->sd;
+
+	if (!new_parent_sd)
+		new_parent_sd = sysfs_root;
+
+	return sysfs_rename(sd, new_parent_sd, NULL);
+}
+
 /*
  * Subsystem file operations.  These operations allow subsystems to
  * have files that can be read/written.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 08ed1b0..f0279a7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -67,6 +67,8 @@ struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
 void sysfs_remove(struct sysfs_dirent *sd);
+int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
+		 const char *new_name);
 
 void sysfs_notify_file(struct sysfs_dirent *sd);
 int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode);
@@ -114,6 +116,13 @@ static inline void sysfs_remove(struct sysfs_dirent *sd)
 {
 }
 
+static inline int sysfs_rename(struct sysfs_dirent *sd,
+			       struct sysfs_dirent *new_parent,
+			       const char *new_name)
+{
+	return 0;
+}
+
 static inline void sysfs_notify_file(struct sysfs_dirent *sd)
 {
 }
-- 
1.5.0.3


