Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbYEEJzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbYEEJzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYEEJzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45946 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYEEJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:21 -0400
Message-Id: <20080505095509.480855416@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 02/15] nfsd: clean up mnt_want_write calls
Content-Disposition: inline; filename=nfsd_create_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Multiple mnt_want_write() calls in the switch statement looks really
ugly.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/vfs.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-05 11:29:21.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-05 11:29:24.000000000 +0200
@@ -1248,36 +1248,34 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		iap->ia_mode = 0;
 	iap->ia_mode = (iap->ia_mode & S_IALLUGO) | type;
 
+	err = nfserr_inval;
+	if (!S_ISREG(type) && !S_ISDIR(type) && !special_file(type)) {
+		printk(KERN_WARNING "nfsd: bad file type %o in nfsd_create\n",
+		       type);
+		goto out;
+	}
+
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	if (host_err)
+		goto out_nfserr;
+
 	/*
 	 * Get the dir op function pointer.
 	 */
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
 		break;
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
-		if (host_err)
-			goto out_nfserr;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
 		break;
-	default:
-	        printk("nfsd: bad file type %o in nfsd_create\n", type);
-		host_err = -EINVAL;
-		goto out_nfserr;
 	}
 	if (host_err < 0) {
 		mnt_drop_write(fhp->fh_export->ex_path.mnt);
@@ -1289,7 +1287,6 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		write_inode_now(dchild->d_inode, 1);
 	}
 
-
 	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
 	if (err2)
 		err = err2;

--
