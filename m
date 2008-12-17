Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751977AbYLQMby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbYLQMby (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYLQM3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53736 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYLQM3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:13 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/24] GFS2: Move i_size from gfs2_dinode_host and rename it to i_disksize
Date: Wed, 17 Dec 2008 11:30:07 +0000
Message-Id: <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch moved the i_size field from the gfs2_dinode_host and
following the ext3 convention renames it i_disksize.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index bec76b1..b43aee7 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -75,9 +75,9 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 		void *kaddr = kmap(page);
 
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
-		       ip->i_di.di_size);
-		memset(kaddr + ip->i_di.di_size, 0,
-		       PAGE_CACHE_SIZE - ip->i_di.di_size);
+		       ip->i_disksize);
+		memset(kaddr + ip->i_disksize, 0,
+		       PAGE_CACHE_SIZE - ip->i_disksize);
 		kunmap(page);
 
 		SetPageUptodate(page);
@@ -132,7 +132,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 	if (error)
 		goto out;
 
-	if (ip->i_di.di_size) {
+	if (ip->i_disksize) {
 		/* Get a free block, fill it with the stuffed data,
 		   and write it out to disk */
 
@@ -159,7 +159,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
-	if (ip->i_di.di_size) {
+	if (ip->i_disksize) {
 		*(__be64 *)(di + 1) = cpu_to_be64(block);
 		gfs2_add_inode_blocks(&ip->i_inode, 1);
 		di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
@@ -926,7 +926,7 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 		}
 	}
 
-	ip->i_di.di_size = size;
+	ip->i_disksize = size;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
@@ -1033,7 +1033,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 		goto out;
 
 	if (gfs2_is_stuffed(ip)) {
-		ip->i_di.di_size = size;
+		ip->i_disksize = size;
 		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
@@ -1045,7 +1045,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 			error = gfs2_block_truncate_page(ip->i_inode.i_mapping);
 
 		if (!error) {
-			ip->i_di.di_size = size;
+			ip->i_disksize = size;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 			ip->i_di.di_flags |= GFS2_DIF_TRUNC_IN_PROG;
 			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
@@ -1114,7 +1114,7 @@ static int trunc_end(struct gfs2_inode *ip)
 	if (error)
 		goto out;
 
-	if (!ip->i_di.di_size) {
+	if (!ip->i_disksize) {
 		ip->i_height = 0;
 		ip->i_goal = ip->i_no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
@@ -1205,9 +1205,9 @@ int gfs2_truncatei(struct gfs2_inode *ip, u64 size)
 	if (gfs2_assert_warn(GFS2_SB(&ip->i_inode), S_ISREG(ip->i_inode.i_mode)))
 		return -EINVAL;
 
-	if (size > ip->i_di.di_size)
+	if (size > ip->i_disksize)
 		error = do_grow(ip, size);
-	else if (size < ip->i_di.di_size)
+	else if (size < ip->i_disksize)
 		error = do_shrink(ip, size);
 	else
 		/* update time stamps */
@@ -1219,7 +1219,7 @@ int gfs2_truncatei(struct gfs2_inode *ip, u64 size)
 int gfs2_truncatei_resume(struct gfs2_inode *ip)
 {
 	int error;
-	error = trunc_dealloc(ip, ip->i_di.di_size);
+	error = trunc_dealloc(ip, ip->i_disksize);
 	if (!error)
 		error = trunc_end(ip);
 	return error;
@@ -1298,7 +1298,7 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 		lblock_stop = offset + len + bsize - 1;
 		do_div(lblock_stop, bsize);
 	} else {
-		u64 end_of_file = (ip->i_di.di_size + sdp->sd_sb.sb_bsize - 1) >> shift;
+		u64 end_of_file = (ip->i_disksize + sdp->sd_sb.sb_bsize - 1) >> shift;
 		lblock = offset >> shift;
 		lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
 		if (lblock_stop > end_of_file)
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 830cf48..d8d8232 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -128,8 +128,8 @@ static int gfs2_dir_write_stuffed(struct gfs2_inode *ip, const char *buf,
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	memcpy(dibh->b_data + offset + sizeof(struct gfs2_dinode), buf, size);
-	if (ip->i_di.di_size < offset + size)
-		ip->i_di.di_size = offset + size;
+	if (ip->i_disksize < offset + size)
+		ip->i_disksize = offset + size;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_dinode_out(ip, dibh->b_data);
 
@@ -226,8 +226,8 @@ out:
 	if (error)
 		return error;
 
-	if (ip->i_di.di_size < offset + copied)
-		ip->i_di.di_size = offset + copied;
+	if (ip->i_disksize < offset + copied)
+		ip->i_disksize = offset + copied;
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
@@ -277,11 +277,11 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, char *buf, u64 offset,
 	int copied = 0;
 	int error = 0;
 
-	if (offset >= ip->i_di.di_size)
+	if (offset >= ip->i_disksize)
 		return 0;
 
-	if (offset + size > ip->i_di.di_size)
-		size = ip->i_di.di_size - offset;
+	if (offset + size > ip->i_disksize)
+		size = ip->i_disksize - offset;
 
 	if (!size)
 		return 0;
@@ -760,7 +760,7 @@ static struct gfs2_dirent *gfs2_dirent_search(struct inode *inode,
 		unsigned hsize = 1 << ip->i_depth;
 		unsigned index;
 		u64 ln;
-		if (hsize * sizeof(u64) != ip->i_di.di_size) {
+		if (hsize * sizeof(u64) != ip->i_disksize) {
 			gfs2_consist_inode(ip);
 			return ERR_PTR(-EIO);
 		}
@@ -905,7 +905,7 @@ static int dir_make_exhash(struct inode *inode)
 	for (x = sdp->sd_hash_ptrs; x--; lp++)
 		*lp = cpu_to_be64(bn);
 
-	dip->i_di.di_size = sdp->sd_sb.sb_bsize / 2;
+	dip->i_disksize = sdp->sd_sb.sb_bsize / 2;
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_di.di_flags |= GFS2_DIF_EXHASH;
 
@@ -1082,7 +1082,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	int error = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_di.di_size) {
+	if (hsize * sizeof(u64) != dip->i_disksize) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
@@ -1091,7 +1091,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 
 	buf = kcalloc(3, sdp->sd_hash_bsize, GFP_NOFS | __GFP_NOFAIL);
 
-	for (block = dip->i_di.di_size >> sdp->sd_hash_bsize_shift; block--;) {
+	for (block = dip->i_disksize >> sdp->sd_hash_bsize_shift; block--;) {
 		error = gfs2_dir_read_data(dip, (char *)buf,
 					    block * sdp->sd_hash_bsize,
 					    sdp->sd_hash_bsize, 1);
@@ -1370,7 +1370,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	unsigned depth = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_di.di_size) {
+	if (hsize * sizeof(u64) != dip->i_disksize) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
@@ -1784,7 +1784,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 	int error = 0;
 
 	hsize = 1 << dip->i_depth;
-	if (hsize * sizeof(u64) != dip->i_di.di_size) {
+	if (hsize * sizeof(u64) != dip->i_disksize) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index fb2fd4a..4596cd2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -234,7 +234,6 @@ enum {
 };
 
 struct gfs2_dinode_host {
-	u64 di_size;		/* number of bytes in file */
 	u32 di_flags;		/* GFS2_DIF_... */
 };
 
@@ -244,6 +243,7 @@ struct gfs2_inode {
 	u64 i_no_formal_ino;
 	u64 i_generation;
 	u64 i_eattr;
+	loff_t i_disksize;
 	unsigned long i_flags;		/* GIF_... */
 
 	struct gfs2_dinode_host i_di; /* To be replaced by ref to block */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7b1867e..5651178 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -273,8 +273,8 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	 * to do that.
 	 */
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
-	di->di_size = be64_to_cpu(str->di_size);
-	i_size_write(&ip->i_inode, di->di_size);
+	ip->i_disksize = be64_to_cpu(str->di_size);
+	i_size_write(&ip->i_inode, ip->i_disksize);
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
@@ -1167,7 +1167,7 @@ int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
 		return error;
 	}
 
-	if (!ip->i_di.di_size) {
+	if (!ip->i_disksize) {
 		gfs2_consist_inode(ip);
 		error = -EIO;
 		goto out;
@@ -1177,7 +1177,7 @@ int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len)
 	if (error)
 		goto out;
 
-	x = ip->i_di.di_size + 1;
+	x = ip->i_disksize + 1;
 	if (x > *len) {
 		*buf = kmalloc(x, GFP_NOFS);
 		if (!*buf) {
@@ -1255,7 +1255,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
 	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
 	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
-	str->di_size = cpu_to_be64(di->di_size);
+	str->di_size = cpu_to_be64(ip->i_disksize);
 	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
 	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
@@ -1287,7 +1287,8 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	       (unsigned long long)ip->i_no_formal_ino);
 	printk(KERN_INFO "  no_addr = %llu\n",
 	       (unsigned long long)ip->i_no_addr);
-	printk(KERN_INFO "  di_size = %llu\n", (unsigned long long)di->di_size);
+	printk(KERN_INFO "  i_disksize = %llu\n",
+	       (unsigned long long)ip->i_disksize);
 	printk(KERN_INFO "  blocks = %llu\n",
 	       (unsigned long long)gfs2_get_inode_blocks(&ip->i_inode));
 	printk(KERN_INFO "  i_goal = %llu\n",
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 44a373b..82a1db6 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -451,8 +451,8 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 
 	kaddr = kmap_atomic(page, KM_USER0);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
-	       ip->i_di.di_size);
-	memset(kaddr + ip->i_di.di_size, 0, PAGE_CACHE_SIZE - ip->i_di.di_size);
+	       ip->i_disksize);
+	memset(kaddr + ip->i_disksize, 0, PAGE_CACHE_SIZE - ip->i_disksize);
 	kunmap_atomic(kaddr, KM_USER0);
 	flush_dcache_page(page);
 	brelse(dibh);
@@ -780,7 +780,7 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 
 	if (inode->i_size < to) {
 		i_size_write(inode, to);
-		ip->i_di.di_size = inode->i_size;
+		ip->i_disksize = inode->i_size;
 		di->di_size = cpu_to_be64(inode->i_size);
 		mark_inode_dirty(inode);
 	}
@@ -845,9 +845,9 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
 
-	if (likely(ret >= 0) && (inode->i_size > ip->i_di.di_size)) {
+	if (likely(ret >= 0) && (inode->i_size > ip->i_disksize)) {
 		di = (struct gfs2_dinode *)dibh->b_data;
-		ip->i_di.di_size = inode->i_size;
+		ip->i_disksize = inode->i_size;
 		di->di_size = cpu_to_be64(inode->i_size);
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index fcfaaef..d7e649e 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -478,7 +478,7 @@ static int gfs2_open(struct inode *inode, struct file *file)
 			goto fail;
 
 		if (!(file->f_flags & O_LARGEFILE) &&
-		    ip->i_di.di_size > MAX_NON_LFS) {
+		    ip->i_disksize > MAX_NON_LFS) {
 			error = -EOVERFLOW;
 			goto fail_gunlock;
 		}
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ca463a4..dd83e83 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -617,7 +617,7 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
 
 	prev_db = 0;
 
-	for (lb = 0; lb < ip->i_di.di_size >> sdp->sd_sb.sb_bsize_shift; lb++) {
+	for (lb = 0; lb < ip->i_disksize >> sdp->sd_sb.sb_bsize_shift; lb++) {
 		bh.b_state = 0;
 		bh.b_blocknr = 0;
 		bh.b_size = 1 << ip->i_inode.i_blkbits;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 48468f4..b932d72 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -371,7 +371,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 
 	ip = ghs[1].gh_gl->gl_object;
 
-	ip->i_di.di_size = size;
+	ip->i_disksize = size;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 
@@ -425,7 +425,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	ip = ghs[1].gh_gl->gl_object;
 
 	ip->i_inode.i_nlink = 2;
-	ip->i_di.di_size = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
+	ip->i_disksize = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
 	ip->i_di.di_flags |= GFS2_DIF_JDATA;
 	ip->i_entries = 2;
 
@@ -990,7 +990,7 @@ static int setattr_size(struct inode *inode, struct iattr *attr)
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	int error;
 
-	if (attr->ia_size != ip->i_di.di_size) {
+	if (attr->ia_size != ip->i_disksize) {
 		error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
 		if (error)
 			return error;
@@ -1001,8 +1001,8 @@ static int setattr_size(struct inode *inode, struct iattr *attr)
 	}
 
 	error = gfs2_truncatei(ip, attr->ia_size);
-	if (error && (inode->i_size != ip->i_di.di_size))
-		i_size_write(inode, ip->i_di.di_size);
+	if (error && (inode->i_size != ip->i_disksize))
+		i_size_write(inode, ip->i_disksize);
 
 	return error;
 }
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3e073f5..188d0a2 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1100,15 +1100,15 @@ static void gfs2_quota_change_in(struct gfs2_quota_change_host *qc, const void *
 int gfs2_quota_init(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_qc_inode);
-	unsigned int blocks = ip->i_di.di_size >> sdp->sd_sb.sb_bsize_shift;
+	unsigned int blocks = ip->i_disksize >> sdp->sd_sb.sb_bsize_shift;
 	unsigned int x, slot = 0;
 	unsigned int found = 0;
 	u64 dblock;
 	u32 extlen = 0;
 	int error;
 
-	if (!ip->i_di.di_size || ip->i_di.di_size > (64 << 20) ||
-	    ip->i_di.di_size & (sdp->sd_sb.sb_bsize - 1)) {
+	if (!ip->i_disksize || ip->i_disksize > (64 << 20) ||
+	    ip->i_disksize & (sdp->sd_sb.sb_bsize - 1)) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2d90fb2..bdad0df 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -501,7 +501,7 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 	for (rgrps = 0;; rgrps++) {
 		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
 
-		if (pos + sizeof(struct gfs2_rindex) >= ip->i_di.di_size)
+		if (pos + sizeof(struct gfs2_rindex) >= ip->i_disksize)
 			break;
 		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
 					   sizeof(struct gfs2_rindex));
@@ -590,7 +590,7 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
-	u64 rgrp_count = ip->i_di.di_size;
+	u64 rgrp_count = ip->i_disksize;
 	int error;
 
 	if (do_div(rgrp_count, sizeof(struct gfs2_rindex))) {
@@ -634,7 +634,7 @@ static int gfs2_ri_update_special(struct gfs2_inode *ip)
 	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
 		/* Ignore partials */
 		if ((sdp->sd_rgrps + 1) * sizeof(struct gfs2_rindex) >
-		    ip->i_di.di_size)
+		    ip->i_disksize)
 			break;
 		error = read_rindex_entry(ip, &ra_state);
 		if (error) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index c3ba3d9..f5cef2a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -206,14 +206,14 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 	int ar;
 	int error;
 
-	if (ip->i_di.di_size < (8 << 20) || ip->i_di.di_size > (1 << 30) ||
-	    (ip->i_di.di_size & (sdp->sd_sb.sb_bsize - 1))) {
+	if (ip->i_disksize < (8 << 20) || ip->i_disksize > (1 << 30) ||
+	    (ip->i_disksize & (sdp->sd_sb.sb_bsize - 1))) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
-	jd->jd_blocks = ip->i_di.di_size >> sdp->sd_sb.sb_bsize_shift;
+	jd->jd_blocks = ip->i_disksize >> sdp->sd_sb.sb_bsize_shift;
 
-	error = gfs2_write_alloc_required(ip, 0, ip->i_di.di_size, &ar);
+	error = gfs2_write_alloc_required(ip, 0, ip->i_disksize, &ar);
 	if (!error && ar) {
 		gfs2_consist_inode(ip);
 		error = -EIO;
-- 
1.6.0.3

