Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbZEAQLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbZEAQLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZEAQLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:11:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZEAQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:11:39 -0400
Message-ID: <49FB1F20.8040400@suse.com>
Date: Fri, 01 May 2009 12:11:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS
 bugs by ensuring that lookup_one_len is always called under i_mutex.

 This patch expands the i_mutex locking to enclose lookup_one_len. This was
 always required, but not not enforced in the reiserfs code since it
 does locking around the xattr interactions with the xattr_sem.

 This is obvious enough, but it survived an overnight 50 thread ACL test.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -120,25 +120,20 @@ static struct dentry *lookup_or_create_d
 	struct dentry *dentry;
 	BUG_ON(!parent);
 
+	mutex_lock_nested(&parent->d_inode->i_mutex, I_MUTEX_XATTR);
 	dentry = lookup_one_len(name, parent, strlen(name));
-	if (IS_ERR(dentry))
-		return dentry;
-	else if (!dentry->d_inode) {
+	if (!IS_ERR(dentry) && !dentry->d_inode) {
 		int err = -ENODATA;
 
-		if (xattr_may_create(flags)) {
-			mutex_lock_nested(&parent->d_inode->i_mutex,
-					  I_MUTEX_XATTR);
+		if (xattr_may_create(flags))
 			err = xattr_mkdir(parent->d_inode, dentry, 0700);
-			mutex_unlock(&parent->d_inode->i_mutex);
-		}
 
 		if (err) {
 			dput(dentry);
 			dentry = ERR_PTR(err);
 		}
 	}
-
+	mutex_unlock(&parent->d_inode->i_mutex);
 	return dentry;
 }
 
@@ -184,6 +179,7 @@ fill_with_dentries(void *buf, const char
 {
 	struct reiserfs_dentry_buf *dbuf = buf;
 	struct dentry *dentry;
+	WARN_ON_ONCE(!mutex_is_locked(&dbuf->xadir->d_inode->i_mutex));
 
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
 		return -ENOSPC;
@@ -349,6 +345,7 @@ static struct dentry *xattr_lookup(struc
 	if (IS_ERR(xadir))
 		return ERR_CAST(xadir);
 
+	mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 	xafile = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(xafile)) {
 		err = PTR_ERR(xafile);
@@ -360,18 +357,15 @@ static struct dentry *xattr_lookup(struc
 
 	if (!xafile->d_inode) {
 		err = -ENODATA;
-		if (xattr_may_create(flags)) {
-			mutex_lock_nested(&xadir->d_inode->i_mutex,
-					  I_MUTEX_XATTR);
+		if (xattr_may_create(flags))
 			err = xattr_create(xadir->d_inode, xafile,
 					      0700|S_IFREG);
-			mutex_unlock(&xadir->d_inode->i_mutex);
-		}
 	}
 
 	if (err)
 		dput(xafile);
 out:
+	mutex_unlock(&xadir->d_inode->i_mutex);
 	dput(xadir);
 	if (err)
 		return ERR_PTR(err);
@@ -435,6 +429,7 @@ static int lookup_and_delete_xattr(struc
 	if (IS_ERR(xadir))
 		return PTR_ERR(xadir);
 
+	mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 	dentry = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -442,14 +437,13 @@ static int lookup_and_delete_xattr(struc
 	}
 
 	if (dentry->d_inode) {
-		mutex_lock_nested(&xadir->d_inode->i_mutex, I_MUTEX_XATTR);
 		err = xattr_unlink(xadir->d_inode, dentry);
-		mutex_unlock(&xadir->d_inode->i_mutex);
 		update_ctime(inode);
 	}
 
 	dput(dentry);
 out_dput:
+	mutex_unlock(&xadir->d_inode->i_mutex);
 	dput(xadir);
 	return err;
 }
@@ -906,9 +900,9 @@ static int create_privroot(struct dentry
 {
 	int err;
 	struct inode *inode = dentry->d_parent->d_inode;
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_XATTR);
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
+
 	err = xattr_mkdir(inode, dentry, 0700);
-	mutex_unlock(&inode->i_mutex);
 	if (err) {
 		dput(dentry);
 		dentry = NULL;
@@ -980,6 +974,7 @@ int reiserfs_xattr_init(struct super_blo
 	/* If we don't have the privroot located yet - go find it */
 	if (!REISERFS_SB(s)->priv_root) {
 		struct dentry *dentry;
+		mutex_lock_nested(&s->s_root->d_inode->i_mutex, I_MUTEX_CHILD);
 		dentry = lookup_one_len(PRIVROOT_NAME, s->s_root,
 					strlen(PRIVROOT_NAME));
 		if (!IS_ERR(dentry)) {
@@ -993,6 +988,7 @@ int reiserfs_xattr_init(struct super_blo
 			}
 		} else
 			err = PTR_ERR(dentry);
+		mutex_unlock(&s->s_root->d_inode->i_mutex);
 
 		if (!err && dentry) {
 			s->s_root->d_op = &xattr_lookup_poison_ops;
-- 
Jeff Mahoney
SUSE Labs
