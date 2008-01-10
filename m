Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYAJTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYAJTHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYAJTHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:08 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33192 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbYAJTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:07:06 -0500
Subject: [RFC][PATCH 1/4] use helper to set mnt_sb
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 10 Jan 2008 11:06:58 -0800
References: <20080110190657.92A8B61F@kernel>
In-Reply-To: <20080110190657.92A8B61F@kernel>
Message-Id: <20080110190658.4BF4421A@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to make sure that all mounts get into the
sb list.  So, require that new setters of mnt->mnt_sb
use simple_set_mnt() instead of doing it themselves.

NFS does the same thing a few times in a row, so give
it a nice little helper.

---

 linux-2.6.git-dave/fs/namespace.c |    3 +--
 linux-2.6.git-dave/fs/nfs/super.c |   31 ++++++++++++++++---------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/namespace.c~make-mnt_sb-off-limits fs/namespace.c
--- linux-2.6.git/fs/namespace.c~make-mnt_sb-off-limits	2008-01-10 10:36:37.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2008-01-10 10:36:37.000000000 -0800
@@ -486,8 +486,7 @@ static struct vfsmount *clone_mnt(struct
 	if (mnt) {
 		mnt->mnt_flags = old->mnt_flags;
 		atomic_inc(&sb->s_active);
-		mnt->mnt_sb = sb;
-		mnt->mnt_root = dget(root);
+		simple_set_mnt(mnt, sb);
 		mnt->mnt_mountpoint = mnt->mnt_root;
 		mnt->mnt_parent = mnt;
 
diff -puN fs/nfs/super.c~make-mnt_sb-off-limits fs/nfs/super.c
--- linux-2.6.git/fs/nfs/super.c~make-mnt_sb-off-limits	2008-01-10 10:36:37.000000000 -0800
+++ linux-2.6.git-dave/fs/nfs/super.c	2008-01-10 10:36:37.000000000 -0800
@@ -1364,6 +1364,17 @@ static int nfs_compare_super(struct supe
 	return nfs_compare_mount_options(sb, server, mntflags);
 }
 
+static void nfs_set_mnt(struct vfsmount *mnt, struct super_block *s)
+{
+	s->s_flags |= MS_ACTIVE;
+	simple_set_mnt(mnt, s);
+	/*
+	 * simple_set_mnt() does a dput, which we already did
+	 * in nfs_get_root().
+	 */
+	dput(s->s_root);
+}
+
 static int nfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
@@ -1417,9 +1428,7 @@ static int nfs_get_sb(struct file_system
 		goto error_splat_super;
 	}
 
-	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
-	mnt->mnt_root = mntroot;
+	nfs_set_mnt(mnt, s);
 	error = 0;
 
 out:
@@ -1505,9 +1514,7 @@ static int nfs_xdev_get_sb(struct file_s
 		goto error_splat_super;
 	}
 
-	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
-	mnt->mnt_root = mntroot;
+	nfs_set_mnt(mnt, s);
 
 	dprintk("<-- nfs_xdev_get_sb() = 0\n");
 	return 0;
@@ -1766,9 +1773,7 @@ static int nfs4_get_sb(struct file_syste
 		goto error_splat_super;
 	}
 
-	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
-	mnt->mnt_root = mntroot;
+	nfs_set_mnt(mnt, s);
 	error = 0;
 
 out:
@@ -1851,9 +1856,7 @@ static int nfs4_xdev_get_sb(struct file_
 		goto error_splat_super;
 	}
 
-	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
-	mnt->mnt_root = mntroot;
+	nfs_set_mnt(mnt, s);
 
 	dprintk("<-- nfs4_xdev_get_sb() = 0\n");
 	return 0;
@@ -1925,9 +1928,7 @@ static int nfs4_referral_get_sb(struct f
 		goto error_splat_super;
 	}
 
-	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
-	mnt->mnt_root = mntroot;
+	nfs_set_mnt(mnt, s);
 
 	dprintk("<-- nfs4_referral_get_sb() = 0\n");
 	return 0;
_
