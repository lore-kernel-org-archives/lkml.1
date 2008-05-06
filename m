Return-Path: <linux-kernel-owner+w=401wt.eu-S1764847AbYEFJQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764847AbYEFJQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760887AbYEFJOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59491 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYEFJOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:18 -0400
Message-Id: <20080506091410.380189145@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>
Subject: [patch 04/24] reiserfs: dont call notify_change
Content-Disposition: inline; filename=reiserfs_notify_change_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Reiserfs calls notify_change() on it's private extended attribute
files to resize and change ownership of these files.  Replace with
reiserfs_setattr().

This is equivalent, except that:

 - i_alloc_sem locking is not performed around reiserfs_setattr() when
   the size is changed
 - security_inode_setattr() is not called before reiserfs_setattr()
 - fsnotify_change() is not called after reiserfs_setattr()

None of the above is necessary, since the files are private to
reiserfs and inaccessible from userspace.

Also remove setting of ctime on the xattr files.

Based on patch by Jeff Mahoney.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jeff Mahoney <jeffm@suse.de>
---
 fs/reiserfs/xattr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2008-05-06 11:04:33.000000000 +0200
+++ linux-2.6/fs/reiserfs/xattr.c	2008-05-06 11:04:33.000000000 +0200
@@ -458,9 +458,9 @@ reiserfs_xattr_set(struct inode *inode, 
 
 	/* Resize it so we're ok to write there */
 	newattrs.ia_size = buffer_size;
-	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
+	newattrs.ia_valid = ATTR_SIZE;
 	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
-	err = notify_change(dentry, &newattrs);
+	err = reiserfs_setattr(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -810,7 +810,7 @@ reiserfs_chown_xattrs_filler(void *buf, 
 	}
 
 	if (!S_ISDIR(xafile->d_inode->i_mode))
-		err = notify_change(xafile, attrs);
+		err = reiserfs_setattr(xafile, attrs);
 	dput(xafile);
 
 	return err;
@@ -843,7 +843,7 @@ int reiserfs_chown_xattrs(struct inode *
 
 	lock_kernel();
 
-	attrs->ia_valid &= (ATTR_UID | ATTR_GID | ATTR_CTIME);
+	attrs->ia_valid &= (ATTR_UID | ATTR_GID);
 	buf.xadir = dir;
 	buf.attrs = attrs;
 	buf.inode = inode;
@@ -854,7 +854,7 @@ int reiserfs_chown_xattrs(struct inode *
 		goto out_dir;
 	}
 
-	err = notify_change(dir, attrs);
+	err = reiserfs_setattr(dir, attrs);
 	unlock_kernel();
 
       out_dir:

--
