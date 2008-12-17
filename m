Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759527AbYLQMck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYLQMck (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYLQM3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53738 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYLQM3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:16 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/24] GFS2: Move rg_igeneration into struct gfs2_rgrpd
Date: Wed, 17 Dec 2008 11:30:09 +0000
Message-Id: <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This moves one of the fields of struct gfs2_rgrpd_host into
the struct gfs2_rgrpd with the eventual aim of removing
the struct rgrpd_host completely.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 6f67e75..869ac83 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -71,7 +71,6 @@ struct gfs2_bitmap {
 struct gfs2_rgrp_host {
 	u32 rg_free;
 	u32 rg_dinodes;
-	u64 rg_igeneration;
 };
 
 struct gfs2_rgrpd {
@@ -84,6 +83,7 @@ struct gfs2_rgrpd {
 	u32 rd_data;			/* num of data blocks in rgrp */
 	u32 rd_bitbytes;		/* number of bytes in data bitmaps */
 	struct gfs2_rgrp_host rd_rg;
+	u64 rd_igeneration;
 	struct gfs2_bitmap *rd_bits;
 	unsigned int rd_bh_count;
 	struct mutex rd_mutex;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bdad0df..8e93d62 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -702,7 +702,7 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 		rgd->rd_flags &= ~GFS2_RDF_NOALLOC;
 	rg->rg_free = be32_to_cpu(str->rg_free);
 	rg->rg_dinodes = be32_to_cpu(str->rg_dinodes);
-	rg->rg_igeneration = be64_to_cpu(str->rg_igeneration);
+	rgd->rd_igeneration = be64_to_cpu(str->rg_igeneration);
 }
 
 static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
@@ -717,7 +717,7 @@ static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 	str->rg_free = cpu_to_be32(rg->rg_free);
 	str->rg_dinodes = cpu_to_be32(rg->rg_dinodes);
 	str->__pad = cpu_to_be32(0);
-	str->rg_igeneration = cpu_to_be64(rg->rg_igeneration);
+	str->rg_igeneration = cpu_to_be64(rgd->rd_igeneration);
 	memset(&str->rg_reserved, 0, sizeof(str->rg_reserved));
 }
 
@@ -1448,7 +1448,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
 	rgd->rd_rg.rg_free--;
 	rgd->rd_rg.rg_dinodes++;
-	*generation = rgd->rd_rg.rg_igeneration++;
+	*generation = rgd->rd_igeneration++;
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-- 
1.6.0.3

