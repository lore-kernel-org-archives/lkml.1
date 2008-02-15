Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbYBOWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbYBOWn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763720AbYBOWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60213 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763694AbYBOWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:40 -0500
Subject: [PATCH 11/30] r/o bind mounts: elevate write count for callers of vfs_mkdir()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:35 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223735.CBBD2484@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty self-explanatory.  Fits in with the rest of the series.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c            |    5 +++++
 linux-2.6.git-dave/fs/nfsd/nfs4recover.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2008-02-15 13:25:47.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:47.000000000 -0800
@@ -2082,7 +2082,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
diff -puN fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/nfsd/nfs4recover.c
--- linux-2.6.git/fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2008-02-15 13:25:47.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4recover.c	2008-02-15 13:25:47.000000000 -0800
@@ -41,6 +41,7 @@
 #include <linux/nfsd/xdr4.h>
 #include <linux/param.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <asm/uaccess.h>
 #include <linux/scatterlist.h>
@@ -154,7 +155,11 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
+	status = mnt_want_write(rec_dir.mnt);
+	if (status)
+		goto out_put;
 	status = vfs_mkdir(rec_dir.path.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
_
