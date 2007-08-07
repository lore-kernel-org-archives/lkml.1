Return-Path: <linux-kernel-owner+w=401wt.eu-S967402AbXHGVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967402AbXHGVyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966429AbXHGVao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:30:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50029 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966337AbXHGVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:30:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: [PATCH 15/25] vfs: Remove lookup_one_len_kern
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 07 Aug 2007 15:25:05 -0600
In-Reply-To: <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 07 Aug 2007 15:23:57 -0600")
Message-ID: <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that sysfs no longer uses lookup_one_len_kern the function has
no users so remove it from the kernel.  Making namei.c just a little
easier to read.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/namei.c            |   46 +++++++++++-----------------------------------
 include/linux/namei.h |    1 -
 2 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a83160a..69d3304 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1273,7 +1273,12 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
 	return err;
 }
 
-static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry *base, struct nameidata *nd)
+/*
+ * Restricted form of lookup. Doesn't follow links, single-component only,
+ * needs parent already locked. Doesn't follow mounts.
+ * SMP-safe.
+ */
+static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
 	struct inode *inode;
@@ -1281,6 +1286,11 @@ static inline struct dentry *__lookup_hash_kern(struct qstr *name, struct dentry
 
 	inode = base->d_inode;
 
+	err = permission(inode, MAY_EXEC, nd);
+	dentry = ERR_PTR(err);
+	if (err)
+		goto out;
+
 	/*
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
@@ -1308,29 +1318,6 @@ out:
 	return dentry;
 }
 
-/*
- * Restricted form of lookup. Doesn't follow links, single-component only,
- * needs parent already locked. Doesn't follow mounts.
- * SMP-safe.
- */
-static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
-{
-	struct dentry *dentry;
-	struct inode *inode;
-	int err;
-
-	inode = base->d_inode;
-
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
-	if (err)
-		goto out;
-
-	dentry = __lookup_hash_kern(name, base, nd);
-out:
-	return dentry;
-}
-
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
 	return __lookup_hash(&nd->last, nd->dentry, nd);
@@ -1369,17 +1356,6 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	return __lookup_hash(&this, base, NULL);
 }
 
-struct dentry *lookup_one_len_kern(const char *name, struct dentry *base, int len)
-{
-	int err;
-	struct qstr this;
-
-	err = __lookup_one_len(name, &this, base, len);
-	if (err)
-		return ERR_PTR(err);
-	return __lookup_hash_kern(&this, base, NULL);
-}
-
 int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 			    struct nameidata *nd)
 {
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 6c38efb..36e5690 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -82,7 +82,6 @@ extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
-extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
-- 
1.5.1.1.181.g2de0

