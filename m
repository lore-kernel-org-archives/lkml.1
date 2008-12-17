Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760345AbYLQMc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYLQMc7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYLQM3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYLQM3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:17 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/24] GFS2: Move rg_free from gfs2_rgrpd_host to gfs2_rgrpd
Date: Wed, 17 Dec 2008 11:30:10 +0000
Message-Id: <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The second of three fields which need to move, in order
to remove the struct gfs2_rgrpd_host.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 869ac83..f8d9773 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -69,7 +69,6 @@ struct gfs2_bitmap {
 };
 
 struct gfs2_rgrp_host {
-	u32 rg_free;
 	u32 rg_dinodes;
 };
 
@@ -82,6 +81,7 @@ struct gfs2_rgrpd {
 	u32 rd_length;			/* length of rgrp header in fs blocks */
 	u32 rd_data;			/* num of data blocks in rgrp */
 	u32 rd_bitbytes;		/* number of bytes in data bitmaps */
+	u32 rd_free;
 	struct gfs2_rgrp_host rd_rg;
 	u64 rd_igeneration;
 	struct gfs2_bitmap *rd_bits;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8e93d62..bab9cfa 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -269,15 +269,15 @@ void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd)
 						  bi->bi_len, x);
 	}
 
-	if (count[0] != rgd->rd_rg.rg_free) {
+	if (count[0] != rgd->rd_free) {
 		if (gfs2_consist_rgrpd(rgd))
 			fs_err(sdp, "free data mismatch:  %u != %u\n",
-			       count[0], rgd->rd_rg.rg_free);
+			       count[0], rgd->rd_free);
 		return;
 	}
 
 	tmp = rgd->rd_data -
-		rgd->rd_rg.rg_free -
+		rgd->rd_free -
 		rgd->rd_rg.rg_dinodes;
 	if (count[1] + count[2] != tmp) {
 		if (gfs2_consist_rgrpd(rgd))
@@ -700,7 +700,7 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 		rgd->rd_flags |= GFS2_RDF_NOALLOC;
 	else
 		rgd->rd_flags &= ~GFS2_RDF_NOALLOC;
-	rg->rg_free = be32_to_cpu(str->rg_free);
+	rgd->rd_free = be32_to_cpu(str->rg_free);
 	rg->rg_dinodes = be32_to_cpu(str->rg_dinodes);
 	rgd->rd_igeneration = be64_to_cpu(str->rg_igeneration);
 }
@@ -714,7 +714,7 @@ static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
 		rg_flags |= GFS2_RGF_NOALLOC;
 	str->rg_flags = cpu_to_be32(rg_flags);
-	str->rg_free = cpu_to_be32(rg->rg_free);
+	str->rg_free = cpu_to_be32(rgd->rd_free);
 	str->rg_dinodes = cpu_to_be32(rg->rg_dinodes);
 	str->__pad = cpu_to_be32(0);
 	str->rg_igeneration = cpu_to_be64(rgd->rd_igeneration);
@@ -776,7 +776,7 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 	}
 
 	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone = rgd->rd_rg.rg_free;
+	rgd->rd_free_clone = rgd->rd_free;
 	rgd->rd_bh_count++;
 	spin_unlock(&sdp->sd_rindex_spin);
 
@@ -850,7 +850,7 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 	}
 
 	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone = rgd->rd_rg.rg_free;
+	rgd->rd_free_clone = rgd->rd_free;
 	spin_unlock(&sdp->sd_rindex_spin);
 }
 
@@ -1403,8 +1403,8 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 	block = rgd->rd_data0 + blk;
 	ip->i_goal = block;
 
-	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free >= *n);
-	rgd->rd_rg.rg_free -= *n;
+	gfs2_assert_withdraw(sdp, rgd->rd_free >= *n);
+	rgd->rd_free -= *n;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
@@ -1445,8 +1445,8 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 
 	block = rgd->rd_data0 + blk;
 
-	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
-	rgd->rd_rg.rg_free--;
+	gfs2_assert_withdraw(sdp, rgd->rd_free);
+	rgd->rd_free--;
 	rgd->rd_rg.rg_dinodes++;
 	*generation = rgd->rd_igeneration++;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
@@ -1481,7 +1481,7 @@ void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	if (!rgd)
 		return;
 
-	rgd->rd_rg.rg_free += blen;
+	rgd->rd_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
@@ -1509,7 +1509,7 @@ void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	if (!rgd)
 		return;
 
-	rgd->rd_rg.rg_free += blen;
+	rgd->rd_free += blen;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
@@ -1549,7 +1549,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 	if (!rgd->rd_rg.rg_dinodes)
 		gfs2_consist_rgrpd(rgd);
 	rgd->rd_rg.rg_dinodes--;
-	rgd->rd_rg.rg_free++;
+	rgd->rd_free++;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f5cef2a..e769076 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -468,7 +468,7 @@ static int statfs_slow_fill(struct gfs2_rgrpd *rgd,
 {
 	gfs2_rgrp_verify(rgd);
 	sc->sc_total += rgd->rd_data;
-	sc->sc_free += rgd->rd_rg.rg_free;
+	sc->sc_free += rgd->rd_free;
 	sc->sc_dinodes += rgd->rd_rg.rg_dinodes;
 	return 0;
 }
-- 
1.6.0.3

