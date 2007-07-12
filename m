Return-Path: <linux-kernel-owner+w=401wt.eu-S937535AbXGLATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937535AbXGLATY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936229AbXGLARW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38112 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070AbXGLARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:15 -0400
Subject: [PATCH 02/23] create cleanup helper svc_msnfs()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:12 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001712.14A5552E@kernel>
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
--- lxc/fs/nfsd/vfs.c~create-svc_msnfs-helper	2007-07-10 12:46:02.000000000 -0700
+++ lxc-dave/fs/nfsd/vfs.c	2007-07-10 12:46:02.000000000 -0700
@@ -837,6 +837,15 @@ nfsd_read_actor(read_descriptor_t *desc,
 	return size;
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
@@ -849,11 +858,9 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 
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
