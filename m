Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZE1XGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZE1XGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZE1XC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:02:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48892 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbZE1XCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:24 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:56 -0700
Message-Id: <1243551665-23596-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4759]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 15/24] sysfs: Kill sysfs_addrm_start and sysfs_addrm_finish
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With lazy inode updates and dentry operations bringing everything
into sync on demand there is no longer any need to immediately
update the vfs or grab i_mutex to protect those updates as we
make changes to sysfs.

So stop updating the vfs inodes and move what remains of
sysfs_addrm_start and sysfs_addrm_finsih (just barely more than taking
the sysfs_mutex) into sysfs_add_one and sysfs_remove_one.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c     |  188 +++++++---------------------------------------------
 fs/sysfs/file.c    |    6 +--
 fs/sysfs/inode.c   |   16 ++---
 fs/sysfs/symlink.c |    6 +--
 fs/sysfs/sysfs.h   |   17 +----
 5 files changed, 32 insertions(+), 201 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b75c938..0cf3fad 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -382,62 +382,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
-static int sysfs_ilookup_test(struct inode *inode, void *arg)
-{
-	struct sysfs_dirent *sd = arg;
-	return inode->i_ino == sd->s_ino;
-}
-
-/**
- *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
- *	@acxt: pointer to sysfs_addrm_cxt to be used
- *	@parent_sd: parent sysfs_dirent
- *
- *	This function is called when the caller is about to add or
- *	remove sysfs_dirent under @parent_sd.  This function acquires
- *	sysfs_mutex, grabs inode for @parent_sd if available and lock
- *	i_mutex of it.  @acxt is used to keep and pass context to
- *	other addrm functions.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).  sysfs_mutex is locked on
- *	return.  i_mutex of parent inode is locked on return if
- *	available.
- */
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd)
-{
-	struct inode *inode;
-
-	memset(acxt, 0, sizeof(*acxt));
-	acxt->parent_sd = parent_sd;
-
-	/* Lookup parent inode.  inode initialization is protected by
-	 * sysfs_mutex, so inode existence can be determined by
-	 * looking up inode while holding sysfs_mutex.
-	 */
-	mutex_lock(&sysfs_mutex);
-
-	inode = ilookup5(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
-			 parent_sd);
-	if (inode) {
-		WARN_ON(inode->i_state & I_NEW);
-
-		/* parent inode available */
-		acxt->parent_inode = inode;
-
-		/* sysfs_mutex is below i_mutex in lock hierarchy.
-		 * First, trylock i_mutex.  If fails, unlock
-		 * sysfs_mutex and lock them in order.
-		 */
-		if (!mutex_trylock(&inode->i_mutex)) {
-			mutex_unlock(&sysfs_mutex);
-			mutex_lock(&inode->i_mutex);
-			mutex_lock(&sysfs_mutex);
-		}
-	}
-}
-
 /**
  *	sysfs_pathname - return full path to sysfs dirent
  *	@sd: sysfs_dirent whose path we want
@@ -460,161 +404,83 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 
 /**
  *	sysfs_add_one - add sysfs_dirent to parent
- *	@acxt: addrm context to use
+ *	@parent_sd: directory to add @sd into
  *	@sd: sysfs_dirent to be added
  *
- *	Get @acxt->parent_sd and set sd->s_parent to it and increment
+ *	Get @parent_sd and set sd->s_parent to it and increment
  *	nlink of parent inode if @sd is a directory and link into the
  *	children list of the parent.
  *
- *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
- *
  *	LOCKING:
- *	Determined by sysfs_addrm_start().
+ *	Kernel thread context (may sleep).  Grabs sysfs_mutex.
  *
  *	RETURNS:
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int sysfs_add_one(struct sysfs_dirent *parent_sd, struct sysfs_dirent *sd)
 {
 	struct iattr *ps_iattr;
 
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
-		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
+	mutex_lock(&sysfs_mutex);
+	if (sysfs_find_dirent(parent_sd, sd->s_name)) {
+		char *path;
+		mutex_unlock(&sysfs_mutex);
+
+		path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
 		     "sysfs: cannot create duplicate filename '%s'\n",
 		     (path == NULL) ? sd->s_name :
-		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
+		     strcat(strcat(sysfs_pathname(parent_sd, path), "/"),
 		            sd->s_name));
 		kfree(path);
 		return -EEXIST;
 	}
 
-	sd->s_parent = sysfs_get(acxt->parent_sd);
-
-	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
-		inc_nlink(acxt->parent_inode);
-
-	acxt->cnt++;
-
+	sd->s_parent = sysfs_get(parent_sd);
 	sysfs_link_sibling(sd);
 
 	/* Update timestamps on the parent */
-	ps_iattr = acxt->parent_sd->s_iattr;
+	ps_iattr = parent_sd->s_iattr;
 	if (ps_iattr)
 		ps_iattr->ia_ctime = ps_iattr->ia_mtime = CURRENT_TIME;
 
+	mutex_unlock(&sysfs_mutex);
 	return 0;
 }
 
 /**
  *	sysfs_remove_one - remove sysfs_dirent from parent
- *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be removed
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
  *	directory.  @sd is unlinked from the children list.
  *
- *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
- *
  *	LOCKING:
- *	Determined by sysfs_addrm_start().
+ *	Kernel thread context (may sleep).  Grabs sysfs_mutex.
  */
-void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+void sysfs_remove_one(struct sysfs_dirent *sd)
 {
 	struct iattr *ps_iattr;
 
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
+	mutex_lock(&sysfs_mutex);
+
 	sysfs_unlink_sibling(sd);
 
 	/* Update timestamps on the parent */
-	ps_iattr = acxt->parent_sd->s_iattr;
+	ps_iattr = sd->s_parent->s_iattr;
 	if (ps_iattr)
 		ps_iattr->ia_ctime = ps_iattr->ia_mtime = CURRENT_TIME;
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	sd->s_sibling = acxt->removed;
-	acxt->removed = sd;
-
-	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
-		drop_nlink(acxt->parent_inode);
-
-	acxt->cnt++;
-}
-
-/**
- *	sysfs_dec_nlink - Decrement link count for the specified sysfs_dirent
- *	@sd: target sysfs_dirent
- *
- *	Decrement nlink for @sd.  @sd must have been unlinked from its
- *	parent on entry to this function such that it can't be looked
- *	up anymore.
- */
-static void sysfs_dec_nlink(struct sysfs_dirent *sd)
-{
-	struct inode *inode;
-
-	inode = ilookup(sysfs_sb, sd->s_ino);
-	if (!inode)
-		return;
-
-	/* adjust nlink and update timestamp */
-	mutex_lock(&inode->i_mutex);
-
-	inode->i_ctime = CURRENT_TIME;
-	drop_nlink(inode);
-	if (sysfs_type(sd) == SYSFS_DIR)
-		drop_nlink(inode);
-
-	mutex_unlock(&inode->i_mutex);
-
-	iput(inode);
-}
 
-/**
- *	sysfs_addrm_finish - finish up sysfs_dirent add/remove
- *	@acxt: addrm context to finish up
- *
- *	Finish up sysfs_dirent add/remove.  Resources acquired by
- *	sysfs_addrm_start() are released and removed sysfs_dirents are
- *	cleaned up.  Timestamps on the parent inode are updated.
- *
- *	LOCKING:
- *	All mutexes acquired by sysfs_addrm_start() are released.
- */
-void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
-{
-	/* release resources acquired by sysfs_addrm_start() */
 	mutex_unlock(&sysfs_mutex);
-	if (acxt->parent_inode) {
-		struct inode *inode = acxt->parent_inode;
 
-		/* if added/removed, update timestamps on the parent */
-		if (acxt->cnt)
-			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
-
-		mutex_unlock(&inode->i_mutex);
-		iput(inode);
-	}
-
-	/* kill removed sysfs_dirents */
-	while (acxt->removed) {
-		struct sysfs_dirent *sd = acxt->removed;
-
-		acxt->removed = sd->s_sibling;
-		sd->s_sibling = NULL;
-
-		sysfs_dec_nlink(sd);
-		sysfs_deactivate(sd);
-		unmap_bin_file(sd);
-		sysfs_put(sd);
-	}
+	sysfs_deactivate(sd);
+	unmap_bin_file(sd);
+	sysfs_put(sd);
 }
 
 /**
@@ -673,7 +539,6 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
 
@@ -684,10 +549,8 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	sd->s_dir.kobj = kobj;
 
 	/* link in */
-	sysfs_addrm_start(&acxt, parent_sd);
-	rc = sysfs_add_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
 
+	rc = sysfs_add_one(parent_sd, sd);
 	if (rc == 0)
 		*p_sd = sd;
 	else
@@ -787,9 +650,7 @@ static void remove_dir(struct sysfs_dirent *dir_sd)
 		mutex_unlock(&sysfs_mutex);
 	}
 
-	sysfs_addrm_start(&acxt, dir_sd->s_parent);
 	sysfs_remove_one(&acxt, dir_sd);
-	sysfs_addrm_finish(&acxt);
 }
 
 void sysfs_remove_subdir(struct sysfs_dirent *sd)
@@ -818,14 +679,11 @@ static struct sysfs_dirent *get_dirent_to_remove(struct sysfs_dirent *dir_sd)
 
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 
 	/* Remove children that we think are safe */
 	while ((sd = get_dirent_to_remove(dir_sd))) {
-		sysfs_addrm_start(&acxt, sd->s_parent);
 		sysfs_remove_one(&acxt, sd);
-		sysfs_addrm_finish(&acxt);
 		sysfs_put(sd);
 	}
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 31cfe1d..b512ce6 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -499,7 +499,6 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 			const struct attribute *attr, int type, mode_t amode)
 {
 	umode_t mode = (amode & S_IALLUGO) | S_IFREG;
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 	int rc;
 
@@ -508,10 +507,7 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
 
-	sysfs_addrm_start(&acxt, dir_sd);
-	rc = sysfs_add_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
-
+	rc = sysfs_add_one(dir_sd, sd);
 	if (rc)
 		sysfs_put(sd);
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 1b7ed3c..ad9a30d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -263,23 +263,17 @@ void sysfs_delete_inode(struct inode *inode)
 
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
-	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 
 	if (!dir_sd)
 		return -ENOENT;
 
-	sysfs_addrm_start(&acxt, dir_sd);
-
-	sd = sysfs_find_dirent(dir_sd, name);
-	if (sd)
-		sysfs_remove_one(&acxt, sd);
-
-	sysfs_addrm_finish(&acxt);
-
-	if (sd)
+	sd = sysfs_get_dirent(dir_sd, name);
+	if (sd) {
+		sysfs_remove_one(sd);
+		sysfs_put(sd);
 		return 0;
-	else
+	} else
 		return -ENOENT;
 }
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 05e4984..fc5fc86 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -31,7 +31,6 @@ int sysfs_create_link(struct kobject *kobj, struct kobject *target,
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
-	struct sysfs_addrm_cxt acxt;
 	int error;
 
 	BUG_ON(!name);
@@ -65,10 +64,7 @@ int sysfs_create_link(struct kobject *kobj, struct kobject *target,
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
-	sysfs_addrm_start(&acxt, parent_sd);
-	error = sysfs_add_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
-
+	error = sysfs_add_one(parent_sd, sd);
 	if (error)
 		goto out_put;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f5b53cf..f17ebb8 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -77,16 +77,6 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 }
 
 /*
- * Context structure to be used while adding/removing nodes.
- */
-struct sysfs_addrm_cxt {
-	struct sysfs_dirent	*parent_sd;
-	struct inode		*parent_inode;
-	struct sysfs_dirent	*removed;
-	int			cnt;
-};
-
-/*
  * mount.c
  */
 extern struct sysfs_dirent sysfs_root;
@@ -106,11 +96,8 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
 struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 void sysfs_put_active_two(struct sysfs_dirent *sd);
-void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-		       struct sysfs_dirent *parent_sd);
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
-void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
-void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+int sysfs_add_one(struct sysfs_dirent *parent_sd, struct sysfs_dirent *sd);
+void sysfs_remove_one(struct sysfs_dirent *sd);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 				       const unsigned char *name);
-- 
1.6.3.1.54.g99dd.dirty

