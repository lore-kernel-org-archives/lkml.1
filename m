Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbXLMRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbXLMRkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764547AbXLMRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:39:35 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8068 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765392AbXLMRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:39:33 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Dec 2007 09:39:29 -0800
Message-ID: <adar6hq7aum.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Dec 2007 17:39:29.0645 (UTC) FILETIME=[1D1389D0:01C83DAF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pull a few small ehca driver fixes for 2.6.24:

Joachim Fenkes (3):
      IB/ehca: Return correct number of SGEs for SRQ
      IB/ehca: Serialize HCA-related hCalls if necessary
      IB/ehca: Fix lock flag variable location, bump version number

 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c    |   15 ++++++++++++++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |    4 ++--
 drivers/infiniband/hw/ehca/hcp_if.c       |   27 ++++++++++-----------------
 drivers/infiniband/hw/ehca/hipz_hw.h      |    1 +
 5 files changed, 28 insertions(+), 20 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 87f12d4..74d2b72 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -322,6 +322,7 @@ extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
+extern int ehca_lock_hcalls;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 90d4334..6a56d86 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -43,13 +43,14 @@
 #ifdef CONFIG_PPC_64K_PAGES
 #include <linux/slab.h>
 #endif
+
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
 #include "ehca_tools.h"
 #include "hcp_if.h"
 
-#define HCAD_VERSION "0024"
+#define HCAD_VERSION "0025"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
@@ -66,6 +67,7 @@ int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
 int ehca_mr_largepage  = 1;
+int ehca_lock_hcalls   = -1;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, S_IRUGO);
 module_param_named(debug_level,   ehca_debug_level,   int, S_IRUGO);
@@ -77,6 +79,7 @@ module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, S_IRUGO);
 module_param_named(static_rate,   ehca_static_rate,   int, S_IRUGO);
 module_param_named(scaling_code,  ehca_scaling_code,  int, S_IRUGO);
 module_param_named(mr_largepage,  ehca_mr_largepage,  int, S_IRUGO);
+module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
 
 MODULE_PARM_DESC(open_aqp1,
 		 "AQP1 on startup (0: no (default), 1: yes)");
@@ -102,6 +105,9 @@ MODULE_PARM_DESC(scaling_code,
 MODULE_PARM_DESC(mr_largepage,
 		 "use large page for MR (0: use PAGE_SIZE (default), "
 		 "1: use large page depending on MR size");
+MODULE_PARM_DESC(lock_hcalls,
+		 "serialize all hCalls made by the driver "
+		 "(default: autodetect)");
 
 DEFINE_RWLOCK(ehca_qp_idr_lock);
 DEFINE_RWLOCK(ehca_cq_idr_lock);
@@ -258,6 +264,7 @@ static struct cap_descr {
 	{ HCA_CAP_UD_LL_QP, "HCA_CAP_UD_LL_QP" },
 	{ HCA_CAP_RESIZE_MR, "HCA_CAP_RESIZE_MR" },
 	{ HCA_CAP_MINI_QP, "HCA_CAP_MINI_QP" },
+	{ HCA_CAP_H_ALLOC_RES_SYNC, "HCA_CAP_H_ALLOC_RES_SYNC" },
 };
 
 static int ehca_sense_attributes(struct ehca_shca *shca)
@@ -333,6 +340,12 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
 			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
 
+	/* Autodetect hCall locking -- the "H_ALLOC_RESOURCE synced" flag is
+	 * a firmware property, so it's valid across all adapters
+	 */
+	if (ehca_lock_hcalls == -1)
+		ehca_lock_hcalls = !(shca->hca_cap & HCA_CAP_H_ALLOC_RES_SYNC);
+
 	/* translate supported MR page sizes; always support 4K */
 	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
 	if (ehca_mr_largepage) { /* support extra sizes only if enabled */
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index dd12668..eff5fb5 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -838,7 +838,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 
 	/* copy back return values */
 	srq_init_attr->attr.max_wr = qp_init_attr.cap.max_recv_wr;
-	srq_init_attr->attr.max_sge = qp_init_attr.cap.max_recv_sge;
+	srq_init_attr->attr.max_sge = 3;
 
 	/* drive SRQ into RTR state */
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
@@ -1750,7 +1750,7 @@ int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 	}
 
 	srq_attr->max_wr = qpcb->max_nr_outst_recv_wr - 1;
-	srq_attr->max_sge = qpcb->actual_nr_sges_in_rq_wqe;
+	srq_attr->max_sge = 3;
 	srq_attr->srq_limit = EHCA_BMASK_GET(
 		MQPCB_CURR_SRQ_LIMIT, qpcb->curr_srq_limit);
 
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index c16a213..7029aa6 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -120,26 +120,21 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 				    unsigned long arg7)
 {
 	long ret;
-	int i, sleep_msecs, do_lock;
-	unsigned long flags;
+	int i, sleep_msecs;
+	unsigned long flags = 0;
 
 	ehca_gen_dbg("opcode=%lx " HCALL7_REGS_FORMAT,
 		     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
 
-	/* lock H_FREE_RESOURCE(MR) against itself and H_ALLOC_RESOURCE(MR) */
-	if ((opcode == H_FREE_RESOURCE) && (arg7 == 5)) {
-		arg7 = 0; /* better not upset firmware */
-		do_lock = 1;
-	}
-
 	for (i = 0; i < 5; i++) {
-		if (do_lock)
+		/* serialize hCalls to work around firmware issue */
+		if (ehca_lock_hcalls)
 			spin_lock_irqsave(&hcall_lock, flags);
 
 		ret = plpar_hcall_norets(opcode, arg1, arg2, arg3, arg4,
 					 arg5, arg6, arg7);
 
-		if (do_lock)
+		if (ehca_lock_hcalls)
 			spin_unlock_irqrestore(&hcall_lock, flags);
 
 		if (H_IS_LONG_BUSY(ret)) {
@@ -174,24 +169,22 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 			      unsigned long arg9)
 {
 	long ret;
-	int i, sleep_msecs, do_lock;
+	int i, sleep_msecs;
 	unsigned long flags = 0;
 
 	ehca_gen_dbg("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT, opcode,
 		     arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
 
-	/* lock H_ALLOC_RESOURCE(MR) against itself and H_FREE_RESOURCE(MR) */
-	do_lock = ((opcode == H_ALLOC_RESOURCE) && (arg2 == 5));
-
 	for (i = 0; i < 5; i++) {
-		if (do_lock)
+		/* serialize hCalls to work around firmware issue */
+		if (ehca_lock_hcalls)
 			spin_lock_irqsave(&hcall_lock, flags);
 
 		ret = plpar_hcall9(opcode, outs,
 				   arg1, arg2, arg3, arg4, arg5,
 				   arg6, arg7, arg8, arg9);
 
-		if (do_lock)
+		if (ehca_lock_hcalls)
 			spin_unlock_irqrestore(&hcall_lock, flags);
 
 		if (H_IS_LONG_BUSY(ret)) {
@@ -821,7 +814,7 @@ u64 hipz_h_free_resource_mr(const struct ipz_adapter_handle adapter_handle,
 	return ehca_plpar_hcall_norets(H_FREE_RESOURCE,
 				       adapter_handle.handle,    /* r4 */
 				       mr->ipz_mr_handle.handle, /* r5 */
-				       0, 0, 0, 0, 5);
+				       0, 0, 0, 0, 0);
 }
 
 u64 hipz_h_reregister_pmr(const struct ipz_adapter_handle adapter_handle,
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index 485b840..bf996c7 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -378,6 +378,7 @@ struct hipz_query_hca {
 #define HCA_CAP_UD_LL_QP              EHCA_BMASK_IBM(16, 16)
 #define HCA_CAP_RESIZE_MR             EHCA_BMASK_IBM(17, 17)
 #define HCA_CAP_MINI_QP               EHCA_BMASK_IBM(18, 18)
+#define HCA_CAP_H_ALLOC_RES_SYNC      EHCA_BMASK_IBM(19, 19)
 
 /* query port response block */
 struct hipz_query_port {
