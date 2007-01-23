Return-Path: <linux-kernel-owner+w=401wt.eu-S965588AbXAWXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588AbXAWXRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965590AbXAWXRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:17:21 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:2583 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965588AbXAWXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:17:20 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org
Subject: [PATCH 2.6.21 3/4] ehca: remove do_mmap()
Date: Wed, 24 Jan 2007 00:13:35 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240013.37135.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes do_mmap() from ehca:
- Call remap_pfn_range() for hardware register block
- Use vm_insert_page() to register memory allocated for completion queues
and queue pairs
- The actual mmap() call/trigger is now controlled by user space, ie. libehca

Thanks
Nam


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_classes.h |   15 +-
 ehca_cq.c      |   65 ++-------
 ehca_iverbs.h  |    8 -
 ehca_main.c    |    6 
 ehca_qp.c      |   78 ++---------
 ehca_uverbs.c  |  395 +++++++++++++++++++++++----------------------------------
 6 files changed, 204 insertions(+), 363 deletions(-)


diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_classes.h	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_classes.h	2007-01-20 00:21:21.000000000 +0100
@@ -119,13 +119,14 @@ struct ehca_qp {
 	struct ipz_qp_handle ipz_qp_handle;
 	struct ehca_pfqp pf;
 	struct ib_qp_init_attr init_attr;
-	u64 uspace_squeue;
-	u64 uspace_rqueue;
-	u64 uspace_fwh;
 	struct ehca_cq *send_cq;
 	struct ehca_cq *recv_cq;
 	unsigned int sqerr_purgeflag;
 	struct hlist_node list_entries;
+	/* mmap counter for resources mapped into user space */
+	u32 mm_count_squeue;
+	u32 mm_count_rqueue;
+	u32 mm_count_galpa;
 };
 
 /* must be power of 2 */
@@ -142,13 +143,14 @@ struct ehca_cq {
 	struct ipz_cq_handle ipz_cq_handle;
 	struct ehca_pfcq pf;
 	spinlock_t cb_lock;
-	u64 uspace_queue;
-	u64 uspace_fwh;
 	struct hlist_head qp_hashtab[QP_HASHTAB_LEN];
 	struct list_head entry;
 	u32 nr_callbacks;
 	spinlock_t task_lock;
 	u32 ownpid;
+	/* mmap counter for resources mapped into user space */
+	u32 mm_count_queue;
+	u32 mm_count_galpa;
 };
 
 enum ehca_mr_flag {
@@ -283,7 +285,6 @@ extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 
 struct ipzu_queue_resp {
-	u64 queue;        /* points to first queue entry */
 	u32 qe_size;      /* queue entry size */
 	u32 act_nr_of_sg;
 	u32 queue_length; /* queue length allocated in bytes */
@@ -296,7 +297,6 @@ struct ehca_create_cq_resp {
 	u32 cq_number;
 	u32 token;
 	struct ipzu_queue_resp ipz_queue;
-	struct h_galpas galpas;
 };
 
 struct ehca_create_qp_resp {
@@ -309,7 +309,6 @@ struct ehca_create_qp_resp {
 	u32 dummy; /* padding for 8 byte alignment */
 	struct ipzu_queue_resp ipz_squeue;
 	struct ipzu_queue_resp ipz_rqueue;
-	struct h_galpas galpas;
 };
 
 struct ehca_alloc_cq_parms {
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_cq.c	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_cq.c	2007-01-20 00:21:21.000000000 +0100
@@ -267,7 +267,6 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	if (context) {
 		struct ipz_queue *ipz_queue = &my_cq->ipz_queue;
 		struct ehca_create_cq_resp resp;
-		struct vm_area_struct *vma;
 		memset(&resp, 0, sizeof(resp));
 		resp.cq_number = my_cq->cq_number;
 		resp.token = my_cq->token;
@@ -276,40 +275,14 @@ struct ib_cq *ehca_create_cq(struct ib_d
 		resp.ipz_queue.queue_length = ipz_queue->queue_length;
 		resp.ipz_queue.pagesize = ipz_queue->pagesize;
 		resp.ipz_queue.toggle_state = ipz_queue->toggle_state;
-		ret = ehca_mmap_nopage(((u64)(my_cq->token) << 32) | 0x12000000,
-				       ipz_queue->queue_length,
-				       (void**)&resp.ipz_queue.queue,
-				       &vma);
-		if (ret) {
-			ehca_err(device, "Could not mmap queue pages");
-			cq = ERR_PTR(ret);
-			goto create_cq_exit4;
-		}
-		my_cq->uspace_queue = resp.ipz_queue.queue;
-		resp.galpas = my_cq->galpas;
-		ret = ehca_mmap_register(my_cq->galpas.user.fw_handle,
-					 (void**)&resp.galpas.kernel.fw_handle,
-					 &vma);
-		if (ret) {
-			ehca_err(device, "Could not mmap fw_handle");
-			cq = ERR_PTR(ret);
-			goto create_cq_exit5;
-		}
-		my_cq->uspace_fwh = (u64)resp.galpas.kernel.fw_handle;
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
-			goto create_cq_exit6;
+			goto create_cq_exit4;
 		}
 	}
 
 	return cq;
 
-create_cq_exit6:
-	ehca_munmap(my_cq->uspace_fwh, EHCA_PAGESIZE);
-
-create_cq_exit5:
-	ehca_munmap(my_cq->uspace_queue, my_cq->ipz_queue.queue_length);
-
 create_cq_exit4:
 	ipz_queue_dtor(&my_cq->ipz_queue);
 
@@ -333,7 +306,6 @@ create_cq_exit1:
 int ehca_destroy_cq(struct ib_cq *cq)
 {
 	u64 h_ret;
-	int ret;
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
 	int cq_num = my_cq->cq_number;
 	struct ib_device *device = cq->device;
@@ -343,6 +315,20 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	u32 cur_pid = current->tgid;
 	unsigned long flags;
 
+	if (cq->uobject) {
+		if (my_cq->mm_count_galpa || my_cq->mm_count_queue) {
+			ehca_err(device, "Resources still referenced in "
+				 "user space cq_num=%x", my_cq->cq_number);
+			return -EINVAL;
+		}
+		if (my_cq->ownpid != cur_pid) {
+			ehca_err(device, "Invalid caller pid=%x ownpid=%x "
+				 "cq_num=%x",
+				 cur_pid, my_cq->ownpid, my_cq->cq_number);
+			return -EINVAL;
+		}
+	}
+
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 	while (my_cq->nr_callbacks) {
 		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
@@ -353,25 +339,6 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	idr_remove(&ehca_cq_idr, my_cq->token);
 	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
-	if (my_cq->uspace_queue && my_cq->ownpid != cur_pid) {
-		ehca_err(device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_cq->ownpid);
-		return -EINVAL;
-	}
-
-	/* un-mmap if vma alloc */
-	if (my_cq->uspace_queue ) {
-		ret = ehca_munmap(my_cq->uspace_queue,
-				  my_cq->ipz_queue.queue_length);
-		if (ret)
-			ehca_err(device, "Could not munmap queue ehca_cq=%p "
-				 "cq_num=%x", my_cq, cq_num);
-		ret = ehca_munmap(my_cq->uspace_fwh, EHCA_PAGESIZE);
-		if (ret)
-			ehca_err(device, "Could not munmap fwh ehca_cq=%p "
-				 "cq_num=%x", my_cq, cq_num);
-	}
-
 	h_ret = hipz_h_destroy_cq(adapter_handle, my_cq, 0);
 	if (h_ret == H_R_STATE) {
 		/* cq in err: read err data and destroy it forcibly */
@@ -400,7 +367,7 @@ int ehca_resize_cq(struct ib_cq *cq, int
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
 	u32 cur_pid = current->tgid;
 
-	if (my_cq->uspace_queue && my_cq->ownpid != cur_pid) {
+	if (cq->uobject && my_cq->ownpid != cur_pid) {
 		ehca_err(cq->device, "Invalid caller pid=%x ownpid=%x",
 			 cur_pid, my_cq->ownpid);
 		return -EINVAL;
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_iverbs.h infiniband_work/drivers/infiniband/hw/ehca/ehca_iverbs.h
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_iverbs.h	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_iverbs.h	2007-01-20 00:21:21.000000000 +0100
@@ -171,14 +171,6 @@ int ehca_mmap(struct ib_ucontext *contex
 
 void ehca_poll_eqs(unsigned long data);
 
-int ehca_mmap_nopage(u64 foffset,u64 length,void **mapped,
-		     struct vm_area_struct **vma);
-
-int ehca_mmap_register(u64 physical,void **mapped,
-		       struct vm_area_struct **vma);
-
-int ehca_munmap(unsigned long addr, size_t len);
-
 #ifdef CONFIG_PPC_64K_PAGES
 void *ehca_alloc_fw_ctrlblock(gfp_t flags);
 void ehca_free_fw_ctrlblock(void *ptr);
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_main.c	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_main.c	2007-01-20 00:21:21.000000000 +0100
@@ -52,7 +52,7 @@
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
-MODULE_VERSION("SVNEHCA_0019");
+MODULE_VERSION("SVNEHCA_0020");
 
 int ehca_open_aqp1     = 0;
 int ehca_debug_level   = 0;
@@ -288,7 +288,7 @@ int ehca_init_device(struct ehca_shca *s
 	strlcpy(shca->ib_device.name, "ehca%d", IB_DEVICE_NAME_MAX);
 	shca->ib_device.owner               = THIS_MODULE;
 
-	shca->ib_device.uverbs_abi_ver	    = 5;
+	shca->ib_device.uverbs_abi_ver	    = 6;
 	shca->ib_device.uverbs_cmd_mask	    =
 		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_DEVICE)	|
@@ -790,7 +790,7 @@ int __init ehca_module_init(void)
 	int ret;
 
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
-	                 "(Rel.: SVNEHCA_0019)\n");
+	                 "(Rel.: SVNEHCA_0020)\n");
 	idr_init(&ehca_qp_idr);
 	idr_init(&ehca_cq_idr);
 	spin_lock_init(&ehca_qp_idr_lock);
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_qp.c infiniband_work/drivers/infiniband/hw/ehca/ehca_qp.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_qp.c	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_qp.c	2007-01-20 00:21:21.000000000 +0100
@@ -637,7 +637,6 @@ struct ib_qp *ehca_create_qp(struct ib_p
 		struct ipz_queue *ipz_rqueue = &my_qp->ipz_rqueue;
 		struct ipz_queue *ipz_squeue = &my_qp->ipz_squeue;
 		struct ehca_create_qp_resp resp;
-		struct vm_area_struct * vma;
 		memset(&resp, 0, sizeof(resp));
 
 		resp.qp_num = my_qp->real_qp_num;
@@ -651,59 +650,21 @@ struct ib_qp *ehca_create_qp(struct ib_p
 		resp.ipz_rqueue.queue_length = ipz_rqueue->queue_length;
 		resp.ipz_rqueue.pagesize = ipz_rqueue->pagesize;
 		resp.ipz_rqueue.toggle_state = ipz_rqueue->toggle_state;
-		ret = ehca_mmap_nopage(((u64)(my_qp->token) << 32) | 0x22000000,
-				       ipz_rqueue->queue_length,
-				       (void**)&resp.ipz_rqueue.queue,
-				       &vma);
-		if (ret) {
-			ehca_err(pd->device, "Could not mmap rqueue pages");
-			goto create_qp_exit3;
-		}
-		my_qp->uspace_rqueue = resp.ipz_rqueue.queue;
 		/* squeue properties */
 		resp.ipz_squeue.qe_size = ipz_squeue->qe_size;
 		resp.ipz_squeue.act_nr_of_sg = ipz_squeue->act_nr_of_sg;
 		resp.ipz_squeue.queue_length = ipz_squeue->queue_length;
 		resp.ipz_squeue.pagesize = ipz_squeue->pagesize;
 		resp.ipz_squeue.toggle_state = ipz_squeue->toggle_state;
-		ret = ehca_mmap_nopage(((u64)(my_qp->token) << 32) | 0x23000000,
-				       ipz_squeue->queue_length,
-				       (void**)&resp.ipz_squeue.queue,
-				       &vma);
-		if (ret) {
-			ehca_err(pd->device, "Could not mmap squeue pages");
-			goto create_qp_exit4;
-		}
-		my_qp->uspace_squeue = resp.ipz_squeue.queue;
-		/* fw_handle */
-		resp.galpas = my_qp->galpas;
-		ret = ehca_mmap_register(my_qp->galpas.user.fw_handle,
-					 (void**)&resp.galpas.kernel.fw_handle,
-					 &vma);
-		if (ret) {
-			ehca_err(pd->device, "Could not mmap fw_handle");
-			goto create_qp_exit5;
-		}
-		my_qp->uspace_fwh = (u64)resp.galpas.kernel.fw_handle;
-
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
-			goto create_qp_exit6;
+			goto create_qp_exit3;
 		}
 	}
 
 	return &my_qp->ib_qp;
 
-create_qp_exit6:
-	ehca_munmap(my_qp->uspace_fwh, EHCA_PAGESIZE);
-
-create_qp_exit5:
-	ehca_munmap(my_qp->uspace_squeue, my_qp->ipz_squeue.queue_length);
-
-create_qp_exit4:
-	ehca_munmap(my_qp->uspace_rqueue, my_qp->ipz_rqueue.queue_length);
-
 create_qp_exit3:
 	ipz_queue_dtor(&my_qp->ipz_rqueue);
 	ipz_queue_dtor(&my_qp->ipz_squeue);
@@ -931,7 +892,7 @@ static int internal_modify_qp(struct ib_
 	     my_qp->qp_type == IB_QPT_SMI) &&
 	    statetrans == IB_QPST_SQE2RTS) {
 		/* mark next free wqe if kernel */
-		if (my_qp->uspace_squeue == 0) {
+		if (!ibqp->uobject) {
 			struct ehca_wqe *wqe;
 			/* lock send queue */
 			spin_lock_irqsave(&my_qp->spinlock_s, spl_flags);
@@ -1417,11 +1378,18 @@ int ehca_destroy_qp(struct ib_qp *ibqp)
 	enum ib_qp_type	qp_type;
 	unsigned long flags;
 
-	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
-	    my_pd->ownpid != cur_pid) {
-		ehca_err(ibqp->device, "Invalid caller pid=%x ownpid=%x",
-			 cur_pid, my_pd->ownpid);
-		return -EINVAL;
+	if (ibqp->uobject) {
+		if (my_qp->mm_count_galpa ||
+		    my_qp->mm_count_rqueue || my_qp->mm_count_squeue) {
+			ehca_err(ibqp->device, "Resources still referenced in "
+				 "user space qp_num=%x", ibqp->qp_num);
+			return -EINVAL;
+		}
+		if (my_pd->ownpid != cur_pid) {
+			ehca_err(ibqp->device, "Invalid caller pid=%x ownpid=%x",
+				 cur_pid, my_pd->ownpid);
+			return -EINVAL;
+		}
 	}
 
 	if (my_qp->send_cq) {
@@ -1439,24 +1407,6 @@ int ehca_destroy_qp(struct ib_qp *ibqp)
 	idr_remove(&ehca_qp_idr, my_qp->token);
 	spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
 
-	/* un-mmap if vma alloc */
-	if (my_qp->uspace_rqueue) {
-		ret = ehca_munmap(my_qp->uspace_rqueue,
-				  my_qp->ipz_rqueue.queue_length);
-		if (ret)
-			ehca_err(ibqp->device, "Could not munmap rqueue "
-				 "qp_num=%x", qp_num);
-		ret = ehca_munmap(my_qp->uspace_squeue,
-				  my_qp->ipz_squeue.queue_length);
-		if (ret)
-			ehca_err(ibqp->device, "Could not munmap squeue "
-				 "qp_num=%x", qp_num);
-		ret = ehca_munmap(my_qp->uspace_fwh, EHCA_PAGESIZE);
-		if (ret)
-			ehca_err(ibqp->device, "Could not munmap fwh qp_num=%x",
-				 qp_num);
-	}
-
 	h_ret = hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
 	if (h_ret != H_SUCCESS) {
 		ehca_err(ibqp->device, "hipz_h_destroy_qp() failed rc=%lx "
diff -Nurp infiniband_orig/drivers/infiniband/hw/ehca/ehca_uverbs.c infiniband_work/drivers/infiniband/hw/ehca/ehca_uverbs.c
--- infiniband_orig/drivers/infiniband/hw/ehca/ehca_uverbs.c	2007-01-20 00:19:10.000000000 +0100
+++ infiniband_work/drivers/infiniband/hw/ehca/ehca_uverbs.c	2007-01-20 00:21:21.000000000 +0100
@@ -68,105 +68,183 @@ int ehca_dealloc_ucontext(struct ib_ucon
 	return 0;
 }
 
-struct page *ehca_nopage(struct vm_area_struct *vma,
-			 unsigned long address, int *type)
+static void ehca_mm_open(struct vm_area_struct *vma)
 {
-	struct page *mypage = NULL;
-	u64 fileoffset = vma->vm_pgoff << PAGE_SHIFT;
-	u32 idr_handle = fileoffset >> 32;
-	u32 q_type = (fileoffset >> 28) & 0xF;	  /* CQ, QP,...        */
-	u32 rsrc_type = (fileoffset >> 24) & 0xF; /* sq,rq,cmnd_window */
-	u32 cur_pid = current->tgid;
-	unsigned long flags;
-	struct ehca_cq *cq;
-	struct ehca_qp *qp;
-	struct ehca_pd *pd;
-	u64 offset;
-	void *vaddr;
+	u32 *count = (u32*)vma->vm_private_data;
+	if (!count) {
+		ehca_gen_err("Invalid vma struct vm_start=%lx vm_end=%lx",
+			     vma->vm_start, vma->vm_end);
+		return;
+	}
+	(*count)++;
+	if (!(*count))
+		ehca_gen_err("Use count overflow vm_start=%lx vm_end=%lx",
+			     vma->vm_start, vma->vm_end);
+	ehca_gen_dbg("vm_start=%lx vm_end=%lx count=%x",
+		     vma->vm_start, vma->vm_end, *count);
+}
 
-	switch (q_type) {
-	case 1: /* CQ */
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-		cq = idr_find(&ehca_cq_idr, idr_handle);
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+static void ehca_mm_close(struct vm_area_struct *vma)
+{
+	u32 *count = (u32*)vma->vm_private_data;
+	if (!count) {
+		ehca_gen_err("Invalid vma struct vm_start=%lx vm_end=%lx",
+			     vma->vm_start, vma->vm_end);
+		return;
+	}
+	(*count)--;
+	ehca_gen_dbg("vm_start=%lx vm_end=%lx count=%x",
+		     vma->vm_start, vma->vm_end, *count);
+}
 
-		/* make sure this mmap really belongs to the authorized user */
-		if (!cq) {
-			ehca_gen_err("cq is NULL ret=NOPAGE_SIGBUS");
-			return NOPAGE_SIGBUS;
+static struct vm_operations_struct vm_ops = {
+	.open =	ehca_mm_open,
+	.close = ehca_mm_close,
+};
+
+static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
+			u32 *mm_count)
+{
+	int ret;
+	u64 vsize, physical;
+
+	vsize = vma->vm_end - vma->vm_start;
+	if (vsize != EHCA_PAGESIZE) {
+		ehca_gen_err("invalid vsize=%lx", vma->vm_end - vma->vm_start);
+		return -EINVAL;
+	}
+
+	physical = galpas->user.fw_handle;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	ehca_gen_dbg("vsize=%lx physical=%lx", vsize, physical);
+	/* VM_IO | VM_RESERVED are set by remap_pfn_range() */
+	ret = remap_pfn_range(vma, vma->vm_start, physical >> PAGE_SHIFT,
+			      vsize, vma->vm_page_prot);
+	if (unlikely(ret)) {
+		ehca_gen_err("remap_pfn_range() failed ret=%x", ret);
+		return -ENOMEM;
+	}
+
+	vma->vm_private_data = mm_count;
+	(*mm_count)++;
+	vma->vm_ops = &vm_ops;
+
+	return 0;
+}
+
+static int ehca_mmap_queue(struct vm_area_struct *vma, struct ipz_queue *queue,
+			   u32 *mm_count)
+{
+	int ret;
+	u64 start, ofs;
+	struct page *page;
+
+	vma->vm_flags |= VM_RESERVED;
+	start = vma->vm_start;
+	for (ofs = 0; ofs < queue->queue_length; ofs += PAGE_SIZE) {
+		u64 virt_addr = (u64)ipz_qeit_calc(queue, ofs);
+		page = virt_to_page(virt_addr);
+		ret = vm_insert_page(vma, start, page);
+		if (unlikely(ret)) {
+			ehca_gen_err("vm_insert_page() failed rc=%x", ret);
+			return ret;
 		}
+		start +=  PAGE_SIZE;
+	}
+	vma->vm_private_data = mm_count;
+	(*mm_count)++;
+	vma->vm_ops = &vm_ops;
 
-		if (cq->ownpid != cur_pid) {
+	return 0;
+}
+
+static int ehca_mmap_cq(struct vm_area_struct *vma, struct ehca_cq *cq,
+			u32 rsrc_type)
+{
+	int ret;
+
+	switch (rsrc_type) {
+	case 1: /* galpa fw handle */
+		ehca_dbg(cq->ib_cq.device, "cq_num=%x fw", cq->cq_number);
+		ret = ehca_mmap_fw(vma, &cq->galpas, &cq->mm_count_galpa);
+		if (unlikely(ret)) {
 			ehca_err(cq->ib_cq.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, cq->ownpid);
-			return NOPAGE_SIGBUS;
+				 "ehca_mmap_fw() failed rc=%x cq_num=%x",
+				 ret, cq->cq_number);
+			return ret;
 		}
+		break;
 
-		if (rsrc_type == 2) {
-			ehca_dbg(cq->ib_cq.device, "cq=%p cq queuearea", cq);
-			offset = address - vma->vm_start;
-			vaddr = ipz_qeit_calc(&cq->ipz_queue, offset);
-			ehca_dbg(cq->ib_cq.device, "offset=%lx vaddr=%p",
-				 offset, vaddr);
-			mypage = virt_to_page(vaddr);
+	case 2: /* cq queue_addr */
+		ehca_dbg(cq->ib_cq.device, "cq_num=%x queue", cq->cq_number);
+		ret = ehca_mmap_queue(vma, &cq->ipz_queue, &cq->mm_count_queue);
+		if (unlikely(ret)) {
+			ehca_err(cq->ib_cq.device,
+				 "ehca_mmap_queue() failed rc=%x cq_num=%x",
+				 ret, cq->cq_number);
+			return ret;
 		}
 		break;
 
-	case 2: /* QP */
-		spin_lock_irqsave(&ehca_qp_idr_lock, flags);
-		qp = idr_find(&ehca_qp_idr, idr_handle);
-		spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	default:
+		ehca_err(cq->ib_cq.device, "bad resource type=%x cq_num=%x",
+			 rsrc_type, cq->cq_number);
+		return -EINVAL;
+	}
 
-		/* make sure this mmap really belongs to the authorized user */
-		if (!qp) {
-			ehca_gen_err("qp is NULL ret=NOPAGE_SIGBUS");
-			return NOPAGE_SIGBUS;
+	return 0;
+}
+
+static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
+			u32 rsrc_type)
+{
+	int ret;
+
+	switch (rsrc_type) {
+	case 1: /* galpa fw handle */
+		ehca_dbg(qp->ib_qp.device, "qp_num=%x fw", qp->ib_qp.qp_num);
+		ret = ehca_mmap_fw(vma, &qp->galpas, &qp->mm_count_galpa);
+		if (unlikely(ret)) {
+			ehca_err(qp->ib_qp.device,
+				 "remap_pfn_range() failed ret=%x qp_num=%x",
+				 ret, qp->ib_qp.qp_num);
+			return -ENOMEM;
 		}
+		break;
 
-		pd = container_of(qp->ib_qp.pd, struct ehca_pd, ib_pd);
-		if (pd->ownpid != cur_pid) {
+	case 2: /* qp rqueue_addr */
+		ehca_dbg(qp->ib_qp.device, "qp_num=%x rqueue",
+			 qp->ib_qp.qp_num);
+		ret = ehca_mmap_queue(vma, &qp->ipz_rqueue, &qp->mm_count_rqueue);
+		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
-				 "Invalid caller pid=%x ownpid=%x",
-				 cur_pid, pd->ownpid);
-			return NOPAGE_SIGBUS;
+				 "ehca_mmap_queue(rq) failed rc=%x qp_num=%x",
+				 ret, qp->ib_qp.qp_num);
+			return ret;
 		}
+		break;
 
-		if (rsrc_type == 2) {	/* rqueue */
-			ehca_dbg(qp->ib_qp.device, "qp=%p qp rqueuearea", qp);
-			offset = address - vma->vm_start;
-			vaddr = ipz_qeit_calc(&qp->ipz_rqueue, offset);
-			ehca_dbg(qp->ib_qp.device, "offset=%lx vaddr=%p",
-				 offset, vaddr);
-			mypage = virt_to_page(vaddr);
-		} else if (rsrc_type == 3) {	/* squeue */
-			ehca_dbg(qp->ib_qp.device, "qp=%p qp squeuearea", qp);
-			offset = address - vma->vm_start;
-			vaddr = ipz_qeit_calc(&qp->ipz_squeue, offset);
-			ehca_dbg(qp->ib_qp.device, "offset=%lx vaddr=%p",
-				 offset, vaddr);
-			mypage = virt_to_page(vaddr);
+	case 3: /* qp squeue_addr */
+		ehca_dbg(qp->ib_qp.device, "qp_num=%x squeue",
+			 qp->ib_qp.qp_num);
+		ret = ehca_mmap_queue(vma, &qp->ipz_squeue, &qp->mm_count_squeue);
+		if (unlikely(ret)) {
+			ehca_err(qp->ib_qp.device,
+				 "ehca_mmap_queue(sq) failed rc=%x qp_num=%x",
+				 ret, qp->ib_qp.qp_num);
+			return ret;
 		}
 		break;
 
 	default:
-		ehca_gen_err("bad queue type %x", q_type);
-		return NOPAGE_SIGBUS;
-	}
-
-	if (!mypage) {
-		ehca_gen_err("Invalid page adr==NULL ret=NOPAGE_SIGBUS");
-		return NOPAGE_SIGBUS;
+		ehca_err(qp->ib_qp.device, "bad resource type=%x qp=num=%x",
+			 rsrc_type, qp->ib_qp.qp_num);
+		return -EINVAL;
 	}
-	get_page(mypage);
 
-	return mypage;
+	return 0;
 }
 
-static struct vm_operations_struct ehcau_vm_ops = {
-	.nopage = ehca_nopage,
-};
-
 int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
 	u64 fileoffset = vma->vm_pgoff << PAGE_SHIFT;
@@ -175,7 +253,6 @@ int ehca_mmap(struct ib_ucontext *contex
 	u32 rsrc_type = (fileoffset >> 24) & 0xF; /* sq,rq,cmnd_window */
 	u32 cur_pid = current->tgid;
 	u32 ret;
-	u64 vsize, physical;
 	unsigned long flags;
 	struct ehca_cq *cq;
 	struct ehca_qp *qp;
@@ -201,44 +278,12 @@ int ehca_mmap(struct ib_ucontext *contex
 		if (!cq->ib_cq.uobject || cq->ib_cq.uobject->context != context)
 			return -EINVAL;
 
-		switch (rsrc_type) {
-		case 1: /* galpa fw handle */
-			ehca_dbg(cq->ib_cq.device, "cq=%p cq triggerarea", cq);
-			vma->vm_flags |= VM_RESERVED;
-			vsize = vma->vm_end - vma->vm_start;
-			if (vsize != EHCA_PAGESIZE) {
-				ehca_err(cq->ib_cq.device, "invalid vsize=%lx",
-					 vma->vm_end - vma->vm_start);
-				return -EINVAL;
-			}
-
-			physical = cq->galpas.user.fw_handle;
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-			vma->vm_flags |= VM_IO | VM_RESERVED;
-
-			ehca_dbg(cq->ib_cq.device,
-				 "vsize=%lx physical=%lx", vsize, physical);
-			ret = remap_pfn_range(vma, vma->vm_start,
-					      physical >> PAGE_SHIFT, vsize,
-					      vma->vm_page_prot);
-			if (ret) {
-				ehca_err(cq->ib_cq.device,
-					 "remap_pfn_range() failed ret=%x",
-					 ret);
-				return -ENOMEM;
-			}
-			break;
-
-		case 2: /* cq queue_addr */
-			ehca_dbg(cq->ib_cq.device, "cq=%p cq q_addr", cq);
-			vma->vm_flags |= VM_RESERVED;
-			vma->vm_ops = &ehcau_vm_ops;
-			break;
-
-		default:
-			ehca_err(cq->ib_cq.device, "bad resource type %x",
-				 rsrc_type);
-			return -EINVAL;
+		ret = ehca_mmap_cq(vma, cq, rsrc_type);
+		if (unlikely(ret)) {
+			ehca_err(cq->ib_cq.device,
+				 "ehca_mmap_cq() failed rc=%x cq_num=%x",
+				 ret, cq->cq_number);
+			return ret;
 		}
 		break;
 
@@ -262,50 +307,12 @@ int ehca_mmap(struct ib_ucontext *contex
 		if (!qp->ib_qp.uobject || qp->ib_qp.uobject->context != context)
 			return -EINVAL;
 
-		switch (rsrc_type) {
-		case 1: /* galpa fw handle */
-			ehca_dbg(qp->ib_qp.device, "qp=%p qp triggerarea", qp);
-			vma->vm_flags |= VM_RESERVED;
-			vsize = vma->vm_end - vma->vm_start;
-			if (vsize != EHCA_PAGESIZE) {
-				ehca_err(qp->ib_qp.device, "invalid vsize=%lx",
-					 vma->vm_end - vma->vm_start);
-				return -EINVAL;
-			}
-
-			physical = qp->galpas.user.fw_handle;
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-			vma->vm_flags |= VM_IO | VM_RESERVED;
-
-			ehca_dbg(qp->ib_qp.device, "vsize=%lx physical=%lx",
-				 vsize, physical);
-			ret = remap_pfn_range(vma, vma->vm_start,
-					      physical >> PAGE_SHIFT, vsize,
-					      vma->vm_page_prot);
-			if (ret) {
-				ehca_err(qp->ib_qp.device,
-					 "remap_pfn_range() failed ret=%x",
-					 ret);
-				return -ENOMEM;
-			}
-			break;
-
-		case 2: /* qp rqueue_addr */
-			ehca_dbg(qp->ib_qp.device, "qp=%p qp rqueue_addr", qp);
-			vma->vm_flags |= VM_RESERVED;
-			vma->vm_ops = &ehcau_vm_ops;
-			break;
-
-		case 3: /* qp squeue_addr */
-			ehca_dbg(qp->ib_qp.device, "qp=%p qp squeue_addr", qp);
-			vma->vm_flags |= VM_RESERVED;
-			vma->vm_ops = &ehcau_vm_ops;
-			break;
-
-		default:
-			ehca_err(qp->ib_qp.device, "bad resource type %x",
-				 rsrc_type);
-			return -EINVAL;
+		ret = ehca_mmap_qp(vma, qp, rsrc_type);
+		if (unlikely(ret)) {
+			ehca_err(qp->ib_qp.device,
+				 "ehca_mmap_qp() failed rc=%x qp_num=%x",
+				 ret, qp->ib_qp.qp_num);
+			return ret;
 		}
 		break;
 
@@ -316,77 +323,3 @@ int ehca_mmap(struct ib_ucontext *contex
 
 	return 0;
 }
-
-int ehca_mmap_nopage(u64 foffset, u64 length, void **mapped,
-		     struct vm_area_struct **vma)
-{
-	down_write(&current->mm->mmap_sem);
-	*mapped = (void*)do_mmap(NULL,0, length, PROT_WRITE,
-				 MAP_SHARED | MAP_ANONYMOUS,
-				 foffset);
-	up_write(&current->mm->mmap_sem);
-	if (!(*mapped)) {
-		ehca_gen_err("couldn't mmap foffset=%lx length=%lx",
-			     foffset, length);
-		return -EINVAL;
-	}
-
-	*vma = find_vma(current->mm, (u64)*mapped);
-	if (!(*vma)) {
-		down_write(&current->mm->mmap_sem);
-		do_munmap(current->mm, 0, length);
-		up_write(&current->mm->mmap_sem);
-		ehca_gen_err("couldn't find vma queue=%p", *mapped);
-		return -EINVAL;
-	}
-	(*vma)->vm_flags |= VM_RESERVED;
-	(*vma)->vm_ops = &ehcau_vm_ops;
-
-	return 0;
-}
-
-int ehca_mmap_register(u64 physical, void **mapped,
-		       struct vm_area_struct **vma)
-{
-	int ret;
-	unsigned long vsize;
-	/* ehca hw supports only 4k page */
-	ret = ehca_mmap_nopage(0, EHCA_PAGESIZE, mapped, vma);
-	if (ret) {
-		ehca_gen_err("could'nt mmap physical=%lx", physical);
-		return ret;
-	}
-
-	(*vma)->vm_flags |= VM_RESERVED;
-	vsize = (*vma)->vm_end - (*vma)->vm_start;
-	if (vsize != EHCA_PAGESIZE) {
-		ehca_gen_err("invalid vsize=%lx",
-			     (*vma)->vm_end - (*vma)->vm_start);
-		return -EINVAL;
-	}
-
-	(*vma)->vm_page_prot = pgprot_noncached((*vma)->vm_page_prot);
-	(*vma)->vm_flags |= VM_IO | VM_RESERVED;
-
-	ret = remap_pfn_range((*vma), (*vma)->vm_start,
-			      physical >> PAGE_SHIFT, vsize,
-			      (*vma)->vm_page_prot);
-	if (ret) {
-		ehca_gen_err("remap_pfn_range() failed ret=%x", ret);
-		return -ENOMEM;
-	}
-
-	return 0;
-
-}
-
-int ehca_munmap(unsigned long addr, size_t len) {
-	int ret = 0;
-	struct mm_struct *mm = current->mm;
-	if (mm) {
-		down_write(&mm->mmap_sem);
-		ret = do_munmap(mm, addr, len);
-		up_write(&mm->mmap_sem);
-	}
-	return ret;
-}
