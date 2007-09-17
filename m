Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXIQSdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXIQSdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbXIQS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39382 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbXIQS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:47 -0400
Subject: [PATCH 09/24] elevate mnt writers for callers of vfs_mkdir()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:29 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182729.14AEDAFA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c            |    5 +++++
 lxc-dave/fs/nfsd/nfs4recover.c |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-09-17 09:44:01.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-17 09:44:01.000000000 -0700
@@ -2051,7 +2051,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
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
--- lxc/fs/nfsd/nfs4recover.c~elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-09-17 09:44:01.000000000 -0700
+++ lxc-dave/fs/nfsd/nfs4recover.c	2007-09-17 09:44:01.000000000 -0700
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
