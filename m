Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbZE2U0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbZE2U0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763597AbZE2UUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45237 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763354AbZE2UT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:56 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:28 -0700
Message-Id: <1243628376-22905-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0237]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=2]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 18/26] sysfs: Propagate renames to the vfs on demand
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

By teaching sysfs_revalidate to hide a dentry for
a sysfs_dirent if the sysfs_dirent has been renamed,
and by teaching sysfs_lookup to return the original
dentry if the sysfs dirent has been renamed.  I can
show the results of renames correctly without having to
update the dcache during the directory rename.

This massively simplifies the rename logic allowing a lot
of weird sysfs special cases to be removed along with
a lot of now unnecesary helper code.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/namei.c            |   22 -------
 fs/sysfs/dir.c        |  156 ++++++++++---------------------------------------
 fs/sysfs/inode.c      |   12 ----
 fs/sysfs/sysfs.h      |    1 -
 include/linux/namei.h |    1 -
 5 files changed, 32 insertions(+), 160 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 78f253c..69f559a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1260,28 +1260,6 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	return __lookup_hash(&this, base, NULL);
 }
 
-/**
- * lookup_one_noperm - bad hack for sysfs
- * @name:	pathname component to lookup
- * @base:	base directory to lookup from
- *
- * This is a variant of lookup_one_len that doesn't perform any permission
- * checks.   It's a horrible hack to work around the braindead sysfs
- * architecture and should not be used anywhere else.
- *
- * DON'T USE THIS FUNCTION EVER, thanks.
- */
-struct dentry *lookup_one_noperm(const char *name, struct dentry *base)
-{
-	int err;
-	struct qstr this;
-
-	err = __lookup_one_len(name, &this, base, strlen(name));
-	if (err)
-		return ERR_PTR(err);
-	return __lookup_hash(&this, base, NULL);
-}
-
 int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3caf9c6..73dbc34 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -24,7 +24,6 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
-DEFINE_MUTEX(sysfs_rename_mutex);
 DEFINE_SPINLOCK(sysfs_assoc_lock);
 
 static DEFINE_SPINLOCK(sysfs_ino_lock);
@@ -84,46 +83,6 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 }
 
 /**
- *	sysfs_get_dentry - get dentry for the given sysfs_dirent
- *	@sd: sysfs_dirent of interest
- *
- *	Get dentry for @sd.  Dentry is looked up if currently not
- *	present.  This function descends from the root looking up
- *	dentry for each step.
- *
- *	LOCKING:
- *	mutex_lock(sysfs_rename_mutex)
- *
- *	RETURNS:
- *	Pointer to found dentry on success, ERR_PTR() value on error.
- */
-struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
-{
-	struct dentry *dentry = dget(sysfs_sb->s_root);
-
-	while (dentry->d_fsdata != sd) {
-		struct sysfs_dirent *cur;
-		struct dentry *parent;
-
-		/* find the first ancestor which hasn't been looked up */
-		cur = sd;
-		while (cur->s_parent != dentry->d_fsdata)
-			cur = cur->s_parent;
-
-		/* look it up */
-		parent = dentry;
-		mutex_lock(&parent->d_inode->i_mutex);
-		dentry = lookup_one_noperm(cur->s_name, parent);
-		mutex_unlock(&parent->d_inode->i_mutex);
-		dput(parent);
-
-		if (IS_ERR(dentry))
-			break;
-	}
-	return dentry;
-}
-
-/**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
  *
@@ -311,6 +270,14 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (sd->s_flags & SYSFS_FLAG_REMOVED)
 		goto out_bad;
 
+	/* The sysfs dirent has been moved? */
+	if (dentry->d_parent->d_fsdata != sd->s_parent)
+		goto out_bad;
+
+	/* The sysfs dirent has been renamed */
+	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
+		goto out_bad;
+
 	mutex_unlock(&sysfs_mutex);
 out_valid:
 	return 1;
@@ -318,6 +285,12 @@ out_bad:
 	/* Remove the dentry from the dcache hashes.
 	 * If this is a deleted dentry we use d_drop instead of d_delete
 	 * so sysfs doesn't need to cope with negative dentries.
+	 *
+	 * If this is a dentry that has simply been renamed we
+	 * use d_drop to remove it from the dcache lookup on its
+	 * old parent.  If this dentry persists later when a lookup
+	 * is performed at its new name the dentry will be readded
+	 * to the dcache hashes.
 	 */
 	is_dir = (sysfs_type(sd) == SYSFS_DIR);
 	mutex_unlock(&sysfs_mutex);
@@ -613,10 +586,15 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* instantiate and hash dentry */
-	dentry->d_op = &sysfs_dentry_ops;
-	dentry->d_fsdata = sysfs_get(sd);
-	d_instantiate(dentry, inode);
-	d_rehash(dentry);
+	ret = d_find_alias(inode);
+	if (!ret) {
+		dentry->d_op = &sysfs_dentry_ops;
+		dentry->d_fsdata = sysfs_get(sd);
+		d_add(dentry, inode);
+	} else {
+		d_move(ret, dentry);
+		iput(inode);
+	}
 
  out_unlock:
 	mutex_unlock(&sysfs_mutex);
@@ -711,62 +689,32 @@ void sysfs_remove_dir(struct kobject * kobj)
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
 	struct sysfs_dirent *sd = kobj->sd;
-	struct dentry *parent = NULL;
-	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	const char *dup_name = NULL;
 	int error;
 
-	mutex_lock(&sysfs_rename_mutex);
+	mutex_lock(&sysfs_mutex);
 
 	error = 0;
 	if (strcmp(sd->s_name, new_name) == 0)
 		goto out;	/* nothing to rename */
 
-	/* get the original dentry */
-	old_dentry = sysfs_get_dentry(sd);
-	if (IS_ERR(old_dentry)) {
-		error = PTR_ERR(old_dentry);
-		old_dentry = NULL;
-		goto out;
-	}
-
-	parent = old_dentry->d_parent;
-
-	/* lock parent and get dentry for new name */
-	mutex_lock(&parent->d_inode->i_mutex);
-	mutex_lock(&sysfs_mutex);
-
 	error = -EEXIST;
 	if (sysfs_find_dirent(sd->s_parent, new_name))
-		goto out_unlock;
-
-	error = -ENOMEM;
-	new_dentry = d_alloc_name(parent, new_name);
-	if (!new_dentry)
-		goto out_unlock;
+		goto out;
 
 	/* rename sysfs_dirent */
 	error = -ENOMEM;
 	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
 	if (!new_name)
-		goto out_unlock;
+		goto out;
 
 	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
-	/* rename */
-	d_add(new_dentry, NULL);
-	d_move(old_dentry, new_dentry);
-
 	error = 0;
- out_unlock:
+ out:
 	mutex_unlock(&sysfs_mutex);
-	mutex_unlock(&parent->d_inode->i_mutex);
 	kfree(dup_name);
-	dput(old_dentry);
-	dput(new_dentry);
- out:
-	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
@@ -774,54 +722,20 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 {
 	struct sysfs_dirent *sd = kobj->sd;
 	struct sysfs_dirent *new_parent_sd;
-	struct dentry *old_parent, *new_parent = NULL;
-	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	int error;
 
-	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
+
+	mutex_lock(&sysfs_mutex);
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
 	error = 0;
 	if (sd->s_parent == new_parent_sd)
 		goto out;	/* nothing to move */
 
-	/* get dentries */
-	old_dentry = sysfs_get_dentry(sd);
-	if (IS_ERR(old_dentry)) {
-		error = PTR_ERR(old_dentry);
-		old_dentry = NULL;
-		goto out;
-	}
-	old_parent = old_dentry->d_parent;
-
-	new_parent = sysfs_get_dentry(new_parent_sd);
-	if (IS_ERR(new_parent)) {
-		error = PTR_ERR(new_parent);
-		new_parent = NULL;
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
 	error = -EEXIST;
 	if (sysfs_find_dirent(new_parent_sd, sd->s_name))
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
+		goto out;
 
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);
@@ -830,15 +744,9 @@ again:
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
- out_unlock:
+	error = 0;
+out:
 	mutex_unlock(&sysfs_mutex);
-	mutex_unlock(&new_parent->d_inode->i_mutex);
-	mutex_unlock(&old_parent->d_inode->i_mutex);
- out:
-	dput(new_parent);
-	dput(old_dentry);
-	dput(new_dentry);
-	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index ad9a30d..a1917b5 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -132,17 +132,6 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
 	inode->i_ctime = iattr->ia_ctime;
 }
 
-
-/*
- * sysfs has a different i_mutex lock order behavior for i_mutex than other
- * filesystems; sysfs i_mutex is called in many places with subsystem locks
- * held. At the same time, many of the VFS locking rules do not apply to
- * sysfs at all (cross directory rename for example). To untangle this mess
- * (which gives false positives in lockdep), we're giving sysfs inodes their
- * own class for i_mutex.
- */
-static struct lock_class_key sysfs_inode_imutex_key;
-
 static int sysfs_count_nlink(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *child;
@@ -190,7 +179,6 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
-	lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
 	set_default_inode_attr(inode, sd->s_mode);
 	sysfs_refresh_inode(sd, inode);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f17ebb8..2db952c 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -87,7 +87,6 @@ extern struct kmem_cache *sysfs_dir_cachep;
  * dir.c
  */
 extern struct mutex sysfs_mutex;
-extern struct mutex sysfs_rename_mutex;
 extern spinlock_t sysfs_assoc_lock;
 
 extern const struct file_operations sysfs_dir_operations;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index fc2e035..758ecfb 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -76,7 +76,6 @@ extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
-extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
-- 
1.6.3.1.54.g99dd.dirty

