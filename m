Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZG3Mrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZG3Mrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZG3Mrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:47:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46423 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZG3Mqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/7] GFS2: keep statfs info in sync on grows
Date: Thu, 30 Jul 2009 14:45:19 +0100
Message-Id: <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 wasn't syncing its statfs info on grows.  This causes a problem
when you grow the filesystem on multiple nodes.  GFS2 would calculate
the new space based on the resource groups (which are always current),
and then assume that the filesystem had grown the from the existing
statfs size.  If you grew the filesystem on two different nodes in a
short time, the second node wouldn't see the statfs size change from the
first node, and would assume that it was grown by a larger amount than
it was.  When all these changes were synced out, the total fileystem
size would be incorrect (the first grow would be counted twice).

This patch syncs makes GFS2 read in the statfs changes from disk before
a grow, and write them out after the grow, while the master statfs inode
is locked.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/aops.c  |   39 +++++++++++++++++++++++++++++++++++++++
 fs/gfs2/super.c |   39 +++++++++++++++++++++++++--------------
 fs/gfs2/super.h |    4 ++++
 3 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 03ebb43..7ebae9a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -624,6 +624,7 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 {
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
 	int alloc_required;
 	int error = 0;
@@ -637,6 +638,14 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 	error = gfs2_glock_nq(&ip->i_gh);
 	if (unlikely(error))
 		goto out_uninit;
+	if (&ip->i_inode == sdp->sd_rindex) {
+		error = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
+					   GL_NOCACHE, &m_ip->i_gh);
+		if (unlikely(error)) {
+			gfs2_glock_dq(&ip->i_gh);
+			goto out_uninit;
+		}
+	}
 
 	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
 	if (error)
@@ -667,6 +676,8 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 		rblocks += data_blocks ? data_blocks : 1;
 	if (ind_blocks || data_blocks)
 		rblocks += RES_STATFS + RES_QUOTA;
+	if (&ip->i_inode == sdp->sd_rindex)
+		rblocks += 2 * RES_STATFS;
 
 	error = gfs2_trans_begin(sdp, rblocks,
 				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
@@ -712,6 +723,10 @@ out_alloc_put:
 		gfs2_alloc_put(ip);
 	}
 out_unlock:
+	if (&ip->i_inode == sdp->sd_rindex) {
+		gfs2_glock_dq(&m_ip->i_gh);
+		gfs2_holder_uninit(&m_ip->i_gh);
+	}
 	gfs2_glock_dq(&ip->i_gh);
 out_uninit:
 	gfs2_holder_uninit(&ip->i_gh);
@@ -725,14 +740,21 @@ out_uninit:
 static void adjust_fs_space(struct inode *inode)
 {
 	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+	struct gfs2_inode *l_ip = GFS2_I(sdp->sd_sc_inode);
 	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
 	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
+	struct buffer_head *m_bh, *l_bh;
 	u64 fs_total, new_free;
 
 	/* Total up the file system space, according to the latest rindex. */
 	fs_total = gfs2_ri_total(sdp);
+	if (gfs2_meta_inode_buffer(m_ip, &m_bh) != 0)
+		return;
 
 	spin_lock(&sdp->sd_statfs_spin);
+	gfs2_statfs_change_in(m_sc, m_bh->b_data +
+			      sizeof(struct gfs2_dinode));
 	if (fs_total > (m_sc->sc_total + l_sc->sc_total))
 		new_free = fs_total - (m_sc->sc_total + l_sc->sc_total);
 	else
@@ -741,6 +763,13 @@ static void adjust_fs_space(struct inode *inode)
 	fs_warn(sdp, "File system extended by %llu blocks.\n",
 		(unsigned long long)new_free);
 	gfs2_statfs_change(sdp, new_free, new_free, 0);
+
+	if (gfs2_meta_inode_buffer(l_ip, &l_bh) != 0)
+		goto out;
+	update_statfs(sdp, m_bh, l_bh);
+	brelse(l_bh);
+out:
+	brelse(m_bh);
 }
 
 /**
@@ -763,6 +792,7 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	u64 to = pos + copied;
 	void *kaddr;
 	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
@@ -794,6 +824,10 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 
 	brelse(dibh);
 	gfs2_trans_end(sdp);
+	if (inode == sdp->sd_rindex) {
+		gfs2_glock_dq(&m_ip->i_gh);
+		gfs2_holder_uninit(&m_ip->i_gh);
+	}
 	gfs2_glock_dq(&ip->i_gh);
 	gfs2_holder_uninit(&ip->i_gh);
 	return copied;
@@ -823,6 +857,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
 	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
@@ -865,6 +900,10 @@ failed:
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
+	if (inode == sdp->sd_rindex) {
+		gfs2_glock_dq(&m_ip->i_gh);
+		gfs2_holder_uninit(&m_ip->i_gh);
+	}
 	gfs2_glock_dq(&ip->i_gh);
 	gfs2_holder_uninit(&ip->i_gh);
 	return ret;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 0a68013..552e321 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -353,7 +353,7 @@ fail:
 	return error;
 }
 
-static void gfs2_statfs_change_in(struct gfs2_statfs_change_host *sc, const void *buf)
+void gfs2_statfs_change_in(struct gfs2_statfs_change_host *sc, const void *buf)
 {
 	const struct gfs2_statfs_change *str = buf;
 
@@ -441,6 +441,29 @@ void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 	brelse(l_bh);
 }
 
+void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
+		   struct buffer_head *l_bh)
+{
+	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+	struct gfs2_inode *l_ip = GFS2_I(sdp->sd_sc_inode);
+	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
+	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
+
+	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
+
+	spin_lock(&sdp->sd_statfs_spin);
+	m_sc->sc_total += l_sc->sc_total;
+	m_sc->sc_free += l_sc->sc_free;
+	m_sc->sc_dinodes += l_sc->sc_dinodes;
+	memset(l_sc, 0, sizeof(struct gfs2_statfs_change));
+	memset(l_bh->b_data + sizeof(struct gfs2_dinode),
+	       0, sizeof(struct gfs2_statfs_change));
+	spin_unlock(&sdp->sd_statfs_spin);
+
+	gfs2_trans_add_bh(m_ip->i_gl, m_bh, 1);
+	gfs2_statfs_change_out(m_sc, m_bh->b_data + sizeof(struct gfs2_dinode));
+}
+
 int gfs2_statfs_sync(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
@@ -477,19 +500,7 @@ int gfs2_statfs_sync(struct gfs2_sbd *sdp)
 	if (error)
 		goto out_bh2;
 
-	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
-
-	spin_lock(&sdp->sd_statfs_spin);
-	m_sc->sc_total += l_sc->sc_total;
-	m_sc->sc_free += l_sc->sc_free;
-	m_sc->sc_dinodes += l_sc->sc_dinodes;
-	memset(l_sc, 0, sizeof(struct gfs2_statfs_change));
-	memset(l_bh->b_data + sizeof(struct gfs2_dinode),
-	       0, sizeof(struct gfs2_statfs_change));
-	spin_unlock(&sdp->sd_statfs_spin);
-
-	gfs2_trans_add_bh(m_ip->i_gl, m_bh, 1);
-	gfs2_statfs_change_out(m_sc, m_bh->b_data + sizeof(struct gfs2_dinode));
+	update_statfs(sdp, m_bh, l_bh);
 
 	gfs2_trans_end(sdp);
 
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index b56413e..22e0417 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -40,6 +40,10 @@ extern int gfs2_make_fs_rw(struct gfs2_sbd *sdp);
 extern int gfs2_statfs_init(struct gfs2_sbd *sdp);
 extern void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 			       s64 dinodes);
+extern void gfs2_statfs_change_in(struct gfs2_statfs_change_host *sc,
+				  const void *buf);
+extern void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
+			  struct buffer_head *l_bh);
 extern int gfs2_statfs_sync(struct gfs2_sbd *sdp);
 
 extern int gfs2_freeze_fs(struct gfs2_sbd *sdp);
-- 
1.6.2.2

