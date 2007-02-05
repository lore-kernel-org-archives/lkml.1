Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbXBEOaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbXBEOaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXBEOaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:30:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXBEOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:30:22 -0500
Subject: [GFS2] use CURRENT_TIME_SEC instead of get_seconds in gfs2 [38/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:38:27 +0000
Message-Id: <1170686307.11001.347.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b1e30982b8b4a276f18092f55e5ae80cd193414 Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@redhat.com>
Date: Thu, 18 Jan 2007 16:41:23 -0600
Subject: [PATCH] [GFS2] use CURRENT_TIME_SEC instead of get_seconds in gfs2

I was looking something else up and came across this...

I don't honestly have a good reason to change it other than to make it
like every other Linux filesystem in this regard.  ;-)  It doesn't
functionally change anything, but makes some lines shorter. :)

I'm also curious; why does gfs2 have 64-bits of on-disk timestamps, but
not in timespec_t format, and only stores second resolutions?  Seems like
you're halfway to sub-second resolutions already.

I suppose if that gets implemented then all of the below should
instead be CURRENT_TIME not CURRENT_TIME_SEC.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 8240c1f..113f6c9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -773,7 +773,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 			gfs2_free_data(ip, bstart, blen);
 	}
 
-	ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 
 	gfs2_dinode_out(ip, dibh->b_data);
 
@@ -848,7 +848,7 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 	}
 
 	ip->i_di.di_size = size;
-	ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
@@ -963,7 +963,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 
 	if (gfs2_is_stuffed(ip)) {
 		ip->i_di.di_size = size;
-		ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + size);
@@ -975,7 +975,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 
 		if (!error) {
 			ip->i_di.di_size = size;
-			ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 			ip->i_di.di_flags |= GFS2_DIF_TRUNC_IN_PROG;
 			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 			gfs2_dinode_out(ip, dibh->b_data);
@@ -1048,7 +1048,7 @@ static int trunc_end(struct gfs2_inode *ip)
 			ip->i_num.no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	}
-	ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 	ip->i_di.di_flags &= ~GFS2_DIF_TRUNC_IN_PROG;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 0eceb05..c93ca8f 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -131,7 +131,7 @@ static int gfs2_dir_write_stuffed(struct gfs2_inode *ip, const char *buf,
 	memcpy(dibh->b_data + offset + sizeof(struct gfs2_dinode), buf, size);
 	if (ip->i_di.di_size < offset + size)
 		ip->i_di.di_size = offset + size;
-	ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 	gfs2_dinode_out(ip, dibh->b_data);
 
 	brelse(dibh);
@@ -229,7 +229,7 @@ out:
 
 	if (ip->i_di.di_size < offset + copied)
 		ip->i_di.di_size = offset + copied;
-	ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
@@ -1565,7 +1565,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 				break;
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
 			ip->i_di.di_entries++;
-			ip->i_inode.i_mtime.tv_sec = ip->i_inode.i_ctime.tv_sec = get_seconds();
+			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 			gfs2_dinode_out(ip, bh->b_data);
 			brelse(bh);
 			error = 0;
@@ -1651,7 +1651,7 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
 		gfs2_consist_inode(dip);
 	gfs2_trans_add_bh(dip->i_gl, bh, 1);
 	dip->i_di.di_entries--;
-	dip->i_inode.i_mtime.tv_sec = dip->i_inode.i_ctime.tv_sec = get_seconds();
+	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME_SEC;
 	gfs2_dinode_out(dip, bh->b_data);
 	brelse(bh);
 	mark_inode_dirty(&dip->i_inode);
@@ -1699,7 +1699,7 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 		gfs2_trans_add_bh(dip->i_gl, bh, 1);
 	}
 
-	dip->i_inode.i_mtime.tv_sec = dip->i_inode.i_ctime.tv_sec = get_seconds();
+	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME_SEC;
 	gfs2_dinode_out(dip, bh->b_data);
 	brelse(bh);
 	return 0;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2603169..f7c8d31 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -357,7 +357,7 @@ int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
 	else
 		drop_nlink(&ip->i_inode);
 
-	ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index b2a12f4..747c731 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -728,7 +728,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		error = gfs2_meta_inode_buffer(ip, &dibh);
 		if (error)
 			goto out_end_trans;
-		ip->i_inode.i_ctime.tv_sec = get_seconds();
+		ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
-- 
1.4.4.2



