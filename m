Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYHGVQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYHGVQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYHGVPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:15:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52474 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYHGVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:15:33 -0400
X-IronPort-AV: E=Sophos;i="4.31,322,1215388800"; 
   d="scan'208";a="137173882"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 07 Aug 2008 14:15:26 -0700
Message-ID: <adavdyco7bl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Aug 2008 21:15:27.0144 (UTC) FILETIME=[B6A97A80:01C8F8D2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the following fixes:

Alex Naslednikov (1):
      IB/mlx4: Allow 4K messages for UD QPs

Alexander Beregalov (1):
      IB/ipath: Fix printk format warnings

Julien Brunel (1):
      IB/mad: Test ib_create_send_mad() return with IS_ERR(), not == NULL

Roland Dreier (3):
      IPoIB/cm: Set correct SG list in ipoib_cm_init_rx_wr()
      RDMA/cma: Remove padding arrays by using struct sockaddr_storage
      Merge branches 'cma', 'cxgb3', 'ipath', 'ipoib', 'mad' and 'mlx4' into for-linus

Steve Wise (3):
      RDMA/cxgb3: Fix QP capabilities
      RDMA/cxgb3: Fix up MW access rights
      RDMA/cxgb3: Fix deadlock initializing iw_cxgb3 device

Vegard Nossum (1):
      IB/ipath: Use unsigned long for irq flags

Yevgeny Petrilin (1):
      mlx4_core: Add ethernet fields to CQE struct

 drivers/infiniband/core/cma.c               |   37 +++++++++++++--------------
 drivers/infiniband/core/mad_rmpp.c          |    2 +-
 drivers/infiniband/core/ucma.c              |   14 ++++------
 drivers/infiniband/hw/cxgb3/cxio_hal.c      |    6 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   28 ++------------------
 drivers/infiniband/hw/cxgb3/iwch_provider.h |    7 +++++
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |   25 ++++++------------
 drivers/infiniband/hw/ipath/ipath_driver.c  |    5 ++-
 drivers/infiniband/hw/ipath/ipath_iba7220.c |    7 +++--
 drivers/infiniband/hw/ipath/ipath_intr.c    |   12 ++++++---
 drivers/infiniband/hw/ipath/ipath_verbs.c   |    6 ++--
 drivers/infiniband/hw/mlx4/cq.c             |   33 +++++++++++------------
 drivers/infiniband/hw/mlx4/qp.c             |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    2 +-
 include/linux/mlx4/cq.h                     |   36 +++++++++++++++++--------
 include/rdma/rdma_cm.h                      |    8 +----
 16 files changed, 108 insertions(+), 122 deletions(-)


diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e980ff3..d951896 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -155,9 +155,7 @@ struct cma_multicast {
 	} multicast;
 	struct list_head	list;
 	void			*context;
-	struct sockaddr		addr;
-	u8			pad[sizeof(struct sockaddr_in6) -
-				    sizeof(struct sockaddr)];
+	struct sockaddr_storage	addr;
 };
 
 struct cma_work {
@@ -786,8 +784,8 @@ static void cma_cancel_operation(struct rdma_id_private *id_priv,
 		cma_cancel_route(id_priv);
 		break;
 	case CMA_LISTEN:
-		if (cma_any_addr(&id_priv->id.route.addr.src_addr) &&
-		    !id_priv->cma_dev)
+		if (cma_any_addr((struct sockaddr *) &id_priv->id.route.addr.src_addr)
+				&& !id_priv->cma_dev)
 			cma_cancel_listens(id_priv);
 		break;
 	default:
@@ -1026,7 +1024,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 		rt->path_rec[1] = *ib_event->param.req_rcvd.alternate_path;
 
 	ib_addr_set_dgid(&rt->addr.dev_addr, &rt->path_rec[0].dgid);
-	ret = rdma_translate_ip(&id->route.addr.src_addr,
+	ret = rdma_translate_ip((struct sockaddr *) &id->route.addr.src_addr,
 				&id->route.addr.dev_addr);
 	if (ret)
 		goto destroy_id;
@@ -1064,7 +1062,7 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 	cma_save_net_info(&id->route.addr, &listen_id->route.addr,
 			  ip_ver, port, src, dst);
 
-	ret = rdma_translate_ip(&id->route.addr.src_addr,
+	ret = rdma_translate_ip((struct sockaddr *) &id->route.addr.src_addr,
 				&id->route.addr.dev_addr);
 	if (ret)
 		goto err;
@@ -1377,7 +1375,7 @@ static int cma_ib_listen(struct rdma_id_private *id_priv)
 	if (IS_ERR(id_priv->cm_id.ib))
 		return PTR_ERR(id_priv->cm_id.ib);
 
-	addr = &id_priv->id.route.addr.src_addr;
+	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
 	svc_id = cma_get_service_id(id_priv->id.ps, addr);
 	if (cma_any_addr(addr))
 		ret = ib_cm_listen(id_priv->cm_id.ib, svc_id, 0, NULL);
@@ -1443,7 +1441,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	dev_id_priv->state = CMA_ADDR_BOUND;
 	memcpy(&id->route.addr.src_addr, &id_priv->id.route.addr.src_addr,
-	       ip_addr_size(&id_priv->id.route.addr.src_addr));
+	       ip_addr_size((struct sockaddr *) &id_priv->id.route.addr.src_addr));
 
 	cma_attach_to_dev(dev_id_priv, cma_dev);
 	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
@@ -1563,13 +1561,14 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(&addr->dev_addr));
 	path_rec.numb_path = 1;
 	path_rec.reversible = 1;
-	path_rec.service_id = cma_get_service_id(id_priv->id.ps, &addr->dst_addr);
+	path_rec.service_id = cma_get_service_id(id_priv->id.ps,
+							(struct sockaddr *) &addr->dst_addr);
 
 	comp_mask = IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
 		    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
 		    IB_SA_PATH_REC_REVERSIBLE | IB_SA_PATH_REC_SERVICE_ID;
 
-	if (addr->src_addr.sa_family == AF_INET) {
+	if (addr->src_addr.ss_family == AF_INET) {
 		path_rec.qos_class = cpu_to_be16((u16) id_priv->tos);
 		comp_mask |= IB_SA_PATH_REC_QOS_CLASS;
 	} else {
@@ -1848,7 +1847,7 @@ static int cma_resolve_loopback(struct rdma_id_private *id_priv)
 	ib_addr_get_sgid(&id_priv->id.route.addr.dev_addr, &gid);
 	ib_addr_set_dgid(&id_priv->id.route.addr.dev_addr, &gid);
 
-	if (cma_zero_addr(&id_priv->id.route.addr.src_addr)) {
+	if (cma_zero_addr((struct sockaddr *) &id_priv->id.route.addr.src_addr)) {
 		src_in = (struct sockaddr_in *)&id_priv->id.route.addr.src_addr;
 		dst_in = (struct sockaddr_in *)&id_priv->id.route.addr.dst_addr;
 		src_in->sin_family = dst_in->sin_family;
@@ -1897,7 +1896,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	if (cma_any_addr(dst_addr))
 		ret = cma_resolve_loopback(id_priv);
 	else
-		ret = rdma_resolve_ip(&addr_client, &id->route.addr.src_addr,
+		ret = rdma_resolve_ip(&addr_client, (struct sockaddr *) &id->route.addr.src_addr,
 				      dst_addr, &id->route.addr.dev_addr,
 				      timeout_ms, addr_handler, id_priv);
 	if (ret)
@@ -2021,11 +2020,11 @@ static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
 	 * We don't support binding to any address if anyone is bound to
 	 * a specific address on the same port.
 	 */
-	if (cma_any_addr(&id_priv->id.route.addr.src_addr))
+	if (cma_any_addr((struct sockaddr *) &id_priv->id.route.addr.src_addr))
 		return -EADDRNOTAVAIL;
 
 	hlist_for_each_entry(cur_id, node, &bind_list->owners, node) {
-		if (cma_any_addr(&cur_id->id.route.addr.src_addr))
+		if (cma_any_addr((struct sockaddr *) &cur_id->id.route.addr.src_addr))
 			return -EADDRNOTAVAIL;
 
 		cur_sin = (struct sockaddr_in *) &cur_id->id.route.addr.src_addr;
@@ -2060,7 +2059,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 	}
 
 	mutex_lock(&lock);
-	if (cma_any_port(&id_priv->id.route.addr.src_addr))
+	if (cma_any_port((struct sockaddr *) &id_priv->id.route.addr.src_addr))
 		ret = cma_alloc_any_port(ps, id_priv);
 	else
 		ret = cma_use_port(ps, id_priv);
@@ -2232,7 +2231,7 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 
 	req.path = route->path_rec;
 	req.service_id = cma_get_service_id(id_priv->id.ps,
-					    &route->addr.dst_addr);
+					    (struct sockaddr *) &route->addr.dst_addr);
 	req.timeout_ms = 1 << (CMA_CM_RESPONSE_TIMEOUT - 8);
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
 
@@ -2283,7 +2282,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 		req.alternate_path = &route->path_rec[1];
 
 	req.service_id = cma_get_service_id(id_priv->id.ps,
-					    &route->addr.dst_addr);
+					    (struct sockaddr *) &route->addr.dst_addr);
 	req.qp_num = id_priv->qp_num;
 	req.qp_type = IB_QPT_RC;
 	req.starting_psn = id_priv->seq_num;
@@ -2667,7 +2666,7 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	if (ret)
 		return ret;
 
-	cma_set_mgid(id_priv, &mc->addr, &rec.mgid);
+	cma_set_mgid(id_priv, (struct sockaddr *) &mc->addr, &rec.mgid);
 	if (id_priv->id.ps == RDMA_PS_UDP)
 		rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
 	ib_addr_get_sgid(dev_addr, &rec.port_gid);
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index d0ef7d6..3af2b84 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -133,7 +133,7 @@ static void ack_recv(struct mad_rmpp_recv *rmpp_recv,
 	msg = ib_create_send_mad(&rmpp_recv->agent->agent, recv_wc->wc->src_qp,
 				 recv_wc->wc->pkey_index, 1, hdr_len,
 				 0, GFP_KERNEL);
-	if (!msg)
+	if (IS_ERR(msg))
 		return;
 
 	format_ack(msg, (struct ib_rmpp_mad *) recv_wc->recv_buf.mad, rmpp_recv);
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b41dd26..3ddacf3 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -81,9 +81,7 @@ struct ucma_multicast {
 
 	u64			uid;
 	struct list_head	list;
-	struct sockaddr		addr;
-	u8			pad[sizeof(struct sockaddr_in6) -
-				    sizeof(struct sockaddr)];
+	struct sockaddr_storage	addr;
 };
 
 struct ucma_event {
@@ -603,11 +601,11 @@ static ssize_t ucma_query_route(struct ucma_file *file,
 		return PTR_ERR(ctx);
 
 	memset(&resp, 0, sizeof resp);
-	addr = &ctx->cm_id->route.addr.src_addr;
+	addr = (struct sockaddr *) &ctx->cm_id->route.addr.src_addr;
 	memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
 				     sizeof(struct sockaddr_in) :
 				     sizeof(struct sockaddr_in6));
-	addr = &ctx->cm_id->route.addr.dst_addr;
+	addr = (struct sockaddr *) &ctx->cm_id->route.addr.dst_addr;
 	memcpy(&resp.dst_addr, addr, addr->sa_family == AF_INET ?
 				     sizeof(struct sockaddr_in) :
 				     sizeof(struct sockaddr_in6));
@@ -913,7 +911,7 @@ static ssize_t ucma_join_multicast(struct ucma_file *file,
 
 	mc->uid = cmd.uid;
 	memcpy(&mc->addr, &cmd.addr, sizeof cmd.addr);
-	ret = rdma_join_multicast(ctx->cm_id, &mc->addr, mc);
+	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr, mc);
 	if (ret)
 		goto err2;
 
@@ -929,7 +927,7 @@ static ssize_t ucma_join_multicast(struct ucma_file *file,
 	return 0;
 
 err3:
-	rdma_leave_multicast(ctx->cm_id, &mc->addr);
+	rdma_leave_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr);
 	ucma_cleanup_mc_events(mc);
 err2:
 	mutex_lock(&mut);
@@ -975,7 +973,7 @@ static ssize_t ucma_leave_multicast(struct ucma_file *file,
 		goto out;
 	}
 
-	rdma_leave_multicast(mc->ctx->cm_id, &mc->addr);
+	rdma_leave_multicast(mc->ctx->cm_id, (struct sockaddr *) &mc->addr);
 	mutex_lock(&mc->ctx->file->mut);
 	ucma_cleanup_mc_events(mc);
 	list_del(&mc->list);
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index f6d5747..4dcf08b 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -725,9 +725,9 @@ static int __cxio_tpt_op(struct cxio_rdev *rdev_p, u32 reset_tpt_entry,
 				V_TPT_STAG_TYPE(type) | V_TPT_PDID(pdid));
 		BUG_ON(page_size >= 28);
 		tpt.flags_pagesize_qpid = cpu_to_be32(V_TPT_PERM(perm) |
-				F_TPT_MW_BIND_ENABLE |
-				V_TPT_ADDR_TYPE((zbva ? TPT_ZBTO : TPT_VATO)) |
-				V_TPT_PAGE_SIZE(page_size));
+			((perm & TPT_MW_BIND) ? F_TPT_MW_BIND_ENABLE : 0) |
+			V_TPT_ADDR_TYPE((zbva ? TPT_ZBTO : TPT_VATO)) |
+			V_TPT_PAGE_SIZE(page_size));
 		tpt.rsvd_pbl_addr = reset_tpt_entry ? 0 :
 				    cpu_to_be32(V_TPT_PBL_ADDR(PBL_OFF(rdev_p, pbl_addr)>>3));
 		tpt.len = cpu_to_be32(len);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b89640a..eb778bf 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1187,28 +1187,6 @@ static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", iwch_dev->rdev.t3cdev_p->type);
 }
 
-static int fw_supports_fastreg(struct iwch_dev *iwch_dev)
-{
-	struct ethtool_drvinfo info;
-	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
-	char *cp, *next;
-	unsigned fw_maj, fw_min;
-
-	rtnl_lock();
-	lldev->ethtool_ops->get_drvinfo(lldev, &info);
-	rtnl_unlock();
-
-	next = info.fw_version+1;
-	cp = strsep(&next, ".");
-	sscanf(cp, "%i", &fw_maj);
-	cp = strsep(&next, ".");
-	sscanf(cp, "%i", &fw_min);
-
-	PDBG("%s maj %u min %u\n", __func__, fw_maj, fw_min);
-
-	return fw_maj > 6 || (fw_maj == 6 && fw_min > 0);
-}
-
 static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct iwch_dev *iwch_dev = container_of(dev, struct iwch_dev,
@@ -1325,12 +1303,12 @@ int iwch_register_device(struct iwch_dev *dev)
 	memset(&dev->ibdev.node_guid, 0, sizeof(dev->ibdev.node_guid));
 	memcpy(&dev->ibdev.node_guid, dev->rdev.t3cdev_p->lldev->dev_addr, 6);
 	dev->ibdev.owner = THIS_MODULE;
-	dev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_WINDOW;
+	dev->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY |
+				IB_DEVICE_MEM_WINDOW |
+				IB_DEVICE_MEM_MGT_EXTENSIONS;
 
 	/* cxgb3 supports STag 0. */
 	dev->ibdev.local_dma_lkey = 0;
-	if (fw_supports_fastreg(dev))
-		dev->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 
 	dev->ibdev.uverbs_cmd_mask =
 	    (1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index f5ceca0..a237d49 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -293,9 +293,16 @@ static inline u32 iwch_ib_to_tpt_access(int acc)
 	return (acc & IB_ACCESS_REMOTE_WRITE ? TPT_REMOTE_WRITE : 0) |
 	       (acc & IB_ACCESS_REMOTE_READ ? TPT_REMOTE_READ : 0) |
 	       (acc & IB_ACCESS_LOCAL_WRITE ? TPT_LOCAL_WRITE : 0) |
+	       (acc & IB_ACCESS_MW_BIND ? TPT_MW_BIND : 0) |
 	       TPT_LOCAL_READ;
 }
 
+static inline u32 iwch_ib_to_tpt_bind_access(int acc)
+{
+	return (acc & IB_ACCESS_REMOTE_WRITE ? TPT_REMOTE_WRITE : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ ? TPT_REMOTE_READ : 0);
+}
+
 enum iwch_mmid_state {
 	IWCH_STAG_STATE_VALID,
 	IWCH_STAG_STATE_INVALID
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 9a3be3a..3e4585c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -565,7 +565,7 @@ int iwch_bind_mw(struct ib_qp *qp,
 	wqe->bind.type = TPT_VATO;
 
 	/* TBD: check perms */
-	wqe->bind.perms = iwch_ib_to_tpt_access(mw_bind->mw_access_flags);
+	wqe->bind.perms = iwch_ib_to_tpt_bind_access(mw_bind->mw_access_flags);
 	wqe->bind.mr_stag = cpu_to_be32(mw_bind->mr->lkey);
 	wqe->bind.mw_stag = cpu_to_be32(mw->rkey);
 	wqe->bind.mw_len = cpu_to_be32(mw_bind->length);
@@ -879,20 +879,13 @@ static int rdma_init(struct iwch_dev *rhp, struct iwch_qp *qhp,
 		(qhp->attr.mpa_attr.xmit_marker_enabled << 1) |
 		(qhp->attr.mpa_attr.crc_enabled << 2);
 
-	/*
-	 * XXX - The IWCM doesn't quite handle getting these
-	 * attrs set before going into RTS.  For now, just turn
-	 * them on always...
-	 */
-#if 0
-	init_attr.qpcaps = qhp->attr.enableRdmaRead |
-		(qhp->attr.enableRdmaWrite << 1) |
-		(qhp->attr.enableBind << 2) |
-		(qhp->attr.enable_stag0_fastreg << 3) |
-		(qhp->attr.enable_stag0_fastreg << 4);
-#else
-	init_attr.qpcaps = 0x1f;
-#endif
+	init_attr.qpcaps = uP_RI_QP_RDMA_READ_ENABLE |
+			   uP_RI_QP_RDMA_WRITE_ENABLE |
+			   uP_RI_QP_BIND_ENABLE;
+	if (!qhp->ibqp.uobject)
+		init_attr.qpcaps |= uP_RI_QP_STAG0_ENABLE |
+				    uP_RI_QP_FAST_REGISTER_ENABLE;
+
 	init_attr.tcp_emss = qhp->ep->emss;
 	init_attr.ord = qhp->attr.max_ord;
 	init_attr.ird = qhp->attr.max_ird;
@@ -900,8 +893,6 @@ static int rdma_init(struct iwch_dev *rhp, struct iwch_qp *qhp,
 	init_attr.qp_dma_size = (1UL << qhp->wq.size_log2);
 	init_attr.rqe_count = iwch_rqes_posted(qhp);
 	init_attr.flags = qhp->attr.mpa_attr.initiator ? MPA_INITIATOR : 0;
-	if (!qhp->ibqp.uobject)
-		init_attr.flags |= PRIV_QP;
 	if (peer2peer) {
 		init_attr.rtr_type = RTR_READ;
 		if (init_attr.ord == 0 && qhp->attr.mpa_attr.initiator)
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index daad09a..ad0aab6 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -1259,7 +1259,7 @@ reloop:
 			 */
 			ipath_cdbg(ERRPKT, "Error Pkt, but no eflags! egrbuf"
 				  " %x, len %x hdrq+%x rhf: %Lx\n",
-				  etail, tlen, l,
+				  etail, tlen, l, (unsigned long long)
 				  le64_to_cpu(*(__le64 *) rhf_addr));
 			if (ipath_debug & __IPATH_ERRPKTDBG) {
 				u32 j, *d, dw = rsize-2;
@@ -1457,7 +1457,8 @@ static void ipath_reset_availshadow(struct ipath_devdata *dd)
 			0xaaaaaaaaaaaaaaaaULL); /* All BUSY bits in qword */
 		if (oldval != dd->ipath_pioavailshadow[i])
 			ipath_dbg("shadow[%d] was %Lx, now %lx\n",
-				i, oldval, dd->ipath_pioavailshadow[i]);
+				i, (unsigned long long) oldval,
+				dd->ipath_pioavailshadow[i]);
 	}
 	spin_unlock_irqrestore(&ipath_pioavail_lock, flags);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index fb70712..85b2cd0 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -1032,7 +1032,7 @@ static int ipath_7220_bringup_serdes(struct ipath_devdata *dd)
 	ipath_cdbg(VERBOSE, "done: xgxs=%llx from %llx\n",
 		   (unsigned long long)
 		   ipath_read_kreg64(dd, dd->ipath_kregs->kr_xgxsconfig),
-		   prev_val);
+		   (unsigned long long) prev_val);
 
 	guid = be64_to_cpu(dd->ipath_guid);
 
@@ -1042,7 +1042,8 @@ static int ipath_7220_bringup_serdes(struct ipath_devdata *dd)
 		ipath_dbg("No GUID for heartbeat, faking %llx\n",
 			(unsigned long long)guid);
 	} else
-		ipath_cdbg(VERBOSE, "Wrote %llX to HRTBT_GUID\n", guid);
+		ipath_cdbg(VERBOSE, "Wrote %llX to HRTBT_GUID\n",
+			(unsigned long long) guid);
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_hrtbt_guid, guid);
 	return ret;
 }
@@ -2505,7 +2506,7 @@ done:
 	if (dd->ipath_flags & IPATH_IB_AUTONEG_INPROG) {
 		ipath_dbg("Did not get to DDR INIT (%x) after %Lu msecs\n",
 			ipath_ib_state(dd, dd->ipath_lastibcstat),
-			jiffies_to_msecs(jiffies)-startms);
+			(unsigned long long) jiffies_to_msecs(jiffies)-startms);
 		dd->ipath_flags &= ~IPATH_IB_AUTONEG_INPROG;
 		if (dd->ipath_autoneg_tries == IPATH_AUTONEG_TRIES) {
 			dd->ipath_flags |= IPATH_IB_AUTONEG_FAILED;
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 26900b3..6c21b4b 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -356,9 +356,10 @@ static void handle_e_ibstatuschanged(struct ipath_devdata *dd,
 			dd->ipath_cregs->cr_iblinkerrrecovcnt);
 		if (linkrecov != dd->ipath_lastlinkrecov) {
 			ipath_dbg("IB linkrecov up %Lx (%s %s) recov %Lu\n",
-				ibcs, ib_linkstate(dd, ibcs),
+				(unsigned long long) ibcs,
+				ib_linkstate(dd, ibcs),
 				ipath_ibcstatus_str[ltstate],
-				linkrecov);
+				(unsigned long long) linkrecov);
 			/* and no more until active again */
 			dd->ipath_lastlinkrecov = 0;
 			ipath_set_linkstate(dd, IPATH_IB_LINKDOWN);
@@ -1118,9 +1119,11 @@ irqreturn_t ipath_intr(int irq, void *data)
 	if (unlikely(istat & ~dd->ipath_i_bitsextant))
 		ipath_dev_err(dd,
 			      "interrupt with unknown interrupts %Lx set\n",
+			      (unsigned long long)
 			      istat & ~dd->ipath_i_bitsextant);
 	else if (istat & ~INFINIPATH_I_ERROR) /* errors do own printing */
-		ipath_cdbg(VERBOSE, "intr stat=0x%Lx\n", istat);
+		ipath_cdbg(VERBOSE, "intr stat=0x%Lx\n",
+			(unsigned long long) istat);
 
 	if (istat & INFINIPATH_I_ERROR) {
 		ipath_stats.sps_errints++;
@@ -1128,7 +1131,8 @@ irqreturn_t ipath_intr(int irq, void *data)
 					  dd->ipath_kregs->kr_errorstatus);
 		if (!estat)
 			dev_info(&dd->pcidev->dev, "error interrupt (%Lx), "
-				 "but no error bits set!\n", istat);
+				 "but no error bits set!\n",
+				 (unsigned long long) istat);
 		else if (estat == -1LL)
 			/*
 			 * should we try clearing all, or hope next read
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 55c7188..b766e40 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1021,7 +1021,7 @@ static void sdma_complete(void *cookie, int status)
 	struct ipath_verbs_txreq *tx = cookie;
 	struct ipath_qp *qp = tx->qp;
 	struct ipath_ibdev *dev = to_idev(qp->ibqp.device);
-	unsigned int flags;
+	unsigned long flags;
 	enum ib_wc_status ibs = status == IPATH_SDMA_TXREQ_S_OK ?
 		IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR;
 
@@ -1051,7 +1051,7 @@ static void sdma_complete(void *cookie, int status)
 
 static void decrement_dma_busy(struct ipath_qp *qp)
 {
-	unsigned int flags;
+	unsigned long flags;
 
 	if (atomic_dec_and_test(&qp->s_dma_busy)) {
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -1221,7 +1221,7 @@ static int ipath_verbs_send_pio(struct ipath_qp *qp,
 	unsigned flush_wc;
 	u32 control;
 	int ret;
-	unsigned int flags;
+	unsigned long flags;
 
 	piobuf = ipath_getpiobuf(dd, plen, NULL);
 	if (unlikely(piobuf == NULL)) {
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index a146457..d0866a3 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -515,17 +515,17 @@ static void mlx4_ib_handle_error_cqe(struct mlx4_err_cqe *cqe,
 	wc->vendor_err = cqe->vendor_err_syndrome;
 }
 
-static int mlx4_ib_ipoib_csum_ok(__be32 status, __be16 checksum)
+static int mlx4_ib_ipoib_csum_ok(__be16 status, __be16 checksum)
 {
-	return ((status & cpu_to_be32(MLX4_CQE_IPOIB_STATUS_IPV4	|
-				      MLX4_CQE_IPOIB_STATUS_IPV4F	|
-				      MLX4_CQE_IPOIB_STATUS_IPV4OPT	|
-				      MLX4_CQE_IPOIB_STATUS_IPV6	|
-				      MLX4_CQE_IPOIB_STATUS_IPOK)) ==
-		cpu_to_be32(MLX4_CQE_IPOIB_STATUS_IPV4	|
-			    MLX4_CQE_IPOIB_STATUS_IPOK))		&&
-		(status & cpu_to_be32(MLX4_CQE_IPOIB_STATUS_UDP	|
-				      MLX4_CQE_IPOIB_STATUS_TCP))	&&
+	return ((status & cpu_to_be16(MLX4_CQE_STATUS_IPV4      |
+				      MLX4_CQE_STATUS_IPV4F     |
+				      MLX4_CQE_STATUS_IPV4OPT   |
+				      MLX4_CQE_STATUS_IPV6      |
+				      MLX4_CQE_STATUS_IPOK)) ==
+		cpu_to_be16(MLX4_CQE_STATUS_IPV4        |
+			    MLX4_CQE_STATUS_IPOK))              &&
+		(status & cpu_to_be16(MLX4_CQE_STATUS_UDP       |
+				      MLX4_CQE_STATUS_TCP))     &&
 		checksum == cpu_to_be16(0xffff);
 }
 
@@ -582,17 +582,17 @@ repoll:
 	}
 
 	if (!*cur_qp ||
-	    (be32_to_cpu(cqe->my_qpn) & 0xffffff) != (*cur_qp)->mqp.qpn) {
+	    (be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) != (*cur_qp)->mqp.qpn) {
 		/*
 		 * We do not have to take the QP table lock here,
 		 * because CQs will be locked while QPs are removed
 		 * from the table.
 		 */
 		mqp = __mlx4_qp_lookup(to_mdev(cq->ibcq.device)->dev,
-				       be32_to_cpu(cqe->my_qpn));
+				       be32_to_cpu(cqe->vlan_my_qpn));
 		if (unlikely(!mqp)) {
 			printk(KERN_WARNING "CQ %06x with entry for unknown QPN %06x\n",
-			       cq->mcq.cqn, be32_to_cpu(cqe->my_qpn) & 0xffffff);
+			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
 			return -EINVAL;
 		}
 
@@ -692,14 +692,13 @@ repoll:
 		}
 
 		wc->slid	   = be16_to_cpu(cqe->rlid);
-		wc->sl		   = cqe->sl >> 4;
+		wc->sl		   = be16_to_cpu(cqe->sl_vid >> 12);
 		g_mlpath_rqpn	   = be32_to_cpu(cqe->g_mlpath_rqpn);
 		wc->src_qp	   = g_mlpath_rqpn & 0xffffff;
 		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
 		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IB_WC_GRH : 0;
 		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) & 0x7f;
-		wc->csum_ok	   = mlx4_ib_ipoib_csum_ok(cqe->ipoib_status,
-							   cqe->checksum);
+		wc->csum_ok	   = mlx4_ib_ipoib_csum_ok(cqe->status, cqe->checksum);
 	}
 
 	return 0;
@@ -767,7 +766,7 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
-		if ((be32_to_cpu(cqe->my_qpn) & 0xffffff) == qpn) {
+		if ((be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_ib_free_srq_wqe(srq, be16_to_cpu(cqe->wqe_index));
 			++nfreed;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index f7bc7dd..f29dbb7 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -902,7 +902,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			context->mtu_msgmax = (IB_MTU_4096 << 5) |
 					      ilog2(dev->dev->caps.max_gso_sz);
 		else
-			context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
+			context->mtu_msgmax = (IB_MTU_4096 << 5) | 12;
 	} else if (attr_mask & IB_QP_PATH_MTU) {
 		if (attr->path_mtu < IB_MTU_256 || attr->path_mtu > IB_MTU_4096) {
 			printk(KERN_ERR "path MTU (%u) is invalid\n",
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 0f2d304..7ebc400 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -337,7 +337,7 @@ static void ipoib_cm_init_rx_wr(struct net_device *dev,
 		sge[i].length = PAGE_SIZE;
 
 	wr->next    = NULL;
-	wr->sg_list = priv->cm.rx_sge;
+	wr->sg_list = sge;
 	wr->num_sge = priv->cm.num_frags;
 }
 
diff --git a/include/linux/mlx4/cq.h b/include/linux/mlx4/cq.h
index 071cf96..6f65b2c 100644
--- a/include/linux/mlx4/cq.h
+++ b/include/linux/mlx4/cq.h
@@ -39,17 +39,18 @@
 #include <linux/mlx4/doorbell.h>
 
 struct mlx4_cqe {
-	__be32			my_qpn;
+	__be32			vlan_my_qpn;
 	__be32			immed_rss_invalid;
 	__be32			g_mlpath_rqpn;
-	u8			sl;
-	u8			reserved1;
+	__be16			sl_vid;
 	__be16			rlid;
-	__be32			ipoib_status;
+	__be16			status;
+	u8			ipv6_ext_mask;
+	u8			badfcs_enc;
 	__be32			byte_cnt;
 	__be16			wqe_index;
 	__be16			checksum;
-	u8			reserved2[3];
+	u8			reserved[3];
 	u8			owner_sr_opcode;
 };
 
@@ -64,6 +65,11 @@ struct mlx4_err_cqe {
 };
 
 enum {
+	MLX4_CQE_VLAN_PRESENT_MASK	= 1 << 29,
+	MLX4_CQE_QPN_MASK		= 0xffffff,
+};
+
+enum {
 	MLX4_CQE_OWNER_MASK	= 0x80,
 	MLX4_CQE_IS_SEND_MASK	= 0x40,
 	MLX4_CQE_OPCODE_MASK	= 0x1f
@@ -86,13 +92,19 @@ enum {
 };
 
 enum {
-	MLX4_CQE_IPOIB_STATUS_IPV4			= 1 << 22,
-	MLX4_CQE_IPOIB_STATUS_IPV4F			= 1 << 23,
-	MLX4_CQE_IPOIB_STATUS_IPV6			= 1 << 24,
-	MLX4_CQE_IPOIB_STATUS_IPV4OPT			= 1 << 25,
-	MLX4_CQE_IPOIB_STATUS_TCP			= 1 << 26,
-	MLX4_CQE_IPOIB_STATUS_UDP			= 1 << 27,
-	MLX4_CQE_IPOIB_STATUS_IPOK			= 1 << 28,
+	MLX4_CQE_STATUS_IPV4		= 1 << 6,
+	MLX4_CQE_STATUS_IPV4F		= 1 << 7,
+	MLX4_CQE_STATUS_IPV6		= 1 << 8,
+	MLX4_CQE_STATUS_IPV4OPT		= 1 << 9,
+	MLX4_CQE_STATUS_TCP		= 1 << 10,
+	MLX4_CQE_STATUS_UDP		= 1 << 11,
+	MLX4_CQE_STATUS_IPOK		= 1 << 12,
+};
+
+enum {
+	MLX4_CQE_LLC                     = 1,
+	MLX4_CQE_SNAP                    = 1 << 1,
+	MLX4_CQE_BAD_FCS                 = 1 << 4,
 };
 
 static inline void mlx4_cq_arm(struct mlx4_cq *cq, u32 cmd,
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index df7faf0..c6b2962 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -71,12 +71,8 @@ enum rdma_port_space {
 };
 
 struct rdma_addr {
-	struct sockaddr src_addr;
-	u8		src_pad[sizeof(struct sockaddr_in6) -
-				sizeof(struct sockaddr)];
-	struct sockaddr dst_addr;
-	u8		dst_pad[sizeof(struct sockaddr_in6) -
-				sizeof(struct sockaddr)];
+	struct sockaddr_storage src_addr;
+	struct sockaddr_storage dst_addr;
 	struct rdma_dev_addr dev_addr;
 };
 
