Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZECKGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZECKGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 06:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZECKGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 06:06:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZECKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 06:06:33 -0400
Date: Sun, 3 May 2009 11:06:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
Message-ID: <20090503100632.GV8633@ZenIV.linux.org.uk>
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk> <20090503091507.GU8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503091507.GU8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 10:15:08AM +0100, Al Viro wrote:

> > I've applied your patch as-is, and unless you have objections to the
> > variant above I'll do that as incremental.  Comments?
> 
> BTW, what in the name of everything unholy is ->xattr_root?  Never
> assigned a non-NULL value...

Looks like your xattr journalling is b0rken - the check in there should
be that for ->priv_root, AFAICS.  Anyway, promised incremental follows (FWIW,
it's commit ff4559 in git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/
on #untested).

[PATCH] Always lookup priv_root on reiserfs mount and keep it

... even if it's a negative dentry.  That way we can set ->d_op on
root before anyone could race with us.  Simplify d_compare(), while
we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/reiserfs/super.c            |    6 ++-
 fs/reiserfs/xattr.c            |   86 +++++++++++++++++-----------------------
 include/linux/reiserfs_xattr.h |    1 +
 3 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 5d0064d..f45cac9 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1845,7 +1845,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 			goto error;
 		}
 
-		if ((errval = reiserfs_xattr_init(s, s->s_flags))) {
+		if ((errval = reiserfs_lookup_privroot(s)) ||
+		    (errval = reiserfs_xattr_init(s, s->s_flags))) {
 			dput(s->s_root);
 			s->s_root = NULL;
 			goto error;
@@ -1858,7 +1859,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 			reiserfs_info(s, "using 3.5.x disk format\n");
 		}
 
-		if ((errval = reiserfs_xattr_init(s, s->s_flags))) {
+		if ((errval = reiserfs_lookup_privroot(s)) ||
+		    (errval = reiserfs_xattr_init(s, s->s_flags))) {
 			dput(s->s_root);
 			s->s_root = NULL;
 			goto error;
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 31a3dbb..2891f78 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -903,16 +903,19 @@ static int create_privroot(struct dentry *dentry)
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
 
 	err = xattr_mkdir(inode, dentry, 0700);
-	if (err) {
-		dput(dentry);
-		dentry = NULL;
+	if (err || !dentry->d_inode) {
+		reiserfs_warning(dentry->d_sb, "jdm-20006",
+				 "xattrs/ACLs enabled and couldn't "
+				 "find/create .reiserfs_priv. "
+				 "Failing mount.");
+		return -EOPNOTSUPP;
 	}
 
-	if (dentry && dentry->d_inode)
-		reiserfs_info(dentry->d_sb, "Created %s - reserved for xattr "
-			      "storage.\n", PRIVROOT_NAME);
+	dentry->d_inode->i_flags |= S_PRIVATE;
+	reiserfs_info(dentry->d_sb, "Created %s - reserved for xattr "
+		      "storage.\n", PRIVROOT_NAME);
 
-	return err;
+	return 0;
 }
 
 static int xattr_mount_check(struct super_block *s)
@@ -944,11 +947,9 @@ static int
 xattr_lookup_poison(struct dentry *dentry, struct qstr *q1, struct qstr *name)
 {
 	struct dentry *priv_root = REISERFS_SB(dentry->d_sb)->priv_root;
-	if (name->len == priv_root->d_name.len &&
-	    name->hash == priv_root->d_name.hash &&
-	    !memcmp(name->name, priv_root->d_name.name, name->len)) {
+	if (container_of(q1, struct dentry, d_name) == priv_root)
 		return -ENOENT;
-	} else if (q1->len == name->len &&
+	if (q1->len == name->len &&
 		   !memcmp(q1->name, name->name, name->len))
 		return 0;
 	return 1;
@@ -958,6 +959,27 @@ static const struct dentry_operations xattr_lookup_poison_ops = {
 	.d_compare = xattr_lookup_poison,
 };
 
+int reiserfs_lookup_privroot(struct super_block *s)
+{
+	struct dentry *dentry;
+	int err = 0;
+
+	/* If we don't have the privroot located yet - go find it */
+	mutex_lock(&s->s_root->d_inode->i_mutex);
+	dentry = lookup_one_len(PRIVROOT_NAME, s->s_root,
+				strlen(PRIVROOT_NAME));
+	if (!IS_ERR(dentry)) {
+		REISERFS_SB(s)->priv_root = dentry;
+		s->s_root->d_op = &xattr_lookup_poison_ops;
+		if (dentry->d_inode)
+			dentry->d_inode->i_flags |= S_PRIVATE;
+	} else
+		err = PTR_ERR(dentry);
+	mutex_unlock(&s->s_root->d_inode->i_mutex);
+
+	return err;
+}
+
 /* We need to take a copy of the mount flags since things like
  * MS_RDONLY don't get set until *after* we're called.
  * mount_flags != mount_options */
@@ -969,48 +991,12 @@ int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 	err = xattr_mount_check(s);
 	if (err)
 		goto error;
-#endif
 
-	/* If we don't have the privroot located yet - go find it */
-	if (!REISERFS_SB(s)->priv_root) {
-		struct dentry *dentry;
-		mutex_lock_nested(&s->s_root->d_inode->i_mutex, I_MUTEX_CHILD);
-		dentry = lookup_one_len(PRIVROOT_NAME, s->s_root,
-					strlen(PRIVROOT_NAME));
-		if (!IS_ERR(dentry)) {
-#ifdef CONFIG_REISERFS_FS_XATTR
-			if (!(mount_flags & MS_RDONLY) && !dentry->d_inode)
-				err = create_privroot(dentry);
-#endif
-			if (!dentry->d_inode) {
-				dput(dentry);
-				dentry = NULL;
-			}
-		} else
-			err = PTR_ERR(dentry);
+	if (!REISERFS_SB(s)->priv_root->d_inode && !(mount_flags & MS_RDONLY)) {
+		mutex_lock(&s->s_root->d_inode->i_mutex);
+		err = create_privroot(REISERFS_SB(s)->priv_root);
 		mutex_unlock(&s->s_root->d_inode->i_mutex);
-
-		if (!err && dentry) {
-			s->s_root->d_op = &xattr_lookup_poison_ops;
-			dentry->d_inode->i_flags |= S_PRIVATE;
-			REISERFS_SB(s)->priv_root = dentry;
-#ifdef CONFIG_REISERFS_FS_XATTR
-		/* xattrs are unavailable */
-		} else if (!(mount_flags & MS_RDONLY)) {
-			/* If we're read-only it just means that the dir
-			 * hasn't been created. Not an error -- just no
-			 * xattrs on the fs. We'll check again if we
-			 * go read-write */
-			reiserfs_warning(s, "jdm-20006",
-					 "xattrs/ACLs enabled and couldn't "
-					 "find/create .reiserfs_priv. "
-					 "Failing mount.");
-			err = -EOPNOTSUPP;
-#endif
-		}
 	}
-
-#ifdef CONFIG_REISERFS_FS_XATTR
 	if (!err)
 		s->s_xattr = reiserfs_xattr_handlers;
 
diff --git a/include/linux/reiserfs_xattr.h b/include/linux/reiserfs_xattr.h
index dcae01e..fea1a8e 100644
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -38,6 +38,7 @@ struct nameidata;
 int reiserfs_xattr_register_handlers(void) __init;
 void reiserfs_xattr_unregister_handlers(void);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
+int reiserfs_lookup_privroot(struct super_block *sb);
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 
-- 
1.5.6.5

