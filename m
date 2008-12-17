Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755313AbYLQMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYLQMcT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYLQM3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYLQM3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:15 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/24] GFS2: Banish struct gfs2_dinode_host
Date: Wed, 17 Dec 2008 11:30:08 +0000
Message-Id: <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The final field in gfs2_dinode_host was the i_flags field. Thats
renamed to i_diskflags in order to avoid confusion with the existing
inode flags, and moved into the inode proper at a suitable location
to avoid creating a "hole".

At that point struct gfs2_dinode_host is no longer needed and as
promised (quite some time ago!) it can now be removed completely.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index b43aee7..789f28c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1047,7 +1047,7 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 		if (!error) {
 			ip->i_disksize = size;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-			ip->i_di.di_flags |= GFS2_DIF_TRUNC_IN_PROG;
+			ip->i_diskflags |= GFS2_DIF_TRUNC_IN_PROG;
 			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 			gfs2_dinode_out(ip, dibh->b_data);
 		}
@@ -1120,7 +1120,7 @@ static int trunc_end(struct gfs2_inode *ip)
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	}
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-	ip->i_di.di_flags &= ~GFS2_DIF_TRUNC_IN_PROG;
+	ip->i_diskflags &= ~GFS2_DIF_TRUNC_IN_PROG;
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index d8d8232..b7c8e5c 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -36,7 +36,7 @@
  * the block.  In leaves, they begin at offset sizeof(struct gfs2_leaf) from the
  * beginning of the leaf block. The dirents reside in leaves when
  *
- * dip->i_di.di_flags & GFS2_DIF_EXHASH is true
+ * dip->i_diskflags & GFS2_DIF_EXHASH is true
  *
  * Otherwise, the dirents are "linear", within a single stuffed dinode block.
  *
@@ -755,7 +755,7 @@ static struct gfs2_dirent *gfs2_dirent_search(struct inode *inode,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	int error;
 
-	if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
+	if (ip->i_diskflags & GFS2_DIF_EXHASH) {
 		struct gfs2_leaf *leaf;
 		unsigned hsize = 1 << ip->i_depth;
 		unsigned index;
@@ -907,7 +907,7 @@ static int dir_make_exhash(struct inode *inode)
 
 	dip->i_disksize = sdp->sd_sb.sb_bsize / 2;
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
-	dip->i_di.di_flags |= GFS2_DIF_EXHASH;
+	dip->i_diskflags |= GFS2_DIF_EXHASH;
 
 	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
 	dip->i_depth = y;
@@ -1429,7 +1429,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 	if (!dip->i_entries)
 		return 0;
 
-	if (dip->i_di.di_flags & GFS2_DIF_EXHASH)
+	if (dip->i_diskflags & GFS2_DIF_EXHASH)
 		return dir_e_read(inode, offset, opaque, filldir);
 
 	if (!gfs2_is_stuffed(dip)) {
@@ -1612,7 +1612,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			dent = gfs2_init_dirent(inode, dent, name, bh);
 			gfs2_inum_out(nip, dent);
 			dent->de_type = cpu_to_be16(type);
-			if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
+			if (ip->i_diskflags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
 				be16_add_cpu(&leaf->lf_entries, 1);
 			}
@@ -1628,7 +1628,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			error = 0;
 			break;
 		}
-		if (!(ip->i_di.di_flags & GFS2_DIF_EXHASH)) {
+		if (!(ip->i_diskflags & GFS2_DIF_EXHASH)) {
 			error = dir_make_exhash(inode);
 			if (error)
 				break;
@@ -1691,7 +1691,7 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
 	}
 
 	dirent_del(dip, bh, prev, dent);
-	if (dip->i_di.di_flags & GFS2_DIF_EXHASH) {
+	if (dip->i_diskflags & GFS2_DIF_EXHASH) {
 		struct gfs2_leaf *leaf = (struct gfs2_leaf *)bh->b_data;
 		u16 entries = be16_to_cpu(leaf->lf_entries);
 		if (!entries)
@@ -1748,7 +1748,7 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 	gfs2_inum_out(nip, dent);
 	dent->de_type = cpu_to_be16(new_type);
 
-	if (dip->i_di.di_flags & GFS2_DIF_EXHASH) {
+	if (dip->i_diskflags & GFS2_DIF_EXHASH) {
 		brelse(bh);
 		error = gfs2_meta_inode_buffer(dip, &bh);
 		if (error)
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 1c1e061..0d1c76d 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -118,7 +118,7 @@ static int ea_foreach(struct gfs2_inode *ip, ea_call_t ea_call, void *data)
 	if (error)
 		return error;
 
-	if (!(ip->i_di.di_flags & GFS2_DIF_EA_INDIRECT)) {
+	if (!(ip->i_diskflags & GFS2_DIF_EA_INDIRECT)) {
 		error = ea_foreach_i(ip, bh, ea_call, data);
 		goto out;
 	}
@@ -935,7 +935,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	int error;
 	int mh_size = sizeof(struct gfs2_meta_header);
 
-	if (ip->i_di.di_flags & GFS2_DIF_EA_INDIRECT) {
+	if (ip->i_diskflags & GFS2_DIF_EA_INDIRECT) {
 		__be64 *end;
 
 		error = gfs2_meta_read(ip->i_gl, ip->i_eattr, DIO_WAIT,
@@ -974,7 +974,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 		eablk = (__be64 *)(indbh->b_data + mh_size);
 		*eablk = cpu_to_be64(ip->i_eattr);
 		ip->i_eattr = blk;
-		ip->i_di.di_flags |= GFS2_DIF_EA_INDIRECT;
+		ip->i_diskflags |= GFS2_DIF_EA_INDIRECT;
 		gfs2_add_inode_blocks(&ip->i_inode, 1);
 
 		eablk++;
@@ -1015,7 +1015,7 @@ static int ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (error)
 		return error;
 
-	if (!(ip->i_di.di_flags & GFS2_DIF_EA_INDIRECT))
+	if (!(ip->i_diskflags & GFS2_DIF_EA_INDIRECT))
 		blks++;
 	if (GFS2_EAREQ_SIZE_STUFFED(er) > GFS2_SB(&ip->i_inode)->sd_jbsize)
 		blks += DIV_ROUND_UP(er->er_data_len, GFS2_SB(&ip->i_inode)->sd_jbsize);
@@ -1051,7 +1051,7 @@ int gfs2_ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 		return error;
 
 	if (el.el_ea) {
-		if (ip->i_di.di_flags & GFS2_DIF_APPENDONLY) {
+		if (ip->i_diskflags & GFS2_DIF_APPENDONLY) {
 			brelse(el.el_bh);
 			return -EPERM;
 		}
@@ -1388,7 +1388,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 	if (bstart)
 		gfs2_free_meta(ip, bstart, blen);
 
-	ip->i_di.di_flags &= ~GFS2_DIF_EA_INDIRECT;
+	ip->i_diskflags &= ~GFS2_DIF_EA_INDIRECT;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
@@ -1479,7 +1479,7 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out_rindex;
 
-	if (ip->i_di.di_flags & GFS2_DIF_EA_INDIRECT) {
+	if (ip->i_diskflags & GFS2_DIF_EA_INDIRECT) {
 		error = ea_dealloc_indirect(ip);
 		if (error)
 			goto out_rindex;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index c6c318c..848d64c 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -239,7 +239,7 @@ static int inode_go_lock(struct gfs2_holder *gh)
 			return error;
 	}
 
-	if ((ip->i_di.di_flags & GFS2_DIF_TRUNC_IN_PROG) &&
+	if ((ip->i_diskflags & GFS2_DIF_TRUNC_IN_PROG) &&
 	    (gl->gl_state == LM_ST_EXCLUSIVE) &&
 	    (gh->gh_state == LM_ST_EXCLUSIVE))
 		error = gfs2_truncatei_resume(ip);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 4596cd2..6f67e75 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -233,9 +233,6 @@ enum {
 	GIF_USER                = 4, /* user inode, not metadata addr space */
 };
 
-struct gfs2_dinode_host {
-	u32 di_flags;		/* GFS2_DIF_... */
-};
 
 struct gfs2_inode {
 	struct inode i_inode;
@@ -245,9 +242,6 @@ struct gfs2_inode {
 	u64 i_eattr;
 	loff_t i_disksize;
 	unsigned long i_flags;		/* GIF_... */
-
-	struct gfs2_dinode_host i_di; /* To be replaced by ref to block */
-
 	struct gfs2_glock *i_gl; /* Move into i_gh? */
 	struct gfs2_holder i_iopen_gh;
 	struct gfs2_holder i_gh; /* for prepare/commit_write only */
@@ -255,6 +249,7 @@ struct gfs2_inode {
 	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
 	u32 i_entries;
+	u32 i_diskflags;
 	u8 i_height;
 	u8 i_depth;
 };
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5651178..1e66fb7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -247,7 +247,6 @@ fail:
 
 static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
-	struct gfs2_dinode_host *di = &ip->i_di;
 	const struct gfs2_dinode *str = buf;
 	struct timespec atime;
 	u16 height, depth;
@@ -288,7 +287,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_goal = be64_to_cpu(str->di_goal_meta);
 	ip->i_generation = be64_to_cpu(str->di_generation);
 
-	di->di_flags = be32_to_cpu(str->di_flags);
+	ip->i_diskflags = be32_to_cpu(str->di_flags);
 	gfs2_set_inode_flags(&ip->i_inode);
 	height = be16_to_cpu(str->di_height);
 	if (unlikely(height > GFS2_MAX_META_HEIGHT))
@@ -789,11 +788,11 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	di->di_flags = 0;
 
 	if (S_ISREG(mode)) {
-		if ((dip->i_di.di_flags & GFS2_DIF_INHERIT_JDATA) ||
+		if ((dip->i_diskflags & GFS2_DIF_INHERIT_JDATA) ||
 		    gfs2_tune_get(sdp, gt_new_files_jdata))
 			di->di_flags |= cpu_to_be32(GFS2_DIF_JDATA);
 	} else if (S_ISDIR(mode)) {
-		di->di_flags |= cpu_to_be32(dip->i_di.di_flags &
+		di->di_flags |= cpu_to_be32(dip->i_diskflags &
 					    GFS2_DIF_INHERIT_JDATA);
 	}
 
@@ -1241,7 +1240,6 @@ int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
 
 void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 {
-	const struct gfs2_dinode_host *di = &ip->i_di;
 	struct gfs2_dinode *str = buf;
 
 	str->di_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
@@ -1265,10 +1263,10 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_goal_data = cpu_to_be64(ip->i_goal);
 	str->di_generation = cpu_to_be64(ip->i_generation);
 
-	str->di_flags = cpu_to_be32(di->di_flags);
+	str->di_flags = cpu_to_be32(ip->i_diskflags);
 	str->di_height = cpu_to_be16(ip->i_height);
 	str->di_payload_format = cpu_to_be32(S_ISDIR(ip->i_inode.i_mode) &&
-					     !(ip->i_di.di_flags & GFS2_DIF_EXHASH) ?
+					     !(ip->i_diskflags & GFS2_DIF_EXHASH) ?
 					     GFS2_FORMAT_DE : 0);
 	str->di_depth = cpu_to_be16(ip->i_depth);
 	str->di_entries = cpu_to_be32(ip->i_entries);
@@ -1281,8 +1279,6 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 
 void gfs2_dinode_print(const struct gfs2_inode *ip)
 {
-	const struct gfs2_dinode_host *di = &ip->i_di;
-
 	printk(KERN_INFO "  no_formal_ino = %llu\n",
 	       (unsigned long long)ip->i_no_formal_ino);
 	printk(KERN_INFO "  no_addr = %llu\n",
@@ -1293,7 +1289,7 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	       (unsigned long long)gfs2_get_inode_blocks(&ip->i_inode));
 	printk(KERN_INFO "  i_goal = %llu\n",
 	       (unsigned long long)ip->i_goal);
-	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
+	printk(KERN_INFO "  i_diskflags = 0x%.8X\n", ip->i_diskflags);
 	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
 	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
 	printk(KERN_INFO "  i_entries = %u\n", ip->i_entries);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index c357790..d532936 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -20,7 +20,7 @@ static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
 
 static inline int gfs2_is_jdata(const struct gfs2_inode *ip)
 {
-	return ip->i_di.di_flags & GFS2_DIF_JDATA;
+	return ip->i_diskflags & GFS2_DIF_JDATA;
 }
 
 static inline int gfs2_is_writeback(const struct gfs2_inode *ip)
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index 3a9b9b4..7fdeb14 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -213,7 +213,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 	}
 
 	error = -EIO;
-	if (GFS2_I(inode)->i_di.di_flags & GFS2_DIF_SYSTEM) {
+	if (GFS2_I(inode)->i_diskflags & GFS2_DIF_SYSTEM) {
 		iput(inode);
 		goto fail;
 	}
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index d7e649e..a6b7a73 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -157,8 +157,8 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 	if (error)
 		return error;
 
-	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_di.di_flags);
-	if (!S_ISDIR(inode->i_mode) && ip->i_di.di_flags & GFS2_DIF_JDATA)
+	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_diskflags);
+	if (!S_ISDIR(inode->i_mode) && ip->i_diskflags & GFS2_DIF_JDATA)
 		fsflags |= FS_JOURNAL_DATA_FL;
 	if (put_user(fsflags, ptr))
 		error = -EFAULT;
@@ -171,17 +171,16 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 void gfs2_set_inode_flags(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_dinode_host *di = &ip->i_di;
 	unsigned int flags = inode->i_flags;
 
 	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (di->di_flags & GFS2_DIF_IMMUTABLE)
+	if (ip->i_diskflags & GFS2_DIF_IMMUTABLE)
 		flags |= S_IMMUTABLE;
-	if (di->di_flags & GFS2_DIF_APPENDONLY)
+	if (ip->i_diskflags & GFS2_DIF_APPENDONLY)
 		flags |= S_APPEND;
-	if (di->di_flags & GFS2_DIF_NOATIME)
+	if (ip->i_diskflags & GFS2_DIF_NOATIME)
 		flags |= S_NOATIME;
-	if (di->di_flags & GFS2_DIF_SYNC)
+	if (ip->i_diskflags & GFS2_DIF_SYNC)
 		flags |= S_SYNC;
 	inode->i_flags = flags;
 }
@@ -220,7 +219,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	if (error)
 		goto out_drop_write;
 
-	flags = ip->i_di.di_flags;
+	flags = ip->i_diskflags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
 		goto out;
@@ -259,7 +258,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	if (error)
 		goto out_trans_end;
 	gfs2_trans_add_bh(ip->i_gl, bh, 1);
-	ip->i_di.di_flags = new_flags;
+	ip->i_diskflags = new_flags;
 	gfs2_dinode_out(ip, bh->b_data);
 	brelse(bh);
 	gfs2_set_inode_flags(inode);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index b932d72..4987754 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -426,7 +426,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	ip->i_inode.i_nlink = 2;
 	ip->i_disksize = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
-	ip->i_di.di_flags |= GFS2_DIF_JDATA;
+	ip->i_diskflags |= GFS2_DIF_JDATA;
 	ip->i_entries = 2;
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index aee6cba..ad36af2 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -496,7 +496,7 @@ static void gfs2_delete_inode(struct inode *inode)
 		goto out_truncate;
 
 	if (S_ISDIR(inode->i_mode) &&
-	    (ip->i_di.di_flags & GFS2_DIF_EXHASH)) {
+	    (ip->i_diskflags & GFS2_DIF_EXHASH)) {
 		error = gfs2_dir_exhash_dealloc(ip);
 		if (error)
 			goto out_unlock;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 188d0a2..228a465 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1013,7 +1013,7 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 
 	if (gfs2_assert_warn(GFS2_SB(&ip->i_inode), change))
 		return;
-	if (ip->i_di.di_flags & GFS2_DIF_SYSTEM)
+	if (ip->i_diskflags & GFS2_DIF_SYSTEM)
 		return;
 
 	for (x = 0; x < al->al_qd_num; x++) {
-- 
1.6.0.3

