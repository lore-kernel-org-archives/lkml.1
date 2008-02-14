Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbYBNXcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbYBNXcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbYBNXcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:32:03 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:4455 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557AbYBNXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:32:00 -0500
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 14 Feb 2008 15:31:55 -0800
Message-ID: <ada8x1np11w.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 23:31:55.0476 (UTC) FILETIME=[C8FF8940:01C86F61]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few post-2.6.25-rc1 fixes:

Eli Cohen (1):
      IPoIB: Remove unused struct ipoib_cm_tx.ibwc member

Jack Morgenstein (3):
      IPoIB: On P_Key change event, reset state properly
      IB/mlx4: mlx4_ib_fmr_alloc() should call mlx4_fmr_enable()
      mlx4_core: Move table_find from fmr_alloc to fmr_enable

Marcin Slusarz (1):
      IB/mthca: Convert to use be16_add_cpu()

Roland Dreier (3):
      IB/mthca: Add missing sg_init_table() in mthca_map_user_db()
      IB/cm: Remove debug printk()s that snuck upstream
      IB/cm: Fix infiniband_cm class kobject ref counting

Sean Hefty (1):
      RDMA/cma: Do not issue MRA if user rejects connection request

Steve Wise (1):
      RDMA/cxgb3: Fail loopback connections

 drivers/infiniband/core/cm.c                |   26 ++++++++------------------
 drivers/infiniband/core/cma.c               |   10 +++++++++-
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |   17 +++++++++++++++++
 drivers/infiniband/hw/mlx4/mr.c             |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c      |    2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |    1 +
 drivers/infiniband/ulp/ipoib/ipoib.h        |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c     |    1 +
 drivers/net/mlx4/mr.c                       |   21 +++++++++++++--------
 9 files changed, 51 insertions(+), 30 deletions(-)


diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 638b727..b10ade9 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3587,8 +3587,6 @@ static void cm_release_port_obj(struct kobject *obj)
 {
 	struct cm_port *cm_port;
 
-	printk(KERN_ERR "free cm port\n");
-
 	cm_port = container_of(obj, struct cm_port, port_obj);
 	kfree(cm_port);
 }
@@ -3601,8 +3599,6 @@ static void cm_release_dev_obj(struct kobject *obj)
 {
 	struct cm_device *cm_dev;
 
-	printk(KERN_ERR "free cm dev\n");
-
 	cm_dev = container_of(obj, struct cm_device, dev_obj);
 	kfree(cm_dev);
 }
@@ -3616,18 +3612,12 @@ struct class cm_class = {
 };
 EXPORT_SYMBOL(cm_class);
 
-static void cm_remove_fs_obj(struct kobject *obj)
-{
-	kobject_put(obj->parent);
-	kobject_put(obj);
-}
-
 static int cm_create_port_fs(struct cm_port *port)
 {
 	int i, ret;
 
 	ret = kobject_init_and_add(&port->port_obj, &cm_port_obj_type,
-				   kobject_get(&port->cm_dev->dev_obj),
+				   &port->cm_dev->dev_obj,
 				   "%d", port->port_num);
 	if (ret) {
 		kfree(port);
@@ -3637,7 +3627,7 @@ static int cm_create_port_fs(struct cm_port *port)
 	for (i = 0; i < CM_COUNTER_GROUPS; i++) {
 		ret = kobject_init_and_add(&port->counter_group[i].obj,
 					   &cm_counter_obj_type,
-					   kobject_get(&port->port_obj),
+					   &port->port_obj,
 					   "%s", counter_group_names[i]);
 		if (ret)
 			goto error;
@@ -3647,8 +3637,8 @@ static int cm_create_port_fs(struct cm_port *port)
 
 error:
 	while (i--)
-		cm_remove_fs_obj(&port->counter_group[i].obj);
-	cm_remove_fs_obj(&port->port_obj);
+		kobject_put(&port->counter_group[i].obj);
+	kobject_put(&port->port_obj);
 	return ret;
 
 }
@@ -3658,9 +3648,9 @@ static void cm_remove_port_fs(struct cm_port *port)
 	int i;
 
 	for (i = 0; i < CM_COUNTER_GROUPS; i++)
-		cm_remove_fs_obj(&port->counter_group[i].obj);
+		kobject_put(&port->counter_group[i].obj);
 
-	cm_remove_fs_obj(&port->port_obj);
+	kobject_put(&port->port_obj);
 }
 
 static void cm_add_one(struct ib_device *device)
@@ -3744,7 +3734,7 @@ error1:
 		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
 	}
-	cm_remove_fs_obj(&cm_dev->dev_obj);
+	kobject_put(&cm_dev->dev_obj);
 }
 
 static void cm_remove_one(struct ib_device *device)
@@ -3771,7 +3761,7 @@ static void cm_remove_one(struct ib_device *device)
 		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
 	}
-	cm_remove_fs_obj(&cm_dev->dev_obj);
+	kobject_put(&cm_dev->dev_obj);
 }
 
 static int __init ib_cm_init(void)
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 1eff1b2..34507da 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1107,7 +1107,6 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		event.param.ud.private_data_len =
 				IB_CM_SIDR_REQ_PRIVATE_DATA_SIZE - offset;
 	} else {
-		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		conn_id = cma_new_conn_id(&listen_id->id, ib_event);
 		cma_set_req_event_data(&event, &ib_event->param.req_rcvd,
 				       ib_event->private_data, offset);
@@ -1130,6 +1129,15 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (!ret) {
+		/*
+		 * Acquire mutex to prevent user executing rdma_destroy_id()
+		 * while we're accessing the cm_id.
+		 */
+		mutex_lock(&lock);
+		if (cma_comp(conn_id, CMA_CONNECT) &&
+		    !cma_is_ud_ps(conn_id->id.ps))
+			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
+		mutex_unlock(&lock);
 		cma_enable_remove(conn_id);
 		goto out;
 	}
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index e9a08fa..320f2b6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -35,6 +35,7 @@
 #include <linux/skbuff.h>
 #include <linux/timer.h>
 #include <linux/notifier.h>
+#include <linux/inetdevice.h>
 
 #include <net/neighbour.h>
 #include <net/netevent.h>
@@ -1784,6 +1785,17 @@ err:
 	return err;
 }
 
+static int is_loopback_dst(struct iw_cm_id *cm_id)
+{
+	struct net_device *dev;
+
+	dev = ip_dev_find(&init_net, cm_id->remote_addr.sin_addr.s_addr);
+	if (!dev)
+		return 0;
+	dev_put(dev);
+	return 1;
+}
+
 int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
 	int err = 0;
@@ -1791,6 +1803,11 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct iwch_ep *ep;
 	struct rtable *rt;
 
+	if (is_loopback_dst(cm_id)) {
+		err = -ENOSYS;
+		goto out;
+	}
+
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
 		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __FUNCTION__);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 7dc91a3..fe2c2e9 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -199,7 +199,7 @@ struct ib_fmr *mlx4_ib_fmr_alloc(struct ib_pd *pd, int acc,
 	if (err)
 		goto err_free;
 
-	err = mlx4_mr_enable(to_mdev(pd->device)->dev, &fmr->mfmr.mr);
+	err = mlx4_fmr_enable(to_mdev(pd->device)->dev, &fmr->mfmr);
 	if (err)
 		goto err_mr;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 6bd9f13..1e1e336 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -473,7 +473,7 @@ static void handle_error_cqe(struct mthca_dev *dev, struct mthca_cq *cq,
 	if (!(new_wqe & cpu_to_be32(0x3f)) || (!cqe->db_cnt && dbd))
 		return;
 
-	cqe->db_cnt   = cpu_to_be16(be16_to_cpu(cqe->db_cnt) - dbd);
+	be16_add_cpu(&cqe->db_cnt, -dbd);
 	cqe->wqe      = new_wqe;
 	cqe->syndrome = SYNDROME_WR_FLUSH_ERR;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 1f4d27d..252db08 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -542,6 +542,7 @@ struct mthca_user_db_table *mthca_init_user_db_tab(struct mthca_dev *dev)
 	for (i = 0; i < npages; ++i) {
 		db_tab->page[i].refcount = 0;
 		db_tab->page[i].uvirt    = 0;
+		sg_init_table(&db_tab->page[i].mem, 1);
 	}
 
 	return db_tab;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index f9b7caa..054fab8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -209,7 +209,6 @@ struct ipoib_cm_tx {
 	unsigned	     tx_tail;
 	unsigned long	     flags;
 	u32		     mtu;
-	struct ib_wc	     ibwc[IPOIB_NUM_WC];
 };
 
 struct ipoib_cm_rx_buf {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 9d3e778..08c4396 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -780,6 +780,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv, int pkey_event)
 		if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &new_index)) {
 			clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
 			ipoib_ib_dev_down(dev, 0);
+			ipoib_ib_dev_stop(dev, 0);
 			ipoib_pkey_dev_delay_open(dev);
 			return;
 		}
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 679dfdb..79b317b 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -578,13 +578,6 @@ int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
 		goto err_free;
 	}
 
-	fmr->mpt = mlx4_table_find(&priv->mr_table.dmpt_table,
-				    key_to_hw_index(fmr->mr.key), NULL);
-	if (!fmr->mpt) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
 	return 0;
 
 err_free:
@@ -595,7 +588,19 @@ EXPORT_SYMBOL_GPL(mlx4_fmr_alloc);
 
 int mlx4_fmr_enable(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
 {
-	return mlx4_mr_enable(dev, &fmr->mr);
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	int err;
+
+	err = mlx4_mr_enable(dev, &fmr->mr);
+	if (err)
+		return err;
+
+	fmr->mpt = mlx4_table_find(&priv->mr_table.dmpt_table,
+				    key_to_hw_index(fmr->mr.key), NULL);
+	if (!fmr->mpt)
+		return -ENOMEM;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx4_fmr_enable);
 
