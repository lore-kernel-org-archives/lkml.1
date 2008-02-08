Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbYBHWbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbYBHWbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYBHW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:08 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46176 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547AbYBHW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:05 -0500
Subject: [RFC][PATCH 11/30] r/o bind mounts: elevate write count for callers of vfs_mkdir()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:01 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222701.8397FA69@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty self-explanatory.  Fits in with the rest of the series.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c            |    5 +++++
 linux-2.6.git-dave/fs/nfsd/nfs4recover.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2008-02-08 13:04:50.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-08 13:04:50.000000000 -0800
@@ -2080,7 +2080,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
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
diff -puN fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/nfsd/nfs4recover.c
--- linux-2.6.git/fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2008-02-08 13:04:50.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4recover.c	2008-02-08 13:04:50.000000000 -0800
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
 	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
+	mnt_drop_write(rec_dir.mnt);
 out_put:
 	dput(dentry);
 out_unlock:
_
