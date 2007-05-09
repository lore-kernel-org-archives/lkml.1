Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbXEILs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbXEILs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXEILsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:19962 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXEILsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:20 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 1/6] IB/ehca: Serialize hypervisor calls in ehca_register_mr()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:47:56 +0200
Message-Id: <200705091347.57470.fenkes@de.ibm.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher@de.ibm.com>

Some pSeries hypervisor versions show a race condition in the allocate MR hCall.
Serialize this call per adapter to circumvent this problem.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_main.c    |    2 ++
 drivers/infiniband/hw/ehca/hcp_if.c       |   14 ++++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 10fb8fb..4bc5cb3 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -276,6 +276,7 @@ void ehca_cleanup_mrmw_cache(void);
 
 extern spinlock_t ehca_qp_idr_lock;
 extern spinlock_t ehca_cq_idr_lock;
+extern spinlock_t hcall_lock;
 extern struct idr ehca_qp_idr;
 extern struct idr ehca_cq_idr;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 2d37054..2e27e68 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -98,6 +98,7 @@ MODULE_PARM_DESC(scaling_code,
 
 spinlock_t ehca_qp_idr_lock;
 spinlock_t ehca_cq_idr_lock;
+spinlock_t hcall_lock;
 DEFINE_IDR(ehca_qp_idr);
 DEFINE_IDR(ehca_cq_idr);
 
@@ -817,6 +818,7 @@ int __init ehca_module_init(void)
 	idr_init(&ehca_cq_idr);
 	spin_lock_init(&ehca_qp_idr_lock);
 	spin_lock_init(&ehca_cq_idr_lock);
+	spin_lock_init(&hcall_lock);
 
 	INIT_LIST_HEAD(&shca_list);
 	spin_lock_init(&shca_list_lock);
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index b564fcd..bb76134 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -154,7 +154,9 @@ static long ehca_plpar_hcall9(unsigned l
 			      unsigned long arg9)
 {
 	long ret;
-	int i, sleep_msecs;
+	int i, sleep_msecs, lock_is_set = 0;
+	unsigned long flags;
+
 
 	ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
 		     "arg5=%lx arg6=%lx arg7=%lx arg8=%lx arg9=%lx",
@@ -162,10 +164,18 @@ static long ehca_plpar_hcall9(unsigned l
 		     arg8, arg9);
 
 	for (i = 0; i < 5; i++) {
+		if ((opcode == H_ALLOC_RESOURCE) && (arg2 == 5)) {
+			spin_lock_irqsave(&hcall_lock, flags);
+			lock_is_set = 1;
+		}
+
 		ret = plpar_hcall9(opcode, outs,
 				   arg1, arg2, arg3, arg4, arg5,
 				   arg6, arg7, arg8, arg9);
 
+		if (lock_is_set)
+			spin_unlock_irqrestore(&hcall_lock, flags);
+
 		if (H_IS_LONG_BUSY(ret)) {
 			sleep_msecs = get_longbusy_msecs(ret);
 			msleep_interruptible(sleep_msecs);
@@ -193,11 +203,11 @@ static long ehca_plpar_hcall9(unsigned l
 			     opcode, ret, outs[0], outs[1], outs[2], outs[3],
 			     outs[4], outs[5], outs[6], outs[7], outs[8]);
 		return ret;
-
 	}
 
 	return H_BUSY;
 }
+
 u64 hipz_h_alloc_resource_eq(const struct ipz_adapter_handle adapter_handle,
 			     struct ehca_pfeq *pfeq,
 			     const u32 neq_control,
-- 
1.4.2.1


