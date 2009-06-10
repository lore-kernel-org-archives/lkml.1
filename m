Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZFJJl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZFJJl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbZFJJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149AbZFJJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/24] GFS2: Be more aggressive in reclaiming unlinked inodes
Date: Wed, 10 Jun 2009 09:30:54 +0100
Message-Id: <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases the frequency with which gfs2 looks
for unlinked, but still allocated inodes. Its the equivalent
operation to ext3's orphan list, but done with bitmaps in
the resource groups.

This also fixes a bug where a field in the rgrp was too small.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index dd87379..225347f 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -94,7 +94,7 @@ struct gfs2_rgrpd {
 	struct gfs2_sbd *rd_sbd;
 	unsigned int rd_bh_count;
 	u32 rd_last_alloc;
-	unsigned char rd_flags;
+	u32 rd_flags;
 #define GFS2_RDF_CHECK		0x10000000 /* check for unlinked inodes */
 #define GFS2_RDF_UPTODATE	0x20000000 /* rg is up to date */
 #define GFS2_RDF_ERROR		0x40000000 /* error in rg */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 23637b9..ee3d5c1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -581,7 +581,6 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 
 	rgd->rd_gl->gl_object = rgd;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
-	rgd->rd_flags |= GFS2_RDF_CHECK;
 	return error;
 }
 
@@ -703,6 +702,8 @@ static void gfs2_rgrp_in(struct gfs2_rgrpd *rgd, const void *buf)
 
 	rg_flags = be32_to_cpu(str->rg_flags);
 	rg_flags &= ~GFS2_RDF_MASK;
+	rgd->rd_flags &= GFS2_RDF_MASK;
+	rgd->rd_flags |= rg_flags;
 	rgd->rd_free = be32_to_cpu(str->rg_free);
 	rgd->rd_dinodes = be32_to_cpu(str->rg_dinodes);
 	rgd->rd_igeneration = be64_to_cpu(str->rg_igeneration);
@@ -773,7 +774,7 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 		for (x = 0; x < length; x++)
 			clear_bit(GBF_FULL, &rgd->rd_bits[x].bi_flags);
 		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
-		rgd->rd_flags |= GFS2_RDF_UPTODATE;
+		rgd->rd_flags |= (GFS2_RDF_UPTODATE | GFS2_RDF_CHECK);
 	}
 
 	spin_lock(&sdp->sd_rindex_spin);
-- 
1.6.0.6

