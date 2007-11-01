Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbXKAXKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbXKAXKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXKAXIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49391 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbXKAXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:40 -0400
Subject: [PATCH 08/27] r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:36 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230836.5664FADD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c            |    5 +++++
 linux-2.6.git-dave/fs/nfsd/nfs4recover.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2007-11-01 14:46:09.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:09.000000000 -0700
@@ -2067,7 +2067,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
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
--- linux-2.6.git/fs/nfsd/nfs4recover.c~r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir	2007-11-01 14:46:09.000000000 -0700
+++ linux-2.6.git-dave/fs/nfsd/nfs4recover.c	2007-11-01 14:46:09.000000000 -0700
@@ -41,6 +41,7 @@
 #include <linux/nfsd/xdr4.h>
 #include <linux/param.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <asm/uaccess.h>
 #include <asm/scatterlist.h>
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
