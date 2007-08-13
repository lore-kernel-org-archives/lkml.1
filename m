Return-Path: <linux-kernel-owner+w=401wt.eu-S947059AbXHMQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947059AbXHMQpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943551AbXHMP6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:58:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25564 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942499AbXHMP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:58:14 -0400
X-IronPort-AV: i="4.19,255,1183359600"; 
   d="scan'208"; a="199201933:sNHT72640818"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git for-linus branch
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 13 Aug 2007 08:58:11 -0700
Message-ID: <adabqdba0ks.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Aug 2007 15:58:11.0656 (UTC) FILETIME=[BFEA8480:01C7DDC2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some small fixes for 2.6.23:

Dotan Barak (3):
      IB: Include <linux/list.h> from <rdma/ib_mad.h>
      IB: Include <linux/list.h> and <linux/rwsem.h> from <rdma/ib_verbs.h>
      IB: Move the macro IB_UMEM_MAX_PAGE_CHUNK() to umem.c

Eli Cohen (1):
      mlx4_core: Wait 1 second after reset before accessing device

Hal Rosenstock (3):
      IB/mad: Fix error path if response alloc fails in ib_mad_recv_done_handler()
      IB/mad: Fix memory leak in switch handling in ib_mad_recv_done_handler()
      IB/mad: agent_send_response() should be void

Jack Morgenstein (1):
      IPoIB: Fix leak in ipoib_transport_dev_init() error path

Moni Shoua (1):
      IB/core: Ignore membership bit in ib_find_pkey()

Raghava Kondapalli (1):
      IB/srp: Add OUI for new Cisco targets

Roland Dreier (2):
      IB/sa: Don't need to check for default P_Key twice
      IB/srp: Wrap OUI checking for workarounds in helper functions

Sean Hefty (1):
      IB/mad: Fix address handle leak in mad_rmpp

Steve Wise (1):
      RDMA/cxgb3: Always call low level send function via cxgb3_ofld_send()

Vu Pham (1):
      IB/mlx4: Fix opcode returned in RDMA read completion

 drivers/infiniband/core/agent.c            |   24 +++++++++------------
 drivers/infiniband/core/agent.h            |    6 ++--
 drivers/infiniband/core/device.c           |    2 +-
 drivers/infiniband/core/mad.c              |   25 +++++++++++----------
 drivers/infiniband/core/mad_rmpp.c         |    8 +++---
 drivers/infiniband/core/sa_query.c         |    4 +--
 drivers/infiniband/core/umem.c             |    5 ++++
 drivers/infiniband/hw/cxgb3/iwch_cm.c      |   16 +++++++-------
 drivers/infiniband/hw/mlx4/cq.c            |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    1 +
 drivers/infiniband/ulp/srp/ib_srp.c        |   31 +++++++++++++++++++--------
 drivers/net/mlx4/reset.c                   |    3 ++
 include/rdma/ib_mad.h                      |    2 +
 include/rdma/ib_verbs.h                    |    7 +----
 14 files changed, 76 insertions(+), 60 deletions(-)


diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index db2633e..ae7c288 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -78,15 +78,14 @@ ib_get_agent_port(struct ib_device *device, int port_num)
 	return entry;
 }
 
-int agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
-			struct ib_wc *wc, struct ib_device *device,
-			int port_num, int qpn)
+void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
+			 struct ib_wc *wc, struct ib_device *device,
+			 int port_num, int qpn)
 {
 	struct ib_agent_port_private *port_priv;
 	struct ib_mad_agent *agent;
 	struct ib_mad_send_buf *send_buf;
 	struct ib_ah *ah;
-	int ret;
 	struct ib_mad_send_wr_private *mad_send_wr;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH)
@@ -96,23 +95,21 @@ int agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 
 	if (!port_priv) {
 		printk(KERN_ERR SPFX "Unable to find port agent\n");
-		return -ENODEV;
+		return;
 	}
 
 	agent = port_priv->agent[qpn];
 	ah = ib_create_ah_from_wc(agent->qp->pd, wc, grh, port_num);
 	if (IS_ERR(ah)) {
-		ret = PTR_ERR(ah);
-		printk(KERN_ERR SPFX "ib_create_ah_from_wc error:%d\n", ret);
-		return ret;
+		printk(KERN_ERR SPFX "ib_create_ah_from_wc error\n");
+		return;
 	}
 
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
 				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
 				      GFP_KERNEL);
 	if (IS_ERR(send_buf)) {
-		ret = PTR_ERR(send_buf);
-		printk(KERN_ERR SPFX "ib_create_send_mad error:%d\n", ret);
+		printk(KERN_ERR SPFX "ib_create_send_mad error\n");
 		goto err1;
 	}
 
@@ -126,16 +123,15 @@ int agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 		mad_send_wr->send_wr.wr.ud.port_num = port_num;
 	}
 
-	if ((ret = ib_post_send_mad(send_buf, NULL))) {
-		printk(KERN_ERR SPFX "ib_post_send_mad error:%d\n", ret);
+	if (ib_post_send_mad(send_buf, NULL)) {
+		printk(KERN_ERR SPFX "ib_post_send_mad error\n");
 		goto err2;
 	}
-	return 0;
+	return;
 err2:
 	ib_free_send_mad(send_buf);
 err1:
 	ib_destroy_ah(ah);
-	return ret;
 }
 
 static void agent_send_handler(struct ib_mad_agent *mad_agent,
diff --git a/drivers/infiniband/core/agent.h b/drivers/infiniband/core/agent.h
index 86d72fa..fb9ed14 100644
--- a/drivers/infiniband/core/agent.h
+++ b/drivers/infiniband/core/agent.h
@@ -46,8 +46,8 @@ extern int ib_agent_port_open(struct ib_device *device, int port_num);
 
 extern int ib_agent_port_close(struct ib_device *device, int port_num);
 
-extern int agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
-			       struct ib_wc *wc, struct ib_device *device,
-			       int port_num, int qpn);
+extern void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
+				struct ib_wc *wc, struct ib_device *device,
+				int port_num, int qpn);
 
 #endif	/* __AGENT_H_ */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 3ada17c..2506c43 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -702,7 +702,7 @@ int ib_find_pkey(struct ib_device *device,
 		if (ret)
 			return ret;
 
-		if (pkey == tmp_pkey) {
+		if ((pkey & 0x7fff) == (tmp_pkey & 0x7fff)) {
 			*index = i;
 			return 0;
 		}
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index bc547f1..6f42877 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1842,16 +1842,11 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 {
 	struct ib_mad_qp_info *qp_info;
 	struct ib_mad_private_header *mad_priv_hdr;
-	struct ib_mad_private *recv, *response;
+	struct ib_mad_private *recv, *response = NULL;
 	struct ib_mad_list_head *mad_list;
 	struct ib_mad_agent_private *mad_agent;
 	int port_num;
 
-	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
-	if (!response)
-		printk(KERN_ERR PFX "ib_mad_recv_done_handler no memory "
-		       "for response buffer\n");
-
 	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
 	qp_info = mad_list->mad_queue->qp_info;
 	dequeue_mad(mad_list);
@@ -1879,6 +1874,13 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	if (!validate_mad(&recv->mad.mad, qp_info->qp->qp_num))
 		goto out;
 
+	response = kmem_cache_alloc(ib_mad_cache, GFP_KERNEL);
+	if (!response) {
+		printk(KERN_ERR PFX "ib_mad_recv_done_handler no memory "
+		       "for response buffer\n");
+		goto out;
+	}
+
 	if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH)
 		port_num = wc->port_num;
 	else
@@ -1914,12 +1916,11 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 			response->header.recv_wc.recv_buf.mad = &response->mad.mad;
 			response->header.recv_wc.recv_buf.grh = &response->grh;
 
-			if (!agent_send_response(&response->mad.mad,
-						 &response->grh, wc,
-						 port_priv->device,
-						 smi_get_fwd_port(&recv->mad.smp),
-						 qp_info->qp->qp_num))
-				response = NULL;
+			agent_send_response(&response->mad.mad,
+					    &response->grh, wc,
+					    port_priv->device,
+					    smi_get_fwd_port(&recv->mad.smp),
+					    qp_info->qp->qp_num);
 
 			goto out;
 		}
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 3663fd7..d43bc62 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -163,8 +163,10 @@ static struct ib_mad_send_buf *alloc_response_msg(struct ib_mad_agent *agent,
 				 hdr_len, 0, GFP_KERNEL);
 	if (IS_ERR(msg))
 		ib_destroy_ah(ah);
-	else
+	else {
 		msg->ah = ah;
+		msg->context[0] = ah;
+	}
 
 	return msg;
 }
@@ -197,9 +199,7 @@ static void ack_ds_ack(struct ib_mad_agent_private *agent,
 
 void ib_rmpp_send_handler(struct ib_mad_send_wc *mad_send_wc)
 {
-	struct ib_rmpp_mad *rmpp_mad = mad_send_wc->send_buf->mad;
-
-	if (rmpp_mad->rmpp_hdr.rmpp_type != IB_MGMT_RMPP_TYPE_ACK)
+	if (mad_send_wc->send_buf->context[0] == mad_send_wc->send_buf->ah)
 		ib_destroy_ah(mad_send_wc->send_buf->ah);
 	ib_free_send_mad(mad_send_wc->send_buf);
 }
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 20ab6b3..d271bd7 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -385,9 +385,7 @@ static void update_sm_ah(struct work_struct *work)
 
 	new_ah->pkey_index = 0;
 	if (ib_find_pkey(port->agent->device, port->port_num,
-			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index) &&
-	    ib_find_pkey(port->agent->device, port->port_num,
-			 IB_DEFAULT_PKEY_PARTIAL, &new_ah->pkey_index))
+			 IB_DEFAULT_PKEY_FULL, &new_ah->pkey_index))
 		printk(KERN_ERR "Couldn't find index for default PKey\n");
 
 	memset(&ah_attr, 0, sizeof ah_attr);
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 26d0470..664d2fa 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -40,6 +40,11 @@
 
 #include "uverbs.h"
 
+#define IB_UMEM_MAX_PAGE_CHUNK						\
+	((PAGE_SIZE - offsetof(struct ib_umem_chunk, page_list)) /	\
+	 ((void *) &((struct ib_umem_chunk *) 0)->page_list[1] -	\
+	  (void *) &((struct ib_umem_chunk *) 0)->page_list[0]))
+
 static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int dirty)
 {
 	struct ib_umem_chunk *chunk, *tmp;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 9574088..1cdfcd4 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -139,7 +139,7 @@ static void release_tid(struct t3cdev *tdev, u32 hwtid, struct sk_buff *skb)
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_TID_RELEASE, hwtid));
 	skb->priority = CPL_PRIORITY_SETUP;
-	tdev->send(tdev, skb);
+	cxgb3_ofld_send(tdev, skb);
 	return;
 }
 
@@ -161,7 +161,7 @@ int iwch_quiesce_tid(struct iwch_ep *ep)
 	req->val = cpu_to_be64(1 << S_TCB_RX_QUIESCE);
 
 	skb->priority = CPL_PRIORITY_DATA;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -183,7 +183,7 @@ int iwch_resume_tid(struct iwch_ep *ep)
 	req->val = 0;
 
 	skb->priority = CPL_PRIORITY_DATA;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -784,7 +784,7 @@ static int update_rx_credits(struct iwch_ep *ep, u32 credits)
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_RX_DATA_ACK, ep->hwtid));
 	req->credit_dack = htonl(V_RX_CREDITS(credits) | V_RX_FORCE_ACK(1));
 	skb->priority = CPL_PRIORITY_ACK;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return credits;
 }
 
@@ -1152,7 +1152,7 @@ static int listen_start(struct iwch_listen_ep *ep)
 	req->opt1 = htonl(V_CONN_POLICY(CPL_CONN_POLICY_ASK));
 
 	skb->priority = 1;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -1186,7 +1186,7 @@ static int listen_stop(struct iwch_listen_ep *ep)
 	req->cpu_idx = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_CLOSE_LISTSRV_REQ, ep->stid));
 	skb->priority = 1;
-	ep->com.tdev->send(ep->com.tdev, skb);
+	cxgb3_ofld_send(ep->com.tdev, skb);
 	return 0;
 }
 
@@ -1264,7 +1264,7 @@ static void reject_cr(struct t3cdev *tdev, u32 hwtid, __be32 peer_ip,
 		rpl->opt0l_status = htonl(CPL_PASS_OPEN_REJECT);
 		rpl->opt2 = 0;
 		rpl->rsvd = rpl->opt2;
-		tdev->send(tdev, skb);
+		cxgb3_ofld_send(tdev, skb);
 	}
 }
 
@@ -1557,7 +1557,7 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	rpl->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
 	OPCODE_TID(rpl) = htonl(MK_OPCODE_TID(CPL_ABORT_RPL, ep->hwtid));
 	rpl->cmd = CPL_ABORT_NO_RST;
-	ep->com.tdev->send(ep->com.tdev, rpl_skb);
+	cxgb3_ofld_send(ep->com.tdev, rpl_skb);
 	if (state != ABORTING) {
 		state_set(&ep->com, DEAD);
 		release_ep_resources(ep);
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 660b27a..8bf44da 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -389,7 +389,7 @@ static int mlx4_ib_poll_one(struct mlx4_ib_cq *cq,
 			wc->opcode    = IB_WC_SEND;
 			break;
 		case MLX4_OPCODE_RDMA_READ:
-			wc->opcode    = IB_WC_SEND;
+			wc->opcode    = IB_WC_RDMA_READ;
 			wc->byte_len  = be32_to_cpu(cqe->byte_cnt);
 			break;
 		case MLX4_OPCODE_ATOMIC_CS:
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 982eb88..563aeac 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -211,6 +211,7 @@ out_free_cq:
 
 out_free_mr:
 	ib_dereg_mr(priv->mr);
+	ipoib_cm_dev_cleanup(dev);
 
 out_free_pd:
 	ib_dealloc_pd(priv->pd);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f01ca18..f6a0514 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -75,16 +75,12 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
-static const u8 topspin_oui[3] = { 0x00, 0x05, 0xad };
-
 static int mellanox_workarounds = 1;
 
 module_param(mellanox_workarounds, int, 0444);
 MODULE_PARM_DESC(mellanox_workarounds,
 		 "Enable workarounds for Mellanox SRP target bugs if != 0");
 
-static const u8 mellanox_oui[3] = { 0x00, 0x02, 0xc9 };
-
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
@@ -108,6 +104,24 @@ static const char *srp_target_info(struct Scsi_Host *host)
 	return host_to_target(host)->target_name;
 }
 
+static int srp_target_is_topspin(struct srp_target_port *target)
+{
+	static const u8 topspin_oui[3] = { 0x00, 0x05, 0xad };
+	static const u8 cisco_oui[3]   = { 0x00, 0x1b, 0x0d };
+
+	return topspin_workarounds &&
+		(!memcmp(&target->ioc_guid, topspin_oui, sizeof topspin_oui) ||
+		 !memcmp(&target->ioc_guid, cisco_oui, sizeof cisco_oui));
+}
+
+static int srp_target_is_mellanox(struct srp_target_port *target)
+{
+	static const u8 mellanox_oui[3] = { 0x00, 0x02, 0xc9 };
+
+	return mellanox_workarounds &&
+		!memcmp(&target->ioc_guid, mellanox_oui, sizeof mellanox_oui);
+}
+
 static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
 				   gfp_t gfp_mask,
 				   enum dma_data_direction direction)
@@ -360,7 +374,7 @@ static int srp_send_req(struct srp_target_port *target)
 	 * zero out the first 8 bytes of our initiator port ID and set
 	 * the second 8 bytes to the local node GUID.
 	 */
-	if (topspin_workarounds && !memcmp(&target->ioc_guid, topspin_oui, 3)) {
+	if (srp_target_is_topspin(target)) {
 		printk(KERN_DEBUG PFX "Topspin/Cisco initiator port ID workaround "
 		       "activated for target GUID %016llx\n",
 		       (unsigned long long) be64_to_cpu(target->ioc_guid));
@@ -585,8 +599,8 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 	if (!dev->fmr_pool)
 		return -ENODEV;
 
-	if ((ib_sg_dma_address(ibdev, &scat[0]) & ~dev->fmr_page_mask) &&
-	    mellanox_workarounds && !memcmp(&target->ioc_guid, mellanox_oui, 3))
+	if (srp_target_is_mellanox(target) &&
+	    (ib_sg_dma_address(ibdev, &scat[0]) & ~dev->fmr_page_mask))
 		return -EINVAL;
 
 	len = page_cnt = 0;
@@ -1087,8 +1101,7 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 		break;
 
 	case IB_CM_REJ_PORT_REDIRECT:
-		if (topspin_workarounds &&
-		    !memcmp(&target->ioc_guid, topspin_oui, 3)) {
+		if (srp_target_is_topspin(target)) {
 			/*
 			 * Topspin/Cisco SRP gateways incorrectly send
 			 * reject reason code 25 when they mean 24
diff --git a/drivers/net/mlx4/reset.c b/drivers/net/mlx4/reset.c
index e4dfd4b..e199715 100644
--- a/drivers/net/mlx4/reset.c
+++ b/drivers/net/mlx4/reset.c
@@ -119,6 +119,9 @@ int mlx4_reset(struct mlx4_dev *dev)
 	writel(MLX4_RESET_VALUE, reset + MLX4_RESET_OFFSET);
 	iounmap(reset);
 
+	/* Docs say to wait one second before accessing device */
+	msleep(1000);
+
 	end = jiffies + MLX4_RESET_TIMEOUT_JIFFIES;
 	do {
 		if (!pci_read_config_word(dev->pdev, PCI_VENDOR_ID, &vendor) &&
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 30712dd..8ec3799 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -39,6 +39,8 @@
 #if !defined( IB_MAD_H )
 #define IB_MAD_H
 
+#include <linux/list.h>
+
 #include <rdma/ib_verbs.h>
 
 /* Management base version */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0627a6a..4bea182 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -46,6 +46,8 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/rwsem.h>
 
 #include <asm/atomic.h>
 #include <asm/scatterlist.h>
@@ -731,11 +733,6 @@ struct ib_udata {
 	size_t       outlen;
 };
 
-#define IB_UMEM_MAX_PAGE_CHUNK						\
-	((PAGE_SIZE - offsetof(struct ib_umem_chunk, page_list)) /	\
-	 ((void *) &((struct ib_umem_chunk *) 0)->page_list[1] -	\
-	  (void *) &((struct ib_umem_chunk *) 0)->page_list[0]))
-
 struct ib_pd {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
