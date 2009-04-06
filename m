Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZDFQO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZDFQO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDFQK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:10:28 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58108 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753282AbZDFQKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:10:18 -0400
Message-Id: <20090406161016.120568000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 06 Apr 2009 11:08:22 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [patch 13/13] GRU - update to rev 0.9 of gru spec
References: <20090406160809.278924000@sgi.com>
Content-Disposition: inline; filename=uv_gru_spec_update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update GRU driver to the latest version of the GRU spec. This consists
of minor updates:
	- changes & additions to error status bits
	- new restriction on handling of TLB misses while in FMM mode
	- new field (not used by software) in TFH


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gru_instructions.h |   19 ++++++++++++-------
 drivers/misc/sgi-gru/grufault.c         |    8 ++++++--
 drivers/misc/sgi-gru/gruhandles.h       |    3 ++-
 drivers/misc/sgi-gru/grukservices.c     |    3 ++-
 drivers/misc/sgi-gru/gruprocfs.c        |    1 +
 drivers/misc/sgi-gru/grutables.h        |    1 +
 6 files changed, 24 insertions(+), 11 deletions(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-04-06 09:17:42.000000000 -0500
@@ -253,32 +253,37 @@ struct gru_instruction {
 #define CBE_CAUSE_HA_RESPONSE_FATAL		(1 << 13)
 #define CBE_CAUSE_HA_RESPONSE_NON_FATAL		(1 << 14)
 #define CBE_CAUSE_ADDRESS_SPACE_DECODE_ERROR	(1 << 15)
-#define CBE_CAUSE_RESPONSE_DATA_ERROR		(1 << 16)
-#define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 17)
+#define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 16)
+#define CBE_CAUSE_RA_RESPONSE_DATA_ERROR	(1 << 17)
+#define CBE_CAUSE_HA_RESPONSE_DATA_ERROR	(1 << 18)
 
 /* CBE cbrexecstatus bits */
 #define CBR_EXS_ABORT_OCC_BIT			0
 #define CBR_EXS_INT_OCC_BIT			1
 #define CBR_EXS_PENDING_BIT			2
 #define CBR_EXS_QUEUED_BIT			3
-#define CBR_EXS_TLBHW_BIT			4
+#define CBR_EXS_TLB_INVAL_BIT			4
 #define CBR_EXS_EXCEPTION_BIT			5
 
 #define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
 #define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
 #define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
 #define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_EXS_TLBHW				(1 << CBR_EXS_TLBHW_BIT)
+#define CBR_TLB_INVAL				(1 << CBR_EXS_TLB_INVAL_BIT)
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
 
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
  * in ecause, the exception is not retryable.
  */
-#define EXCEPTION_RETRY_BITS (CBE_CAUSE_RESPONSE_DATA_ERROR |		\
-			      CBE_CAUSE_RA_REQUEST_TIMEOUT |		\
+#define EXCEPTION_RETRY_BITS (CBE_CAUSE_EXECUTION_HW_ERROR |		\
 			      CBE_CAUSE_TLBHW_ERROR |			\
-			      CBE_CAUSE_HA_REQUEST_TIMEOUT)
+			      CBE_CAUSE_RA_REQUEST_TIMEOUT |		\
+			      CBE_CAUSE_RA_RESPONSE_NON_FATAL |		\
+			      CBE_CAUSE_HA_RESPONSE_NON_FATAL |		\
+			      CBE_CAUSE_RA_RESPONSE_DATA_ERROR |	\
+			      CBE_CAUSE_HA_RESPONSE_DATA_ERROR		\
+			      )
 
 /* Message queue head structure */
 union gru_mesqhead {
Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-04-06 09:17:42.000000000 -0500
@@ -339,8 +339,12 @@ static int gru_try_dropin(struct gru_thr
 	 * Might be a hardware race OR a stupid user. Ignore FMM because FMM
 	 * is a transient state.
 	 */
-	if (tfh->status != TFHSTATUS_EXCEPTION)
-		goto failnoexception;
+	if (tfh->status != TFHSTATUS_EXCEPTION) {
+		gru_flush_cache(tfh);
+		if (tfh->status != TFHSTATUS_EXCEPTION)
+			goto failnoexception;
+		STAT(tfh_stale_on_fault);
+	}
 	if (tfh->state == TFHSTATE_IDLE)
 		goto failidle;
 	if (tfh->state == TFHSTATE_MISS_FMM && cb)
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-04-06 09:17:42.000000000 -0500
@@ -255,7 +255,8 @@ struct gru_tlb_fault_handle {
 	unsigned int state:3;
 	unsigned int fill3:1;
 
-	unsigned int cause:7;
+	unsigned int cause:6;
+	unsigned int cb_int:1;
 	unsigned int fill4:1;
 
 	unsigned int indexway:12;	/* DW 0 - high 32 */
Index: linux/drivers/misc/sgi-gru/grukservices.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.c	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.c	2009-04-06 09:17:50.000000000 -0500
@@ -406,7 +406,8 @@ static int gru_retry_exception(void *cb)
 			return CBS_IDLE;
 
 		gru_get_cb_exception_detail(cb, &excdet);
-		if (excdet.ecause & ~EXCEPTION_RETRY_BITS)
+		if ((excdet.ecause & ~EXCEPTION_RETRY_BITS) ||
+				(excdet.cbrexecstatus & CBR_EXS_ABORT_OCC))
 			break;
 		if (retry-- == 0)
 			break;
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2009-04-06 09:17:42.000000000 -0500
@@ -89,6 +89,7 @@ static int statistics_show(struct seq_fi
 	printstat(s, tlb_dropin_fail_fmm);
 	printstat(s, tlb_dropin_fail_no_exception);
 	printstat(s, tlb_dropin_fail_no_exception_war);
+	printstat(s, tfh_stale_on_fault);
 	printstat(s, mmu_invalidate_range);
 	printstat(s, mmu_invalidate_page);
 	printstat(s, mmu_clear_flush_young);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-04-06 09:17:38.000000000 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-04-06 09:17:42.000000000 -0500
@@ -212,6 +212,7 @@ struct gru_stats_s {
 	atomic_long_t tlb_dropin_fail_fmm;
 	atomic_long_t tlb_dropin_fail_no_exception;
 	atomic_long_t tlb_dropin_fail_no_exception_war;
+	atomic_long_t tfh_stale_on_fault;
 	atomic_long_t mmu_invalidate_range;
 	atomic_long_t mmu_invalidate_page;
 	atomic_long_t mmu_clear_flush_young;

