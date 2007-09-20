Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbXITIdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbXITIdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXITIby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12629 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbXITIbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=pcNVkwCyw2Mkq1Jh9nulj84QKRWZuENp8OVBaw5LzgW3VWCTD1zsL7K8JwzfhETJaUaEYJF5onv+oIqYJrIfXl/M5BCtdNUmccqJIVGfLqOESl/ztrhvrjzhWK98zPPW1GdsN9lKhLUurKtU0R6CLBhCZ/a0a34BeQeYEkADULI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 7/8] sysfs: implement batch error handling
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <11902770983349-git-send-email-htejun@gmail.com>
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

Batch error handling is to be used with plugged creation.  It
accumulates any error condition which happens under a plugged node and
let the user handle error once right before unplugging.  This easily
replaces attribute group creation.

Batch error handling works by the following two mechanisms.

* When an error occurs, tree is walked toward the top and, if there
  are plugged nodes which don't have plugged error recorded yet,
  sd->s_batch_error is set before returning the error code.

* All interface funtions allow ERR_PTR value to be passed as
  sysfs_dirent arguments and return -EBADF if that happens.

* After all the operations are complete, the user calls
  sysfs_check_batch_error() on the plugged node (usually the top one)
  which returns 0 if there hasn't been any error or error code of the
  first error.

* The user unplugs or removes the node accordingly.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c        |    8 +++-
 fs/sysfs/dir.c        |  137 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/sysfs/file.c       |   12 ++++-
 fs/sysfs/symlink.c    |    7 +++
 fs/sysfs/sysfs.h      |   12 ++++-
 include/linux/sysfs.h |    6 ++
 6 files changed, 173 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d6cc7b3..1f705d2 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -231,10 +231,16 @@ struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 {
 	struct sysfs_dirent *sd;
 
+	/* for batch error handling */
+	if (IS_ERR(parent))
+		return ERR_PTR(-EBADF);
+
 	/* allocate and initialize */
 	sd = sysfs_new_dirent(name, mode, SYSFS_BIN);
-	if (!sd)
+	if (!sd) {
+		sysfs_set_batch_error(parent, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	sd->s_bin.ops = bops;
 	sd->s_bin.size = size;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 88ec749..f18da1b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -305,7 +305,12 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	if (sd->s_flags & SYSFS_FLAG_LINK_NAME_FMT_COPIED)
 		kfree(sd->s_link.name_fmt);
 
-	kfree(sd->s_iattr);
+	/* s_batch_error shares room with s_iattr.  If plugged, it's
+	 * s_batch_error; otherwise, s_iattr.
+	 */
+	if (!(sd->s_flags & SYSFS_FLAG_PLUGGED))
+		kfree(sd->s_iattr);
+
 	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
@@ -722,6 +727,7 @@ struct sysfs_dirent *sysfs_insert_one(struct sysfs_dirent *parent,
 
 	if (rc) {
 		sysfs_put(sd);
+		sysfs_set_batch_error(parent, rc);
 		return ERR_PTR(rc);
 	}
 
@@ -804,6 +810,10 @@ struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 {
 	struct sysfs_dirent *sd;
 
+	/* for batch error handling */
+	if (IS_ERR(parent))
+		return ERR_PTR(-EBADF);
+
 	mutex_lock(&sysfs_mutex);
 	sd = sysfs_find_dirent(parent, name);
 	mutex_unlock(&sysfs_mutex);
@@ -837,10 +847,16 @@ struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 {
 	struct sysfs_dirent *sd;
 
+	/* for plugged error handling */
+	if (IS_ERR(parent))
+		return ERR_PTR(-EBADF);
+
 	/* allocate and initialize */
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
-	if (!sd)
+	if (!sd) {
+		sysfs_set_batch_error(parent, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	sd->s_dir.data = data;
 
@@ -849,6 +865,71 @@ struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 EXPORT_SYMBOL_GPL(sysfs_add_dir);
 
 /**
+ *	sysfs_set_batch_error - record batch error
+ *	@sd: sysfs_dirent which failed operation
+ *	@error: error value
+ *
+ *	If @error is an error value, find all plugging ancestors and
+ *	record batch error status if this is the first error in the
+ *	subtree.  Note that only the first error behind a plugged node
+ *	is recorded.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).  Uses sysfs_mutex.
+ */
+void sysfs_set_batch_error(struct sysfs_dirent *sd, int error)
+{
+	if (!IS_ERR_VALUE(error))
+		return;
+
+	mutex_lock(&sysfs_mutex);
+
+	for ( ; sd; sd = sd->s_parent) {
+		if (!(sd->s_flags & SYSFS_FLAG_PLUGGED) || sd->s_batch_error) {
+			BUG_ON(sd->s_batch_error &&
+			       !IS_ERR_VALUE(sd->s_batch_error));
+			continue;
+		}
+
+		/* s_iattr must be unused at this point */
+		BUG_ON(sd->s_iattr);
+		sd->s_batch_error = error;
+	}
+
+	mutex_unlock(&sysfs_mutex);
+}
+
+/**
+ *	sysfs_check_batch_error - check batch error
+ *	@sd: sysfs_dirent to check batch error for
+ *
+ *	Check whether any error has occurred on a plugged node @sd and
+ *	the nodes behind it.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	0 if there hasn't been any batch error, -errno if it had one
+ *	or more batch errors.  -errno is from the first batch error.
+ */
+int sysfs_check_batch_error(struct sysfs_dirent *sd)
+{
+	int error = 0;
+
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+
+	if (sd->s_batch_error) {
+		error = sd->s_batch_error;
+		BUG_ON(!IS_ERR_VALUE(error));
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_check_batch_error);
+
+/**
  *	sysfs_unplug - unplug a plugged sysfs_dirent
  *	@sd: sysfs_dirent to unplug
  *
@@ -858,12 +939,19 @@ EXPORT_SYMBOL_GPL(sysfs_add_dir);
  *	userland.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep).  Uses sysfs_mutex.
+ *	Kernel thread context (may sleep).  Uses sysfs_op_mutex and
+ *	sysfs_mutex.
  */
 void sysfs_unplug(struct sysfs_dirent *sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
+	/* This happens when creation of the top node failed but the
+	 * user want to ignore it.  Do nothing.
+	 */
+	if (IS_ERR(sd))
+		return;
+
 	/* Unplugging performs parent inode update delayed from
 	 * add/removal.  Also, sysfs_op_mutex grabbed by addrm_start
 	 * guarantees renaming to see consistent plugged status.
@@ -876,6 +964,12 @@ void sysfs_unplug(struct sysfs_dirent *sd)
 
 		sd->s_flags &= ~SYSFS_FLAG_PLUGGED;
 
+		/* s_batch_error shares room with s_iattr, make sure
+		 * it's NULL.
+		 */
+		BUG_ON(sd->s_batch_error && !IS_ERR_VALUE(sd->s_batch_error));
+		sd->s_iattr = NULL;
+
 		if (parent_inode) {
 			parent_inode->i_ctime =
 			parent_inode->i_mtime = CURRENT_TIME;
@@ -1036,8 +1130,8 @@ void __sysfs_remove(struct sysfs_dirent *sd, int recurse)
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *cur, *next;
 
-	/* noop on NULL */
-	if (!sd)
+	/* noop on NULL and ERR_PTR, the latter is for batch error handling */
+	if (!sd || IS_ERR(sd))
 		return;
 
 	sysfs_addrm_start(&acxt);
@@ -1223,6 +1317,18 @@ static int sysfs_rcxt_get_dentries(struct sysfs_rename_context *rcxt,
 	struct dentry *old_dentry, *new_parent_dentry, *new_dentry;
 	int rc;
 
+	/* If sd is plugged currently and will stay plugged under the
+	 * new parent, dentries are guaranteed to not exist and stay
+	 * that way till rename is complete (op mutex released) and
+	 * there's nothing to do regarding dentries.
+	 *
+	 * Changing plugged status by moving isn't allowed and this
+	 * function will fail later if the user tries to do that.
+	 */
+	if (sysfs_plugged(rent->sd, NULL) &&
+	    sysfs_plugged(rent->sd, rent->new_parent))
+		return 0;
+
 	/* get old dentry */
 	old_dentry = sysfs_get_dentry(rent->sd);
 	if (IS_ERR(old_dentry))
@@ -1424,6 +1530,10 @@ int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 	struct sysfs_rcxt_rename_ent *rent;
 	int error;
 
+	/* for batch error handling */
+	if (IS_ERR(sd) || IS_ERR(new_parent))
+		return -EBADF;
+
 	mutex_lock(&sysfs_op_mutex);
 
 	if (!new_parent)
@@ -1463,6 +1573,12 @@ int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 			sysfs_link_sibling(rent->sd);
 		}
 
+		/* no dentry, no inode - this happens for plugged rename */
+		if (!rent->old_dentry) {
+			WARN_ON(rent->new_dentry);
+			continue;
+		}
+
 		/* update dcache and inode accordingly */
 		if (sysfs_type(rent->sd) == SYSFS_DIR) {
 			drop_nlink(rent->old_dentry->d_parent->d_inode);
@@ -1479,6 +1595,8 @@ int sysfs_rename(struct sysfs_dirent *sd, struct sysfs_dirent *new_parent,
 	sysfs_post_rename(&rcxt, error);
  out:
 	mutex_unlock(&sysfs_op_mutex);
+	sysfs_set_batch_error(sd, error);
+	sysfs_set_batch_error(new_parent, error);
 	return error;
 }
 EXPORT_SYMBOL_GPL(sysfs_rename);
@@ -1498,11 +1616,17 @@ EXPORT_SYMBOL_GPL(sysfs_rename);
  */
 int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
 {
-	mode_t new_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
 	struct dentry *dentry = NULL;
 	struct inode *inode = NULL;
+	mode_t new_mode;
 	int rc = 0;
 
+	/* for batch error handling */
+	if (IS_ERR(sd))
+		return -EBADF;
+
+	new_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
+
 	mutex_lock(&sysfs_op_mutex);
 
 	/* If @sd is plugged, dentry and inode aren't there and can't
@@ -1537,6 +1661,7 @@ int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
  out_unlock_op:
 	mutex_unlock(&sysfs_op_mutex);
 	dput(dentry);
+	sysfs_set_batch_error(sd, rc);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1d93940..3412732 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -498,6 +498,10 @@ void sysfs_notify_file(struct sysfs_dirent *sd)
 {
 	struct sysfs_open_dirent *od;
 
+	/* for batch error handling */
+	if (IS_ERR(sd))
+		return;
+
 	BUG_ON(sysfs_type(sd) != SYSFS_FILE);
 
 	spin_lock(&sysfs_open_dirent_lock);
@@ -545,10 +549,16 @@ struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
 {
 	struct sysfs_dirent *sd;
 
+	/* for batch error handling */
+	if (IS_ERR(parent))
+		return ERR_PTR(-EBADF);
+
 	/* allocate and initialize */
 	sd = sysfs_new_dirent(name, mode, SYSFS_FILE);
-	if (!sd)
+	if (!sd) {
+		sysfs_set_batch_error(parent, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	sd->s_file.ops = fops;
 	sd->s_file.data = data;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 53cc8a6..7e0fd89 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -217,6 +217,10 @@ struct sysfs_dirent *__sysfs_add_link(struct sysfs_dirent *parent,
 	struct sysfs_addrm_cxt acxt;
 	int rc;
 
+	/* for batch error handling */
+	if (IS_ERR(parent) || IS_ERR(target))
+		return ERR_PTR(-EBADF);
+
 	/* acquire locks early for link name formatting */
 	sysfs_addrm_start(&acxt);
 
@@ -280,6 +284,9 @@ struct sysfs_dirent *__sysfs_add_link(struct sysfs_dirent *parent,
 		kfree(name_fmt);
 	if (flags & SYSFS_FLAG_NAME_COPIED)
 		kfree(name);
+
+	sysfs_set_batch_error(parent, rc);
+	sysfs_set_batch_error(target, rc);
 	return ERR_PTR(rc);
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 51f346d..ec0b308 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -52,7 +52,15 @@ struct sysfs_dirent {
 	unsigned int		s_flags;
 	ino_t			s_ino;
 	umode_t			s_mode;
-	struct iattr		*s_iattr;
+
+	/* Make s_iattr and s_batch_error share the room.  This is
+	 * okay because s_iattr is used only after a node is unplugged
+	 * while s_batch_error is used only while a node is plugged.
+	 */
+	union {
+		struct iattr		*s_iattr;
+		int			s_batch_error;
+	};
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -120,6 +128,8 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 				      const unsigned char *name);
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
 
+void sysfs_set_batch_error(struct sysfs_dirent *sd, int error);
+
 void __sysfs_remove(struct sysfs_dirent *sd, int recurse);
 
 void release_sysfs_dirent(struct sysfs_dirent *sd);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5a8c9f1..a8dfc6b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -64,6 +64,7 @@ struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
 			const char *name_fmt, mode_t mode,
 			struct sysfs_dirent *target);
+int sysfs_check_batch_error(struct sysfs_dirent *sd);
 void sysfs_unplug(struct sysfs_dirent *sd);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
@@ -108,6 +109,11 @@ static inline struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline int sysfs_check_batch_error(struct sysfs_dirent *sd)
+{
+	return 0;
+}
+
 static inline void sysfs_unplug(struct sysfs_dirent *sd)
 {
 }
-- 
1.5.0.3


