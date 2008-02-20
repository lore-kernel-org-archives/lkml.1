Return-Path: <linux-kernel-owner+w=401wt.eu-S1764056AbYBTBJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764056AbYBTBJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbYBTBIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:08:54 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43006 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbYBTBIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:08:54 -0500
Date: Wed, 20 Feb 2008 03:08:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix use-after-free
Message-ID: <20080220010817.GB31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a use-after-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/infiniband/hw/nes/nes_verbs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c.old	2008-02-20 03:02:13.000000000 +0200
+++ linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c	2008-02-20 03:03:20.000000000 +0200
@@ -1820,22 +1820,22 @@ static struct ib_cq *nes_create_cq(struc
 	ret = wait_event_timeout(cqp_request->waitq, (0 != cqp_request->request_done),
 			NES_EVENT_TIMEOUT * 2);
 	nes_debug(NES_DBG_CQ, "Create iWARP CQ%u completed, wait_event_timeout ret = %d.\n",
 			nescq->hw_cq.cq_number, ret);
 	if ((!ret) || (cqp_request->major_code)) {
+		nes_debug(NES_DBG_CQ, "iWARP CQ%u create timeout expired, major code = 0x%04X,"
+				" minor code = 0x%04X\n",
+				nescq->hw_cq.cq_number, cqp_request->major_code, cqp_request->minor_code);
 		if (atomic_dec_and_test(&cqp_request->refcount)) {
 			if (cqp_request->dynamic) {
 				kfree(cqp_request);
 			} else {
 				spin_lock_irqsave(&nesdev->cqp.lock, flags);
 				list_add_tail(&cqp_request->list, &nesdev->cqp_avail_reqs);
 				spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 			}
 		}
-		nes_debug(NES_DBG_CQ, "iWARP CQ%u create timeout expired, major code = 0x%04X,"
-				" minor code = 0x%04X\n",
-				nescq->hw_cq.cq_number, cqp_request->major_code, cqp_request->minor_code);
 		if (!context)
 			pci_free_consistent(nesdev->pcidev, nescq->cq_mem_size, mem,
 					nescq->hw_cq.cq_pbase);
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 		kfree(nescq);

