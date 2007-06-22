Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbXFVQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbXFVQ0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbXFVQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:26:09 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:12662 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbXFVQ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:26:07 -0400
X-IronPort-AV: i="4.16,452,1175497200"; 
   d="scan'208"; a="4460124:sNHT24866922"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 22 Jun 2007 09:26:05 -0700
Message-ID: <ada1wg42bxe.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jun 2007 16:26:05.0846 (UTC) FILETIME=[0854A360:01C7B4EA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes for crashes/deadlocks as a well as a few
other small, safe fixes:

Jack Morgenstein (1):
      IB/mlx4: Correct max_srq_wr returned from mlx4_ib_query_device()

Michael S. Tsirkin (2):
      IPoIB/cm: Initialize RX before moving QP to RTR
      IPoIB/cm: Fix interoperability when MTU doesn't match

Roland Dreier (2):
      IB/umem: Fix possible hang on process exit
      IPoIB/cm: Remove dead definition of struct ipoib_cm_id

 drivers/infiniband/core/umem.c          |   16 ++++++-----
 drivers/infiniband/hw/mlx4/main.c       |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   42 ++++++++++++++----------------
 3 files changed, 30 insertions(+), 30 deletions(-)


diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index b4aec51..d40652a 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -225,13 +225,15 @@ void ib_umem_release(struct ib_umem *umem)
 	 * up here and not be able to take the mmap_sem.  In that case
 	 * we defer the vm_locked accounting to the system workqueue.
 	 */
-	if (context->closing && !down_write_trylock(&mm->mmap_sem)) {
-		INIT_WORK(&umem->work, ib_umem_account);
-		umem->mm   = mm;
-		umem->diff = diff;
-
-		schedule_work(&umem->work);
-		return;
+	if (context->closing) {
+		if (!down_write_trylock(&mm->mmap_sem)) {
+			INIT_WORK(&umem->work, ib_umem_account);
+			umem->mm   = mm;
+			umem->diff = diff;
+
+			schedule_work(&umem->work);
+			return;
+		}
 	} else
 		down_write(&mm->mmap_sem);
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1095c82..c591616 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -120,7 +120,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_qp_init_rd_atom = dev->dev->caps.max_qp_init_rdma;
 	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
 	props->max_srq		   = dev->dev->caps.num_srqs - dev->dev->caps.reserved_srqs;
-	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes;
+	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes - 1;
 	props->max_srq_sge	   = dev->dev->caps.max_srq_sge;
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 076a0bb..5ffc464 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -56,13 +56,6 @@ MODULE_PARM_DESC(cm_data_debug_level,
 #define IPOIB_CM_RX_DELAY       (3 * 256 * HZ)
 #define IPOIB_CM_RX_UPDATE_MASK (0x3)
 
-struct ipoib_cm_id {
-	struct ib_cm_id *id;
-	int flags;
-	u32 remote_qpn;
-	u32 remote_mtu;
-};
-
 static struct ib_qp_attr ipoib_cm_err_attr = {
 	.qp_state = IB_QPS_ERR
 };
@@ -309,6 +302,11 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 		return -ENOMEM;
 	p->dev = dev;
 	p->id = cm_id;
+	cm_id->context = p;
+	p->state = IPOIB_CM_RX_LIVE;
+	p->jiffies = jiffies;
+	INIT_LIST_HEAD(&p->list);
+
 	p->qp = ipoib_cm_create_rx_qp(dev, p);
 	if (IS_ERR(p->qp)) {
 		ret = PTR_ERR(p->qp);
@@ -320,24 +318,24 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 	if (ret)
 		goto err_modify;
 
+	spin_lock_irq(&priv->lock);
+	queue_delayed_work(ipoib_workqueue,
+			   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
+	/* Add this entry to passive ids list head, but do not re-add it
+	 * if IB_EVENT_QP_LAST_WQE_REACHED has moved it to flush list. */
+	p->jiffies = jiffies;
+	if (p->state == IPOIB_CM_RX_LIVE)
+		list_move(&p->list, &priv->cm.passive_ids);
+	spin_unlock_irq(&priv->lock);
+
 	ret = ipoib_cm_send_rep(dev, cm_id, p->qp, &event->param.req_rcvd, psn);
 	if (ret) {
 		ipoib_warn(priv, "failed to send REP: %d\n", ret);
-		goto err_rep;
+		if (ib_modify_qp(p->qp, &ipoib_cm_err_attr, IB_QP_STATE))
+			ipoib_warn(priv, "unable to move qp to error state\n");
 	}
-
-	cm_id->context = p;
-	p->jiffies = jiffies;
-	p->state = IPOIB_CM_RX_LIVE;
-	spin_lock_irq(&priv->lock);
-	if (list_empty(&priv->cm.passive_ids))
-		queue_delayed_work(ipoib_workqueue,
-				   &priv->cm.stale_task, IPOIB_CM_RX_DELAY);
-	list_add(&p->list, &priv->cm.passive_ids);
-	spin_unlock_irq(&priv->lock);
 	return 0;
 
-err_rep:
 err_modify:
 	ib_destroy_qp(p->qp);
 err_qp:
@@ -754,9 +752,9 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 
 	p->mtu = be32_to_cpu(data->mtu);
 
-	if (p->mtu < priv->dev->mtu + IPOIB_ENCAP_LEN) {
-		ipoib_warn(priv, "Rejecting connection: mtu %d < device mtu %d + 4\n",
-			   p->mtu, priv->dev->mtu);
+	if (p->mtu <= IPOIB_ENCAP_LEN) {
+		ipoib_warn(priv, "Rejecting connection: mtu %d <= %d\n",
+			   p->mtu, IPOIB_ENCAP_LEN);
 		return -EINVAL;
 	}
 
