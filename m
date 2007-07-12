Return-Path: <linux-kernel-owner+w=401wt.eu-S937795AbXGLAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937795AbXGLAXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXGLARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33762 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952AbXGLARf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:35 -0400
Subject: [PATCH 16/23] elevate write count over calls to vfs_rename()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:31 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001731.D188AE30@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This also uses the little helper in the NFS code to
make an if() a little bit less ugly.  We introduced
the helper at the beginning of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c    |    4 ++++
 lxc-dave/fs/nfsd/vfs.c |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~elevate-write-count-over-calls-to-vfs-rename fs/namei.c
--- lxc/fs/namei.c~elevate-write-count-over-calls-to-vfs-rename	2007-07-10 12:46:12.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-10 12:46:12.000000000 -0700
@@ -2597,8 +2597,12 @@ static int do_rename(int olddfd, const c
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
--- lxc/fs/nfsd/vfs.c~elevate-write-count-over-calls-to-vfs-rename	2007-07-10 12:46:12.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-07-10 12:46:12.000000000 -0700
@@ -1622,13 +1622,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
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
