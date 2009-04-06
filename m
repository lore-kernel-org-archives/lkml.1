Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZDFQL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZDFQL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZDFQKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59738 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbZDFQKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:15 -0400
Message-Id: <20090406161012.733698000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:14 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 05/13] GRU - support cch_allocate for kernel threads
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_cch_allocate
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Change the interface to cch_allocate so that it can be used
to allocate GRU contexts for kernel threads. Kernel threads
use the GRU in unmapped mode and do not require ASIDs for the
GRU TLB.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.c   |   14 ++------------
 drivers/misc/sgi-gru/gruhandles.h   |    4 +---
 drivers/misc/sgi-gru/grukservices.c |    5 ++++-
 drivers/misc/sgi-gru/grumain.c      |   15 +++++++++++----
 4 files changed, 18 insertions(+), 20 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2009-02-21 22:30:51.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2009-02-21 22:36:47.000000000 -0600
@@ -72,18 +72,8 @@ static int wait_instruction_complete(voi
 	return status;
 }
 
-int cch_allocate(struct gru_context_configuration_handle *cch,
-		int asidval, int sizeavail, unsigned long cbrmap,
-		unsigned long dsrmap)
-{
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = (asidval++);
-		cch->sizeavail[i] = sizeavail;
-	}
-	cch->dsr_allocation_map = dsrmap;
-	cch->cbr_allocation_map = cbrmap;
+int cch_allocate(struct gru_context_configuration_handle *cch)
+{
 	cch->opc = CCHOP_ALLOCATE;
 	start_instruction(cch);
 	return wait_instruction_complete(cch, cchop_allocate);
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-02-21 22:34:32.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-02-21 22:35:46.000000000 -0600
@@ -480,9 +480,7 @@ enum gru_cbr_state {
 /* minimum TLB purge count to ensure a full purge */
 #define GRUMAXINVAL		1024UL
 
-int cch_allocate(struct gru_context_configuration_handle *cch,
-       int asidval, int sizeavail, unsigned long cbrmap, unsigned long dsrmap);
-
+int cch_allocate(struct gru_context_configuration_handle *cch);
 int cch_start(struct gru_context_configuration_handle *cch);
 int cch_interrupt(struct gru_context_configuration_handle *cch);
 int cch_deallocate(struct gru_context_configuration_handle *cch);
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-02-21 22:30:51.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-02-21 22:35:46.000000000 -0600
@@ -672,7 +672,10 @@ int gru_kservices_init(struct gru_state 
 	cch->tlb_int_enable = 0;
 	cch->tfm_done_bit_enable = 0;
 	cch->unmap_enable = 1;
-	err = cch_allocate(cch, 0, 0, cbr_map, dsr_map);
+	cch->dsr_allocation_map = dsr_map;
+	cch->cbr_allocation_map = cbr_map;
+
+	err = cch_allocate(cch);
 	if (err) {
 		gru_dbg(grudev,
 			"Unable to allocate kernel CCH: gid %d, err %d\n",
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-02-21 22:35:37.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-02-21 22:35:46.000000000 -0600
@@ -537,13 +537,12 @@ void gru_load_context(struct gru_thread_
 {
 	struct gru_state *gru = gts->ts_gru;
 	struct gru_context_configuration_handle *cch;
-	int err, asid, ctxnum = gts->ts_ctxnum;
+	int i, err, asid, ctxnum = gts->ts_ctxnum;
 
 	gru_dbg(grudev, "gts %p\n", gts);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	lock_cch_handle(cch);
-	asid = gru_load_mm_tracker(gru, gts);
 	cch->tfm_fault_bit_enable =
 	    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
 	     || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
@@ -553,8 +552,16 @@ void gru_load_context(struct gru_thread_
 		cch->tlb_int_select = gts->ts_tlb_int_select;
 	}
 	cch->tfm_done_bit_enable = 0;
-	err = cch_allocate(cch, asid, gts->ts_sizeavail, gts->ts_cbr_map,
-				gts->ts_dsr_map);
+	cch->dsr_allocation_map = gts->ts_dsr_map;
+	cch->cbr_allocation_map = gts->ts_cbr_map;
+	asid = gru_load_mm_tracker(gru, gts);
+	cch->unmap_enable = 0;
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = asid + i;
+		cch->sizeavail[i] = gts->ts_sizeavail;
+	}
+
+	err = cch_allocate(cch);
 	if (err) {
 		gru_dbg(grudev,
 			"err %d: cch %p, gts %p, cbr 0x%lx, dsr 0x%lx\n",

