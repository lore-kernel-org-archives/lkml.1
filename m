Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbXITT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbXITT5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXITTxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49180 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbXITTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:14 -0400
Subject: [PATCH 16/25] elevate write count over calls to vfs_rename()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:09 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195309.18E26A29@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This also uses the little helper in the NFS code to
make an if() a little bit less ugly.  We introduced
the helper at the beginning of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/namei.c    |    4 ++++
 lxc-dave/fs/nfsd/vfs.c |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~elevate-write-count-over-calls-to-vfs-rename fs/namei.c
--- lxc/fs/namei.c~elevate-write-count-over-calls-to-vfs-rename	2007-09-20 12:16:18.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:18.000000000 -0700
@@ -2630,8 +2630,12 @@ static int do_rename(int olddfd, const c
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
diff -puN fs/nfsd/vfs.c~elevate-write-count-over-calls-to-vfs-rename fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~elevate-write-count-over-calls-to-vfs-rename	2007-09-20 12:16:18.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-09-20 12:16:18.000000000 -0700
@@ -1651,13 +1651,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
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
