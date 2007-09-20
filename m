Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXITIdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXITIdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbXITIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:12702 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbXITIbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=LbunXpaUFMBNO8gE6L7yyVGxIJovJgz1M01oXpRo48BpD2r1xo7Zv42GYMK3y3tRPpdPM/kYCQm6VbOz69XnFZbffz4yQGAde1t5EfuYyAMsaeNeovXR9jg2Jn+jCxhcfg+bdetpK17h/CDblH91M1y5oylq97x0ZKIWYs/rnfQ=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 6/8] sysfs: implement plugged creation of sysfs nodes
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <11902770983006-git-send-email-htejun@gmail.com>
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

This patch implements plugged creation of sysfs nodes.  If
SYSFS_PLUGGED is specified to any of sysfs_add_*() functions, the
node, its children which get added under it and symlinks pointing to
it or its children won't be visible from userland - lookup and
directory listing won't show them, until the plugged node is
unplugged using sysfs_unplug().

This will be used to prevent userland from seeing sysfs hierarchy for
certain entity (device or whatever) appear piece-by-piece.  Also,
initialization failure won't be visible on userland.  Everything
including inode nlinks are handled properly.

This will be later combined with uevent_suppress.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |  165 +++++++++++++++++++++++++++++++++++++++++--------
 fs/sysfs/inode.c      |    3 +-
 fs/sysfs/sysfs.h      |    2 +
 include/linux/sysfs.h |    8 ++-
 4 files changed, 149 insertions(+), 29 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index eac8fef..88ec749 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -118,8 +118,15 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 		/* look it up */
 		parent = dentry;
 		mutex_lock(&parent->d_inode->i_mutex);
+
 		dentry = lookup_one_len_kern(cur->s_name, parent,
 					     strlen(cur->s_name));
+		/* negative dentry means @sd is plugged, return -ENOENT */
+		if (!dentry->d_inode) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+		}
+
 		mutex_unlock(&parent->d_inode->i_mutex);
 		dput(parent);
 
@@ -322,12 +329,13 @@ static struct dentry_operations sysfs_dentry_ops = {
 /**
  *	sysfs_new_dirent - allocate and initialize sysfs_dirent
  *	@name: name for the new sysfs_dirent
- *	@mode: mask of bits from S_IRWXUGO | SYSFS_COPY_NAME
+ *	@mode: mask of bits from S_IRWXUGO | SYSFS_COPY_NAME | SYSFS_PLUGGED
  *	@type: one of SYSFS_{DIR|FILE|BIN|LINK}
  *
  *	Allocate and initialize a sysfs_dirent with the specified
  *	parameters.  If SYSFS_COPY_NAME is specified in @mode, @name
- *	is duplicated.
+ *	is duplicated.  If SYSFS_PLUGGED is set, the node is
+ *	initialized into plugged state.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -351,6 +359,10 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 		flags |= SYSFS_FLAG_NAME_COPIED;
 	}
 
+	/* start plugged? */
+	if (mode & SYSFS_PLUGGED)
+		flags |= SYSFS_FLAG_PLUGGED;
+
 	/* normalize mode */
 	mode &= S_IALLUGO;
 
@@ -512,12 +524,14 @@ static struct inode *sysfs_addrm_get_parent_inode(struct sysfs_addrm_cxt *acxt,
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
 		  struct sysfs_dirent *sd)
 {
-	struct inode *parent_inode;
+	struct inode *parent_inode = NULL;
 
 	if (sysfs_find_dirent(parent, sd->s_name))
 		return -EEXIST;
 
-	parent_inode = sysfs_addrm_get_parent_inode(acxt, parent);
+	/* if plugged, don't update parent inode, will be updated on unplug */
+	if (!(sd->s_flags & SYSFS_FLAG_PLUGGED))
+		parent_inode = sysfs_addrm_get_parent_inode(acxt, parent);
 
 	sd->s_parent = sysfs_get(parent);
 
@@ -555,11 +569,13 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	struct inode *parent_inode;
+	struct inode *parent_inode = NULL;
 
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
-	parent_inode = sysfs_addrm_get_parent_inode(acxt, sd->s_parent);
+	/* if plugged, don't update parent inode, will be updated on unplug */
+	if (!(sd->s_flags & SYSFS_FLAG_PLUGGED))
+		parent_inode = sysfs_addrm_get_parent_inode(acxt, sd->s_parent);
 
 	if (sd->s_flags & SYSFS_FLAG_LINK_CHAINED) {
 		struct sysfs_dirent *target = sd->s_link.target;
@@ -805,7 +821,9 @@ EXPORT_SYMBOL_GPL(sysfs_find_child);
  *
  *	Add a new directory under @parent with the specified
  *	parameters.  If SYSFS_COPY_NAME is set in @mode, @name is
- *	copied before being used.
+ *	copied before being used.  If SYSFS_PLUGGED is set in @mode,
+ *	the new directory will start plugged (won't be visible till
+ *	unplugged).
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -830,6 +848,84 @@ struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 }
 EXPORT_SYMBOL_GPL(sysfs_add_dir);
 
+/**
+ *	sysfs_unplug - unplug a plugged sysfs_dirent
+ *	@sd: sysfs_dirent to unplug
+ *
+ *	A plugged sysfs_dirent isn't visible to userland.  As are all
+ *	its children and symlinks point to the sysfs_dirent or its
+ *	children.  This function unplugs @sd and makes it visible to
+ *	userland.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).  Uses sysfs_mutex.
+ */
+void sysfs_unplug(struct sysfs_dirent *sd)
+{
+	struct sysfs_addrm_cxt acxt;
+
+	/* Unplugging performs parent inode update delayed from
+	 * add/removal.  Also, sysfs_op_mutex grabbed by addrm_start
+	 * guarantees renaming to see consistent plugged status.
+	 */
+	sysfs_addrm_start(&acxt);
+
+	if (sd->s_flags & SYSFS_FLAG_PLUGGED) {
+		struct inode *parent_inode =
+			sysfs_addrm_get_parent_inode(&acxt, sd->s_parent);
+
+		sd->s_flags &= ~SYSFS_FLAG_PLUGGED;
+
+		if (parent_inode) {
+			parent_inode->i_ctime =
+			parent_inode->i_mtime = CURRENT_TIME;
+
+			if (sysfs_type(sd) == SYSFS_DIR)
+				inc_nlink(parent_inode);
+		}
+	}
+
+	sysfs_addrm_finish(&acxt);
+}
+EXPORT_SYMBOL_GPL(sysfs_unplug);
+
+static int sysfs_plugged(struct sysfs_dirent *sd,
+			 struct sysfs_dirent *new_parent)
+{
+	struct sysfs_dirent *cur;
+
+	/* @sd itself is plugged? */
+	if (sd->s_flags & SYSFS_FLAG_PLUGGED)
+		return 1;
+
+	/* Parent override for renaming.  This is used to determine
+	 * whether @sd will be plugged when moved under @new_parent.
+	 */
+	if (!new_parent)
+		new_parent = sd->s_parent;
+
+	/* is one of @sd's acnestors plugged? */
+	for (cur = new_parent; cur; cur = cur->s_parent)
+		if (cur->s_flags & SYSFS_FLAG_PLUGGED)
+			return 1;
+
+	/* A symlink is plugged if its target is plugged.  Check
+	 * whether the target is plugged unless the symlink is known
+	 * to be unplugged.
+	 */
+	if (sysfs_type(sd) != SYSFS_LINK ||
+	    (sd->s_flags & SYSFS_FLAG_LINK_UNPLUGGED))
+		return 0;
+
+	for (cur = sd->s_link.target; cur; cur = cur->s_parent)
+		if (cur->s_flags & SYSFS_FLAG_PLUGGED)
+			return 1;
+
+	/* if unplugged, mark it to accelerate future plugged test */
+	sd->s_flags |= SYSFS_FLAG_LINK_UNPLUGGED;
+	return 0;
+}
+
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
@@ -842,8 +938,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name);
 
-	/* no such entry */
-	if (!sd)
+	/* no such entry or plugged */
+	if (unlikely(!sd || sysfs_plugged(sd, NULL)))
 		goto out_unlock;
 
 	/* attach dentry and inode */
@@ -1021,6 +1117,10 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			const char * name;
 			int len;
 
+			/* skip plugged nodes */
+			if (unlikely(sysfs_plugged(pos, NULL)))
+				continue;
+
 			name = pos->s_name;
 			len = strlen(name);
 			filp->f_pos = ino = pos->s_ino;
@@ -1398,33 +1498,44 @@ EXPORT_SYMBOL_GPL(sysfs_rename);
  */
 int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
 {
-	struct dentry *dentry;
-	struct inode *inode;
-	struct iattr newattrs;
-	int rc;
+	mode_t new_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
+	struct dentry *dentry = NULL;
+	struct inode *inode = NULL;
+	int rc = 0;
 
 	mutex_lock(&sysfs_op_mutex);
-	dentry = sysfs_get_dentry(sd);
-	mutex_unlock(&sysfs_op_mutex);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
 
-	inode = dentry->d_inode;
+	/* If @sd is plugged, dentry and inode aren't there and can't
+	 * be looked up.  Just update @sd->s_mode.
+	 */
+	if (!sysfs_plugged(sd, NULL)) {
+		struct iattr newattrs;
 
-	mutex_lock(&inode->i_mutex);
+		dentry = sysfs_get_dentry(sd);
+		if (IS_ERR(dentry)) {
+			rc = PTR_ERR(dentry);
+			goto out_unlock_op;
+		}
+		inode = dentry->d_inode;
 
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(dentry, &newattrs);
+		mutex_lock(&inode->i_mutex);
 
-	if (rc == 0) {
-		mutex_lock(&sysfs_mutex);
-		sd->s_mode = newattrs.ia_mode;
-		mutex_unlock(&sysfs_mutex);
+		newattrs.ia_mode = new_mode;
+		newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+		rc = notify_change(dentry, &newattrs);
+		if (rc)
+			goto out_unlock_inode;
 	}
 
-	mutex_unlock(&inode->i_mutex);
+	mutex_lock(&sysfs_mutex);
+	sd->s_mode = new_mode;
+	mutex_unlock(&sysfs_mutex);
 
+ out_unlock_inode:
+	if (inode)
+		mutex_unlock(&inode->i_mutex);
+ out_unlock_op:
+	mutex_unlock(&sysfs_op_mutex);
 	dput(dentry);
 	return rc;
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 0aeea4b..bd61cca 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -128,7 +128,8 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 	int nr = 0;
 
 	for (child = sd->s_dir.children; child; child = child->s_sibling)
-		if (sysfs_type(child) == SYSFS_DIR)
+		if (sysfs_type(child) == SYSFS_DIR &&
+		    !(child->s_flags & SYSFS_FLAG_PLUGGED))
 			nr++;
 
 	return nr + 2;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f704279..51f346d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -64,10 +64,12 @@ struct sysfs_dirent {
 #define SYSFS_LINK			0x0008
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_PLUGGED		0x0100
 #define SYSFS_FLAG_REMOVED		0x0200
 #define SYSFS_FLAG_NAME_COPIED		0x0400
 #define SYSFS_FLAG_LINK_NAME_FMT_COPIED	0x0800
 #define SYSFS_FLAG_LINK_CHAINED		0x1000
+#define SYSFS_FLAG_LINK_UNPLUGGED	0x2000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5afe3bd..5a8c9f1 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -30,9 +30,10 @@ struct vm_area_struct;
  */
 #define SYSFS_DIR_MODE		(S_IRWXU | S_IRUGO | S_IXUGO)
 #define SYSFS_COPY_NAME		010000	/* copy passed @name[_fmt] */
+#define SYSFS_PLUGGED		020000	/* plug the node on creation */
 
 /* collection of all flags for verification */
-#define SYSFS_MODE_FLAGS	SYSFS_COPY_NAME
+#define SYSFS_MODE_FLAGS	(SYSFS_COPY_NAME | SYSFS_PLUGGED)
 
 struct sysfs_file_ops {
 	ssize_t (*show)(char *page, void *data, void *parent_data);
@@ -63,6 +64,7 @@ struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
 struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
 			const char *name_fmt, mode_t mode,
 			struct sysfs_dirent *target);
+void sysfs_unplug(struct sysfs_dirent *sd);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
@@ -106,6 +108,10 @@ static inline struct sysfs_dirent *sysfs_add_link(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline void sysfs_unplug(struct sysfs_dirent *sd)
+{
+}
+
 static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 						    const char *name)
 {
-- 
1.5.0.3


