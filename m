Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752336AbYLQMdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbYLQMdW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYLQM3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53741 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYLQM3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:18 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/24] GFS2: Banish struct gfs2_rgrpd_host
Date: Wed, 17 Dec 2008 11:30:11 +0000
Message-Id: <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
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
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch moves the final field so that we can get rid
of struct gfs2_rgrpd_host, as promised some time ago. Also
by rearranging the fields slightly, we are able to reduce
the size of the gfs2_rgrpd structure at the same time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f8d9773..9e3b613 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -68,10 +68,6 @@ struct gfs2_bitmap {
 	u32 bi_len;
 };
 
-struct gfs2_rgrp_host {
-	u32 rg_dinodes;
-};
-
 struct gfs2_rgrpd {
 	struct list_head rd_list;	/* Link with superblock */
 	struct list_head rd_list_mru;
@@ -82,15 +78,15 @@ struct gfs2_rgrpd {
 	u32 rd_data;			/* num of data blocks in rgrp */
 	u32 rd_bitbytes;		/* number of bytes in data bitmaps */
 	u32 rd_free;
-	struct gfs2_rgrp_host rd_rg;
+	u32 rd_free_clone;
+	u32 rd_dinodes;
 	u64 rd_igeneration;
 	struct gfs2_bitmap *rd_bits;
-	unsigned int rd_bh_count;
 	struct mutex rd_mutex;
-	u32 rd_free_clone;
 	struct gfs2_log_element rd_le;
-	u32 rd_last_alloc;
 	struct gfs2_sbd *rd_sbd;
+	unsigned int rd_bh_count;
+	u32 rd_last_alloc;
 	unsigned char rd_flags;
 #define GFS2_RDF_CHECK        0x01      /* Need to check for unlinked inodes */
 #define GFS2_RDF_NOALLOC      0x02      /* rg prohibits allocation */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bab9cfa..8b01c63 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -276,9 +276,7 @@ void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd)
 		return;
 	}
 
-	tmp = rgd->rd_data -
-		rgd->rd_free -
-		rgd->rd_rg.rg_dinodes;
+	tmp = rgd->rd_data - rgd->rd_free - rgd->rd_dinodes;
 	if (count[1] + count[2] != tmp) {
 		if (gfs2_consist_rgrpd(rgd))
 			fs_err(sdp, "used data mismatch:  %u != %u\n",
@@ -286,10 +284,10 @@ void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd)
 		return;
 	}
 
-	if (count[3] != rgd->rd_rg.rg_dinodes) {
+	if (count[3] != rgd->rd_dinodes) {
 		if (gfs2_consist_rgrpd(rgd))
 			fs_err(sdp, "used metadata mismatch:  %u != %u\n",
-			       count[3], rgd->rd_rg.rg_dinodes);
+			       count[3], rgd->rd_dinodes);
 		return;
 	}
 
@@ -692,7 +690,6 @@ int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh)
 static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 {
 	const struct gfs2_rgrp *str = buf;
-	struct gfs2_rgrp_host *rg = &rgd->rd_rg;
 	u32 rg_flags;
 
 	rg_flags = be32_to_cpu(str->rg_flags);
@@ -701,21 +698,20 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 	else
 		rgd->rd_flags &= ~GFS2_RDF_NOALLOC;
 	rgd->rd_free = be32_to_cpu(str->rg_free);
-	rg->rg_dinodes = be32_to_cpu(str->rg_dinodes);
+	rgd->rd_dinodes = be32_to_cpu(str->rg_dinodes);
 	rgd->rd_igeneration = be64_to_cpu(str->rg_igeneration);
 }
 
 static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 {
 	struct gfs2_rgrp *str = buf;
-	struct gfs2_rgrp_host *rg = &rgd->rd_rg;
 	u32 rg_flags = 0;
 
 	if (rgd->rd_flags & GFS2_RDF_NOALLOC)
 		rg_flags |= GFS2_RGF_NOALLOC;
 	str->rg_flags = cpu_to_be32(rg_flags);
 	str->rg_free = cpu_to_be32(rgd->rd_free);
-	str->rg_dinodes = cpu_to_be32(rg->rg_dinodes);
+	str->rg_dinodes = cpu_to_be32(rgd->rd_dinodes);
 	str->__pad = cpu_to_be32(0);
 	str->rg_igeneration = cpu_to_be64(rgd->rd_igeneration);
 	memset(&str->rg_reserved, 0, sizeof(str->rg_reserved));
@@ -1447,7 +1443,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 
 	gfs2_assert_withdraw(sdp, rgd->rd_free);
 	rgd->rd_free--;
-	rgd->rd_rg.rg_dinodes++;
+	rgd->rd_dinodes++;
 	*generation = rgd->rd_igeneration++;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
@@ -1546,9 +1542,9 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 		return;
 	gfs2_assert_withdraw(sdp, rgd == tmp_rgd);
 
-	if (!rgd->rd_rg.rg_dinodes)
+	if (!rgd->rd_dinodes)
 		gfs2_consist_rgrpd(rgd);
-	rgd->rd_rg.rg_dinodes--;
+	rgd->rd_dinodes--;
 	rgd->rd_free++;
 
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e769076..b858770 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -469,7 +469,7 @@ static int statfs_slow_fill(struct gfs2_rgrpd *rgd,
 	gfs2_rgrp_verify(rgd);
 	sc->sc_total += rgd->rd_data;
 	sc->sc_free += rgd->rd_free;
-	sc->sc_dinodes += rgd->rd_rg.rg_dinodes;
+	sc->sc_dinodes += rgd->rd_dinodes;
 	return 0;
 }
 
-- 
1.6.0.3

