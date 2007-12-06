Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXLFPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXLFPIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXLFPIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:08:12 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:15076 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:08:11 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 6 Dec 2007 16:07:19 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712061607.20004.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All firmware versions on POWER5 systems have a locking issue in the
HCA-related hCalls that can cause loss of Infiniband connectivity if
allocate and free calls happen in parallel. This may for example be caused
if two processes are using OpenMPI in parallel.
Circumvent this by serializing all HCA-related hCalls on POWER5.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

We tested this patch, especially the autodetection, and it works okay.
Please review and apply for 2.6.24-rc5 - thanks!

 drivers/infiniband/hw/ehca/ehca_main.c |   16 ++++++++++++++++
 drivers/infiniband/hw/ehca/hcp_if.c    |   28 +++++++++++-----------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 90d4334..8f33d06 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -43,6 +43,9 @@
 #ifdef CONFIG_PPC_64K_PAGES
 #include <linux/slab.h>
 #endif
+
+#include <asm/cputable.h>
+
 #include "ehca_classes.h"
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
@@ -66,6 +69,7 @@ int ehca_poll_all_eqs  = 1;
 int ehca_static_rate   = -1;
 int ehca_scaling_code  = 0;
 int ehca_mr_largepage  = 1;
+int ehca_lock_hcalls   = -1;
 
 module_param_named(open_aqp1,     ehca_open_aqp1,     int, S_IRUGO);
 module_param_named(debug_level,   ehca_debug_level,   int, S_IRUGO);
@@ -77,6 +81,7 @@ module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, S_IRUGO);
 module_param_named(static_rate,   ehca_static_rate,   int, S_IRUGO);
 module_param_named(scaling_code,  ehca_scaling_code,  int, S_IRUGO);
 module_param_named(mr_largepage,  ehca_mr_largepage,  int, S_IRUGO);
+module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
 
 MODULE_PARM_DESC(open_aqp1,
 		 "AQP1 on startup (0: no (default), 1: yes)");
@@ -102,6 +107,9 @@ MODULE_PARM_DESC(scaling_code,
 MODULE_PARM_DESC(mr_largepage,
 		 "use large page for MR (0: use PAGE_SIZE (default), "
 		 "1: use large page depending on MR size");
+MODULE_PARM_DESC(lock_hcalls,
+		 "serialize all hCalls made by the driver "
+		 "(default: autodetect)");
 
 DEFINE_RWLOCK(ehca_qp_idr_lock);
 DEFINE_RWLOCK(ehca_cq_idr_lock);
@@ -924,6 +932,14 @@ int __init ehca_module_init(void)
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
 	       "(Version " HCAD_VERSION ")\n");
 
+	/* Autodetect hCall locking -- we can't read the firmware version
+	 * directly, but we know that starting with POWER6, all firmware
+	 * versions are good.
+	 */
+	if (ehca_lock_hcalls == -1)
+		ehca_lock_hcalls = !(cur_cpu_spec->cpu_user_features
+				     & PPC_FEATURE_ARCH_2_05);
+
 	ret = ehca_create_comp_pool();
 	if (ret) {
 		ehca_gen_err("Cannot create comp pool.");
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index c16a213..331b5e8 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -89,6 +89,7 @@
 #define HCALL9_REGS_FORMAT HCALL7_REGS_FORMAT " r11=%lx r12=%lx"
 
 static DEFINE_SPINLOCK(hcall_lock);
+extern int ehca_lock_hcalls;
 
 static u32 get_longbusy_msecs(int longbusy_rc)
 {
@@ -120,26 +121,21 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
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
@@ -174,24 +170,22 @@ static long ehca_plpar_hcall9(unsigned long opcode,
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
@@ -821,7 +815,7 @@ u64 hipz_h_free_resource_mr(const struct ipz_adapter_handle adapter_handle,
 	return ehca_plpar_hcall_norets(H_FREE_RESOURCE,
 				       adapter_handle.handle,    /* r4 */
 				       mr->ipz_mr_handle.handle, /* r5 */
-				       0, 0, 0, 0, 5);
+				       0, 0, 0, 0, 0);
 }
 
 u64 hipz_h_reregister_pmr(const struct ipz_adapter_handle adapter_handle,
-- 
1.5.2


