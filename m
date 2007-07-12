Return-Path: <linux-kernel-owner+w=401wt.eu-S1765992AbXGLA2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765992AbXGLA2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936883AbXGLASW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36286 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937538AbXGLARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:37 -0400
Subject: [PATCH 17/23] nfs: check mnt instead of superblock directly
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:33 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001733.C031FBB7@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If we depend on the inodes for writeability, we will not
catch the r/o mounts when implemented.

This patches uses __mnt_want_write().  It does not guarantee
that the mount will stay writeable after the check.  But,
this is OK for one of the checks because it is just for a
printk().

The other two are probably unnecessary and duplicate existing
checks in the VFS.  This won't make them better checks than
before, but it will make them detect r/o mounts.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/nfs/dir.c  |    3 ++-
 lxc-dave/fs/nfsd/vfs.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nfs/dir.c~nfs-check-mnt-instead-of-sb fs/nfs/dir.c
--- lxc/fs/nfs/dir.c~nfs-check-mnt-instead-of-sb	2007-07-10 12:46:13.000000000 -0700
+++ lxc-dave/fs/nfs/dir.c	2007-07-10 12:46:13.000000000 -0700
@@ -998,7 +998,8 @@ static int is_atomic_open(struct inode *
 	if (nd->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (__mnt_is_readonly(nd->mnt) &&
+	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
diff -puN fs/nfsd/vfs.c~nfs-check-mnt-instead-of-sb fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~nfs-check-mnt-instead-of-sb	2007-07-10 12:46:13.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-07-10 12:46:13.000000000 -0700
@@ -1810,7 +1810,7 @@ nfsd_permission(struct svc_export *exp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1821,7 +1821,7 @@ nfsd_permission(struct svc_export *exp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (EX_RDONLY(exp) || IS_RDONLY(inode))
+			if (EX_RDONLY(exp) || __mnt_is_readonly(exp->ex_mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
_
