Return-Path: <linux-kernel-owner+w=401wt.eu-S936892AbXGLAAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936892AbXGLAAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935176AbXGKXhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:20 -0400
Received: from ns.suse.de ([195.135.220.2]:34060 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935147AbXGKXhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/61] sysfs: restructure add/remove paths and fix inode update
Date: Wed, 11 Jul 2007 16:32:16 -0700
Message-Id: <11841970112965-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841970052991-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
 <11841970013184-git-send-email-gregkh@suse.de>
 <11841970052991-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

The original add/remove code had the following problems.

* parent's timestamps are updated on dentry instantiation.  this is
  incorrect with reclaimable files.

* updating parent's timestamps isn't synchronized.

* parent nlink update assumes the inode is accessible which won't be
  true once directory dentries are made reclaimable.

This patch restructures add/remove paths to resolve the above
problems.  Add/removal are done in the following steps.

1. sysfs_addrm_start() : acquire locks including sysfs_mutex and other
   resources.

2-a. sysfs_add_one() : add new sd.  linking the new sd into the
     children list is caller's responsibility.

2-b. sysfs_remove_one() : remove a sd.  unlinking the sd from the
     children list is caller's responsibility.

3. sysfs_addrm_finish() : release all resources and clean up.

Steps 2-a and/or 2-b can be repeated multiple times.

Parent's inode is looked up during sysfs_addrm_start().  If available
(always at the moment), it's pinned and nlink is updated as sd's are
added and removed.  Timestamps are updated during finish if any sd has
been added or removed.  If parent's inode is not available during
start, sysfs_mutex ensures that parent inode is not created till
add/remove is complete.

All the complexity is contained inside the helper functions.
Especially, dentry/inode handling is properly hidden from the rest of
sysfs which now mostly operate on sysfs_dirents.  As an added bonus,
codes which use these helpers to add and remove sysfs_dirents are now
more structured and simpler.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |  250 ++++++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/file.c    |   17 ++--
 fs/sysfs/inode.c   |   46 ++--------
 fs/sysfs/symlink.c |   20 +++--
 fs/sysfs/sysfs.h   |   20 ++++-
 5 files changed, 229 insertions(+), 124 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 9fc8558..edb3062 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -30,7 +30,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	Locking:
  *	mutex_lock(sysfs_mutex)
  */
-static void sysfs_link_sibling(struct sysfs_dirent *sd)
+void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd = sd->s_parent;
 
@@ -49,7 +49,7 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
  *	Locking:
  *	mutex_lock(sysfs_mutex)
  */
-static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
+void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent **pos;
 
@@ -165,7 +165,7 @@ void sysfs_put_active_two(struct sysfs_dirent *sd)
  *
  *	Deny new active references and drain existing ones.
  */
-void sysfs_deactivate(struct sysfs_dirent *sd)
+static void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
@@ -318,27 +318,164 @@ static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
 	d_rehash(dentry);
 }
 
+static int sysfs_ilookup_test(struct inode *inode, void *arg)
+{
+	struct sysfs_dirent *sd = arg;
+	return inode->i_ino == sd->s_ino;
+}
+
 /**
- *	sysfs_attach_dirent - attach sysfs_dirent to its parent and dentry
- *	@sd: sysfs_dirent to attach
- *	@parent_sd: parent to attach to (optional)
- *	@dentry: dentry to be associated to @sd (optional)
+ *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
+ *	@acxt: pointer to sysfs_addrm_cxt to be used
+ *	@parent_sd: parent sysfs_dirent
  *
- *	Attach @sd to @parent_sd and/or @dentry.  Both are optional.
+ *	This function is called when the caller is about to add or
+ *	remove sysfs_dirent under @parent_sd.  This function acquires
+ *	sysfs_mutex, grabs inode for @parent_sd if available and lock
+ *	i_mutex of it.  @acxt is used to keep and pass context to
+ *	other addrm functions.
  *
  *	LOCKING:
- *	mutex_lock(sysfs_mutex)
+ *	Kernel thread context (may sleep).  sysfs_mutex is locked on
+ *	return.  i_mutex of parent inode is locked on return if
+ *	available.
  */
-void sysfs_attach_dirent(struct sysfs_dirent *sd,
-			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
+		       struct sysfs_dirent *parent_sd)
 {
-	if (dentry)
-		sysfs_attach_dentry(sd, dentry);
+	struct inode *inode;
 
-	if (parent_sd) {
-		sd->s_parent = sysfs_get(parent_sd);
-		sysfs_link_sibling(sd);
+	memset(acxt, 0, sizeof(*acxt));
+	acxt->parent_sd = parent_sd;
+
+	/* Lookup parent inode.  inode initialization and I_NEW
+	 * clearing are protected by sysfs_mutex.  By grabbing it and
+	 * looking up with _nowait variant, inode state can be
+	 * determined reliably.
+	 */
+	mutex_lock(&sysfs_mutex);
+
+	inode = ilookup5_nowait(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
+				parent_sd);
+
+	if (inode && !(inode->i_state & I_NEW)) {
+		/* parent inode available */
+		acxt->parent_inode = inode;
+
+		/* sysfs_mutex is below i_mutex in lock hierarchy.
+		 * First, trylock i_mutex.  If fails, unlock
+		 * sysfs_mutex and lock them in order.
+		 */
+		if (!mutex_trylock(&inode->i_mutex)) {
+			mutex_unlock(&sysfs_mutex);
+			mutex_lock(&inode->i_mutex);
+			mutex_lock(&sysfs_mutex);
+		}
+	} else
+		iput(inode);
+}
+
+/**
+ *	sysfs_add_one - add sysfs_dirent to parent
+ *	@acxt: addrm context to use
+ *	@sd: sysfs_dirent to be added
+ *
+ *	Get @acxt->parent_sd and set sd->s_parent to it and increment
+ *	nlink of parent inode if @sd is a directory.  @sd is NOT
+ *	linked into the children list of the parent.  The caller
+ *	should invoke sysfs_link_sibling() after this function
+ *	completes if @sd needs to be on the children list.
+ *
+ *	This function should be called between calls to
+ *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
+ *	passed the same @acxt as passed to sysfs_addrm_start().
+ *
+ *	LOCKING:
+ *	Determined by sysfs_addrm_start().
+ */
+void sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+{
+	sd->s_parent = sysfs_get(acxt->parent_sd);
+
+	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
+		inc_nlink(acxt->parent_inode);
+
+	acxt->cnt++;
+}
+
+/**
+ *	sysfs_remove_one - remove sysfs_dirent from parent
+ *	@acxt: addrm context to use
+ *	@sd: sysfs_dirent to be added
+ *
+ *	Mark @sd removed and drop nlink of parent inode if @sd is a
+ *	directory.  @sd is NOT unlinked from the children list of the
+ *	parent.  The caller is repsonsible for removing @sd from the
+ *	children list before calling this function.
+ *
+ *	This function should be called between calls to
+ *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
+ *	passed the same @acxt as passed to sysfs_addrm_start().
+ *
+ *	LOCKING:
+ *	Determined by sysfs_addrm_start().
+ */
+void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+{
+	BUG_ON(sd->s_sibling || (sd->s_flags & SYSFS_FLAG_REMOVED));
+
+	sd->s_flags |= SYSFS_FLAG_REMOVED;
+	sd->s_sibling = acxt->removed;
+	acxt->removed = sd;
+
+	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
+		drop_nlink(acxt->parent_inode);
+
+	acxt->cnt++;
+}
+
+/**
+ *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
+ *	@acxt: addrm context to finish up
+ *
+ *	Finish up sysfs_dirent add/remove.  Resources acquired by
+ *	sysfs_addrm_start() are released and removed sysfs_dirents are
+ *	cleaned up.  Timestamps on the parent inode are updated.
+ *
+ *	LOCKING:
+ *	All mutexes acquired by sysfs_addrm_start() are released.
+ *
+ *	RETURNS:
+ *	Number of added/removed sysfs_dirents since sysfs_addrm_start().
+ */
+int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
+{
+	/* release resources acquired by sysfs_addrm_start() */
+	mutex_unlock(&sysfs_mutex);
+	if (acxt->parent_inode) {
+		struct inode *inode = acxt->parent_inode;
+
+		/* if added/removed, update timestamps on the parent */
+		if (acxt->cnt)
+			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+
+		mutex_unlock(&inode->i_mutex);
+		iput(inode);
+	}
+
+	/* kill removed sysfs_dirents */
+	while (acxt->removed) {
+		struct sysfs_dirent *sd = acxt->removed;
+
+		acxt->removed = sd->s_sibling;
+		sd->s_sibling = NULL;
+
+		sysfs_drop_dentry(sd);
+		sysfs_deactivate(sd);
+		sysfs_put(sd);
 	}
+
+	return acxt->cnt;
 }
 
 /**
@@ -396,19 +533,20 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
 	struct dentry *parent = parent_sd->s_dentry;
+	struct sysfs_addrm_cxt acxt;
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 	struct dentry *dentry;
 	struct inode *inode;
 	struct sysfs_dirent *sd;
 
-	mutex_lock(&parent->d_inode->i_mutex);
+	sysfs_addrm_start(&acxt, parent_sd);
 
 	/* allocate */
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out_unlock;
+		goto out_finish;
 	}
 
 	error = -EEXIST;
@@ -433,23 +571,18 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	}
 
 	/* link in */
-	mutex_lock(&sysfs_mutex);
-
 	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name)) {
-		mutex_unlock(&sysfs_mutex);
+	if (sysfs_find_dirent(parent_sd, name))
 		goto out_iput;
-	}
 
+	sysfs_add_one(&acxt, sd);
+	sysfs_link_sibling(sd);
 	sysfs_instantiate(dentry, inode);
-	inc_nlink(parent->d_inode);
-	sysfs_attach_dirent(sd, parent_sd, dentry);
-
-	mutex_unlock(&sysfs_mutex);
+	sysfs_attach_dentry(sd, dentry);
 
 	*p_sd = sd;
 	error = 0;
-	goto out_unlock;	/* pin directory dentry in core */
+	goto out_finish;	/* pin directory dentry in core */
 
  out_iput:
 	iput(inode);
@@ -459,8 +592,8 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	d_drop(dentry);
  out_dput:
 	dput(dentry);
- out_unlock:
-	mutex_unlock(&parent->d_inode->i_mutex);
+ out_finish:
+	sysfs_addrm_finish(&acxt);
 	return error;
 }
 
@@ -561,16 +694,12 @@ const struct inode_operations sysfs_dir_inode_operations = {
 
 static void remove_dir(struct sysfs_dirent *sd)
 {
-	mutex_lock(&sysfs_mutex);
-	sysfs_unlink_sibling(sd);
-	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	mutex_unlock(&sysfs_mutex);
+	struct sysfs_addrm_cxt acxt;
 
-	pr_debug(" o %s removing done\n", sd->s_name);
-
-	sysfs_drop_dentry(sd);
-	sysfs_deactivate(sd);
-	sysfs_put(sd);
+	sysfs_addrm_start(&acxt, sd->s_parent);
+	sysfs_unlink_sibling(sd);
+	sysfs_remove_one(&acxt, sd);
+	sysfs_addrm_finish(&acxt);
 }
 
 void sysfs_remove_subdir(struct sysfs_dirent *sd)
@@ -581,38 +710,26 @@ void sysfs_remove_subdir(struct sysfs_dirent *sd)
 
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
-	struct sysfs_dirent *removed = NULL;
+	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent **pos;
 
 	if (!dir_sd)
 		return;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	mutex_lock(&sysfs_mutex);
+	sysfs_addrm_start(&acxt, dir_sd);
 	pos = &dir_sd->s_children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
 		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
-			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
-			sd->s_sibling = removed;
-			removed = sd;
+			sd->s_sibling = NULL;
+			sysfs_remove_one(&acxt, sd);
 		} else
 			pos = &(*pos)->s_sibling;
 	}
-	mutex_unlock(&sysfs_mutex);
-
-	while (removed) {
-		struct sysfs_dirent *sd = removed;
-
-		removed = sd->s_sibling;
-		sd->s_sibling = NULL;
-
-		sysfs_drop_dentry(sd);
-		sysfs_deactivate(sd);
-		sysfs_put(sd);
-	}
+	sysfs_addrm_finish(&acxt);
 
 	remove_dir(dir_sd);
 }
@@ -772,7 +889,8 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 	sd = sysfs_new_dirent("_DIR_", 0, 0);
 	if (sd) {
 		mutex_lock(&sysfs_mutex);
-		sysfs_attach_dirent(sd, parent_sd, NULL);
+		sd->s_parent = sysfs_get(parent_sd);
+		sysfs_link_sibling(sd);
 		mutex_unlock(&sysfs_mutex);
 	}
 
@@ -957,6 +1075,7 @@ struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 	struct sysfs_dirent *parent_sd = parent->d_fsdata;
 	struct dentry *shadow;
 	struct sysfs_dirent *sd;
+	struct sysfs_addrm_cxt acxt;
 
 	sd = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
@@ -970,15 +1089,18 @@ struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 	if (!sd)
 		goto nomem;
 	sd->s_elem.dir.kobj = kobj;
-	/* point to parent_sd but don't attach to it */
-	sd->s_parent = sysfs_get(parent_sd);
-	mutex_lock(&sysfs_mutex);
-	sysfs_attach_dirent(sd, NULL, shadow);
-	mutex_unlock(&sysfs_mutex);
 
+	sysfs_addrm_start(&acxt, parent_sd);
+
+	/* add but don't link into children list */
+	sysfs_add_one(&acxt, sd);
+
+	/* attach and instantiate dentry */
+	sysfs_attach_dentry(sd, shadow);
 	d_instantiate(shadow, igrab(inode));
-	inc_nlink(inode);
-	inc_nlink(parent->d_inode);
+	inc_nlink(inode);	/* tj: synchronization? */
+
+	sysfs_addrm_finish(&acxt);
 
 	dget(shadow);		/* Extra count - pin the dentry in core */
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d0deed3..69bacf1 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -416,6 +416,7 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		   int type)
 {
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
+	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 
 	sd = sysfs_new_dirent(attr->name, mode, type);
@@ -423,20 +424,18 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		return -ENOMEM;
 	sd->s_elem.attr.attr = (void *)attr;
 
-	mutex_lock(&sysfs_mutex);
+	sysfs_addrm_start(&acxt, dir_sd);
 
 	if (!sysfs_find_dirent(dir_sd, attr->name)) {
-		sysfs_attach_dirent(sd, dir_sd, NULL);
-		sd = NULL;
+		sysfs_add_one(&acxt, sd);
+		sysfs_link_sibling(sd);
 	}
 
-	mutex_unlock(&sysfs_mutex);
+	if (sysfs_addrm_finish(&acxt))
+		return 0;
 
-	if (sd) {
-		sysfs_put(sd);
-		return -EEXIST;
-	}
-	return 0;
+	sysfs_put(sd);
+	return -EEXIST;
 }
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index d439c0b..f959668 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -191,15 +191,9 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	BUG_ON(!dentry || dentry->d_inode);
 
-	if (inode->i_state & I_NEW) {
+	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 
-		if (dentry->d_parent && dentry->d_parent->d_inode) {
-			struct inode *p_inode = dentry->d_parent->d_inode;
-			p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
-		}
-	}
-
 	d_instantiate(dentry, inode);
 }
 
@@ -220,7 +214,6 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 void sysfs_drop_dentry(struct sysfs_dirent *sd)
 {
 	struct dentry *dentry = NULL;
-	struct timespec curtime;
 	struct inode *inode;
 
 	/* We're not holding a reference to ->s_dentry dentry but the
@@ -246,13 +239,11 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 		dput(dentry);
 
 	/* adjust nlink and update timestamp */
-	curtime = CURRENT_TIME;
-
 	inode = ilookup(sysfs_sb, sd->s_ino);
 	if (inode) {
 		mutex_lock(&inode->i_mutex);
 
-		inode->i_ctime = curtime;
+		inode->i_ctime = CURRENT_TIME;
 		drop_nlink(inode);
 		if (sysfs_type(sd) == SYSFS_DIR)
 			drop_nlink(inode);
@@ -260,30 +251,17 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 		mutex_unlock(&inode->i_mutex);
 		iput(inode);
 	}
-
-	/* adjust nlink and udpate timestamp of the parent */
-	inode = ilookup(sysfs_sb, sd->s_parent->s_ino);
-	if (inode) {
-		mutex_lock(&inode->i_mutex);
-
-		inode->i_ctime = inode->i_mtime = curtime;
-		if (sysfs_type(sd) == SYSFS_DIR)
-			drop_nlink(inode);
-
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
 }
 
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
+	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent **pos, *sd;
-	int found = 0;
 
 	if (!dir_sd)
 		return -ENOENT;
 
-	mutex_lock(&sysfs_mutex);
+	sysfs_addrm_start(&acxt, dir_sd);
 
 	for (pos = &dir_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
@@ -291,22 +269,14 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 		if (!sysfs_type(sd))
 			continue;
 		if (!strcmp(sd->s_name, name)) {
-			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
-			found = 1;
+			sysfs_remove_one(&acxt, sd);
 			break;
 		}
 	}
 
-	mutex_unlock(&sysfs_mutex);
-
-	if (!found)
-		return -ENOENT;
-
-	sysfs_drop_dentry(sd);
-	sysfs_deactivate(sd);
-	sysfs_put(sd);
-
-	return 0;
+	if (sysfs_addrm_finish(&acxt))
+		return 0;
+	return -ENOENT;
 }
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 683316f..2f86e04 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -55,6 +55,7 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
+	struct sysfs_addrm_cxt acxt;
 	int error;
 
 	BUG_ON(!name);
@@ -87,17 +88,18 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		goto out_put;
 	sd->s_elem.symlink.target_sd = target_sd;
 
-	mutex_lock(&sysfs_mutex);
-	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name))
-		goto out_unlock;
-	sysfs_attach_dirent(sd, parent_sd, NULL);
-	mutex_unlock(&sysfs_mutex);
+	sysfs_addrm_start(&acxt, parent_sd);
 
-	return 0;
+	if (!sysfs_find_dirent(parent_sd, name)) {
+		sysfs_add_one(&acxt, sd);
+		sysfs_link_sibling(sd);
+	}
 
- out_unlock:
-	mutex_unlock(&sysfs_mutex);
+	if (sysfs_addrm_finish(&acxt))
+		return 0;
+
+	error = -EEXIST;
+	/* fall through */
  out_put:
 	sysfs_put(target_sd);
 	sysfs_put(sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2605161..3e9a5ee 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -44,14 +44,29 @@ struct sysfs_dirent {
 
 #define SD_DEACTIVATED_BIAS	INT_MIN
 
+struct sysfs_addrm_cxt {
+	struct sysfs_dirent	*parent_sd;
+	struct inode		*parent_inode;
+	struct sysfs_dirent	*removed;
+	int			cnt;
+};
+
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
+extern void sysfs_link_sibling(struct sysfs_dirent *sd);
+extern void sysfs_unlink_sibling(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 extern void sysfs_put_active(struct sysfs_dirent *sd);
 extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 extern void sysfs_put_active_two(struct sysfs_dirent *sd);
-extern void sysfs_deactivate(struct sysfs_dirent *sd);
+extern void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
+			      struct sysfs_dirent *parent_sd);
+extern void sysfs_add_one(struct sysfs_addrm_cxt *acxt,
+			  struct sysfs_dirent *sd);
+extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
+			     struct sysfs_dirent *sd);
+extern int sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
@@ -65,9 +80,6 @@ extern struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 					     const unsigned char *name);
 extern struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode,
 					     int type);
-extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
-				struct sysfs_dirent *parent_sd,
-				struct dentry *dentry);
 
 extern int sysfs_add_file(struct sysfs_dirent *dir_sd,
 			  const struct attribute *attr, int type);
-- 
1.5.2.2

