Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbYCCSzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbYCCSzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYCCSzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:55:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYCCSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:55:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SS7zPL9ZyLCblVo2lr74wEFtylEqJD05o0KQli4kN2V7HKzBngwyXXUsnl7gKXDTFIvkGeqSADDlpxew7AzEOiTBn9BPuEmshUy47UxgBtrSUr49TSuhieIxDoeB/w16eQoFaxx7WLl8eKjop2JMmp/ZkHBzk2oHY4QjxbGAEmg=
Date: Mon, 3 Mar 2008 21:54:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] GFS2: possible null pointer dereference fixup
Message-ID: <20080303185421.GB10511@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2_alloc_get may fail so we have to check it to prevent
NULL pointer dereference.

Signed-off-by: Cyrill Gorcunov <gorcunov@gamil.com>
---

 bmap.c        |    6 +++++-
 dir.c         |   10 +++++++---
 eattr.c       |    6 ++++++
 inode.c       |    7 ++++++-
 ops_address.c |    4 ++++
 ops_inode.c   |   11 ++++++++++-
 quota.c       |    9 +++++++--
 7 files changed, 45 insertions(+), 8 deletions(-)

Index: linux-2.6.git/fs/gfs2/bmap.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/bmap.c	2008-02-06 23:15:16.000000000 +0300
+++ linux-2.6.git/fs/gfs2/bmap.c	2008-03-03 21:45:36.000000000 +0300
@@ -808,6 +808,8 @@ static int do_grow(struct gfs2_inode *ip
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -997,7 +999,9 @@ static int trunc_dealloc(struct gfs2_ino
 		lblock = (size - 1) >> GFS2_SB(&ip->i_inode)->sd_sb.sb_bsize_shift;
 
 	find_metapath(ip, lblock, &mp);
-	gfs2_alloc_get(ip);
+
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
Index: linux-2.6.git/fs/gfs2/dir.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/dir.c	2008-02-08 19:09:52.000000000 +0300
+++ linux-2.6.git/fs/gfs2/dir.c	2008-03-03 21:22:06.000000000 +0300
@@ -1870,11 +1870,14 @@ static int leaf_dealloc(struct gfs2_inod
 	if (!ht)
 		return -ENOMEM;
 
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip)) {
+		error = -ENOMEM;
+		goto out;
+	}
 
 	error = gfs2_quota_hold(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
-		goto out;
+		goto out_put;
 
 	error = gfs2_rindex_hold(sdp, &dip->i_alloc->al_ri_gh);
 	if (error)
@@ -1952,8 +1955,9 @@ out_rlist:
 	gfs2_glock_dq_uninit(&dip->i_alloc->al_ri_gh);
 out_qs:
 	gfs2_quota_unhold(dip);
-out:
+out_put:
 	gfs2_alloc_put(dip);
+out:
 	kfree(ht);
 	return error;
 }
Index: linux-2.6.git/fs/gfs2/eattr.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/eattr.c	2008-01-26 22:07:50.000000000 +0300
+++ linux-2.6.git/fs/gfs2/eattr.c	2008-03-03 21:02:58.000000000 +0300
@@ -321,6 +321,8 @@ static int ea_remove_unstuffed(struct gf
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -684,6 +686,8 @@ static int ea_alloc_skeleton(struct gfs2
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -1474,6 +1478,8 @@ int gfs2_ea_dealloc(struct gfs2_inode *i
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
Index: linux-2.6.git/fs/gfs2/inode.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/inode.c	2008-02-08 19:09:52.000000000 +0300
+++ linux-2.6.git/fs/gfs2/inode.c	2008-03-03 21:24:50.000000000 +0300
@@ -344,6 +344,8 @@ int gfs2_dinode_dealloc(struct gfs2_inod
 	}
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -818,7 +820,8 @@ static int make_dinode(struct gfs2_inode
 	int error;
 
 	munge_mode_uid_gid(dip, &mode, &uid, &gid);
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, uid, gid);
 	if (error)
@@ -853,6 +856,8 @@ static int link_dinode(struct gfs2_inode
 	int error;
 
 	al = gfs2_alloc_get(dip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
Index: linux-2.6.git/fs/gfs2/ops_address.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/ops_address.c	2008-02-06 23:15:16.000000000 +0300
+++ linux-2.6.git/fs/gfs2/ops_address.c	2008-03-03 21:34:08.000000000 +0300
@@ -648,6 +648,10 @@ static int gfs2_write_begin(struct file 
 
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
 
 		error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
Index: linux-2.6.git/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/ops_inode.c	2008-02-08 19:09:52.000000000 +0300
+++ linux-2.6.git/fs/gfs2/ops_inode.c	2008-03-03 21:49:24.000000000 +0300
@@ -200,6 +200,10 @@ static int gfs2_link(struct dentry *old_
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(dip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -716,6 +720,10 @@ static int gfs2_rename(struct inode *odi
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(ndip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(ndip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -953,7 +961,8 @@ static int setattr_chown(struct inode *i
 	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
 		ogid = ngid = NO_QUOTA_CHANGE;
 
-	gfs2_alloc_get(ip);
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
 	if (error)
Index: linux-2.6.git/fs/gfs2/quota.c
===================================================================
--- linux-2.6.git.orig/fs/gfs2/quota.c	2008-01-26 22:07:50.000000000 +0300
+++ linux-2.6.git/fs/gfs2/quota.c	2008-03-03 21:33:03.000000000 +0300
@@ -617,8 +617,9 @@ static int gfs2_adjust_quota(struct gfs2
 	int err = -EIO;
 
 	if (gfs2_is_stuffed(ip)) {
-		struct gfs2_alloc *al = NULL;
-		al = gfs2_alloc_get(ip);
+		struct gfs2_alloc *al = gfs2_alloc_get(ip);
+		if (!al)
+			return -ENOMEM;
 		/* just request 1 blk */
 		al->al_requested = 1;
 		gfs2_inplace_reserve(ip);
@@ -729,6 +730,10 @@ static int do_sync(unsigned int num_qd, 
 
 	if (nalloc) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		al->al_requested = nalloc * (data_blocks + ind_blocks);
 
