Return-Path: <linux-kernel-owner+w=401wt.eu-S1767010AbXDSVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767010AbXDSVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767015AbXDSVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:50:41 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:45987 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767010AbXDSVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:50:40 -0400
Date: Thu, 19 Apr 2007 17:50:36 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH] Re: BUG in sysfs_remove_group
In-Reply-To: <20070417100756.32454f9d.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0704191222460.1633@d.namei>
References: <20070417100756.32454f9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Nagendra Singh Tomar wrote:

> The return value of lookup_one_len() is used without testing for error return. 
> This results in the following oops when SELinux is enabled and enforced.  The 
> reason for the Oops is as follows.
> 	The shell's (bash) SELinux domain is not allowed "search" permission in sysfs 
> filesystem (type sysfs_t in the default SELinux policy), due to which the 
> lookup_one_len->__lookup_hash->permission->security_inode_permission 
> returns -EACCESS. This -ve number is passed as the 'dir' argument to 
> remove_files()  and then to sysfs_hash_and_remove() which accesses this bogus 
> pointer resulting in the crash.
> 	A simple fix will be to check for IS_ERR(dir) in sysfs_remove_group() and 
> return (without doing anything) if true, but this will result in the 
> corresponding sysfs dirent entries to be leaked. IMHO the proper fix will be 
> to not check for "search" permissions in such cases where the internal kernel 
> code is trying to free up sysfs entries like the current case.

I hit the same issue a couple of days before with MLS policy, and your 
report and analysis proved most useful, thanks.

A preliminary patch for this is below, based on suggestions from Stephen 
Smalley.

Please review, and Nagendra, let me know if this works for you.


Prevent permission checking from being peformed when the kernel wants to 
unconditionally remove a sysfs group, by introducing an kernel-only 
variant of lookup_one_len(), lookup_one_len_kern().

Additionally, as sysfs_remove_group() does not check the return value of 
the lookup before using it, a BUG_ON has been added to pinpoint the cause 
of any problems potentially caused by this (and as a form of annotation).

Signed-off-by: James Morris <jmorris@namei.org>


---

 fs/namei.c            |   29 +++++++++++++++++++++--------
 fs/sysfs/group.c      |    6 ++++--
 include/linux/namei.h |    1 +
 3 files changed, 26 insertions(+), 10 deletions(-)


diff --git a/fs/namei.c b/fs/namei.c
index ee60cc4..70d3c46 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1248,17 +1248,20 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd)
+static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd, int kern)
 {
 	struct dentry * dentry;
 	struct inode *inode;
 	int err;
 
 	inode = base->d_inode;
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
-	if (err)
-		goto out;
+	
+	if (likely(!kern)) {
+		err = permission(inode, MAY_EXEC, nd);
+		dentry = ERR_PTR(err);
+		if (err)
+			goto out;
+	}
 
 	/*
 	 * See if the low-level filesystem might want
@@ -1289,11 +1292,11 @@ out:
 
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
-	return __lookup_hash(&nd->last, nd->dentry, nd);
+	return __lookup_hash(&nd->last, nd->dentry, nd, 0);
 }
 
 /* SMP-safe */
-struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+static inline struct dentry * __lookup_one_len(const char * name, struct dentry * base, int len, int kern)
 {
 	unsigned long hash;
 	struct qstr this;
@@ -1313,11 +1316,21 @@ struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
 	}
 	this.hash = end_name_hash(hash);
 
-	return __lookup_hash(&this, base, NULL);
+	return __lookup_hash(&this, base, NULL, kern);
 access:
 	return ERR_PTR(-EACCES);
 }
 
+struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+{
+	return __lookup_one_len(name, base, len, 0);
+}
+
+struct dentry * lookup_one_len_kern(const char * name, struct dentry * base, int len)
+{
+	return __lookup_one_len(name, base, len, 1);
+}
+
 /*
  *	namei()
  *
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index b20951c..52eed2a 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -70,9 +70,11 @@ void sysfs_remove_group(struct kobject * kobj,
 {
 	struct dentry * dir;
 
-	if (grp->name)
-		dir = lookup_one_len(grp->name, kobj->dentry,
+	if (grp->name) {
+		dir = lookup_one_len_kern(grp->name, kobj->dentry,
 				strlen(grp->name));
+		BUG_ON(IS_ERR(dir));
+	}
 	else
 		dir = dget(kobj->dentry);
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d39a5a6..d4031ff 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -82,6 +82,7 @@ extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry * lookup_one_len_kern(const char *, struct dentry *, int);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
