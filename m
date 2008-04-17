Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbYDQJl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbYDQJl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbYDQJ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/48] [GFS2] Shrink & rename di_depth
Date: Thu, 17 Apr 2008 09:38:55 +0100
Message-Id: <12084216082638-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216061172-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch forms a pair with the previous patch which shrunk
di_height. Like that patch di_depth is renamed i_depth and moved
into struct gfs2_inode directly. Also the field goes from 16 bits
to 8 bits since it is also limited to a max value which is rather
small (17 in this case). In addition we also now validate the field
against this maximum value when its read in.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 78c236f..081daa9 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -757,7 +757,7 @@ static struct gfs2_dirent *gfs2_dirent_search(struct inode *inode,
 
 	if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
 		struct gfs2_leaf *leaf;
-		unsigned hsize = 1 << ip->i_di.di_depth;
+		unsigned hsize = 1 << ip->i_depth;
 		unsigned index;
 		u64 ln;
 		if (hsize * sizeof(u64) != ip->i_di.di_size) {
@@ -765,7 +765,7 @@ static struct gfs2_dirent *gfs2_dirent_search(struct inode *inode,
 			return ERR_PTR(-EIO);
 		}
 
-		index = name->hash >> (32 - ip->i_di.di_depth);
+		index = name->hash >> (32 - ip->i_depth);
 		error = get_first_leaf(ip, index, &bh);
 		if (error)
 			return ERR_PTR(error);
@@ -910,7 +910,7 @@ static int dir_make_exhash(struct inode *inode)
 	dip->i_di.di_flags |= GFS2_DIF_EXHASH;
 
 	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
-	dip->i_di.di_depth = y;
+	dip->i_depth = y;
 
 	gfs2_dinode_out(dip, dibh->b_data);
 
@@ -941,7 +941,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	int x, moved = 0;
 	int error;
 
-	index = name->hash >> (32 - dip->i_di.di_depth);
+	index = name->hash >> (32 - dip->i_depth);
 	error = get_leaf_nr(dip, index, &leaf_no);
 	if (error)
 		return error;
@@ -952,7 +952,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 		return error;
 
 	oleaf = (struct gfs2_leaf *)obh->b_data;
-	if (dip->i_di.di_depth == be16_to_cpu(oleaf->lf_depth)) {
+	if (dip->i_depth == be16_to_cpu(oleaf->lf_depth)) {
 		brelse(obh);
 		return 1; /* can't split */
 	}
@@ -967,10 +967,10 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	bn = nbh->b_blocknr;
 
 	/*  Compute the start and len of leaf pointers in the hash table.  */
-	len = 1 << (dip->i_di.di_depth - be16_to_cpu(oleaf->lf_depth));
+	len = 1 << (dip->i_depth - be16_to_cpu(oleaf->lf_depth));
 	half_len = len >> 1;
 	if (!half_len) {
-		printk(KERN_WARNING "di_depth %u lf_depth %u index %u\n", dip->i_di.di_depth, be16_to_cpu(oleaf->lf_depth), index);
+		printk(KERN_WARNING "i_depth %u lf_depth %u index %u\n", dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
 		gfs2_consist_inode(dip);
 		error = -EIO;
 		goto fail_brelse;
@@ -997,7 +997,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	kfree(lp);
 
 	/*  Compute the divider  */
-	divider = (start + half_len) << (32 - dip->i_di.di_depth);
+	divider = (start + half_len) << (32 - dip->i_depth);
 
 	/*  Copy the entries  */
 	dirent_first(dip, obh, &dent);
@@ -1082,7 +1082,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	int x;
 	int error = 0;
 
-	hsize = 1 << dip->i_di.di_depth;
+	hsize = 1 << dip->i_depth;
 	if (hsize * sizeof(u64) != dip->i_di.di_size) {
 		gfs2_consist_inode(dip);
 		return -EIO;
@@ -1125,7 +1125,7 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 
 	error = gfs2_meta_inode_buffer(dip, &dibh);
 	if (!gfs2_assert_withdraw(sdp, !error)) {
-		dip->i_di.di_depth++;
+		dip->i_depth++;
 		gfs2_dinode_out(dip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -1370,14 +1370,14 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 	int error = 0;
 	unsigned depth = 0;
 
-	hsize = 1 << dip->i_di.di_depth;
+	hsize = 1 << dip->i_depth;
 	if (hsize * sizeof(u64) != dip->i_di.di_size) {
 		gfs2_consist_inode(dip);
 		return -EIO;
 	}
 
 	hash = gfs2_dir_offset2hash(*offset);
-	index = hash >> (32 - dip->i_di.di_depth);
+	index = hash >> (32 - dip->i_depth);
 
 	lp = kmalloc(sdp->sd_hash_bsize, GFP_KERNEL);
 	if (!lp)
@@ -1405,7 +1405,7 @@ static int dir_e_read(struct inode *inode, u64 *offset, void *opaque,
 		if (error)
 			break;
 
-		len = 1 << (dip->i_di.di_depth - depth);
+		len = 1 << (dip->i_depth - depth);
 		index = (index & ~(len - 1)) + len;
 	}
 
@@ -1549,7 +1549,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 	u32 index;
 	u64 bn;
 
-	index = name->hash >> (32 - ip->i_di.di_depth);
+	index = name->hash >> (32 - ip->i_depth);
 	error = get_first_leaf(ip, index, &obh);
 	if (error)
 		return error;
@@ -1641,7 +1641,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			continue;
 		if (error < 0)
 			break;
-		if (ip->i_di.di_depth < GFS2_DIR_MAX_DEPTH) {
+		if (ip->i_depth < GFS2_DIR_MAX_DEPTH) {
 			error = dir_double_exhash(ip);
 			if (error)
 				break;
@@ -1785,7 +1785,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 	u64 leaf_no;
 	int error = 0;
 
-	hsize = 1 << dip->i_di.di_depth;
+	hsize = 1 << dip->i_depth;
 	if (hsize * sizeof(u64) != dip->i_di.di_size) {
 		gfs2_consist_inode(dip);
 		return -EIO;
@@ -1817,7 +1817,7 @@ static int foreach_leaf(struct gfs2_inode *dip, leaf_call_t lc, void *data)
 			if (error)
 				goto out;
 			leaf = (struct gfs2_leaf *)bh->b_data;
-			len = 1 << (dip->i_di.di_depth - be16_to_cpu(leaf->lf_depth));
+			len = 1 << (dip->i_depth - be16_to_cpu(leaf->lf_depth));
 			brelse(bh);
 
 			error = lc(dip, index, len, leaf_no, data);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e9c58dc..9dfdde3 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -246,7 +246,6 @@ struct gfs2_dinode_host {
 	u64 di_generation;	/* generation number for NFS */
 	u32 di_flags;		/* GFS2_DIF_... */
 	/* These only apply to directories  */
-	u16 di_depth;		/* Number of bits in the table */
 	u32 di_entries;		/* The number of entries in the directory */
 	u64 di_eattr;		/* extended attribute block number */
 };
@@ -267,6 +266,7 @@ struct gfs2_inode {
 
 	struct rw_semaphore i_rw_mutex;
 	u8 i_height;
+	u8 i_depth;
 };
 
 /*
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index db5961a..65fdfee 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -248,7 +248,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	struct gfs2_dinode_host *di = &ip->i_di;
 	const struct gfs2_dinode *str = buf;
-	u16 height;
+	u16 height, depth;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
 		goto corrupt;
@@ -293,7 +293,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		goto corrupt;
 	ip->i_height = (u8)height;
 
-	di->di_depth = be16_to_cpu(str->di_depth);
+	depth = be16_to_cpu(str->di_depth);
+	if (unlikely(depth > GFS2_DIR_MAX_DEPTH))
+		goto corrupt;
+	ip->i_depth = (u8)depth;
 	di->di_entries = be32_to_cpu(str->di_entries);
 
 	di->di_eattr = be64_to_cpu(str->di_eattr);
@@ -1410,7 +1413,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
 					     !(ip->i_di.di_flags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
-	str->di_depth = cpu_to_be16(di->di_depth);
+	str->di_depth = cpu_to_be16(ip->i_depth);
 	str->di_entries = cpu_to_be32(di->di_entries);
 
 	str->di_eattr = cpu_to_be64(di->di_eattr);
@@ -1436,7 +1439,7 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	       (unsigned long long)di->di_goal_data);
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
 	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
-	printk(KERN_INFO "  di_depth = %u\n", di->di_depth);
+	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
 	printk(KERN_INFO "  di_entries = %u\n", di->di_entries);
 	printk(KERN_INFO "  di_eattr = %llu\n",
 	       (unsigned long long)di->di_eattr);
-- 
1.5.1.2

