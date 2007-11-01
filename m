Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbXKAXR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbXKAXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbXKAXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58535 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576AbXKAXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:09:04 -0400
Subject: [PATCH 22/27] r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:56 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230856.ACD52E33@kernel>
Sender: linux-kernel-owner@vger.kernel.org
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
 linux-2.6.git-dave/fs/nfsd/vfs.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly fs/nfs/dir.c
--- linux-2.6.git/fs/nfs/dir.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly	2007-11-01 14:46:19.000000000 -0700
+++ linux-2.6.git-dave/fs/nfs/dir.c	2007-11-01 14:46:19.000000000 -0700
@@ -949,7 +949,8 @@ static int is_atomic_open(struct inode *
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
--- linux-2.6.git/fs/nfsd/vfs.c~r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly	2007-11-01 14:46:19.000000000 -0700
+++ linux-2.6.git-dave/fs/nfsd/vfs.c	2007-11-01 14:46:19.000000000 -0700
@@ -1862,7 +1862,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		IS_RDONLY(inode)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1873,7 +1873,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || IS_RDONLY(inode))
+			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
_
