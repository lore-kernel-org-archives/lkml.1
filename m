Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbXITT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbXITT4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXITTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41963 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXITTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:10 -0400
Subject: [PATCH 10/25] elevate mnt writers for callers of vfs_mkdir()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:01 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195301.A505A68F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/namei.c            |    5 +++++
 lxc-dave/fs/nfsd/nfs4recover.c |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-09-20 12:16:14.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:14.000000000 -0700
@@ -2026,7 +2026,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
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
--- lxc/fs/nfsd/nfs4recover.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-09-20 12:16:14.000000000 -0700
+++ lxc-dave/fs/nfsd/nfs4recover.c	2007-09-20 12:16:14.000000000 -0700
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
