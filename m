Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXIQSbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXIQSbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXIQS1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50480 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXIQS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:42 -0400
Subject: [PATCH 16/24] nfs: check mnt instead of superblock directly
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:39 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182739.6987C126@kernel>
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
--- lxc/fs/nfs/dir.c~nfs-check-mnt-instead-of-sb	2007-09-17 09:44:05.000000000 -0700
+++ lxc-dave/fs/nfs/dir.c	2007-09-17 09:44:05.000000000 -0700
@@ -997,7 +997,8 @@ static int is_atomic_open(struct inode *
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
--- lxc/fs/nfsd/vfs.c~nfs-check-mnt-instead-of-sb	2007-09-17 09:44:05.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-09-17 09:44:05.000000000 -0700
@@ -1853,7 +1853,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1864,7 +1864,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
_
