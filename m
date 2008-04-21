Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYDUIFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYDUIFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYDUIFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:05:32 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:39626 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYDUIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:05:29 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/5] IB/ehca: Move high-volume debug output to higher debug levels
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200804211003.10695.fenkes@de.ibm.com>
In-Reply-To: <200804211003.10695.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3040
Date: Mon, 21 Apr 2008 09:05:26 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804211005.26567.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c   |   14 ++++++--
 drivers/infiniband/hw/ehca/ehca_mrmw.c   |   16 ++++++----
 drivers/infiniband/hw/ehca/ehca_qp.c     |   12 ++++----
 drivers/infiniband/hw/ehca/ehca_reqs.c   |   46 ++++++++++++++---------------
 drivers/infiniband/hw/ehca/ehca_uverbs.c |    6 +--
 drivers/infiniband/hw/ehca/hcp_if.c      |   23 ++++++++-------
 7 files changed, 63 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index b5ca94c..ca5eb0c 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -633,7 +633,7 @@ static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 	unsigned long flags;
 
 	WARN_ON_ONCE(!in_interrupt());
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 3)
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 65b3362..4379bef 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -85,8 +85,8 @@ module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
 MODULE_PARM_DESC(open_aqp1,
 		 "AQP1 on startup (0: no (default), 1: yes)");
 MODULE_PARM_DESC(debug_level,
-		 "debug level"
-		 " (0: no debug traces (default), 1: with debug traces)");
+		 "Amount of debug output (0: none (default), 1: traces, "
+		 "2: some dumps, 3: lots)");
 MODULE_PARM_DESC(hw_level,
 		 "hardware level"
 		 " (0: autosensing (default), 1: v. 0.20, 2: v. 0.21)");
@@ -275,6 +275,7 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 	u64 h_ret;
 	struct hipz_query_hca *rblock;
 	struct hipz_query_port *port;
+	const char *loc_code;
 
 	static const u32 pgsize_map[] = {
 		HCA_CAP_MR_PGSIZE_4K,  0x1000,
@@ -283,6 +284,12 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 		HCA_CAP_MR_PGSIZE_16M, 0x1000000,
 	};
 
+	ehca_gen_dbg("Probing adapter %s...",
+		     shca->ofdev->node->full_name);
+	loc_code = of_get_property(shca->ofdev->node, "ibm,loc-code", NULL);
+	if (loc_code)
+		ehca_gen_dbg(" ... location lode=%s", loc_code);
+
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
 		ehca_gen_err("Cannot allocate rblock memory.");
@@ -567,8 +574,7 @@ static int ehca_destroy_aqp1(struct ehca_sport *sport)
 
 static ssize_t ehca_show_debug_level(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			ehca_debug_level);
+	return snprintf(buf, PAGE_SIZE, "%d\n", ehca_debug_level);
 }
 
 static ssize_t ehca_store_debug_level(struct device_driver *ddp,
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index f26997f..46ae4eb 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -1794,8 +1794,9 @@ static int ehca_check_kpages_per_ate(struct scatterlist *page_list,
 	int t;
 	for (t = start_idx; t <= end_idx; t++) {
 		u64 pgaddr = page_to_pfn(sg_page(&page_list[t])) << PAGE_SHIFT;
-		ehca_gen_dbg("chunk_page=%lx value=%016lx", pgaddr,
-			     *(u64 *)abs_to_virt(phys_to_abs(pgaddr)));
+		if (ehca_debug_level >= 3)
+			ehca_gen_dbg("chunk_page=%lx value=%016lx", pgaddr,
+				     *(u64 *)abs_to_virt(phys_to_abs(pgaddr)));
 		if (pgaddr - PAGE_SIZE != *prev_pgaddr) {
 			ehca_gen_err("uncontiguous page found pgaddr=%lx "
 				     "prev_pgaddr=%lx page_list_i=%x",
@@ -1862,10 +1863,13 @@ static int ehca_set_pagebuf_user2(struct ehca_mr_pginfo *pginfo,
 						pgaddr &
 						~(pginfo->hwpage_size - 1));
 				}
-				ehca_gen_dbg("kpage=%lx chunk_page=%lx "
-					     "value=%016lx", *kpage, pgaddr,
-					     *(u64 *)abs_to_virt(
-						     phys_to_abs(pgaddr)));
+				if (ehca_debug_level >= 3) {
+					u64 val = *(u64 *)abs_to_virt(
+						phys_to_abs(pgaddr));
+					ehca_gen_dbg("kpage=%lx chunk_page=%lx "
+						     "value=%016lx",
+						     *kpage, pgaddr, val);
+				}
 				prev_pgaddr = pgaddr;
 				i++;
 				pginfo->kpage_cnt++;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 5a653d7..57bef11 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -966,7 +966,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 		 qp_num, bad_send_wqe_p);
 	/* convert wqe pointer to vadr */
 	bad_send_wqe_v = abs_to_virt((u64)bad_send_wqe_p);
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(bad_send_wqe_v, 32, "qp_num=%x bad_wqe", qp_num);
 	squeue = &my_qp->ipz_squeue;
 	if (ipz_queue_abs_to_offset(squeue, (u64)bad_send_wqe_p, &q_ofs)) {
@@ -979,7 +979,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 	wqe = (struct ehca_wqe *)ipz_qeit_calc(squeue, q_ofs);
 	*bad_wqe_cnt = 0;
 	while (wqe->optype != 0xff && wqe->wqef != 0xff) {
-		if (ehca_debug_level)
+		if (ehca_debug_level >= 2)
 			ehca_dmp(wqe, 32, "qp_num=%x wqe", qp_num);
 		wqe->nr_of_data_seg = 0; /* suppress data access */
 		wqe->wqef = WQEF_PURGE; /* WQE to be purged */
@@ -1451,7 +1451,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		/* no support for max_send/recv_sge yet */
 	}
 
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(mqpcb, 4*70, "qp_num=%x", ibqp->qp_num);
 
 	h_ret = hipz_h_modify_qp(shca->ipz_hca_handle,
@@ -1766,7 +1766,7 @@ int ehca_query_qp(struct ib_qp *qp,
 	if (qp_init_attr)
 		*qp_init_attr = my_qp->init_attr;
 
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(qpcb, 4*70, "qp_num=%x", qp->qp_num);
 
 query_qp_exit1:
@@ -1814,7 +1814,7 @@ int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		goto modify_srq_exit0;
 	}
 
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(mqpcb, 4*70, "qp_num=%x", my_qp->real_qp_num);
 
 	h_ret = hipz_h_modify_qp(shca->ipz_hca_handle, my_qp->ipz_qp_handle,
@@ -1867,7 +1867,7 @@ int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 	srq_attr->srq_limit = EHCA_BMASK_GET(
 		MQPCB_CURR_SRQ_LIMIT, qpcb->curr_srq_limit);
 
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(qpcb, 4*70, "qp_num=%x", my_qp->real_qp_num);
 
 query_srq_exit1:
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 0b2359e..bbe0436 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -81,7 +81,7 @@ static inline int ehca_write_rwqe(struct ipz_queue *ipz_rqueue,
 			recv_wr->sg_list[cnt_ds].length;
 	}
 
-	if (ehca_debug_level) {
+	if (ehca_debug_level >= 3) {
 		ehca_gen_dbg("RECEIVE WQE written into ipz_rqueue=%p",
 			     ipz_rqueue);
 		ehca_dmp(wqe_p, 16*(6 + wqe_p->nr_of_data_seg), "recv wqe");
@@ -281,7 +281,7 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 		return -EINVAL;
 	}
 
-	if (ehca_debug_level) {
+	if (ehca_debug_level >= 3) {
 		ehca_gen_dbg("SEND WQE written into queue qp=%p ", qp);
 		ehca_dmp( wqe_p, 16*(6 + wqe_p->nr_of_data_seg), "send wqe");
 	}
@@ -459,13 +459,14 @@ int ehca_post_send(struct ib_qp *qp,
 			goto post_send_exit0;
 		}
 		wqe_cnt++;
-		ehca_dbg(qp->device, "ehca_qp=%p qp_num=%x wqe_cnt=%d",
-			 my_qp, qp->qp_num, wqe_cnt);
 	} /* eof for cur_send_wr */
 
 post_send_exit0:
 	iosync(); /* serialize GAL register access */
 	hipz_update_sqa(my_qp, wqe_cnt);
+	if (unlikely(ret || ehca_debug_level >= 2))
+		ehca_dbg(qp->device, "ehca_qp=%p qp_num=%x wqe_cnt=%d ret=%i",
+			 my_qp, qp->qp_num, wqe_cnt, ret);
 	my_qp->message_count += wqe_cnt;
 	spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
 	return ret;
@@ -525,13 +526,14 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 			goto post_recv_exit0;
 		}
 		wqe_cnt++;
-		ehca_dbg(dev, "ehca_qp=%p qp_num=%x wqe_cnt=%d",
-			 my_qp, my_qp->real_qp_num, wqe_cnt);
 	} /* eof for cur_recv_wr */
 
 post_recv_exit0:
 	iosync(); /* serialize GAL register access */
 	hipz_update_rqa(my_qp, wqe_cnt);
+	if (unlikely(ret || ehca_debug_level >= 2))
+	    ehca_dbg(dev, "ehca_qp=%p qp_num=%x wqe_cnt=%d ret=%i",
+		     my_qp, my_qp->real_qp_num, wqe_cnt, ret);
 	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
 	return ret;
 }
@@ -575,16 +577,17 @@ static inline int ehca_poll_cq_one(struct ib_cq *cq, struct ib_wc *wc)
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
 	struct ehca_cqe *cqe;
 	struct ehca_qp *my_qp;
-	int cqe_count = 0;
+	int cqe_count = 0, is_error;
 
 poll_cq_one_read_cqe:
 	cqe = (struct ehca_cqe *)
 		ipz_qeit_get_inc_valid(&my_cq->ipz_queue);
 	if (!cqe) {
 		ret = -EAGAIN;
-		ehca_dbg(cq->device, "Completion queue is empty ehca_cq=%p "
-			 "cq_num=%x ret=%i", my_cq, my_cq->cq_number, ret);
-		goto  poll_cq_one_exit0;
+		if (ehca_debug_level >= 3)
+			ehca_dbg(cq->device, "Completion queue is empty  "
+				 "my_cq=%p cq_num=%x", my_cq, my_cq->cq_number);
+		goto poll_cq_one_exit0;
 	}
 
 	/* prevents loads being reordered across this point */
@@ -614,7 +617,7 @@ poll_cq_one_read_cqe:
 			ehca_dbg(cq->device,
 				 "Got CQE with purged bit qp_num=%x src_qp=%x",
 				 cqe->local_qp_number, cqe->remote_qp_number);
-			if (ehca_debug_level)
+			if (ehca_debug_level >= 2)
 				ehca_dmp(cqe, 64, "qp_num=%x src_qp=%x",
 					 cqe->local_qp_number,
 					 cqe->remote_qp_number);
@@ -627,11 +630,13 @@ poll_cq_one_read_cqe:
 		}
 	}
 
-	/* tracing cqe */
-	if (unlikely(ehca_debug_level)) {
+	is_error = cqe->status & WC_STATUS_ERROR_BIT;
+
+	/* trace error CQEs if debug_level >= 1, trace all CQEs if >= 3 */
+	if (unlikely(ehca_debug_level >= 3 || (ehca_debug_level && is_error))) {
 		ehca_dbg(cq->device,
-			 "Received COMPLETION ehca_cq=%p cq_num=%x -----",
-			 my_cq, my_cq->cq_number);
+			 "Received %sCOMPLETION ehca_cq=%p cq_num=%x -----",
+			 is_error ? "ERROR " : "", my_cq, my_cq->cq_number);
 		ehca_dmp(cqe, 64, "ehca_cq=%p cq_num=%x",
 			 my_cq, my_cq->cq_number);
 		ehca_dbg(cq->device,
@@ -654,8 +659,9 @@ poll_cq_one_read_cqe:
 		/* update also queue adder to throw away this entry!!! */
 		goto poll_cq_one_exit0;
 	}
+
 	/* eval ib_wc_status */
-	if (unlikely(cqe->status & WC_STATUS_ERROR_BIT)) {
+	if (unlikely(is_error)) {
 		/* complete with errors */
 		map_ib_wc_status(cqe->status, &wc->status);
 		wc->vendor_err = wc->status;
@@ -676,14 +682,6 @@ poll_cq_one_read_cqe:
 	wc->imm_data = cpu_to_be32(cqe->immediate_data);
 	wc->sl = cqe->service_level;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS))
-		ehca_dbg(cq->device,
-			 "ehca_cq=%p cq_num=%x WARNING unsuccessful cqe "
-			 "OPType=%x status=%x qp_num=%x src_qp=%x wr_id=%lx "
-			 "cqe=%p", my_cq, my_cq->cq_number, cqe->optype,
-			 cqe->status, cqe->local_qp_number,
-			 cqe->remote_qp_number, cqe->work_request_id, cqe);
-
 poll_cq_one_exit0:
 	if (cqe_count > 0)
 		hipz_update_feca(my_cq, cqe_count);
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 1b07f2b..e43ed8f 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -211,8 +211,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 		break;
 
 	case 1: /* qp rqueue_addr */
-		ehca_dbg(qp->ib_qp.device, "qp_num=%x rqueue",
-			 qp->ib_qp.qp_num);
+		ehca_dbg(qp->ib_qp.device, "qp_num=%x rq", qp->ib_qp.qp_num);
 		ret = ehca_mmap_queue(vma, &qp->ipz_rqueue,
 				      &qp->mm_count_rqueue);
 		if (unlikely(ret)) {
@@ -224,8 +223,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 		break;
 
 	case 2: /* qp squeue_addr */
-		ehca_dbg(qp->ib_qp.device, "qp_num=%x squeue",
-			 qp->ib_qp.qp_num);
+		ehca_dbg(qp->ib_qp.device, "qp_num=%x sq", qp->ib_qp.qp_num);
 		ret = ehca_mmap_queue(vma, &qp->ipz_squeue,
 				      &qp->mm_count_squeue);
 		if (unlikely(ret)) {
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 7029aa6..5245e13 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -123,8 +123,9 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 	int i, sleep_msecs;
 	unsigned long flags = 0;
 
-	ehca_gen_dbg("opcode=%lx " HCALL7_REGS_FORMAT,
-		     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
+	if (unlikely(ehca_debug_level >= 2))
+		ehca_gen_dbg("opcode=%lx " HCALL7_REGS_FORMAT,
+			     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
 
 	for (i = 0; i < 5; i++) {
 		/* serialize hCalls to work around firmware issue */
@@ -148,7 +149,8 @@ static long ehca_plpar_hcall_norets(unsigned long opcode,
 				     opcode, ret, arg1, arg2, arg3,
 				     arg4, arg5, arg6, arg7);
 		else
-			ehca_gen_dbg("opcode=%lx ret=%li", opcode, ret);
+			if (unlikely(ehca_debug_level >= 2))
+				ehca_gen_dbg("opcode=%lx ret=%li", opcode, ret);
 
 		return ret;
 	}
@@ -172,8 +174,10 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 	int i, sleep_msecs;
 	unsigned long flags = 0;
 
-	ehca_gen_dbg("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT, opcode,
-		     arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
+	if (unlikely(ehca_debug_level >= 2))
+		ehca_gen_dbg("INPUT -- opcode=%lx " HCALL9_REGS_FORMAT, opcode,
+			     arg1, arg2, arg3, arg4, arg5,
+			     arg6, arg7, arg8, arg9);
 
 	for (i = 0; i < 5; i++) {
 		/* serialize hCalls to work around firmware issue */
@@ -201,7 +205,7 @@ static long ehca_plpar_hcall9(unsigned long opcode,
 				     ret, outs[0], outs[1], outs[2], outs[3],
 				     outs[4], outs[5], outs[6], outs[7],
 				     outs[8]);
-		} else
+		} else if (unlikely(ehca_debug_level >= 2))
 			ehca_gen_dbg("OUTPUT -- ret=%li " HCALL9_REGS_FORMAT,
 				     ret, outs[0], outs[1], outs[2], outs[3],
 				     outs[4], outs[5], outs[6], outs[7],
@@ -381,7 +385,7 @@ u64 hipz_h_query_port(const struct ipz_adapter_handle adapter_handle,
 				      r_cb,	             /* r6 */
 				      0, 0, 0, 0);
 
-	if (ehca_debug_level)
+	if (ehca_debug_level >= 2)
 		ehca_dmp(query_port_response_block, 64, "response_block");
 
 	return ret;
@@ -731,9 +735,6 @@ u64 hipz_h_alloc_resource_mr(const struct ipz_adapter_handle adapter_handle,
 	u64 ret;
 	u64 outs[PLPAR_HCALL9_BUFSIZE];
 
-	ehca_gen_dbg("kernel PAGE_SIZE=%x access_ctrl=%016x "
-		     "vaddr=%lx length=%lx",
-		     (u32)PAGE_SIZE, access_ctrl, vaddr, length);
 	ret = ehca_plpar_hcall9(H_ALLOC_RESOURCE, outs,
 				adapter_handle.handle,            /* r4 */
 				5,                                /* r5 */
@@ -758,7 +759,7 @@ u64 hipz_h_register_rpage_mr(const struct ipz_adapter_handle adapter_handle,
 {
 	u64 ret;
 
-	if (unlikely(ehca_debug_level >= 2)) {
+	if (unlikely(ehca_debug_level >= 3)) {
 		if (count > 1) {
 			u64 *kpage;
 			int i;
-- 
1.5.5


