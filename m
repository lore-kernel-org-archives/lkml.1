Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXDUAWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXDUAWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXDUAWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:22:08 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:35854 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXDUAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:22:07 -0400
Date: Fri, 20 Apr 2007 20:22:01 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH - Try #2] Re: BUG in sysfs_remove_group
In-Reply-To: <Line.LNX.4.64.0704191222460.1633@d.namei>
Message-ID: <Line.LNX.4.64.0704202017270.22553@d.namei>
References: <20070417100756.32454f9d.akpm@linux-foundation.org>
 <Line.LNX.4.64.0704191222460.1633@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version of the patch, which splits __lookup_hash() into normal and 
kernel variants, to prevent a check of the type of lookup.  Also splits 
lookup_one_len().  Tests ok on my system.  Please review.


Subject: [PATCH] security: prevent permission checking of file removal via sysfs_remove_group()

Prevent permission checking from being peformed when the kernel wants to
unconditionally remove a sysfs group, by introducing an kernel-only
variant of lookup_one_len(), lookup_one_len_kern().

Additionally, as sysfs_remove_group() does not check the return value of
the lookup before using it, a BUG_ON has been added to pinpoint the cause
of any problems potentially caused by this (and as a form of annotation).

Signed-off-by: James Morris <jmorris@namei.org>
---
 fs/namei.c            |   72 +++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/group.c      |    6 +++-
 include/linux/namei.h |    1 +
 3 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ee60cc4..cabe2b8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1243,22 +1243,13 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
 	return err;
 }
 
-/*
- * Restricted form of lookup. Doesn't follow links, single-component only,
- * needs parent already locked. Doesn't follow mounts.
- * SMP-safe.
- */
-static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd)
+static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
 {
-	struct dentry * dentry;
+	struct dentry *dentry;
 	struct inode *inode;
 	int err;
 
 	inode = base->d_inode;
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
-	if (err)
-		goto out;
 
 	/*
 	 * See if the low-level filesystem might want
@@ -1287,35 +1278,76 @@ out:
 	return dentry;
 }
 
+/*
+ * Restricted form of lookup. Doesn't follow links, single-component only,
+ * needs parent already locked. Doesn't follow mounts.
+ * SMP-safe.
+ */
+static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	int err;
+
+	inode = base->d_inode;
+
+	err = permission(inode, MAY_EXEC, nd);
+	dentry = ERR_PTR(err);
+	if (err)
+		goto out;
+
+	dentry = __lookup_hash_kern(name, base, nd);
+out:
+	return dentry;
+}
+
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
 	return __lookup_hash(&nd->last, nd->dentry, nd);
 }
 
 /* SMP-safe */
-struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+static inline int __lookup_one_len(const char *name, struct qstr *this, struct dentry *base, int len)
 {
 	unsigned long hash;
-	struct qstr this;
 	unsigned int c;
 
-	this.name = name;
-	this.len = len;
+	this->name = name;
+	this->len = len;
 	if (!len)
-		goto access;
+		return -EACCES;
 
 	hash = init_name_hash();
 	while (len--) {
 		c = *(const unsigned char *)name++;
 		if (c == '/' || c == '\0')
-			goto access;
+			return -EACCES;
 		hash = partial_name_hash(c, hash);
 	}
-	this.hash = end_name_hash(hash);
+	this->hash = end_name_hash(hash);
+	return 0;
+}
 
+struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
+{
+	int err;
+	struct qstr this;
+	
+	err = __lookup_one_len(name, &this, base, len);
+	if (err)
+		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
-access:
-	return ERR_PTR(-EACCES);
+}
+
+struct dentry *lookup_one_len_kern(const char *name, struct dentry *base, int len)
+{
+	int err;
+	struct qstr this;
+	
+	err = __lookup_one_len(name, &this, base, len);
+	if (err)
+		return ERR_PTR(err);
+	return __lookup_hash_kern(&this, base, NULL);
 }
 
 /*
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
index d39a5a6..b7dd249 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -82,6 +82,7 @@ extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
-- 
1.5.0.6

