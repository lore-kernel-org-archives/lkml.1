Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbXKNQXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbXKNQXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXKNQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:23:13 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:30917 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXKNQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:23:12 -0500
X-IronPort-AV: E=Sophos;i="4.21,417,1188802800"; 
   d="scan'208";a="228633"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Nov 2007 08:23:07 -0800
Message-ID: <adalk9023v8.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Nov 2007 16:23:07.0911 (UTC) FILETIME=[A42BA970:01C826DA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pull some low-level driver fixes for 2.6.24:

Ali Ayoub (1):
      mlx4_core: Fix possible bad free in mlx4_buf_free()

Jack Morgenstein (1):
      mlx4_core: Fix thinko in QP destroy (incorrect bitmap_free)

Joachim Fenkes (2):
      IB/ehca: Return physical link information in query_port()
      IB/ehca: Fix static rate calculation

Ralph Campbell (2):
      IB/ipath: Fix memory leak in ipath_resize_cq() if copy_to_user() fails
      IB/ipath: Fix race with ACK retry timeout list management

Steve Wise (1):
      RDMA/cxgb3: Set the max_qp_init_rd_atom attribute in query_device

 drivers/infiniband/hw/cxgb3/iwch_provider.c |    1 +
 drivers/infiniband/hw/ehca/ehca_av.c        |   48 ++++++++++++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_classes.h   |    1 -
 drivers/infiniband/hw/ehca/ehca_hca.c       |   20 ++++++++---
 drivers/infiniband/hw/ehca/ehca_iverbs.h    |    3 ++
 drivers/infiniband/hw/ehca/ehca_main.c      |    3 --
 drivers/infiniband/hw/ehca/ehca_qp.c        |   29 +++++++---------
 drivers/infiniband/hw/ehca/hipz_hw.h        |    6 +++-
 drivers/infiniband/hw/ipath/ipath_cq.c      |   11 ++++--
 drivers/infiniband/hw/ipath/ipath_rc.c      |    5 ++-
 drivers/net/mlx4/alloc.c                    |    7 ++--
 drivers/net/mlx4/qp.c                       |    2 +-
 12 files changed, 89 insertions(+), 47 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index f0c7775..b5436ca 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1000,6 +1000,7 @@ static int iwch_query_device(struct ib_device *ibdev,
 	props->max_sge = dev->attr.max_sge_per_wr;
 	props->max_sge_rd = 1;
 	props->max_qp_rd_atom = dev->attr.max_rdma_reads_per_qp;
+	props->max_qp_init_rd_atom = dev->attr.max_rdma_reads_per_qp;
 	props->max_cq = dev->attr.max_cqs;
 	props->max_cqe = dev->attr.max_cqes_per_cq;
 	props->max_mr = dev->attr.max_mem_regs;
diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 97d1086..453eb99 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -50,6 +50,38 @@
 
 static struct kmem_cache *av_cache;
 
+int ehca_calc_ipd(struct ehca_shca *shca, int port,
+		  enum ib_rate path_rate, u32 *ipd)
+{
+	int path = ib_rate_to_mult(path_rate);
+	int link, ret;
+	struct ib_port_attr pa;
+
+	if (path_rate == IB_RATE_PORT_CURRENT) {
+		*ipd = 0;
+		return 0;
+	}
+
+	if (unlikely(path < 0)) {
+		ehca_err(&shca->ib_device, "Invalid static rate! path_rate=%x",
+			 path_rate);
+		return -EINVAL;
+	}
+
+	ret = ehca_query_port(&shca->ib_device, port, &pa);
+	if (unlikely(ret < 0)) {
+		ehca_err(&shca->ib_device, "Failed to query port  ret=%i", ret);
+		return ret;
+	}
+
+	link = ib_width_enum_to_int(pa.active_width) * pa.active_speed;
+
+	/* IPD = round((link / path) - 1) */
+	*ipd = ((link + (path >> 1)) / path) - 1;
+
+	return 0;
+}
+
 struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
 	int ret;
@@ -69,15 +101,13 @@ struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 	av->av.slid_path_bits = ah_attr->src_path_bits;
 
 	if (ehca_static_rate < 0) {
-		int ah_mult = ib_rate_to_mult(ah_attr->static_rate);
-		int ehca_mult =
-			ib_rate_to_mult(shca->sport[ah_attr->port_num].rate );
-
-		if (ah_mult >= ehca_mult)
-			av->av.ipd = 0;
-		else
-			av->av.ipd = (ah_mult > 0) ?
-				((ehca_mult - 1) / ah_mult) : 0;
+		u32 ipd;
+		if (ehca_calc_ipd(shca, ah_attr->port_num,
+				  ah_attr->static_rate, &ipd)) {
+			ret = -EINVAL;
+			goto create_ah_exit1;
+		}
+		av->av.ipd = ipd;
 	} else
 		av->av.ipd = ehca_static_rate;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 2d660ae..87f12d4 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -95,7 +95,6 @@ struct ehca_sma_attr {
 struct ehca_sport {
 	struct ib_cq *ibcq_aqp1;
 	struct ib_qp *ibqp_aqp1;
-	enum ib_rate  rate;
 	enum ib_port_state port_state;
 	struct ehca_sma_attr saved_attr;
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 15806d1..5bd7b59 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -151,7 +151,6 @@ int ehca_query_port(struct ib_device *ibdev,
 	}
 
 	memset(props, 0, sizeof(struct ib_port_attr));
-	props->state = rblock->state;
 
 	switch (rblock->max_mtu) {
 	case 0x1:
@@ -188,11 +187,20 @@ int ehca_query_port(struct ib_device *ibdev,
 	props->subnet_timeout  = rblock->subnet_timeout;
 	props->init_type_reply = rblock->init_type_reply;
 
-	props->active_width    = IB_WIDTH_12X;
-	props->active_speed    = 0x1;
-
-	/* at the moment (logical) link state is always LINK_UP */
-	props->phys_state      = 0x5;
+	if (rblock->state && rblock->phys_width) {
+		props->phys_state      = rblock->phys_pstate;
+		props->state           = rblock->phys_state;
+		props->active_width    = rblock->phys_width;
+		props->active_speed    = rblock->phys_speed;
+	} else {
+		/* old firmware releases don't report physical
+		 * port info, so use default values
+		 */
+		props->phys_state      = 5;
+		props->state           = rblock->state;
+		props->active_width    = IB_WIDTH_12X;
+		props->active_speed    = 0x1;
+	}
 
 query_port1:
 	ehca_free_fw_ctrlblock(rblock);
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index dce503b..5485799 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -189,6 +189,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 void ehca_poll_eqs(unsigned long data);
 
+int ehca_calc_ipd(struct ehca_shca *shca, int port,
+		  enum ib_rate path_rate, u32 *ipd);
+
 #ifdef CONFIG_PPC_64K_PAGES
 void *ehca_alloc_fw_ctrlblock(gfp_t flags);
 void ehca_free_fw_ctrlblock(void *ptr);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index c6cd38c..90d4334 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -327,9 +327,6 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 		shca->hw_level = ehca_hw_level;
 	ehca_gen_dbg(" ... hardware level=%x", shca->hw_level);
 
-	shca->sport[0].rate = IB_RATE_30_GBPS;
-	shca->sport[1].rate = IB_RATE_30_GBPS;
-
 	shca->hca_cap = rblock->hca_cap_indicators;
 	ehca_gen_dbg(" ... HCA capabilities:");
 	for (i = 0; i < ARRAY_SIZE(hca_cap_descr); i++)
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index de18264..2e3e654 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1196,10 +1196,6 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_QKEY, 1);
 	}
 	if (attr_mask & IB_QP_AV) {
-		int ah_mult = ib_rate_to_mult(attr->ah_attr.static_rate);
-		int ehca_mult = ib_rate_to_mult(shca->sport[my_qp->
-						init_attr.port_num].rate);
-
 		mqpcb->dlid = attr->ah_attr.dlid;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_DLID, 1);
 		mqpcb->source_path_bits = attr->ah_attr.src_path_bits;
@@ -1207,11 +1203,12 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->service_level = attr->ah_attr.sl;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL, 1);
 
-		if (ah_mult < ehca_mult)
-			mqpcb->max_static_rate = (ah_mult > 0) ?
-			((ehca_mult - 1) / ah_mult) : 0;
-		else
-			mqpcb->max_static_rate = 0;
+		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+				  attr->ah_attr.static_rate,
+				  &mqpcb->max_static_rate)) {
+			ret = -EINVAL;
+			goto modify_qp_exit2;
+		}
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_MAX_STATIC_RATE, 1);
 
 		/*
@@ -1280,10 +1277,6 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			(MQPCB_MASK_RDMA_ATOMIC_OUTST_DEST_QP, 1);
 	}
 	if (attr_mask & IB_QP_ALT_PATH) {
-		int ah_mult = ib_rate_to_mult(attr->alt_ah_attr.static_rate);
-		int ehca_mult = ib_rate_to_mult(
-			shca->sport[my_qp->init_attr.port_num].rate);
-
 		if (attr->alt_port_num < 1
 		    || attr->alt_port_num > shca->num_ports) {
 			ret = -EINVAL;
@@ -1309,10 +1302,12 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
 
-		if (ah_mult > 0 && ah_mult < ehca_mult)
-			mqpcb->max_static_rate_al = (ehca_mult - 1) / ah_mult;
-		else
-			mqpcb->max_static_rate_al = 0;
+		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+				  attr->alt_ah_attr.static_rate,
+				  &mqpcb->max_static_rate_al)) {
+			ret = -EINVAL;
+			goto modify_qp_exit2;
+		}
 
 		/* OpenIB doesn't support alternate retry counts - copy them */
 		mqpcb->retry_count_al = mqpcb->retry_count;
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index d9739e5..485b840 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -402,7 +402,11 @@ struct hipz_query_port {
 	u64 max_msg_sz;
 	u32 max_mtu;
 	u32 vl_cap;
-	u8  reserved2[1900];
+	u32 phys_pstate;
+	u32 phys_state;
+	u32 phys_speed;
+	u32 phys_width;
+	u8  reserved2[1884];
 	u64 guid_entries[255];
 } __attribute__ ((packed));
 
diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/infiniband/hw/ipath/ipath_cq.c
index 645ed71..08d8ae1 100644
--- a/drivers/infiniband/hw/ipath/ipath_cq.c
+++ b/drivers/infiniband/hw/ipath/ipath_cq.c
@@ -404,7 +404,7 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 
 		ret = ib_copy_to_udata(udata, &offset, sizeof(offset));
 		if (ret)
-			goto bail;
+			goto bail_free;
 	}
 
 	spin_lock_irq(&cq->lock);
@@ -424,10 +424,8 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 	else
 		n = head - tail;
 	if (unlikely((u32)cqe < n)) {
-		spin_unlock_irq(&cq->lock);
-		vfree(wc);
 		ret = -EOVERFLOW;
-		goto bail;
+		goto bail_unlock;
 	}
 	for (n = 0; tail != head; n++) {
 		if (cq->ip)
@@ -459,7 +457,12 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 	}
 
 	ret = 0;
+	goto bail;
 
+bail_unlock:
+	spin_unlock_irq(&cq->lock);
+bail_free:
+	vfree(wc);
 bail:
 	return ret;
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/infiniband/hw/ipath/ipath_rc.c
index 5c29b2b..120a61b 100644
--- a/drivers/infiniband/hw/ipath/ipath_rc.c
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c
@@ -959,8 +959,9 @@ static int do_rc_ack(struct ipath_qp *qp, u32 aeth, u32 psn, int opcode,
 		/* If this is a partial ACK, reset the retransmit timer. */
 		if (qp->s_last != qp->s_tail) {
 			spin_lock(&dev->pending_lock);
-			list_add_tail(&qp->timerwait,
-				      &dev->pending[dev->pending_index]);
+			if (list_empty(&qp->timerwait))
+				list_add_tail(&qp->timerwait,
+					&dev->pending[dev->pending_index]);
 			spin_unlock(&dev->pending_lock);
 			/*
 			 * If we get a partial ACK for a resent operation,
diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index f8d63d3..b226e01 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -171,9 +171,10 @@ void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf)
 				  buf->u.direct.map);
 	else {
 		for (i = 0; i < buf->nbufs; ++i)
-			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
-					  buf->u.page_list[i].buf,
-					  buf->u.page_list[i].map);
+			if (buf->u.page_list[i].buf)
+				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
+						  buf->u.page_list[i].buf,
+						  buf->u.page_list[i].map);
 		kfree(buf->u.page_list);
 	}
 }
diff --git a/drivers/net/mlx4/qp.c b/drivers/net/mlx4/qp.c
index cc4b1be..42b4763 100644
--- a/drivers/net/mlx4/qp.c
+++ b/drivers/net/mlx4/qp.c
@@ -240,7 +240,7 @@ void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp)
 	mlx4_table_put(dev, &qp_table->auxc_table, qp->qpn);
 	mlx4_table_put(dev, &qp_table->qp_table, qp->qpn);
 
-	if (qp->qpn < dev->caps.sqp_start + 8)
+	if (qp->qpn >= dev->caps.sqp_start + 8)
 		mlx4_bitmap_free(&qp_table->bitmap, qp->qpn);
 }
 EXPORT_SYMBOL_GPL(mlx4_qp_free);
