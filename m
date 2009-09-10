Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZIJKbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZIJKbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZIJKa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbZIJKaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:30:02 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/15] GFS2: Remove no_formal_ino generating code
Date: Thu, 10 Sep 2009 12:28:05 +0100
Message-Id: <1252582087-10007-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-13-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-12-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-13-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inum structure used throughout GFS2 has two fields. One
no_addr is the disk block number of the inode in question and
is used everywhere as the inode number. The other, no_formal_ino,
is used only as the generation number for NFS.

Historically the no_formal_ino field was set using a complicated
system of one global and one per-node file containing inode numbers
in order to ensure that each no_formal_ino was unique. Also this
code made no provision for what would happen when eventually the
(64 bit) numbers ran out. Now I know that is pretty unlikely to
happen given the large space of numbers, but it is possible
nevertheless.

The only guarantee required for no_formal_ino is that, for any
single inode, the same number doesn't get reused too quickly.

We already have a generation number which is kept in the inode
and initialised from a counter in the resource group (almost
no overhead, since we have to touch the resource group anyway
in order to allocate an inode in the first place). Aside from
ensuring that we never use the value 0 in the no_formal_ino
field, we can use that counter directly.

As a result of that change, we lose about 200 lines of code and
also gain about 10 creates/sec on the postmark benchmark (on
my test machine).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/incore.h     |    7 ---
 fs/gfs2/inode.c      |  143 +------------------------------------------------
 fs/gfs2/ops_fstype.c |   45 ++--------------
 fs/gfs2/rgrp.c       |    2 +
 fs/gfs2/super.c      |    3 -
 5 files changed, 10 insertions(+), 190 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 1d11e6e..52436ab 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -548,18 +548,12 @@ struct gfs2_sbd {
 	struct dentry *sd_root_dir;
 
 	struct inode *sd_jindex;
-	struct inode *sd_inum_inode;
 	struct inode *sd_statfs_inode;
-	struct inode *sd_ir_inode;
 	struct inode *sd_sc_inode;
 	struct inode *sd_qc_inode;
 	struct inode *sd_rindex;
 	struct inode *sd_quota_inode;
 
-	/* Inum stuff */
-
-	struct mutex sd_inum_mutex;
-
 	/* StatFS stuff */
 
 	spinlock_t sd_statfs_spin;
@@ -587,7 +581,6 @@ struct gfs2_sbd {
 	struct gfs2_holder sd_journal_gh;
 	struct gfs2_holder sd_jinode_gh;
 
-	struct gfs2_holder sd_ir_gh;
 	struct gfs2_holder sd_sc_gh;
 	struct gfs2_holder sd_qc_gh;
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4f5e442..fb15d3b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -519,139 +519,6 @@ out:
 	return inode ? inode : ERR_PTR(error);
 }
 
-static void gfs2_inum_range_in(struct gfs2_inum_range_host *ir, const void *buf)
-{
-	const struct gfs2_inum_range *str = buf;
-
-	ir->ir_start = be64_to_cpu(str->ir_start);
-	ir->ir_length = be64_to_cpu(str->ir_length);
-}
-
-static void gfs2_inum_range_out(const struct gfs2_inum_range_host *ir, void *buf)
-{
-	struct gfs2_inum_range *str = buf;
-
-	str->ir_start = cpu_to_be64(ir->ir_start);
-	str->ir_length = cpu_to_be64(ir->ir_length);
-}
-
-static int pick_formal_ino_1(struct gfs2_sbd *sdp, u64 *formal_ino)
-{
-	struct gfs2_inode *ip = GFS2_I(sdp->sd_ir_inode);
-	struct buffer_head *bh;
-	struct gfs2_inum_range_host ir;
-	int error;
-
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		return error;
-	mutex_lock(&sdp->sd_inum_mutex);
-
-	error = gfs2_meta_inode_buffer(ip, &bh);
-	if (error) {
-		mutex_unlock(&sdp->sd_inum_mutex);
-		gfs2_trans_end(sdp);
-		return error;
-	}
-
-	gfs2_inum_range_in(&ir, bh->b_data + sizeof(struct gfs2_dinode));
-
-	if (ir.ir_length) {
-		*formal_ino = ir.ir_start++;
-		ir.ir_length--;
-		gfs2_trans_add_bh(ip->i_gl, bh, 1);
-		gfs2_inum_range_out(&ir,
-				    bh->b_data + sizeof(struct gfs2_dinode));
-		brelse(bh);
-		mutex_unlock(&sdp->sd_inum_mutex);
-		gfs2_trans_end(sdp);
-		return 0;
-	}
-
-	brelse(bh);
-
-	mutex_unlock(&sdp->sd_inum_mutex);
-	gfs2_trans_end(sdp);
-
-	return 1;
-}
-
-static int pick_formal_ino_2(struct gfs2_sbd *sdp, u64 *formal_ino)
-{
-	struct gfs2_inode *ip = GFS2_I(sdp->sd_ir_inode);
-	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_inum_inode);
-	struct gfs2_holder gh;
-	struct buffer_head *bh;
-	struct gfs2_inum_range_host ir;
-	int error;
-
-	error = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	if (error)
-		return error;
-
-	error = gfs2_trans_begin(sdp, 2 * RES_DINODE, 0);
-	if (error)
-		goto out;
-	mutex_lock(&sdp->sd_inum_mutex);
-
-	error = gfs2_meta_inode_buffer(ip, &bh);
-	if (error)
-		goto out_end_trans;
-
-	gfs2_inum_range_in(&ir, bh->b_data + sizeof(struct gfs2_dinode));
-
-	if (!ir.ir_length) {
-		struct buffer_head *m_bh;
-		u64 x, y;
-		__be64 z;
-
-		error = gfs2_meta_inode_buffer(m_ip, &m_bh);
-		if (error)
-			goto out_brelse;
-
-		z = *(__be64 *)(m_bh->b_data + sizeof(struct gfs2_dinode));
-		x = y = be64_to_cpu(z);
-		ir.ir_start = x;
-		ir.ir_length = GFS2_INUM_QUANTUM;
-		x += GFS2_INUM_QUANTUM;
-		if (x < y)
-			gfs2_consist_inode(m_ip);
-		z = cpu_to_be64(x);
-		gfs2_trans_add_bh(m_ip->i_gl, m_bh, 1);
-		*(__be64 *)(m_bh->b_data + sizeof(struct gfs2_dinode)) = z;
-
-		brelse(m_bh);
-	}
-
-	*formal_ino = ir.ir_start++;
-	ir.ir_length--;
-
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
-	gfs2_inum_range_out(&ir, bh->b_data + sizeof(struct gfs2_dinode));
-
-out_brelse:
-	brelse(bh);
-out_end_trans:
-	mutex_unlock(&sdp->sd_inum_mutex);
-	gfs2_trans_end(sdp);
-out:
-	gfs2_glock_dq_uninit(&gh);
-	return error;
-}
-
-static int pick_formal_ino(struct gfs2_sbd *sdp, u64 *inum)
-{
-	int error;
-
-	error = pick_formal_ino_1(sdp, inum);
-	if (error <= 0)
-		return error;
-
-	error = pick_formal_ino_2(sdp, inum);
-
-	return error;
-}
-
 /**
  * create_ok - OK to create a new on-disk inode here?
  * @dip:  Directory in which dinode is to be created
@@ -981,13 +848,10 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock;
 
-	error = pick_formal_ino(sdp, &inum.no_formal_ino);
-	if (error)
-		goto fail_gunlock;
-
 	error = alloc_dinode(dip, &inum.no_addr, &generation);
 	if (error)
 		goto fail_gunlock;
+	inum.no_formal_ino = generation;
 
 	error = gfs2_glock_nq_num(sdp, inum.no_addr, &gfs2_inode_glops,
 				  LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
@@ -998,9 +862,8 @@ struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 	if (error)
 		goto fail_gunlock2;
 
-	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode),
-					inum.no_addr,
-					inum.no_formal_ino, 0);
+	inode = gfs2_inode_lookup(dir->i_sb, IF2DT(mode), inum.no_addr,
+				  inum.no_formal_ino, 0);
 	if (IS_ERR(inode))
 		goto fail_gunlock2;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1ec69e6..8e3f00e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -84,7 +84,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	gfs2_tune_init(&sdp->sd_tune);
 
-	mutex_init(&sdp->sd_inum_mutex);
 	spin_lock_init(&sdp->sd_statfs_spin);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
@@ -833,21 +832,12 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 	if (error)
 		goto fail;
 
-	/* Read in the master inode number inode */
-	sdp->sd_inum_inode = gfs2_lookup_simple(master, "inum");
-	if (IS_ERR(sdp->sd_inum_inode)) {
-		error = PTR_ERR(sdp->sd_inum_inode);
-		fs_err(sdp, "can't read in inum inode: %d\n", error);
-		goto fail_journal;
-	}
-
-
 	/* Read in the master statfs inode */
 	sdp->sd_statfs_inode = gfs2_lookup_simple(master, "statfs");
 	if (IS_ERR(sdp->sd_statfs_inode)) {
 		error = PTR_ERR(sdp->sd_statfs_inode);
 		fs_err(sdp, "can't read in statfs inode: %d\n", error);
-		goto fail_inum;
+		goto fail_journal;
 	}
 
 	/* Read in the resource index inode */
@@ -876,8 +866,6 @@ fail_rindex:
 	iput(sdp->sd_rindex);
 fail_statfs:
 	iput(sdp->sd_statfs_inode);
-fail_inum:
-	iput(sdp->sd_inum_inode);
 fail_journal:
 	init_journal(sdp, UNDO);
 fail:
@@ -905,20 +893,12 @@ static int init_per_node(struct gfs2_sbd *sdp, int undo)
 		return error;
 	}
 
-	sprintf(buf, "inum_range%u", sdp->sd_jdesc->jd_jid);
-	sdp->sd_ir_inode = gfs2_lookup_simple(pn, buf);
-	if (IS_ERR(sdp->sd_ir_inode)) {
-		error = PTR_ERR(sdp->sd_ir_inode);
-		fs_err(sdp, "can't find local \"ir\" file: %d\n", error);
-		goto fail;
-	}
-
 	sprintf(buf, "statfs_change%u", sdp->sd_jdesc->jd_jid);
 	sdp->sd_sc_inode = gfs2_lookup_simple(pn, buf);
 	if (IS_ERR(sdp->sd_sc_inode)) {
 		error = PTR_ERR(sdp->sd_sc_inode);
 		fs_err(sdp, "can't find local \"sc\" file: %d\n", error);
-		goto fail_ir_i;
+		goto fail;
 	}
 
 	sprintf(buf, "quota_change%u", sdp->sd_jdesc->jd_jid);
@@ -932,27 +912,16 @@ static int init_per_node(struct gfs2_sbd *sdp, int undo)
 	iput(pn);
 	pn = NULL;
 
-	ip = GFS2_I(sdp->sd_ir_inode);
-	error = gfs2_glock_nq_init(ip->i_gl,
-				   LM_ST_EXCLUSIVE, 0,
-				   &sdp->sd_ir_gh);
-	if (error) {
-		fs_err(sdp, "can't lock local \"ir\" file: %d\n", error);
-		goto fail_qc_i;
-	}
-
 	ip = GFS2_I(sdp->sd_sc_inode);
-	error = gfs2_glock_nq_init(ip->i_gl,
-				   LM_ST_EXCLUSIVE, 0,
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0,
 				   &sdp->sd_sc_gh);
 	if (error) {
 		fs_err(sdp, "can't lock local \"sc\" file: %d\n", error);
-		goto fail_ir_gh;
+		goto fail_qc_i;
 	}
 
 	ip = GFS2_I(sdp->sd_qc_inode);
-	error = gfs2_glock_nq_init(ip->i_gl,
-				   LM_ST_EXCLUSIVE, 0,
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0,
 				   &sdp->sd_qc_gh);
 	if (error) {
 		fs_err(sdp, "can't lock local \"qc\" file: %d\n", error);
@@ -965,14 +934,10 @@ fail_qc_gh:
 	gfs2_glock_dq_uninit(&sdp->sd_qc_gh);
 fail_ut_gh:
 	gfs2_glock_dq_uninit(&sdp->sd_sc_gh);
-fail_ir_gh:
-	gfs2_glock_dq_uninit(&sdp->sd_ir_gh);
 fail_qc_i:
 	iput(sdp->sd_qc_inode);
 fail_ut_i:
 	iput(sdp->sd_sc_inode);
-fail_ir_i:
-	iput(sdp->sd_ir_inode);
 fail:
 	if (pn)
 		iput(pn);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c681c54..388a61d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1567,6 +1567,8 @@ int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
 	rgd->rd_free--;
 	rgd->rd_dinodes++;
 	*generation = rgd->rd_igeneration++;
+	if (*generation == 0)
+		*generation = rgd->rd_igeneration++;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2e78a3f..d95cf77 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -788,7 +788,6 @@ restart:
 	/*  Release stuff  */
 
 	iput(sdp->sd_jindex);
-	iput(sdp->sd_inum_inode);
 	iput(sdp->sd_statfs_inode);
 	iput(sdp->sd_rindex);
 	iput(sdp->sd_quota_inode);
@@ -799,10 +798,8 @@ restart:
 	if (!sdp->sd_args.ar_spectator) {
 		gfs2_glock_dq_uninit(&sdp->sd_journal_gh);
 		gfs2_glock_dq_uninit(&sdp->sd_jinode_gh);
-		gfs2_glock_dq_uninit(&sdp->sd_ir_gh);
 		gfs2_glock_dq_uninit(&sdp->sd_sc_gh);
 		gfs2_glock_dq_uninit(&sdp->sd_qc_gh);
-		iput(sdp->sd_ir_inode);
 		iput(sdp->sd_sc_inode);
 		iput(sdp->sd_qc_inode);
 	}
-- 
1.6.2.5

