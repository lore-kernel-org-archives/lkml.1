Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYKDVhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYKDVhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYKDVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:37:09 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:31922 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYKDVhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:37:05 -0500
X-IronPort-AV: E=Sophos;i="4.33,545,1220227200"; 
   d="scan'208";a="113097537"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Nov 2008 13:37:00 -0800
Message-ID: <ada1vxrtbpf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Nov 2008 21:37:03.0581 (UTC) FILETIME=[7A29D0D0:01C93EC5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the following changes; mostly low-level hardware changes
plus a couple of small patches that fix IPoIB crashes.

Chien Tung (2):
      RDMA/nes: Correct handling of PBL resources
      RDMA/nes: Mitigate compatibility issue regarding PCIe write credits

Ilpo Järvinen (1):
      RDMA/nes: Reindent mis-indented spinlocks

Ralph Campbell (1):
      IB/ipath: Fix RDMA write with immediate copy of last packet

Roland Dreier (3):
      RDMA/cxgb3: Fix too-big reserved field zeroing in iwch_post_zb_read()
      mlx4_core: Fix unused variable warning
      Merge branches 'cxgb3', 'ehca', 'ipath', 'ipoib', 'mlx4' and 'nes' into for-next

Stefan Roscher (1):
      IB/ehca: Remove reference to special QP in case of port activation failure

Vadim Makhervaks (1):
      RDMA/nes: Fix CQ allocation scheme for multicast receive queue apps

Yossi Etigin (3):
      IPoIB: Don't enable napi when it's already enabled
      IPoIB: Fix hang in ipoib_flush_paths()
      IPoIB: Fix crash in path_rec_completion()

 drivers/infiniband/hw/cxgb3/iwch_qp.c     |    1 -
 drivers/infiniband/hw/ehca/ehca_irq.c     |    7 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |    5 ++
 drivers/infiniband/hw/ipath/ipath_ruc.c   |   10 ++--
 drivers/infiniband/hw/nes/nes.c           |   16 +++++++
 drivers/infiniband/hw/nes/nes_hw.h        |    1 +
 drivers/infiniband/hw/nes/nes_verbs.c     |   64 +++++++++++++++++++---------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    6 ++-
 drivers/net/mlx4/mlx4.h                   |    9 +---
 9 files changed, 82 insertions(+), 37 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 3e4585c..19661b2 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -745,7 +745,6 @@ int iwch_post_zb_read(struct iwch_qp *qhp)
 	wqe->read.rdmaop = T3_READ_REQ;
 	wqe->read.reserved[0] = 0;
 	wqe->read.reserved[1] = 0;
-	wqe->read.reserved[2] = 0;
 	wqe->read.rem_stag = cpu_to_be32(1);
 	wqe->read.rem_to = cpu_to_be64(1);
 	wqe->read.local_stag = cpu_to_be32(1);
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index cb55be0..9e43459 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -370,6 +370,10 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 	switch (ec) {
 	case 0x30: /* port availability change */
 		if (EHCA_BMASK_GET(NEQE_PORT_AVAILABILITY, eqe)) {
+			/* only for autodetect mode important */
+			if (ehca_nr_ports >= 0)
+				break;
+
 			int suppress_event;
 			/* replay modify_qp for sqps */
 			spin_lock_irqsave(&sport->mod_sqp_lock, flags);
@@ -387,8 +391,7 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 			sport->port_state = IB_PORT_ACTIVE;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
 					    "is active");
-			ehca_query_sma_attr(shca, port,
-					    &sport->saved_attr);
+			ehca_query_sma_attr(shca, port, &sport->saved_attr);
 		} else {
 			sport->port_state = IB_PORT_DOWN;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 4d54b9f..9e05ee2 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -860,6 +860,11 @@ static struct ehca_qp *internal_create_qp(
 	if (qp_type == IB_QPT_GSI) {
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
+			kfree(my_qp->mod_qp_parm);
+			my_qp->mod_qp_parm = NULL;
+			/* the QP pointer is no longer valid */
+			shca->sport[init_attr->port_num - 1].ibqp_sqp[qp_type] =
+				NULL;
 			ret = ehca2ib_return_code(h_ret);
 			goto create_qp_exit6;
 		}
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
index fc0f6d9..2296832 100644
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -156,7 +156,7 @@ bail:
 /**
  * ipath_get_rwqe - copy the next RWQE into the QP's RWQE
  * @qp: the QP
- * @wr_id_only: update wr_id only, not SGEs
+ * @wr_id_only: update qp->r_wr_id only, not qp->r_sge
  *
  * Return 0 if no RWQE is available, otherwise return 1.
  *
@@ -173,8 +173,6 @@ int ipath_get_rwqe(struct ipath_qp *qp, int wr_id_only)
 	u32 tail;
 	int ret;
 
-	qp->r_sge.sg_list = qp->r_sg_list;
-
 	if (qp->ibqp.srq) {
 		srq = to_isrq(qp->ibqp.srq);
 		handler = srq->ibsrq.event_handler;
@@ -206,8 +204,10 @@ int ipath_get_rwqe(struct ipath_qp *qp, int wr_id_only)
 		wqe = get_rwqe_ptr(rq, tail);
 		if (++tail >= rq->size)
 			tail = 0;
-	} while (!wr_id_only && !ipath_init_sge(qp, wqe, &qp->r_len,
-						&qp->r_sge));
+		if (wr_id_only)
+			break;
+		qp->r_sge.sg_list = qp->r_sg_list;
+	} while (!ipath_init_sge(qp, wqe, &qp->r_len, &qp->r_sge));
 	qp->r_wr_id = wqe->wr_id;
 	wq->tail = tail;
 
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index a2b04d6..aa1dc41 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -95,6 +95,10 @@ unsigned int wqm_quanta = 0x10000;
 module_param(wqm_quanta, int, 0644);
 MODULE_PARM_DESC(wqm_quanta, "WQM quanta");
 
+static unsigned int limit_maxrdreqsz;
+module_param(limit_maxrdreqsz, bool, 0644);
+MODULE_PARM_DESC(limit_maxrdreqsz, "Limit max read request size to 256 Bytes");
+
 LIST_HEAD(nes_adapter_list);
 static LIST_HEAD(nes_dev_list);
 
@@ -588,6 +592,18 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 						nesdev->nesadapter->port_count;
 	}
 
+	if ((limit_maxrdreqsz ||
+	     ((nesdev->nesadapter->phy_type[0] == NES_PHY_TYPE_GLADIUS) &&
+	      (hw_rev == NE020_REV1))) &&
+	    (pcie_get_readrq(pcidev) > 256)) {
+		if (pcie_set_readrq(pcidev, 256))
+			printk(KERN_ERR PFX "Unable to set max read request"
+				" to 256 bytes\n");
+		else
+			nes_debug(NES_DBG_INIT, "Max read request size set"
+				" to 256 bytes\n");
+	}
+
 	tasklet_init(&nesdev->dpc_tasklet, nes_dpc, (unsigned long)nesdev);
 
 	/* bring up the Control QP */
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 610b9d8..bc0b4de 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -40,6 +40,7 @@
 #define NES_PHY_TYPE_ARGUS     4
 #define NES_PHY_TYPE_PUMA_1G   5
 #define NES_PHY_TYPE_PUMA_10G  6
+#define NES_PHY_TYPE_GLADIUS   7
 
 #define NES_MULTICAST_PF_MAX 8
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 932e56f..d36c9a0 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -220,14 +220,14 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.sq_head;
 	qsize = nesqp->hwqp.sq_tail;
 
 	/* Check for SQ overflow */
 	if (((head + (2 * qsize) - nesqp->hwqp.sq_tail) % qsize) == (qsize - 1)) {
-			spin_unlock_irqrestore(&nesqp->lock, flags);
+		spin_unlock_irqrestore(&nesqp->lock, flags);
 		return -EINVAL;
 	}
 
@@ -269,7 +269,7 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 	nes_write32(nesdev->regs+NES_WQE_ALLOC,
 			(1 << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	return 0;
 }
@@ -349,7 +349,7 @@ static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
 			if (nesfmr->nesmr.pbls_used > nesadapter->free_4kpbl) {
 				spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 				ret = -ENOMEM;
-				goto failed_vpbl_alloc;
+				goto failed_vpbl_avail;
 			} else {
 				nesadapter->free_4kpbl -= nesfmr->nesmr.pbls_used;
 			}
@@ -357,7 +357,7 @@ static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
 			if (nesfmr->nesmr.pbls_used > nesadapter->free_256pbl) {
 				spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 				ret = -ENOMEM;
-				goto failed_vpbl_alloc;
+				goto failed_vpbl_avail;
 			} else {
 				nesadapter->free_256pbl -= nesfmr->nesmr.pbls_used;
 			}
@@ -391,14 +391,14 @@ static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
 			goto failed_vpbl_alloc;
 		}
 
-		nesfmr->root_vpbl.leaf_vpbl = kzalloc(sizeof(*nesfmr->root_vpbl.leaf_vpbl)*1024, GFP_KERNEL);
+		nesfmr->leaf_pbl_cnt = nesfmr->nesmr.pbls_used-1;
+		nesfmr->root_vpbl.leaf_vpbl = kzalloc(sizeof(*nesfmr->root_vpbl.leaf_vpbl)*1024, GFP_ATOMIC);
 		if (!nesfmr->root_vpbl.leaf_vpbl) {
 			spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 			ret = -ENOMEM;
 			goto failed_leaf_vpbl_alloc;
 		}
 
-		nesfmr->leaf_pbl_cnt = nesfmr->nesmr.pbls_used-1;
 		nes_debug(NES_DBG_MR, "two level pbl, root_vpbl.pbl_vbase=%p"
 				" leaf_pbl_cnt=%d root_vpbl.leaf_vpbl=%p\n",
 				nesfmr->root_vpbl.pbl_vbase, nesfmr->leaf_pbl_cnt, nesfmr->root_vpbl.leaf_vpbl);
@@ -519,6 +519,16 @@ static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
 				nesfmr->root_vpbl.pbl_pbase);
 
 	failed_vpbl_alloc:
+	if (nesfmr->nesmr.pbls_used != 0) {
+		spin_lock_irqsave(&nesadapter->pbl_lock, flags);
+		if (nesfmr->nesmr.pbl_4k)
+			nesadapter->free_4kpbl += nesfmr->nesmr.pbls_used;
+		else
+			nesadapter->free_256pbl += nesfmr->nesmr.pbls_used;
+		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
+	}
+
+failed_vpbl_avail:
 	kfree(nesfmr);
 
 	failed_fmr_alloc:
@@ -534,18 +544,14 @@ static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
  */
 static int nes_dealloc_fmr(struct ib_fmr *ibfmr)
 {
+	unsigned long flags;
 	struct nes_mr *nesmr = to_nesmr_from_ibfmr(ibfmr);
 	struct nes_fmr *nesfmr = to_nesfmr(nesmr);
 	struct nes_vnic *nesvnic = to_nesvnic(ibfmr->device);
 	struct nes_device *nesdev = nesvnic->nesdev;
-	struct nes_mr temp_nesmr = *nesmr;
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int i = 0;
 
-	temp_nesmr.ibmw.device = ibfmr->device;
-	temp_nesmr.ibmw.pd = ibfmr->pd;
-	temp_nesmr.ibmw.rkey = ibfmr->rkey;
-	temp_nesmr.ibmw.uobject = NULL;
-
 	/* free the resources */
 	if (nesfmr->leaf_pbl_cnt == 0) {
 		/* single PBL case */
@@ -561,8 +567,24 @@ static int nes_dealloc_fmr(struct ib_fmr *ibfmr)
 		pci_free_consistent(nesdev->pcidev, 8192, nesfmr->root_vpbl.pbl_vbase,
 				nesfmr->root_vpbl.pbl_pbase);
 	}
+	nesmr->ibmw.device = ibfmr->device;
+	nesmr->ibmw.pd = ibfmr->pd;
+	nesmr->ibmw.rkey = ibfmr->rkey;
+	nesmr->ibmw.uobject = NULL;
 
-	return nes_dealloc_mw(&temp_nesmr.ibmw);
+	if (nesfmr->nesmr.pbls_used != 0) {
+		spin_lock_irqsave(&nesadapter->pbl_lock, flags);
+		if (nesfmr->nesmr.pbl_4k) {
+			nesadapter->free_4kpbl += nesfmr->nesmr.pbls_used;
+			WARN_ON(nesadapter->free_4kpbl > nesadapter->max_4kpbl);
+		} else {
+			nesadapter->free_256pbl += nesfmr->nesmr.pbls_used;
+			WARN_ON(nesadapter->free_256pbl > nesadapter->max_256pbl);
+		}
+		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
+	}
+
+	return nes_dealloc_mw(&nesmr->ibmw);
 }
 
 
@@ -1595,7 +1617,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 		nes_ucontext->mcrqf = req.mcrqf;
 		if (nes_ucontext->mcrqf) {
 			if (nes_ucontext->mcrqf & 0x80000000)
-				nescq->hw_cq.cq_number = nesvnic->nic.qp_id + 12 + (nes_ucontext->mcrqf & 0xf) - 1;
+				nescq->hw_cq.cq_number = nesvnic->nic.qp_id + 28 + 2 * ((nes_ucontext->mcrqf & 0xf) - 1);
 			else if (nes_ucontext->mcrqf & 0x40000000)
 				nescq->hw_cq.cq_number = nes_ucontext->mcrqf & 0xffff;
 			else
@@ -3212,7 +3234,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.sq_head;
 
@@ -3337,7 +3359,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 				(counter << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 	}
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	if (err)
 		*bad_wr = ib_wr;
@@ -3368,7 +3390,7 @@ static int nes_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.rq_head;
 
@@ -3421,7 +3443,7 @@ static int nes_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter<<24) | nesqp->hwqp.qp_id);
 	}
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	if (err)
 		*bad_wr = ib_wr;
@@ -3453,7 +3475,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 
 	nes_debug(NES_DBG_CQ, "\n");
 
-		spin_lock_irqsave(&nescq->lock, flags);
+	spin_lock_irqsave(&nescq->lock, flags);
 
 	head = nescq->hw_cq.cq_head;
 	cq_size = nescq->hw_cq.cq_size;
@@ -3562,7 +3584,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 	nes_debug(NES_DBG_CQ, "Reporting %u completions for CQ%u.\n",
 			cqe_count, nescq->hw_cq.cq_number);
 
-		spin_unlock_irqrestore(&nescq->lock, flags);
+	spin_unlock_irqrestore(&nescq->lock, flags);
 
 	return cqe_count;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index fddded7..85257f6 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -106,12 +106,13 @@ int ipoib_open(struct net_device *dev)
 
 	ipoib_dbg(priv, "bringing up interface\n");
 
-	napi_enable(&priv->napi);
 	set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
 	if (ipoib_pkey_dev_delay_open(dev))
 		return 0;
 
+	napi_enable(&priv->napi);
+
 	if (ipoib_ib_dev_open(dev)) {
 		napi_disable(&priv->napi);
 		return -EINVAL;
@@ -546,6 +547,7 @@ static int path_rec_start(struct net_device *dev,
 	if (path->query_id < 0) {
 		ipoib_warn(priv, "ib_sa_path_rec_get failed: %d\n", path->query_id);
 		path->query = NULL;
+		complete(&path->done);
 		return path->query_id;
 	}
 
@@ -662,7 +664,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			skb_push(skb, sizeof *phdr);
 			__skb_queue_tail(&path->queue, skb);
 
-			if (path_rec_start(dev, path)) {
+			if (!path->query && path_rec_start(dev, path)) {
 				spin_unlock_irqrestore(&priv->lock, flags);
 				path_free(dev, path);
 				return;
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index fa431fa..56a2e21 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -87,6 +87,9 @@ enum {
 
 #ifdef CONFIG_MLX4_DEBUG
 extern int mlx4_debug_level;
+#else /* CONFIG_MLX4_DEBUG */
+#define mlx4_debug_level	(0)
+#endif /* CONFIG_MLX4_DEBUG */
 
 #define mlx4_dbg(mdev, format, arg...)					\
 	do {								\
@@ -94,12 +97,6 @@ extern int mlx4_debug_level;
 			dev_printk(KERN_DEBUG, &mdev->pdev->dev, format, ## arg); \
 	} while (0)
 
-#else /* CONFIG_MLX4_DEBUG */
-
-#define mlx4_dbg(mdev, format, arg...) do { (void) mdev; } while (0)
-
-#endif /* CONFIG_MLX4_DEBUG */
-
 #define mlx4_err(mdev, format, arg...) \
 	dev_err(&mdev->pdev->dev, format, ## arg)
 #define mlx4_info(mdev, format, arg...) \
