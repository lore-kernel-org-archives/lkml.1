Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbYBHWjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbYBHWjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYBHW1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:36 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56246 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYBHW10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:26 -0500
Subject: [RFC][PATCH 26/30] r/o bind mounts: check mnt instead of superblock directly
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:22 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222722.A03D8375@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we depend on the inodes for writeability, we will not catch the r/o mounts
when implemented.

This patches uses __mnt_want_write().  It does not guarantee that the mount
will stay writeable after the check.  But, this is OK for one of the checks
because it is just for a printk().

The other two are probably unnecessary and duplicate existing checks in the
VFS.  This won't make them better checks than before, but it will make them
detect r/o mounts.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/nfs/dir.c  |    3 ++-
 linux-2.6.git-dave/fs/nfsd/vfs.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly fs/nfs/dir.c
--- linux-2.6.git/fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly	2008-02-08 13:04:59.000000000 -0800
+++ linux-2.6.git-dave/fs/nfs/dir.c	2008-02-08 13:04:59.000000000 -0800
@@ -967,7 +967,8 @@ static int is_atomic_open(struct inode *
 	if (nd->flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (__mnt_is_readonly(nd->mnt) &&
+	    (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly fs/nfsd/vfs.c
--- linux-2.6.git/fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly	2008-02-08 13:04:59.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/vfs.c	2008-02-08 13:04:59.000000000 -0800
@@ -1873,7 +1873,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1884,7 +1884,8 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) ||
+			    __mnt_is_readonly(exp->ex_mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
_
