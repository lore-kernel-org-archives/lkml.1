Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXITIIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXITIIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXITIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:58 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33382 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbXITIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=T/tM9Q4pfIHDU/a7DiXdCmuOBWWxhJeDCYc35UHogdGbCOZjjcpX7bNowlRQ5GxipxNqzKZQiql+Rq+vgrojgW+GBj3C8e1xP+/xzHDWXlFvLD+xUxXGXt8Zufq2XkI4oYT0t+qdmCYGCYD3WXi2Y6HjNBWNbg93pFnCrBPDLEI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 06/22] sysfs: restructure addrm helpers
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755391812-git-send-email-htejun@gmail.com>
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

Restruct addrm helpers such that it can remove nodes under different
parents at one go.

sysfs_addrm_start() now doesn't take @sd.  It now only initializes
@acxt and lock sysfs_mutex.  Parent inode lookup now lives in
sysfs_addrm_get_parent_inode() and sysfs_add/remove_one() call them
directly.  The function unlocks i_mutex of the previous inode and
grabs and locks the inode for the specified @parent_sd.  This allows
sysfs_add/remove_one() to be called for any node.

This will be used to recursively remove sysfs nodes.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |  144 +++++++++++++++++++++++++++++++++------------------
 fs/sysfs/file.c    |    4 +-
 fs/sysfs/inode.c   |    2 +-
 fs/sysfs/symlink.c |    4 +-
 fs/sysfs/sysfs.h   |   10 ++--
 5 files changed, 103 insertions(+), 61 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7a6be9a..b1cf090 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -375,6 +375,27 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
+/**
+ *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
+ *	@acxt: pointer to sysfs_addrm_cxt to be used
+ *
+ *	This function is called when the caller is about to add or
+ *	remove sysfs_dirents.  This function initializes @acxt and
+ *	acquires sysfs_mutex.  @acxt is used to keep and pass context
+ *	to other addrm functions.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).  sysfs_mutex is locked on
+ *	return.
+ */
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
+{
+	memset(acxt, 0, sizeof(*acxt));
+	acxt->removed_tail = &acxt->removed;
+
+	mutex_lock(&sysfs_mutex);
+}
+
 static int sysfs_ilookup_test(struct inode *inode, void *arg)
 {
 	struct sysfs_dirent *sd = arg;
@@ -382,39 +403,53 @@ static int sysfs_ilookup_test(struct inode *inode, void *arg)
 }
 
 /**
- *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
- *	@acxt: pointer to sysfs_addrm_cxt to be used
- *	@parent_sd: parent sysfs_dirent
+ *	sysfs_addrm_get_parent_inode - get parent inode for add/rm
+ *	@acxt: addrm context to prepare parent inode for
+ *	@new_parent: parent to prepare (can be NULL)
  *
- *	This function is called when the caller is about to add or
- *	remove sysfs_dirent under @parent_sd.  This function acquires
- *	sysfs_mutex, grabs inode for @parent_sd if available and lock
- *	i_mutex of it.  @acxt is used to keep and pass context to
- *	other addrm functions.
+ *	Release inode of the current @acxt->parent_sd and prepare
+ *	inode of @new_parent.  If @new_parent is NULL, the current
+ *	parent inode is released.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep).  sysfs_mutex is locked on
- *	return.  i_mutex of parent inode is locked on return if
- *	available.
+ *	mutex_lock(sysfs_mutex).  Returns with i_mutex of @new_parent
+ *	locked if available.  sysfs_mutex might be released and
+ *	regrabbed.
+ *
+ *	RETURNS:
+ *	inode of @new_parent if available, NULL otherwise.
  */
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd)
+static struct inode *sysfs_addrm_get_parent_inode(struct sysfs_addrm_cxt *acxt,
+					struct sysfs_dirent *new_parent)
 {
 	struct inode *inode;
 
-	memset(acxt, 0, sizeof(*acxt));
-	acxt->parent_sd = parent_sd;
-	acxt->removed_tail = &acxt->removed;
+	/* nothing to do if new equals current */
+	if (new_parent == acxt->parent_sd)
+		goto out;
+
+	/* if we're holding inode of the current parent, release it */
+	if ((inode = acxt->parent_inode)) {
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
+	}
+
+	acxt->parent_sd = NULL;
+	acxt->parent_inode = NULL;
+
+	if (!new_parent)
+		goto out;
+
+	/* make @new_parent the current one */
+	acxt->parent_sd = new_parent;
 
 	/* Lookup parent inode.  inode initialization and I_NEW
-	 * clearing are protected by sysfs_mutex.  By grabbing it and
-	 * looking up with _nowait variant, inode state can be
+	 * clearing are protected by sysfs_mutex.  By looking up with
+	 * _nowait variant while holding it, inode state can be
 	 * determined reliably.
 	 */
-	mutex_lock(&sysfs_mutex);
-
-	inode = ilookup5_nowait(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
-				parent_sd);
+	inode = ilookup5_nowait(sysfs_sb, new_parent->s_ino, sysfs_ilookup_test,
+				new_parent);
 
 	if (inode && !(inode->i_state & I_NEW)) {
 		/* parent inode available */
@@ -431,16 +466,19 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 		}
 	} else
 		iput(inode);
+ out:
+	return acxt->parent_inode;
 }
 
 /**
  *	sysfs_add_one - add sysfs_dirent to parent
  *	@acxt: addrm context to use
+ *	@parent: parent sysfs_dirent to add sysfs_dirent under
  *	@sd: sysfs_dirent to be added
  *
- *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory and link into the
- *	children list of the parent.
+ *	Get @parent and set sd->s_parent to it and increment nlink of
+ *	parent inode if @sd is a directory and link into the children
+ *	list of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -453,20 +491,26 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
+		  struct sysfs_dirent *sd)
 {
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
-		return -EEXIST;
+	struct inode *parent_inode;
 
-	sd->s_parent = sysfs_get(acxt->parent_sd);
+	if (sysfs_find_dirent(parent, sd->s_name))
+		return -EEXIST;
 
-	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
-		inc_nlink(acxt->parent_inode);
+	parent_inode = sysfs_addrm_get_parent_inode(acxt, parent);
 
-	acxt->cnt++;
+	sd->s_parent = sysfs_get(parent);
 
 	sysfs_link_sibling(sd);
 
+	if (parent_inode) {
+		parent_inode->i_ctime = parent_inode->i_mtime = CURRENT_TIME;
+		if (sysfs_type(sd) == SYSFS_DIR)
+			inc_nlink(parent_inode);
+	}
+
 	return 0;
 }
 
@@ -487,8 +531,12 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct inode *parent_inode;
+
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
+	parent_inode = sysfs_addrm_get_parent_inode(acxt, sd->s_parent);
+
 	sysfs_unlink_sibling(sd);
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
@@ -497,10 +545,11 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	acxt->removed_tail = &sd->s_sibling;
 	*acxt->removed_tail = NULL;
 
-	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
-		drop_nlink(acxt->parent_inode);
-
-	acxt->cnt++;
+	if (parent_inode) {
+		parent_inode->i_ctime = parent_inode->i_mtime = CURRENT_TIME;
+		if (sysfs_type(sd) == SYSFS_DIR)
+			drop_nlink(parent_inode);
+	}
 }
 
 /**
@@ -568,18 +617,11 @@ repeat:
  */
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 {
-	/* release resources acquired by sysfs_addrm_start() */
+	/* Release resources acquired by
+	 * sysfs_addrm_get_parent_inode() and sysfs_addrm_start().
+	 */
+	sysfs_addrm_get_parent_inode(acxt, NULL);
 	mutex_unlock(&sysfs_mutex);
-	if (acxt->parent_inode) {
-		struct inode *inode = acxt->parent_inode;
-
-		/* if added/removed, update timestamps on the parent */
-		if (acxt->cnt)
-			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
-
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
 
 	/* kill removed sysfs_dirents */
 	while (acxt->removed) {
@@ -695,8 +737,8 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd->s_dir.kobj = kobj;
 
 	/* link in */
-	sysfs_addrm_start(&acxt, parent_sd);
-	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_start(&acxt);
+	rc = sysfs_add_one(&acxt, parent_sd, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc == 0)
@@ -778,7 +820,7 @@ static void remove_dir(struct sysfs_dirent *sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
-	sysfs_addrm_start(&acxt, sd->s_parent);
+	sysfs_addrm_start(&acxt);
 	sysfs_remove_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 }
@@ -798,7 +840,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 		return;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	sysfs_addrm_start(&acxt, dir_sd);
+	sysfs_addrm_start(&acxt);
 	pos = &dir_sd->s_dir.children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8d8e1ee..fb77d54 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -581,8 +581,8 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
 
-	sysfs_addrm_start(&acxt, dir_sd);
-	rc = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_start(&acxt);
+	rc = sysfs_add_one(&acxt, dir_sd, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 2210cf0..95bde29 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -214,7 +214,7 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 	if (!dir_sd)
 		return -ENOENT;
 
-	sysfs_addrm_start(&acxt, dir_sd);
+	sysfs_addrm_start(&acxt);
 
 	sd = sysfs_find_dirent(dir_sd, name);
 	if (sd)
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 982085c..897cc2f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -90,8 +90,8 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
-	sysfs_addrm_start(&acxt, parent_sd);
-	error = sysfs_add_one(&acxt, sd);
+	sysfs_addrm_start(&acxt);
+	error = sysfs_add_one(&acxt, parent_sd, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index db1a433..1f3915f 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -66,13 +66,13 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 }
 
 /*
- * Context structure to be used while adding/removing nodes.
+ * Context structure to be used while adding/removing nodes.  Don't
+ * dereference outside of addrm functions.
  */
 struct sysfs_addrm_cxt {
 	struct sysfs_dirent	*parent_sd;
 	struct inode		*parent_inode;
 	struct sysfs_dirent	*removed, **removed_tail;
-	int			cnt;
 };
 
 /*
@@ -97,9 +97,9 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 void sysfs_put_active(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 void sysfs_put_active_two(struct sysfs_dirent *sd);
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd);
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
+		  struct sysfs_dirent *sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
-- 
1.5.0.3


