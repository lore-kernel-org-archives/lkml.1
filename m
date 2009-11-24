Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbZKXPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbZKXPMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbZKXPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:12:27 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57696 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933247AbZKXPHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:48 -0500
Message-Id: <20091124150754.618013000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:12 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 15/29] GRU - Fix prefetch and speculation bugs
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_speculation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix several bugs related to prefetch, ordering & speculation:

	- GRU cch_allocate() instruction causes cacheable memory
	  to be created. Add a barriers to prevent speculation
	  from prefetching data before it exists.
	- Add memory barriers before cache-flush instructions to ensure
	  that previously stored data is included in the line flushed to memory.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |    1 +
 drivers/misc/sgi-gru/grufault.c         |    2 ++
 drivers/misc/sgi-gru/gruhandles.c       |   22 ++++++++++++++++++++--
 drivers/misc/sgi-gru/grukservices.c     |   10 ++++++----
 drivers/misc/sgi-gru/grumain.c          |    9 +++++++++
 5 files changed, 38 insertions(+), 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-11-20 09:32:25.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-11-20 09:32:33.000000000 -0600
@@ -325,6 +325,7 @@ static inline void gru_flush_cache(void 
 static inline void gru_start_instruction(struct gru_instruction *ins, int op32)
 {
 	gru_ordered_store_int(ins, op32);
+	mb();
 	gru_flush_cache(ins);
 }
 
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:33.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:33.000000000 -0600
@@ -333,6 +333,7 @@ static int gru_try_dropin(struct gru_thr
 	 */
 	if (tfh->status != TFHSTATUS_EXCEPTION) {
 		gru_flush_cache(tfh);
+		sync_core();
 		if (tfh->status != TFHSTATUS_EXCEPTION)
 			goto failnoexception;
 		STAT(tfh_stale_on_fault);
@@ -599,6 +600,7 @@ int gru_get_exception_detail(unsigned lo
 		cbrnum = thread_cbr_number(gts, ucbnum);
 		cbe = get_cbe_by_index(gts->ts_gru, cbrnum);
 		gru_flush_cache(cbe);	/* CBE not coherent */
+		sync_core();		/* make sure we are have current data */
 		excdet.opc = cbe->opccpy;
 		excdet.exopc = cbe->exopccpy;
 		excdet.ecause = cbe->ecause;
Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2009-11-20 09:32:30.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2009-11-20 09:32:33.000000000 -0600
@@ -91,9 +91,18 @@ static int wait_instruction_complete(voi
 
 int cch_allocate(struct gru_context_configuration_handle *cch)
 {
+	int ret;
+
 	cch->opc = CCHOP_ALLOCATE;
 	start_instruction(cch);
-	return wait_instruction_complete(cch, cchop_allocate);
+	ret = wait_instruction_complete(cch, cchop_allocate);
+
+	/*
+	 * Stop speculation into the GSEG being mapped by the previous ALLOCATE.
+	 * The GSEG memory does not exist until the ALLOCATE completes.
+	 */
+	sync_core();
+	return ret;
 }
 
 int cch_start(struct gru_context_configuration_handle *cch)
@@ -112,9 +121,18 @@ int cch_interrupt(struct gru_context_con
 
 int cch_deallocate(struct gru_context_configuration_handle *cch)
 {
+	int ret;
+
 	cch->opc = CCHOP_DEALLOCATE;
 	start_instruction(cch);
-	return wait_instruction_complete(cch, cchop_deallocate);
+	ret = wait_instruction_complete(cch, cchop_deallocate);
+
+	/*
+	 * Stop speculation into the GSEG being unmapped by the previous
+	 * DEALLOCATE.
+	 */
+	sync_core();
+	return ret;
 }
 
 int cch_interrupt_sync(struct gru_context_configuration_handle
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:32.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-11-20 09:32:33.000000000 -0600
@@ -395,6 +395,7 @@ int gru_get_cb_exception_detail(void *cb
 	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
 	cbe = get_cbe(GRUBASE(cb), cbrnum);
 	gru_flush_cache(cbe);	/* CBE not coherent */
+	sync_core();
 	excdet->opc = cbe->opccpy;
 	excdet->exopc = cbe->exopccpy;
 	excdet->ecause = cbe->ecause;
@@ -461,9 +462,10 @@ int gru_check_status_proc(void *cb)
 	int ret;
 
 	ret = gen->istatus;
-	if (ret != CBS_EXCEPTION)
-		return ret;
-	return gru_retry_exception(cb);
+	if (ret == CBS_EXCEPTION)
+		ret = gru_retry_exception(cb);
+	rmb();
+	return ret;
 
 }
 
@@ -475,7 +477,7 @@ int gru_wait_proc(void *cb)
 	ret = gru_wait_idle_or_exception(gen);
 	if (ret == CBS_EXCEPTION)
 		ret = gru_retry_exception(cb);
-
+	rmb();
 	return ret;
 }
 
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:31.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-11-20 09:32:33.000000000 -0600
@@ -499,6 +499,9 @@ static void gru_load_context_data(void *
 			memset(cbe + i * GRU_HANDLE_STRIDE, 0,
 						GRU_CACHE_LINE_BYTES);
 		}
+		/* Flush CBE to hide race in context restart */
+		mb();
+		gru_flush_cache(cbe + i * GRU_HANDLE_STRIDE);
 		cb += GRU_HANDLE_STRIDE;
 	}
 
@@ -519,6 +522,12 @@ static void gru_unload_context_data(void
 	cb = gseg + GRU_CB_BASE;
 	cbe = grubase + GRU_CBE_BASE;
 	length = hweight64(dsrmap) * GRU_DSR_AU_BYTES;
+
+	/* CBEs may not be coherent. Flush them from cache */
+	for_each_cbr_in_allocation_map(i, &cbrmap, scr)
+		gru_flush_cache(cbe + i * GRU_HANDLE_STRIDE);
+	mb();		/* Let the CL flush complete */
+
 	gru_prefetch_context(gseg, cb, cbe, cbrmap, length);
 
 	for_each_cbr_in_allocation_map(i, &cbrmap, scr) {

