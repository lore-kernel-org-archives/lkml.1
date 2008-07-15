Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYGOTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYGOTLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYGOTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:11:26 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:14114 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYGOTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:11:24 -0400
X-IronPort-AV: E=Sophos;i="4.30,367,1212364800"; 
   d="scan'208";a="87350051"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
References: <ada8ww5jbaf.fsf@cisco.com> <487B820E.4020002@mellanox.co.il>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 15 Jul 2008 12:11:21 -0700
In-Reply-To: <487B820E.4020002@mellanox.co.il> (Tziporet Koren's message of
	"Mon, 14 Jul 2008 19:42:54 +0300")
Message-ID: <adahcarezdy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 19:11:22.0213 (UTC) FILETIME=[91A2E950:01C8E6AE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  - I've been working on memory management extensions support for mlx4,
 > >    but I'm not sure if it will be ready in time.  Firmware for this
 > >    may not be released for a while so it ain't urgent anyway.

 > We are testing the patches and we already have FW that enable them.
 > I agree its not urgent but it would be good to have it, so ULPs that
 > are interested can be tested over IB too.

By the way, for outside of Mellanox, here is my patch that adds mem mgt
extensions and local lkey support to mlx4.  Comments appreciated...

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 299f208..0b191a4 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -637,6 +637,7 @@ repoll:
 		case MLX4_OPCODE_SEND_IMM:
 			wc->wc_flags |= IB_WC_WITH_IMM;
 		case MLX4_OPCODE_SEND:
+		case MLX4_OPCODE_SEND_INVAL:
 			wc->opcode    = IB_WC_SEND;
 			break;
 		case MLX4_OPCODE_RDMA_READ:
@@ -657,6 +658,12 @@ repoll:
 		case MLX4_OPCODE_LSO:
 			wc->opcode    = IB_WC_LSO;
 			break;
+		case MLX4_OPCODE_FMR:
+			wc->opcode    = IB_WC_FAST_REG_MR;
+			break;
+		case MLX4_OPCODE_LOCAL_INVAL:
+			wc->opcode    = IB_WC_LOCAL_INV;
+			break;
 		}
 	} else {
 		wc->byte_len = be32_to_cpu(cqe->byte_cnt);
@@ -667,6 +674,11 @@ repoll:
 			wc->wc_flags	= IB_WC_WITH_IMM;
 			wc->ex.imm_data = cqe->immed_rss_invalid;
 			break;
+		case MLX4_RECV_OPCODE_SEND_INVAL:
+			wc->opcode	= IB_WC_RECV;
+			wc->wc_flags	= IB_WC_WITH_INVALIDATE;
+			wc->ex.invalidate_rkey = be32_to_cpu(cqe->immed_rss_invalid);
+			break;
 		case MLX4_RECV_OPCODE_SEND:
 			wc->opcode   = IB_WC_RECV;
 			wc->wc_flags = 0;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bcf5064..38d6907 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -104,6 +104,12 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
 	if (dev->dev->caps.max_gso_sz)
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
+	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
+		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
+	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
+	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
+	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
+		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
@@ -127,6 +133,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_srq		   = dev->dev->caps.num_srqs - dev->dev->caps.reserved_srqs;
 	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes - 1;
 	props->max_srq_sge	   = dev->dev->caps.max_srq_sge;
+	props->max_fast_reg_page_list_len = PAGE_SIZE / sizeof (u64);
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
@@ -565,6 +572,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	strlcpy(ibdev->ib_dev.name, "mlx4_%d", IB_DEVICE_NAME_MAX);
 	ibdev->ib_dev.owner		= THIS_MODULE;
 	ibdev->ib_dev.node_type		= RDMA_NODE_IB_CA;
+	ibdev->ib_dev.local_dma_lkey	= dev->caps.reserved_lkey;
 	ibdev->ib_dev.phys_port_cnt	= dev->caps.num_ports;
 	ibdev->ib_dev.num_comp_vectors	= 1;
 	ibdev->ib_dev.dma_device	= &dev->pdev->dev;
@@ -627,6 +635,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.get_dma_mr	= mlx4_ib_get_dma_mr;
 	ibdev->ib_dev.reg_user_mr	= mlx4_ib_reg_user_mr;
 	ibdev->ib_dev.dereg_mr		= mlx4_ib_dereg_mr;
+	ibdev->ib_dev.alloc_fast_reg_mr = mlx4_ib_alloc_fast_reg_mr;
+	ibdev->ib_dev.alloc_fast_reg_page_list = mlx4_ib_alloc_fast_reg_page_list;
+	ibdev->ib_dev.free_fast_reg_page_list  = mlx4_ib_free_fast_reg_page_list;
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index c4cf5b6..d26a913 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -83,6 +83,11 @@ struct mlx4_ib_mr {
 	struct ib_umem	       *umem;
 };
 
+struct mlx4_ib_fast_reg_page_list {
+	struct ib_fast_reg_page_list	ibfrpl;
+	dma_addr_t			map;
+};
+
 struct mlx4_ib_fmr {
 	struct ib_fmr           ibfmr;
 	struct mlx4_fmr         mfmr;
@@ -199,6 +204,11 @@ static inline struct mlx4_ib_mr *to_mmr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct mlx4_ib_mr, ibmr);
 }
 
+static inline struct mlx4_ib_fast_reg_page_list *to_mfrpl(struct ib_fast_reg_page_list *ibfrpl)
+{
+	return container_of(ibfrpl, struct mlx4_ib_fast_reg_page_list, ibfrpl);
+}
+
 static inline struct mlx4_ib_fmr *to_mfmr(struct ib_fmr *ibfmr)
 {
 	return container_of(ibfmr, struct mlx4_ib_fmr, ibfmr);
@@ -239,6 +249,11 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
 int mlx4_ib_dereg_mr(struct ib_mr *mr);
+struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
+					int max_page_list_len);
+struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
+							       int page_list_len);
+void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
 
 int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 68e9248..db2086f 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -183,6 +183,76 @@ int mlx4_ib_dereg_mr(struct ib_mr *ibmr)
 	return 0;
 }
 
+struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
+					int max_page_list_len)
+{
+	struct mlx4_ib_dev *dev = to_mdev(pd->device);
+	struct mlx4_ib_mr *mr;
+	int err;
+
+	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, 0, 0, 0,
+			    max_page_list_len, 0, &mr->mmr);
+	if (err)
+		goto err_free;
+
+	err = mlx4_mr_enable(dev->dev, &mr->mmr);
+	if (err)
+		goto err_mr;
+
+	return &mr->ibmr;
+
+err_mr:
+	mlx4_mr_free(dev->dev, &mr->mmr);
+
+err_free:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
+struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
+							       int page_list_len)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct mlx4_ib_fast_reg_page_list *mfrpl;
+	int size = page_list_len * sizeof (u64);
+
+	if (size > PAGE_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	mfrpl = kmalloc(sizeof *mfrpl, GFP_KERNEL);
+	if (!mfrpl)
+		return ERR_PTR(-ENOMEM);
+
+	mfrpl->ibfrpl.page_list = dma_alloc_coherent(&dev->dev->pdev->dev,
+						     size, &mfrpl->map,
+						     GFP_KERNEL);
+	if (!mfrpl->ibfrpl.page_list)
+		goto err_free;
+
+	WARN_ON(mfrpl->map & 0x3f);
+
+	return &mfrpl->ibfrpl;
+
+err_free:
+	kfree(mfrpl);
+	return ERR_PTR(-ENOMEM);
+}
+
+void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list)
+{
+	struct mlx4_ib_dev *dev = to_mdev(page_list->device);
+	struct mlx4_ib_fast_reg_page_list *mfrpl = to_mfrpl(page_list);
+	int size = page_list->max_page_list_len * sizeof (u64);
+
+	dma_free_coherent(&dev->dev->pdev->dev, size, page_list->page_list,
+			  mfrpl->map);
+	kfree(mfrpl);
+}
+
 struct ib_fmr *mlx4_ib_fmr_alloc(struct ib_pd *pd, int acc,
 				 struct ib_fmr_attr *fmr_attr)
 {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 91590e7..47ec68d 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -78,6 +78,9 @@ static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_RDMA_READ]		= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_READ),
 	[IB_WR_ATOMIC_CMP_AND_SWP]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_CS),
 	[IB_WR_ATOMIC_FETCH_AND_ADD]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_FA),
+	[IB_WR_SEND_WITH_INV]		= __constant_cpu_to_be32(MLX4_OPCODE_SEND_INVAL),
+	[IB_WR_LOCAL_INV]		= __constant_cpu_to_be32(MLX4_OPCODE_LOCAL_INVAL),
+	[IB_WR_FAST_REG_MR]		= __constant_cpu_to_be32(MLX4_OPCODE_FMR),
 };
 
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
@@ -987,6 +990,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	context->pd	    = cpu_to_be32(to_mpd(ibqp->pd)->pdn);
 	context->params1    = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
 
+	/* Set "fast registration enabled" for all kernel QPs */
+	if (!qp->ibqp.uobject)
+		context->params1 |= cpu_to_be32(1 << 11);
+
 	if (attr_mask & IB_QP_RNR_RETRY) {
 		context->params1 |= cpu_to_be32(attr->rnr_retry << 13);
 		optpar |= MLX4_QP_OPTPAR_RNR_RETRY;
@@ -1333,6 +1340,38 @@ static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq
 	return cur + nreq >= wq->max_post;
 }
 
+static __be32 convert_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_ATOMIC ? cpu_to_be32(MLX4_WQE_FMR_PERM_ATOMIC)       : 0) |
+	       (acc & IB_ACCESS_REMOTE_WRITE  ? cpu_to_be32(MLX4_WQE_FMR_PERM_REMOTE_WRITE) : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ   ? cpu_to_be32(MLX4_WQE_FMR_PERM_REMOTE_READ)  : 0) |
+	       (acc & IB_ACCESS_LOCAL_WRITE   ? cpu_to_be32(MLX4_WQE_FMR_PERM_LOCAL_WRITE)  : 0) |
+		cpu_to_be32(MLX4_WQE_FMR_PERM_LOCAL_READ);
+}
+
+static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
+{
+	struct mlx4_ib_fast_reg_page_list *mfrpl = to_mfrpl(wr->wr.fast_reg.page_list);
+
+	fseg->flags		= convert_access(wr->wr.fast_reg.access_flags);
+	fseg->mem_key		= cpu_to_be32(wr->wr.fast_reg.rkey);
+	fseg->buf_list		= cpu_to_be64(mfrpl->map);
+	fseg->start_addr	= cpu_to_be64(wr->wr.fast_reg.iova_start);
+	fseg->reg_len		= cpu_to_be64(wr->wr.fast_reg.length);
+	fseg->offset		= 0; /* XXX -- is this just for ZBVA? */
+	fseg->page_size		= cpu_to_be32(wr->wr.fast_reg.page_shift);
+	fseg->reserved[0]	= 0;
+	fseg->reserved[1]	= 0;
+}
+
+static void set_local_inv_seg(struct mlx4_wqe_local_inval_seg *iseg, u32 rkey)
+{
+	iseg->flags	= 0;
+	iseg->mem_key	= cpu_to_be32(rkey);
+	iseg->guest_id	= 0;
+	iseg->pa	= 0;
+}
+
 static __always_inline void set_raddr_seg(struct mlx4_wqe_raddr_seg *rseg,
 					  u64 remote_addr, u32 rkey)
 {
@@ -1434,6 +1473,21 @@ static int build_lso_seg(struct mlx4_lso_seg *wqe, struct ib_send_wr *wr,
 	return 0;
 }
 
+static __be32 send_ieth(struct ib_send_wr *wr)
+{
+	switch (wr->opcode) {
+	case IB_WR_SEND_WITH_IMM:
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		return wr->ex.imm_data;
+
+	case IB_WR_SEND_WITH_INV:
+		return cpu_to_be32(wr->ex.invalidate_rkey);
+
+	default:
+		return 0;
+	}
+}
+
 int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
@@ -1480,11 +1534,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				     MLX4_WQE_CTRL_TCP_UDP_CSUM) : 0) |
 			qp->sq_signal_bits;
 
-		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
-		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
-			ctrl->imm = wr->ex.imm_data;
-		else
-			ctrl->imm = 0;
+		ctrl->imm = send_ieth(wr);
 
 		wqe += sizeof *ctrl;
 		size = sizeof *ctrl / 16;
@@ -1516,6 +1566,18 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				size += sizeof (struct mlx4_wqe_raddr_seg) / 16;
 				break;
 
+			case IB_WR_LOCAL_INV:
+				set_local_inv_seg(wqe, wr->ex.invalidate_rkey);
+				wqe  += sizeof (struct mlx4_wqe_local_inval_seg);
+				size += sizeof (struct mlx4_wqe_local_inval_seg) / 16;
+				break;
+
+			case IB_WR_FAST_REG_MR:
+				set_fmr_seg(wqe, wr);
+				wqe  += sizeof (struct mlx4_wqe_fmr_seg);
+				size += sizeof (struct mlx4_wqe_fmr_seg) / 16;
+				break;
+
 			default:
 				/* No extra segments required for sends */
 				break;
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 2b5006b..1180fca 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -198,7 +198,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_C_MPT_ENTRY_SZ_OFFSET	0x8e
 #define QUERY_DEV_CAP_MTT_ENTRY_SZ_OFFSET	0x90
 #define QUERY_DEV_CAP_D_MPT_ENTRY_SZ_OFFSET	0x92
-#define QUERY_DEV_CAP_BMME_FLAGS_OFFSET		0x97
+#define QUERY_DEV_CAP_BMME_FLAGS_OFFSET		0x94
 #define QUERY_DEV_CAP_RSVD_LKEY_OFFSET		0x98
 #define QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET		0xa0
 
@@ -373,12 +373,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		}
 	}
 
-	if (dev_cap->bmme_flags & 1)
-		mlx4_dbg(dev, "Base MM extensions: yes "
-			 "(flags %d, rsvd L_Key %08x)\n",
-			 dev_cap->bmme_flags, dev_cap->reserved_lkey);
-	else
-		mlx4_dbg(dev, "Base MM extensions: no\n");
+	mlx4_dbg(dev, "Base MM extensions: flags %08x, rsvd L_Key %08x\n",
+		 dev_cap->bmme_flags, dev_cap->reserved_lkey);
 
 	/*
 	 * Each UAR has 4 EQ doorbells; so if a UAR is reserved, then
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index a0e046c..fbf0e22 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -98,7 +98,7 @@ struct mlx4_dev_cap {
 	int cmpt_entry_sz;
 	int mtt_entry_sz;
 	int resize_srq;
-	u8  bmme_flags;
+	u32 bmme_flags;
 	u32 reserved_lkey;
 	u64 max_icm_sz;
 	int max_gso_sz;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index d373601..8e1d24c 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -158,6 +158,8 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_msg_sz         = dev_cap->max_msg_sz;
 	dev->caps.page_size_cap	     = ~(u32) (dev_cap->min_page_sz - 1);
 	dev->caps.flags		     = dev_cap->flags;
+	dev->caps.bmme_flags	     = dev_cap->bmme_flags;
+	dev->caps.reserved_lkey	     = dev_cap->reserved_lkey;
 	dev->caps.stat_rate_support  = dev_cap->stat_rate_support;
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;
 
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 03a9abc..66c6f84 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -47,7 +47,7 @@ struct mlx4_mpt_entry {
 	__be32 flags;
 	__be32 qpn;
 	__be32 key;
-	__be32 pd;
+	__be32 pd_flags;
 	__be64 start;
 	__be64 length;
 	__be32 lkey;
@@ -61,11 +61,15 @@ struct mlx4_mpt_entry {
 } __attribute__((packed));
 
 #define MLX4_MPT_FLAG_SW_OWNS	    (0xfUL << 28)
+#define MLX4_MPT_FLAG_FREE	    (0x3UL << 28)
 #define MLX4_MPT_FLAG_MIO	    (1 << 17)
 #define MLX4_MPT_FLAG_BIND_ENABLE   (1 << 15)
 #define MLX4_MPT_FLAG_PHYSICAL	    (1 <<  9)
 #define MLX4_MPT_FLAG_REGION	    (1 <<  8)
 
+#define MLX4_MPT_PD_FLAG_FAST_REG   (1 << 26)
+#define MLX4_MPT_PD_FLAG_EN_INV	    (3 << 24)
+
 #define MLX4_MTT_FLAG_PRESENT		1
 
 #define MLX4_MPT_STATUS_SW		0xF0
@@ -314,21 +318,30 @@ int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
 
 	memset(mpt_entry, 0, sizeof *mpt_entry);
 
-	mpt_entry->flags = cpu_to_be32(MLX4_MPT_FLAG_SW_OWNS	 |
-				       MLX4_MPT_FLAG_MIO	 |
+	mpt_entry->flags = cpu_to_be32(MLX4_MPT_FLAG_MIO	 |
 				       MLX4_MPT_FLAG_REGION	 |
 				       mr->access);
 
 	mpt_entry->key	       = cpu_to_be32(key_to_hw_index(mr->key));
-	mpt_entry->pd	       = cpu_to_be32(mr->pd);
+	mpt_entry->pd_flags    = cpu_to_be32(mr->pd | MLX4_MPT_PD_FLAG_EN_INV);
 	mpt_entry->start       = cpu_to_be64(mr->iova);
 	mpt_entry->length      = cpu_to_be64(mr->size);
 	mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
+
 	if (mr->mtt.order < 0) {
 		mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
 		mpt_entry->mtt_seg = 0;
-	} else
+	} else {
 		mpt_entry->mtt_seg = cpu_to_be64(mlx4_mtt_addr(dev, &mr->mtt));
+	}
+
+	if (mr->mtt.order >= 0 && mr->mtt.page_shift == 0) {
+		/* fast register MR in free state */
+		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_FREE);
+		mpt_entry->pd_flags |= cpu_to_be32(MLX4_MPT_PD_FLAG_FAST_REG);
+	} else {
+		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_SW_OWNS);
+	}
 
 	err = mlx4_SW2HW_MPT(dev, mailbox,
 			     key_to_hw_index(mr->key) & (dev->caps.num_mpts - 1));
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 81b3dd5..655ea0d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -68,6 +68,14 @@ enum {
 	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21
 };
 
+enum {
+	MLX4_BMME_FLAG_LOCAL_INV	= 1 <<  6,
+	MLX4_BMME_FLAG_REMOTE_INV	= 1 <<  7,
+	MLX4_BMME_FLAG_TYPE_2_WIN	= 1 <<  9,
+	MLX4_BMME_FLAG_RESERVED_LKEY	= 1 << 10,
+	MLX4_BMME_FLAG_FAST_REG_WR	= 1 << 11,
+};
+
 enum mlx4_event {
 	MLX4_EVENT_TYPE_COMP		   = 0x00,
 	MLX4_EVENT_TYPE_PATH_MIG	   = 0x01,
@@ -184,6 +192,8 @@ struct mlx4_caps {
 	u32			max_msg_sz;
 	u32			page_size_cap;
 	u32			flags;
+	u32			bmme_flags;
+	u32			reserved_lkey;
 	u16			stat_rate_support;
 	u8			port_width_cap[MLX4_MAX_PORTS + 1];
 	int			max_gso_sz;
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 7f128b2..5cb34fb 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -233,6 +233,14 @@ struct mlx4_wqe_bind_seg {
 	__be64			length;
 };
 
+enum {
+	MLX4_WQE_FMR_PERM_LOCAL_READ	= 1 << 27,
+	MLX4_WQE_FMR_PERM_LOCAL_WRITE	= 1 << 28,
+	MLX4_WQE_FMR_PERM_REMOTE_READ	= 1 << 29,
+	MLX4_WQE_FMR_PERM_REMOTE_WRITE	= 1 << 30,
+	MLX4_WQE_FMR_PERM_ATOMIC	= 1 << 31
+};
+
 struct mlx4_wqe_fmr_seg {
 	__be32			flags;
 	__be32			mem_key;
@@ -255,11 +263,9 @@ struct mlx4_wqe_fmr_ext_seg {
 };
 
 struct mlx4_wqe_local_inval_seg {
-	u8			flags;
-	u8			reserved1[3];
+	__be32			flags;
 	__be32			mem_key;
-	u8			reserved2[3];
-	u8			guest_id;
+	__be32			guest_id;
 	__be64			pa;
 };
 
