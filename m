Return-Path: <linux-kernel-owner+w=401wt.eu-S936404AbXGKXxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404AbXGKXxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935247AbXGKXgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:33421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935117AbXGKXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/61] sysfs: use iget_locked() instead of new_inode()
Date: Wed, 11 Jul 2007 16:32:03 -0700
Message-Id: <11841969453004-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969401152-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

After dentry is reclaimed, sysfs always used to allocate new dentry
and inode if the file is accessed again.  This causes problem with
operations which only pin the inode.  For example, if inotify watch is
added to a sysfs file and the dentry for the file is reclaimed, the
next update event creates new dentry and new inode making the inotify
watch miss all the events from there on.

This patch fixes it by using iget_locked() instead of new_inode().
sysfs_new_inode() is renamed to sysfs_get_inode() and inode is
initialized iff the inode is newly allocated.  sysfs_instantiate() is
responsible for unlocking new inodes.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   37 +++++++++++++++++++++----------------
 fs/sysfs/inode.c |   24 +++++++++++++++---------
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index bbf3525..06dff2c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -219,14 +219,16 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 		goto out_drop;
 	sd->s_elem.dir.kobj = kobj;
 
-	inode = sysfs_new_inode(sd);
+	inode = sysfs_get_inode(sd);
 	if (!inode)
 		goto out_sput;
 
-	inode->i_op = &sysfs_dir_inode_operations;
-	inode->i_fop = &sysfs_dir_operations;
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
+	if (inode->i_state & I_NEW) {
+		inode->i_op = &sysfs_dir_inode_operations;
+		inode->i_fop = &sysfs_dir_operations;
+		/* directory inodes start off with i_nlink == 2 (for ".") */
+		inc_nlink(inode);
+	}
 
 	/* link in */
 	error = -EEXIST;
@@ -310,20 +312,23 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		return NULL;
 
 	/* attach dentry and inode */
-	inode = sysfs_new_inode(sd);
+	inode = sysfs_get_inode(sd);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	/* initialize inode according to type */
-	if (sd->s_type & SYSFS_KOBJ_ATTR) {
-		inode->i_size = PAGE_SIZE;
-		inode->i_fop = &sysfs_file_operations;
-	} else if (sd->s_type & SYSFS_KOBJ_BIN_ATTR) {
-		struct bin_attribute *bin_attr = sd->s_elem.bin_attr.bin_attr;
-		inode->i_size = bin_attr->size;
-		inode->i_fop = &bin_fops;
-	} else if (sd->s_type & SYSFS_KOBJ_LINK)
-		inode->i_op = &sysfs_symlink_inode_operations;
+	if (inode->i_state & I_NEW) {
+		/* initialize inode according to type */
+		if (sd->s_type & SYSFS_KOBJ_ATTR) {
+			inode->i_size = PAGE_SIZE;
+			inode->i_fop = &sysfs_file_operations;
+		} else if (sd->s_type & SYSFS_KOBJ_BIN_ATTR) {
+			struct bin_attribute *bin_attr =
+				sd->s_elem.bin_attr.bin_attr;
+			inode->i_size = bin_attr->size;
+			inode->i_fop = &bin_fops;
+		} else if (sd->s_type & SYSFS_KOBJ_LINK)
+			inode->i_op = &sysfs_symlink_inode_operations;
+	}
 
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 26d8503..3eab9c4 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -153,10 +153,12 @@ void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 }
 
 /**
- *	sysfs_new_inode - allocate new inode for sysfs_dirent
+ *	sysfs_get_inode - get inode for sysfs_dirent
  *	@sd: sysfs_dirent to allocate inode for
  *
- *	Allocate inode for @sd and initialize basics.
+ *	Get inode for @sd.  If such inode doesn't exist, a new inode
+ *	is allocated and basics are initialized.  New inode is
+ *	returned locked.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
@@ -164,12 +166,12 @@ void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode * sysfs_new_inode(struct sysfs_dirent *sd)
+struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
 {
 	struct inode *inode;
 
-	inode = new_inode(sysfs_sb);
-	if (inode)
+	inode = iget_locked(sysfs_sb, sd->s_ino);
+	if (inode && (inode->i_state & I_NEW))
 		sysfs_init_inode(sd, inode);
 
 	return inode;
@@ -180,7 +182,7 @@ struct inode * sysfs_new_inode(struct sysfs_dirent *sd)
  *	@dentry: dentry to be instantiated
  *	@inode: inode associated with @sd
  *
- *	Instantiate @dentry with @inode.
+ *	Unlock @inode if locked and instantiate @dentry with @inode.
  *
  *	LOCKING:
  *	None.
@@ -189,9 +191,13 @@ void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	BUG_ON(!dentry || dentry->d_inode);
 
-	if (dentry->d_parent && dentry->d_parent->d_inode) {
-		struct inode *p_inode = dentry->d_parent->d_inode;
-		p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
+	if (inode->i_state & I_NEW) {
+		unlock_new_inode(inode);
+
+		if (dentry->d_parent && dentry->d_parent->d_inode) {
+			struct inode *p_inode = dentry->d_parent->d_inode;
+			p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
+		}
 	}
 
 	d_instantiate(dentry, inode);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 143fdbe..627bf39 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -58,7 +58,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
-extern struct inode * sysfs_new_inode(struct sysfs_dirent *sd);
+extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
-- 
1.5.2.2

