Return-Path: <linux-kernel-owner+w=401wt.eu-S935040AbYDQJry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040AbYDQJry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbYDQJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbYDQJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:16 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 28/48] [GFS2] Eliminate (almost) duplicate field from gfs2_inode
Date: Thu, 17 Apr 2008 09:39:04 +0100
Message-Id: <12084216262937-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216241802-git-send-email-swhiteho@redhat.com>
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
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The blocks counter is almost a duplicate of the i_blocks
field in the VFS inode. The only difference is that i_blocks
can be only 32bits long for 32bit arch without large single file
support. Since GFS2 doesn't handle the non-large single file
case (for 32 bit anyway) this adds a new config dependency on
64BIT || LSF. This has always been the case, however we've never
explicitly said so before.

Even if we do add support for the non-LSF case, we will still
not require this field to be duplicated since we will not be
able to access oversized files anyway.

So the net result of all this is that we shave 8 bytes from a gfs2_inode
and get our config deps correct.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index de8e64c..d147b53 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,6 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && (64BIT || LSF)
 	select FS_POSIX_ACL
 	select CRC32
 	help
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6780aa5..e27e660 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -161,9 +161,8 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 
 	if (ip->i_di.di_size) {
 		*(__be64 *)(di + 1) = cpu_to_be64(block);
-		ip->i_di.di_blocks++;
-		gfs2_set_inode_blocks(&ip->i_inode);
-		di->di_blocks = cpu_to_be64(ip->i_di.di_blocks);
+		gfs2_add_inode_blocks(&ip->i_inode, 1);
+		di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	}
 
 	ip->i_height = 1;
@@ -238,10 +237,9 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	*(__be64 *)(di + 1) = cpu_to_be64(bn);
 	ip->i_height += new_height;
-	ip->i_di.di_blocks += new_height;
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_add_inode_blocks(&ip->i_inode, new_height);
 	di->di_height = cpu_to_be16(ip->i_height);
-	di->di_blocks = cpu_to_be64(ip->i_di.di_blocks);
+	di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	brelse(dibh);
 	return error;
 }
@@ -380,8 +378,7 @@ static int lookup_block(struct gfs2_inode *ip, unsigned int height,
 	gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[height], 1);
 
 	*ptr = cpu_to_be64(*block);
-	ip->i_di.di_blocks++;
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_add_inode_blocks(&ip->i_inode, 1);
 
 	*new = 1;
 	return 0;
@@ -779,10 +776,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		}
 
 		*p = 0;
-		if (!ip->i_di.di_blocks)
-			gfs2_consist_inode(ip);
-		ip->i_di.di_blocks--;
-		gfs2_set_inode_blocks(&ip->i_inode);
+		gfs2_add_inode_blocks(&ip->i_inode, -1);
 	}
 	if (bstart) {
 		if (metadata)
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 93a2e6a..862aa32 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -906,8 +906,7 @@ static int dir_make_exhash(struct inode *inode)
 		*lp = cpu_to_be64(bn);
 
 	dip->i_di.di_size = sdp->sd_sb.sb_bsize / 2;
-	dip->i_di.di_blocks++;
-	gfs2_set_inode_blocks(&dip->i_inode);
+	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_di.di_flags |= GFS2_DIF_EXHASH;
 
 	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
@@ -1045,8 +1044,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	error = gfs2_meta_inode_buffer(dip, &dibh);
 	if (!gfs2_assert_withdraw(GFS2_SB(&dip->i_inode), !error)) {
 		gfs2_trans_add_bh(dip->i_gl, dibh, 1);
-		dip->i_di.di_blocks++;
-		gfs2_set_inode_blocks(&dip->i_inode);
+		gfs2_add_inode_blocks(&dip->i_inode, 1);
 		gfs2_dinode_out(dip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -1580,8 +1578,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 	if (error)
 		return error;
 	gfs2_trans_add_bh(ip->i_gl, bh, 1);
-	ip->i_di.di_blocks++;
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_add_inode_blocks(&ip->i_inode, 1);
 	gfs2_dinode_out(ip, bh->b_data);
 	brelse(bh);
 	return 0;
@@ -1922,11 +1919,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 		brelse(bh);
 
 		gfs2_free_meta(dip, blk, 1);
-
-		if (!dip->i_di.di_blocks)
-			gfs2_consist_inode(dip);
-		dip->i_di.di_blocks--;
-		gfs2_set_inode_blocks(&dip->i_inode);
+		gfs2_add_inode_blocks(&dip->i_inode, -1);
 	}
 
 	error = gfs2_dir_write_data(dip, ht, index * sizeof(u64), size);
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 0e79cd5..76ead1a 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -277,10 +277,7 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 		}
 
 		*dataptrs = 0;
-		if (!ip->i_di.di_blocks)
-			gfs2_consist_inode(ip);
-		ip->i_di.di_blocks--;
-		gfs2_set_inode_blocks(&ip->i_inode);
+		gfs2_add_inode_blocks(&ip->i_inode, -1);
 	}
 	if (bstart)
 		gfs2_free_meta(ip, bstart, blen);
@@ -598,8 +595,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	ea->ea_flags = GFS2_EAFLAG_LAST;
 	ea->ea_num_ptrs = 0;
 
-	ip->i_di.di_blocks++;
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_add_inode_blocks(&ip->i_inode, 1);
 
 	return 0;
 }
@@ -651,8 +647,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
 			gfs2_metatype_set(bh, GFS2_METATYPE_ED, GFS2_FORMAT_ED);
 
-			ip->i_di.di_blocks++;
-			gfs2_set_inode_blocks(&ip->i_inode);
+			gfs2_add_inode_blocks(&ip->i_inode, 1);
 
 			copy = data_len > sdp->sd_jbsize ? sdp->sd_jbsize :
 							   data_len;
@@ -980,8 +975,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		*eablk = cpu_to_be64(ip->i_di.di_eattr);
 		ip->i_di.di_eattr = blk;
 		ip->i_di.di_flags |= GFS2_DIF_EA_INDIRECT;
-		ip->i_di.di_blocks++;
-		gfs2_set_inode_blocks(&ip->i_inode);
+		gfs2_add_inode_blocks(&ip->i_inode, 1);
 
 		eablk++;
 	}
@@ -1389,10 +1383,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 		}
 
 		*eablk = 0;
-		if (!ip->i_di.di_blocks)
-			gfs2_consist_inode(ip);
-		ip->i_di.di_blocks--;
-		gfs2_set_inode_blocks(&ip->i_inode);
+		gfs2_add_inode_blocks(&ip->i_inode, -1);
 	}
 	if (bstart)
 		gfs2_free_meta(ip, bstart, blen);
@@ -1444,10 +1435,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 	gfs2_free_meta(ip, ip->i_di.di_eattr, 1);
 
 	ip->i_di.di_eattr = 0;
-	if (!ip->i_di.di_blocks)
-		gfs2_consist_inode(ip);
-	ip->i_di.di_blocks--;
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_add_inode_blocks(&ip->i_inode, -1);
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 898b456..4ba2ea6 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -239,7 +239,6 @@ enum {
 
 struct gfs2_dinode_host {
 	u64 di_size;		/* number of bytes in file */
-	u64 di_blocks;		/* number of blocks in file */
 	u64 di_generation;	/* generation number for NFS */
 	u32 di_flags;		/* GFS2_DIF_... */
 	/* These only apply to directories  */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c3fe8aa..5f50dd5 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -273,8 +273,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
 	di->di_size = be64_to_cpu(str->di_size);
 	i_size_write(&ip->i_inode, di->di_size);
-	di->di_blocks = be64_to_cpu(str->di_blocks);
-	gfs2_set_inode_blocks(&ip->i_inode);
+	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	ip->i_inode.i_atime.tv_sec = be64_to_cpu(str->di_atime);
 	ip->i_inode.i_atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
 	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
@@ -344,7 +343,7 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	struct gfs2_rgrpd *rgd;
 	int error;
 
-	if (ip->i_di.di_blocks != 1) {
+	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
 		if (gfs2_consist_inode(ip))
 			gfs2_dinode_print(ip);
 		return -EIO;
@@ -1398,7 +1397,7 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
 	str->di_nlink = cpu_to_be32(ip->i_inode.i_nlink);
 	str->di_size = cpu_to_be64(di->di_size);
-	str->di_blocks = cpu_to_be64(di->di_blocks);
+	str->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
 	str->di_atime = cpu_to_be64(ip->i_inode.i_atime.tv_sec);
 	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
 	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
@@ -1430,8 +1429,8 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  no_addr = %llu\n",
 	       (unsigned long long)ip->i_no_addr);
 	printk(KERN_INFO "  di_size = %llu\n", (unsigned long long)di->di_size);
-	printk(KERN_INFO "  di_blocks = %llu\n",
-	       (unsigned long long)di->di_blocks);
+	printk(KERN_INFO "  blocks = %llu\n",
+	       (unsigned long long)gfs2_get_inode_blocks(&ip->i_inode));
 	printk(KERN_INFO "  i_goal = %llu\n",
 	       (unsigned long long)ip->i_goal);
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index db73868..580da45 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -10,6 +10,8 @@
 #ifndef __INODE_DOT_H__
 #define __INODE_DOT_H__
 
+#include "util.h"
+
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
 {
 	return !ip->i_height;
@@ -37,13 +39,25 @@ static inline int gfs2_is_dir(const struct gfs2_inode *ip)
 	return S_ISDIR(ip->i_inode.i_mode);
 }
 
-static inline void gfs2_set_inode_blocks(struct inode *inode)
+static inline void gfs2_set_inode_blocks(struct inode *inode, u64 blocks)
+{
+	inode->i_blocks = blocks <<
+		(GFS2_SB(inode)->sd_sb.sb_bsize_shift - GFS2_BASIC_BLOCK_SHIFT);
+}
+
+static inline u64 gfs2_get_inode_blocks(const struct inode *inode)
 {
-	struct gfs2_inode *ip = GFS2_I(inode);
-	inode->i_blocks = ip->i_di.di_blocks <<
+	return inode->i_blocks >>
 		(GFS2_SB(inode)->sd_sb.sb_bsize_shift - GFS2_BASIC_BLOCK_SHIFT);
 }
 
+static inline void gfs2_add_inode_blocks(struct inode *inode, s64 change)
+{
+	gfs2_assert(GFS2_SB(inode), (change >= 0 || inode->i_blocks > -change));
+	change *= (GFS2_SB(inode)->sd_sb.sb_bsize/GFS2_BASIC_BLOCK);
+	inode->i_blocks += change;
+}
+
 static inline int gfs2_check_inum(const struct gfs2_inode *ip, u64 no_addr,
 				  u64 no_formal_ino)
 {
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index e874129..301c945 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -981,8 +981,9 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	brelse(dibh);
 
 	if (ouid != NO_QUOTA_CHANGE || ogid != NO_QUOTA_CHANGE) {
-		gfs2_quota_change(ip, -ip->i_di.di_blocks, ouid, ogid);
-		gfs2_quota_change(ip, ip->i_di.di_blocks, nuid, ngid);
+		u64 blocks = gfs2_get_inode_blocks(&ip->i_inode);
+		gfs2_quota_change(ip, -blocks, ouid, ogid);
+		gfs2_quota_change(ip, blocks, nuid, ngid);
 	}
 
 out_end_trans:
-- 
1.5.1.2

