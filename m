Return-Path: <linux-kernel-owner+w=401wt.eu-S1761731AbZAVR4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731AbZAVR4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbZAVRut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:50:49 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43216 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760093AbZAVRu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:50:29 -0500
Message-Id: <20090122175028.630392000@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 22 Jan 2009 11:49:26 -0600
From: steiner@sgi.com
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 09/14] ASID (context management) bug fixes
References: <20090122174917.563627000@sgi.com>
Content-Disposition: inline; filename=uv_gru_asid_fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

This patch fixes bugs related to ASID (context id) management
in the GRU driver.  These changes are all internal to the SGI
GRU driver and have no effect on the base kernel.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |    1 +
 drivers/misc/sgi-gru/grumain.c |   13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2009-01-15 08:18:06.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufile.c	2009-01-15 08:18:11.000000000 -0600
@@ -286,6 +286,7 @@ static void gru_init_chiplet(struct gru_
 	gru->gs_blade_id = bid;
 	gru->gs_cbr_map = (GRU_CBR_AU == 64) ? ~0 : (1UL << GRU_CBR_AU) - 1;
 	gru->gs_dsr_map = (1UL << GRU_DSR_AU) - 1;
+	gru->gs_asid_limit = MAX_ASID;
 	gru_tgh_flush_init(gru);
 	gru_dbg(grudev, "bid %d, nid %d, gid %d, vaddr %p (0x%lx)\n",
 		bid, nid, gru->gs_gid, gru->gs_gru_base_vaddr,
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-01-15 08:18:06.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-01-15 08:18:11.000000000 -0600
@@ -79,7 +79,6 @@ static int gru_wrap_asid(struct gru_stat
 	gru_dbg(grudev, "gid %d\n", gru->gs_gid);
 	STAT(asid_wrap);
 	gru->gs_asid_gen++;
-	gru_flush_all_tlb(gru);
 	return MIN_ASID;
 }
 
@@ -93,6 +92,7 @@ static int gru_reset_asid_limit(struct g
 	limit = MAX_ASID;
 	if (asid >= limit)
 		asid = gru_wrap_asid(gru);
+	gru_flush_all_tlb(gru);
 	gid = gru->gs_gid;
 again:
 	for (i = 0; i < GRU_NUM_CCH; i++) {
@@ -131,12 +131,10 @@ static int gru_assign_asid(struct gru_st
 {
 	int asid;
 
-	spin_lock(&gru->gs_asid_lock);
 	gru->gs_asid += ASID_INC;
 	asid = gru->gs_asid;
 	if (asid >= gru->gs_asid_limit)
 		asid = gru_reset_asid_limit(gru, asid);
-	spin_unlock(&gru->gs_asid_lock);
 
 	gru_dbg(grudev, "gid %d, asid 0x%x\n", gru->gs_gid, asid);
 	return asid;
@@ -227,7 +225,9 @@ static int gru_load_mm_tracker(struct gr
 	spin_lock(&gms->ms_asid_lock);
 	asid = asids->mt_asid;
 
-	if (asid == 0 || asids->mt_asid_gen != gru->gs_asid_gen) {
+	spin_lock(&gru->gs_asid_lock);
+	if (asid == 0 || (asids->mt_ctxbitmap == 0 && asids->mt_asid_gen !=
+			  gru->gs_asid_gen)) {
 		asid = gru_assign_asid(gru);
 		asids->mt_asid = asid;
 		asids->mt_asid_gen = gru->gs_asid_gen;
@@ -235,6 +235,7 @@ static int gru_load_mm_tracker(struct gr
 	} else {
 		STAT(asid_reuse);
 	}
+	spin_unlock(&gru->gs_asid_lock);
 
 	BUG_ON(asids->mt_ctxbitmap & ctxbitmap);
 	asids->mt_ctxbitmap |= ctxbitmap;
@@ -259,10 +260,12 @@ static void gru_unload_mm_tracker(struct
 	asids = &gms->ms_asids[gru->gs_gid];
 	ctxbitmap = (1 << gts->ts_ctxnum);
 	spin_lock(&gms->ms_asid_lock);
+	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
 	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
+	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
 }
 
@@ -412,6 +415,7 @@ static void gru_free_gru_context(struct 
 	__clear_bit(gts->ts_ctxnum, &gru->gs_context_map);
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_gru = NULL;
+	gts->ts_blade = -1;
 	spin_unlock(&gru->gs_lock);
 
 	gts_drop(gts);
@@ -731,6 +735,7 @@ again:
 		}
 		reserve_gru_resources(gru, gts);
 		gts->ts_gru = gru;
+		gts->ts_blade = gru->gs_blade_id;
 		gts->ts_ctxnum =
 		    find_first_zero_bit(&gru->gs_context_map, GRU_NUM_CCH);
 		BUG_ON(gts->ts_ctxnum == GRU_NUM_CCH);

