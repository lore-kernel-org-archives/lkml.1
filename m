Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZEETar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZEETar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbZEETaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:30:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:49058 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758450AbZEETaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:30:16 -0400
Message-ID: <4A00938F.9080602@suse.com>
Date: Tue, 05 May 2009 15:29:19 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk> <20090503091507.GU8633@ZenIV.linux.org.uk> <49FE7448.2040302@suse.com> <20090504061327.GG8633@ZenIV.linux.org.uk> <49FF1A7F.4010307@suse.com>
In-Reply-To: <49FF1A7F.4010307@suse.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
> Al Viro wrote:
>> On Mon, May 04, 2009 at 12:51:20AM -0400, Jeff Mahoney wrote:
> 
>>> Huh. I didn't see that still in there. That's an artifact of an earlier
>>> version of the code where I kept a reference to /.reiserfs_priv/xattrs.
>>> Then I decided that .reiserfs_priv was all I needed to cache (to avoid
>>> recursive i_mutex locking on the fs root) and dropped the caching of
>>> xattrs. Looks like it didn't get totally cleared out.
>> It's not that simple ;-/  You check it in journalling code, AFAICS in order
>> to decide how much will that sucker take (due to extra mkdir?) and something
>> will need to be done with that check.
> 
> Yes, it's for an extra mkdir. Now that I've gotten some sleep and looked
> at the code again, I see what you're saying. At least it's broken in a
> performance way instead of causing a system crash or data corruption.
> 
>> Anyway, I'm going to push all that stuff to #for-next, so that -next would
>> pick it.  I have *not* touched the xattr_root logics, so if you could do
>> that on top of your patch + my incremental...
> 
> Ok, I'll fix that up and get some testing in.

Here's the patch to fix up the xattr root caching. I have two more that do some
cleanups that I'll post separately. The early load of the privroot means we can
get rid of some of the mess with hiding the entry during readdir and lookup.

I'll send all three as a series, separately as well.

-Jeff

---

 The xattr_root caching was broken from my previous patch set. It wouldn't
 cause corruption, but could cause decreased performance due to allocating
 a larger chunk of the journal (~ 27 blocks) than it would actually use.

 This patch loads the xattr root dentry at xattr initialization and creates
 it on-demand. Since we're using the cached dentry, there's no point
 in keeping lookup_or_create_dir around, so that's removed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c            |   73 +++++++++++++++++++++++++----------------
 include/linux/reiserfs_fs_sb.h |    2 -
 include/linux/reiserfs_xattr.h |    2 -
 3 files changed, 48 insertions(+), 29 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -113,36 +113,28 @@ static int xattr_rmdir(struct inode *dir
 
 #define xattr_may_create(flags)	(!flags || flags & XATTR_CREATE)
 
-/* Returns and possibly creates the xattr dir. */
-static struct dentry *lookup_or_create_dir(struct dentry *parent,
-					    const char *name, int flags)
+static struct dentry *open_xa_root(struct super_block *sb, int flags)
 {
-	struct dentry *dentry;
-	BUG_ON(!parent);
+	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
+	struct dentry *xaroot;
+	if (!privroot->d_inode)
+		return ERR_PTR(-ENODATA);
 
-	mutex_lock_nested(&parent->d_inode->i_mutex, I_MUTEX_XATTR);
-	dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry) && !dentry->d_inode) {
-		int err = -ENODATA;
+	mutex_lock_nested(&privroot->d_inode->i_mutex, I_MUTEX_XATTR);
 
+	xaroot = dget(REISERFS_SB(sb)->xattr_root);
+	if (!xaroot->d_inode) {
+		int err = -ENODATA;
 		if (xattr_may_create(flags))
-			err = xattr_mkdir(parent->d_inode, dentry, 0700);
-
+			err = xattr_mkdir(privroot->d_inode, xaroot, 0700);
 		if (err) {
-			dput(dentry);
-			dentry = ERR_PTR(err);
+			dput(xaroot);
+			xaroot = ERR_PTR(err);
 		}
 	}
-	mutex_unlock(&parent->d_inode->i_mutex);
-	return dentry;
-}
 
-static struct dentry *open_xa_root(struct super_block *sb, int flags)
-{
-	struct dentry *privroot = REISERFS_SB(sb)->priv_root;
-	if (!privroot)
-		return ERR_PTR(-ENODATA);
-	return lookup_or_create_dir(privroot, XAROOT_NAME, flags);
+	mutex_unlock(&privroot->d_inode->i_mutex);
+	return xaroot;
 }
 
 static struct dentry *open_xa_dir(const struct inode *inode, int flags)
@@ -158,10 +150,22 @@ static struct dentry *open_xa_dir(const
 		 le32_to_cpu(INODE_PKEY(inode)->k_objectid),
 		 inode->i_generation);
 
-	xadir = lookup_or_create_dir(xaroot, namebuf, flags);
+	mutex_lock_nested(&xaroot->d_inode->i_mutex, I_MUTEX_XATTR);
+
+	xadir = lookup_one_len(namebuf, xaroot, strlen(namebuf));
+	if (!IS_ERR(xadir) && !xadir->d_inode) {
+		int err = -ENODATA;
+		if (xattr_may_create(flags))
+			err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
+		if (err) {
+			dput(xadir);
+			xadir = ERR_PTR(err);
+		}
+	}
+
+	mutex_unlock(&xaroot->d_inode->i_mutex);
 	dput(xaroot);
 	return xadir;
-
 }
 
 /* The following are side effects of other operations that aren't explicitly
@@ -986,19 +990,33 @@ int reiserfs_lookup_privroot(struct supe
 int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 {
 	int err = 0;
+	struct dentry *privroot = REISERFS_SB(s)->priv_root;
 
 #ifdef CONFIG_REISERFS_FS_XATTR
 	err = xattr_mount_check(s);
 	if (err)
 		goto error;

-	if (!REISERFS_SB(s)->priv_root->d_inode && !(mount_flags & MS_RDONLY)) {
+	if (!privroot->d_inode && !(mount_flags & MS_RDONLY)) {
 		mutex_lock(&s->s_root->d_inode->i_mutex);
 		err = create_privroot(REISERFS_SB(s)->priv_root);
 		mutex_unlock(&s->s_root->d_inode->i_mutex);
 	}
-	if (!err)
+
+	if (privroot->d_inode) {
 		s->s_xattr = reiserfs_xattr_handlers;
+		mutex_lock(&privroot->d_inode->i_mutex);
+		if (!REISERFS_SB(s)->xattr_root) {
+			struct dentry *dentry;
+			dentry = lookup_one_len(XAROOT_NAME, privroot,
+						strlen(XAROOT_NAME));
+			if (!IS_ERR(dentry))
+				REISERFS_SB(s)->xattr_root = dentry;
+			else
+				err = PTR_ERR(dentry);
+		}
+		mutex_unlock(&privroot->d_inode->i_mutex);
+	}
 
 error:
 	if (err) {
@@ -1008,11 +1026,12 @@ error:
 #endif
 
 	/* The super_block MS_POSIXACL must mirror the (no)acl mount option. */
-	s->s_flags = s->s_flags & ~MS_POSIXACL;
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	if (reiserfs_posixacl(s))
 		s->s_flags |= MS_POSIXACL;
+	else
 #endif
+		s->s_flags &= ~MS_POSIXACL;
 
 	return err;
 }
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -402,7 +402,7 @@ struct reiserfs_sb_info {
 	int reserved_blocks;	/* amount of blocks reserved for further allocations */
 	spinlock_t bitmap_lock;	/* this lock on now only used to protect reserved_blocks variable */
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
-	struct dentry *xattr_root;	/* root of /.reiserfs_priv/.xa */
+	struct dentry *xattr_root;	/* root of /.reiserfs_priv/xattrs */
 	int j_errno;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -98,7 +98,7 @@ static inline size_t reiserfs_xattr_jcre
 
 	if ((REISERFS_I(inode)->i_flags & i_has_xattr_dir) == 0) {
 		nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
-		if (REISERFS_SB(inode->i_sb)->xattr_root == NULL)
+		if (!REISERFS_SB(inode->i_sb)->xattr_root->d_inode)
 			nblocks += JOURNAL_BLOCKS_PER_OBJECT(inode->i_sb);
 	}
 
-- 
Jeff Mahoney
SUSE Labs
