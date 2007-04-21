Return-Path: <linux-kernel-owner+w=401wt.eu-S1031249AbXDUOcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031249AbXDUOcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031253AbXDUOcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:32:07 -0400
Received: from mail.suse.de ([195.135.220.2]:39263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031249AbXDUOcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:32:06 -0400
Message-ID: <462A2055.1040509@suse.com>
Date: Sat, 21 Apr 2007 10:31:49 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: a.righi@cineca.it
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com, Edward Shishkin <edward@namesys.com>,
       zam@clusterfs.com, ak@suse.de
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com> <20070420170738.e269fcae.akpm@linux-foundation.org> <46296CB8.3090100@suse.com> <462A0F06.9020602@cineca.it>
In-Reply-To: <462A0F06.9020602@cineca.it>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Jeff Mahoney wrote:
>> I have the patchset that I mentioned, but I'm not proposing it for 2.6.21.
>> It's much too invasive to be introduced in an -rc7, but it does include
>> locking changes that I believe avoid this bug.
>>
>> Vladimir was right in his analysis that sometimes get_xa_root() takes the
>> reference once and other times twice, but not for the right reasons.  I save
>> a reference to the xattr dir to avoid a lookup later, but when there are multiple
>> getxattrs or listxattrs as the first xattr operation on the file system, we can end
>> up taking a second reference when we shouldn't. This is because those operations
>> are protected by read locks and the ->xattr_root pointer isn't protected by anything
>> else. A quick fix would be to just extend the protection of the priv root's i_mutex
>> around the assignment, and test first. The right fix involves a complete rework of
>> the locking, and I have code to do that, it's just too late to include it in 2.6.21.
>>
>> I'd love to know what Andrea (and now Andi Kleen) are doing to hit this now. There
>> haven't been any changes in this code in a while, and the shrink_dcache_for_umount()
>> has been around since October. I'm unable to reproduce locally so far, so if Andrea
>> or Andi could see if this fixes it for them, I'd appreciate it.
> 
> Jeff, your patch doesn't resolve, but you hit the problem. Actually, I
> think the xattr_root pointer must be protected also in get_xa_root()
> using the same private root i_mutex.
> 
> I've tested the following patch and it resolves in my case. What do you
> think about it? could it be a reasonable fix?

Your patch fixes the problem. That'll teach me to spin a patch up while I'm headed
out the door. I think a cleaner solution for now is just to refactor get_xa_root,
__get_xa_root, and create_xa_root into one function to simplify the lookup and the
locking. I think I'll add another step to my patch set that removes the caching of
xattr_root entirely or creates in on mount, as the priv root is created. The privroot
must be cached to avoid a deadlock on the fs-root directory's i_mutex, but xattr_root
was cached as an optimzation. If we need to take privroot->i_mutex every time, there's
no point in caching it since it will probably be in the dcache anyway.

-Jeff

---
 fs/reiserfs/xattr.c |   89 ++++++++++++----------------------------------------
 1 file changed, 22 insertions(+), 67 deletions(-)

--- a/fs/reiserfs/xattr.c	2007-04-21 10:15:00.000000000 -0400
+++ b/fs/reiserfs/xattr.c	2007-04-21 10:27:40.000000000 -0400
@@ -54,7 +54,12 @@
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
 								*prefix);
 
-static struct dentry *create_xa_root(struct super_block *sb)
+/* Returns the dentry referring to the root of the extended attribute
+ * directory tree. If it has already been retrieved, it is used. If it
+ * hasn't been created and the flags indicate creation is allowed, we
+ * attempt to create it. On error, we return a pointer-encoded error.
+ */
+static struct dentry *get_xa_root(struct super_block *sb, int flags)
 {
 	struct dentry *privroot = dget(REISERFS_SB(sb)->priv_root);
 	struct dentry *xaroot;
@@ -63,73 +68,33 @@ static struct dentry *create_xa_root(str
 	if (!privroot)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	xaroot = lookup_one_len(XAROOT_NAME, privroot, strlen(XAROOT_NAME));
-	if (IS_ERR(xaroot)) {
+	mutex_lock(&privroot->d_inode->i_mutex);
+	if (REISERFS_SB(sb)->xattr_root) {
+		xaroot = dget(REISERFS_SB(sb)->xattr_root);
 		goto out;
-	} else if (!xaroot->d_inode) {
-		int err;
-		mutex_lock(&privroot->d_inode->i_mutex);
-		err =
-		    privroot->d_inode->i_op->mkdir(privroot->d_inode, xaroot,
-						   0700);
-		mutex_unlock(&privroot->d_inode->i_mutex);
-
-		if (err) {
-			dput(xaroot);
-			dput(privroot);
-			return ERR_PTR(err);
-		}
-		REISERFS_SB(sb)->xattr_root = dget(xaroot);
 	}
 
-      out:
-	dput(privroot);
-	return xaroot;
-}
-
-/* This will return a dentry, or error, refering to the xa root directory.
- * If the xa root doesn't exist yet, the dentry will be returned without
- * an associated inode. This dentry can be used with ->mkdir to create
- * the xa directory. */
-static struct dentry *__get_xa_root(struct super_block *s)
-{
-	struct dentry *privroot = dget(REISERFS_SB(s)->priv_root);
-	struct dentry *xaroot = NULL;
-
-	if (IS_ERR(privroot) || !privroot)
-		return privroot;
-
 	xaroot = lookup_one_len(XAROOT_NAME, privroot, strlen(XAROOT_NAME));
 	if (IS_ERR(xaroot)) {
 		goto out;
 	} else if (!xaroot->d_inode) {
-		dput(xaroot);
-		xaroot = NULL;
-		goto out;
+		int err = -ENODATA;
+		if (flags == 0 || flags & XATTR_CREATE)
+			err = privroot->d_inode->i_op->mkdir(privroot->d_inode,
+			                                     xaroot, 0700);
+		if (err) {
+			dput(xaroot);
+			goto out;
+		}
 	}
-
-	REISERFS_SB(s)->xattr_root = dget(xaroot);
+	REISERFS_SB(sb)->xattr_root = dget(xaroot);
 
       out:
+	mutex_unlock(&privroot->d_inode->i_mutex);
 	dput(privroot);
 	return xaroot;
 }
 
-/* Returns the dentry (or NULL) referring to the root of the extended
- * attribute directory tree. If it has already been retrieved, it is used.
- * Otherwise, we attempt to retrieve it from disk. It may also return
- * a pointer-encoded error.
- */
-static inline struct dentry *get_xa_root(struct super_block *s)
-{
-	struct dentry *dentry = dget(REISERFS_SB(s)->xattr_root);
-
-	if (!dentry)
-		dentry = __get_xa_root(s);
-
-	return dentry;
-}
-
 /* Opens the directory corresponding to the inode's extended attribute store.
  * If flags allow, the tree to the directory may be created. If creation is
  * prohibited, -ENODATA is returned. */
@@ -138,21 +103,11 @@ static struct dentry *open_xa_dir(const 
 	struct dentry *xaroot, *xadir;
 	char namebuf[17];
 
-	xaroot = get_xa_root(inode->i_sb);
-	if (IS_ERR(xaroot)) {
+	xaroot = get_xa_root(inode->i_sb, flags);
+	if (IS_ERR(xaroot))
 		return xaroot;
-	} else if (!xaroot) {
-		if (flags == 0 || flags & XATTR_CREATE) {
-			xaroot = create_xa_root(inode->i_sb);
-			if (IS_ERR(xaroot))
-				return xaroot;
-		}
-		if (!xaroot)
-			return ERR_PTR(-ENODATA);
-	}
 
 	/* ok, we have xaroot open */
-
 	snprintf(namebuf, sizeof(namebuf), "%X.%X",
 		 le32_to_cpu(INODE_PKEY(inode)->k_objectid),
 		 inode->i_generation);
@@ -821,7 +776,7 @@ int reiserfs_delete_xattrs(struct inode 
 
 	/* Leftovers besides . and .. -- that's not good. */
 	if (dir->d_inode->i_nlink <= 2) {
-		root = get_xa_root(inode->i_sb);
+		root = get_xa_root(inode->i_sb, XATTR_REPLACE);
 		reiserfs_write_lock_xattrs(inode->i_sb);
 		err = vfs_rmdir(root->d_inode, dir);
 		reiserfs_write_unlock_xattrs(inode->i_sb);


-- 
Jeff Mahoney
SUSE Labs
