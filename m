Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXIKNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXIKNgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXIKNem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:34:42 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:37347 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764038AbXIKNei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:34:38 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 11/12] IB/ehca: Serialize MR alloc and MR free hvCalls
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:34:35 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111534.35916.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some firmware levels exhibit a race condition between H_ALLOC_RESOURCE(MR)
and H_FREE_RESOURCE(MR). Work around this problem by locking these hvCalls
against each other.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/hcp_if.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index a70a5ed..d3d1ef2 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -120,15 +120,28 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 				    unsigned long arg7)
 {
 	long ret;
-	int i, sleep_msecs;
+	int i, sleep_msecs, do_lock;
+	unsigned long flags;
 
 	ehca_gen_dbg("opcode=%lx " HCALL7_REGS_FORMAT,
 		     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
 
+	/* lock H_FREE_RESOURCE(MR) against itself and H_ALLOC_RESOURCE(MR) */
+	if ((opcode == H_FREE_RESOURCE) && (arg7 == 5)) {
+		arg7 = 0; /* better not upset firmware */
+		do_lock = 1;
+	}
+
 	for (i = 0; i < 5; i++) {
+		if (do_lock)
+			spin_lock_irqsave(&hcall_lock, flags);
+
 		ret = plpar_hcall_norets(opcode, arg1, arg2, arg3, arg4,
 					 arg5, arg6, arg7);
 
+		if (do_lock)
+			spin_unlock_irqrestore(&hcall_lock, flags);
+
 		if (H_IS_LONG_BUSY(ret)) {
 			sleep_msecs = get_longbusy_msecs(ret);
 			msleep_interruptible(sleep_msecs);
@@ -161,23 +174,24 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 			      unsigned long arg9)
 {
 	long ret;
-	int i, sleep_msecs, lock_is_set = 0;
+	int i, sleep_msecs, do_lock;
 	unsigned long flags = 0;
 
 	ehca_gen_dbg("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT, opcode,
 		     arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
 
+	/* lock H_ALLOC_RESOURCE(MR) against itself and H_FREE_RESOURCE(MR) */
+	do_lock = ((opcode == H_ALLOC_RESOURCE) && (arg2 == 5));
+
 	for (i = 0; i < 5; i++) {
-		if ((opcode == H_ALLOC_RESOURCE) && (arg2 == 5)) {
+		if (do_lock)
 			spin_lock_irqsave(&hcall_lock, flags);
-			lock_is_set = 1;
-		}
 
 		ret = plpar_hcall9(opcode, outs,
 				   arg1, arg2, arg3, arg4, arg5,
 				   arg6, arg7, arg8, arg9);
 
-		if (lock_is_set)
+		if (do_lock)
 			spin_unlock_irqrestore(&hcall_lock, flags);
 
 		if (H_IS_LONG_BUSY(ret)) {
@@ -807,7 +821,7 @@ u64 hipz_h_free_resource_mr(const struct ipz_adapter_handle adapter_handle,
 	return ehca_plpar_hcall_norets(H_FREE_RESOURCE,
 				       adapter_handle.handle,    /* r4 */
 				       mr->ipz_mr_handle.handle, /* r5 */
-				       0, 0, 0, 0, 0);
+				       0, 0, 0, 0, 5);
 }
 
 u64 hipz_h_reregister_pmr(const struct ipz_adapter_handle adapter_handle,
-- 
1.5.2


