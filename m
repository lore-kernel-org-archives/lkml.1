Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZDFQNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZDFQNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZDFQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59743 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752638AbZDFQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:16 -0400
Message-Id: <20090406161014.467898000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:18 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 09/13] GRU - check context state on reload
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_gts_data_valid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Check whether the gru state being loaded into a gru is from a
new context or a previously unloaded context. If new, simply zero
out the hardware context; if unloaded and valid, reload the old state.

This change is primarily for reloading kernel contexts where the
previous is not required to be saved.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grumain.c   |   32 +++++++++++++++++++++++---------
 drivers/misc/sgi-gru/grutables.h |    2 ++
 2 files changed, 25 insertions(+), 9 deletions(-)

Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-03-11 10:35:48.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-03-11 10:36:09.000000000 -0500
@@ -307,11 +307,12 @@ struct gru_thread_state *gru_alloc_gts(s
 
 	bytes = DSR_BYTES(dsr_au_count) + CBR_BYTES(cbr_au_count);
 	bytes += sizeof(struct gru_thread_state);
-	gts = kzalloc(bytes, GFP_KERNEL);
+	gts = kmalloc(bytes, GFP_KERNEL);
 	if (!gts)
 		return NULL;
 
 	STAT(gts_alloc);
+	memset(gts, 0, sizeof(struct gru_thread_state)); /* zero out header */
 	atomic_set(&gts->ts_refcnt, 1);
 	mutex_init(&gts->ts_ctxlock);
 	gts->ts_cbr_au_count = cbr_au_count;
@@ -458,7 +459,8 @@ static void gru_prefetch_context(void *g
 }
 
 static void gru_load_context_data(void *save, void *grubase, int ctxnum,
-				  unsigned long cbrmap, unsigned long dsrmap)
+				  unsigned long cbrmap, unsigned long dsrmap,
+				  int data_valid)
 {
 	void *gseg, *cb, *cbe;
 	unsigned long length;
@@ -471,12 +473,22 @@ static void gru_load_context_data(void *
 	gru_prefetch_context(gseg, cb, cbe, cbrmap, length);
 
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {
-		save += gru_copy_handle(cb, save);
-		save += gru_copy_handle(cbe + i * GRU_HANDLE_STRIDE, save);
+		if (data_valid) {
+			save += gru_copy_handle(cb, save);
+			save += gru_copy_handle(cbe + i * GRU_HANDLE_STRIDE,
+						save);
+		} else {
+			memset(cb, 0, GRU_CACHE_LINE_BYTES);
+			memset(cbe + i * GRU_HANDLE_STRIDE, 0,
+						GRU_CACHE_LINE_BYTES);
+		}
 		cb += GRU_HANDLE_STRIDE;
 	}
 
-	memcpy(gseg + GRU_DS_BASE, save, length);
+	if (data_valid)
+		memcpy(gseg + GRU_DS_BASE, save, length);
+	else
+		memset(gseg + GRU_DS_BASE, 0, length);
 }
 
 static void gru_unload_context_data(void *save, void *grubase, int ctxnum,
@@ -517,10 +529,12 @@ void gru_unload_context(struct gru_threa
 
 	if (!is_kernel_context(gts))
 		gru_unload_mm_tracker(gru, gts);
-	if (savestate)
+	if (savestate) {
 		gru_unload_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr,
 					ctxnum, gts->ts_cbr_map,
 					gts->ts_dsr_map);
+		gts->ts_data_valid = 1;
+	}
 
 	if (cch_deallocate(cch))
 		BUG();
@@ -576,7 +590,7 @@ void gru_load_context(struct gru_thread_
 	}
 
 	gru_load_context_data(gts->ts_gdata, gru->gs_gru_base_vaddr, ctxnum,
-			      gts->ts_cbr_map, gts->ts_dsr_map);
+			gts->ts_cbr_map, gts->ts_dsr_map, gts->ts_data_valid);
 
 	if (cch_start(cch))
 		BUG();
@@ -611,8 +625,8 @@ int gru_update_cch(struct gru_thread_sta
 			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 			cch->tlb_int_select = gru_cpu_fault_map_id();
 			cch->tfm_fault_bit_enable =
-				(gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-				|| gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
+			  (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+			    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-03-11 10:35:36.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-03-11 10:36:09.000000000 -0500
@@ -385,6 +385,8 @@ struct gru_thread_state {
 						   after migration */
 	char			ts_cbr_idx[GRU_CBR_AU];/* CBR numbers of each
 							  allocated CB */
+	int			ts_data_valid;	/* Indicates if ts_gdata has
+						   valid data */
 	unsigned long		ts_gdata[0];	/* save area for GRU data (CB,
 						   DS, CBE) */
 };

