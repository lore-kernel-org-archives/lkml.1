Return-Path: <linux-kernel-owner+w=401wt.eu-S1767295AbXDTWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767295AbXDTWdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767288AbXDTWdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:33:04 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:4727 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbXDTWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:32:50 -0400
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="414003416:sNHT202686178"
Subject: [PATCH 5/6] [RFC]mlx4_ib rest of files
In-Reply-To: <20074201532.mohEXyoz7s98VaHz@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.Rlzy7s6yc7iv5IXX@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:37.0262 (UTC) FILETIME=[CC362AE0:01C7839B]
Authentication-Results: sj-dkim-8; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rest of mlx4_ib code.

Signed-off-by: Roland Dreier <rolandd@cisco.com>

---

 ah.c       |  100 ++++
 cq.c       |  525 +++++++++++++++++++++++++
 doorbell.c |  215 ++++++++++
 mad.c      |  339 ++++++++++++++++
 mr.c       |  184 ++++++++
 qp.c       | 1263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 srq.c      |  334 ++++++++++++++++
 user.h     |   91 ++++
 8 files changed, 3051 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
new file mode 100644
index 0000000..c75ac94
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "mlx4_ib.h"
+
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+{
+	struct mlx4_dev *dev = to_mdev(pd->device)->dev;
+	struct mlx4_ib_ah *ah;
+
+	ah = kmalloc(sizeof *ah, GFP_ATOMIC);
+	if (!ah)
+		return ERR_PTR(-ENOMEM);
+
+	memset(&ah->av, 0, sizeof ah->av);
+
+	ah->av.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
+	ah->av.g_slid  = ah_attr->src_path_bits;
+	ah->av.dlid    = cpu_to_be16(ah_attr->dlid);
+	if (ah_attr->static_rate) {
+		ah->av.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
+		while (ah->av.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
+		       !(1 << ah->av.stat_rate & dev->caps.stat_rate_support))
+			--ah->av.stat_rate;
+	}
+	ah->av.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
+	if (ah_attr->ah_flags & IB_AH_GRH) {
+		ah->av.g_slid   |= 0x80;
+		ah->av.gid_index = ah_attr->grh.sgid_index;
+		ah->av.hop_limit = ah_attr->grh.hop_limit;
+		ah->av.sl_tclass_flowlabel |=
+			cpu_to_be32((ah_attr->grh.traffic_class << 20) |
+				    ah_attr->grh.flow_label);
+		memcpy(ah->av.dgid, ah_attr->grh.dgid.raw, 16);
+	}
+
+	return &ah->ibah;
+}
+
+int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+{
+	struct mlx4_ib_ah *ah = to_mah(ibah);
+
+	memset(ah_attr, 0, sizeof *ah_attr);
+	ah_attr->dlid	       = be16_to_cpu(ah->av.dlid);
+	ah_attr->sl	       = be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
+	ah_attr->port_num      = be32_to_cpu(ah->av.port_pd) >> 24;
+	if (ah->av.stat_rate)
+		ah_attr->static_rate = ah->av.stat_rate - MLX4_STAT_RATE_OFFSET;
+	ah_attr->src_path_bits = ah->av.g_slid & 0x7F;
+
+	if (mlx4_ib_ah_grh_present(ah)) {
+		ah_attr->ah_flags = IB_AH_GRH;
+
+		ah_attr->grh.traffic_class =
+			be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 20;
+		ah_attr->grh.flow_label =
+			be32_to_cpu(ah->av.sl_tclass_flowlabel) & 0xfffff;
+		ah_attr->grh.hop_limit  = ah->av.hop_limit;
+		ah_attr->grh.sgid_index = ah->av.gid_index;
+		memcpy(ah_attr->grh.dgid.raw, ah->av.dgid, 16);
+	}
+
+	return 0;
+}
+
+int mlx4_ib_destroy_ah(struct ib_ah *ah)
+{
+	kfree(to_mah(ah));
+	return 0;
+}
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
new file mode 100644
index 0000000..7884f6d
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -0,0 +1,525 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/mlx4/cq.h>
+#include <linux/mlx4/qp.h>
+
+#include "mlx4_ib.h"
+#include "user.h"
+
+static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
+{
+	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
+	ibcq->comp_handler(ibcq, ibcq->cq_context);
+}
+
+static void mlx4_ib_cq_event(struct mlx4_cq *cq, enum mlx4_event type)
+{
+	struct ib_event event;
+	struct ib_cq *ibcq;
+
+	if (type != MLX4_EVENT_TYPE_CQ_ERROR) {
+		printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+		       "on CQ %06x\n", type, cq->cqn);
+		return;
+	}
+
+	ibcq = &to_mibcq(cq)->ibcq;
+	if (ibcq->event_handler) {
+		event.device     = ibcq->device;
+		event.event      = IB_EVENT_CQ_ERR;
+		event.element.cq = ibcq;
+		ibcq->event_handler(&event, ibcq->cq_context);
+	}
+}
+
+static void *get_cqe_from_buf(struct mlx4_ib_cq_buf *buf, int n)
+{
+	int offset = n * sizeof (struct mlx4_cqe);
+
+	if (buf->buf.nbufs == 1)
+		return buf->buf.u.direct.buf + offset;
+	else
+		return buf->buf.u.page_list[offset >> PAGE_SHIFT].buf +
+			(offset & (PAGE_SIZE - 1));
+}
+
+static void *get_cqe(struct mlx4_ib_cq *cq, int n)
+{
+	return get_cqe_from_buf(&cq->buf, n);
+}
+
+static void *get_sw_cqe(struct mlx4_ib_cq *cq, int n)
+{
+	struct mlx4_cqe *cqe = get_cqe(cq, n & cq->ibcq.cqe);
+
+	return (!!(cqe->owner_sr_opcode & MLX4_CQE_OWNER_MASK) ^
+		!!(n & (cq->ibcq.cqe + 1))) ? NULL : cqe;
+}
+
+static struct mlx4_cqe *next_cqe_sw(struct mlx4_ib_cq *cq)
+{
+	return get_sw_cqe(cq, cq->mcq.cons_index);
+}
+
+struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries,
+				struct ib_ucontext *context,
+				struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct mlx4_ib_cq *cq;
+	struct mlx4_uar *uar;
+	int buf_size;
+	int err;
+
+	if (entries < 1 || entries > dev->dev->caps.max_cqes)
+		return ERR_PTR(-EINVAL);
+
+	cq = kmalloc(sizeof *cq, GFP_KERNEL);
+	if (!cq)
+		return ERR_PTR(-ENOMEM);
+
+	entries      = roundup_pow_of_two(entries + 1);
+	cq->ibcq.cqe = entries - 1;
+	buf_size     = entries * sizeof (struct mlx4_cqe);
+	spin_lock_init(&cq->lock);
+
+	if (context) {
+		struct mlx4_ib_create_cq ucmd;
+
+		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+			err = -EFAULT;
+			goto err_cq;
+		}
+
+		cq->umem = ib_umem_get(context, ucmd.buf_addr, buf_size,
+				       IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(cq->umem)) {
+			err = PTR_ERR(cq->umem);
+			goto err_cq;
+		}
+
+		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(cq->umem),
+				    ilog2(cq->umem->page_size), &cq->buf.mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_ib_umem_write_mtt(dev, &cq->buf.mtt, cq->umem);
+		if (err)
+			goto err_mtt;
+
+		err = mlx4_ib_db_map_user(to_mucontext(context), ucmd.db_addr,
+					  &cq->db);
+		if (err)
+			goto err_mtt;
+
+		uar = &to_mucontext(context)->uar;
+	} else {
+		err = mlx4_ib_db_alloc(dev, &cq->db, 1);
+		if (err)
+			goto err_cq;
+
+		cq->mcq.set_ci_db  = cq->db.db;
+		cq->mcq.arm_db     = cq->db.db + 1;
+		*cq->mcq.set_ci_db = 0;
+		*cq->mcq.arm_db    = 0;
+
+		if (mlx4_buf_alloc(dev->dev, buf_size, PAGE_SIZE * 2, &cq->buf.buf)) {
+			err = -ENOMEM;
+			goto err_db;
+		}
+
+		err = mlx4_mtt_init(dev->dev, cq->buf.buf.npages, cq->buf.buf.page_shift,
+				    &cq->buf.mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_buf_write_mtt(dev->dev, &cq->buf.mtt, &cq->buf.buf);
+		if (err)
+			goto err_mtt;
+
+		uar = &dev->priv_uar;
+	}
+
+	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
+			    cq->db.dma, &cq->mcq);
+	if (err)
+		goto err_dbmap;
+
+	cq->mcq.comp  = mlx4_ib_cq_comp;
+	cq->mcq.event = mlx4_ib_cq_event;
+
+	if (context)
+		if (ib_copy_to_udata(udata, &cq->mcq.cqn, sizeof (__u32))) {
+			err = -EFAULT;
+			goto err_dbmap;
+		}
+
+	return &cq->ibcq;
+
+err_dbmap:
+	if (context)
+		mlx4_ib_db_unmap_user(to_mucontext(context), &cq->db);
+
+err_mtt:
+	mlx4_mtt_cleanup(dev->dev, &cq->buf.mtt);
+
+err_buf:
+	if (context)
+		ib_umem_release(cq->umem);
+	else
+		mlx4_buf_free(dev->dev, entries * sizeof (struct mlx4_cqe),
+			      &cq->buf.buf);
+
+err_db:
+	if (!context)
+		mlx4_ib_db_free(dev, &cq->db);
+
+err_cq:
+	kfree(cq);
+
+	return ERR_PTR(err);
+}
+
+int mlx4_ib_destroy_cq(struct ib_cq *cq)
+{
+	struct mlx4_ib_dev *dev = to_mdev(cq->device);
+	struct mlx4_ib_cq *mcq = to_mcq(cq);
+
+	mlx4_cq_free(dev->dev, &mcq->mcq);
+	mlx4_mtt_cleanup(dev->dev, &mcq->buf.mtt);
+
+	if (cq->uobject) {
+		mlx4_ib_db_unmap_user(to_mucontext(cq->uobject->context), &mcq->db);
+		ib_umem_release(mcq->umem);
+	} else {
+		mlx4_buf_free(dev->dev, (cq->cqe + 1) * sizeof (struct mlx4_cqe),
+			      &mcq->buf.buf);
+		mlx4_ib_db_free(dev, &mcq->db);
+	}
+
+	kfree(mcq);
+
+	return 0;
+}
+
+static void dump_cqe(void *cqe)
+{
+	__be32 *buf = cqe;
+
+	printk(KERN_DEBUG "CQE contents %08x %08x %08x %08x %08x %08x %08x %08x\n",
+	       be32_to_cpu(buf[0]), be32_to_cpu(buf[1]), be32_to_cpu(buf[2]),
+	       be32_to_cpu(buf[3]), be32_to_cpu(buf[4]), be32_to_cpu(buf[5]),
+	       be32_to_cpu(buf[6]), be32_to_cpu(buf[7]));
+}
+
+static void mlx4_ib_handle_error_cqe(struct mlx4_err_cqe *cqe,
+				     struct ib_wc *wc)
+{
+	if (cqe->syndrome == MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR) {
+		printk(KERN_DEBUG "local QP operation err "
+		       "(QPN %06x, WQE index %x, vendor syndrome %02x, "
+		       "opcode = %02x)\n",
+		       be32_to_cpu(cqe->my_qpn), be16_to_cpu(cqe->wqe_index),
+		       cqe->vendor_err_syndrome,
+		       cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK);
+		dump_cqe(cqe);
+	}
+
+	switch (cqe->syndrome) {
+	case MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR:
+		wc->status = IB_WC_LOC_LEN_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR:
+		wc->status = IB_WC_LOC_QP_OP_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_LOCAL_PROT_ERR:
+		wc->status = IB_WC_LOC_PROT_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_WR_FLUSH_ERR:
+		wc->status = IB_WC_WR_FLUSH_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_MW_BIND_ERR:
+		wc->status = IB_WC_MW_BIND_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_BAD_RESP_ERR:
+		wc->status = IB_WC_BAD_RESP_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR:
+		wc->status = IB_WC_LOC_ACCESS_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
+		wc->status = IB_WC_REM_INV_REQ_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR:
+		wc->status = IB_WC_REM_ACCESS_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_REMOTE_OP_ERR:
+		wc->status = IB_WC_REM_OP_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
+		wc->status = IB_WC_RETRY_EXC_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
+		wc->status = IB_WC_RNR_RETRY_EXC_ERR;
+		break;
+	case MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR:
+		wc->status = IB_WC_REM_ABORT_ERR;
+		break;
+	default:
+		wc->status = IB_WC_GENERAL_ERR;
+		break;
+	}
+
+	wc->vendor_err = cqe->vendor_err_syndrome;
+}
+
+static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
+			    struct mlx4_ib_qp **cur_qp,
+			    struct ib_wc *wc)
+{
+	struct mlx4_cqe *cqe;
+	struct mlx4_qp *mqp;
+	struct mlx4_ib_wq *wq;
+	struct mlx4_ib_srq *srq;
+	int is_send;
+	int is_error;
+	u16 wqe_ctr;
+
+	cqe = next_cqe_sw(cq);
+	if (!cqe)
+		return -EAGAIN;
+
+	++cq->mcq.cons_index;
+
+	/*
+	 * Make sure we read CQ entry contents after we've checked the
+	 * ownership bit.
+	 */
+	rmb();
+
+	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
+	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
+		MLX4_CQE_OPCODE_ERROR;
+
+	if (!*cur_qp ||
+	    (be32_to_cpu(cqe->my_qpn) & 0xffffff) != (*cur_qp)->mqp.qpn) {
+		/*
+		 * We do not have to take the QP table lock here,
+		 * because CQs will be locked while QPs are removed
+		 * from the table.
+		 */
+		mqp = __mlx4_qp_lookup(to_mdev(cq->ibcq.device)->dev,
+				       be32_to_cpu(cqe->my_qpn));
+		if (unlikely(!mqp)) {
+			printk(KERN_WARNING "CQ %06x with entry for unknown QPN %06x\n",
+			       cq->mcq.cqn, be32_to_cpu(cqe->my_qpn) & 0xffffff);
+			return -EINVAL;
+		}
+
+		*cur_qp = to_mibqp(mqp);
+	}
+
+	wc->qp = &(*cur_qp)->ibqp;
+
+	if (is_send) {
+		wq = &(*cur_qp)->sq;
+		wqe_ctr = be16_to_cpu(cqe->wqe_index);
+		wq->tail += wqe_ctr - (u16) wq->tail;
+		wc->wr_id = wq->wrid[wq->tail & (wq->max - 1)];
+		++wq->tail;
+	} else if ((*cur_qp)->ibqp.srq) {
+		srq = to_msrq((*cur_qp)->ibqp.srq);
+		wqe_ctr = be16_to_cpu(cqe->wqe_index);
+		wc->wr_id = srq->wrid[wqe_ctr];
+		mlx4_ib_free_srq_wqe(srq, wqe_ctr);
+	} else {
+		wq	  = &(*cur_qp)->rq;
+		wc->wr_id = wq->wrid[wq->tail & (wq->max - 1)];
+		++wq->tail;
+	}
+
+	if (unlikely(is_error)) {
+		mlx4_ib_handle_error_cqe((struct mlx4_err_cqe *) cqe, wc);
+		return 0;
+	}
+
+	wc->status = IB_WC_SUCCESS;
+
+	if (is_send) {
+		wc->wc_flags = 0;
+		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_OPCODE_RDMA_WRITE_IMM:
+			wc->wc_flags |= IB_WC_WITH_IMM;
+		case MLX4_OPCODE_RDMA_WRITE:
+			wc->opcode    = IB_WC_RDMA_WRITE;
+			break;
+		case MLX4_OPCODE_SEND_IMM:
+			wc->wc_flags |= IB_WC_WITH_IMM;
+		case MLX4_OPCODE_SEND:
+			wc->opcode    = IB_WC_SEND;
+			break;
+		case MLX4_OPCODE_RDMA_READ:
+			wc->opcode    = IB_WC_SEND;
+			wc->byte_len  = be32_to_cpu(cqe->byte_cnt);
+			break;
+		case MLX4_OPCODE_ATOMIC_CS:
+			wc->opcode    = IB_WC_COMP_SWAP;
+			wc->byte_len  = 8;
+			break;
+		case MLX4_OPCODE_ATOMIC_FA:
+			wc->opcode    = IB_WC_FETCH_ADD;
+			wc->byte_len  = 8;
+			break;
+		case MLX4_OPCODE_BIND_MW:
+			wc->opcode    = IB_WC_BIND_MW;
+			break;
+		}
+	} else {
+		wc->byte_len = be32_to_cpu(cqe->byte_cnt);
+
+		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
+			wc->opcode   = IB_WC_RECV_RDMA_WITH_IMM;
+			wc->wc_flags = IB_WC_WITH_IMM;
+			wc->imm_data = cqe->immed_rss_invalid;
+			break;
+		case MLX4_RECV_OPCODE_SEND:
+			wc->opcode   = IB_WC_RECV;
+			wc->wc_flags = 0;
+			break;
+		case MLX4_RECV_OPCODE_SEND_IMM:
+			wc->opcode   = IB_WC_RECV;
+			wc->wc_flags = IB_WC_WITH_IMM;
+			wc->imm_data = cqe->immed_rss_invalid;
+			break;
+		}
+
+		wc->slid	   = be16_to_cpu(cqe->rlid);
+		wc->sl		   = cqe->sl >> 4;
+		wc->src_qp	   = be32_to_cpu(cqe->g_mlpath_rqpn) & 0xffffff;
+		wc->dlid_path_bits = (be32_to_cpu(cqe->g_mlpath_rqpn) >> 24) & 0x7f;
+		wc->wc_flags      |= be32_to_cpu(cqe->g_mlpath_rqpn) & 0x80000000 ?
+			IB_WC_GRH : 0;
+		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) >> 16;
+	}
+
+	return 0;
+}
+
+int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
+{
+	struct mlx4_ib_cq *cq = to_mcq(ibcq);
+	struct mlx4_ib_qp *cur_qp = NULL;
+	unsigned long flags;
+	int npolled;
+	int err = 0;
+
+	spin_lock_irqsave(&cq->lock, flags);
+
+	for (npolled = 0; npolled < num_entries; ++npolled) {
+		err = mlx4_ib_poll_one(cq, &cur_qp, wc + npolled);
+		if (err)
+			break;
+	}
+
+	if (npolled)
+		mlx4_cq_set_ci(&cq->mcq);
+
+	spin_unlock_irqrestore(&cq->lock, flags);
+
+	if (err == 0 || err == -EAGAIN)
+		return npolled;
+	else
+		return err;
+}
+
+int mlx4_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
+{
+	mlx4_cq_arm(&to_mcq(ibcq)->mcq,
+		    notify == IB_CQ_SOLICITED ? MLX4_CQ_DB_REQ_NOT_SOL :
+		    MLX4_CQ_DB_REQ_NOT,
+		    to_mdev(ibcq->device)->uar_map,
+		    MLX4_GET_DOORBELL_LOCK(&to_mdev(ibcq->device)->uar_lock));
+
+	return 0;
+}
+
+void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
+{
+	u32 prod_index;
+	int nfreed = 0;
+	struct mlx4_cqe *cqe;
+
+	/*
+	 * First we need to find the current producer index, so we
+	 * know where to start cleaning from.  It doesn't matter if HW
+	 * adds new entries after this loop -- the QP we're worried
+	 * about is already in RESET, so the new entries won't come
+	 * from our QP and therefore don't need to be checked.
+	 */
+	for (prod_index = cq->mcq.cons_index; get_sw_cqe(cq, prod_index); ++prod_index)
+		if (prod_index == cq->mcq.cons_index + cq->ibcq.cqe)
+			break;
+
+	/*
+	 * Now sweep backwards through the CQ, removing CQ entries
+	 * that match our QP by copying older entries on top of them.
+	 */
+	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
+		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
+		if ((be32_to_cpu(cqe->my_qpn) & 0xffffff) == qpn) {
+			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
+				mlx4_ib_free_srq_wqe(srq, be16_to_cpu(cqe->wqe_index));
+			++nfreed;
+		} else if (nfreed)
+			memcpy(get_cqe(cq, (prod_index + nfreed) & cq->ibcq.cqe),
+			       cqe, sizeof *cqe);
+	}
+
+	if (nfreed) {
+		cq->mcq.cons_index += nfreed;
+		/*
+		 * Make sure update of buffer contents is done before
+		 * updating consumer index.
+		 */
+		wmb();
+		mlx4_cq_set_ci(&cq->mcq);
+	}
+}
+
+void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
+{
+	spin_lock_irq(&cq->lock);
+	__mlx4_ib_cq_clean(cq, qpn, srq);
+	spin_unlock_irq(&cq->lock);
+}
diff --git a/drivers/infiniband/hw/mlx4/doorbell.c b/drivers/infiniband/hw/mlx4/doorbell.c
new file mode 100644
index 0000000..c3398a3
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/doorbell.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/slab.h>
+
+#include "mlx4_ib.h"
+
+struct mlx4_ib_db_pgdir {
+	struct list_head	list;
+	DECLARE_BITMAP(order0, MLX4_IB_DB_PER_PAGE);
+	DECLARE_BITMAP(order1, MLX4_IB_DB_PER_PAGE / 2);
+	unsigned long	       *bits[2];
+	__be32		       *db_page;
+	dma_addr_t		db_dma;
+};
+
+static struct mlx4_ib_db_pgdir *mlx4_ib_alloc_db_pgdir(struct mlx4_ib_dev *dev)
+{
+	struct mlx4_ib_db_pgdir *pgdir;
+
+	pgdir = kzalloc(sizeof *pgdir, GFP_KERNEL);
+	if (!pgdir)
+		return NULL;
+
+	bitmap_fill(pgdir->order1, MLX4_IB_DB_PER_PAGE / 2);
+	pgdir->bits[0] = pgdir->order0;
+	pgdir->bits[1] = pgdir->order1;
+	pgdir->db_page = dma_alloc_coherent(dev->ib_dev.dma_device,
+					    PAGE_SIZE, &pgdir->db_dma,
+					    GFP_KERNEL);
+	if (!pgdir->db_page) {
+		kfree(pgdir);
+		return NULL;
+	}
+
+	return pgdir;
+}
+
+static int mlx4_ib_alloc_db_from_pgdir(struct mlx4_ib_db_pgdir *pgdir,
+				       struct mlx4_ib_db *db, int order)
+{
+	int o;
+	int i;
+
+	for (o = order; o <= 1; ++o) {
+		i = find_first_bit(pgdir->bits[o], MLX4_IB_DB_PER_PAGE >> o);
+		if (i < MLX4_IB_DB_PER_PAGE >> o)
+			goto found;
+	}
+
+	return -ENOMEM;
+
+found:
+	clear_bit(i, pgdir->bits[o]);
+
+	i <<= o;
+
+	if (o > order)
+		set_bit(i ^ 1, pgdir->bits[order]);
+
+	db->u.pgdir = pgdir;
+	db->index   = i;
+	db->db      = pgdir->db_page + db->index;
+	db->dma     = pgdir->db_dma  + db->index * 4;
+	db->order   = order;
+
+	return 0;
+}
+
+int mlx4_ib_db_alloc(struct mlx4_ib_dev *dev, struct mlx4_ib_db *db, int order)
+{
+	struct mlx4_ib_db_pgdir *pgdir;
+	int ret = 0;
+
+	spin_lock(&dev->pgdir_lock);
+
+	list_for_each_entry(pgdir, &dev->pgdir_list, list)
+		if (!mlx4_ib_alloc_db_from_pgdir(pgdir, db, order))
+			goto out;
+
+	pgdir = mlx4_ib_alloc_db_pgdir(dev);
+	if (!pgdir) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	list_add(&pgdir->list, &dev->pgdir_list);
+
+	BUG_ON(mlx4_ib_alloc_db_from_pgdir(pgdir, db, order));
+
+out:
+	spin_unlock(&dev->pgdir_lock);
+
+	return ret;
+}
+
+void mlx4_ib_db_free(struct mlx4_ib_dev *dev, struct mlx4_ib_db *db)
+{
+	int o;
+	int i;
+
+	spin_lock(&dev->pgdir_lock);
+
+	o = db->order;
+	i = db->index >> db->order;
+
+	if (db->order == 0 && test_bit(i ^ 1, db->u.pgdir->order0)) {
+		clear_bit(i ^ 1, db->u.pgdir->order0);
+		++o;
+	}
+
+	i >>= o;
+	set_bit(i, db->u.pgdir->bits[o]);
+
+	if (bitmap_full(db->u.pgdir->order1, MLX4_IB_DB_PER_PAGE / 2)) {
+		dma_free_coherent(dev->ib_dev.dma_device, PAGE_SIZE,
+				  db->u.pgdir->db_page, db->u.pgdir->db_dma);
+		list_del(&db->u.pgdir->list);
+		kfree(db->u.pgdir);
+	}
+
+	spin_unlock(&dev->pgdir_lock);
+}
+
+struct mlx4_ib_user_db_page {
+	struct list_head	list;
+	struct ib_umem	       *umem;
+	unsigned long		user_virt;
+	int			refcnt;
+};
+
+int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
+			struct mlx4_ib_db *db)
+{
+	struct mlx4_ib_user_db_page *page;
+	struct ib_umem_chunk *chunk;
+	int err = 0;
+
+	mutex_lock(&context->db_page_mutex);
+
+	list_for_each_entry(page, &context->db_page_list, list)
+		if (page->user_virt == (virt & PAGE_MASK))
+			goto found;
+
+	page = kmalloc(sizeof *page, GFP_KERNEL);
+	if (!page) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	page->user_virt = (virt & PAGE_MASK);
+	page->refcnt    = 0;
+	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
+				      PAGE_SIZE, 0);
+	if (IS_ERR(page->umem)) {
+		err = PTR_ERR(page->umem);
+		kfree(page);
+		goto out;
+	}
+
+	list_add(&page->list, &context->db_page_list);
+
+found:
+	chunk = list_entry(page->umem->chunk_list.next, struct ib_umem_chunk, list);
+	db->dma		= sg_dma_address(chunk->page_list) + (virt & ~PAGE_MASK);
+	db->u.user_page = page;
+	++page->refcnt;
+
+out:
+	mutex_unlock(&context->db_page_mutex);
+
+	return err;
+}
+
+void mlx4_ib_db_unmap_user(struct mlx4_ib_ucontext *context, struct mlx4_ib_db *db)
+{
+	mutex_lock(&context->db_page_mutex);
+
+	if (!--db->u.user_page->refcnt) {
+		list_del(&db->u.user_page->list);
+		ib_umem_release(db->u.user_page->umem);
+		kfree(db->u.user_page);
+	}
+
+	mutex_unlock(&context->db_page_mutex);
+}
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
new file mode 100644
index 0000000..3330917
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -0,0 +1,339 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <rdma/ib_mad.h>
+#include <rdma/ib_smi.h>
+
+#include <linux/mlx4/cmd.h>
+
+#include "mlx4_ib.h"
+
+enum {
+	MLX4_IB_VENDOR_CLASS1 = 0x9,
+	MLX4_IB_VENDOR_CLASS2 = 0xa
+};
+
+int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int ignore_mkey, int ignore_bkey,
+		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
+		 void *in_mad, void *response_mad)
+{
+	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
+	void *inbox;
+	int err;
+	u32 in_modifier = port;
+	u8 op_modifier = 0;
+
+	inmailbox = mlx4_alloc_cmd_mailbox(dev->dev);
+	if (IS_ERR(inmailbox))
+		return PTR_ERR(inmailbox);
+	inbox = inmailbox->buf;
+
+	outmailbox = mlx4_alloc_cmd_mailbox(dev->dev);
+	if (IS_ERR(outmailbox)) {
+		mlx4_free_cmd_mailbox(dev->dev, inmailbox);
+		return PTR_ERR(outmailbox);
+	}
+
+	memcpy(inbox, in_mad, 256);
+
+	/*
+	 * Key check traps can't be generated unless we have in_wc to
+	 * tell us where to send the trap.
+	 */
+	if (ignore_mkey || !in_wc)
+		op_modifier |= 0x1;
+	if (ignore_bkey || !in_wc)
+		op_modifier |= 0x2;
+
+	if (in_wc) {
+		struct {
+			__be32		my_qpn;
+			u32		reserved1;
+			__be32		rqpn;
+			u8		sl;
+			u8		g_path;
+			u16		reserved2[2];
+			__be16		pkey;
+			u32		reserved3[11];
+			u8		grh[40];
+		} *ext_info;
+
+		memset(inbox + 256, 0, 256);
+		ext_info = inbox + 256;
+
+		ext_info->my_qpn = cpu_to_be32(in_wc->qp->qp_num);
+		ext_info->rqpn   = cpu_to_be32(in_wc->src_qp);
+		ext_info->sl     = in_wc->sl << 4;
+		ext_info->g_path = in_wc->dlid_path_bits |
+			(in_wc->wc_flags & IB_WC_GRH ? 0x80 : 0);
+		ext_info->pkey   = cpu_to_be16(in_wc->pkey_index);
+
+		if (in_grh)
+			memcpy(ext_info->grh, in_grh, 40);
+
+		op_modifier |= 0x4;
+
+		in_modifier |= in_wc->slid << 16;
+	}
+
+	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma,
+			   in_modifier, op_modifier,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
+
+	if (!err);
+		memcpy(response_mad, outmailbox->buf, 256);
+
+	mlx4_free_cmd_mailbox(dev->dev, inmailbox);
+	mlx4_free_cmd_mailbox(dev->dev, outmailbox);
+
+	return err;
+}
+
+static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
+{
+	struct ib_ah *new_ah;
+	struct ib_ah_attr ah_attr;
+
+	if (!dev->send_agent[port_num - 1][0])
+		return;
+
+	memset(&ah_attr, 0, sizeof ah_attr);
+	ah_attr.dlid     = lid;
+	ah_attr.sl       = sl;
+	ah_attr.port_num = port_num;
+
+	new_ah = ib_create_ah(dev->send_agent[port_num - 1][0]->qp->pd,
+			      &ah_attr);
+	if (IS_ERR(new_ah))
+		return;
+
+	spin_lock(&dev->sm_lock);
+	if (dev->sm_ah[port_num - 1])
+		ib_destroy_ah(dev->sm_ah[port_num - 1]);
+	dev->sm_ah[port_num - 1] = new_ah;
+	spin_unlock(&dev->sm_lock);
+}
+
+/*
+ * Snoop SM MADs for port info and P_Key table sets, so we can
+ * synthesize LID change and P_Key change events.
+ */
+static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad)
+{
+	struct ib_event event;
+
+	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
+	     mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) &&
+	    mad->mad_hdr.method == IB_MGMT_METHOD_SET) {
+		if (mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO) {
+			struct ib_port_info *pinfo =
+				(struct ib_port_info *) ((struct ib_smp *) mad)->data;
+
+			update_sm_ah(to_mdev(ibdev), port_num,
+				     be16_to_cpu(pinfo->sm_lid),
+				     pinfo->neighbormtu_mastersmsl & 0xf);
+
+			event.device	       = ibdev;
+			event.element.port_num = port_num;
+
+			if(pinfo->clientrereg_resv_subnetto & 0x80)
+				event.event    = IB_EVENT_CLIENT_REREGISTER;
+			else
+				event.event    = IB_EVENT_LID_CHANGE;
+
+			ib_dispatch_event(&event);
+		}
+
+		if (mad->mad_hdr.attr_id == IB_SMP_ATTR_PKEY_TABLE) {
+			event.device	       = ibdev;
+			event.event	       = IB_EVENT_PKEY_CHANGE;
+			event.element.port_num = port_num;
+			ib_dispatch_event(&event);
+		}
+	}
+}
+
+static void node_desc_override(struct ib_device *dev,
+			       struct ib_mad *mad)
+{
+	if ((mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
+	     mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) &&
+	    mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP &&
+	    mad->mad_hdr.attr_id == IB_SMP_ATTR_NODE_DESC) {
+		spin_lock(&to_mdev(dev)->sm_lock);
+		memcpy(((struct ib_smp *) mad)->data, dev->node_desc, 64);
+		spin_unlock(&to_mdev(dev)->sm_lock);
+	}
+}
+
+static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *mad)
+{
+	int qpn = mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED;
+	struct ib_mad_send_buf *send_buf;
+	struct ib_mad_agent *agent = dev->send_agent[port_num - 1][qpn];
+	int ret;
+
+	if (agent) {
+		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
+					      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+		/*
+		 * We rely here on the fact that MLX QPs don't use the
+		 * address handle after the send is posted (this is
+		 * wrong following the IB spec strictly, but we know
+		 * it's OK for our devices).
+		 */
+		spin_lock(&dev->sm_lock);
+		memcpy(send_buf->mad, mad, sizeof *mad);
+		if ((send_buf->ah = dev->sm_ah[port_num - 1]))
+			ret = ib_post_send_mad(send_buf, NULL);
+		else
+			ret = -EINVAL;
+		spin_unlock(&dev->sm_lock);
+
+		if (ret)
+			ib_free_send_mad(send_buf);
+	}
+}
+
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
+			struct ib_wc *in_wc, struct ib_grh *in_grh,
+			struct ib_mad *in_mad, struct ib_mad *out_mad)
+{
+	u16 slid;
+	int err;
+
+	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+
+	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
+		forward_trap(to_mdev(ibdev), port_num, in_mad);
+		return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+	}
+
+	if (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_LID_ROUTED ||
+	    in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
+		if (in_mad->mad_hdr.method   != IB_MGMT_METHOD_GET &&
+		    in_mad->mad_hdr.method   != IB_MGMT_METHOD_SET &&
+		    in_mad->mad_hdr.method   != IB_MGMT_METHOD_TRAP_REPRESS)
+			return IB_MAD_RESULT_SUCCESS;
+
+		/*
+		 * Don't process SMInfo queries or vendor-specific
+		 * MADs -- the SMA can't handle them.
+		 */
+		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_SM_INFO ||
+		    ((in_mad->mad_hdr.attr_id & IB_SMP_ATTR_VENDOR_MASK) ==
+		     IB_SMP_ATTR_VENDOR_MASK))
+			return IB_MAD_RESULT_SUCCESS;
+	} else if (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT ||
+		   in_mad->mad_hdr.mgmt_class == MLX4_IB_VENDOR_CLASS1   ||
+		   in_mad->mad_hdr.mgmt_class == MLX4_IB_VENDOR_CLASS2) {
+		if (in_mad->mad_hdr.method  != IB_MGMT_METHOD_GET &&
+		    in_mad->mad_hdr.method  != IB_MGMT_METHOD_SET)
+			return IB_MAD_RESULT_SUCCESS;
+	} else
+		return IB_MAD_RESULT_SUCCESS;
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev),
+			   mad_flags & IB_MAD_IGNORE_MKEY,
+			   mad_flags & IB_MAD_IGNORE_BKEY,
+			   port_num, in_wc, in_grh, in_mad, out_mad);
+	if (err)
+		return IB_MAD_RESULT_FAILURE;
+
+	if (!out_mad->mad_hdr.status) {
+		smp_snoop(ibdev, port_num, in_mad);
+		node_desc_override(ibdev, out_mad);
+	}
+
+	/* set return bit in status of directed route responses */
+	if (in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+		out_mad->mad_hdr.status |= cpu_to_be16(1 << 15);
+
+	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP_REPRESS)
+		/* no response for trap repress */
+		return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+
+	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+}
+
+static void send_handler(struct ib_mad_agent *agent,
+			 struct ib_mad_send_wc *mad_send_wc)
+{
+	ib_free_send_mad(mad_send_wc->send_buf);
+}
+
+int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
+{
+	struct ib_mad_agent *agent;
+	int p, q;
+	int ret;
+
+	for (p = 0; p < dev->dev->caps.num_ports; ++p)
+		for (q = 0; q <= 1; ++q) {
+			agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
+						      q ? IB_QPT_GSI : IB_QPT_SMI,
+						      NULL, 0, send_handler,
+						      NULL, NULL);
+			if (IS_ERR(agent)) {
+				ret = PTR_ERR(agent);
+				goto err;
+			}
+			dev->send_agent[p][q] = agent;
+		}
+
+	return 0;
+
+err:
+	for (p = 0; p < dev->dev->caps.num_ports; ++p)
+		for (q = 0; q <= 1; ++q)
+			if (dev->send_agent[p][q])
+				ib_unregister_mad_agent(dev->send_agent[p][q]);
+
+	return ret;
+}
+
+void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev)
+{
+	struct ib_mad_agent *agent;
+	int p, q;
+
+	for (p = 0; p < dev->dev->caps.num_ports; ++p) {
+		for (q = 0; q <= 1; ++q) {
+			agent = dev->send_agent[p][q];
+			dev->send_agent[p][q] = NULL;
+			ib_unregister_mad_agent(agent);
+		}
+
+		if (dev->sm_ah[p])
+			ib_destroy_ah(dev->sm_ah[p]);
+	}
+}
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
new file mode 100644
index 0000000..85ae906
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -0,0 +1,184 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "mlx4_ib.h"
+
+static u32 convert_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_ATOMIC ? MLX4_PERM_ATOMIC       : 0) |
+	       (acc & IB_ACCESS_REMOTE_WRITE  ? MLX4_PERM_REMOTE_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ   ? MLX4_PERM_REMOTE_READ  : 0) |
+	       (acc & IB_ACCESS_LOCAL_WRITE   ? MLX4_PERM_LOCAL_WRITE  : 0) |
+	       MLX4_PERM_LOCAL_READ;
+}
+
+struct ib_mr *mlx4_ib_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	struct mlx4_ib_mr *mr;
+	int err;
+
+	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_mr_alloc(to_mdev(pd->device)->dev, to_mpd(pd)->pdn, 0,
+			    ~0ull, convert_access(acc), 0, 0, &mr->mmr);
+	if (err)
+		goto err_free;
+
+	err = mlx4_mr_enable(to_mdev(pd->device)->dev, &mr->mmr);
+	if (err)
+		goto err_mr;
+
+	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+	mr->umem = NULL;
+
+	return &mr->ibmr;
+
+err_mr:
+	mlx4_mr_free(to_mdev(pd->device)->dev, &mr->mmr);
+
+err_free:
+	kfree(mr);
+
+	return ERR_PTR(err);
+}
+
+int mlx4_ib_umem_write_mtt(struct mlx4_ib_dev *dev, struct mlx4_mtt *mtt,
+			   struct ib_umem *umem)
+{
+	u64 *pages;
+	struct ib_umem_chunk *chunk;
+	int i, j, k;
+	int n;
+	int len;
+	int err = 0;
+
+	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	i = n = 0;
+
+	list_for_each_entry(chunk, &umem->chunk_list, list)
+		for (j = 0; j < chunk->nmap; ++j) {
+			len = sg_dma_len(&chunk->page_list[j]) >> mtt->page_shift;
+			for (k = 0; k < len; ++k) {
+				pages[i++] = sg_dma_address(&chunk->page_list[j]) +
+					umem->page_size * k;
+				/*
+				 * Be friendly to WRITE_MTT firmware
+				 * command, and pass it chunks of
+				 * appropriate size.
+				 */
+				if (i == PAGE_SIZE / sizeof (u64) - 2) {
+					err = mlx4_write_mtt(dev->dev, mtt, n,
+							     i, pages);
+					if (err)
+						goto out;
+					n += i;
+					i = 0;
+				}
+			}
+		}
+
+	if (i)
+		err = mlx4_write_mtt(dev->dev, mtt, n, i, pages);
+
+out:
+	free_page((unsigned long) pages);
+	return err;
+}
+
+struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				  u64 virt_addr, int access_flags,
+				  struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(pd->device);
+	struct mlx4_ib_mr *mr;
+	int shift;
+	int err;
+	int n;
+
+	mr = kmalloc(sizeof *mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, access_flags);
+	if (IS_ERR(mr->umem)) {
+		err = PTR_ERR(mr->umem);
+		goto err_free;
+	}
+
+	n = ib_umem_page_count(mr->umem);
+	shift = ilog2(mr->umem->page_size);
+
+	err = mlx4_mr_alloc(dev->dev, to_mpd(pd)->pdn, virt_addr, length,
+			    convert_access(access_flags), n, shift, &mr->mmr);
+	if (err)
+		goto err_umem;
+
+	err = mlx4_ib_umem_write_mtt(dev, &mr->mmr.mtt, mr->umem);
+	if (err)
+		goto err_mr;
+
+	err = mlx4_mr_enable(dev->dev, &mr->mmr);
+	if (err)
+		goto err_mr;
+
+	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+
+	return &mr->ibmr;
+
+err_mr:
+	mlx4_mr_free(to_mdev(pd->device)->dev, &mr->mmr);
+
+err_umem:
+	ib_umem_release(mr->umem);
+
+err_free:
+	kfree(mr);
+
+	return ERR_PTR(err);
+}
+
+int mlx4_ib_dereg_mr(struct ib_mr *ibmr)
+{
+	struct mlx4_ib_mr *mr = to_mmr(ibmr);
+
+	mlx4_mr_free(to_mdev(ibmr->device)->dev, &mr->mmr);
+	if (mr->umem)
+		ib_umem_release(mr->umem);
+	kfree(mr);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
new file mode 100644
index 0000000..1f51bfd
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -0,0 +1,1263 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <rdma/ib_cache.h>
+#include <rdma/ib_pack.h>
+
+#include <linux/mlx4/qp.h>
+
+#include "mlx4_ib.h"
+#include "user.h"
+
+enum {
+	MLX4_IB_ACK_REQ_FREQ	= 8,
+};
+
+enum {
+	MLX4_IB_DEFAULT_SCHED_QUEUE	= 0x83,
+	MLX4_IB_DEFAULT_QP0_SCHED_QUEUE	= 0x3f
+};
+
+enum {
+	/*
+	 * Largest possible UD header: send with GRH and immediate data.
+	 */
+	MLX4_IB_UD_HEADER_SIZE		= 72
+};
+
+struct mlx4_ib_sqp {
+	struct mlx4_ib_qp	qp;
+	int			pkey_index;
+	u32			qkey;
+	u32			send_psn;
+	struct ib_ud_header	ud_header;
+	u8			header_buf[MLX4_IB_UD_HEADER_SIZE];
+};
+
+static const __be32 mlx4_ib_opcode[] = {
+	[IB_WR_SEND]			= __constant_cpu_to_be32(MLX4_OPCODE_SEND),
+	[IB_WR_SEND_WITH_IMM]		= __constant_cpu_to_be32(MLX4_OPCODE_SEND_IMM),
+	[IB_WR_RDMA_WRITE]		= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_WRITE),
+	[IB_WR_RDMA_WRITE_WITH_IMM]	= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_WRITE_IMM),
+	[IB_WR_RDMA_READ]		= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_READ),
+	[IB_WR_ATOMIC_CMP_AND_SWP]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_CS),
+	[IB_WR_ATOMIC_FETCH_AND_ADD]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_FA),
+};
+
+static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
+{
+	return container_of(mqp, struct mlx4_ib_sqp, qp);
+}
+
+static int is_sqp(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	return qp->mqp.qpn >= dev->dev->caps.sqp_start &&
+		qp->mqp.qpn <= dev->dev->caps.sqp_start + 3;
+}
+
+static int is_qp0(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	return qp->mqp.qpn >= dev->dev->caps.sqp_start &&
+		qp->mqp.qpn <= dev->dev->caps.sqp_start + 1;
+}
+
+static void *get_wqe(struct mlx4_ib_qp *qp, int offset)
+{
+	if (qp->buf.nbufs == 1)
+		return qp->buf.u.direct.buf + offset;
+	else
+		return qp->buf.u.page_list[offset >> PAGE_SHIFT].buf +
+			(offset & (PAGE_SIZE - 1));
+}
+
+static void *get_recv_wqe(struct mlx4_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->rq.offset + (n << qp->rq.wqe_shift));
+}
+
+static void *get_send_wqe(struct mlx4_ib_qp *qp, int n)
+{
+	return get_wqe(qp, qp->sq.offset + (n << qp->sq.wqe_shift));
+}
+
+static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
+{
+	struct ib_event event;
+	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
+
+	if (type == MLX4_EVENT_TYPE_PATH_MIG)
+		to_mibqp(qp)->port = to_mibqp(qp)->alt_port;
+
+	if (ibqp->event_handler) {
+		event.device     = ibqp->device;
+		event.element.qp = ibqp;
+		switch (type) {
+		case MLX4_EVENT_TYPE_PATH_MIG:
+			event.event = IB_EVENT_PATH_MIG;
+			break;
+		case MLX4_EVENT_TYPE_COMM_EST:
+			event.event = IB_EVENT_COMM_EST;
+			break;
+		case MLX4_EVENT_TYPE_SQ_DRAINED:
+			event.event = IB_EVENT_SQ_DRAINED;
+			break;
+		case MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE:
+			event.event = IB_EVENT_QP_LAST_WQE_REACHED;
+			break;
+		case MLX4_EVENT_TYPE_WQ_CATAS_ERROR:
+			event.event = IB_EVENT_QP_FATAL;
+			break;
+		case MLX4_EVENT_TYPE_PATH_MIG_FAILED:
+			event.event = IB_EVENT_PATH_MIG_ERR;
+			break;
+		case MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+			event.event = IB_EVENT_QP_REQ_ERR;
+			break;
+		case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
+			event.event = IB_EVENT_QP_ACCESS_ERR;
+			break;
+		default:
+			printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+			       "on QP %06x\n", type, qp->qpn);
+			return;
+		}
+
+		ibqp->event_handler(&event, ibqp->qp_context);
+	}
+}
+
+static int send_wqe_overhead(enum ib_qp_type type)
+{
+	/*
+	 * UD WQEs must have a datagram segment.
+	 * RC and UC WQEs might have a remote address segment.
+	 * MLX WQEs need two extra inline data segments (for the UD
+	 * header and space for the ICRC).
+	 */
+	switch (type) {
+	case IB_QPT_UD:
+		return sizeof (struct mlx4_wqe_ctrl_seg) +
+			sizeof (struct mlx4_wqe_datagram_seg);
+	case IB_QPT_UC:
+		return sizeof (struct mlx4_wqe_ctrl_seg) +
+			sizeof (struct mlx4_wqe_raddr_seg);
+	case IB_QPT_RC:
+		return sizeof (struct mlx4_wqe_ctrl_seg) +
+			sizeof (struct mlx4_wqe_atomic_seg) +
+			sizeof (struct mlx4_wqe_raddr_seg);
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+		return sizeof (struct mlx4_wqe_ctrl_seg) +
+			ALIGN(MLX4_IB_UD_HEADER_SIZE +
+			      sizeof (struct mlx4_wqe_inline_seg),
+			      sizeof (struct mlx4_wqe_data_seg)) +
+			ALIGN(4 +
+			      sizeof (struct mlx4_wqe_inline_seg),
+			      sizeof (struct mlx4_wqe_data_seg));
+	default:
+		return sizeof (struct mlx4_wqe_ctrl_seg);
+	}
+}
+
+static int set_qp_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
+		       enum ib_qp_type type, struct mlx4_ib_qp *qp)
+{
+	/* Sanity check QP size before proceeding */
+	if (cap->max_send_wr	 > dev->dev->caps.max_wqes  ||
+	    cap->max_recv_wr	 > dev->dev->caps.max_wqes  ||
+	    cap->max_send_sge	 > dev->dev->caps.max_sq_sg ||
+	    cap->max_recv_sge	 > dev->dev->caps.max_rq_sg ||
+	    cap->max_inline_data + send_wqe_overhead(type) +
+	    sizeof (struct mlx4_wqe_inline_seg) > dev->dev->caps.max_sq_desc_sz)
+		return -EINVAL;
+
+	/*
+	 * For MLX transport we need 2 extra S/G entries:
+	 * one for the header and one for the checksum at the end
+	 */
+	if ((type == IB_QPT_SMI || type == IB_QPT_GSI) &&
+	    cap->max_send_sge + 2 > dev->dev->caps.max_sq_sg)
+		return -EINVAL;
+
+	qp->rq.max = cap->max_recv_wr ? roundup_pow_of_two(cap->max_recv_wr) : 0;
+	qp->sq.max = cap->max_send_wr ? roundup_pow_of_two(cap->max_send_wr) : 0;
+
+	qp->rq.wqe_shift = ilog2(roundup_pow_of_two(cap->max_recv_sge *
+						    sizeof (struct mlx4_wqe_data_seg)));
+	qp->rq.max_gs    = (1 << qp->rq.wqe_shift) / sizeof (struct mlx4_wqe_data_seg);
+
+	qp->sq.wqe_shift = ilog2(roundup_pow_of_two(max(cap->max_send_sge *
+							sizeof (struct mlx4_wqe_data_seg),
+							cap->max_inline_data +
+							sizeof (struct mlx4_wqe_inline_seg)) +
+						    send_wqe_overhead(type)));
+	qp->sq.max_gs    = ((1 << qp->sq.wqe_shift) - send_wqe_overhead(type)) /
+		sizeof (struct mlx4_wqe_data_seg);
+
+	qp->buf_size = (qp->rq.max << qp->rq.wqe_shift) +
+		(qp->sq.max << qp->sq.wqe_shift);
+	if (qp->rq.wqe_shift > qp->sq.wqe_shift) {
+		qp->rq.offset = 0;
+		qp->sq.offset = qp->rq.max << qp->rq.wqe_shift;
+	} else {
+		qp->rq.offset = qp->sq.max << qp->sq.wqe_shift;
+		qp->sq.offset = 0;
+	}
+
+	cap->max_send_wr  = qp->sq.max;
+	cap->max_recv_wr  = qp->rq.max;
+	cap->max_send_sge = qp->sq.max_gs;
+	cap->max_recv_sge = qp->sq.max_gs;
+
+	return 0;
+}
+
+static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
+			    struct ib_qp_init_attr *init_attr,
+			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp *qp)
+{
+	struct mlx4_wqe_ctrl_seg *ctrl;
+	int err;
+	int i;
+
+	mutex_init(&qp->mutex);
+	spin_lock_init(&qp->sq.lock);
+	spin_lock_init(&qp->rq.lock);
+
+	qp->state	 = IB_QPS_RESET;
+	qp->atomic_rd_en = 0;
+	qp->resp_depth   = 0;
+
+	qp->rq.head	    = 0;
+	qp->rq.tail	    = 0;
+	qp->sq.head	    = 0;
+	qp->sq.tail	    = 0;
+
+	err = set_qp_size(dev, &init_attr->cap, init_attr->qp_type, qp);
+	if (err)
+		goto err;
+
+	if (pd->uobject) {
+		struct mlx4_ib_create_qp ucmd;
+
+		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+			err = -EFAULT;
+			goto err;
+		}
+
+		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
+				       qp->buf_size, 0);
+		if (IS_ERR(qp->umem)) {
+			err = PTR_ERR(qp->umem);
+			goto err;
+		}
+
+		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(qp->umem),
+				    ilog2(qp->umem->page_size), &qp->mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_ib_umem_write_mtt(dev, &qp->mtt, qp->umem);
+		if (err)
+			goto err_mtt;
+
+		err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
+					  ucmd.db_addr, &qp->db);
+		if (err)
+			goto err_mtt;
+	} else {
+		err = mlx4_ib_db_alloc(dev, &qp->db, 0);
+		if (err)
+			goto err;
+
+		*qp->db.db = 0;
+
+		if (mlx4_buf_alloc(dev->dev, qp->buf_size, PAGE_SIZE * 2, &qp->buf)) {
+			err = -ENOMEM;
+			goto err_db;
+		}
+
+		err = mlx4_mtt_init(dev->dev, qp->buf.npages, qp->buf.page_shift,
+				    &qp->mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_buf_write_mtt(dev->dev, &qp->mtt, &qp->buf);
+		if (err)
+			goto err_mtt;
+
+		for (i = 0; i < qp->sq.max; ++i) {
+			ctrl = get_send_wqe(qp, i);
+			ctrl->owner_opcode = cpu_to_be32(1 << 31);
+		}
+
+		qp->sq.wrid  = kmalloc(qp->sq.max * sizeof (u64), GFP_KERNEL);
+		qp->rq.wrid  = kmalloc(qp->rq.max * sizeof (u64), GFP_KERNEL);
+
+		if (!qp->sq.wrid || !qp->rq.wrid) {
+			err = -ENOMEM;
+			goto err_wrid;
+		}
+	}
+
+	err = mlx4_qp_alloc(dev->dev, sqpn, &qp->mqp);
+	if (err)
+		goto err_wrid;
+
+	/*
+	 * Hardware wants QPN written in big-endian order (after
+	 * shifting) for send doorbell.  Precompute this value to save
+	 * a little bit when posting sends.
+	 */
+	qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
+
+	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
+		qp->sq_signal_bits = cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
+	else
+		qp->sq_signal_bits = 0;
+
+	qp->mqp.event = mlx4_ib_qp_event;
+
+	return 0;
+
+err_wrid:
+	if (pd->uobject)
+		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db);
+	else {
+		kfree(qp->sq.wrid);
+		kfree(qp->rq.wrid);
+	}
+
+err_mtt:
+	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
+
+err_buf:
+	if (pd->uobject)
+		ib_umem_release(qp->umem);
+	else
+		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
+
+err_db:
+	if (!pd->uobject)
+		mlx4_ib_db_free(dev, &qp->db);
+
+err:
+	return err;
+}
+
+static enum mlx4_qp_state to_mlx4_state(enum ib_qp_state state)
+{
+	switch (state) {
+	case IB_QPS_RESET:	return MLX4_QP_STATE_RST;
+	case IB_QPS_INIT:	return MLX4_QP_STATE_INIT;
+	case IB_QPS_RTR:	return MLX4_QP_STATE_RTR;
+	case IB_QPS_RTS:	return MLX4_QP_STATE_RTS;
+	case IB_QPS_SQD:	return MLX4_QP_STATE_SQD;
+	case IB_QPS_SQE:	return MLX4_QP_STATE_SQER;
+	case IB_QPS_ERR:	return MLX4_QP_STATE_ERR;
+	default:		return -1;
+	}
+}
+
+static void mlx4_ib_lock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *recv_cq)
+{
+	if (send_cq == recv_cq)
+		spin_lock_irq(&send_cq->lock);
+	else if (send_cq->mcq.cqn < recv_cq->mcq.cqn) {
+		spin_lock_irq(&send_cq->lock);
+		spin_lock_nested(&recv_cq->lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock_irq(&recv_cq->lock);
+		spin_lock_nested(&send_cq->lock, SINGLE_DEPTH_NESTING);
+	}
+}
+
+static void mlx4_ib_unlock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *recv_cq)
+{
+	if (send_cq == recv_cq)
+		spin_unlock_irq(&send_cq->lock);
+	else if (send_cq->mcq.cqn < recv_cq->mcq.cqn) {
+		spin_unlock(&recv_cq->lock);
+		spin_unlock_irq(&send_cq->lock);
+	} else {
+		spin_unlock(&send_cq->lock);
+		spin_unlock_irq(&recv_cq->lock);
+	}
+}
+
+static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
+			      int is_user)
+{
+	struct mlx4_ib_cq *send_cq, *recv_cq;
+
+	if (qp->state != IB_QPS_RESET)
+		if (mlx4_qp_modify(dev->dev, NULL, to_mlx4_state(qp->state),
+				   MLX4_QP_STATE_RST, NULL, 0, 0, &qp->mqp))
+			printk(KERN_WARNING "mlx4_ib: modify QP %06x to RESET failed.\n",
+			       qp->mqp.qpn);
+
+	send_cq = to_mcq(qp->ibqp.send_cq);
+	recv_cq = to_mcq(qp->ibqp.recv_cq);
+
+	mlx4_ib_lock_cqs(send_cq, recv_cq);
+
+	if (!is_user) {
+		mlx4_ib_cq_clean(recv_cq, qp->mqp.qpn,
+				 qp->ibqp.srq ? to_msrq(qp->ibqp.srq): NULL);
+		if (send_cq != recv_cq)
+			mlx4_ib_cq_clean(send_cq, qp->mqp.qpn, NULL);
+	}
+
+	mlx4_qp_remove(dev->dev, &qp->mqp);
+
+	mlx4_ib_unlock_cqs(send_cq, recv_cq);
+
+	mlx4_qp_free(dev->dev, &qp->mqp);
+	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
+
+	if (is_user) {
+		mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
+				      &qp->db);
+		ib_umem_release(qp->umem);
+	} else {
+		kfree(qp->sq.wrid);
+		kfree(qp->rq.wrid);
+		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
+		mlx4_ib_db_free(dev, &qp->db);
+	}
+}
+
+struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
+				struct ib_qp_init_attr *init_attr,
+				struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(pd->device);
+	struct mlx4_ib_sqp *sqp;
+	struct mlx4_ib_qp *qp;
+	int err;
+
+	switch (init_attr->qp_type) {
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+	case IB_QPT_UD:
+	{
+		qp = kmalloc(sizeof *qp, GFP_KERNEL);
+		if (!qp)
+			return ERR_PTR(-ENOMEM);
+
+		err = create_qp_common(dev, pd, init_attr, udata, 0, qp);
+		if (err) {
+			kfree(qp);
+			return ERR_PTR(err);
+		}
+
+		qp->ibqp.qp_num = qp->mqp.qpn;
+
+		break;
+	}
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	{
+		/* Userspace is not allowed to create special QPs: */
+		if (pd->uobject)
+			return ERR_PTR(-EINVAL);
+
+		sqp = kmalloc(sizeof *sqp, GFP_KERNEL);
+		if (!sqp)
+			return ERR_PTR(-ENOMEM);
+
+		qp = &sqp->qp;
+
+		err = create_qp_common(dev, pd, init_attr, udata,
+				       dev->dev->caps.sqp_start +
+				       (init_attr->qp_type == IB_QPT_SMI ? 0 : 2) +
+				       init_attr->port_num - 1,
+				       qp);
+		if (err) {
+			kfree(sqp);
+			return ERR_PTR(err);
+		}
+
+		qp->port	= init_attr->port_num;
+		qp->ibqp.qp_num = init_attr->qp_type == IB_QPT_SMI ? 0 : 1;
+
+		break;
+	}
+	default:
+		/* Don't support raw QPs */
+		return ERR_PTR(-EINVAL);
+	}
+
+	return &qp->ibqp;
+}
+
+int mlx4_ib_destroy_qp(struct ib_qp *qp)
+{
+	struct mlx4_ib_dev *dev = to_mdev(qp->device);
+	struct mlx4_ib_qp *mqp = to_mqp(qp);
+
+	if (is_qp0(dev, mqp))
+		mlx4_CLOSE_PORT(dev->dev, mqp->port);
+
+	destroy_qp_common(dev, mqp, !!qp->pd->uobject);
+
+	if (is_sqp(dev, mqp))
+		kfree(to_msqp(mqp));
+	else
+		kfree(mqp);
+
+	return 0;
+}
+
+static void init_port(struct mlx4_ib_dev *dev, int port)
+{
+	struct mlx4_init_port_param param;
+	int err;
+
+	memset(&param, 0, sizeof param);
+
+	param.port_width_cap = dev->dev->caps.port_width_cap;
+	param.vl_cap	     = dev->dev->caps.vl_cap;
+	param.mtu	     = ib_mtu_enum_to_int(dev->dev->caps.mtu_cap);
+	param.max_gid	     = dev->dev->caps.gid_table_len;
+	param.max_pkey	     = dev->dev->caps.pkey_table_len;
+
+	err = mlx4_INIT_PORT(dev->dev, &param, port);
+	if (err)
+		printk(KERN_WARNING "INIT_PORT failed, return code %d.\n", err);
+}
+
+static int to_mlx4_st(enum ib_qp_type type)
+{
+	switch (type) {
+	case IB_QPT_RC:		return MLX4_QP_ST_RC;
+	case IB_QPT_UC:		return MLX4_QP_ST_UC;
+	case IB_QPT_UD:		return MLX4_QP_ST_UD;
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:	return MLX4_QP_ST_MLX;
+	default:		return -1;
+	}
+}
+
+static __be32 to_mlx4_access_flags(struct mlx4_ib_qp *qp, struct ib_qp_attr *attr,
+				   int attr_mask)
+{
+	u8 dest_rd_atomic;
+	u32 access_flags;
+	u32 hw_access_flags = 0;
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		dest_rd_atomic = attr->max_dest_rd_atomic;
+	else
+		dest_rd_atomic = qp->resp_depth;
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS)
+		access_flags = attr->qp_access_flags;
+	else
+		access_flags = qp->atomic_rd_en;
+
+	if (!dest_rd_atomic)
+		access_flags &= IB_ACCESS_REMOTE_WRITE;
+
+	if (access_flags & IB_ACCESS_REMOTE_READ)
+		hw_access_flags |= MLX4_QP_BIT_RRE;
+	if (access_flags & IB_ACCESS_REMOTE_ATOMIC)
+		hw_access_flags |= MLX4_QP_BIT_RAE;
+	if (access_flags & IB_ACCESS_REMOTE_WRITE)
+		hw_access_flags |= MLX4_QP_BIT_RWE;
+
+	return cpu_to_be32(hw_access_flags);
+}
+
+static void store_sqp_attrs(struct mlx4_ib_sqp *sqp, struct ib_qp_attr *attr,
+			    int attr_mask)
+{
+	if (attr_mask & IB_QP_PKEY_INDEX)
+		sqp->pkey_index = attr->pkey_index;
+	if (attr_mask & IB_QP_QKEY)
+		sqp->qkey = attr->qkey;
+	if (attr_mask & IB_QP_SQ_PSN)
+		sqp->send_psn = attr->sq_psn;
+}
+
+static void mlx4_set_sched(struct mlx4_qp_path *path, u8 port)
+{
+	path->sched_queue = (path->sched_queue & 0xbf) | ((port - 1) << 6);
+}
+
+static int mlx4_set_path(struct mlx4_ib_dev *dev, struct ib_ah_attr *ah,
+			 struct mlx4_qp_path *path, u8 port)
+{
+	path->grh_mylmc     = ah->src_path_bits & 0x7f;
+	path->rlid	    = cpu_to_be16(ah->dlid);
+	if (ah->static_rate) {
+		path->static_rate = ah->static_rate + MLX4_STAT_RATE_OFFSET;
+		while (path->static_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
+		       !(1 << path->static_rate & dev->dev->caps.stat_rate_support))
+			--path->static_rate;
+	} else
+		path->static_rate = 0;
+	path->counter_index = 0xff;
+
+	if (ah->ah_flags & IB_AH_GRH) {
+		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len) {
+			printk(KERN_ERR "sgid_index (%u) too large. max is %d\n",
+			       ah->grh.sgid_index, dev->dev->caps.gid_table_len - 1);
+			return -1;
+		}
+
+		path->grh_mylmc |= 1 << 7;
+		path->mgid_index = ah->grh.sgid_index;
+		path->hop_limit  = ah->grh.hop_limit;
+		path->tclass_flowlabel =
+			cpu_to_be32((ah->grh.traffic_class << 20) |
+				    (ah->grh.flow_label));
+		memcpy(path->rgid, ah->grh.dgid.raw, 16);
+	}
+
+	path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
+		((port - 1) << 6) | ((ah->sl & 0xf) << 2);
+
+	return 0;
+}
+
+int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+		      int attr_mask, struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibqp->device);
+	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	struct mlx4_qp_context *context;
+	enum mlx4_qp_optpar optpar = 0;
+	enum ib_qp_state cur_state, new_state;
+	int sqd_event;
+	int err = -EINVAL;
+
+	context = kzalloc(sizeof *context, GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+
+	mutex_lock(&qp->mutex);
+
+	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
+	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
+
+	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type, attr_mask))
+		goto out;
+
+	if ((attr_mask & IB_QP_PKEY_INDEX) &&
+	     attr->pkey_index >= dev->dev->caps.pkey_table_len) {
+		goto out;
+	}
+
+	if ((attr_mask & IB_QP_PORT) &&
+	    (attr->port_num == 0 || attr->port_num > dev->dev->caps.num_ports)) {
+		goto out;
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
+	    attr->max_rd_atomic > dev->dev->caps.max_qp_init_rdma) {
+		goto out;
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
+	    attr->max_dest_rd_atomic > 1 << dev->dev->caps.max_qp_dest_rdma) {
+		goto out;
+	}
+
+	context->flags = cpu_to_be32((to_mlx4_state(new_state) << 28) |
+				     (to_mlx4_st(ibqp->qp_type) << 16));
+	context->flags     |= cpu_to_be32(1 << 8); /* DE? */
+
+	if (!(attr_mask & IB_QP_PATH_MIG_STATE))
+		context->flags |= cpu_to_be32(MLX4_QP_PM_MIGRATED << 11);
+	else {
+		optpar |= MLX4_QP_OPTPAR_PM_STATE;
+		switch (attr->path_mig_state) {
+		case IB_MIG_MIGRATED:
+			context->flags |= cpu_to_be32(MLX4_QP_PM_MIGRATED << 11);
+			break;
+		case IB_MIG_REARM:
+			context->flags |= cpu_to_be32(MLX4_QP_PM_REARM << 11);
+			break;
+		case IB_MIG_ARMED:
+			context->flags |= cpu_to_be32(MLX4_QP_PM_ARMED << 11);
+			break;
+		}
+	}
+
+	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
+	    ibqp->qp_type == IB_QPT_UD)
+		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
+	else if (attr_mask & IB_QP_PATH_MTU) {
+		if (attr->path_mtu < IB_MTU_256 || attr->path_mtu > IB_MTU_4096) {
+			printk(KERN_ERR "path MTU (%u) is invalid\n",
+			       attr->path_mtu);
+			return -EINVAL;
+		}
+		context->mtu_msgmax = (attr->path_mtu << 5) | 31;
+	}
+
+	if (qp->rq.max)
+		context->rq_size_stride = ilog2(qp->rq.max) << 3;
+	context->rq_size_stride |= qp->rq.wqe_shift - 4;
+
+	if (qp->sq.max)
+		context->sq_size_stride = ilog2(qp->sq.max) << 3;
+	context->sq_size_stride |= qp->sq.wqe_shift - 4;
+
+	/*FIXME monkeying with UAR internals?*/
+	if (qp->ibqp.uobject)
+		context->usr_page = cpu_to_be32(to_mucontext(ibqp->uobject->context)->uar.index);
+	else
+		context->usr_page = cpu_to_be32(dev->priv_uar.index);
+	/*FIXME looking at mqp.qpn? */
+	context->local_qpn  = cpu_to_be32(qp->mqp.qpn);
+	if (attr_mask & IB_QP_DEST_QPN)
+		context->remote_qpn = cpu_to_be32(attr->dest_qp_num);
+
+	if (attr_mask & IB_QP_PORT) {
+		if (cur_state == IB_QPS_SQD && new_state == IB_QPS_SQD &&
+		    !(attr_mask & IB_QP_AV)) {
+			mlx4_set_sched(&context->pri_path, attr->port_num);
+			optpar |= MLX4_QP_OPTPAR_SCHED_QUEUE;
+		}
+	}
+
+	if (attr_mask & IB_QP_PKEY_INDEX) {
+		context->pri_path.pkey_index = attr->pkey_index;
+		optpar |= MLX4_QP_OPTPAR_PKEY_INDEX;
+	}
+
+	if (attr_mask & IB_QP_RNR_RETRY) {
+		context->params1 |= cpu_to_be32(attr->rnr_retry << 13);
+		optpar |= MLX4_QP_OPTPAR_RNR_RETRY;
+	}
+
+	if (attr_mask & IB_QP_AV) {
+		if (mlx4_set_path(dev, &attr->ah_attr, &context->pri_path,
+				  attr_mask & IB_QP_PORT ? attr->port_num : qp->port)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
+			   MLX4_QP_OPTPAR_SCHED_QUEUE);
+	}
+
+	if (attr_mask & IB_QP_TIMEOUT) {
+		context->pri_path.ackto = attr->timeout << 3;
+		optpar |= MLX4_QP_OPTPAR_ACK_TIMEOUT;
+	}
+
+	if (attr_mask & IB_QP_ALT_PATH) {
+		if (attr->alt_pkey_index >= dev->dev->caps.pkey_table_len)
+			return -EINVAL;
+
+		if (attr->alt_port_num == 0 ||
+		    attr->alt_port_num > dev->dev->caps.num_ports)
+			return -EINVAL;
+
+		if (mlx4_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
+				  attr->alt_port_num))
+			return -EINVAL;
+
+		context->alt_path.pkey_index = attr->alt_pkey_index;
+		context->alt_path.ackto = attr->alt_timeout << 3;
+		optpar |= MLX4_QP_OPTPAR_ALT_ADDR_PATH;
+	}
+
+	context->pd	    = cpu_to_be32(to_mpd(ibqp->pd)->pdn);
+	context->params1    = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
+	if (attr_mask & IB_QP_RETRY_CNT) {
+		context->params1 |= cpu_to_be32(attr->retry_cnt << 16);
+		optpar |= MLX4_QP_OPTPAR_RETRY_COUNT;
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
+		if (attr->max_rd_atomic)
+			context->params1 |=
+				cpu_to_be32(fls(attr->max_rd_atomic - 1) << 21);
+		optpar |= MLX4_QP_OPTPAR_SRA_MAX;
+	}
+
+	if (attr_mask & IB_QP_SQ_PSN)
+		context->next_send_psn = cpu_to_be32(attr->sq_psn);
+	/*FIXME poking into CQ for cqn?*/
+	context->cqn_send = cpu_to_be32(to_mcq(ibqp->send_cq)->mcq.cqn);
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
+		if (attr->max_dest_rd_atomic)
+			context->params2 |=
+				cpu_to_be32(fls(attr->max_dest_rd_atomic - 1) << 21);
+		optpar |= MLX4_QP_OPTPAR_RRA_MAX;
+	}
+
+	if (attr_mask & (IB_QP_ACCESS_FLAGS | IB_QP_MAX_DEST_RD_ATOMIC)) {
+		context->params2 |= to_mlx4_access_flags(qp, attr, attr_mask);
+		optpar |= MLX4_QP_OPTPAR_RWE | MLX4_QP_OPTPAR_RRE | MLX4_QP_OPTPAR_RAE;
+	}
+
+	if (ibqp->srq)
+		context->params2 |= cpu_to_be32(MLX4_QP_BIT_RIC);
+
+	if (attr_mask & IB_QP_MIN_RNR_TIMER) {
+		context->rnr_nextrecvpsn |= cpu_to_be32(attr->min_rnr_timer << 24);
+		optpar |= MLX4_QP_OPTPAR_RNR_TIMEOUT;
+	}
+	if (attr_mask & IB_QP_RQ_PSN)
+		context->rnr_nextrecvpsn |= cpu_to_be32(attr->rq_psn);
+
+	/*FIXME poking into CQ for cqn?*/
+	context->cqn_recv = cpu_to_be32(to_mcq(ibqp->recv_cq)->mcq.cqn);
+
+	if (attr_mask & IB_QP_QKEY) {
+		context->qkey = cpu_to_be32(attr->qkey);
+		optpar |= MLX4_QP_OPTPAR_Q_KEY;
+	}
+
+	if (ibqp->srq)
+		context->srqn = cpu_to_be32(1 << 24 | to_msrq(ibqp->srq)->msrq.srqn);
+
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+		context->db_rec_addr = cpu_to_be64(qp->db.dma);
+
+	if (cur_state == IB_QPS_INIT &&
+	    new_state == IB_QPS_RTR  &&
+	    (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI ||
+	     ibqp->qp_type == IB_QPT_UD)) {
+		context->pri_path.sched_queue = (qp->port - 1) << 6;
+		if (is_qp0(dev, qp))
+			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_QP0_SCHED_QUEUE;
+		else
+			context->pri_path.sched_queue |= MLX4_IB_DEFAULT_SCHED_QUEUE;
+	}
+
+	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
+	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
+		sqd_event = 1;
+	else
+		sqd_event = 0;
+
+	err = mlx4_qp_modify(dev->dev, &qp->mtt, to_mlx4_state(cur_state),
+			     to_mlx4_state(new_state), context, optpar,
+			     sqd_event, &qp->mqp);
+	if (err)
+		goto out;
+
+	qp->state = new_state;
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS)
+		qp->atomic_rd_en = attr->qp_access_flags;
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		qp->resp_depth = attr->max_dest_rd_atomic;
+	if (attr_mask & IB_QP_PORT)
+		qp->port = attr->port_num;
+	if (attr_mask & IB_QP_ALT_PATH)
+		qp->alt_port = attr->alt_port_num;
+
+	if (is_sqp(dev, qp))
+		store_sqp_attrs(to_msqp(qp), attr, attr_mask);
+
+	/*
+	 * If we moved QP0 to RTR, bring the IB link up; if we moved
+	 * QP0 to RESET or ERROR, bring the link back down.
+	 */
+	if (is_qp0(dev, qp)) {
+		if (cur_state != IB_QPS_RTR && new_state == IB_QPS_RTR)
+			init_port(dev, qp->port);
+
+		if (cur_state != IB_QPS_RESET && cur_state != IB_QPS_ERR &&
+		    (new_state == IB_QPS_RESET || new_state == IB_QPS_ERR))
+			mlx4_CLOSE_PORT(dev->dev, qp->port);
+	}
+
+	/*
+	 * If we moved a kernel QP to RESET, clean up all old CQ
+	 * entries and reinitialize the QP.
+	 */
+	if (new_state == IB_QPS_RESET && !ibqp->uobject) {
+		mlx4_ib_cq_clean(to_mcq(ibqp->recv_cq), qp->mqp.qpn,
+				 ibqp->srq ? to_msrq(ibqp->srq): NULL);
+		if (ibqp->send_cq != ibqp->recv_cq)
+			mlx4_ib_cq_clean(to_mcq(ibqp->send_cq), qp->mqp.qpn, NULL);
+
+		qp->rq.head = 0;
+		qp->rq.tail = 0;
+		qp->sq.head = 0;
+		qp->sq.tail = 0;
+		*qp->db.db  = 0;
+	}
+
+out:
+	mutex_unlock(&qp->mutex);
+	kfree(context);
+	return err;
+}
+
+static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
+			    void *wqe)
+{
+	struct ib_device *ib_dev = &to_mdev(sqp->qp.ibqp.device)->ib_dev;
+	struct mlx4_wqe_mlx_seg *mlx = wqe;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_ib_ah *ah = to_mah(wr->wr.ud.ah);
+	u16 pkey;
+	int send_size;
+	int header_size;
+	int i;
+
+	send_size = 0;
+	for (i = 0; i < wr->num_sge; ++i)
+		send_size += wr->sg_list[i].length;
+
+	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), &sqp->ud_header);
+
+	sqp->ud_header.lrh.service_level   =
+		be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
+	sqp->ud_header.lrh.destination_lid = ah->av.dlid;
+	sqp->ud_header.lrh.source_lid      = cpu_to_be16(ah->av.g_slid & 0x7f);
+	if (mlx4_ib_ah_grh_present(ah)) {
+		sqp->ud_header.grh.traffic_class =
+			(be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 20) & 0xff;
+		sqp->ud_header.grh.flow_label    =
+			ah->av.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
+		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.port_pd) >> 24,
+				  ah->av.gid_index, &sqp->ud_header.grh.source_gid);
+		memcpy(sqp->ud_header.grh.destination_gid.raw,
+		       ah->av.dgid, 16);
+	}
+
+	mlx->flags &= cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
+	mlx->flags |= cpu_to_be32((!sqp->qp.ibqp.qp_num ? MLX4_WQE_MLX_VL15 : 0) |
+				  (sqp->ud_header.lrh.destination_lid ==
+				   IB_LID_PERMISSIVE ? MLX4_WQE_MLX_SLR : 0) |
+				  (sqp->ud_header.lrh.service_level << 8));
+	mlx->rlid   = sqp->ud_header.lrh.destination_lid;
+
+	switch (wr->opcode) {
+	case IB_WR_SEND:
+		sqp->ud_header.bth.opcode	 = IB_OPCODE_UD_SEND_ONLY;
+		sqp->ud_header.immediate_present = 0;
+		break;
+	case IB_WR_SEND_WITH_IMM:
+		sqp->ud_header.bth.opcode	 = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
+		sqp->ud_header.immediate_present = 1;
+		sqp->ud_header.immediate_data    = wr->imm_data;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	sqp->ud_header.lrh.virtual_lane    = !sqp->qp.ibqp.qp_num ? 15 : 0;
+	if (sqp->ud_header.lrh.destination_lid == IB_LID_PERMISSIVE)
+		sqp->ud_header.lrh.source_lid = IB_LID_PERMISSIVE;
+	sqp->ud_header.bth.solicited_event = !!(wr->send_flags & IB_SEND_SOLICITED);
+	if (!sqp->qp.ibqp.qp_num)
+		ib_get_cached_pkey(ib_dev, sqp->qp.port, sqp->pkey_index, &pkey);
+	else
+		ib_get_cached_pkey(ib_dev, sqp->qp.port, wr->wr.ud.pkey_index, &pkey);
+	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
+	sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->wr.ud.remote_qpn);
+	sqp->ud_header.bth.psn = cpu_to_be32((sqp->send_psn++) & ((1 << 24) - 1));
+	sqp->ud_header.deth.qkey = cpu_to_be32(wr->wr.ud.remote_qkey & 0x80000000 ?
+					       sqp->qkey : wr->wr.ud.remote_qkey);
+	sqp->ud_header.deth.source_qpn = cpu_to_be32(sqp->qp.ibqp.qp_num);
+
+	header_size = ib_ud_header_pack(&sqp->ud_header, sqp->header_buf);
+
+	if (0) {
+		printk(KERN_ERR "built UD header of size %d:\n", header_size);
+		for (i = 0; i < header_size / 4; ++i) {
+			if (i % 8 == 0)
+				printk("  [%02x] ", i * 4);
+			printk(" %08x",
+			       be32_to_cpu(((__be32 *) sqp->header_buf)[i]));
+			if ((i + 1) % 8 == 0)
+				printk("\n");
+		}
+		printk("\n");
+	}
+
+	inl->byte_count = cpu_to_be32(1 << 31 | header_size);
+	memcpy(inl + 1, sqp->header_buf, header_size);
+
+	return ALIGN(sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
+}
+
+int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		      struct ib_send_wr **bad_wr)
+{
+	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	void *wqe;
+	struct mlx4_wqe_ctrl_seg *ctrl;
+	unsigned long flags;
+	int nreq;
+	int err = 0;
+	int ind;
+	int size;
+	int i;
+
+	spin_lock_irqsave(&qp->rq.lock, flags);
+
+	ind = qp->sq.head;
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		/* FIXME check overflow */
+
+		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
+			err = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		ctrl = wqe = get_send_wqe(qp, ind & (qp->sq.max - 1));
+		qp->sq.wrid[ind & (qp->sq.max - 1)] = wr->wr_id;
+
+		ctrl->srcrb_flags =
+			(wr->send_flags & IB_SEND_SIGNALED ?
+			 cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE) : 0) |
+			(wr->send_flags & IB_SEND_SOLICITED ?
+			 cpu_to_be32(MLX4_WQE_CTRL_SOLICITED) : 0) |
+			qp->sq_signal_bits;
+
+		if (wr->opcode == IB_WR_SEND_WITH_IMM ||
+		    wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM)
+			ctrl->imm = wr->imm_data;
+		else
+			ctrl->imm = 0;
+
+		wqe += sizeof *ctrl;
+		size = sizeof *ctrl / 16;
+
+		switch (ibqp->qp_type) {
+		case IB_QPT_RC:
+		case IB_QPT_UC:
+			switch (wr->opcode) {
+			case IB_WR_ATOMIC_CMP_AND_SWP:
+			case IB_WR_ATOMIC_FETCH_AND_ADD:
+				((struct mlx4_wqe_raddr_seg *) wqe)->raddr =
+					cpu_to_be64(wr->wr.atomic.remote_addr);
+				((struct mlx4_wqe_raddr_seg *) wqe)->rkey =
+					cpu_to_be32(wr->wr.atomic.rkey);
+				((struct mlx4_wqe_raddr_seg *) wqe)->reserved = 0;
+
+				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
+
+				if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
+					((struct mlx4_wqe_atomic_seg *) wqe)->swap_add =
+						cpu_to_be64(wr->wr.atomic.swap);
+					((struct mlx4_wqe_atomic_seg *) wqe)->compare =
+						cpu_to_be64(wr->wr.atomic.compare_add);
+				} else {
+					((struct mlx4_wqe_atomic_seg *) wqe)->swap_add =
+						cpu_to_be64(wr->wr.atomic.compare_add);
+					((struct mlx4_wqe_atomic_seg *) wqe)->compare = 0;
+				}
+
+				wqe  += sizeof (struct mlx4_wqe_atomic_seg);
+				size += (sizeof (struct mlx4_wqe_raddr_seg) +
+					 sizeof (struct mlx4_wqe_atomic_seg)) / 16;
+
+				break;
+
+			case IB_WR_RDMA_READ:
+			case IB_WR_RDMA_WRITE:
+			case IB_WR_RDMA_WRITE_WITH_IMM:
+				((struct mlx4_wqe_raddr_seg *) wqe)->raddr =
+					cpu_to_be64(wr->wr.rdma.remote_addr);
+				((struct mlx4_wqe_raddr_seg *) wqe)->rkey =
+					cpu_to_be32(wr->wr.rdma.rkey);
+				((struct mlx4_wqe_raddr_seg *) wqe)->reserved = 0;
+
+				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
+				size += sizeof (struct mlx4_wqe_raddr_seg) / 16;
+
+				break;
+
+			default:
+				/* No extra segments required for sends */
+				break;
+			}
+			break;
+
+		case IB_QPT_UD:
+			memcpy(((struct mlx4_wqe_datagram_seg *) wqe)->av,
+			       &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
+			((struct mlx4_wqe_datagram_seg *) wqe)->dqpn =
+				cpu_to_be32(wr->wr.ud.remote_qpn);
+			((struct mlx4_wqe_datagram_seg *) wqe)->qkey =
+				cpu_to_be32(wr->wr.ud.remote_qkey);
+
+			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
+			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+			break;
+
+		case IB_QPT_SMI:
+		case IB_QPT_GSI:
+			err = build_mlx_header(to_msqp(qp), wr, ctrl);
+			if (err < 0) {
+				*bad_wr = wr;
+				goto out;
+			}
+			wqe  += err;
+			size += err / 16;
+
+			err = 0;
+			break;
+
+		default:
+			break;
+		}
+
+		for (i = 0; i < wr->num_sge; ++i) {
+			((struct mlx4_wqe_data_seg *) wqe)->byte_count =
+				cpu_to_be32(wr->sg_list[i].length);
+			((struct mlx4_wqe_data_seg *) wqe)->lkey =
+				cpu_to_be32(wr->sg_list[i].lkey);
+			((struct mlx4_wqe_data_seg *) wqe)->addr =
+				cpu_to_be64(wr->sg_list[i].addr);
+
+			wqe  += sizeof (struct mlx4_wqe_data_seg);
+			size += sizeof (struct mlx4_wqe_data_seg) / 16;
+		}
+
+		/* Add one more inline data segment for ICRC for MLX sends */
+		if (qp->ibqp.qp_type == IB_QPT_SMI || qp->ibqp.qp_type == IB_QPT_GSI) {
+			((struct mlx4_wqe_inline_seg *) wqe)->byte_count =
+				cpu_to_be32((1 << 31) | 4);
+			((u32 *) wqe)[1] = 0;
+			wqe  += sizeof (struct mlx4_wqe_data_seg);
+			size += sizeof (struct mlx4_wqe_data_seg) / 16;
+		}
+
+		ctrl->fence_size = (wr->send_flags & IB_SEND_FENCE ?
+				    MLX4_WQE_CTRL_FENCE : 0) | size;
+
+		/*
+		 * Make sure descriptor is fully written before
+		 * setting ownership bit (because HW can start
+		 * executing as soon as we do).
+		 */
+		wmb();
+
+		/*FIXME check opcode validity? */
+		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
+			(ind & qp->sq.max ? cpu_to_be32(1 << 31) : 0);
+
+		++ind;
+	}
+
+out:
+	if (likely(nreq)) {
+		qp->sq.head += nreq;
+
+		/*
+		 * Make sure that descriptors are written before
+		 * doorbell record.
+		 */
+		wmb();
+
+		writel(qp->doorbell_qpn,
+		       to_mdev(ibqp->device)->uar_map + MLX4_SEND_DOORBELL);
+
+		/*
+		 * Make sure doorbells don't leak out of SQ spinlock
+		 * and reach the HCA out of order.
+		 */
+		mmiowb();
+	}
+
+	spin_unlock_irqrestore(&qp->rq.lock, flags);
+
+	return err;
+}
+
+int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr)
+{
+	struct mlx4_ib_qp *qp = to_mqp(ibqp);
+	struct mlx4_wqe_data_seg *scat;
+	unsigned long flags;
+	int err = 0;
+	int nreq;
+	int ind;
+	int i;
+
+	spin_lock_irqsave(&qp->rq.lock, flags);
+
+	ind = qp->rq.head & (qp->rq.max - 1);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		/* FIXME check overflow */
+
+		if (unlikely(wr->num_sge > qp->rq.max_gs)) {
+			err = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		scat = get_recv_wqe(qp, ind);
+
+		for (i = 0; i < wr->num_sge; ++i) {
+			scat[i].byte_count = cpu_to_be32(wr->sg_list[i].length);
+			scat[i].lkey       = cpu_to_be32(wr->sg_list[i].lkey);
+			scat[i].addr       = cpu_to_be64(wr->sg_list[i].addr);
+		}
+
+		if (i < qp->rq.max_gs) {
+			scat[i].byte_count = 0;
+			scat[i].lkey       = cpu_to_be32(MLX4_INVALID_LKEY);
+			scat[i].addr       = 0;
+		}
+
+		qp->rq.wrid[ind] = wr->wr_id;
+
+		ind = (ind + 1) & (qp->rq.max - 1);
+	}
+
+out:
+	if (likely(nreq)) {
+		qp->rq.head += nreq;
+
+		/*
+		 * Make sure that descriptors are written before
+		 * doorbell record.
+		 */
+		wmb();
+
+		*qp->db.db = cpu_to_be32(qp->rq.head & 0xffff);
+	}
+
+	spin_unlock_irqrestore(&qp->rq.lock, flags);
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
new file mode 100644
index 0000000..42ab4a8
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -0,0 +1,334 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/mlx4/qp.h>
+#include <linux/mlx4/srq.h>
+
+#include "mlx4_ib.h"
+#include "user.h"
+
+static void *get_wqe(struct mlx4_ib_srq *srq, int n)
+{
+	int offset = n << srq->msrq.wqe_shift;
+
+	if (srq->buf.nbufs == 1)
+		return srq->buf.u.direct.buf + offset;
+	else
+		return srq->buf.u.page_list[offset >> PAGE_SHIFT].buf +
+			(offset & (PAGE_SIZE - 1));
+}
+
+static void mlx4_ib_srq_event(struct mlx4_srq *srq, enum mlx4_event type)
+{
+	struct ib_event event;
+	struct ib_srq *ibsrq = &to_mibsrq(srq)->ibsrq;
+
+	if (ibsrq->event_handler) {
+		event.device      = ibsrq->device;
+		event.element.srq = ibsrq;
+		switch (type) {
+		case MLX4_EVENT_TYPE_SRQ_LIMIT:
+			event.event = IB_EVENT_SRQ_LIMIT_REACHED;
+			break;
+		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
+			event.event = IB_EVENT_SRQ_ERR;
+			break;
+		default:
+			printk(KERN_WARNING "mlx4_ib: Unexpected event type %d "
+			       "on SRQ %06x\n", type, srq->srqn);
+			return;
+		}
+
+		ibsrq->event_handler(&event, ibsrq->srq_context);
+	}
+}
+
+struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
+				  struct ib_srq_init_attr *init_attr,
+				  struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(pd->device);
+	struct mlx4_ib_srq *srq;
+	struct mlx4_wqe_srq_next_seg *next;
+	int desc_size;
+	int buf_size;
+	int err;
+	int i;
+
+	/* Sanity check SRQ size before proceeding */
+	if (init_attr->attr.max_wr  >= dev->dev->caps.max_srq_wqes ||
+	    init_attr->attr.max_sge >  dev->dev->caps.max_srq_sge)
+		return ERR_PTR(-EINVAL);
+
+	srq = kmalloc(sizeof *srq, GFP_KERNEL);
+	if (!srq)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&srq->mutex);
+	spin_lock_init(&srq->lock);
+	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
+	srq->msrq.max_gs = init_attr->attr.max_sge;
+
+	desc_size = max(32UL,
+			roundup_pow_of_two(sizeof (struct mlx4_wqe_srq_next_seg) +
+					   srq->msrq.max_gs *
+					   sizeof (struct mlx4_wqe_data_seg)));
+	srq->msrq.wqe_shift = ilog2(desc_size);
+
+	buf_size = srq->msrq.max * desc_size;
+
+	if (pd->uobject) {
+		struct mlx4_ib_create_srq ucmd;
+
+		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+			err = -EFAULT;
+			goto err_srq;
+		}
+
+		srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
+					buf_size, 0);
+		if (IS_ERR(srq->umem)) {
+			err = PTR_ERR(srq->umem);
+			goto err_srq;
+		}
+
+		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(srq->umem),
+				    ilog2(srq->umem->page_size), &srq->mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_ib_umem_write_mtt(dev, &srq->mtt, srq->umem);
+		if (err)
+			goto err_mtt;
+
+		err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
+					  ucmd.db_addr, &srq->db);
+		if (err)
+			goto err_mtt;
+	} else {
+		err = mlx4_ib_db_alloc(dev, &srq->db, 0);
+		if (err)
+			goto err_srq;
+
+		*srq->db.db = 0;
+
+		if (mlx4_buf_alloc(dev->dev, buf_size, PAGE_SIZE * 2, &srq->buf)) {
+			err = -ENOMEM;
+			goto err_db;
+		}
+
+		srq->head    = 0;
+		srq->tail    = srq->msrq.max - 1;
+		srq->wqe_ctr = 0;
+
+		for (i = 0; i < srq->msrq.max; ++i) {
+			next = get_wqe(srq, i);
+			next->next_wqe_index =
+				cpu_to_be16((i + 1) & (srq->msrq.max - 1));
+		}
+
+		err = mlx4_mtt_init(dev->dev, srq->buf.npages, srq->buf.page_shift,
+				    &srq->mtt);
+		if (err)
+			goto err_buf;
+
+		err = mlx4_buf_write_mtt(dev->dev, &srq->mtt, &srq->buf);
+		if (err)
+			goto err_mtt;
+
+		srq->wrid = kmalloc(srq->msrq.max * sizeof (u64), GFP_KERNEL);
+		if (!srq->wrid) {
+			err = -ENOMEM;
+			goto err_mtt;
+		}
+	}
+
+	err = mlx4_srq_alloc(dev->dev, to_mpd(pd)->pdn, &srq->mtt,
+			     srq->db.dma, &srq->msrq);
+	if (err)
+		goto err_wrid;
+
+	srq->msrq.event = mlx4_ib_srq_event;
+
+	if (pd->uobject)
+		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof (__u32))) {
+			err = -EFAULT;
+			goto err_wrid;
+		}
+
+	init_attr->attr.max_wr = srq->msrq.max - 1;
+
+	return &srq->ibsrq;
+
+err_wrid:
+	if (pd->uobject)
+		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &srq->db);
+	else
+		kfree(srq->wrid);
+
+err_mtt:
+	mlx4_mtt_cleanup(dev->dev, &srq->mtt);
+
+err_buf:
+	if (pd->uobject)
+		ib_umem_release(srq->umem);
+	else
+		mlx4_buf_free(dev->dev, buf_size, &srq->buf);
+
+err_db:
+	if (!pd->uobject)
+		mlx4_ib_db_free(dev, &srq->db);
+
+err_srq:
+	kfree(srq);
+
+	return ERR_PTR(err);
+}
+
+int mlx4_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibsrq->device);
+	struct mlx4_ib_srq *srq = to_msrq(ibsrq);
+	int ret;
+
+	/* We don't support resizing SRQs (yet?) */
+	if (attr_mask & IB_SRQ_MAX_WR)
+		return -EINVAL;
+
+	if (attr_mask & IB_SRQ_LIMIT) {
+		if (attr->srq_limit >= srq->msrq.max)
+			return -EINVAL;
+
+		mutex_lock(&srq->mutex);
+		ret = mlx4_srq_arm(dev->dev, &srq->msrq, attr->srq_limit);
+		mutex_unlock(&srq->mutex);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int mlx4_ib_destroy_srq(struct ib_srq *srq)
+{
+	struct mlx4_ib_dev *dev = to_mdev(srq->device);
+	struct mlx4_ib_srq *msrq = to_msrq(srq);
+
+	mlx4_srq_free(dev->dev, &msrq->msrq);
+	mlx4_mtt_cleanup(dev->dev, &msrq->mtt);
+
+	if (srq->uobject) {
+		mlx4_ib_db_unmap_user(to_mucontext(srq->uobject->context), &msrq->db);
+		ib_umem_release(msrq->umem);
+	} else {
+		kfree(msrq->wrid);
+		mlx4_buf_free(dev->dev, msrq->msrq.max << msrq->msrq.wqe_shift,
+			      &msrq->buf);
+		mlx4_ib_db_free(dev, &msrq->db);
+	}
+
+	kfree(msrq);
+
+	return 0;
+}
+
+void mlx4_ib_free_srq_wqe(struct mlx4_ib_srq *srq, int wqe_index)
+{
+	struct mlx4_wqe_srq_next_seg *next;
+
+	/* always called with interrupts disabled. */
+	spin_lock(&srq->lock);
+
+	next = get_wqe(srq, srq->tail);
+	next->next_wqe_index = cpu_to_be16(wqe_index);
+	srq->tail = wqe_index;
+
+	spin_unlock(&srq->lock);
+}
+
+int mlx4_ib_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+			  struct ib_recv_wr **bad_wr)
+{
+	struct mlx4_ib_srq *srq = to_msrq(ibsrq);
+	struct mlx4_wqe_srq_next_seg *next;
+	struct mlx4_wqe_data_seg *scat;
+	unsigned long flags;
+	int err = 0;
+	int nreq;
+	int i;
+
+	spin_lock_irqsave(&srq->lock, flags);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (unlikely(wr->num_sge > srq->msrq.max_gs)) {
+			err = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
+
+		srq->wrid[srq->head] = wr->wr_id;
+
+		next      = get_wqe(srq, srq->head);
+		srq->head = be16_to_cpu(next->next_wqe_index);
+		scat      = (struct mlx4_wqe_data_seg *) (next + 1);
+
+		for (i = 0; i < wr->num_sge; ++i) {
+			scat[i].byte_count = cpu_to_be32(wr->sg_list[i].length);
+			scat[i].lkey       = cpu_to_be32(wr->sg_list[i].lkey);
+			scat[i].addr       = cpu_to_be64(wr->sg_list[i].addr);
+		}
+
+		if (i < srq->msrq.max_gs) {
+			scat[i].byte_count = 0;
+			scat[i].lkey       = cpu_to_be32(MLX4_INVALID_LKEY);
+			scat[i].addr       = 0;
+		}
+	}
+
+	if (likely(nreq)) {
+		srq->wqe_ctr += nreq;
+
+		/*
+		 * Make sure that descriptors are written before
+		 * doorbell record.
+		 */
+		wmb();
+
+		*srq->db.db = cpu_to_be32(srq->wqe_ctr);
+	}
+
+	spin_unlock_irqrestore(&srq->lock, flags);
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx4/user.h b/drivers/infiniband/hw/mlx4/user.h
new file mode 100644
index 0000000..2f382d2
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/user.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_IB_USER_H
+#define MLX4_IB_USER_H
+
+#include <linux/types.h>
+
+/*
+ * Increment this value if any changes that break userspace ABI
+ * compatibility are made.
+ */
+#define MLX4_IB_UVERBS_ABI_VERSION	1
+
+/*
+ * Make sure that all structs defined in this file remain laid out so
+ * that they pack the same way on 32-bit and 64-bit architectures (to
+ * avoid incompatibility between 32-bit userspace and 64-bit kernels).
+ * In particular do not use pointer types -- pass pointers in __u64
+ * instead.
+ */
+
+struct mlx4_ib_alloc_ucontext_resp {
+	__u32	qp_tab_size;
+	__u32	bf_reg_size;
+};
+
+struct mlx4_ib_alloc_pd_resp {
+	__u32	pdn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_cq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_cq_resp {
+	__u32	cqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_resize_cq {
+	__u64	buf_addr;
+};
+
+struct mlx4_ib_create_srq {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+struct mlx4_ib_create_srq_resp {
+	__u32	srqn;
+	__u32	reserved;
+};
+
+struct mlx4_ib_create_qp {
+	__u64	buf_addr;
+	__u64	db_addr;
+};
+
+#endif /* MLX4_IB_USER_H */
