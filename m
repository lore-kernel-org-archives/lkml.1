Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbXKAXO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbXKAXO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759458AbXKAXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40082 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbXKAXIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:53 -0400
Subject: [PATCH 18/27] r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:50 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230850.2DD2790B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This also uses the little helper in the NFS code to make an if() a little bit
less ugly.  We introduced the helper at the beginning of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c    |    4 ++++
 linux-2.6.git-dave/fs/nfsd/vfs.c |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:16.000000000 -0700
@@ -2734,8 +2734,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/nfsd/vfs.c
--- linux-2.6.git/fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/fs/nfsd/vfs.c	2007-11-01 14:46:16.000000000 -0700
@@ -1668,13 +1668,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
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
_
