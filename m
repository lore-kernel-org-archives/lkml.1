Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbZKXPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbZKXPIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbZKXPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:57 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45522 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933286AbZKXPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:53 -0500
Message-Id: <20091124150759.471426000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:25 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 28/29] GRU - improve GRU TLB dropin statistics
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_update_ustats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the TLB dropin statistics kept for each GRU context. Count
TLB dropins separate from the misses - some misses do not result
in a TLB dropin. Some of the diagnostics need both counts.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru.h       |   11 +++++++++++
 drivers/misc/sgi-gru/grufault.c  |    5 +++--
 drivers/misc/sgi-gru/grulib.h    |   13 ++-----------
 drivers/misc/sgi-gru/grutables.h |    2 +-
 4 files changed, 17 insertions(+), 14 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru.h	2009-11-20 09:32:13.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gru.h	2009-11-20 09:32:39.000000000 -0600
@@ -53,6 +53,17 @@ struct gru_chiplet_info {
 	int	free_user_cbr;
 };
 
+/*
+ * Statictics kept for each context.
+ */
+struct gru_gseg_statistics {
+	unsigned long	fmm_tlbmiss;
+	unsigned long	upm_tlbmiss;
+	unsigned long	tlbdropin;
+	unsigned long	context_stolen;
+	unsigned long	reserved[10];
+};
+
 /* Flags for GRU options on the gru_create_context() call */
 /* Select one of the follow 4 options to specify how TLB misses are handled */
 #define GRU_OPT_MISS_DEFAULT	0x0000	/* Use default mode */
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:38.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:39.000000000 -0600
@@ -438,6 +438,7 @@ static int gru_try_dropin(struct gru_sta
 	}
 
 	gru_cb_set_istatus_active(cbk);
+	gts->ustats.tlbdropin++;
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
 	gru_dbg(grudev,
@@ -580,9 +581,9 @@ static irqreturn_t gru_intr(int chiplet,
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
 		 */
+		gts->ustats.fmm_tlbmiss++;
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
-			gts->ustats.fmm_tlbdropin++;
 			gru_try_dropin(gru, gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
@@ -624,7 +625,7 @@ static int gru_user_dropin(struct gru_th
 	struct gru_mm_struct *gms = gts->ts_gms;
 	int ret;
 
-	gts->ustats.upm_tlbdropin++;
+	gts->ustats.upm_tlbmiss++;
 	while (1) {
 		wait_event(gms->ms_wait_queue,
 			   atomic_read(&gms->ms_range_active) == 0);
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grulib.h	2009-11-20 09:32:39.000000000 -0600
@@ -63,18 +63,9 @@
 #define THREAD_POINTER(p, th)		(p + GRU_GSEG_PAGESIZE * (th))
 #define GSEG_START(cb)			((void *)((unsigned long)(cb) & ~(GRU_GSEG_PAGESIZE - 1)))
 
-/*
- * Statictics kept on a per-GTS basis.
- */
-struct gts_statistics {
-	unsigned long	fmm_tlbdropin;
-	unsigned long	upm_tlbdropin;
-	unsigned long	context_stolen;
-};
-
 struct gru_get_gseg_statistics_req {
-	unsigned long		gseg;
-	struct gts_statistics	stats;
+	unsigned long			gseg;
+	struct gru_gseg_statistics	stats;
 };
 
 /*
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:38.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:39.000000000 -0600
@@ -385,7 +385,7 @@ struct gru_thread_state {
 							  allocated CB */
 	int			ts_data_valid;	/* Indicates if ts_gdata has
 						   valid data */
-	struct gts_statistics	ustats;		/* User statistics */
+	struct gru_gseg_statistics ustats;	/* User statistics */
 	unsigned long		ts_gdata[0];	/* save area for GRU data (CB,
 						   DS, CBE) */
 };

