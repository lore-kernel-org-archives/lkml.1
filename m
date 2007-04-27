Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbXD0TA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbXD0TA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXD0S7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:34 -0400
Received: from ns1.suse.de ([195.135.220.2]:50820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073AbXD0S7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:59:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>,
       Nagendra Singh Tomar <nagendra_tomar@adaptec.com>,
       Tejun Heo <htejun@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/46] security: prevent permission checking of file removal via sysfs_remove_group()
Date: Fri, 27 Apr 2007 11:53:55 -0700
Message-Id: <11777001931075-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001891914-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
 <11777001891914-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>

Prevent permission checking from being performed when the kernel wants to
unconditionally remove a sysfs group, by introducing an kernel-only variant
of lookup_one_len(), lookup_one_len_kern().

Additionally, as sysfs_remove_group() does not check the return value of
the lookup before using it, a BUG_ON has been added to pinpoint the cause
of any problems potentially caused by this (and as a form of annotation).

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/namei.c            |   72 +++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/group.c      |    6 +++-
 include/linux/namei.h |    1 +
 3 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ee60cc4..880052c 100644
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
1.5.1.2

