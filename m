Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXIQS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXIQS2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXIQS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44031 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbXIQS1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:24 -0400
Subject: [PATCH 03/24] create cleanup helper svc_msnfs()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:21 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182721.8EF73A09@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm going to be modifying nfsd_rename() shortly to support
read-only bind mounts.  This #ifdef is around the area I'm
patching, and it starts to get really ugly if I just try
to add my new code by itself.  Using this little helper
makes things a lot cleaner to use.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/nfsd/vfs.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/vfs.c~create-svc_msnfs-helper fs/nfsd/vfs.c
--- lxc/fs/nfsd/vfs.c~create-svc_msnfs-helper	2007-09-17 09:43:56.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-09-17 09:43:56.000000000 -0700
@@ -865,6 +865,15 @@ static int nfsd_direct_splice_actor(stru
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
@@ -877,11 +886,9 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 
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
