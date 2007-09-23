Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXIWUGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXIWUGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXIWUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:06:10 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:11577 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbXIWUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:06:08 -0400
X-IronPort-AV: E=Sophos;i="4.20,289,1186383600"; 
   d="scan'208";a="177283688"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 23 Sep 2007 13:06:05 -0700
Message-ID: <ada6421w3iq.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Sep 2007 20:06:06.0415 (UTC) FILETIME=[2CE65DF0:01C7FE1D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get one fix for a data corruption bug in 2.6.23-rc7:

Jack Morgenstein (1):
      IB/mlx4: Fix data corruption triggered by wrong headroom marking order

 drivers/infiniband/hw/mlx4/qp.c |   62 ++++++++++++++++++++++++++++++--------
 1 files changed, 49 insertions(+), 13 deletions(-)


diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index ba0428d..85c51bd 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1211,12 +1211,42 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	dseg->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
 }
 
-static void set_data_seg(struct mlx4_wqe_data_seg *dseg,
-			 struct ib_sge *sg)
+static void set_mlx_icrc_seg(void *dseg)
+{
+	u32 *t = dseg;
+	struct mlx4_wqe_inline_seg *iseg = dseg;
+
+	t[1] = 0;
+
+	/*
+	 * Need a barrier here before writing the byte_count field to
+	 * make sure that all the data is visible before the
+	 * byte_count field is set.  Otherwise, if the segment begins
+	 * a new cacheline, the HCA prefetcher could grab the 64-byte
+	 * chunk and get a valid (!= * 0xffffffff) byte count but
+	 * stale data, and end up sending the wrong data.
+	 */
+	wmb();
+
+	iseg->byte_count = cpu_to_be32((1 << 31) | 4);
+}
+
+static void set_data_seg(struct mlx4_wqe_data_seg *dseg, struct ib_sge *sg)
 {
-	dseg->byte_count = cpu_to_be32(sg->length);
 	dseg->lkey       = cpu_to_be32(sg->lkey);
 	dseg->addr       = cpu_to_be64(sg->addr);
+
+	/*
+	 * Need a barrier here before writing the byte_count field to
+	 * make sure that all the data is visible before the
+	 * byte_count field is set.  Otherwise, if the segment begins
+	 * a new cacheline, the HCA prefetcher could grab the 64-byte
+	 * chunk and get a valid (!= * 0xffffffff) byte count but
+	 * stale data, and end up sending the wrong data.
+	 */
+	wmb();
+
+	dseg->byte_count = cpu_to_be32(sg->length);
 }
 
 int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
@@ -1225,6 +1255,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	struct mlx4_ib_qp *qp = to_mqp(ibqp);
 	void *wqe;
 	struct mlx4_wqe_ctrl_seg *ctrl;
+	struct mlx4_wqe_data_seg *dseg;
 	unsigned long flags;
 	int nreq;
 	int err = 0;
@@ -1324,22 +1355,27 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			break;
 		}
 
-		for (i = 0; i < wr->num_sge; ++i) {
-			set_data_seg(wqe, wr->sg_list + i);
+		/*
+		 * Write data segments in reverse order, so as to
+		 * overwrite cacheline stamp last within each
+		 * cacheline.  This avoids issues with WQE
+		 * prefetching.
+		 */
 
-			wqe  += sizeof (struct mlx4_wqe_data_seg);
-			size += sizeof (struct mlx4_wqe_data_seg) / 16;
-		}
+		dseg = wqe;
+		dseg += wr->num_sge - 1;
+		size += wr->num_sge * (sizeof (struct mlx4_wqe_data_seg) / 16);
 
 		/* Add one more inline data segment for ICRC for MLX sends */
-		if (qp->ibqp.qp_type == IB_QPT_SMI || qp->ibqp.qp_type == IB_QPT_GSI) {
-			((struct mlx4_wqe_inline_seg *) wqe)->byte_count =
-				cpu_to_be32((1 << 31) | 4);
-			((u32 *) wqe)[1] = 0;
-			wqe  += sizeof (struct mlx4_wqe_data_seg);
+		if (unlikely(qp->ibqp.qp_type == IB_QPT_SMI ||
+			     qp->ibqp.qp_type == IB_QPT_GSI)) {
+			set_mlx_icrc_seg(dseg + 1);
 			size += sizeof (struct mlx4_wqe_data_seg) / 16;
 		}
 
+		for (i = wr->num_sge - 1; i >= 0; --i, --dseg)
+			set_data_seg(dseg, wr->sg_list + i);
+
 		ctrl->fence_size = (wr->send_flags & IB_SEND_FENCE ?
 				    MLX4_WQE_CTRL_FENCE : 0) | size;
 
