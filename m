Return-Path: <linux-kernel-owner+w=401wt.eu-S1161035AbXBGIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161035AbXBGIzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030600AbXBGIzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:55:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:52084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030578AbXBGIzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:55:36 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Wed, 7 Feb 2007 00:55:10 -0800
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051813.26958.agruen@suse.de> <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uPZyFo7/DQLocWI"
Message-Id: <200702070055.10856.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uPZyFo7/DQLocWI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 06 February 2007 04:55, Stephen Smalley wrote:
> On Mon, 2007-02-05 at 18:13 -0800, Andreas Gruenbacher wrote:
> > 	Reiserfs should probably just mark all its xattr inodes as private in
> > order to play nicely with other lsms. As far as pathname based lsms are
> > concerned, pathnames to those fs-internal objects are meaningless though,
> > and so we pass NULL here.
>
> That should be handled by the current marking of reiserfs xattr inodes
> with S_PRIVATE and the tests for IS_PRIVATE in include/linux/security.h
> (and in one instance, within SELinux itself).

Reiserfs currently only marks the ".reiserfs_priv" directory as private, but 
not the files below it -- how about the attached patch to fix that?

Andreas

--Boundary-00=_uPZyFo7/DQLocWI
Content-Type: text/x-diff;
  charset="utf-8";
  name="reiserfs-mark-xattrs-private.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="reiserfs-mark-xattrs-private.diff"

Fix reiserfs xattrs for selinux

Mark all inodes used for reiserfs xattrs as private so that selinux
(or any other LSM) will not try to mediate access to the files and
directories used as the xattr backing store. The xattr operations
are already protected through the xattr LSM hooks.

There is no real reason for having reiserfs_mark_inode_private --
remove it and directly mark the inodes as private.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeff Mahoney <jeffm@suse.de>

Index: b/fs/reiserfs/xattr.c
===================================================================
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -79,6 +79,7 @@ static struct dentry *create_xa_root(str
 			dput(privroot);
 			return ERR_PTR(err);
 		}
+		xaroot->d_inode->i_flags |= S_PRIVATE;
 		REISERFS_SB(sb)->xattr_root = dget(xaroot);
 	}
 
@@ -108,6 +109,7 @@ static struct dentry *__get_xa_root(stru
 		goto out;
 	}
 
+	xaroot->d_inode->i_flags |= S_PRIVATE;
 	REISERFS_SB(s)->xattr_root = dget(xaroot);
 
       out:
@@ -183,6 +185,7 @@ static struct dentry *open_xa_dir(const 
 			return ERR_PTR(-ENODATA);
 		}
 	}
+	xadir->d_inode->i_flags |= S_PRIVATE;
 
 	dput(xaroot);
 	return xadir;
@@ -235,6 +238,8 @@ static struct dentry *get_xa_file_dentry
 	dput(xadir);
 	if (err)
 		xafile = ERR_PTR(err);
+	else
+		xafile->d_inode->i_flags |= S_PRIVATE;
 	return xafile;
 }
 
@@ -715,6 +720,7 @@ __reiserfs_xattr_del(struct dentry *xadi
 		err = -ENODATA;
 		goto out_file;
 	}
+	dentry->d_inode->i_flags |= S_PRIVATE;
 
 	/* Skip directories.. */
 	if (S_ISDIR(dentry->d_inode->i_mode))
@@ -865,6 +871,7 @@ reiserfs_chown_xattrs_filler(void *buf, 
 		dput(xafile);
 		return -ENODATA;
 	}
+	xafile->d_inode->i_flags |= S_PRIVATE;
 
 	if (!S_ISDIR(xafile->d_inode->i_mode))
 		err = notify_change(xafile, NULL, attrs);
@@ -1289,7 +1296,7 @@ int reiserfs_xattr_init(struct super_blo
 
 		if (!err && dentry) {
 			s->s_root->d_op = &xattr_lookup_poison_ops;
-			reiserfs_mark_inode_private(dentry->d_inode);
+			dentry->d_inode->i_flags |= S_PRIVATE;
 			REISERFS_SB(s)->priv_root = dentry;
 		} else if (!(mount_flags & MS_RDONLY)) {	/* xattrs are unavailable */
 			/* If we're read-only it just means that the dir hasn't been
Index: b/include/linux/reiserfs_xattr.h
===================================================================
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -92,11 +92,6 @@ static inline void reiserfs_read_unlock_
 	up_read(&REISERFS_I(inode)->xattr_sem);
 }
 
-static inline void reiserfs_mark_inode_private(struct inode *inode)
-{
-	inode->i_flags |= S_PRIVATE;
-}
-
 static inline void reiserfs_init_xattr_rwsem(struct inode *inode)
 {
 	init_rwsem(&REISERFS_I(inode)->xattr_sem);
@@ -105,7 +100,6 @@ static inline void reiserfs_init_xattr_r
 #else
 
 #define is_reiserfs_priv_object(inode) 0
-#define reiserfs_mark_inode_private(inode) do {;} while(0)
 #define reiserfs_getxattr NULL
 #define reiserfs_setxattr NULL
 #define reiserfs_listxattr NULL
Index: b/fs/reiserfs/xattr_acl.c
===================================================================
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -336,7 +336,7 @@ reiserfs_inherit_default_acl(struct inod
 	 * would be useless since permissions are ignored, and a pain because
 	 * it introduces locking cycles */
 	if (is_reiserfs_priv_object(dir)) {
-		reiserfs_mark_inode_private(inode);
+		inode->i_flags |= S_PRIVATE;
 		goto apply_umask;
 	}
 

--Boundary-00=_uPZyFo7/DQLocWI--
