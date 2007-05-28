Return-Path: <linux-kernel-owner+w=401wt.eu-S1762738AbXE1QLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738AbXE1QLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761916AbXE1QKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:10:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2662 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761696AbXE1QKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=j/QyezcBVkaPiNODZo62L2FSHuDrtEJLd6XekMm9QApf1fH9SYovS9OQM01MQ/tjon4CrnxA0KsSPugsQCh+VV7gQ/eV6A5Ac8QILHBddv1kFaUYnIw5DTiQb8v7DjJM8sBYNX2cqXF8miSSLEfjO7ESiqYPaTcuggYvP69vhb4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/5] sysfs: use iget_locked() instead of new_inode()
In-Reply-To: <1180368625600-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:10:26 +0900
Message-Id: <11803686261683-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 fs/sysfs/dir.c   |   37 +++++++++++++++++++++----------------
 fs/sysfs/inode.c |   24 +++++++++++++++---------
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index bbf3525..06dff2c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -219,14 +219,16 @@ static int create_dir(struct kobject *ko
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
@@ -310,20 +312,23 @@ static struct dentry * sysfs_lookup(stru
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
index 3b2dc2a..167c7fb 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -152,10 +152,12 @@ void sysfs_init_inode(struct sysfs_diren
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
@@ -163,12 +165,12 @@ void sysfs_init_inode(struct sysfs_diren
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
@@ -179,7 +181,7 @@ struct inode * sysfs_new_inode(struct sy
  *	@dentry: dentry to be instantiated
  *	@inode: inode associated with @sd
  *
- *	Instantiate @dentry with @inode.
+ *	Unlock @inode if locked and instantiate @dentry with @inode.
  *
  *	LOCKING:
  *	None.
@@ -188,9 +190,13 @@ void sysfs_instantiate(struct dentry *de
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
@@ -58,7 +58,7 @@ extern struct kmem_cache *sysfs_dir_cach
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
-extern struct inode * sysfs_new_inode(struct sysfs_dirent *sd);
+extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
 extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
-- 
1.4.3.4


