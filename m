Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXGIQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXGIQ0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbXGIQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbXGIQXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Clean up inode number handling
Date: Mon,  9 Jul 2007 17:02:14 +0100
Message-Id: <11839970061096-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970052865-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch cleans up the inode number handling code. The main difference
is that instead of looking up the inodes using a struct gfs2_inum_host
we now use just the no_addr member of this structure. The tests relating
to no_formal_ino can then be done by the calling code. This has
advantages in that we want to do different things in different code
paths if the no_formal_ino doesn't match. In the NFS patch we want to
return -ESTALE, but in the ->lookup() path, its a bug in the fs if the
no_formal_ino doesn't match and thus we can withdraw in this case.

In order to later fix bz #201012, we need to be able to look up an inode
without knowing no_formal_ino, as the only information that is known to
us is the on-disk location of the inode in question.

This patch will also help us to fix bz #236099 at a later date by
cleaning up a lot of the code in that area.

There are no user visible changes as a result of this patch and there
are no changes to the on-disk format either.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1c40c4b..e76a887 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1040,7 +1040,7 @@ static int trunc_end(struct gfs2_inode *ip)
 		ip->i_di.di_height = 0;
 		ip->i_di.di_goal_meta =
 			ip->i_di.di_goal_data =
-			ip->i_num.no_addr;
+			ip->i_no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	}
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index a96fa07..9cdd71c 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1456,7 +1456,7 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		if (dip->i_di.di_entries != g.offset) {
 			fs_warn(sdp, "Number of entries corrupt in dir %llu, "
 				"ip->i_di.di_entries (%u) != g.offset (%u)\n",
-				(unsigned long long)dip->i_num.no_addr,
+				(unsigned long long)dip->i_no_addr,
 				dip->i_di.di_entries,
 				g.offset);
 			error = -EIO;
@@ -1488,24 +1488,54 @@ out:
  * Returns: errno
  */
 
-int gfs2_dir_search(struct inode *dir, const struct qstr *name,
-		    struct gfs2_inum_host *inum, unsigned int *type)
+struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
 {
 	struct buffer_head *bh;
 	struct gfs2_dirent *dent;
+	struct inode *inode;
+
+	dent = gfs2_dirent_search(dir, name, gfs2_dirent_find, &bh);
+	if (dent) {
+		if (IS_ERR(dent))
+			return ERR_PTR(PTR_ERR(dent));
+		inode = gfs2_inode_lookup(dir->i_sb,
+					  be64_to_cpu(dent->de_inum.no_addr),
+					  be16_to_cpu(dent->de_type));
+		brelse(bh);
+		return inode;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+int gfs2_dir_check(struct inode *dir, const struct qstr *name,
+		   const struct gfs2_inode *ip)
+{
+	struct buffer_head *bh;
+	struct gfs2_dirent *dent;
+	int ret = -ENOENT;
 
 	dent = gfs2_dirent_search(dir, name, gfs2_dirent_find, &bh);
 	if (dent) {
 		if (IS_ERR(dent))
 			return PTR_ERR(dent);
-		if (inum)
-			gfs2_inum_in(inum, (char *)&dent->de_inum);
-		if (type)
-			*type = be16_to_cpu(dent->de_type);
+		if (ip) {
+			if (be64_to_cpu(dent->de_inum.no_addr) != ip->i_no_addr)
+				goto out;
+			if (be64_to_cpu(dent->de_inum.no_formal_ino) !=
+			    ip->i_no_formal_ino)
+				goto out;
+			if (unlikely(IF2DT(ip->i_inode.i_mode) !=
+			    be16_to_cpu(dent->de_type))) {
+				gfs2_consist_inode(GFS2_I(dir));
+				ret = -EIO;
+				goto out;
+			}
+		}
+		ret = 0;
+out:
 		brelse(bh);
-		return 0;
 	}
-	return -ENOENT;
+	return ret;
 }
 
 static int dir_new_leaf(struct inode *inode, const struct qstr *name)
@@ -1565,7 +1595,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
  */
 
 int gfs2_dir_add(struct inode *inode, const struct qstr *name,
-		 const struct gfs2_inum_host *inum, unsigned type)
+		 const struct gfs2_inode *nip, unsigned type)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *bh;
@@ -1580,7 +1610,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			if (IS_ERR(dent))
 				return PTR_ERR(dent);
 			dent = gfs2_init_dirent(inode, dent, name, bh);
-			gfs2_inum_out(inum, (char *)&dent->de_inum);
+			gfs2_inum_out(nip, dent);
 			dent->de_type = cpu_to_be16(type);
 			if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
@@ -1700,7 +1730,7 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *name)
  */
 
 int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
-		   struct gfs2_inum_host *inum, unsigned int new_type)
+		   const struct gfs2_inode *nip, unsigned int new_type)
 {
 	struct buffer_head *bh;
 	struct gfs2_dirent *dent;
@@ -1715,7 +1745,7 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 		return PTR_ERR(dent);
 
 	gfs2_trans_add_bh(dip->i_gl, bh, 1);
-	gfs2_inum_out(inum, (char *)&dent->de_inum);
+	gfs2_inum_out(nip, dent);
 	dent->de_type = cpu_to_be16(new_type);
 
 	if (dip->i_di.di_flags & GFS2_DIF_EXHASH) {
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 48fe890..8a468ca 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -16,15 +16,16 @@ struct inode;
 struct gfs2_inode;
 struct gfs2_inum;
 
-int gfs2_dir_search(struct inode *dir, const struct qstr *filename,
-		    struct gfs2_inum_host *inum, unsigned int *type);
+struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *filename);
+int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
+		   const struct gfs2_inode *ip);
 int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
-		 const struct gfs2_inum_host *inum, unsigned int type);
+		 const struct gfs2_inode *ip, unsigned int type);
 int gfs2_dir_del(struct gfs2_inode *dip, const struct qstr *filename);
 int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		  filldir_t filldir);
 int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
-		   struct gfs2_inum_host *new_inum, unsigned int new_type);
+		   const struct gfs2_inode *nip, unsigned int new_type);
 
 int gfs2_dir_exhash_dealloc(struct gfs2_inode *dip);
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c66c718..b3ed585 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1823,8 +1823,8 @@ static int dump_inode(struct glock_iter *gi, struct gfs2_inode *ip)
 
 	print_dbg(gi, "  Inode:\n");
 	print_dbg(gi, "    num = %llu/%llu\n",
-		  (unsigned long long)ip->i_num.no_formal_ino,
-		  (unsigned long long)ip->i_num.no_addr);
+		  (unsigned long long)ip->i_no_formal_ino,
+		  (unsigned long long)ip->i_no_addr);
 	print_dbg(gi, "    type = %u\n", IF2DT(ip->i_inode.i_mode));
 	print_dbg(gi, "    i_flags =");
 	for (x = 0; x < 32; x++)
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index d995441..00c3004 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -213,8 +213,8 @@ enum {
 
 struct gfs2_inode {
 	struct inode i_inode;
-	struct gfs2_inum_host i_num;
-
+	u64 i_no_addr;
+	u64 i_no_formal_ino;
 	unsigned long i_flags;		/* GIF_... */
 
 	struct gfs2_dinode_host i_di; /* To be replaced by ref to block */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index df0b8b3..58f5a67 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -41,9 +41,9 @@
 static int iget_test(struct inode *inode, void *opaque)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_inum_host *inum = opaque;
+	u64 *no_addr = opaque;
 
-	if (ip->i_num.no_addr == inum->no_addr &&
+	if (ip->i_no_addr == *no_addr &&
 	    inode->i_private != NULL)
 		return 1;
 
@@ -53,37 +53,37 @@ static int iget_test(struct inode *inode, void *opaque)
 static int iget_set(struct inode *inode, void *opaque)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_inum_host *inum = opaque;
+	u64 *no_addr = opaque;
 
-	ip->i_num = *inum;
-	inode->i_ino = inum->no_addr;
+	inode->i_ino = (unsigned long)*no_addr;
+	ip->i_no_addr = *no_addr;
 	return 0;
 }
 
-struct inode *gfs2_ilookup(struct super_block *sb, struct gfs2_inum_host *inum)
+struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr)
 {
-	return ilookup5(sb, (unsigned long)inum->no_addr,
-			iget_test, inum);
+	unsigned long hash = (unsigned long)no_addr;
+	return ilookup5(sb, hash, iget_test, &no_addr);
 }
 
-static struct inode *gfs2_iget(struct super_block *sb, struct gfs2_inum_host *inum)
+static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
 {
-	return iget5_locked(sb, (unsigned long)inum->no_addr,
-		     iget_test, iget_set, inum);
+	unsigned long hash = (unsigned long)no_addr;
+	return iget5_locked(sb, hash, iget_test, iget_set, &no_addr);
 }
 
 /**
  * gfs2_inode_lookup - Lookup an inode
  * @sb: The super block
- * @inum: The inode number
+ * @no_addr: The inode number
  * @type: The type of the inode
  *
  * Returns: A VFS inode, or an error
  */
 
-struct inode *gfs2_inode_lookup(struct super_block *sb, struct gfs2_inum_host *inum, unsigned int type)
+struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned int type)
 {
-	struct inode *inode = gfs2_iget(sb, inum);
+	struct inode *inode = gfs2_iget(sb, no_addr);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_glock *io_gl;
 	int error;
@@ -110,12 +110,12 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, struct gfs2_inum_host *i
 			inode->i_op = &gfs2_dev_iops;
 		}
 
-		error = gfs2_glock_get(sdp, inum->no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
+		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
 		if (unlikely(error))
 			goto fail;
 		ip->i_gl->gl_object = ip;
 
-		error = gfs2_glock_get(sdp, inum->no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
+		error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
 		if (unlikely(error))
 			goto fail_put;
 
@@ -144,14 +144,12 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	struct gfs2_dinode_host *di = &ip->i_di;
 	const struct gfs2_dinode *str = buf;
 
-	if (ip->i_num.no_addr != be64_to_cpu(str->di_num.no_addr)) {
+	if (ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)) {
 		if (gfs2_consist_inode(ip))
 			gfs2_dinode_print(ip);
 		return -EIO;
 	}
-	if (ip->i_num.no_formal_ino != be64_to_cpu(str->di_num.no_formal_ino))
-		return -ESTALE;
-
+	ip->i_no_formal_ino = be64_to_cpu(str->di_num.no_formal_ino);
 	ip->i_inode.i_mode = be32_to_cpu(str->di_mode);
 	ip->i_inode.i_rdev = 0;
 	switch (ip->i_inode.i_mode & S_IFMT) {
@@ -247,7 +245,7 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		goto out_qs;
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
 	if (!rgd) {
 		gfs2_consist_inode(ip);
 		error = -EIO;
@@ -366,8 +364,6 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 	struct super_block *sb = dir->i_sb;
 	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_holder d_gh;
-	struct gfs2_inum_host inum;
-	unsigned int type;
 	int error;
 	struct inode *inode = NULL;
 	int unlock = 0;
@@ -395,12 +391,9 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			goto out;
 	}
 
-	error = gfs2_dir_search(dir, name, &inum, &type);
-	if (error)
-		goto out;
-
-	inode = gfs2_inode_lookup(sb, &inum, type);
-
+	inode = gfs2_dir_search(dir, name);
+	if (IS_ERR(inode))
+		error = PTR_ERR(inode);
 out:
 	if (unlock)
 		gfs2_glock_dq_uninit(&d_gh);
@@ -548,7 +541,7 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (!dip->i_inode.i_nlink)
 		return -EPERM;
 
-	error = gfs2_dir_search(&dip->i_inode, name, NULL, NULL);
+	error = gfs2_dir_check(&dip->i_inode, name, NULL);
 	switch (error) {
 	case -ENOENT:
 		error = 0;
@@ -588,8 +581,7 @@ static void munge_mode_uid_gid(struct gfs2_inode *dip, unsigned int *mode,
 		*gid = current->fsgid;
 }
 
-static int alloc_dinode(struct gfs2_inode *dip, struct gfs2_inum_host *inum,
-			u64 *generation)
+static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	int error;
@@ -605,7 +597,7 @@ static int alloc_dinode(struct gfs2_inode *dip, struct gfs2_inum_host *inum,
 	if (error)
 		goto out_ipreserv;
 
-	inum->no_addr = gfs2_alloc_di(dip, generation);
+	*no_addr = gfs2_alloc_di(dip, generation);
 
 	gfs2_trans_end(sdp);
 
@@ -760,7 +752,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 			goto fail_quota_locks;
 	}
 
-	error = gfs2_dir_add(&dip->i_inode, name, &ip->i_num, IF2DT(ip->i_inode.i_mode));
+	error = gfs2_dir_add(&dip->i_inode, name, ip, IF2DT(ip->i_inode.i_mode));
 	if (error)
 		goto fail_end_trans;
 
@@ -844,7 +836,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	struct gfs2_inode *dip = ghs->gh_gl->gl_object;
 	struct inode *dir = &dip->i_inode;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
-	struct gfs2_inum_host inum;
+	struct gfs2_inum_host inum = { .no_addr = 0, .no_formal_ino = 0 };
 	int error;
 	u64 generation;
 
@@ -864,7 +856,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock;
 
-	error = alloc_dinode(dip, &inum, &generation);
+	error = alloc_dinode(dip, &inum.no_addr, &generation);
 	if (error)
 		goto fail_gunlock;
 
@@ -877,7 +869,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock2;
 
-	inode = gfs2_inode_lookup(dir->i_sb, &inum, IF2DT(mode));
+	inode = gfs2_inode_lookup(dir->i_sb, inum.no_addr, IF2DT(mode));
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
@@ -976,10 +968,8 @@ int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
  */
 
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
-		   struct gfs2_inode *ip)
+		   const struct gfs2_inode *ip)
 {
-	struct gfs2_inum_host inum;
-	unsigned int type;
 	int error;
 
 	if (IS_IMMUTABLE(&ip->i_inode) || IS_APPEND(&ip->i_inode))
@@ -997,18 +987,10 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		return error;
 
-	error = gfs2_dir_search(&dip->i_inode, name, &inum, &type);
+	error = gfs2_dir_check(&dip->i_inode, name, ip);
 	if (error)
 		return error;
 
-	if (!gfs2_inum_equal(&inum, &ip->i_num))
-		return -ENOENT;
-
-	if (IF2DT(ip->i_inode.i_mode) != type) {
-		gfs2_consist_inode(dip);
-		return -EIO;
-	}
-
 	return 0;
 }
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index b57f448..05fc095 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -10,17 +10,17 @@
 #ifndef __INODE_DOT_H__
 #define __INODE_DOT_H__
 
-static inline int gfs2_is_stuffed(struct gfs2_inode *ip)
+static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
 {
 	return !ip->i_di.di_height;
 }
 
-static inline int gfs2_is_jdata(struct gfs2_inode *ip)
+static inline int gfs2_is_jdata(const struct gfs2_inode *ip)
 {
 	return ip->i_di.di_flags & GFS2_DIF_JDATA;
 }
 
-static inline int gfs2_is_dir(struct gfs2_inode *ip)
+static inline int gfs2_is_dir(const struct gfs2_inode *ip)
 {
 	return S_ISDIR(ip->i_inode.i_mode);
 }
@@ -32,9 +32,15 @@ static inline void gfs2_set_inode_blocks(struct inode *inode)
 		(GFS2_SB(inode)->sd_sb.sb_bsize_shift - GFS2_BASIC_BLOCK_SHIFT);
 }
 
+static inline int gfs2_check_inum(const struct gfs2_inode *ip, u64 no_addr,
+				  u64 no_formal_ino)
+{
+	return ip->i_no_addr == no_addr && ip->i_no_formal_ino == no_formal_ino;
+}
+
 void gfs2_inode_attr_in(struct gfs2_inode *ip);
-struct inode *gfs2_inode_lookup(struct super_block *sb, struct gfs2_inum_host *inum, unsigned type);
-struct inode *gfs2_ilookup(struct super_block *sb, struct gfs2_inum_host *inum);
+struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned type);
+struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 int gfs2_inode_refresh(struct gfs2_inode *ip);
 
@@ -47,7 +53,7 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 		struct gfs2_inode *ip);
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
-		   struct gfs2_inode *ip);
+		   const struct gfs2_inode *ip);
 int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index e037425..527bf19 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -63,7 +63,7 @@ int gfs2_meta_indirect_buffer(struct gfs2_inode *ip, int height, u64 num,
 static inline int gfs2_meta_inode_buffer(struct gfs2_inode *ip,
 					 struct buffer_head **bhp)
 {
-	return gfs2_meta_indirect_buffer(ip, 0, ip->i_num.no_addr, 0, bhp);
+	return gfs2_meta_indirect_buffer(ip, 0, ip->i_no_addr, 0, bhp);
 }
 
 struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen);
diff --git a/fs/gfs2/ondisk.c b/fs/gfs2/ondisk.c
index d9ecfd2..cd4cf05 100644
--- a/fs/gfs2/ondisk.c
+++ b/fs/gfs2/ondisk.c
@@ -33,26 +33,10 @@
  * first arg: the cpu-order structure
  */
 
-void gfs2_inum_in(struct gfs2_inum_host *no, const void *buf)
+void gfs2_inum_out(const struct gfs2_inode *ip, struct gfs2_dirent *dent)
 {
-	const struct gfs2_inum *str = buf;
-
-	no->no_formal_ino = be64_to_cpu(str->no_formal_ino);
-	no->no_addr = be64_to_cpu(str->no_addr);
-}
-
-void gfs2_inum_out(const struct gfs2_inum_host *no, void *buf)
-{
-	struct gfs2_inum *str = buf;
-
-	str->no_formal_ino = cpu_to_be64(no->no_formal_ino);
-	str->no_addr = cpu_to_be64(no->no_addr);
-}
-
-static void gfs2_inum_print(const struct gfs2_inum_host *no)
-{
-	printk(KERN_INFO "  no_formal_ino = %llu\n", (unsigned long long)no->no_formal_ino);
-	printk(KERN_INFO "  no_addr = %llu\n", (unsigned long long)no->no_addr);
+	dent->de_inum.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
+	dent->de_inum.no_addr = cpu_to_be64(ip->i_no_addr);
 }
 
 static void gfs2_meta_header_in(struct gfs2_meta_header_host *mh, const void *buf)
@@ -74,9 +58,10 @@ void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
 	sb->sb_multihost_format = be32_to_cpu(str->sb_multihost_format);
 	sb->sb_bsize = be32_to_cpu(str->sb_bsize);
 	sb->sb_bsize_shift = be32_to_cpu(str->sb_bsize_shift);
-
-	gfs2_inum_in(&sb->sb_master_dir, (char *)&str->sb_master_dir);
-	gfs2_inum_in(&sb->sb_root_dir, (char *)&str->sb_root_dir);
+	sb->sb_master_dir.no_addr = be64_to_cpu(str->sb_master_dir.no_addr);
+	sb->sb_master_dir.no_formal_ino = be64_to_cpu(str->sb_master_dir.no_formal_ino);
+	sb->sb_root_dir.no_addr = be64_to_cpu(str->sb_root_dir.no_addr);
+	sb->sb_root_dir.no_formal_ino = be64_to_cpu(str->sb_root_dir.no_formal_ino);
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
@@ -146,9 +131,8 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_header.__pad0 = 0;
 	str->di_header.mh_format = cpu_to_be32(GFS2_FORMAT_DI);
 	str->di_header.__pad1 = 0;
-
-	gfs2_inum_out(&ip->i_num, &str->di_num);
-
+	str->di_num.no_addr = cpu_to_be64(ip->i_no_addr);
+	str->di_num.no_formal_ino = cpu_to_be64(ip->i_no_formal_ino);
 	str->di_mode = cpu_to_be32(ip->i_inode.i_mode);
 	str->di_uid = cpu_to_be32(ip->i_inode.i_uid);
 	str->di_gid = cpu_to_be32(ip->i_inode.i_gid);
@@ -178,7 +162,8 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 {
 	const struct gfs2_dinode_host *di = &ip->i_di;
 
-	gfs2_inum_print(&ip->i_num);
+	printk(KERN_INFO "  no_formal_ino = %llu\n", (unsigned long long)ip->i_no_formal_ino);
+	printk(KERN_INFO "  no_addr = %llu\n", (unsigned long long)ip->i_no_addr);
 
 	printk(KERN_INFO "  di_size = %llu\n", (unsigned long long)di->di_size);
 	printk(KERN_INFO "  di_blocks = %llu\n", (unsigned long long)di->di_blocks);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 4913ef5..fb84478 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -757,8 +757,8 @@ static unsigned limit = 0;
 			return;
 
 		fs_warn(sdp, "ip = %llu %llu\n",
-			(unsigned long long)ip->i_num.no_formal_ino,
-			(unsigned long long)ip->i_num.no_addr);
+			(unsigned long long)ip->i_no_formal_ino,
+			(unsigned long long)ip->i_no_addr);
 
 		for (x = 0; x < GFS2_MAX_META_HEIGHT; x++)
 			fs_warn(sdp, "ip->i_cache[%u] = %s\n",
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
index a6fdc52..793e334 100644
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -21,6 +21,7 @@
 #include "glock.h"
 #include "ops_dentry.h"
 #include "util.h"
+#include "inode.h"
 
 /**
  * gfs2_drevalidate - Check directory lookup consistency
@@ -40,14 +41,15 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 	struct gfs2_inode *dip = GFS2_I(parent->d_inode);
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_holder d_gh;
-	struct gfs2_inode *ip;
-	struct gfs2_inum_host inum;
-	unsigned int type;
+	struct gfs2_inode *ip = NULL;
 	int error;
 	int had_lock=0;
 
-	if (inode && is_bad_inode(inode))
-		goto invalid;
+	if (inode) {
+		if (is_bad_inode(inode))
+			goto invalid;
+		ip = GFS2_I(inode);
+	}
 
 	if (sdp->sd_args.ar_localcaching)
 		goto valid;
@@ -59,7 +61,7 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 			goto fail;
 	} 
 
-	error = gfs2_dir_search(parent->d_inode, &dentry->d_name, &inum, &type);
+	error = gfs2_dir_check(parent->d_inode, &dentry->d_name, ip);
 	switch (error) {
 	case 0:
 		if (!inode)
@@ -73,16 +75,6 @@ static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
 		goto fail_gunlock;
 	}
 
-	ip = GFS2_I(inode);
-
-	if (!gfs2_inum_equal(&ip->i_num, &inum))
-		goto invalid_gunlock;
-
-	if (IF2DT(ip->i_inode.i_mode) != type) {
-		gfs2_consist_inode(dip);
-		goto fail_gunlock;
-	}
-
 valid_gunlock:
 	if (!had_lock)
 		gfs2_glock_dq_uninit(&d_gh);
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index aad9183..51a8a14 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -75,10 +75,10 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 	    (connectable && *len < GFS2_LARGE_FH_SIZE))
 		return 255;
 
-	fh[0] = cpu_to_be32(ip->i_num.no_formal_ino >> 32);
-	fh[1] = cpu_to_be32(ip->i_num.no_formal_ino & 0xFFFFFFFF);
-	fh[2] = cpu_to_be32(ip->i_num.no_addr >> 32);
-	fh[3] = cpu_to_be32(ip->i_num.no_addr & 0xFFFFFFFF);
+	fh[0] = cpu_to_be32(ip->i_no_formal_ino >> 32);
+	fh[1] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
+	fh[2] = cpu_to_be32(ip->i_no_addr >> 32);
+	fh[3] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
 	*len = GFS2_SMALL_FH_SIZE;
 
 	if (!connectable || inode == sb->s_root->d_inode)
@@ -90,10 +90,10 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 	igrab(inode);
 	spin_unlock(&dentry->d_lock);
 
-	fh[4] = cpu_to_be32(ip->i_num.no_formal_ino >> 32);
-	fh[5] = cpu_to_be32(ip->i_num.no_formal_ino & 0xFFFFFFFF);
-	fh[6] = cpu_to_be32(ip->i_num.no_addr >> 32);
-	fh[7] = cpu_to_be32(ip->i_num.no_addr & 0xFFFFFFFF);
+	fh[4] = cpu_to_be32(ip->i_no_formal_ino >> 32);
+	fh[5] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
+	fh[6] = cpu_to_be32(ip->i_no_addr >> 32);
+	fh[7] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
 
 	fh[8]  = cpu_to_be32(inode->i_mode);
 	fh[9]  = 0;	/* pad to double word */
@@ -144,7 +144,8 @@ static int gfs2_get_name(struct dentry *parent, char *name,
 	ip = GFS2_I(inode);
 
 	*name = 0;
-	gnfd.inum = ip->i_num;
+	gnfd.inum.no_addr = ip->i_no_addr;
+	gnfd.inum.no_formal_ino = ip->i_no_formal_ino;
 	gnfd.name = name;
 
 	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &gh);
@@ -202,9 +203,9 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 
 	/* System files? */
 
-	inode = gfs2_ilookup(sb, inum);
+	inode = gfs2_ilookup(sb, inum->no_addr);
 	if (inode) {
-		if (GFS2_I(inode)->i_num.no_formal_ino != inum->no_formal_ino) {
+		if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
 			iput(inode);
 			return ERR_PTR(-ESTALE);
 		}
@@ -236,7 +237,7 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 	gfs2_glock_dq_uninit(&rgd_gh);
 	gfs2_glock_dq_uninit(&ri_gh);
 
-	inode = gfs2_inode_lookup(sb, inum, fh_obj->imode);
+	inode = gfs2_inode_lookup(sb, inum->no_addr, fh_obj->imode);
 	if (!inode)
 		goto fail;
 	if (IS_ERR(inode)) {
@@ -249,6 +250,10 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
 		iput(inode);
 		goto fail;
 	}
+	if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
+		iput(inode);
+		goto fail;
+	}
 
 	error = -EIO;
 	if (GFS2_I(inode)->i_di.di_flags & GFS2_DIF_SYSTEM) {
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 064df88..550032c 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -502,7 +502,7 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
 	struct lm_lockname name =
-		{ .ln_number = ip->i_num.no_addr,
+		{ .ln_number = ip->i_no_addr,
 		  .ln_type = LM_TYPE_PLOCK };
 
 	if (!(fl->fl_flags & FL_POSIX))
@@ -557,7 +557,7 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 		gfs2_glock_dq_uninit(fl_gh);
 	} else {
 		error = gfs2_glock_get(GFS2_SB(&ip->i_inode),
-				      ip->i_num.no_addr, &gfs2_flock_glops,
+				      ip->i_no_addr, &gfs2_flock_glops,
 				      CREATE, &gl);
 		if (error)
 			goto out;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 2c5f8e7..c682371 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -236,17 +236,17 @@ fail:
 	return error;
 }
 
-static struct inode *gfs2_lookup_root(struct super_block *sb,
-				      struct gfs2_inum_host *inum)
+static inline struct inode *gfs2_lookup_root(struct super_block *sb,
+					     u64 no_addr)
 {
-	return gfs2_inode_lookup(sb, inum, DT_DIR);
+	return gfs2_inode_lookup(sb, no_addr, DT_DIR);
 }
 
 static int init_sb(struct gfs2_sbd *sdp, int silent, int undo)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct gfs2_holder sb_gh;
-	struct gfs2_inum_host *inum;
+	u64 no_addr;
 	struct inode *inode;
 	int error = 0;
 
@@ -289,10 +289,10 @@ static int init_sb(struct gfs2_sbd *sdp, int silent, int undo)
 	sb_set_blocksize(sb, sdp->sd_sb.sb_bsize);
 
 	/* Get the root inode */
-	inum = &sdp->sd_sb.sb_root_dir;
+	no_addr = sdp->sd_sb.sb_root_dir.no_addr;
 	if (sb->s_type == &gfs2meta_fs_type)
-		inum = &sdp->sd_sb.sb_master_dir;
-	inode = gfs2_lookup_root(sb, inum);
+		no_addr = sdp->sd_sb.sb_master_dir.no_addr;
+	inode = gfs2_lookup_root(sb, no_addr);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		fs_err(sdp, "can't read in root inode: %d\n", error);
@@ -449,7 +449,7 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 	if (undo)
 		goto fail_qinode;
 
-	inode = gfs2_lookup_root(sdp->sd_vfs, &sdp->sd_sb.sb_master_dir);
+	inode = gfs2_lookup_root(sdp->sd_vfs, sdp->sd_sb.sb_master_dir.no_addr);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		fs_err(sdp, "can't read in master directory: %d\n", error);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index d85f6e0..f8ecfec 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -157,7 +157,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out_gunlock;
 
-	error = gfs2_dir_search(dir, &dentry->d_name, NULL, NULL);
+	error = gfs2_dir_check(dir, &dentry->d_name, NULL);
 	switch (error) {
 	case -ENOENT:
 		break;
@@ -217,8 +217,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_ipres;
 	}
 
-	error = gfs2_dir_add(dir, &dentry->d_name, &ip->i_num,
-			     IF2DT(inode->i_mode));
+	error = gfs2_dir_add(dir, &dentry->d_name, ip, IF2DT(inode->i_mode));
 	if (error)
 		goto out_end_trans;
 
@@ -275,7 +274,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 
@@ -420,7 +419,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		dent = (struct gfs2_dirent *)((char*)dent + GFS2_DIRENT_SIZE(1));
 		gfs2_qstr2dirent(&str, dibh->b_size - GFS2_DIRENT_SIZE(1) - sizeof(struct gfs2_dinode), dent);
 
-		gfs2_inum_out(&dip->i_num, &dent->de_inum);
+		gfs2_inum_out(dip, dent);
 		dent->de_type = cpu_to_be16(DT_DIR);
 
 		gfs2_dinode_out(ip, di);
@@ -472,7 +471,7 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
 	error = gfs2_glock_nq_m(3, ghs);
@@ -614,7 +613,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		 * this is the case of the target file already existing
 		 * so we unlink before doing the rename
 		 */
-		nrgd = gfs2_blk2rgrpd(sdp, nip->i_num.no_addr);
+		nrgd = gfs2_blk2rgrpd(sdp, nip->i_no_addr);
 		if (nrgd)
 			gfs2_holder_init(nrgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + num_gh++);
 	}
@@ -653,7 +652,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_gunlock;
 
-		error = gfs2_dir_search(ndir, &ndentry->d_name, NULL, NULL);
+		error = gfs2_dir_check(ndir, &ndentry->d_name, NULL);
 		switch (error) {
 		case -ENOENT:
 			error = 0;
@@ -750,7 +749,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_end_trans;
 
-		error = gfs2_dir_mvino(ip, &name, &ndip->i_num, DT_DIR);
+		error = gfs2_dir_mvino(ip, &name, nip, DT_DIR);
 		if (error)
 			goto out_end_trans;
 	} else {
@@ -768,8 +767,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_dir_add(ndir, &ndentry->d_name, &ip->i_num,
-			     IF2DT(ip->i_inode.i_mode));
+	error = gfs2_dir_add(ndir, &ndentry->d_name, ip, IF2DT(ip->i_inode.i_mode));
 	if (error)
 		goto out_end_trans;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a62c0f2..30eb428 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1470,7 +1470,7 @@ void gfs2_unlink_di(struct inode *inode)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_rgrpd *rgd;
-	u64 blkno = ip->i_num.no_addr;
+	u64 blkno = ip->i_no_addr;
 
 	rgd = rgblk_free(sdp, blkno, 1, GFS2_BLKST_UNLINKED);
 	if (!rgd)
@@ -1505,9 +1505,9 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 
 void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 {
-	gfs2_free_uninit_di(rgd, ip->i_num.no_addr);
+	gfs2_free_uninit_di(rgd, ip->i_no_addr);
 	gfs2_quota_change(ip, -1, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	gfs2_meta_wipe(ip, ip->i_num.no_addr, 1);
+	gfs2_meta_wipe(ip, ip->i_no_addr, 1);
 }
 
 /**
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4fdda97..faccffd 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -360,7 +360,7 @@ int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
 		name.len = sprintf(buf, "journal%u", sdp->sd_journals);
 		name.hash = gfs2_disk_hash(name.name, name.len);
 
-		error = gfs2_dir_search(sdp->sd_jindex, &name, NULL, NULL);
+		error = gfs2_dir_check(sdp->sd_jindex, &name, NULL);
 		if (error == -ENOENT) {
 			error = 0;
 			break;
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 601eaa1..3f5edc5 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -115,8 +115,8 @@ int gfs2_consist_inode_i(struct gfs2_inode *ip, int cluster_wide,
 		"GFS2: fsid=%s:   inode = %llu %llu\n"
 		"GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
 		sdp->sd_fsname,
-		sdp->sd_fsname, (unsigned long long)ip->i_num.no_formal_ino,
-		(unsigned long long)ip->i_num.no_addr,
+		sdp->sd_fsname, (unsigned long long)ip->i_no_formal_ino,
+		(unsigned long long)ip->i_no_addr,
 		sdp->sd_fsname, function, file, line);
 	return rv;
 }
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 8b7e4c1..a82ec8c 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -59,13 +59,6 @@ struct gfs2_inum_host {
 	__u64 no_addr;
 };
 
-static inline int gfs2_inum_equal(const struct gfs2_inum_host *ino1,
-				  const struct gfs2_inum_host *ino2)
-{
-	return ino1->no_formal_ino == ino2->no_formal_ino &&
-	       ino1->no_addr == ino2->no_addr;
-}
-
 /*
  * Generic metadata head structure
  * Every inplace buffer logged in the journal must start with this.
@@ -509,9 +502,9 @@ struct gfs2_quota_change_host {
 
 #ifdef __KERNEL__
 /* Translation functions */
+struct gfs2_inode;
 
-extern void gfs2_inum_in(struct gfs2_inum_host *no, const void *buf);
-extern void gfs2_inum_out(const struct gfs2_inum_host *no, void *buf);
+extern void gfs2_inum_out(const struct gfs2_inode *ip, struct gfs2_dirent *dent);
 extern void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf);
 extern void gfs2_rindex_in(struct gfs2_rindex_host *ri, const void *buf);
 extern void gfs2_rindex_out(const struct gfs2_rindex_host *ri, void *buf);
-- 
1.5.1.2

