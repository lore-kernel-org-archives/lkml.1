Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZAPAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZAPAcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZAPAcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:32:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:27652 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZAPAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qn4JZ7AueC68mx39/fbUowAJUp6gbWqmlPuzz0CMuqxMptr3Ty0BbvwlinYX8BaAJK
         /mviBhcLYFfIdLfUvBh6oIU0pxAYsZkO/D29LO52ydkEpMawpSrOVeBRgIplSN6x8qI2
         Z8xVl8pBZmJ5uQZ+njxW7DMAC86WOSHd8Tedg=
Subject: [PATCH] infiniband: remove __constant_{endian} uses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 16:32:00 -0800
Message-Id: <1232065920.11986.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base versions handle constant folding just fine, use them
directly.  The replacements are OK in the include/ files as
they are not exported to userspace so we don't need the __ prefixed
versions.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Roland, the necessary byteorder rework is now in -linus mainline
and all arches have moved over, I'm starting to remove the uses
of the __constant_* helpers now that they are equivalent.

If you'd like a more broken-up series, just ask.

 drivers/infiniband/core/cm.c                  |   15 ++--
 drivers/infiniband/core/cm_msgs.h             |   22 +++---
 drivers/infiniband/core/mad_rmpp.c            |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c         |    4 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c         |    8 +-
 drivers/infiniband/hw/ipath/ipath_eeprom.c    |    4 +-
 drivers/infiniband/hw/ipath/ipath_mad.c       |   95 ++++++++++++-------------
 drivers/infiniband/hw/ipath/ipath_rc.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c      |    4 +-
 drivers/infiniband/hw/ipath/ipath_uc.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_ud.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    6 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c     |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h     |   10 ++--
 drivers/infiniband/hw/mlx4/qp.c               |   22 +++---
 include/rdma/ib_cm.h                          |   12 ++--
 include/rdma/ib_mad.h                         |    2 +-
 include/rdma/ib_smi.h                         |   34 +++++-----
 18 files changed, 124 insertions(+), 126 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f1e82a9..5130fc5 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -927,8 +927,7 @@ int ib_cm_listen(struct ib_cm_id *cm_id, __be64 service_id, __be64 service_mask,
 	unsigned long flags;
 	int ret = 0;
 
-	service_mask = service_mask ? service_mask :
-		       __constant_cpu_to_be64(~0ULL);
+	service_mask = service_mask ? service_mask : ~cpu_to_be64(0);
 	service_id &= service_mask;
 	if ((service_id & IB_SERVICE_ID_AGN_MASK) == IB_CM_ASSIGN_SERVICE_ID &&
 	    (service_id != IB_CM_ASSIGN_SERVICE_ID))
@@ -954,7 +953,7 @@ int ib_cm_listen(struct ib_cm_id *cm_id, __be64 service_id, __be64 service_mask,
 	spin_lock_irqsave(&cm.lock, flags);
 	if (service_id == IB_CM_ASSIGN_SERVICE_ID) {
 		cm_id->service_id = cpu_to_be64(cm.listen_service_id++);
-		cm_id->service_mask = __constant_cpu_to_be64(~0ULL);
+		cm_id->service_mask = ~cpu_to_be64(0);
 	} else {
 		cm_id->service_id = service_id;
 		cm_id->service_mask = service_mask;
@@ -1134,7 +1133,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 			goto error1;
 	}
 	cm_id->service_id = param->service_id;
-	cm_id->service_mask = __constant_cpu_to_be64(~0ULL);
+	cm_id->service_mask = ~cpu_to_be64(0);
 	cm_id_priv->timeout_ms = cm_convert_to_ms(
 				    param->primary_path->packet_life_time) * 2 +
 				 cm_convert_to_ms(
@@ -1545,7 +1544,7 @@ static int cm_req_handler(struct cm_work *work)
 	cm_id_priv->id.cm_handler = listen_cm_id_priv->id.cm_handler;
 	cm_id_priv->id.context = listen_cm_id_priv->id.context;
 	cm_id_priv->id.service_id = req_msg->service_id;
-	cm_id_priv->id.service_mask = __constant_cpu_to_be64(~0ULL);
+	cm_id_priv->id.service_mask = ~cpu_to_be64(0);
 
 	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
@@ -2898,7 +2897,7 @@ int ib_send_cm_sidr_req(struct ib_cm_id *cm_id,
 		goto out;
 
 	cm_id->service_id = param->service_id;
-	cm_id->service_mask = __constant_cpu_to_be64(~0ULL);
+	cm_id->service_mask = ~cpu_to_be64(0);
 	cm_id_priv->timeout_ms = param->timeout_ms;
 	cm_id_priv->max_cm_retries = param->max_cm_retries;
 	ret = cm_alloc_msg(cm_id_priv, &msg);
@@ -2992,7 +2991,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
 	cm_id_priv->id.context = cur_cm_id_priv->id.context;
 	cm_id_priv->id.service_id = sidr_req_msg->service_id;
-	cm_id_priv->id.service_mask = __constant_cpu_to_be64(~0ULL);
+	cm_id_priv->id.service_mask = ~cpu_to_be64(0);
 
 	cm_format_sidr_req_event(work, &cur_cm_id_priv->id);
 	cm_process_work(cm_id_priv, work);
@@ -3789,7 +3788,7 @@ static int __init ib_cm_init(void)
 	rwlock_init(&cm.device_lock);
 	spin_lock_init(&cm.lock);
 	cm.listen_service_table = RB_ROOT;
-	cm.listen_service_id = __constant_be64_to_cpu(IB_CM_ASSIGN_SERVICE_ID);
+	cm.listen_service_id = be64_to_cpu(IB_CM_ASSIGN_SERVICE_ID);
 	cm.remote_id_table = RB_ROOT;
 	cm.remote_qp_table = RB_ROOT;
 	cm.remote_sidr_table = RB_ROOT;
diff --git a/drivers/infiniband/core/cm_msgs.h b/drivers/infiniband/core/cm_msgs.h
index aec9c7a..7e63c08 100644
--- a/drivers/infiniband/core/cm_msgs.h
+++ b/drivers/infiniband/core/cm_msgs.h
@@ -44,17 +44,17 @@
 
 #define IB_CM_CLASS_VERSION	2 /* IB specification 1.2 */
 
-#define CM_REQ_ATTR_ID	    __constant_htons(0x0010)
-#define CM_MRA_ATTR_ID	    __constant_htons(0x0011)
-#define CM_REJ_ATTR_ID	    __constant_htons(0x0012)
-#define CM_REP_ATTR_ID	    __constant_htons(0x0013)
-#define CM_RTU_ATTR_ID	    __constant_htons(0x0014)
-#define CM_DREQ_ATTR_ID	    __constant_htons(0x0015)
-#define CM_DREP_ATTR_ID	    __constant_htons(0x0016)
-#define CM_SIDR_REQ_ATTR_ID __constant_htons(0x0017)
-#define CM_SIDR_REP_ATTR_ID __constant_htons(0x0018)
-#define CM_LAP_ATTR_ID      __constant_htons(0x0019)
-#define CM_APR_ATTR_ID      __constant_htons(0x001A)
+#define CM_REQ_ATTR_ID		cpu_to_be16(0x0010)
+#define CM_MRA_ATTR_ID		cpu_to_be16(0x0011)
+#define CM_REJ_ATTR_ID		cpu_to_be16(0x0012)
+#define CM_REP_ATTR_ID		cpu_to_be16(0x0013)
+#define CM_RTU_ATTR_ID		cpu_to_be16(0x0014)
+#define CM_DREQ_ATTR_ID		cpu_to_be16(0x0015)
+#define CM_DREP_ATTR_ID		cpu_to_be16(0x0016)
+#define CM_SIDR_REQ_ATTR_ID	cpu_to_be16(0x0017)
+#define CM_SIDR_REP_ATTR_ID	cpu_to_be16(0x0018)
+#define CM_LAP_ATTR_ID		cpu_to_be16(0x0019)
+#define CM_APR_ATTR_ID		cpu_to_be16(0x001A)
 
 enum cm_msg_sequence {
 	CM_MSG_SEQUENCE_REQ,
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 3af2b84..57a3c6f 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -735,7 +735,7 @@ process_rmpp_data(struct ib_mad_agent_private *agent,
 		goto bad;
 	}
 
-	if (rmpp_hdr->seg_num == __constant_htonl(1)) {
+	if (rmpp_hdr->seg_num == cpu_to_be32(1)) {
 		if (!(ib_get_rmpp_flags(rmpp_hdr) & IB_MGMT_RMPP_FLAG_FIRST)) {
 			rmpp_status = IB_MGMT_RMPP_STATUS_BAD_SEG;
 			goto bad;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 19661b2..48e2b0b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -99,8 +99,8 @@ static int build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
 	if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM) {
 		plen = 4;
 		wqe->write.sgl[0].stag = wr->ex.imm_data;
-		wqe->write.sgl[0].len = __constant_cpu_to_be32(0);
-		wqe->write.num_sgle = __constant_cpu_to_be32(0);
+		wqe->write.sgl[0].len = cpu_to_be32(0);
+		wqe->write.num_sgle = cpu_to_be32(0);
 		*flit_cnt = 6;
 	} else {
 		plen = 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index 706d97a..a9ae7b8 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -46,11 +46,11 @@
 #include "ehca_iverbs.h"
 #include "hcp_if.h"
 
-#define IB_MAD_STATUS_REDIRECT		__constant_htons(0x0002)
-#define IB_MAD_STATUS_UNSUP_VERSION	__constant_htons(0x0004)
-#define IB_MAD_STATUS_UNSUP_METHOD	__constant_htons(0x0008)
+#define IB_MAD_STATUS_REDIRECT		cpu_to_be16(0x0002)
+#define IB_MAD_STATUS_UNSUP_VERSION	cpu_to_be16(0x0004)
+#define IB_MAD_STATUS_UNSUP_METHOD	cpu_to_be16(0x0008)
 
-#define IB_PMA_CLASS_PORT_INFO		__constant_htons(0x0001)
+#define IB_PMA_CLASS_PORT_INFO		cpu_to_be16(0x0001)
 
 /**
  * ehca_define_sqp - Defines special queue pair 1 (GSI QP). When special queue
diff --git a/drivers/infiniband/hw/ipath/ipath_eeprom.c b/drivers/infiniband/hw/ipath/ipath_eeprom.c
index dc37277..fc71819 100644
--- a/drivers/infiniband/hw/ipath/ipath_eeprom.c
+++ b/drivers/infiniband/hw/ipath/ipath_eeprom.c
@@ -772,8 +772,8 @@ void ipath_get_eeprom_info(struct ipath_devdata *dd)
 			 "0x%x, not 0x%x\n", csum, ifp->if_csum);
 		goto done;
 	}
-	if (*(__be64 *) ifp->if_guid == 0ULL ||
-	    *(__be64 *) ifp->if_guid == __constant_cpu_to_be64(-1LL)) {
+	if (*(__be64 *) ifp->if_guid == cpu_to_be64(0) ||
+	    *(__be64 *) ifp->if_guid == ~cpu_to_be64(0)) {
 		ipath_dev_err(dd, "Invalid GUID %llx from flash; "
 			      "ignoring\n",
 			      *(unsigned long long *) ifp->if_guid);
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index 17a1231..16a702d 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -37,10 +37,10 @@
 #include "ipath_verbs.h"
 #include "ipath_common.h"
 
-#define IB_SMP_UNSUP_VERSION	__constant_htons(0x0004)
-#define IB_SMP_UNSUP_METHOD	__constant_htons(0x0008)
-#define IB_SMP_UNSUP_METH_ATTR	__constant_htons(0x000C)
-#define IB_SMP_INVALID_FIELD	__constant_htons(0x001C)
+#define IB_SMP_UNSUP_VERSION	cpu_to_be16(0x0004)
+#define IB_SMP_UNSUP_METHOD	cpu_to_be16(0x0008)
+#define IB_SMP_UNSUP_METH_ATTR	cpu_to_be16(0x000C)
+#define IB_SMP_INVALID_FIELD	cpu_to_be16(0x001C)
 
 static int reply(struct ib_smp *smp)
 {
@@ -789,12 +789,12 @@ static int recv_subn_set_pkeytable(struct ib_smp *smp,
 	return recv_subn_get_pkeytable(smp, ibdev);
 }
 
-#define IB_PMA_CLASS_PORT_INFO		__constant_htons(0x0001)
-#define IB_PMA_PORT_SAMPLES_CONTROL	__constant_htons(0x0010)
-#define IB_PMA_PORT_SAMPLES_RESULT	__constant_htons(0x0011)
-#define IB_PMA_PORT_COUNTERS		__constant_htons(0x0012)
-#define IB_PMA_PORT_COUNTERS_EXT	__constant_htons(0x001D)
-#define IB_PMA_PORT_SAMPLES_RESULT_EXT	__constant_htons(0x001E)
+#define IB_PMA_CLASS_PORT_INFO		cpu_to_be16(0x0001)
+#define IB_PMA_PORT_SAMPLES_CONTROL	cpu_to_be16(0x0010)
+#define IB_PMA_PORT_SAMPLES_RESULT	cpu_to_be16(0x0011)
+#define IB_PMA_PORT_COUNTERS		cpu_to_be16(0x0012)
+#define IB_PMA_PORT_COUNTERS_EXT	cpu_to_be16(0x001D)
+#define IB_PMA_PORT_SAMPLES_RESULT_EXT	cpu_to_be16(0x001E)
 
 struct ib_perf {
 	u8 base_version;
@@ -884,19 +884,19 @@ struct ib_pma_portcounters {
 	__be32 port_rcv_packets;
 } __attribute__ ((packed));
 
-#define IB_PMA_SEL_SYMBOL_ERROR			__constant_htons(0x0001)
-#define IB_PMA_SEL_LINK_ERROR_RECOVERY		__constant_htons(0x0002)
-#define IB_PMA_SEL_LINK_DOWNED			__constant_htons(0x0004)
-#define IB_PMA_SEL_PORT_RCV_ERRORS		__constant_htons(0x0008)
-#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS	__constant_htons(0x0010)
-#define IB_PMA_SEL_PORT_XMIT_DISCARDS		__constant_htons(0x0040)
-#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS	__constant_htons(0x0200)
-#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS	__constant_htons(0x0400)
-#define IB_PMA_SEL_PORT_VL15_DROPPED		__constant_htons(0x0800)
-#define IB_PMA_SEL_PORT_XMIT_DATA		__constant_htons(0x1000)
-#define IB_PMA_SEL_PORT_RCV_DATA		__constant_htons(0x2000)
-#define IB_PMA_SEL_PORT_XMIT_PACKETS		__constant_htons(0x4000)
-#define IB_PMA_SEL_PORT_RCV_PACKETS		__constant_htons(0x8000)
+#define IB_PMA_SEL_SYMBOL_ERROR			cpu_to_be16(0x0001)
+#define IB_PMA_SEL_LINK_ERROR_RECOVERY		cpu_to_be16(0x0002)
+#define IB_PMA_SEL_LINK_DOWNED			cpu_to_be16(0x0004)
+#define IB_PMA_SEL_PORT_RCV_ERRORS		cpu_to_be16(0x0008)
+#define IB_PMA_SEL_PORT_RCV_REMPHYS_ERRORS	cpu_to_be16(0x0010)
+#define IB_PMA_SEL_PORT_XMIT_DISCARDS		cpu_to_be16(0x0040)
+#define IB_PMA_SEL_LOCAL_LINK_INTEGRITY_ERRORS	cpu_to_be16(0x0200)
+#define IB_PMA_SEL_EXCESSIVE_BUFFER_OVERRUNS	cpu_to_be16(0x0400)
+#define IB_PMA_SEL_PORT_VL15_DROPPED		cpu_to_be16(0x0800)
+#define IB_PMA_SEL_PORT_XMIT_DATA		cpu_to_be16(0x1000)
+#define IB_PMA_SEL_PORT_RCV_DATA		cpu_to_be16(0x2000)
+#define IB_PMA_SEL_PORT_XMIT_PACKETS		cpu_to_be16(0x4000)
+#define IB_PMA_SEL_PORT_RCV_PACKETS		cpu_to_be16(0x8000)
 
 struct ib_pma_portcounters_ext {
 	u8 reserved;
@@ -913,14 +913,14 @@ struct ib_pma_portcounters_ext {
 	__be64 port_multicast_rcv_packets;
 } __attribute__ ((packed));
 
-#define IB_PMA_SELX_PORT_XMIT_DATA		__constant_htons(0x0001)
-#define IB_PMA_SELX_PORT_RCV_DATA		__constant_htons(0x0002)
-#define IB_PMA_SELX_PORT_XMIT_PACKETS		__constant_htons(0x0004)
-#define IB_PMA_SELX_PORT_RCV_PACKETS		__constant_htons(0x0008)
-#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS	__constant_htons(0x0010)
-#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS	__constant_htons(0x0020)
-#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS	__constant_htons(0x0040)
-#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS	__constant_htons(0x0080)
+#define IB_PMA_SELX_PORT_XMIT_DATA		cpu_to_be16(0x0001)
+#define IB_PMA_SELX_PORT_RCV_DATA		cpu_to_be16(0x0002)
+#define IB_PMA_SELX_PORT_XMIT_PACKETS		cpu_to_be16(0x0004)
+#define IB_PMA_SELX_PORT_RCV_PACKETS		cpu_to_be16(0x0008)
+#define IB_PMA_SELX_PORT_UNI_XMIT_PACKETS	cpu_to_be16(0x0010)
+#define IB_PMA_SELX_PORT_UNI_RCV_PACKETS	cpu_to_be16(0x0020)
+#define IB_PMA_SELX_PORT_MULTI_XMIT_PACKETS	cpu_to_be16(0x0040)
+#define IB_PMA_SELX_PORT_MULTI_RCV_PACKETS	cpu_to_be16(0x0080)
 
 static int recv_pma_get_classportinfo(struct ib_perf *pmp)
 {
@@ -933,7 +933,7 @@ static int recv_pma_get_classportinfo(struct ib_perf *pmp)
 		pmp->status |= IB_SMP_INVALID_FIELD;
 
 	/* Indicate AllPortSelect is valid (only one port anyway) */
-	p->cap_mask = __constant_cpu_to_be16(1 << 8);
+	p->cap_mask = cpu_to_be16(1 << 8);
 	p->base_version = 1;
 	p->class_version = 1;
 	/*
@@ -951,12 +951,11 @@ static int recv_pma_get_classportinfo(struct ib_perf *pmp)
  * We support 5 counters which only count the mandatory quantities.
  */
 #define COUNTER_MASK(q, n) (q << ((9 - n) * 3))
-#define COUNTER_MASK0_9 \
-	__constant_cpu_to_be32(COUNTER_MASK(1, 0) | \
-			       COUNTER_MASK(1, 1) | \
-			       COUNTER_MASK(1, 2) | \
-			       COUNTER_MASK(1, 3) | \
-			       COUNTER_MASK(1, 4))
+#define COUNTER_MASK0_9 cpu_to_be32(COUNTER_MASK(1, 0) | \
+				    COUNTER_MASK(1, 1) | \
+				    COUNTER_MASK(1, 2) | \
+				    COUNTER_MASK(1, 3) | \
+				    COUNTER_MASK(1, 4))
 
 static int recv_pma_get_portsamplescontrol(struct ib_perf *pmp,
 					   struct ib_device *ibdev, u8 port)
@@ -1137,7 +1136,7 @@ static int recv_pma_get_portsamplesresult_ext(struct ib_perf *pmp,
 		status = dev->pma_sample_status;
 	p->sample_status = cpu_to_be16(status);
 	/* 64 bits */
-	p->extended_width = __constant_cpu_to_be32(0x80000000);
+	p->extended_width = cpu_to_be32(0x80000000);
 	for (i = 0; i < ARRAY_SIZE(dev->pma_counter_select); i++)
 		p->counter[i] = (status != IB_PMA_SAMPLE_STATUS_DONE) ? 0 :
 		    cpu_to_be64(
@@ -1185,7 +1184,7 @@ static int recv_pma_get_portcounters(struct ib_perf *pmp,
 		pmp->status |= IB_SMP_INVALID_FIELD;
 
 	if (cntrs.symbol_error_counter > 0xFFFFUL)
-		p->symbol_error_counter = __constant_cpu_to_be16(0xFFFF);
+		p->symbol_error_counter = cpu_to_be16(0xFFFF);
 	else
 		p->symbol_error_counter =
 			cpu_to_be16((u16)cntrs.symbol_error_counter);
@@ -1199,17 +1198,17 @@ static int recv_pma_get_portcounters(struct ib_perf *pmp,
 	else
 		p->link_downed_counter = (u8)cntrs.link_downed_counter;
 	if (cntrs.port_rcv_errors > 0xFFFFUL)
-		p->port_rcv_errors = __constant_cpu_to_be16(0xFFFF);
+		p->port_rcv_errors = cpu_to_be16(0xFFFF);
 	else
 		p->port_rcv_errors =
 			cpu_to_be16((u16) cntrs.port_rcv_errors);
 	if (cntrs.port_rcv_remphys_errors > 0xFFFFUL)
-		p->port_rcv_remphys_errors = __constant_cpu_to_be16(0xFFFF);
+		p->port_rcv_remphys_errors = cpu_to_be16(0xFFFF);
 	else
 		p->port_rcv_remphys_errors =
 			cpu_to_be16((u16)cntrs.port_rcv_remphys_errors);
 	if (cntrs.port_xmit_discards > 0xFFFFUL)
-		p->port_xmit_discards = __constant_cpu_to_be16(0xFFFF);
+		p->port_xmit_discards = cpu_to_be16(0xFFFF);
 	else
 		p->port_xmit_discards =
 			cpu_to_be16((u16)cntrs.port_xmit_discards);
@@ -1220,24 +1219,24 @@ static int recv_pma_get_portcounters(struct ib_perf *pmp,
 	p->lli_ebor_errors = (cntrs.local_link_integrity_errors << 4) |
 		cntrs.excessive_buffer_overrun_errors;
 	if (cntrs.vl15_dropped > 0xFFFFUL)
-		p->vl15_dropped = __constant_cpu_to_be16(0xFFFF);
+		p->vl15_dropped = cpu_to_be16(0xFFFF);
 	else
 		p->vl15_dropped = cpu_to_be16((u16)cntrs.vl15_dropped);
 	if (cntrs.port_xmit_data > 0xFFFFFFFFUL)
-		p->port_xmit_data = __constant_cpu_to_be32(0xFFFFFFFF);
+		p->port_xmit_data = cpu_to_be32(0xFFFFFFFF);
 	else
 		p->port_xmit_data = cpu_to_be32((u32)cntrs.port_xmit_data);
 	if (cntrs.port_rcv_data > 0xFFFFFFFFUL)
-		p->port_rcv_data = __constant_cpu_to_be32(0xFFFFFFFF);
+		p->port_rcv_data = cpu_to_be32(0xFFFFFFFF);
 	else
 		p->port_rcv_data = cpu_to_be32((u32)cntrs.port_rcv_data);
 	if (cntrs.port_xmit_packets > 0xFFFFFFFFUL)
-		p->port_xmit_packets = __constant_cpu_to_be32(0xFFFFFFFF);
+		p->port_xmit_packets = cpu_to_be32(0xFFFFFFFF);
 	else
 		p->port_xmit_packets =
 			cpu_to_be32((u32)cntrs.port_xmit_packets);
 	if (cntrs.port_rcv_packets > 0xFFFFFFFFUL)
-		p->port_rcv_packets = __constant_cpu_to_be32(0xFFFFFFFF);
+		p->port_rcv_packets = cpu_to_be32(0xFFFFFFFF);
 	else
 		p->port_rcv_packets =
 			cpu_to_be32((u32) cntrs.port_rcv_packets);
diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/infiniband/hw/ipath/ipath_rc.c
index 9170710..79b3dbc 100644
--- a/drivers/infiniband/hw/ipath/ipath_rc.c
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c
@@ -1744,7 +1744,7 @@ void ipath_rc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 		/* Signal completion event if the solicited bit is set. */
 		ipath_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			       (ohdr->bth[0] &
-				__constant_cpu_to_be32(1 << 23)) != 0);
+				cpu_to_be32(1 << 23)) != 0);
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 8e255ad..4b06985 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -781,10 +781,10 @@ retry:
 		descqp = &dd->ipath_sdma_descq[dd->ipath_sdma_descq_cnt].qw[0];
 	descqp -= 2;
 	/* SDmaLastDesc */
-	descqp[0] |= __constant_cpu_to_le64(1ULL << 11);
+	descqp[0] |= cpu_to_le64(1ULL << 11);
 	if (tx->txreq.flags & IPATH_SDMA_TXREQ_F_INTREQ) {
 		/* SDmaIntReq */
-		descqp[0] |= __constant_cpu_to_le64(1ULL << 15);
+		descqp[0] |= cpu_to_le64(1ULL << 15);
 	}
 
 	/* Commit writes to memory and advance the tail on the chip */
diff --git a/drivers/infiniband/hw/ipath/ipath_uc.c b/drivers/infiniband/hw/ipath/ipath_uc.c
index 82cc588..22e6099 100644
--- a/drivers/infiniband/hw/ipath/ipath_uc.c
+++ b/drivers/infiniband/hw/ipath/ipath_uc.c
@@ -419,7 +419,7 @@ void ipath_uc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 		/* Signal completion event if the solicited bit is set. */
 		ipath_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			       (ohdr->bth[0] &
-				__constant_cpu_to_be32(1 << 23)) != 0);
+				cpu_to_be32(1 << 23)) != 0);
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/infiniband/hw/ipath/ipath_ud.c
index 91c74cc..6076cb6 100644
--- a/drivers/infiniband/hw/ipath/ipath_ud.c
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c
@@ -370,7 +370,7 @@ int ipath_make_ud_req(struct ipath_qp *qp)
 	 */
 	ohdr->bth[1] = ah_attr->dlid >= IPATH_MULTICAST_LID_BASE &&
 		ah_attr->dlid != IPATH_PERMISSIVE_LID ?
-		__constant_cpu_to_be32(IPATH_MULTICAST_QPN) :
+		cpu_to_be32(IPATH_MULTICAST_QPN) :
 		cpu_to_be32(wqe->wr.wr.ud.remote_qpn);
 	ohdr->bth[2] = cpu_to_be32(qp->s_next_psn++ & IPATH_PSN_MASK);
 	/*
@@ -573,7 +573,7 @@ void ipath_ud_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 	/* Signal completion event if the solicited bit is set. */
 	ipath_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 		       (ohdr->bth[0] &
-			__constant_cpu_to_be32(1 << 23)) != 0);
+			cpu_to_be32(1 << 23)) != 0);
 
 bail:;
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index 82d9a0b..7bff4b9 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -667,13 +667,13 @@ static inline __le64 ipath_sdma_make_desc0(struct ipath_devdata *dd,
 
 static inline __le64 ipath_sdma_make_first_desc0(__le64 descq)
 {
-	return descq | __constant_cpu_to_le64(1ULL << 12);
+	return descq | cpu_to_le64(1ULL << 12);
 }
 
 static inline __le64 ipath_sdma_make_last_desc0(__le64 descq)
 {
 					      /* last */  /* dma head */
-	return descq | __constant_cpu_to_le64(1ULL << 11 | 1ULL << 13);
+	return descq | cpu_to_le64(1ULL << 11 | 1ULL << 13);
 }
 
 static inline __le64 ipath_sdma_make_desc1(u64 addr)
@@ -763,7 +763,7 @@ static int ipath_user_sdma_push_pkts(struct ipath_devdata *dd,
 		if (ofs >= IPATH_SMALLBUF_DWORDS) {
 			for (i = 0; i < pkt->naddr; i++) {
 				dd->ipath_sdma_descq[dtail].qw[0] |=
-					__constant_cpu_to_le64(1ULL << 14);
+					cpu_to_le64(1ULL << 14);
 				if (++dtail == dd->ipath_sdma_descq_cnt)
 					dtail = 0;
 			}
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index cdf0e6a..9289ab4 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1585,7 +1585,7 @@ static int ipath_query_port(struct ib_device *ibdev,
 	u64 ibcstat;
 
 	memset(props, 0, sizeof(*props));
-	props->lid = lid ? lid : __constant_be16_to_cpu(IB_LID_PERMISSIVE);
+	props->lid = lid ? lid : be16_to_cpu(IB_LID_PERMISSIVE);
 	props->lmc = dd->ipath_lmc;
 	props->sm_lid = dev->sm_lid;
 	props->sm_sl = dev->sm_sl;
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index 11e3f61..ae6cff4 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -86,11 +86,11 @@
 #define IB_PMA_SAMPLE_STATUS_RUNNING	0x02
 
 /* Mandatory IB performance counter select values. */
-#define IB_PMA_PORT_XMIT_DATA	__constant_htons(0x0001)
-#define IB_PMA_PORT_RCV_DATA	__constant_htons(0x0002)
-#define IB_PMA_PORT_XMIT_PKTS	__constant_htons(0x0003)
-#define IB_PMA_PORT_RCV_PKTS	__constant_htons(0x0004)
-#define IB_PMA_PORT_XMIT_WAIT	__constant_htons(0x0005)
+#define IB_PMA_PORT_XMIT_DATA	cpu_to_be16(0x0001)
+#define IB_PMA_PORT_RCV_DATA	cpu_to_be16(0x0002)
+#define IB_PMA_PORT_XMIT_PKTS	cpu_to_be16(0x0003)
+#define IB_PMA_PORT_RCV_PKTS	cpu_to_be16(0x0004)
+#define IB_PMA_PORT_XMIT_WAIT	cpu_to_be16(0x0005)
 
 struct ib_reth {
 	__be64 vaddr;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 39167a7..2ac0052 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -71,17 +71,17 @@ enum {
 };
 
 static const __be32 mlx4_ib_opcode[] = {
-	[IB_WR_SEND]			= __constant_cpu_to_be32(MLX4_OPCODE_SEND),
-	[IB_WR_LSO]			= __constant_cpu_to_be32(MLX4_OPCODE_LSO),
-	[IB_WR_SEND_WITH_IMM]		= __constant_cpu_to_be32(MLX4_OPCODE_SEND_IMM),
-	[IB_WR_RDMA_WRITE]		= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_WRITE),
-	[IB_WR_RDMA_WRITE_WITH_IMM]	= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_WRITE_IMM),
-	[IB_WR_RDMA_READ]		= __constant_cpu_to_be32(MLX4_OPCODE_RDMA_READ),
-	[IB_WR_ATOMIC_CMP_AND_SWP]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_CS),
-	[IB_WR_ATOMIC_FETCH_AND_ADD]	= __constant_cpu_to_be32(MLX4_OPCODE_ATOMIC_FA),
-	[IB_WR_SEND_WITH_INV]		= __constant_cpu_to_be32(MLX4_OPCODE_SEND_INVAL),
-	[IB_WR_LOCAL_INV]		= __constant_cpu_to_be32(MLX4_OPCODE_LOCAL_INVAL),
-	[IB_WR_FAST_REG_MR]		= __constant_cpu_to_be32(MLX4_OPCODE_FMR),
+	[IB_WR_SEND]			= cpu_to_be32(MLX4_OPCODE_SEND),
+	[IB_WR_LSO]			= cpu_to_be32(MLX4_OPCODE_LSO),
+	[IB_WR_SEND_WITH_IMM]		= cpu_to_be32(MLX4_OPCODE_SEND_IMM),
+	[IB_WR_RDMA_WRITE]		= cpu_to_be32(MLX4_OPCODE_RDMA_WRITE),
+	[IB_WR_RDMA_WRITE_WITH_IMM]	= cpu_to_be32(MLX4_OPCODE_RDMA_WRITE_IMM),
+	[IB_WR_RDMA_READ]		= cpu_to_be32(MLX4_OPCODE_RDMA_READ),
+	[IB_WR_ATOMIC_CMP_AND_SWP]	= cpu_to_be32(MLX4_OPCODE_ATOMIC_CS),
+	[IB_WR_ATOMIC_FETCH_AND_ADD]	= cpu_to_be32(MLX4_OPCODE_ATOMIC_FA),
+	[IB_WR_SEND_WITH_INV]		= cpu_to_be32(MLX4_OPCODE_SEND_INVAL),
+	[IB_WR_LOCAL_INV]		= cpu_to_be32(MLX4_OPCODE_LOCAL_INVAL),
+	[IB_WR_FAST_REG_MR]		= cpu_to_be32(MLX4_OPCODE_FMR),
 };
 
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index ec7c6d9..9388583 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -314,12 +314,12 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
  */
 void ib_destroy_cm_id(struct ib_cm_id *cm_id);
 
-#define IB_SERVICE_ID_AGN_MASK	__constant_cpu_to_be64(0xFF00000000000000ULL)
-#define IB_CM_ASSIGN_SERVICE_ID __constant_cpu_to_be64(0x0200000000000000ULL)
-#define IB_CMA_SERVICE_ID	__constant_cpu_to_be64(0x0000000001000000ULL)
-#define IB_CMA_SERVICE_ID_MASK	__constant_cpu_to_be64(0xFFFFFFFFFF000000ULL)
-#define IB_SDP_SERVICE_ID	__constant_cpu_to_be64(0x0000000000010000ULL)
-#define IB_SDP_SERVICE_ID_MASK	__constant_cpu_to_be64(0xFFFFFFFFFFFF0000ULL)
+#define IB_SERVICE_ID_AGN_MASK	cpu_to_be64(0xFF00000000000000ULL)
+#define IB_CM_ASSIGN_SERVICE_ID	cpu_to_be64(0x0200000000000000ULL)
+#define IB_CMA_SERVICE_ID	cpu_to_be64(0x0000000001000000ULL)
+#define IB_CMA_SERVICE_ID_MASK	cpu_to_be64(0xFFFFFFFFFF000000ULL)
+#define IB_SDP_SERVICE_ID	cpu_to_be64(0x0000000000010000ULL)
+#define IB_SDP_SERVICE_ID_MASK	cpu_to_be64(0xFFFFFFFFFFFF0000ULL)
 
 struct ib_cm_compare_data {
 	u8  data[IB_CM_COMPARE_SIZE];
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 5f6c40f..8cc71a1 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -107,7 +107,7 @@
 #define	IB_MGMT_RMPP_STATUS_ABORT_MAX		127
 
 #define IB_QP0		0
-#define IB_QP1		__constant_htonl(1)
+#define IB_QP1		cpu_to_be32(1)
 #define IB_QP1_QKEY	0x80010000
 #define IB_QP_SET_QKEY	0x80000000
 
diff --git a/include/rdma/ib_smi.h b/include/rdma/ib_smi.h
index aaca087..98b9086 100644
--- a/include/rdma/ib_smi.h
+++ b/include/rdma/ib_smi.h
@@ -63,25 +63,25 @@ struct ib_smp {
 	u8	return_path[IB_SMP_MAX_PATH_HOPS];
 } __attribute__ ((packed));
 
-#define IB_SMP_DIRECTION			__constant_htons(0x8000)
+#define IB_SMP_DIRECTION			cpu_to_be16(0x8000)
 
 /* Subnet management attributes */
-#define IB_SMP_ATTR_NOTICE			__constant_htons(0x0002)
-#define IB_SMP_ATTR_NODE_DESC			__constant_htons(0x0010)
-#define IB_SMP_ATTR_NODE_INFO			__constant_htons(0x0011)
-#define IB_SMP_ATTR_SWITCH_INFO			__constant_htons(0x0012)
-#define IB_SMP_ATTR_GUID_INFO			__constant_htons(0x0014)
-#define IB_SMP_ATTR_PORT_INFO			__constant_htons(0x0015)
-#define IB_SMP_ATTR_PKEY_TABLE			__constant_htons(0x0016)
-#define IB_SMP_ATTR_SL_TO_VL_TABLE		__constant_htons(0x0017)
-#define IB_SMP_ATTR_VL_ARB_TABLE		__constant_htons(0x0018)
-#define IB_SMP_ATTR_LINEAR_FORWARD_TABLE	__constant_htons(0x0019)
-#define IB_SMP_ATTR_RANDOM_FORWARD_TABLE	__constant_htons(0x001A)
-#define IB_SMP_ATTR_MCAST_FORWARD_TABLE		__constant_htons(0x001B)
-#define IB_SMP_ATTR_SM_INFO			__constant_htons(0x0020)
-#define IB_SMP_ATTR_VENDOR_DIAG			__constant_htons(0x0030)
-#define IB_SMP_ATTR_LED_INFO			__constant_htons(0x0031)
-#define IB_SMP_ATTR_VENDOR_MASK			__constant_htons(0xFF00)
+#define IB_SMP_ATTR_NOTICE			cpu_to_be16(0x0002)
+#define IB_SMP_ATTR_NODE_DESC			cpu_to_be16(0x0010)
+#define IB_SMP_ATTR_NODE_INFO			cpu_to_be16(0x0011)
+#define IB_SMP_ATTR_SWITCH_INFO			cpu_to_be16(0x0012)
+#define IB_SMP_ATTR_GUID_INFO			cpu_to_be16(0x0014)
+#define IB_SMP_ATTR_PORT_INFO			cpu_to_be16(0x0015)
+#define IB_SMP_ATTR_PKEY_TABLE			cpu_to_be16(0x0016)
+#define IB_SMP_ATTR_SL_TO_VL_TABLE		cpu_to_be16(0x0017)
+#define IB_SMP_ATTR_VL_ARB_TABLE		cpu_to_be16(0x0018)
+#define IB_SMP_ATTR_LINEAR_FORWARD_TABLE	cpu_to_be16(0x0019)
+#define IB_SMP_ATTR_RANDOM_FORWARD_TABLE	cpu_to_be16(0x001A)
+#define IB_SMP_ATTR_MCAST_FORWARD_TABLE		cpu_to_be16(0x001B)
+#define IB_SMP_ATTR_SM_INFO			cpu_to_be16(0x0020)
+#define IB_SMP_ATTR_VENDOR_DIAG			cpu_to_be16(0x0030)
+#define IB_SMP_ATTR_LED_INFO			cpu_to_be16(0x0031)
+#define IB_SMP_ATTR_VENDOR_MASK			cpu_to_be16(0xFF00)
 
 struct ib_port_info {
 	__be64 mkey;
-- 
1.6.1.249.g455e5



