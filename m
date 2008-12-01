Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYLASQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYLASQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYLASQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:16:19 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:55318 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYLASQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:16:13 -0500
X-IronPort-AV: E=Sophos;i="4.33,696,1220227200"; 
   d="scan'208";a="111914878"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 01 Dec 2008 10:16:10 -0800
Message-ID: <ada1vwrbw2d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Dec 2008 18:16:11.0330 (UTC) FILETIME=[E39D8220:01C953E0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get two fixes to the ehca driver for problems in patches
added in the 2.6.28 cycle, and two fixes for mlx4, one for a
regression introduced in the 2.6.28 cycle, and one for a resource leak
that is serious enough and has a simple enough fix to target -stable.

Jack Morgenstein (2):
      mlx4_core: Save/restore default port IB capability mask
      IB/mlx4: Fix MTT leakage in resize CQ

Joachim Fenkes (1):
      IB/ehca: Change misleading error message on memory hotplug

Roland Dreier (1):
      Merge branches 'ehca' and 'mlx4' into for-linus

Stefan Roscher (1):
      IB/ehca: Fix problem with generated flush work completions

 drivers/infiniband/hw/ehca/ehca_classes.h |    4 ++-
 drivers/infiniband/hw/ehca/ehca_main.c    |    3 +-
 drivers/infiniband/hw/ehca/ehca_qp.c      |   26 +++++++++++---
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   51 +++++++++++++++++------------
 drivers/infiniband/hw/mlx4/cq.c           |    5 +++
 drivers/net/mlx4/main.c                   |    8 ++++
 drivers/net/mlx4/mlx4.h                   |    1 +
 drivers/net/mlx4/port.c                   |   39 +++++++++++++++++++++-
 include/linux/mlx4/device.h               |    1 +
 9 files changed, 107 insertions(+), 31 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 4df887a..7fc35cf 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -163,7 +163,8 @@ struct ehca_mod_qp_parm {
 /* struct for tracking if cqes have been reported to the application */
 struct ehca_qmap_entry {
 	u16 app_wr_id;
-	u16 reported;
+	u8 reported;
+	u8 cqe_req;
 };
 
 struct ehca_queue_map {
@@ -171,6 +172,7 @@ struct ehca_queue_map {
 	unsigned int entries;
 	unsigned int tail;
 	unsigned int left_to_poll;
+	unsigned int next_wqe_idx;   /* Idx to first wqe to be flushed */
 };
 
 struct ehca_qp {
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index bb02a86..bec7e02 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -994,8 +994,7 @@ static int ehca_mem_notifier(struct notifier_block *nb,
 			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
 						   30 * 1000))
 				ehca_gen_err("DMEM operations are not allowed"
-					     "as long as an ehca adapter is"
-					     "attached to the LPAR");
+					     "in conjunction with eHCA");
 			return NOTIFY_BAD;
 		}
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 9e05ee2..cadbf0c 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -435,9 +435,13 @@ static void reset_queue_map(struct ehca_queue_map *qmap)
 {
 	int i;
 
-	qmap->tail = 0;
-	for (i = 0; i < qmap->entries; i++)
+	qmap->tail = qmap->entries - 1;
+	qmap->left_to_poll = 0;
+	qmap->next_wqe_idx = 0;
+	for (i = 0; i < qmap->entries; i++) {
 		qmap->map[i].reported = 1;
+		qmap->map[i].cqe_req = 0;
+	}
 }
 
 /*
@@ -1121,6 +1125,7 @@ static int calc_left_cqes(u64 wqe_p, struct ipz_queue *ipz_queue,
 	void *wqe_v;
 	u64 q_ofs;
 	u32 wqe_idx;
+	unsigned int tail_idx;
 
 	/* convert real to abs address */
 	wqe_p = wqe_p & (~(1UL << 63));
@@ -1133,12 +1138,17 @@ static int calc_left_cqes(u64 wqe_p, struct ipz_queue *ipz_queue,
 		return -EFAULT;
 	}
 
+	tail_idx = (qmap->tail + 1) % qmap->entries;
 	wqe_idx = q_ofs / ipz_queue->qe_size;
-	if (wqe_idx < qmap->tail)
-		qmap->left_to_poll = (qmap->entries - qmap->tail) + wqe_idx;
-	else
-		qmap->left_to_poll = wqe_idx - qmap->tail;
 
+	/* check all processed wqes, whether a cqe is requested or not */
+	while (tail_idx != wqe_idx) {
+		if (qmap->map[tail_idx].cqe_req)
+			qmap->left_to_poll++;
+		tail_idx = (tail_idx + 1) % qmap->entries;
+	}
+	/* save index in queue, where we have to start flushing */
+	qmap->next_wqe_idx = wqe_idx;
 	return 0;
 }
 
@@ -1185,10 +1195,14 @@ static int check_for_left_cqes(struct ehca_qp *my_qp, struct ehca_shca *shca)
 	} else {
 		spin_lock_irqsave(&my_qp->send_cq->spinlock, flags);
 		my_qp->sq_map.left_to_poll = 0;
+		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
+						my_qp->sq_map.entries;
 		spin_unlock_irqrestore(&my_qp->send_cq->spinlock, flags);
 
 		spin_lock_irqsave(&my_qp->recv_cq->spinlock, flags);
 		my_qp->rq_map.left_to_poll = 0;
+		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
+						my_qp->rq_map.entries;
 		spin_unlock_irqrestore(&my_qp->recv_cq->spinlock, flags);
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 6492807..00a648f 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -179,6 +179,7 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 
 	qmap_entry->app_wr_id = get_app_wr_id(send_wr->wr_id);
 	qmap_entry->reported = 0;
+	qmap_entry->cqe_req = 0;
 
 	switch (send_wr->opcode) {
 	case IB_WR_SEND:
@@ -203,8 +204,10 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 
 	if ((send_wr->send_flags & IB_SEND_SIGNALED ||
 	    qp->init_attr.sq_sig_type == IB_SIGNAL_ALL_WR)
-	    && !hidden)
+	    && !hidden) {
 		wqe_p->wr_flag |= WQE_WRFLAG_REQ_SIGNAL_COM;
+		qmap_entry->cqe_req = 1;
+	}
 
 	if (send_wr->opcode == IB_WR_SEND_WITH_IMM ||
 	    send_wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM) {
@@ -569,6 +572,7 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 		qmap_entry = &my_qp->rq_map.map[rq_map_idx];
 		qmap_entry->app_wr_id = get_app_wr_id(cur_recv_wr->wr_id);
 		qmap_entry->reported = 0;
+		qmap_entry->cqe_req = 1;
 
 		wqe_cnt++;
 	} /* eof for cur_recv_wr */
@@ -706,27 +710,34 @@ repoll:
 		goto repoll;
 	wc->qp = &my_qp->ib_qp;
 
+	qmap_tail_idx = get_app_wr_id(cqe->work_request_id);
+	if (!(cqe->w_completion_flags & WC_SEND_RECEIVE_BIT))
+		/* We got a send completion. */
+		qmap = &my_qp->sq_map;
+	else
+		/* We got a receive completion. */
+		qmap = &my_qp->rq_map;
+
+	/* advance the tail pointer */
+	qmap->tail = qmap_tail_idx;
+
 	if (is_error) {
 		/*
 		 * set left_to_poll to 0 because in error state, we will not
 		 * get any additional CQEs
 		 */
-		ehca_add_to_err_list(my_qp, 1);
+		my_qp->sq_map.next_wqe_idx = (my_qp->sq_map.tail + 1) %
+						my_qp->sq_map.entries;
 		my_qp->sq_map.left_to_poll = 0;
+		ehca_add_to_err_list(my_qp, 1);
 
+		my_qp->rq_map.next_wqe_idx = (my_qp->rq_map.tail + 1) %
+						my_qp->rq_map.entries;
+		my_qp->rq_map.left_to_poll = 0;
 		if (HAS_RQ(my_qp))
 			ehca_add_to_err_list(my_qp, 0);
-		my_qp->rq_map.left_to_poll = 0;
 	}
 
-	qmap_tail_idx = get_app_wr_id(cqe->work_request_id);
-	if (!(cqe->w_completion_flags & WC_SEND_RECEIVE_BIT))
-		/* We got a send completion. */
-		qmap = &my_qp->sq_map;
-	else
-		/* We got a receive completion. */
-		qmap = &my_qp->rq_map;
-
 	qmap_entry = &qmap->map[qmap_tail_idx];
 	if (qmap_entry->reported) {
 		ehca_warn(cq->device, "Double cqe on qp_num=%#x",
@@ -738,10 +749,6 @@ repoll:
 	wc->wr_id = replace_wr_id(cqe->work_request_id, qmap_entry->app_wr_id);
 	qmap_entry->reported = 1;
 
-	/* this is a proper completion, we need to advance the tail pointer */
-	if (++qmap->tail == qmap->entries)
-		qmap->tail = 0;
-
 	/* if left_to_poll is decremented to 0, add the QP to the error list */
 	if (qmap->left_to_poll > 0) {
 		qmap->left_to_poll--;
@@ -805,13 +812,14 @@ static int generate_flush_cqes(struct ehca_qp *my_qp, struct ib_cq *cq,
 	else
 		qmap = &my_qp->rq_map;
 
-	qmap_entry = &qmap->map[qmap->tail];
+	qmap_entry = &qmap->map[qmap->next_wqe_idx];
 
 	while ((nr < num_entries) && (qmap_entry->reported == 0)) {
 		/* generate flush CQE */
+
 		memset(wc, 0, sizeof(*wc));
 
-		offset = qmap->tail * ipz_queue->qe_size;
+		offset = qmap->next_wqe_idx * ipz_queue->qe_size;
 		wqe = (struct ehca_wqe *)ipz_qeit_calc(ipz_queue, offset);
 		if (!wqe) {
 			ehca_err(cq->device, "Invalid wqe offset=%#lx on "
@@ -850,11 +858,12 @@ static int generate_flush_cqes(struct ehca_qp *my_qp, struct ib_cq *cq,
 
 		wc->qp = &my_qp->ib_qp;
 
-		/* mark as reported and advance tail pointer */
+		/* mark as reported and advance next_wqe pointer */
 		qmap_entry->reported = 1;
-		if (++qmap->tail == qmap->entries)
-			qmap->tail = 0;
-		qmap_entry = &qmap->map[qmap->tail];
+		qmap->next_wqe_idx++;
+		if (qmap->next_wqe_idx == qmap->entries)
+			qmap->next_wqe_idx = 0;
+		qmap_entry = &qmap->map[qmap->next_wqe_idx];
 
 		wc++; nr++;
 	}
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index d0866a3..1830849 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -343,6 +343,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibcq->device);
 	struct mlx4_ib_cq *cq = to_mcq(ibcq);
+	struct mlx4_mtt mtt;
 	int outst_cqe;
 	int err;
 
@@ -376,10 +377,13 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 			goto out;
 	}
 
+	mtt = cq->buf.mtt;
+
 	err = mlx4_cq_resize(dev->dev, &cq->mcq, entries, &cq->resize_buf->buf.mtt);
 	if (err)
 		goto err_buf;
 
+	mlx4_mtt_cleanup(dev->dev, &mtt);
 	if (ibcq->uobject) {
 		cq->buf      = cq->resize_buf->buf;
 		cq->ibcq.cqe = cq->resize_buf->cqe;
@@ -406,6 +410,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 	goto out;
 
 err_buf:
+	mlx4_mtt_cleanup(dev->dev, &cq->resize_buf->buf.mtt);
 	if (!ibcq->uobject)
 		mlx4_ib_free_cq_buf(dev, &cq->resize_buf->buf,
 				    cq->resize_buf->cqe);
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 468921b..90a0281 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -753,6 +753,7 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 	int port;
+	__be32 ib_port_default_caps;
 
 	err = mlx4_init_uar_table(dev);
 	if (err) {
@@ -852,6 +853,13 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 	}
 
 	for (port = 1; port <= dev->caps.num_ports; port++) {
+		ib_port_default_caps = 0;
+		err = mlx4_get_port_ib_caps(dev, port, &ib_port_default_caps);
+		if (err)
+			mlx4_warn(dev, "failed to get port %d default "
+				  "ib capabilities (%d). Continuing with "
+				  "caps = 0\n", port, err);
+		dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
 		err = mlx4_SET_PORT(dev, port);
 		if (err) {
 			mlx4_err(dev, "Failed to set port %d, aborting\n",
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 56a2e21..34c909d 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -385,5 +385,6 @@ void mlx4_init_mac_table(struct mlx4_dev *dev, struct mlx4_mac_table *table);
 void mlx4_init_vlan_table(struct mlx4_dev *dev, struct mlx4_vlan_table *table);
 
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port);
+int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps);
 
 #endif /* MLX4_H */
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index e2fdab4..0a057e5 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -258,6 +258,42 @@ out:
 }
 EXPORT_SYMBOL_GPL(mlx4_unregister_vlan);
 
+int mlx4_get_port_ib_caps(struct mlx4_dev *dev, u8 port, __be32 *caps)
+{
+	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
+	u8 *inbuf, *outbuf;
+	int err;
+
+	inmailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(inmailbox))
+		return PTR_ERR(inmailbox);
+
+	outmailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(outmailbox)) {
+		mlx4_free_cmd_mailbox(dev, inmailbox);
+		return PTR_ERR(outmailbox);
+	}
+
+	inbuf = inmailbox->buf;
+	outbuf = outmailbox->buf;
+	memset(inbuf, 0, 256);
+	memset(outbuf, 0, 256);
+	inbuf[0] = 1;
+	inbuf[1] = 1;
+	inbuf[2] = 1;
+	inbuf[3] = 1;
+	*(__be16 *) (&inbuf[16]) = cpu_to_be16(0x0015);
+	*(__be32 *) (&inbuf[20]) = cpu_to_be32(port);
+
+	err = mlx4_cmd_box(dev, inmailbox->dma, outmailbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C);
+	if (!err)
+		*caps = *(__be32 *) (outbuf + 84);
+	mlx4_free_cmd_mailbox(dev, inmailbox);
+	mlx4_free_cmd_mailbox(dev, outmailbox);
+	return err;
+}
+
 int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -273,7 +309,8 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 		((u8 *) mailbox->buf)[3] = 6;
 		((__be16 *) mailbox->buf)[4] = cpu_to_be16(1 << 15);
 		((__be16 *) mailbox->buf)[6] = cpu_to_be16(1 << 15);
-	}
+	} else
+		((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
 	err = mlx4_cmd(dev, mailbox->dma, port, is_eth, MLX4_CMD_SET_PORT,
 		       MLX4_CMD_TIME_CLASS_B);
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index bd9977b..371086f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -179,6 +179,7 @@ struct mlx4_caps {
 	int			num_ports;
 	int			vl_cap[MLX4_MAX_PORTS + 1];
 	int			ib_mtu_cap[MLX4_MAX_PORTS + 1];
+	__be32			ib_port_def_cap[MLX4_MAX_PORTS + 1];
 	u64			def_mac[MLX4_MAX_PORTS + 1];
 	int			eth_mtu_cap[MLX4_MAX_PORTS + 1];
 	int			gid_table_len[MLX4_MAX_PORTS + 1];
