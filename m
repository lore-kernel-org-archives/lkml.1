Return-Path: <linux-kernel-owner+w=401wt.eu-S937587AbXGLAUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937587AbXGLAUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937454AbXGLAR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36156 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937072AbXGLAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:27 -0400
Subject: [PATCH 09/23] elevate mnt writers for callers of vfs_mkdir()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:22 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001722.4068399A@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c            |    5 +++++
 lxc-dave/fs/nfsd/nfs4recover.c |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-07-10 12:46:07.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-10 12:46:07.000000000 -0700
@@ -1993,7 +1993,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
+	mnt_drop_write(nd.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
diff -puN fs/nfsd/nfs4recover.c~elevate-mnt-writers-for-callers-of-vfs-mkdir fs/nfsd/nfs4recover.c
--- lxc/fs/nfsd/nfs4recover.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-07-10 12:46:07.000000000 -0700
+++ lxc-dave/fs/nfsd/nfs4recover.c	2007-07-10 12:46:07.000000000 -0700
@@ -156,7 +156,11 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
+	status = mnt_want_write(rec_dir.mnt);
+	if (status)
+		goto out_put;
 	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
_
