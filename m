Return-Path: <linux-kernel-owner+w=401wt.eu-S1765984AbYBUNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765984AbYBUNOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYBUNOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:14:25 -0500
Received: from 75.neteffect.com ([204.57.75.75]:63819 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754005AbYBUNOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:14:24 -0500
Date: Thu, 21 Feb 2008 07:51:17 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211351.m1LDpH3e004925@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 1/8] infiniband/hw/nes/nes_verbs.c: address dead code warning in nes_verbs.c
Cc: bunk@kernel.org, ctung@neteffect.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chien Tung <ctung@neteffect.com>

Adrian Bunk found some apparently dead code in nes_verbs.c
after a coverity review that really shouldn't have been dead.  

The function nes_create_cq() was missing the following assignment

	err = 1;

just prior to an iteration that conditionally set err = 0
if a PBL was found for a given virtual CQ.  Also noticed 
we should have been returning -EFAULT on a couple related
error paths.

Signed-off-by: Chien Tung <ctung@neteffect.com>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 4dafbe1..201b95e 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1327,7 +1327,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 								  (long long unsigned int)req.user_wqe_buffers);
 							nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
 							kfree(nesqp->allocated_buffer);
-							return ERR_PTR(-ENOMEM);
+							return ERR_PTR(-EFAULT);
 						}
 					}
 
@@ -1674,6 +1674,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 		}
 		nes_debug(NES_DBG_CQ, "CQ Virtual Address = %08lX, size = %u.\n",
 				(unsigned long)req.user_cq_buffer, entries);
+		err = 1;
 		list_for_each_entry(nespbl, &nes_ucontext->cq_reg_mem_list, list) {
 			if (nespbl->user_base == (unsigned long )req.user_cq_buffer) {
 				list_del(&nespbl->list);
@@ -1686,7 +1687,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 		if (err) {
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 			kfree(nescq);
-			return ERR_PTR(err);
+			return ERR_PTR(-EFAULT);
 		}
 
 		pbl_entries = nespbl->pbl_size >> 3;
