Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbZKXPH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbZKXPH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbZKXPH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:56 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39141 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933284AbZKXPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:53 -0500
Message-Id: <20091124150759.119528000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:24 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 27/29] GRU - Fix GRU interrupt race at deallocate
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_gts_invalid_race
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Fix a race where an interrupt could be received for a GRU context that
has been deallocated.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufault.c  |   24 +++++++++++++++++-------
 drivers/misc/sgi-gru/gruprocfs.c |    1 +
 drivers/misc/sgi-gru/grutables.h |    1 +
 3 files changed, 19 insertions(+), 7 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:38.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:38.000000000 -0600
@@ -360,7 +360,8 @@ static void gru_preload_tlb(struct gru_s
  * 		< 0 = error code
  *
  */
-static int gru_try_dropin(struct gru_thread_state *gts,
+static int gru_try_dropin(struct gru_state *gru,
+			  struct gru_thread_state *gts,
 			  struct gru_tlb_fault_handle *tfh,
 			  struct gru_instruction_bits *cbk)
 {
@@ -432,7 +433,7 @@ static int gru_try_dropin(struct gru_thr
 	}
 
 	if (unlikely(cbe) && pageshift == PAGE_SHIFT) {
-		gru_preload_tlb(gts->ts_gru, gts, atomic, vaddr, asid, write, tlb_preload_count, tfh, cbe);
+		gru_preload_tlb(gru, gts, atomic, vaddr, asid, write, tlb_preload_count, tfh, cbe);
 		gru_flush_cache_cbe(cbe);
 	}
 
@@ -442,7 +443,7 @@ static int gru_try_dropin(struct gru_thr
 	gru_dbg(grudev,
 		"%s: gid %d, gts 0x%p, tfh 0x%p, vaddr 0x%lx, asid 0x%x, indexway 0x%x,"
 		" rw %d, ps %d, gpa 0x%lx\n",
-		atomic ? "atomic" : "non-atomic", gts->ts_gru->gs_gid, gts, tfh, vaddr, asid,
+		atomic ? "atomic" : "non-atomic", gru->gs_gid, gts, tfh, vaddr, asid,
 		indexway, write, pageshift, gpa);
 	STAT(tlb_dropin);
 	return 0;
@@ -528,6 +529,7 @@ static irqreturn_t gru_intr(int chiplet,
 	struct gru_tlb_fault_map imap, dmap;
 	struct gru_thread_state *gts;
 	struct gru_tlb_fault_handle *tfh = NULL;
+	struct completion *cmp;
 	int cbrnum, ctxnum;
 
 	STAT(intr);
@@ -547,9 +549,11 @@ static irqreturn_t gru_intr(int chiplet,
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		STAT(intr_cbr);
-		complete(gru->gs_blade->bs_async_wq);
+		cmp = gru->gs_blade->bs_async_wq;
+		if (cmp)
+			complete(cmp);
 		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
-			gru->gs_gid, cbrnum, gru->gs_blade->bs_async_wq->done);
+			gru->gs_gid, cbrnum, cmp ? cmp->done : -1);
 	}
 
 	for_each_cbr_in_tfm(cbrnum, imap.fault_bits) {
@@ -566,6 +570,12 @@ static irqreturn_t gru_intr(int chiplet,
 		ctxnum = tfh->ctxnum;
 		gts = gru->gs_gts[ctxnum];
 
+		/* Spurious interrupts can cause this. Ignore. */
+		if (!gts) {
+			STAT(intr_spurious);
+			continue;
+		}
+
 		/*
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
@@ -573,7 +583,7 @@ static irqreturn_t gru_intr(int chiplet,
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
 			gts->ustats.fmm_tlbdropin++;
-			gru_try_dropin(gts, tfh, NULL);
+			gru_try_dropin(gru, gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
 			tfh_user_polling_mode(tfh);
@@ -619,7 +629,7 @@ static int gru_user_dropin(struct gru_th
 		wait_event(gms->ms_wait_queue,
 			   atomic_read(&gms->ms_range_active) == 0);
 		prefetchw(tfh);	/* Helps on hdw, required for emulator */
-		ret = gru_try_dropin(gts, tfh, cb);
+		ret = gru_try_dropin(gts->ts_gru, gts, tfh, cb);
 		if (ret <= 0)
 			return ret;
 		STAT(call_os_wait_queue);
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-11-20 09:32:38.000000000 -0600
@@ -66,6 +66,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, intr);
 	printstat(s, intr_cbr);
 	printstat(s, intr_tfh);
+	printstat(s, intr_spurious);
 	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
 	printstat(s, call_os_wait_queue);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:38.000000000 -0600
@@ -192,6 +192,7 @@ struct gru_stats_s {
 	atomic_long_t intr;
 	atomic_long_t intr_cbr;
 	atomic_long_t intr_tfh;
+	atomic_long_t intr_spurious;
 	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
 	atomic_long_t call_os_wait_queue;

