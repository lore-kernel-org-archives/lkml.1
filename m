Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751920AbYLQMbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYLQMbM (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYLQM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53734 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYLQM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:11 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/24] GFS2: Move "entries" into "proper" inode
Date: Wed, 17 Dec 2008 11:30:05 +0000
Message-Id: <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This moves the directory entry count into the proper inode.
Potentially we could get this to share the space used by
something else in the future, but this is one more step
on the way to removing the gfs2_dinode_host structure.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index eed040d..830cf48 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -858,8 +858,8 @@ static int dir_make_exhash(struct inode *inode)
 		return -ENOSPC;
 	bn = bh->b_blocknr;
 
-	gfs2_assert(sdp, dip->i_di.di_entries < (1 << 16));
-	leaf->lf_entries = cpu_to_be16(dip->i_di.di_entries);
+	gfs2_assert(sdp, dip->i_entries < (1 << 16));
+	leaf->lf_entries = cpu_to_be16(dip->i_entries);
 
 	/*  Copy dirents  */
 
@@ -1426,7 +1426,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 	int copied = 0;
 	int error;
 
-	if (!dip->i_di.di_entries)
+	if (!dip->i_entries)
 		return 0;
 
 	if (dip->i_di.di_flags & GFS2_DIF_EXHASH)
@@ -1453,17 +1453,17 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 			error = PTR_ERR(dent);
 			goto out;
 		}
-		if (dip->i_di.di_entries != g.offset) {
+		if (dip->i_entries != g.offset) {
 			fs_warn(sdp, "Number of entries corrupt in dir %llu, "
-				"ip->i_di.di_entries (%u) != g.offset (%u)\n",
+				"ip->i_entries (%u) != g.offset (%u)\n",
 				(unsigned long long)dip->i_no_addr,
-				dip->i_di.di_entries,
+				dip->i_entries,
 				g.offset);
 			error = -EIO;
 			goto out;
 		}
 		error = do_filldir_main(dip, offset, opaque, filldir, darr,
-					dip->i_di.di_entries, &copied);
+					dip->i_entries, &copied);
 out:
 		kfree(darr);
 	}
@@ -1621,7 +1621,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			if (error)
 				break;
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
-			ip->i_di.di_entries++;
+			ip->i_entries++;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 			gfs2_dinode_out(ip, bh->b_data);
 			brelse(bh);
@@ -1704,10 +1704,10 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
 	if (error)
 		return error;
 
-	if (!dip->i_di.di_entries)
+	if (!dip->i_entries)
 		gfs2_consist_inode(dip);
 	gfs2_trans_add_bh(dip->i_gl, bh, 1);
-	dip->i_di.di_entries--;
+	dip->i_entries--;
 	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_dinode_out(dip, bh->b_data);
 	brelse(bh);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4ff1d7e..15ca3a7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -236,8 +236,6 @@ enum {
 struct gfs2_dinode_host {
 	u64 di_size;		/* number of bytes in file */
 	u32 di_flags;		/* GFS2_DIF_... */
-	/* These only apply to directories  */
-	u32 di_entries;		/* The number of entries in the directory */
 	u64 di_eattr;		/* extended attribute block number */
 };
 
@@ -256,6 +254,7 @@ struct gfs2_inode {
 	struct gfs2_alloc *i_alloc;
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
+	u32 i_entries;
 	u8 i_height;
 	u8 i_depth;
 };
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 081ffff..30ffc88 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -299,7 +299,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
 		goto corrupt;
 	ip->i_depth = (u8)depth;
-	di->di_entries = be32_to_cpu(str->di_entries);
+	ip->i_entries = be32_to_cpu(str->di_entries);
 
 	di->di_eattr = be64_to_cpu(str->di_eattr);
 	if (S_ISREG(ip->i_inode.i_mode))
@@ -689,7 +689,7 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 		return error;
 	}
 
-	if (dip->i_di.di_entries == (u32)-1)
+	if (dip->i_entries == (u32)-1)
 		return -EFBIG;
 	if (S_ISDIR(mode) && dip->i_inode.i_nlink == (u32)-1)
 		return -EMLINK;
@@ -1067,7 +1067,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 	struct qstr dotname;
 	int error;
 
-	if (ip->i_di.di_entries != 2) {
+	if (ip->i_entries != 2) {
 		if (gfs2_consist_inode(ip))
 			gfs2_dinode_print(ip);
 		return -EIO;
@@ -1271,7 +1271,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 					     !(ip->i_di.di_flags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
 	str->di_depth = cpu_to_be16(ip->i_depth);
-	str->di_entries = cpu_to_be32(di->di_entries);
+	str->di_entries = cpu_to_be32(ip->i_entries);
 
 	str->di_eattr = cpu_to_be64(di->di_eattr);
 	str->di_atime_nsec = cpu_to_be32(ip->i_inode.i_atime.tv_nsec);
@@ -1295,7 +1295,7 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
 	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
 	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
-	printk(KERN_INFO "  di_entries = %u\n", di->di_entries);
+	printk(KERN_INFO "  i_entries = %u\n", ip->i_entries);
 	printk(KERN_INFO "  di_eattr = %llu\n",
 	       (unsigned long long)di->di_eattr);
 }
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 98440fe..48468f4 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -185,7 +185,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (!dip->i_inode.i_nlink)
 		goto out_gunlock;
 	error = -EFBIG;
-	if (dip->i_di.di_entries == (u32)-1)
+	if (dip->i_entries == (u32)-1)
 		goto out_gunlock;
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
@@ -427,7 +427,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	ip->i_inode.i_nlink = 2;
 	ip->i_di.di_size = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
 	ip->i_di.di_flags |= GFS2_DIF_JDATA;
-	ip->i_di.di_entries = 2;
+	ip->i_entries = 2;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 
@@ -517,13 +517,13 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	if (error)
 		goto out_gunlock;
 
-	if (ip->i_di.di_entries < 2) {
+	if (ip->i_entries < 2) {
 		if (gfs2_consist_inode(ip))
 			gfs2_dinode_print(ip);
 		error = -EIO;
 		goto out_gunlock;
 	}
-	if (ip->i_di.di_entries > 2) {
+	if (ip->i_entries > 2) {
 		error = -ENOTEMPTY;
 		goto out_gunlock;
 	}
@@ -726,13 +726,13 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock;
 
 		if (S_ISDIR(nip->i_inode.i_mode)) {
-			if (nip->i_di.di_entries < 2) {
+			if (nip->i_entries < 2) {
 				if (gfs2_consist_inode(nip))
 					gfs2_dinode_print(nip);
 				error = -EIO;
 				goto out_gunlock;
 			}
-			if (nip->i_di.di_entries > 2) {
+			if (nip->i_entries > 2) {
 				error = -ENOTEMPTY;
 				goto out_gunlock;
 			}
@@ -758,7 +758,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 				error = -EINVAL;
 				goto out_gunlock;
 			}
-			if (ndip->i_di.di_entries == (u32)-1) {
+			if (ndip->i_entries == (u32)-1) {
 				error = -EFBIG;
 				goto out_gunlock;
 			}
-- 
1.6.0.3

