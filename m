Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbYBSTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbYBSTaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbYBST3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:29:49 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55846 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760385AbYBST3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:48 -0500
Date: Tue, 19 Feb 2008 21:29:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/nes/nes_verbs.c: remove dead code
Message-ID: <20080219192912.GG31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/infiniband/hw/nes/nes_verbs.c |    6 ------
 1 file changed, 6 deletions(-)

--- linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c.old	2008-02-19 20:23:02.000000000 +0200
+++ linux-2.6/drivers/infiniband/hw/nes/nes_verbs.c	2008-02-19 20:24:34.000000000 +0200
@@ -1638,95 +1638,89 @@ static struct ib_cq *nes_create_cq(struc
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_cqs,
 			nesadapter->max_cq, &cq_num, &nesadapter->next_cq);
 	if (err) {
 		return ERR_PTR(err);
 	}
 
 	nescq = kzalloc(sizeof(struct nes_cq), GFP_KERNEL);
 	if (!nescq) {
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 		nes_debug(NES_DBG_CQ, "Unable to allocate nes_cq struct\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
 	nescq->hw_cq.cq_size = max(entries + 1, 5);
 	nescq->hw_cq.cq_number = cq_num;
 	nescq->ibcq.cqe = nescq->hw_cq.cq_size - 1;
 
 
 	if (context) {
 		nes_ucontext = to_nesucontext(context);
 		if (ib_copy_from_udata(&req, udata, sizeof (struct nes_create_cq_req))) {
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 			kfree(nescq);
 			return ERR_PTR(-EFAULT);
 		}
 		nesvnic->mcrq_ucontext = nes_ucontext;
 		nes_ucontext->mcrqf = req.mcrqf;
 		if (nes_ucontext->mcrqf) {
 			if (nes_ucontext->mcrqf & 0x80000000)
 				nescq->hw_cq.cq_number = nesvnic->nic.qp_id + 12 + (nes_ucontext->mcrqf & 0xf) - 1;
 			else if (nes_ucontext->mcrqf & 0x40000000)
 				nescq->hw_cq.cq_number = nes_ucontext->mcrqf & 0xffff;
 			else
 				nescq->hw_cq.cq_number = nesvnic->mcrq_qp_id + nes_ucontext->mcrqf-1;
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 		}
 		nes_debug(NES_DBG_CQ, "CQ Virtual Address = %08lX, size = %u.\n",
 				(unsigned long)req.user_cq_buffer, entries);
 		list_for_each_entry(nespbl, &nes_ucontext->cq_reg_mem_list, list) {
 			if (nespbl->user_base == (unsigned long )req.user_cq_buffer) {
 				list_del(&nespbl->list);
-				err = 0;
 				nes_debug(NES_DBG_CQ, "Found PBL for virtual CQ. nespbl=%p.\n",
 						nespbl);
 				break;
 			}
 		}
-		if (err) {
-			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
-			kfree(nescq);
-			return ERR_PTR(err);
-		}
 
 		pbl_entries = nespbl->pbl_size >> 3;
 		nescq->cq_mem_size = 0;
 	} else {
 		nescq->cq_mem_size = nescq->hw_cq.cq_size * sizeof(struct nes_hw_cqe);
 		nes_debug(NES_DBG_CQ, "Attempting to allocate pci memory (%u entries, %u bytes) for CQ%u.\n",
 				entries, nescq->cq_mem_size, nescq->hw_cq.cq_number);
 
 		/* allocate the physical buffer space */
 		mem = pci_alloc_consistent(nesdev->pcidev, nescq->cq_mem_size,
 				&nescq->hw_cq.cq_pbase);
 		if (!mem) {
 			printk(KERN_ERR PFX "Unable to allocate pci memory for cq\n");
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 			kfree(nescq);
 			return ERR_PTR(-ENOMEM);
 		}
 
 		memset(mem, 0, nescq->cq_mem_size);
 		nescq->hw_cq.cq_vbase = mem;
 		nescq->hw_cq.cq_head = 0;
 		nes_debug(NES_DBG_CQ, "CQ%u virtual address @ %p, phys = 0x%08X\n",
 				nescq->hw_cq.cq_number, nescq->hw_cq.cq_vbase,
 				(u32)nescq->hw_cq.cq_pbase);
 	}
 
 	nescq->hw_cq.ce_handler = nes_iwarp_ce_handler;
 	spin_lock_init(&nescq->lock);
 
 	/* send CreateCQ request to CQP */
 	cqp_request = nes_get_cqp_request(nesdev);
 	if (cqp_request == NULL) {
 		nes_debug(NES_DBG_CQ, "Failed to get a cqp_request.\n");
 		if (!context)
 			pci_free_consistent(nesdev->pcidev, nescq->cq_mem_size, mem,
 					nescq->hw_cq.cq_pbase);
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
 		kfree(nescq);
 		return ERR_PTR(-ENOMEM);
 	}
 	cqp_request->waiting = 1;
 	cqp_wqe = &cqp_request->cqp_wqe;

