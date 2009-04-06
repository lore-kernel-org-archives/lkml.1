Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZDFQMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZDFQMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZDFQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:23 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752029AbZDFQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:16 -0400
Message-Id: <20090406161010.956109000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:10 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 01/13] GRU - bug fixes for GRU exception handling
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_exception
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Bug fixes for GRU exception handling. Additional fields
from the CBR must be returned to the user to allow the
user to correctly diagnose GRU exceptions.

Handle endcase in TFH TLB miss handling. Verify that TFH
actually indicates a pending exception.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gru_instructions.h |   20 +++++++++++++++++++-
 drivers/misc/sgi-gru/grufault.c         |   25 +++++++++++++++++++++----
 drivers/misc/sgi-gru/gruhandles.h       |   23 ++++-------------------
 drivers/misc/sgi-gru/grumain.c          |    3 +++
 drivers/misc/sgi-gru/gruprocfs.c        |    5 +++--
 drivers/misc/sgi-gru/grutables.h        |    2 ++
 6 files changed, 52 insertions(+), 26 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-04-06 09:11:50.000000000 -0500
@@ -81,6 +81,8 @@ struct control_block_extended_exc_detail
 	int		exopc;
 	long		exceptdet0;
 	int		exceptdet1;
+	int		cbrstate;
+	int		cbrexecstatus;
 };
 
 /*
@@ -107,7 +109,8 @@ struct gru_instruction_bits {
     unsigned char		reserved2: 2;
     unsigned char		istatus:   2;
     unsigned char		isubstatus:4;
-    unsigned char		reserved3: 2;
+    unsigned char		reserved3: 1;
+    unsigned char		tlb_fault_color: 1;
     /* DW 1 */
     unsigned long		idef4;		/* 42 bits: TRi1, BufSize */
     /* DW 2-6 */
@@ -253,6 +256,21 @@ struct gru_instruction {
 #define CBE_CAUSE_RESPONSE_DATA_ERROR		(1 << 16)
 #define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 17)
 
+/* CBE cbrexecstatus bits */
+#define CBR_EXS_ABORT_OCC_BIT			0
+#define CBR_EXS_INT_OCC_BIT			1
+#define CBR_EXS_PENDING_BIT			2
+#define CBR_EXS_QUEUED_BIT			3
+#define CBR_EXS_TLBHW_BIT			4
+#define CBR_EXS_EXCEPTION_BIT			5
+
+#define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
+#define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
+#define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
+#define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
+#define CBR_EXS_TLBHW				(1 << CBR_EXS_TLBHW_BIT)
+#define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
+
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
  * in ecause, the exception is not retryable.
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:12:20.000000000 -0500
@@ -334,6 +334,8 @@ static int gru_try_dropin(struct gru_thr
 	 * Might be a hardware race OR a stupid user. Ignore FMM because FMM
 	 * is a transient state.
 	 */
+	if (tfh->status != TFHSTATUS_EXCEPTION)
+		goto failnoexception;
 	if (tfh->state == TFHSTATE_IDLE)
 		goto failidle;
 	if (tfh->state == TFHSTATE_MISS_FMM && cb)
@@ -401,8 +403,17 @@ failfmm:
 	gru_dbg(grudev, "FAILED fmm tfh: 0x%p, state %d\n", tfh, tfh->state);
 	return 0;
 
+failnoexception:
+	/* TFH status did not show exception pending */
+	gru_flush_cache(tfh);
+	if (cb)
+		gru_flush_cache(cb);
+	STAT(tlb_dropin_fail_no_exception);
+	gru_dbg(grudev, "FAILED non-exception tfh: 0x%p, status %d, state %d\n", tfh, tfh->status, tfh->state);
+	return 0;
+
 failidle:
-	/* TFH was idle  - no miss pending */
+	/* TFH state was idle  - no miss pending */
 	gru_flush_cache(tfh);
 	if (cb)
 		gru_flush_cache(cb);
@@ -472,7 +483,8 @@ irqreturn_t gru_intr(int irq, void *dev_
 		 * This is running in interrupt context. Trylock the mmap_sem.
 		 * If it fails, retry the fault in user context.
 		 */
-		if (down_read_trylock(&gts->ts_mm->mmap_sem)) {
+		if (!gts->ts_force_cch_reload &&
+					down_read_trylock(&gts->ts_mm->mmap_sem)) {
 			gru_try_dropin(gts, tfh, NULL);
 			up_read(&gts->ts_mm->mmap_sem);
 		} else {
@@ -595,14 +607,19 @@ int gru_get_exception_detail(unsigned lo
 		excdet.ecause = cbe->ecause;
 		excdet.exceptdet0 = cbe->idef1upd;
 		excdet.exceptdet1 = cbe->idef3upd;
+		excdet.cbrstate = cbe->cbrstate;
+		excdet.cbrexecstatus = cbe->cbrexecstatus;
 		ret = 0;
 	} else {
 		ret = -EAGAIN;
 	}
 	gru_unlock_gts(gts);
 
-	gru_dbg(grudev, "address 0x%lx, ecause 0x%x\n", excdet.cb,
-		excdet.ecause);
+	gru_dbg(grudev,
+		"cb 0x%lx, op %d, exopc %d, cbrstate %d, cbrexecstatus 0x%x, ecause 0x%x, "
+		"exdet0 0x%lx, exdet1 0x%x\n",
+		excdet.cb, excdet.opc, excdet.exopc, excdet.cbrstate, excdet.cbrexecstatus,
+		excdet.ecause, excdet.exceptdet0, excdet.exceptdet1);
 	if (!ret && copy_to_user((void __user *)arg, &excdet, sizeof(excdet)))
 		ret = -EFAULT;
 	return ret;
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-04-06 09:11:55.000000000 -0500
@@ -251,15 +251,14 @@ struct gru_tlb_fault_handle {
 	unsigned int fill1:9;
 
 	unsigned int status:2;
-	unsigned int fill2:1;
-	unsigned int color:1;
+	unsigned int fill2:2;
 	unsigned int state:3;
 	unsigned int fill3:1;
 
-	unsigned int cause:7;		/* DW 0 - high 32 */
+	unsigned int cause:7;
 	unsigned int fill4:1;
 
-	unsigned int indexway:12;
+	unsigned int indexway:12;	/* DW 0 - high 32 */
 	unsigned int fill5:4;
 
 	unsigned int ctxnum:4;
@@ -457,21 +456,7 @@ enum gru_cbr_state {
 	CBRSTATE_BUSY_INTERRUPT,
 };
 
-/* CBE cbrexecstatus bits */
-#define CBR_EXS_ABORT_OCC_BIT			0
-#define CBR_EXS_INT_OCC_BIT			1
-#define CBR_EXS_PENDING_BIT			2
-#define CBR_EXS_QUEUED_BIT			3
-#define CBR_EXS_TLBHW_BIT			4
-#define CBR_EXS_EXCEPTION_BIT			5
-
-#define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
-#define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
-#define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
-#define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_EXS_TLBHW				(1 << CBR_EXS_TLBHW_BIT)
-#define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
-
+/* CBE cbrexecstatus bits  - defined in gru_instructions.h*/
 /* CBE ecause bits  - defined in gru_instructions.h */
 
 /*
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2009-04-06 09:11:57.000000000 -0500
@@ -599,6 +599,9 @@ int gru_update_cch(struct gru_thread_sta
 				cch->sizeavail[i] = gts->ts_sizeavail;
 			gts->ts_tlb_int_select = gru_cpu_fault_map_id();
 			cch->tlb_int_select = gru_cpu_fault_map_id();
+			cch->tfm_fault_bit_enable =
+	    		    (gts->ts_user_options == GRU_OPT_MISS_FMM_POLL
+	     		    || gts->ts_user_options == GRU_OPT_MISS_FMM_INTR);
 		} else {
 			for (i = 0; i < 8; i++)
 				cch->asid[i] = 0;
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-04-06 09:11:55.000000000 -0500
@@ -84,6 +84,8 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin_fail_range_active);
 	printstat(s, tlb_dropin_fail_idle);
 	printstat(s, tlb_dropin_fail_fmm);
+	printstat(s, tlb_dropin_fail_no_exception);
+	printstat(s, tlb_dropin_fail_no_exception_war);
 	printstat(s, mmu_invalidate_range);
 	printstat(s, mmu_invalidate_page);
 	printstat(s, mmu_clear_flush_young);
@@ -158,8 +160,7 @@ static ssize_t options_write(struct file
 	unsigned long val;
 	char buf[80];
 
-	if (copy_from_user
-	    (buf, userbuf, count < sizeof(buf) ? count : sizeof(buf)))
+	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
 		return -EFAULT;
 	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-06 07:47:59.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-06 09:11:58.000000000 -0500
@@ -207,6 +207,8 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin_fail_range_active;
 	atomic_long_t tlb_dropin_fail_idle;
 	atomic_long_t tlb_dropin_fail_fmm;
+	atomic_long_t tlb_dropin_fail_no_exception;
+	atomic_long_t tlb_dropin_fail_no_exception_war;
 	atomic_long_t mmu_invalidate_range;
 	atomic_long_t mmu_invalidate_page;
 	atomic_long_t mmu_clear_flush_young;

