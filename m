Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXITTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXITTx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXITTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:52:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42393 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbXITTw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:52:56 -0400
Subject: [PATCH 04/25] create cleanup helper svc_msnfs()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:52:53 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195253.3A6CC036@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm going to be modifying nfsd_rename() shortly to support
read-only bind mounts.  This #ifdef is around the area I'm
patching, and it starts to get really ugly if I just try
to add my new code by itself.  Using this little helper
makes things a lot cleaner to use.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/nfsd/vfs.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/vfs.c~create-svc_msnfs-helper fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~create-svc_msnfs-helper	2007-09-20 12:16:10.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-09-20 12:16:10.000000000 -0700
@@ -857,6 +857,15 @@ static int nfsd_direct_splice_actor(stru
 	return __splice_from_pipe(pipe, sd, nfsd_splice_actor);
 }
 
+static inline int svc_msnfs(struct svc_fh *ffhp)
+{
+#ifdef MSNFS
+	return (ffhp->fh_export->ex_flags & NFSEXP_MSNFS);
+#else
+	return 0;
+#endif
+}
+
 static __be32
 nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
               loff_t offset, struct kvec *vec, int vlen, unsigned long *count)
@@ -869,11 +878,9 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 
 	err = nfserr_perm;
 	inode = file->f_path.dentry->d_inode;
-#ifdef MSNFS
-	if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
-		(!lock_may_read(inode, offset, *count)))
+
+	if (svc_msnfs(fhp) && !lock_may_read(inode, offset, *count))
 		goto out;
-#endif
 
 	/* Get readahead parameters */
 	ra = nfsd_get_raparms(inode->i_sb->s_dev, inode->i_ino);
_
