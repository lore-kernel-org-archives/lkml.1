Return-Path: <linux-kernel-owner+w=401wt.eu-S1764120AbYBOWt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764120AbYBOWt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbYBOWiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:03 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36210 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765572AbYBOWhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:53 -0500
Subject: [PATCH 21/30] r/o bind mounts: get write access for vfs_rename() callers
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:49 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223749.E8D2C121@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This also uses the little helper in the NFS code to make an if() a little bit
less ugly.  We introduced the helper at the beginning of the series.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c    |    4 ++++
 linux-2.6.git-dave/fs/nfsd/vfs.c |   17 +++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename	2008-02-15 13:25:54.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:54.000000000 -0800
@@ -2751,8 +2751,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.path.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/nfsd/vfs.c
--- linux-2.6.git/fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename	2008-02-15 13:25:54.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/vfs.c	2008-02-15 13:25:54.000000000 -0800
@@ -1678,13 +1678,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (ndentry == trap)
 		goto out_dput_new;
 
-#ifdef MSNFS
-	if ((ffhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
+	if (svc_msnfs(ffhp) &&
 		((atomic_read(&odentry->d_count) > 1)
 		 || (atomic_read(&ndentry->d_count) > 1))) {
 			host_err = -EPERM;
-	} else
-#endif
+			goto out_dput_new;
+	}
+
+	host_err = -EXDEV;
+	if (ffhp->fh_export->ex_mnt != tfhp->fh_export->ex_mnt)
+		goto out_dput_new;
+	host_err = mnt_want_write(ffhp->fh_export->ex_mnt);
+	if (host_err)
+		goto out_dput_new;
+
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
@@ -1692,6 +1699,8 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 			host_err = nfsd_sync_dir(fdentry);
 	}
 
+	mnt_drop_write(ffhp->fh_export->ex_mnt);
+
  out_dput_new:
 	dput(ndentry);
  out_dput_old:
_
