Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYAUKEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYAUKEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbYAUKCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbYAUKCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:00 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/58] [GFS2] Add gfs2_is_writeback()
Date: Mon, 21 Jan 2008 09:21:24 +0000
Message-Id: <12009073531216-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073512300-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
Message-Id: <84de47e81185234c2e5c7c04af1f95d17d9ae5dd.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This adds a function "gfs2_is_writeback()" along the lines of the
existing "gfs2_is_jdata()" in order to clean up the code and make
the various tests for the inode mode more obvious. It also fixes
the PageChecked() logic where we were resetting the flag too early
in the case of an error path.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 93fa427..1cfd493 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -59,7 +59,6 @@ struct strip_mine {
 static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 			       u64 block, struct page *page)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct buffer_head *bh;
 	int release = 0;
@@ -95,7 +94,7 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 	set_buffer_uptodate(bh);
 	if (!gfs2_is_jdata(ip))
 		mark_buffer_dirty(bh);
-	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
+	if (!gfs2_is_writeback(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
 	if (release) {
@@ -879,7 +878,6 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	loff_t from = inode->i_size;
 	unsigned long index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
@@ -931,7 +929,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping)
 		err = 0;
 	}
 
-	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
+	if (!gfs2_is_writeback(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
 	zero_user_page(page, offset, length, KM_USER0);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e53da7d..82dfe9b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -285,7 +285,7 @@ static inline struct gfs2_inode *GFS2_I(struct inode *inode)
 	return container_of(inode, struct gfs2_inode, i_inode);
 }
 
-static inline struct gfs2_sbd *GFS2_SB(struct inode *inode)
+static inline struct gfs2_sbd *GFS2_SB(const struct inode *inode)
 {
 	return inode->i_sb->s_fs_info;
 }
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 351ac87..bed3dc2 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -20,6 +20,12 @@ static inline int gfs2_is_jdata(const struct gfs2_inode *ip)
 	return ip->i_di.di_flags & GFS2_DIF_JDATA;
 }
 
+static inline int gfs2_is_writeback(const struct gfs2_inode *ip)
+{
+	const struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	return (sdp->sd_args.ar_data == GFS2_DATA_WRITEBACK) && !gfs2_is_jdata(ip);
+}
+
 static inline int gfs2_is_dir(const struct gfs2_inode *ip)
 {
 	return S_ISDIR(ip->i_inode.i_mode);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 4c4ef7f..ed154af 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -138,12 +138,11 @@ static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 		return 0; /* don't care */
 	}
 
-	if ((sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip)) &&
-	    PageChecked(page)) {
-		ClearPageChecked(page);
+	if (PageChecked(page)) {
 		error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
 		if (error)
 			goto out_ignore;
+		ClearPageChecked(page);
 		if (!page_has_buffers(page)) {
 			create_empty_buffers(page, inode->i_sb->s_blocksize,
 					     (1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -180,9 +179,8 @@ static int gfs2_writepages(struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
-	if (sdp->sd_args.ar_data == GFS2_DATA_WRITEBACK && !gfs2_is_jdata(ip))
+	if (gfs2_is_writeback(ip))
 		return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
 
 	return generic_writepages(mapping, wbc);
@@ -606,7 +604,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	if (gfs2_is_stuffed(ip))
 		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
 
-	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
+	if (!gfs2_is_writeback(ip))
 		gfs2_page_add_databufs(ip, page, from, to);
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-- 
1.5.1.2

