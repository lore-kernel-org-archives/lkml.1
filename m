Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYDTKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYDTKwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbYDTKlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56382 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147AbYDTKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:41:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tony Jones <tonyj@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 34/36] IB: rename "dev" to "srp_dev" in srp_host structure
Date: Sun, 20 Apr 2008 03:46:04 -0700
Message-Id: <1208688366-9252-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sets us up to be able to convert the srp_host to use a struct
device instead of a class_device.

Based on a original patch from Tony Jones, but split up into this piece
by Greg.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Reviewed-by: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   49 ++++++++++++++++++----------------
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +-
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 125765a..99a1106 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -139,8 +139,9 @@ static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
 	if (!iu->buf)
 		goto out_free_iu;
 
-	iu->dma = ib_dma_map_single(host->dev->dev, iu->buf, size, direction);
-	if (ib_dma_mapping_error(host->dev->dev, iu->dma))
+	iu->dma = ib_dma_map_single(host->srp_dev->dev, iu->buf, size,
+				    direction);
+	if (ib_dma_mapping_error(host->srp_dev->dev, iu->dma))
 		goto out_free_buf;
 
 	iu->size      = size;
@@ -161,7 +162,8 @@ static void srp_free_iu(struct srp_host *host, struct srp_iu *iu)
 	if (!iu)
 		return;
 
-	ib_dma_unmap_single(host->dev->dev, iu->dma, iu->size, iu->direction);
+	ib_dma_unmap_single(host->srp_dev->dev, iu->dma, iu->size,
+			    iu->direction);
 	kfree(iu->buf);
 	kfree(iu);
 }
@@ -181,7 +183,7 @@ static int srp_init_qp(struct srp_target_port *target,
 	if (!attr)
 		return -ENOMEM;
 
-	ret = ib_find_cached_pkey(target->srp_host->dev->dev,
+	ret = ib_find_cached_pkey(target->srp_host->srp_dev->dev,
 				  target->srp_host->port,
 				  be16_to_cpu(target->path.pkey),
 				  &attr->pkey_index);
@@ -208,7 +210,7 @@ static int srp_new_cm_id(struct srp_target_port *target)
 {
 	struct ib_cm_id *new_cm_id;
 
-	new_cm_id = ib_create_cm_id(target->srp_host->dev->dev,
+	new_cm_id = ib_create_cm_id(target->srp_host->srp_dev->dev,
 				    srp_cm_handler, target);
 	if (IS_ERR(new_cm_id))
 		return PTR_ERR(new_cm_id);
@@ -229,8 +231,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	if (!init_attr)
 		return -ENOMEM;
 
-	target->cq = ib_create_cq(target->srp_host->dev->dev, srp_completion,
-				  NULL, target, SRP_CQ_SIZE, 0);
+	target->cq = ib_create_cq(target->srp_host->srp_dev->dev,
+				  srp_completion, NULL, target, SRP_CQ_SIZE, 0);
 	if (IS_ERR(target->cq)) {
 		ret = PTR_ERR(target->cq);
 		goto out;
@@ -248,7 +250,7 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	init_attr->send_cq             = target->cq;
 	init_attr->recv_cq             = target->cq;
 
-	target->qp = ib_create_qp(target->srp_host->dev->pd, init_attr);
+	target->qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
 	if (IS_ERR(target->qp)) {
 		ret = PTR_ERR(target->qp);
 		ib_destroy_cq(target->cq);
@@ -302,7 +304,7 @@ static int srp_lookup_path(struct srp_target_port *target)
 	init_completion(&target->done);
 
 	target->path_query_id = ib_sa_path_rec_get(&srp_sa_client,
-						   target->srp_host->dev->dev,
+						   target->srp_host->srp_dev->dev,
 						   target->srp_host->port,
 						   &target->path,
 						   IB_SA_PATH_REC_SERVICE_ID	|
@@ -403,7 +405,7 @@ static int srp_send_req(struct srp_target_port *target)
 			     (unsigned long long) be64_to_cpu(target->ioc_guid));
 		memset(req->priv.initiator_port_id, 0, 8);
 		memcpy(req->priv.initiator_port_id + 8,
-		       &target->srp_host->dev->dev->node_guid, 8);
+		       &target->srp_host->srp_dev->dev->node_guid, 8);
 	}
 
 	status = ib_send_cm_req(target->cm_id, &req->param);
@@ -520,7 +522,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		req->fmr = NULL;
 	}
 
-	ib_dma_unmap_sg(target->srp_host->dev->dev, scsi_sglist(scmnd),
+	ib_dma_unmap_sg(target->srp_host->srp_dev->dev, scsi_sglist(scmnd),
 			scsi_sg_count(scmnd), scmnd->sc_data_direction);
 }
 
@@ -628,7 +630,7 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 	int page_cnt;
 	int i, j;
 	int ret;
-	struct srp_device *dev = target->srp_host->dev;
+	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = dev->dev;
 	struct scatterlist *sg;
 
@@ -723,7 +725,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	nents = scsi_sg_count(scmnd);
 	scat  = scsi_sglist(scmnd);
 
-	dev = target->srp_host->dev;
+	dev = target->srp_host->srp_dev;
 	ibdev = dev->dev;
 
 	count = ib_dma_map_sg(ibdev, scat, nents, scmnd->sc_data_direction);
@@ -779,7 +781,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 		buf->table_desc.va  =
 			cpu_to_be64(req->cmd->dma + sizeof *cmd + sizeof *buf);
 		buf->table_desc.key =
-			cpu_to_be32(target->srp_host->dev->mr->rkey);
+			cpu_to_be32(target->srp_host->srp_dev->mr->rkey);
 		buf->table_desc.len =
 			cpu_to_be32(count * sizeof (struct srp_direct_buf));
 
@@ -855,7 +857,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 
 	iu = target->rx_ring[wc->wr_id & ~SRP_OP_RECV];
 
-	dev = target->srp_host->dev->dev;
+	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_ti_iu_len,
 				   DMA_FROM_DEVICE);
 
@@ -937,7 +939,7 @@ static int __srp_post_recv(struct srp_target_port *target)
 
 	list.addr   = iu->dma;
 	list.length = iu->size;
-	list.lkey   = target->srp_host->dev->mr->lkey;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next     = NULL;
 	wr.sg_list  = &list;
@@ -996,7 +998,7 @@ static int __srp_post_send(struct srp_target_port *target,
 
 	list.addr   = iu->dma;
 	list.length = len;
-	list.lkey   = target->srp_host->dev->mr->lkey;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
 	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
@@ -1039,7 +1041,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	if (!iu)
 		goto err;
 
-	dev = target->srp_host->dev->dev;
+	dev = target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
 				   DMA_TO_DEVICE);
 
@@ -1563,7 +1565,7 @@ static ssize_t show_local_ib_device(struct class_device *cdev, char *buf)
 {
 	struct srp_target_port *target = host_to_target(class_to_shost(cdev));
 
-	return sprintf(buf, "%s\n", target->srp_host->dev->dev->name);
+	return sprintf(buf, "%s\n", target->srp_host->srp_dev->dev->name);
 }
 
 static CLASS_DEVICE_ATTR(id_ext,	  S_IRUGO, show_id_ext,		 NULL);
@@ -1613,7 +1615,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	sprintf(target->target_name, "SRP.T10:%016llX",
 		 (unsigned long long) be64_to_cpu(target->id_ext));
 
-	if (scsi_add_host(target->scsi_host, host->dev->dev->dma_device))
+	if (scsi_add_host(target->scsi_host, host->srp_dev->dev->dma_device))
 		return -ENODEV;
 
 	memcpy(ids.port_id, &target->id_ext, 8);
@@ -1871,7 +1873,8 @@ static ssize_t srp_create_target(struct class_device *class_dev,
 	if (ret)
 		goto err;
 
-	ib_get_cached_gid(host->dev->dev, host->port, 0, &target->path.sgid);
+	ib_get_cached_gid(host->srp_dev->dev, host->port, 0,
+			  &target->path.sgid);
 
 	shost_printk(KERN_DEBUG, target->scsi_host, PFX
 		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
@@ -1933,7 +1936,7 @@ static ssize_t show_ibdev(struct class_device *class_dev, char *buf)
 	struct srp_host *host =
 		container_of(class_dev, struct srp_host, class_dev);
 
-	return sprintf(buf, "%s\n", host->dev->dev->name);
+	return sprintf(buf, "%s\n", host->srp_dev->dev->name);
 }
 
 static CLASS_DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
@@ -1959,7 +1962,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 	INIT_LIST_HEAD(&host->target_list);
 	spin_lock_init(&host->target_lock);
 	init_completion(&host->released);
-	host->dev  = device;
+	host->srp_dev = device;
 	host->port = port;
 
 	host->class_dev.class = &srp_class;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index cb6eb81..67e17c3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -97,7 +97,7 @@ struct srp_device {
 };
 
 struct srp_host {
-	struct srp_device      *dev;
+	struct srp_device      *srp_dev;
 	u8			port;
 	struct class_device	class_dev;
 	struct list_head	target_list;
-- 
1.5.4.5

