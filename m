Return-Path: <linux-kernel-owner+w=401wt.eu-S969323AbXFHOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969323AbXFHOWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967844AbXFHOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:22:37 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:50503 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967230AbXFHOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:22:35 -0400
X-IronPort-AV: i="4.16,400,1175497200"; 
   d="scan'208"; a="491883245:sNHT59307248"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Jun 2007 07:22:24 -0700
Message-ID: <ada1wgmcyqn.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jun 2007 14:22:24.0861 (UTC) FILETIME=[6F4BB0D0:01C7A9D8]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a bunch of fixes to the new mlx4 driver, and one fix for
port assignment by the RDMA CM:

Eli Cohen (1):
      mlx4_core: Fix CQ context layout

Jack Morgenstein (2):
      mlx4_core: Don't set MTT address in dMPT entries with PA set
      IB/mlx4: Fix zeroing of rnr_retry value in ib_modify_qp()

Roland Dreier (5):
      mlx4_core: Initialize ctx_list and ctx_lock earlier
      mlx4_core: Free catastrophic error MSI-X interrupt with correct dev_id
      IB/mthca, mlx4_core: Fix typo in comment
      mlx4_core: Check firmware command interface revision
      IB/mlx4: Make sure RQ allocation is always valid

Sean Hefty (1):
      RDMA/cma: Fix initialization of next_port

 drivers/infiniband/core/cma.c           |    4 +-
 drivers/infiniband/hw/mlx4/qp.c         |   33 ++++++++++++++++++++----------
 drivers/infiniband/hw/mthca/mthca_cmd.c |    2 +-
 drivers/net/mlx4/cq.c                   |    2 +-
 drivers/net/mlx4/eq.c                   |    4 ++-
 drivers/net/mlx4/fw.c                   |   27 ++++++++++++++++++++++--
 drivers/net/mlx4/intf.c                 |    3 --
 drivers/net/mlx4/main.c                 |    2 +
 drivers/net/mlx4/mr.c                   |    8 ++++--
 9 files changed, 60 insertions(+), 25 deletions(-)


diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2eb52b7..32a0e66 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2773,8 +2773,8 @@ static int cma_init(void)
 	int ret;
 
 	get_random_bytes(&next_port, sizeof next_port);
-	next_port = (next_port % (sysctl_local_port_range[1] -
-				  sysctl_local_port_range[0])) +
+	next_port = ((unsigned int) next_port %
+		    (sysctl_local_port_range[1] - sysctl_local_port_range[0])) +
 		    sysctl_local_port_range[0];
 	cma_wq = create_singlethread_workqueue("rdma_cm");
 	if (!cma_wq)
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index dc137de..5c6d054 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -189,18 +189,28 @@ static int send_wqe_overhead(enum ib_qp_type type)
 }
 
 static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
-		       struct mlx4_ib_qp *qp)
+		       int is_user, int has_srq, struct mlx4_ib_qp *qp)
 {
 	/* Sanity check RQ size before proceeding */
 	if (cap->max_recv_wr  > dev->dev->caps.max_wqes  ||
 	    cap->max_recv_sge > dev->dev->caps.max_rq_sg)
 		return -EINVAL;
 
-	qp->rq.max = cap->max_recv_wr ? roundup_pow_of_two(cap->max_recv_wr) : 0;
+	if (has_srq) {
+		/* QPs attached to an SRQ should have no RQ */
+		if (cap->max_recv_wr)
+			return -EINVAL;
+
+		qp->rq.max = qp->rq.max_gs = 0;
+	} else {
+		/* HW requires >= 1 RQ entry with >= 1 gather entry */
+		if (is_user && (!cap->max_recv_wr || !cap->max_recv_sge))
+			return -EINVAL;
 
-	qp->rq.wqe_shift = ilog2(roundup_pow_of_two(cap->max_recv_sge *
-						    sizeof (struct mlx4_wqe_data_seg)));
-	qp->rq.max_gs    = (1 << qp->rq.wqe_shift) / sizeof (struct mlx4_wqe_data_seg);
+		qp->rq.max	 = roundup_pow_of_two(max(1, cap->max_recv_wr));
+		qp->rq.max_gs	 = roundup_pow_of_two(max(1, cap->max_recv_sge));
+		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
+	}
 
 	cap->max_recv_wr  = qp->rq.max;
 	cap->max_recv_sge = qp->rq.max_gs;
@@ -285,7 +295,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	qp->sq.head	    = 0;
 	qp->sq.tail	    = 0;
 
-	err = set_rq_size(dev, &init_attr->cap, qp);
+	err = set_rq_size(dev, &init_attr->cap, !!pd->uobject, !!init_attr->srq, qp);
 	if (err)
 		goto err;
 
@@ -762,11 +772,6 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		optpar |= MLX4_QP_OPTPAR_PKEY_INDEX;
 	}
 
-	if (attr_mask & IB_QP_RNR_RETRY) {
-		context->params1 |= cpu_to_be32(attr->rnr_retry << 13);
-		optpar |= MLX4_QP_OPTPAR_RNR_RETRY;
-	}
-
 	if (attr_mask & IB_QP_AV) {
 		if (mlx4_set_path(dev, &attr->ah_attr, &context->pri_path,
 				  attr_mask & IB_QP_PORT ? attr->port_num : qp->port)) {
@@ -802,6 +807,12 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 
 	context->pd	    = cpu_to_be32(to_mpd(ibqp->pd)->pdn);
 	context->params1    = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
+
+	if (attr_mask & IB_QP_RNR_RETRY) {
+		context->params1 |= cpu_to_be32(attr->rnr_retry << 13);
+		optpar |= MLX4_QP_OPTPAR_RNR_RETRY;
+	}
+
 	if (attr_mask & IB_QP_RETRY_CNT) {
 		context->params1 |= cpu_to_be32(attr->retry_cnt << 16);
 		optpar |= MLX4_QP_OPTPAR_RETRY_COUNT;
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 3810252..f40558d 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -772,7 +772,7 @@ int mthca_QUERY_FW(struct mthca_dev *dev, u8 *status)
 
 	MTHCA_GET(dev->fw_ver,   outbox, QUERY_FW_VER_OFFSET);
 	/*
-	 * FW subminor version is at more signifant bits than minor
+	 * FW subminor version is at more significant bits than minor
 	 * version, so swap here.
 	 */
 	dev->fw_ver = (dev->fw_ver & 0xffff00000000ull) |
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index 437d78a..39253d0 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -61,7 +61,7 @@ struct mlx4_cq_context {
 	__be32			solicit_producer_index;
 	__be32			consumer_index;
 	__be32			producer_index;
-	u8			reserved6[2];
+	u32			reserved6[2];
 	__be64			db_rec_addr;
 };
 
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index 0f11adb..27a82ce 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -490,9 +490,11 @@ static void mlx4_free_irqs(struct mlx4_dev *dev)
 
 	if (eq_table->have_irq)
 		free_irq(dev->pdev->irq, dev);
-	for (i = 0; i < MLX4_NUM_EQ; ++i)
+	for (i = 0; i < MLX4_EQ_CATAS; ++i)
 		if (eq_table->eq[i].have_irq)
 			free_irq(eq_table->eq[i].irq, eq_table->eq + i);
+	if (eq_table->eq[MLX4_EQ_CATAS].have_irq)
+		free_irq(eq_table->eq[MLX4_EQ_CATAS].irq, dev);
 }
 
 static int __devinit mlx4_map_clr_int(struct mlx4_dev *dev)
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index cfa5cc0..e7ca118 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -37,6 +37,10 @@
 #include "fw.h"
 #include "icm.h"
 
+enum {
+	MLX4_COMMAND_INTERFACE_REV	= 1
+};
+
 extern void __buggy_use_of_MLX4_GET(void);
 extern void __buggy_use_of_MLX4_PUT(void);
 
@@ -452,10 +456,12 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 	u32 *outbox;
 	int err = 0;
 	u64 fw_ver;
+	u16 cmd_if_rev;
 	u8 lg;
 
 #define QUERY_FW_OUT_SIZE             0x100
 #define QUERY_FW_VER_OFFSET            0x00
+#define QUERY_FW_CMD_IF_REV_OFFSET     0x0a
 #define QUERY_FW_MAX_CMD_OFFSET        0x0f
 #define QUERY_FW_ERR_START_OFFSET      0x30
 #define QUERY_FW_ERR_SIZE_OFFSET       0x38
@@ -477,21 +483,36 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 
 	MLX4_GET(fw_ver, outbox, QUERY_FW_VER_OFFSET);
 	/*
-	 * FW subminor version is at more signifant bits than minor
+	 * FW subminor version is at more significant bits than minor
 	 * version, so swap here.
 	 */
 	dev->caps.fw_ver = (fw_ver & 0xffff00000000ull) |
 		((fw_ver & 0xffff0000ull) >> 16) |
 		((fw_ver & 0x0000ffffull) << 16);
 
+	MLX4_GET(cmd_if_rev, outbox, QUERY_FW_CMD_IF_REV_OFFSET);
+	if (cmd_if_rev != MLX4_COMMAND_INTERFACE_REV) {
+		mlx4_err(dev, "Installed FW has unsupported "
+			 "command interface revision %d.\n",
+			 cmd_if_rev);
+		mlx4_err(dev, "(Installed FW version is %d.%d.%03d)\n",
+			 (int) (dev->caps.fw_ver >> 32),
+			 (int) (dev->caps.fw_ver >> 16) & 0xffff,
+			 (int) dev->caps.fw_ver & 0xffff);
+		mlx4_err(dev, "This driver version supports only revision %d.\n",
+			 MLX4_COMMAND_INTERFACE_REV);
+		err = -ENODEV;
+		goto out;
+	}
+
 	MLX4_GET(lg, outbox, QUERY_FW_MAX_CMD_OFFSET);
 	cmd->max_cmds = 1 << lg;
 
-	mlx4_dbg(dev, "FW version %d.%d.%03d, max commands %d\n",
+	mlx4_dbg(dev, "FW version %d.%d.%03d (cmd intf rev %d), max commands %d\n",
 		 (int) (dev->caps.fw_ver >> 32),
 		 (int) (dev->caps.fw_ver >> 16) & 0xffff,
 		 (int) dev->caps.fw_ver & 0xffff,
-		 cmd->max_cmds);
+		 cmd_if_rev, cmd->max_cmds);
 
 	MLX4_GET(fw->catas_offset, outbox, QUERY_FW_ERR_START_OFFSET);
 	MLX4_GET(fw->catas_size,   outbox, QUERY_FW_ERR_SIZE_OFFSET);
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index 65854f9..9ae951b 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -135,9 +135,6 @@ int mlx4_register_device(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_interface *intf;
 
-	INIT_LIST_HEAD(&priv->ctx_list);
-	spin_lock_init(&priv->ctx_lock);
-
 	mutex_lock(&intf_mutex);
 
 	list_add_tail(&priv->dev_list, &dev_list);
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 20b8c0d..d417293 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -787,6 +787,8 @@ static int __devinit mlx4_init_one(struct pci_dev *pdev,
 
 	dev       = &priv->dev;
 	dev->pdev = pdev;
+	INIT_LIST_HEAD(&priv->ctx_list);
+	spin_lock_init(&priv->ctx_lock);
 
 	/*
 	 * Now reset the HCA before we touch the PCI capabilities or
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index b33864d..d0808fa 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -324,15 +324,17 @@ int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
 				       MLX4_MPT_FLAG_MIO	 |
 				       MLX4_MPT_FLAG_REGION	 |
 				       mr->access);
-	if (mr->mtt.order < 0)
-		mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
 
 	mpt_entry->key	       = cpu_to_be32(key_to_hw_index(mr->key));
 	mpt_entry->pd	       = cpu_to_be32(mr->pd);
 	mpt_entry->start       = cpu_to_be64(mr->iova);
 	mpt_entry->length      = cpu_to_be64(mr->size);
 	mpt_entry->entity_size = cpu_to_be32(mr->mtt.page_shift);
-	mpt_entry->mtt_seg     = cpu_to_be64(mlx4_mtt_addr(dev, &mr->mtt));
+	if (mr->mtt.order < 0) {
+		mpt_entry->flags |= cpu_to_be32(MLX4_MPT_FLAG_PHYSICAL);
+		mpt_entry->mtt_seg = 0;
+	} else
+		mpt_entry->mtt_seg = cpu_to_be64(mlx4_mtt_addr(dev, &mr->mtt));
 
 	err = mlx4_SW2HW_MPT(dev, mailbox,
 			     key_to_hw_index(mr->key) & (dev->caps.num_mpts - 1));
