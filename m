Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbYDQJiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbYDQJiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbYDQJZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbYDQJZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:37 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/48] [GFS2] Combine rg_flags and rd_flags
Date: Thu, 17 Apr 2008 09:38:47 +0100
Message-Id: <12084215913125-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215891940-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch reduces the memory required by GFS2 by combining
the rd_flags and rg_flags (in core only).

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 7ae12d2..39bab7b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -69,7 +69,6 @@ struct gfs2_bitmap {
 };
 
 struct gfs2_rgrp_host {
-	u32 rg_flags;
 	u32 rg_free;
 	u32 rg_dinodes;
 	u64 rg_igeneration;
@@ -95,8 +94,9 @@ struct gfs2_rgrpd {
 	u32 rd_last_alloc_data;
 	u32 rd_last_alloc_meta;
 	struct gfs2_sbd *rd_sbd;
-	unsigned long rd_flags;
-#define GFS2_RDF_CHECK        0x0001          /* Need to check for unlinked inodes */
+	unsigned char rd_flags;
+#define GFS2_RDF_CHECK        0x01      /* Need to check for unlinked inodes */
+#define GFS2_RDF_NOALLOC      0x02      /* rg prohibits allocation */
 };
 
 enum gfs2_state_bits {
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index dc7e83e..da60ce8 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -655,21 +655,31 @@ int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh)
 	return error;
 }
 
-static void gfs2_rgrp_in(struct gfs2_rgrp_host *rg, const void *buf)
+static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 {
 	const struct gfs2_rgrp *str = buf;
+	struct gfs2_rgrp_host *rg = &rgd->rd_rg;
+	u32 rg_flags;
 
-	rg->rg_flags = be32_to_cpu(str->rg_flags);
+	rg_flags = be32_to_cpu(str->rg_flags);
+	if (rg_flags & GFS2_RGF_NOALLOC)
+		rgd->rd_flags |= GFS2_RDF_NOALLOC;
+	else
+		rgd->rd_flags &= ~GFS2_RDF_NOALLOC;
 	rg->rg_free = be32_to_cpu(str->rg_free);
 	rg->rg_dinodes = be32_to_cpu(str->rg_dinodes);
 	rg->rg_igeneration = be64_to_cpu(str->rg_igeneration);
 }
 
-static void gfs2_rgrp_out(const struct gfs2_rgrp_host *rg, void *buf)
+static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 {
 	struct gfs2_rgrp *str = buf;
+	struct gfs2_rgrp_host *rg = &rgd->rd_rg;
+	u32 rg_flags = 0;
 
-	str->rg_flags = cpu_to_be32(rg->rg_flags);
+	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
+		rg_flags |= GFS2_RGF_NOALLOC;
+	str->rg_flags = cpu_to_be32(rg_flags);
 	str->rg_free = cpu_to_be32(rg->rg_free);
 	str->rg_dinodes = cpu_to_be32(rg->rg_dinodes);
 	str->__pad = cpu_to_be32(0);
@@ -727,7 +737,7 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 	}
 
 	if (rgd->rd_rg_vn != gl->gl_vn) {
-		gfs2_rgrp_in(&rgd->rd_rg, (rgd->rd_bits[0].bi_bh)->b_data);
+		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
 		rgd->rd_rg_vn = gl->gl_vn;
 	}
 
@@ -840,7 +850,7 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	int ret = 0;
 
-	if (rgd->rd_rg.rg_flags & GFS2_RGF_NOALLOC)
+	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
 		return 0;
 
 	spin_lock(&sdp->sd_rindex_spin);
@@ -1431,7 +1441,7 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 	rgd->rd_rg.rg_free--;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	al->al_alloced++;
 
@@ -1476,7 +1486,7 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 	rgd->rd_rg.rg_free--;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	al->al_alloced++;
 
@@ -1519,7 +1529,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	rgd->rd_rg.rg_dinodes++;
 	*generation = rgd->rd_rg.rg_igeneration++;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	al->al_alloced++;
 
@@ -1553,7 +1563,7 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd->rd_rg.rg_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_trans_add_rg(rgd);
 
@@ -1581,7 +1591,7 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	rgd->rd_rg.rg_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_trans_add_rg(rgd);
 
@@ -1601,7 +1611,7 @@ void gfs2_unlink_di(struct inode *inode)
 	if (!rgd)
 		return;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_trans_add_rg(rgd);
 }
 
@@ -1621,7 +1631,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 	rgd->rd_rg.rg_free++;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(&rgd->rd_rg, rgd->rd_bits[0].bi_bh->b_data);
+	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_statfs_change(sdp, 0, +1, -1);
 	gfs2_trans_add_rg(rgd);
-- 
1.5.1.2

