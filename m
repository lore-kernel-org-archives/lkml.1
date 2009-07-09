Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZGISFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZGISFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZGISFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:05:20 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38162 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZGISFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=drPdRzCthVIe+ffts0aQPtb8ZJpWl5Sni3awjiapXkGrlU4Yz1XcdVSh0wuvOGhZot
         K2n27VdfuOO42giiSSG9KVzz/0sSGqII3jCBKnNhF+PuK1oyWNp2Of/+WL4oWBYv4i4b
         FPLLSNYW3ds/rVAlnFBXvdGSfN1WzGHrUR0Eg=
Message-ID: <4A56315E.5030808@gmail.com>
Date: Thu, 09 Jul 2009 22:05:18 +0400
From: Eugene Kapun <abacabadabacaba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] reiserfs: fix crashes in extended attributes implementation
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Kapun <abacabadabacaba@gmail.com>

Fixes crashes when:
* .reiserfs_priv exists and is not a directory
* .reiserfs_priv/xattrs exists and is not a directory
* .reiserfs_prix/xattrs/<something> exists and is not a directory
* .reiserfs_priv/xattrs/<something>/<something> exists and is not a
  regular file
Signed-off-by: Eugene Kapun <abacabadabacaba@gmail.com>
---
This patch applies to linux-2.6.31-rc2-git4.
This patch depends on patch 2/3 (reiserfs: add mount option that
disables extended attributes support).
This patch prevents reiserfs from crashing if certain directories are
actually files or something else, and vice versa. Instead, it will
refuse to mount such filesystem or abort operations on files with -EIO.

 fs/reiserfs/super.c |   53 ++++++++++++++++++++++--------------------
 fs/reiserfs/xattr.c |   44 +++++++++++++++++++++++++++-------
 2 files changed, 63 insertions(+), 34 deletions(-)

diff -uprN linux-2.6.31-rc2-git3.2/fs/reiserfs/super.c linux-2.6.31-rc2-git3.3/fs/reiserfs/super.c
--- linux-2.6.31-rc2-git3.2/fs/reiserfs/super.c	2009-07-09 15:03:10.000000000 +0400
+++ linux-2.6.31-rc2-git3.3/fs/reiserfs/super.c	2009-07-09 13:57:15.000000000 +0400
@@ -1762,11 +1762,8 @@ static int reiserfs_fill_super(struct su
 	}
 	// define and initialize hash function
 	sbi->s_hash_function = hash_function(s);
-	if (sbi->s_hash_function == NULL) {
-		dput(s->s_root);
-		s->s_root = NULL;
-		goto error;
-	}
+	if (sbi->s_hash_function == NULL)
+		goto error_root;
 
 	if (is_reiserfs_3_5(rs)
 	    || (is_reiserfs_jr(rs) && SB_VERSION(s) == REISERFS_VERSION_1))
@@ -1779,11 +1776,8 @@ static int reiserfs_fill_super(struct su
 	if (!(s->s_flags & MS_RDONLY)) {
 
 		errval = journal_begin(&th, s, 1);
-		if (errval) {
-			dput(s->s_root);
-			s->s_root = NULL;
-			goto error;
-		}
+		if (errval)
+			goto error_root;
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
 
 		set_sb_umount_state(rs, REISERFS_ERROR_FS);
@@ -1834,18 +1828,12 @@ static int reiserfs_fill_super(struct su
 
 		journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 		errval = journal_end(&th, s, 1);
-		if (errval) {
-			dput(s->s_root);
-			s->s_root = NULL;
-			goto error;
-		}
+		if (errval)
+			goto error_root;
 
 		if ((errval = reiserfs_lookup_privroot(s)) ||
-		    (errval = reiserfs_xattr_init(s, s->s_flags))) {
-			dput(s->s_root);
-			s->s_root = NULL;
-			goto error;
-		}
+		    (errval = reiserfs_xattr_init(s, s->s_flags)))
+			goto error_privroot;
 
 		/* look for files which were to be removed in previous session */
 		finish_unfinished(s);
@@ -1855,11 +1843,8 @@ static int reiserfs_fill_super(struct su
 		}
 
 		if ((errval = reiserfs_lookup_privroot(s)) ||
-		    (errval = reiserfs_xattr_init(s, s->s_flags))) {
-			dput(s->s_root);
-			s->s_root = NULL;
-			goto error;
-		}
+		    (errval = reiserfs_xattr_init(s, s->s_flags)))
+			goto error_privroot;
 	}
 	// mark hash in super block: it could be unset. overwrite should be ok
 	set_sb_hash_function_code(rs, function2code(sbi->s_hash_function));
@@ -1873,6 +1858,24 @@ static int reiserfs_fill_super(struct su
 
 	return (0);
 
+error_privroot:
+#ifdef CONFIG_REISERFS_FS_EXTENDED
+	if (REISERFS_SB(s)->priv_root) {
+		if (REISERFS_SB(s)->xattr_root) {
+			d_invalidate(REISERFS_SB(s)->xattr_root);
+			dput(REISERFS_SB(s)->xattr_root);
+			REISERFS_SB(s)->xattr_root = NULL;
+		}
+		d_invalidate(REISERFS_SB(s)->priv_root);
+		dput(REISERFS_SB(s)->priv_root);
+		REISERFS_SB(s)->priv_root = NULL;
+	}
+#endif
+
+error_root:
+	dput(s->s_root);
+	s->s_root = NULL;
+
 error:
 	if (jinit_done) {	/* kill the commit thread, free journal ram */
 		journal_release_error(NULL, s);
diff -uprN linux-2.6.31-rc2-git3.2/fs/reiserfs/xattr.c linux-2.6.31-rc2-git3.3/fs/reiserfs/xattr.c
--- linux-2.6.31-rc2-git3.2/fs/reiserfs/xattr.c	2009-07-09 15:06:12.000000000 +0400
+++ linux-2.6.31-rc2-git3.3/fs/reiserfs/xattr.c	2009-07-09 13:57:15.000000000 +0400
@@ -155,10 +155,17 @@ static struct dentry *open_xa_dir(const 
 	mutex_lock_nested(&xaroot->d_inode->i_mutex, I_MUTEX_XATTR);
 
 	xadir = lookup_one_len(namebuf, xaroot, strlen(namebuf));
-	if (!IS_ERR(xadir) && !xadir->d_inode) {
-		int err = -ENODATA;
-		if (xattr_may_create(flags))
-			err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
+	if (!IS_ERR(xadir)) {
+		int err;
+		if (xadir->d_inode) {
+			err = 0;
+			if (!S_ISDIR(xadir->d_inode->i_mode))
+				err = -EIO;
+		} else {
+			err = -ENODATA;
+			if (xattr_may_create(flags))
+				err = xattr_mkdir(xaroot->d_inode, xadir, 0700);
+		}
 		if (err) {
 			dput(xadir);
 			xadir = ERR_PTR(err);
@@ -372,7 +379,8 @@ static struct dentry *xattr_lookup(struc
 		if (xattr_may_create(flags))
 			err = xattr_create(xadir->d_inode, xafile,
 					      0700|S_IFREG);
-	}
+	} else if (!S_ISREG(xafile->d_inode->i_mode))
+		err = -EIO;
 
 	if (err)
 		dput(xafile);
@@ -992,8 +1000,17 @@ int reiserfs_lookup_privroot(struct supe
 		REISERFS_SB(s)->priv_root = dentry;
 		if (!reiserfs_expose_privroot(s))
 			s->s_root->d_op = &xattr_lookup_poison_ops;
-		if (dentry->d_inode)
-			dentry->d_inode->i_flags |= S_PRIVATE;
+		if (dentry->d_inode) {
+			if (S_ISDIR(dentry->d_inode->i_mode)) {
+				dentry->d_inode->i_flags |= S_PRIVATE;
+			} else {
+				reiserfs_warning(s, NULL,
+					PRIVROOT_NAME " exists and "
+					"is not a directory. Remount "
+					"with -o noext to fix this");
+				err = -EINVAL;
+			}
+		}
 	} else
 		err = PTR_ERR(dentry);
 	mutex_unlock(&s->s_root->d_inode->i_mutex);
@@ -1028,9 +1045,18 @@ int reiserfs_xattr_init(struct super_blo
 			struct dentry *dentry;
 			dentry = lookup_one_len(XAROOT_NAME, privroot,
 						strlen(XAROOT_NAME));
-			if (!IS_ERR(dentry))
+			if (!IS_ERR(dentry)) {
 				REISERFS_SB(s)->xattr_root = dentry;
-			else
+				if (dentry->d_inode &&
+					!S_ISDIR(dentry->d_inode->i_mode)) {
+					reiserfs_warning(s, NULL,
+						PRIVROOT_NAME "/" XAROOT_NAME
+						" exists and is not "
+						"a directory. Remount with "
+						"-o noext to fix this");
+					err = -EINVAL;
+				}
+			} else
 				err = PTR_ERR(dentry);
 		}
 		mutex_unlock(&privroot->d_inode->i_mutex);


