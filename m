Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYKZVN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYKZVN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYKZVM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:12:58 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:2372 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYKZVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=s3URAGfkhST9clvqaXaRDJAyzR3AREeLPk+X0tMPGZxS+M0uFXh2tVTDxIyHtwEGJP
         ykLL8Wp51mc8uOMRYlp7xgmL9c9ucgS0X1aF8UD3aqFIXAWoYB9osKxP5QK5Utb/smTQ
         PmuHrDx7cJizjGQQUWUQD03Uxxm3JuxYyAPHE=
Subject: [PATCH-mm 3/8] misc: remove the few in-kernel uses of
 __constant_{endian}_to_cpu
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:12:51 -0800
Message-Id: <1227733971.5511.125.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base versions handle constant folding just fine.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the byteorder consolidation in -mm.

 drivers/infiniband/core/cm.c              |   15 +++++++--------
 drivers/infiniband/hw/ipath/ipath_verbs.c |    6 +++---
 drivers/usb/gadget/ci13xxx_udc.c          |    2 +-
 3 files changed, 11 insertions(+), 12 deletions(-)

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
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index eabc424..f04d2d5 100644
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
@@ -2020,9 +2020,9 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 
 	spin_lock_init(&idev->qp_table.lock);
 	spin_lock_init(&idev->lk_table.lock);
-	idev->sm_lid = __constant_be16_to_cpu(IB_LID_PERMISSIVE);
+	idev->sm_lid = be16_to_cpu(IB_LID_PERMISSIVE);
 	/* Set the prefix to the default value (see ch. 4.1.1) */
-	idev->gid_prefix = __constant_cpu_to_be64(0xfe80000000000000ULL);
+	idev->gid_prefix = cpu_to_be64(0xfe80000000000000ULL);
 
 	ret = ipath_init_qp_table(idev, ib_ipath_qp_table_size);
 	if (ret)
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index bebf911..91853f8 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -1981,7 +1981,7 @@ static int ep_enable(struct usb_ep *ep,
 	mEp->num  =  desc->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
 	mEp->type =  desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
 
-	mEp->ep.maxpacket = __constant_le16_to_cpu(desc->wMaxPacketSize);
+	mEp->ep.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
 
 	direction = mEp->dir;
 	do {
-- 
1.6.0.4.1044.g77718


