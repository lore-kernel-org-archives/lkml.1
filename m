Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDFQLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDFQLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDFQKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:17 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41537 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbZDFQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:14 -0400
Message-Id: <20090406161012.313662000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:13 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 04/13] GRU - change context load and unload
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_load_unload_context
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Remove "static" from the functions for loading/unloading
GRU contexts. These functions will be called from other
GRU files. Fix bug in unlocking gru context.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c  |    4 ++--
 drivers/misc/sgi-gru/grumain.c   |   10 +++++-----
 drivers/misc/sgi-gru/grutables.h |    4 ++++
 3 files changed, 11 insertions(+), 7 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:12:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:13:01.000000000 -0500
@@ -558,8 +558,8 @@ int gru_handle_user_call_os(unsigned lon
 	 * CCH may contain stale data if ts_force_cch_reload is set.
 	 */
 	if (gts->ts_gru && gts->ts_force_cch_reload) {
-		gru_update_cch(gts, 0);
 		gts->ts_force_cch_reload = 0;
+		gru_update_cch(gts, 0);
 	}
 
 	ret = -EAGAIN;
@@ -644,7 +644,7 @@ static int gru_unload_all_contexts(void)
 			if (gts && mutex_trylock(&gts->ts_ctxlock)) {
 				spin_unlock(&gru->gs_lock);
 				gru_unload_context(gts, 1);
-				gru_unlock_gts(gts);
+				mutex_unlock(&gts->ts_ctxlock);
 				spin_lock(&gru->gs_lock);
 			}
 		}
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-04-06 09:13:01.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-04-06 09:13:01.000000000 -0500
@@ -533,7 +533,7 @@ void gru_unload_context(struct gru_threa
  * Load a GRU context by copying it from the thread data structure in memory
  * to the GRU.
  */
-static void gru_load_context(struct gru_thread_state *gts)
+void gru_load_context(struct gru_thread_state *gts)
 {
 	struct gru_state *gru = gts->ts_gru;
 	struct gru_context_configuration_handle *cch;
@@ -600,8 +600,8 @@ int gru_update_cch(struct gru_thread_sta
 			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 			cch->tlb_int_select = gru_cpu_fault_map_id();
 			cch->tfm_fault_bit_enable =
-	    		    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
-	     		    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
+				(gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+				|| gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
@@ -645,7 +645,7 @@ static int gru_retarget_intr(struct gru_
 #define next_gru(b, g)	(((g) < &(b)->bs_grus[GRU_CHIPLETS_PER_BLADE - 1]) ?  \
 				 ((g)+1) : &(b)->bs_grus[0])
 
-static void gru_steal_context(struct gru_thread_state *gts, int blade_id)
+void gru_steal_context(struct gru_thread_state *gts, int blade_id)
 {
 	struct gru_blade_state *blade;
 	struct gru_state *gru, *gru0;
@@ -711,7 +711,7 @@ static void gru_steal_context(struct gru
 /*
  * Scan the GRUs on the local blade & assign a GRU context.
  */
-static struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
+struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
 						int blade)
 {
 	struct gru_state *gru, *grux;
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-06 09:13:01.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-06 09:13:01.000000000 -0500
@@ -611,6 +611,10 @@ extern struct gru_thread_state *gru_find
 				*vma, int tsid);
 extern struct gru_thread_state *gru_alloc_thread_state(struct vm_area_struct
 				*vma, int tsid);
+extern struct gru_state *gru_assign_gru_context(struct gru_thread_state *gts,
+		int blade);
+extern void gru_load_context(struct gru_thread_state *gts);
+extern void gru_steal_context(struct gru_thread_state *gts, int blade_id);
 extern void gru_unload_context(struct gru_thread_state *gts, int savestate);
 extern int gru_update_cch(struct gru_thread_state *gts, int force_unload);
 extern void gts_drop(struct gru_thread_state *gts);

