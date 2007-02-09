Return-Path: <linux-kernel-owner+w=401wt.eu-S1946143AbXBIWyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946143AbXBIWyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423364AbXBIWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:53:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46936 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbXBIWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:35 -0500
Subject: [PATCH 05/22] elevate mnt writers for callers of vfs_mkdir()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:32 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225332.1EE0065B@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


elevate mnt writers for callers of vfs_mkdir()

Pretty self-explanatory.  Fits in with the rest of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c            |    5 +++++
 lxc-dave/fs/nfsd/nfs4recover.c |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN fs/namei.c~07-24-elevate-mnt-writers-for-callers-of-vfs-mkdir fs/namei.c
--- lxc/fs/namei.c~07-24-elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-02-09 14:26:49.000000000 -0800
+++ lxc-dave/fs/namei.c	2007-02-09 14:26:49.000000000 -0800
@@ -1963,7 +1963,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 
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
diff -puN fs/nfsd/nfs4recover.c~07-24-elevate-mnt-writers-for-callers-of-vfs-mkdir fs/nfsd/nfs4recover.c
--- lxc/fs/nfsd/nfs4recover.c~07-24-elevate-mnt-writers-for-callers-of-vfs-mkdir	2007-02-09 14:26:49.000000000 -0800
+++ lxc-dave/fs/nfsd/nfs4recover.c	2007-02-09 14:26:49.000000000 -0800
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
