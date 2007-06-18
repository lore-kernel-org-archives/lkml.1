Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXFRPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXFRPtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762806AbXFRPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:49:28 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:16440 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbXFRPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:49:25 -0400
X-IronPort-AV: i="4.16,435,1175497200"; 
   d="scan'208"; a="5076251:sNHT51377052"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 18 Jun 2007 08:49:20 -0700
Message-ID: <adad4ztfekf.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jun 2007 15:49:20.0939 (UTC) FILETIME=[3C7387B0:01C7B1C0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a bunch of fixes to the new mlx4 driver.  This pull is
bigger than I would have liked after -rc5, but Mellanox discovered a
problem that required a firmware change and also some driver help to
fix.  Since this is a new driver for 2.6.22, which is for new hardware
that no one has in production yet, I think it's better to merge this
early even if it risks introducing a bug, rather than have a driver
in 2.6.22 that doesn't work at all with current adapter firmware.

Jack Morgenstein (1):
      IB/mlx4: Handle buffer wraparound in __mlx4_ib_cq_clean()

Roland Dreier (6):
      IB/mlx4: Fix handling of wq->tail for send completions
      IB/mlx4: Fix warning in rounding up queue sizes
      IB/mlx4: Handle new FW requirement for send request prefetching
      IB/mlx4: Get rid of max_inline_data calculation
      IB/mlx4: Handle FW command interface rev 3
      IB/mlx4: Make sure inline data segments don't cross a 64 byte boundary

 drivers/infiniband/hw/mlx4/cq.c      |   19 ++--
 drivers/infiniband/hw/mlx4/main.c    |   16 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    5 +-
 drivers/infiniband/hw/mlx4/qp.c      |  196 ++++++++++++++++++++++------------
 drivers/infiniband/hw/mlx4/user.h    |    9 +-
 drivers/net/mlx4/fw.c                |  110 +++++++++++++-------
 drivers/net/mlx4/fw.h                |   10 +-
 drivers/net/mlx4/main.c              |   14 ++-
 include/linux/mlx4/cmd.h             |    1 +
 include/linux/mlx4/device.h          |   13 ++-
 include/linux/mlx4/qp.h              |    4 +
 11 files changed, 259 insertions(+), 138 deletions(-)


diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index b2a290c..660b27a 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -354,8 +354,8 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
 		wqe_ctr = be16_to_cpu(cqe->wqe_index);
-		wq->tail += wqe_ctr - (u16) wq->tail;
-		wc->wr_id = wq->wrid[wq->tail & (wq->max - 1)];
+		wq->tail += (u16) (wqe_ctr - (u16) wq->tail);
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	} else if ((*cur_qp)->ibqp.srq) {
 		srq = to_msrq((*cur_qp)->ibqp.srq);
@@ -364,7 +364,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
 	} else {
 		wq	  = &(*cur_qp)->rq;
-		wc->wr_id = wq->wrid[wq->tail & (wq->max - 1)];
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	}
 
@@ -478,7 +478,8 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 {
 	u32 prod_index;
 	int nfreed = 0;
-	struct mlx4_cqe *cqe;
+	struct mlx4_cqe *cqe, *dest;
+	u8 owner_bit;
 
 	/*
 	 * First we need to find the current producer index, so we
@@ -501,9 +502,13 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_ib_free_srq_wqe(srq, be16_to_cpu(cqe->wqe_index));
 			++nfreed;
-		} else if (nfreed)
-			memcpy(get_cqe(cq, (prod_index + nfreed) & cq->ibcq.cqe),
-			       cqe, sizeof *cqe);
+		} else if (nfreed) {
+			dest = get_cqe(cq, (prod_index + nfreed) & cq->ibcq.cqe);
+			owner_bit = dest->owner_sr_opcode & MLX4_CQE_OWNER_MASK;
+			memcpy(dest, cqe, sizeof *cqe);
+			dest->owner_sr_opcode = owner_bit |
+				(dest->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK);
+		}
 	}
 
 	if (nfreed) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 402f3a2..1095c82 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -125,7 +125,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
-	props->max_pkeys	   = dev->dev->caps.pkey_table_len;
+	props->max_pkeys	   = dev->dev->caps.pkey_table_len[1];
 	props->max_mcast_grp	   = dev->dev->caps.num_mgms + dev->dev->caps.num_amgms;
 	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
@@ -168,9 +168,9 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= out_mad->data[32] & 0xf;
 	props->phys_state	= out_mad->data[33] >> 4;
 	props->port_cap_flags	= be32_to_cpup((__be32 *) (out_mad->data + 20));
-	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len;
+	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= 0x80000000;
-	props->pkey_tbl_len	= to_mdev(ibdev)->dev->caps.pkey_table_len;
+	props->pkey_tbl_len	= to_mdev(ibdev)->dev->caps.pkey_table_len[port];
 	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
 	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
 	props->active_width	= out_mad->data[31] & 0xf;
@@ -280,8 +280,14 @@ static int mlx4_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_viols,
 		return PTR_ERR(mailbox);
 
 	memset(mailbox->buf, 0, 256);
-	*(u8 *) mailbox->buf	     = !!reset_qkey_viols << 6;
-	((__be32 *) mailbox->buf)[2] = cpu_to_be32(cap_mask);
+
+	if (dev->dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
+		*(u8 *) mailbox->buf	     = !!reset_qkey_viols << 6;
+		((__be32 *) mailbox->buf)[2] = cpu_to_be32(cap_mask);
+	} else {
+		((u8 *) mailbox->buf)[3]     = !!reset_qkey_viols;
+		((__be32 *) mailbox->buf)[1] = cpu_to_be32(cap_mask);
+	}
 
 	err = mlx4_cmd(dev->dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
 		       MLX4_CMD_TIME_CLASS_B);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 93dac71..24ccadd 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -95,7 +95,8 @@ struct mlx4_ib_mr {
 struct mlx4_ib_wq {
 	u64		       *wrid;
 	spinlock_t		lock;
-	int			max;
+	int			wqe_cnt;
+	int			max_post;
 	int			max_gs;
 	int			offset;
 	int			wqe_shift;
@@ -113,6 +114,7 @@ struct mlx4_ib_qp {
 
 	u32			doorbell_qpn;
 	__be32			sq_signal_bits;
+	int			sq_spare_wqes;
 	struct mlx4_ib_wq	sq;
 
 	struct ib_umem	       *umem;
@@ -123,6 +125,7 @@ struct mlx4_ib_qp {
 	u8			alt_port;
 	u8			atomic_rd_en;
 	u8			resp_depth;
+	u8			sq_no_prefetch;
 	u8			state;
 };
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 5c6d054..f8a1a08 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -109,6 +109,20 @@ static void *get_send_wqe(struct mlx4_ib_qp *qp, int n)
 	return get_wqe(qp, qp->sq.offset + (n << qp->sq.wqe_shift));
 }
 
+/*
+ * Stamp a SQ WQE so that it is invalid if prefetched by marking the
+ * first four bytes of every 64 byte chunk with 0xffffffff, except for
+ * the very first chunk of the WQE.
+ */
+static void stamp_send_wqe(struct mlx4_ib_qp *qp, int n)
+{
+	u32 *wqe = get_send_wqe(qp, n);
+	int i;
+
+	for (i = 16; i < 1 << (qp->sq.wqe_shift - 2); i += 16)
+		wqe[i] = 0xffffffff;
+}
+
 static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 {
 	struct ib_event event;
@@ -178,6 +192,8 @@ static int send_wqe_overhead(enum ib_qp_type type)
 	case IB_QPT_GSI:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
 			ALIGN(MLX4_IB_UD_HEADER_SIZE +
+			      DIV_ROUND_UP(MLX4_IB_UD_HEADER_SIZE,
+					   MLX4_INLINE_ALIGN) *
 			      sizeof (struct mlx4_wqe_inline_seg),
 			      sizeof (struct mlx4_wqe_data_seg)) +
 			ALIGN(4 +
@@ -201,18 +217,18 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 		if (cap->max_recv_wr)
 			return -EINVAL;
 
-		qp->rq.max = qp->rq.max_gs = 0;
+		qp->rq.wqe_cnt = qp->rq.max_gs = 0;
 	} else {
 		/* HW requires >= 1 RQ entry with >= 1 gather entry */
 		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge))
 			return -EINVAL;
 
-		qp->rq.max	 = roundup_pow_of_two(max(1, cap->max_recv_wr));
-		qp->rq.max_gs	 = roundup_pow_of_two(max(1, cap->max_recv_sge));
+		qp->rq.wqe_cnt	 = roundup_pow_of_two(max(1U, cap->max_recv_wr));
+		qp->rq.max_gs	 = roundup_pow_of_two(max(1U, cap->max_recv_sge));
 		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
 	}
 
-	cap->max_recv_wr  = qp->rq.max;
+	cap->max_recv_wr  = qp->rq.max_post = qp->rq.wqe_cnt;
 	cap->max_recv_sge = qp->rq.max_gs;
 
 	return 0;
@@ -236,8 +252,6 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	    cap->max_send_sge + 2 > dev->dev->caps.max_sq_sg)
 		return -EINVAL;
 
-	qp->sq.max = cap->max_send_wr ? roundup_pow_of_two(cap->max_send_wr) : 1;
-
 	qp->sq.wqe_shift = ilog2(roundup_pow_of_two(max(cap->max_send_sge *
 							sizeof (struct mlx4_wqe_data_seg),
 							cap->max_inline_data +
@@ -246,20 +260,27 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	qp->sq.max_gs    = ((1 << qp->sq.wqe_shift) - send_wqe_overhead(type)) /
 		sizeof (struct mlx4_wqe_data_seg);
 
-	qp->buf_size = (qp->rq.max << qp->rq.wqe_shift) +
-		(qp->sq.max << qp->sq.wqe_shift);
+	/*
+	 * We need to leave 2 KB + 1 WQE of headroom in the SQ to
+	 * allow HW to prefetch.
+	 */
+	qp->sq_spare_wqes = (2048 >> qp->sq.wqe_shift) + 1;
+	qp->sq.wqe_cnt = roundup_pow_of_two(cap->max_send_wr + qp->sq_spare_wqes);
+
+	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
+		(qp->sq.wqe_cnt << qp->sq.wqe_shift);
 	if (qp->rq.wqe_shift > qp->sq.wqe_shift) {
 		qp->rq.offset = 0;
-		qp->sq.offset = qp->rq.max << qp->rq.wqe_shift;
+		qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
 	} else {
-		qp->rq.offset = qp->sq.max << qp->sq.wqe_shift;
+		qp->rq.offset = qp->sq.wqe_cnt << qp->sq.wqe_shift;
 		qp->sq.offset = 0;
 	}
 
-	cap->max_send_wr     = qp->sq.max;
-	cap->max_send_sge    = qp->sq.max_gs;
-	cap->max_inline_data = (1 << qp->sq.wqe_shift) - send_wqe_overhead(type) -
-		sizeof (struct mlx4_wqe_inline_seg);
+	cap->max_send_wr  = qp->sq.max_post = qp->sq.wqe_cnt - qp->sq_spare_wqes;
+	cap->max_send_sge = qp->sq.max_gs;
+	/* We don't support inline sends for kernel QPs (yet) */
+	cap->max_inline_data = 0;
 
 	return 0;
 }
@@ -267,11 +288,11 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 static int set_user_sq_size(struct mlx4_ib_qp *qp,
 			    struct mlx4_ib_create_qp *ucmd)
 {
-	qp->sq.max       = 1 << ucmd->log_sq_bb_count;
+	qp->sq.wqe_cnt   = 1 << ucmd->log_sq_bb_count;
 	qp->sq.wqe_shift = ucmd->log_sq_stride;
 
-	qp->buf_size = (qp->rq.max << qp->rq.wqe_shift) +
-		(qp->sq.max << qp->sq.wqe_shift);
+	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
+		(qp->sq.wqe_cnt << qp->sq.wqe_shift);
 
 	return 0;
 }
@@ -307,6 +328,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 		}
 
+		qp->sq_no_prefetch = ucmd.sq_no_prefetch;
+
 		err = set_user_sq_size(qp, &ucmd);
 		if (err)
 			goto err;
@@ -334,6 +357,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 				goto err_mtt;
 		}
 	} else {
+		qp->sq_no_prefetch = 0;
+
 		err = set_kernel_sq_size(dev, &init_attr->cap, init_attr->qp_type, qp);
 		if (err)
 			goto err;
@@ -360,16 +385,13 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid  = kmalloc(qp->sq.max * sizeof (u64), GFP_KERNEL);
-		qp->rq.wrid  = kmalloc(qp->rq.max * sizeof (u64), GFP_KERNEL);
+		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), GFP_KERNEL);
+		qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), GFP_KERNEL);
 
 		if (!qp->sq.wrid || !qp->rq.wrid) {
 			err = -ENOMEM;
 			goto err_wrid;
 		}
-
-		/* We don't support inline sends for kernel QPs (yet) */
-		init_attr->cap.max_inline_data = 0;
 	}
 
 	err = mlx4_qp_alloc(dev->dev, sqpn, &qp->mqp);
@@ -583,24 +605,6 @@ int mlx4_ib_destroy_qp(struct ib_qp *qp)
 	return 0;
 }
 
-static void init_port(struct mlx4_ib_dev *dev, int port)
-{
-	struct mlx4_init_port_param param;
-	int err;
-
-	memset(&param, 0, sizeof param);
-
-	param.port_width_cap = dev->dev->caps.port_width_cap;
-	param.vl_cap	     = dev->dev->caps.vl_cap;
-	param.mtu	     = ib_mtu_enum_to_int(dev->dev->caps.mtu_cap);
-	param.max_gid	     = dev->dev->caps.gid_table_len;
-	param.max_pkey	     = dev->dev->caps.pkey_table_len;
-
-	err = mlx4_INIT_PORT(dev->dev, &param, port);
-	if (err)
-		printk(KERN_WARNING "INIT_PORT failed, return code %d.\n", err);
-}
-
 static int to_mlx4_st(enum ib_qp_type type)
 {
 	switch (type) {
@@ -674,9 +678,9 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 	path->counter_index = 0xff;
 
 	if (ah->ah_flags & IB_AH_GRH) {
-		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len) {
+		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
 			printk(KERN_ERR "sgid_index (%u) too large. max is %d\n",
-			       ah->grh.sgid_index, dev->dev->caps.gid_table_len - 1);
+			       ah->grh.sgid_index, dev->dev->caps.gid_table_len[port] - 1);
 			return -1;
 		}
 
@@ -743,14 +747,17 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		context->mtu_msgmax = (attr->path_mtu << 5) | 31;
 	}
 
-	if (qp->rq.max)
-		context->rq_size_stride = ilog2(qp->rq.max) << 3;
+	if (qp->rq.wqe_cnt)
+		context->rq_size_stride = ilog2(qp->rq.wqe_cnt) << 3;
 	context->rq_size_stride |= qp->rq.wqe_shift - 4;
 
-	if (qp->sq.max)
-		context->sq_size_stride = ilog2(qp->sq.max) << 3;
+	if (qp->sq.wqe_cnt)
+		context->sq_size_stride = ilog2(qp->sq.wqe_cnt) << 3;
 	context->sq_size_stride |= qp->sq.wqe_shift - 4;
 
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+		context->sq_size_stride |= !!qp->sq_no_prefetch << 7;
+
 	if (qp->ibqp.uobject)
 		context->usr_page = cpu_to_be32(to_mucontext(ibqp->uobject->context)->uar.index);
 	else
@@ -789,13 +796,14 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		if (attr->alt_pkey_index >= dev->dev->caps.pkey_table_len)
-			return -EINVAL;
-
 		if (attr->alt_port_num == 0 ||
 		    attr->alt_port_num > dev->dev->caps.num_ports)
 			return -EINVAL;
 
+		if (attr->alt_pkey_index >=
+		    dev->dev->caps.pkey_table_len[attr->alt_port_num])
+			return -EINVAL;
+
 		if (mlx4_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
 				  attr->alt_port_num))
 			return -EINVAL;
@@ -884,16 +892,19 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 
 	/*
 	 * Before passing a kernel QP to the HW, make sure that the
-	 * ownership bits of the send queue are set so that the
-	 * hardware doesn't start processing stale work requests.
+	 * ownership bits of the send queue are set and the SQ
+	 * headroom is stamped so that the hardware doesn't start
+	 * processing stale work requests.
 	 */
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		struct mlx4_wqe_ctrl_seg *ctrl;
 		int i;
 
-		for (i = 0; i < qp->sq.max; ++i) {
+		for (i = 0; i < qp->sq.wqe_cnt; ++i) {
 			ctrl = get_send_wqe(qp, i);
 			ctrl->owner_opcode = cpu_to_be32(1 << 31);
+
+			stamp_send_wqe(qp, i);
 		}
 	}
 
@@ -923,7 +934,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	 */
 	if (is_qp0(dev, qp)) {
 		if (cur_state != IB_QPS_RTR && new_state == IB_QPS_RTR)
-			init_port(dev, qp->port);
+			if (mlx4_INIT_PORT(dev->dev, qp->port))
+				printk(KERN_WARNING "INIT_PORT failed for port %d\n",
+				       qp->port);
 
 		if (cur_state != IB_QPS_RESET && cur_state != IB_QPS_ERR &&
 		    (new_state == IB_QPS_RESET || new_state == IB_QPS_ERR))
@@ -986,16 +999,17 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask))
 		goto out;
 
-	if ((attr_mask & IB_QP_PKEY_INDEX) &&
-	     attr->pkey_index >= dev->dev->caps.pkey_table_len) {
-		goto out;
-	}
-
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
 		goto out;
 	}
 
+	if (attr_mask & IB_QP_PKEY_INDEX) {
+		int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+		if (attr->pkey_index >= dev->dev->caps.pkey_table_len[p])
+			goto out;
+	}
+
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic > dev->dev->caps.max_qp_init_rdma) {
 		goto out;
@@ -1037,6 +1051,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	u16 pkey;
 	int send_size;
 	int header_size;
+	int spc;
 	int i;
 
 	send_size = 0;
@@ -1112,10 +1127,43 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		printk("\n");
 	}
 
-	inl->byte_count = cpu_to_be32(1 << 31 | header_size);
-	memcpy(inl + 1, sqp->header_buf, header_size);
+	/*
+	 * Inline data segments may not cross a 64 byte boundary.  If
+	 * our UD header is bigger than the space available up to the
+	 * next 64 byte boundary in the WQE, use two inline data
+	 * segments to hold the UD header.
+	 */
+	spc = MLX4_INLINE_ALIGN -
+		((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
+	if (header_size <= spc) {
+		inl->byte_count = cpu_to_be32(1 << 31 | header_size);
+		memcpy(inl + 1, sqp->header_buf, header_size);
+		i = 1;
+	} else {
+		inl->byte_count = cpu_to_be32(1 << 31 | spc);
+		memcpy(inl + 1, sqp->header_buf, spc);
 
-	return ALIGN(sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
+		inl = (void *) (inl + 1) + spc;
+		memcpy(inl + 1, sqp->header_buf + spc, header_size - spc);
+		/*
+		 * Need a barrier here to make sure all the data is
+		 * visible before the byte_count field is set.
+		 * Otherwise the HCA prefetcher could grab the 64-byte
+		 * chunk with this inline segment and get a valid (!=
+		 * 0xffffffff) byte count but stale data, and end up
+		 * processing generating a packet with bad headers.
+		 *
+		 * The first inline segment's byte_count field doesn't
+		 * need a barrier, because it comes after a
+		 * control/MLX segment and therefore is at an offset
+		 * of 16 mod 64.
+		 */
+		wmb();
+		inl->byte_count = cpu_to_be32(1 << 31 | (header_size - spc));
+		i = 2;
+	}
+
+	return ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
 }
 
 static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq)
@@ -1124,7 +1172,7 @@ static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq
 	struct mlx4_ib_cq *cq;
 
 	cur = wq->head - wq->tail;
-	if (likely(cur + nreq < wq->max))
+	if (likely(cur + nreq < wq->max_post))
 		return 0;
 
 	cq = to_mcq(ib_cq);
@@ -1132,7 +1180,7 @@ static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq
 	cur = wq->head - wq->tail;
 	spin_unlock(&cq->lock);
 
-	return cur + nreq >= wq->max;
+	return cur + nreq >= wq->max_post;
 }
 
 int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
@@ -1165,8 +1213,8 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			goto out;
 		}
 
-		ctrl = wqe = get_send_wqe(qp, ind & (qp->sq.max - 1));
-		qp->sq.wrid[ind & (qp->sq.max - 1)] = wr->wr_id;
+		ctrl = wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
+		qp->sq.wrid[ind & (qp->sq.wqe_cnt - 1)] = wr->wr_id;
 
 		ctrl->srcrb_flags =
 			(wr->send_flags & IB_SEND_SIGNALED ?
@@ -1301,7 +1349,16 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
-			(ind & qp->sq.max ? cpu_to_be32(1 << 31) : 0);
+			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0);
+
+		/*
+		 * We can improve latency by not stamping the last
+		 * send queue WQE until after ringing the doorbell, so
+		 * only stamp here if there are still more WQEs to post.
+		 */
+		if (wr->next)
+			stamp_send_wqe(qp, (ind + qp->sq_spare_wqes) &
+				       (qp->sq.wqe_cnt - 1));
 
 		++ind;
 	}
@@ -1324,6 +1381,9 @@ out:
 		 * and reach the HCA out of order.
 		 */
 		mmiowb();
+
+		stamp_send_wqe(qp, (ind + qp->sq_spare_wqes - 1) &
+			       (qp->sq.wqe_cnt - 1));
 	}
 
 	spin_unlock_irqrestore(&qp->rq.lock, flags);
@@ -1344,7 +1404,7 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 	spin_lock_irqsave(&qp->rq.lock, flags);
 
-	ind = qp->rq.head & (qp->rq.max - 1);
+	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (mlx4_wq_overflow(&qp->rq, nreq, qp->ibqp.send_cq)) {
@@ -1375,7 +1435,7 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		qp->rq.wrid[ind] = wr->wr_id;
 
-		ind = (ind + 1) & (qp->rq.max - 1);
+		ind = (ind + 1) & (qp->rq.wqe_cnt - 1);
 	}
 
 out:
diff --git a/drivers/infiniband/hw/mlx4/user.h b/drivers/infiniband/hw/mlx4/user.h
index 88c72d5..e2d11be 100644
--- a/drivers/infiniband/hw/mlx4/user.h
+++ b/drivers/infiniband/hw/mlx4/user.h
@@ -39,7 +39,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MLX4_IB_UVERBS_ABI_VERSION	2
+#define MLX4_IB_UVERBS_ABI_VERSION	3
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -87,9 +87,10 @@ struct mlx4_ib_create_srq_resp {
 struct mlx4_ib_create_qp {
 	__u64	buf_addr;
 	__u64	db_addr;
-        __u8	log_sq_bb_count;
-        __u8	log_sq_stride;
-        __u8	reserved[6];
+	__u8	log_sq_bb_count;
+	__u8	log_sq_stride;
+	__u8	sq_no_prefetch;
+	__u8	reserved[5];
 };
 
 #endif /* MLX4_IB_USER_H */
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index e7ca118..d2b0653 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -38,7 +38,9 @@
 #include "icm.h"
 
 enum {
-	MLX4_COMMAND_INTERFACE_REV	= 1
+	MLX4_COMMAND_INTERFACE_MIN_REV		= 2,
+	MLX4_COMMAND_INTERFACE_MAX_REV		= 3,
+	MLX4_COMMAND_INTERFACE_NEW_PORT_CMDS	= 3,
 };
 
 extern void __buggy_use_of_MLX4_GET(void);
@@ -107,6 +109,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	u16 size;
 	u16 stat_rate;
 	int err;
+	int i;
 
 #define QUERY_DEV_CAP_OUT_SIZE		       0x100
 #define QUERY_DEV_CAP_MAX_SRQ_SZ_OFFSET		0x10
@@ -176,7 +179,6 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 
 	err = mlx4_cmd_box(dev, 0, mailbox->dma, 0, 0, MLX4_CMD_QUERY_DEV_CAP,
 			   MLX4_CMD_TIME_CLASS_A);
-
 	if (err)
 		goto out;
 
@@ -216,18 +218,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev_cap->max_rdma_global = 1 << (field & 0x3f);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_ACK_DELAY_OFFSET);
 	dev_cap->local_ca_ack_delay = field & 0x1f;
-	MLX4_GET(field, outbox, QUERY_DEV_CAP_MTU_WIDTH_OFFSET);
-	dev_cap->max_mtu	= field >> 4;
-	dev_cap->max_port_width = field & 0xf;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_VL_PORT_OFFSET);
-	dev_cap->max_vl    = field >> 4;
 	dev_cap->num_ports = field & 0xf;
-	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_GID_OFFSET);
-	dev_cap->max_gids = 1 << (field & 0xf);
 	MLX4_GET(stat_rate, outbox, QUERY_DEV_CAP_RATE_SUPPORT_OFFSET);
 	dev_cap->stat_rate_support = stat_rate;
-	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PKEY_OFFSET);
-	dev_cap->max_pkeys = 1 << (field & 0xf);
 	MLX4_GET(dev_cap->flags, outbox, QUERY_DEV_CAP_FLAGS_OFFSET);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_UAR_OFFSET);
 	dev_cap->reserved_uars = field >> 4;
@@ -304,6 +298,42 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	MLX4_GET(dev_cap->max_icm_sz, outbox,
 		 QUERY_DEV_CAP_MAX_ICM_SZ_OFFSET);
 
+	if (dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
+		for (i = 1; i <= dev_cap->num_ports; ++i) {
+			MLX4_GET(field, outbox, QUERY_DEV_CAP_VL_PORT_OFFSET);
+			dev_cap->max_vl[i]	   = field >> 4;
+			MLX4_GET(field, outbox, QUERY_DEV_CAP_MTU_WIDTH_OFFSET);
+			dev_cap->max_mtu[i]	   = field >> 4;
+			dev_cap->max_port_width[i] = field & 0xf;
+			MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_GID_OFFSET);
+			dev_cap->max_gids[i]	   = 1 << (field & 0xf);
+			MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PKEY_OFFSET);
+			dev_cap->max_pkeys[i]	   = 1 << (field & 0xf);
+		}
+	} else {
+#define QUERY_PORT_MTU_OFFSET			0x01
+#define QUERY_PORT_WIDTH_OFFSET			0x06
+#define QUERY_PORT_MAX_GID_PKEY_OFFSET		0x07
+#define QUERY_PORT_MAX_VL_OFFSET		0x0b
+
+		for (i = 1; i <= dev_cap->num_ports; ++i) {
+			err = mlx4_cmd_box(dev, 0, mailbox->dma, i, 0, MLX4_CMD_QUERY_PORT,
+					   MLX4_CMD_TIME_CLASS_B);
+			if (err)
+				goto out;
+
+			MLX4_GET(field, outbox, QUERY_PORT_MTU_OFFSET);
+			dev_cap->max_mtu[i]	   = field & 0xf;
+			MLX4_GET(field, outbox, QUERY_PORT_WIDTH_OFFSET);
+			dev_cap->max_port_width[i] = field & 0xf;
+			MLX4_GET(field, outbox, QUERY_PORT_MAX_GID_PKEY_OFFSET);
+			dev_cap->max_gids[i]	   = 1 << (field >> 4);
+			dev_cap->max_pkeys[i]	   = 1 << (field & 0xf);
+			MLX4_GET(field, outbox, QUERY_PORT_MAX_VL_OFFSET);
+			dev_cap->max_vl[i]	   = field & 0xf;
+		}
+	}
+
 	if (dev_cap->bmme_flags & 1)
 		mlx4_dbg(dev, "Base MM extensions: yes "
 			 "(flags %d, rsvd L_Key %08x)\n",
@@ -338,8 +368,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	mlx4_dbg(dev, "Max CQEs: %d, max WQEs: %d, max SRQ WQEs: %d\n",
 		 dev_cap->max_cq_sz, dev_cap->max_qp_sz, dev_cap->max_srq_sz);
 	mlx4_dbg(dev, "Local CA ACK delay: %d, max MTU: %d, port width cap: %d\n",
-		 dev_cap->local_ca_ack_delay, 128 << dev_cap->max_mtu,
-		 dev_cap->max_port_width);
+		 dev_cap->local_ca_ack_delay, 128 << dev_cap->max_mtu[1],
+		 dev_cap->max_port_width[1]);
 	mlx4_dbg(dev, "Max SQ desc size: %d, max SQ S/G: %d\n",
 		 dev_cap->max_sq_desc_sz, dev_cap->max_sq_sg);
 	mlx4_dbg(dev, "Max RQ desc size: %d, max RQ S/G: %d\n",
@@ -491,7 +521,8 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 		((fw_ver & 0x0000ffffull) << 16);
 
 	MLX4_GET(cmd_if_rev, outbox, QUERY_FW_CMD_IF_REV_OFFSET);
-	if (cmd_if_rev != MLX4_COMMAND_INTERFACE_REV) {
+	if (cmd_if_rev < MLX4_COMMAND_INTERFACE_MIN_REV ||
+	    cmd_if_rev > MLX4_COMMAND_INTERFACE_MAX_REV) {
 		mlx4_err(dev, "Installed FW has unsupported "
 			 "command interface revision %d.\n",
 			 cmd_if_rev);
@@ -499,12 +530,15 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 			 (int) (dev->caps.fw_ver >> 32),
 			 (int) (dev->caps.fw_ver >> 16) & 0xffff,
 			 (int) dev->caps.fw_ver & 0xffff);
-		mlx4_err(dev, "This driver version supports only revision %d.\n",
-			 MLX4_COMMAND_INTERFACE_REV);
+		mlx4_err(dev, "This driver version supports only revisions %d to %d.\n",
+			 MLX4_COMMAND_INTERFACE_MIN_REV, MLX4_COMMAND_INTERFACE_MAX_REV);
 		err = -ENODEV;
 		goto out;
 	}
 
+	if (cmd_if_rev < MLX4_COMMAND_INTERFACE_NEW_PORT_CMDS)
+		dev->flags |= MLX4_FLAG_OLD_PORT_CMDS;
+
 	MLX4_GET(lg, outbox, QUERY_FW_MAX_CMD_OFFSET);
 	cmd->max_cmds = 1 << lg;
 
@@ -708,13 +742,15 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 	return err;
 }
 
-int mlx4_INIT_PORT(struct mlx4_dev *dev, struct mlx4_init_port_param *param, int port)
+int mlx4_INIT_PORT(struct mlx4_dev *dev, int port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	u32 *inbox;
 	int err;
 	u32 flags;
+	u16 field;
 
+	if (dev->flags & MLX4_FLAG_OLD_PORT_CMDS) {
 #define INIT_PORT_IN_SIZE          256
 #define INIT_PORT_FLAGS_OFFSET     0x00
 #define INIT_PORT_FLAG_SIG         (1 << 18)
@@ -729,32 +765,32 @@ int mlx4_INIT_PORT(struct mlx4_dev *dev, struct mlx4_init_port_param *param, int
 #define INIT_PORT_NODE_GUID_OFFSET 0x18
 #define INIT_PORT_SI_GUID_OFFSET   0x20
 
-	mailbox = mlx4_alloc_cmd_mailbox(dev);
-	if (IS_ERR(mailbox))
-		return PTR_ERR(mailbox);
-	inbox = mailbox->buf;
+		mailbox = mlx4_alloc_cmd_mailbox(dev);
+		if (IS_ERR(mailbox))
+			return PTR_ERR(mailbox);
+		inbox = mailbox->buf;
 
-	memset(inbox, 0, INIT_PORT_IN_SIZE);
+		memset(inbox, 0, INIT_PORT_IN_SIZE);
 
-	flags = 0;
-	flags |= param->set_guid0     ? INIT_PORT_FLAG_G0  : 0;
-	flags |= param->set_node_guid ? INIT_PORT_FLAG_NG  : 0;
-	flags |= param->set_si_guid   ? INIT_PORT_FLAG_SIG : 0;
-	flags |= (param->vl_cap & 0xf) << INIT_PORT_VL_SHIFT;
-	flags |= (param->port_width_cap & 0xf) << INIT_PORT_PORT_WIDTH_SHIFT;
-	MLX4_PUT(inbox, flags,            INIT_PORT_FLAGS_OFFSET);
+		flags = 0;
+		flags |= (dev->caps.vl_cap[port] & 0xf) << INIT_PORT_VL_SHIFT;
+		flags |= (dev->caps.port_width_cap[port] & 0xf) << INIT_PORT_PORT_WIDTH_SHIFT;
+		MLX4_PUT(inbox, flags,		  INIT_PORT_FLAGS_OFFSET);
 
-	MLX4_PUT(inbox, param->mtu,       INIT_PORT_MTU_OFFSET);
-	MLX4_PUT(inbox, param->max_gid,   INIT_PORT_MAX_GID_OFFSET);
-	MLX4_PUT(inbox, param->max_pkey,  INIT_PORT_MAX_PKEY_OFFSET);
-	MLX4_PUT(inbox, param->guid0,     INIT_PORT_GUID0_OFFSET);
-	MLX4_PUT(inbox, param->node_guid, INIT_PORT_NODE_GUID_OFFSET);
-	MLX4_PUT(inbox, param->si_guid,   INIT_PORT_SI_GUID_OFFSET);
+		field = 128 << dev->caps.mtu_cap[port];
+		MLX4_PUT(inbox, field, INIT_PORT_MTU_OFFSET);
+		field = dev->caps.gid_table_len[port];
+		MLX4_PUT(inbox, field, INIT_PORT_MAX_GID_OFFSET);
+		field = dev->caps.pkey_table_len[port];
+		MLX4_PUT(inbox, field, INIT_PORT_MAX_PKEY_OFFSET);
 
-	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_INIT_PORT,
-		       MLX4_CMD_TIME_CLASS_A);
+		err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_INIT_PORT,
+			       MLX4_CMD_TIME_CLASS_A);
 
-	mlx4_free_cmd_mailbox(dev, mailbox);
+		mlx4_free_cmd_mailbox(dev, mailbox);
+	} else
+		err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_INIT_PORT,
+			       MLX4_CMD_TIME_CLASS_A);
 
 	return err;
 }
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index 2616fa5..296254a 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -59,13 +59,13 @@ struct mlx4_dev_cap {
 	int max_responder_per_qp;
 	int max_rdma_global;
 	int local_ca_ack_delay;
-	int max_mtu;
-	int max_port_width;
-	int max_vl;
 	int num_ports;
-	int max_gids;
+	int max_mtu[MLX4_MAX_PORTS + 1];
+	int max_port_width[MLX4_MAX_PORTS + 1];
+	int max_vl[MLX4_MAX_PORTS + 1];
+	int max_gids[MLX4_MAX_PORTS + 1];
+	int max_pkeys[MLX4_MAX_PORTS + 1];
 	u16 stat_rate_support;
-	int max_pkeys;
 	u32 flags;
 	int reserved_uars;
 	int uar_size;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index d417293..41eafeb 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -88,6 +88,7 @@ static struct mlx4_profile default_profile = {
 static int __devinit mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 {
 	int err;
+	int i;
 
 	err = mlx4_QUERY_DEV_CAP(dev, dev_cap);
 	if (err) {
@@ -117,11 +118,15 @@ static int __devinit mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev
 	}
 
 	dev->caps.num_ports	     = dev_cap->num_ports;
+	for (i = 1; i <= dev->caps.num_ports; ++i) {
+		dev->caps.vl_cap[i]	    = dev_cap->max_vl[i];
+		dev->caps.mtu_cap[i]	    = dev_cap->max_mtu[i];
+		dev->caps.gid_table_len[i]  = dev_cap->max_gids[i];
+		dev->caps.pkey_table_len[i] = dev_cap->max_pkeys[i];
+		dev->caps.port_width_cap[i] = dev_cap->max_port_width[i];
+	}
+
 	dev->caps.num_uars	     = dev_cap->uar_size / PAGE_SIZE;
-	dev->caps.vl_cap	     = dev_cap->max_vl;
-	dev->caps.mtu_cap	     = dev_cap->max_mtu;
-	dev->caps.gid_table_len	     = dev_cap->max_gids;
-	dev->caps.pkey_table_len     = dev_cap->max_pkeys;
 	dev->caps.local_ca_ack_delay = dev_cap->local_ca_ack_delay;
 	dev->caps.bf_reg_size	     = dev_cap->bf_reg_size;
 	dev->caps.bf_regs_per_page   = dev_cap->bf_regs_per_page;
@@ -148,7 +153,6 @@ static int __devinit mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev
 	dev->caps.reserved_mrws	     = dev_cap->reserved_mrws;
 	dev->caps.reserved_uars	     = dev_cap->reserved_uars;
 	dev->caps.reserved_pds	     = dev_cap->reserved_pds;
-	dev->caps.port_width_cap     = dev_cap->max_port_width;
 	dev->caps.mtt_entry_sz	     = MLX4_MTT_ENTRY_PER_SEG * dev_cap->mtt_entry_sz;
 	dev->caps.page_size_cap	     = ~(u32) (dev_cap->min_page_sz - 1);
 	dev->caps.flags		     = dev_cap->flags;
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 4fb552d..7d1eaa9 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -54,6 +54,7 @@ enum {
 	MLX4_CMD_INIT_PORT	 = 0x9,
 	MLX4_CMD_CLOSE_PORT	 = 0xa,
 	MLX4_CMD_QUERY_HCA	 = 0xb,
+	MLX4_CMD_QUERY_PORT	 = 0x43,
 	MLX4_CMD_SET_PORT	 = 0xc,
 	MLX4_CMD_ACCESS_DDR	 = 0x2e,
 	MLX4_CMD_MAP_ICM	 = 0xffa,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8c5f8fd..b372f59 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -41,6 +41,7 @@
 
 enum {
 	MLX4_FLAG_MSI_X		= 1 << 0,
+	MLX4_FLAG_OLD_PORT_CMDS	= 1 << 1,
 };
 
 enum {
@@ -131,10 +132,10 @@ enum {
 struct mlx4_caps {
 	u64			fw_ver;
 	int			num_ports;
-	int			vl_cap;
-	int			mtu_cap;
-	int			gid_table_len;
-	int			pkey_table_len;
+	int			vl_cap[MLX4_MAX_PORTS + 1];
+	int			mtu_cap[MLX4_MAX_PORTS + 1];
+	int			gid_table_len[MLX4_MAX_PORTS + 1];
+	int			pkey_table_len[MLX4_MAX_PORTS + 1];
 	int			local_ca_ack_delay;
 	int			num_uars;
 	int			bf_reg_size;
@@ -174,7 +175,7 @@ struct mlx4_caps {
 	u32			page_size_cap;
 	u32			flags;
 	u16			stat_rate_support;
-	u8			port_width_cap;
+	u8			port_width_cap[MLX4_MAX_PORTS + 1];
 };
 
 struct mlx4_buf_list {
@@ -322,7 +323,7 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
 void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq);
 int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark);
 
-int mlx4_INIT_PORT(struct mlx4_dev *dev, struct mlx4_init_port_param *param, int port);
+int mlx4_INIT_PORT(struct mlx4_dev *dev, int port);
 int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port);
 
 int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9eeb61a..10c57d2 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -269,6 +269,10 @@ struct mlx4_wqe_data_seg {
 	__be64			addr;
 };
 
+enum {
+	MLX4_INLINE_ALIGN	= 64,
+};
+
 struct mlx4_wqe_inline_seg {
 	__be32			byte_count;
 };
