Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYIQQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYIQQlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYIQQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:40:52 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:64613 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYIQQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:40:49 -0400
X-IronPort-AV: E=Sophos;i="4.32,416,1217808000"; 
   d="scan'208";a="78947940"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 17 Sep 2008 09:40:39 -0700
Message-ID: <adar67ibu9k.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2008 16:40:39.0872 (UTC) FILETIME=[1E6B2C00:01C918E4]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get four patches, which I believe are all appropriate for
this stage of 2.6.27:

 - A fix for a nes regression we introduced in some earlier 2.6.27
   patches that leads to userspace processes hanging on exit.

 - Two fixes that make a new mlx4 feature we added in 2.6.27 actually
   work.  The functions touched are only used for the new fast
   register work requests so fixing this is low risk.

 - A fix for an IPoIB RTNL deadlock that we introduced in 2.6.27.

Faisal Latif (1):
      RDMA/nes: Fix client side QP destroy

Roland Dreier (1):
      Merge branches 'ipoib', 'mlx4' and 'nes' into for-linus

Vladimir Sokolovsky (2):
      mlx4_core: Set RAE and init mtt_sz field in FRMR MPT entries
      IB/mlx4: Fix up fast register page list format

Yossi Etigin (1):
      IPoIB: Fix deadlock on RTNL between bcast join comp and ipoib_stop()

 drivers/infiniband/hw/mlx4/qp.c                |    6 ++++
 drivers/infiniband/hw/nes/nes_cm.c             |   11 +-------
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   31 ++++++++++++++++-------
 drivers/net/mlx4/mr.c                          |   10 ++++---
 include/linux/mlx4/device.h                    |    4 +++
 7 files changed, 42 insertions(+), 23 deletions(-)


commit e8224e4b804b4fd26723191c1891101a5959bb8a
Author: Yossi Etigin <yossi.openib@gmail.com>
Date:   Tue Sep 16 11:57:45 2008 -0700

    IPoIB: Fix deadlock on RTNL between bcast join comp and ipoib_stop()
    
    Taking rtnl_lock in ipoib_mcast_join_complete() causes a deadlock with
    ipoib_stop().  We avoid it by scheduling the piece of code that takes
    the lock on ipoib_workqueue instead of executing it directly.  This
    works because we only flush the ipoib_workqueue with the RTNL not held.
    
    The deadlock happens because ipoib_stop() calls ipoib_ib_dev_down()
    which calls ipoib_mcast_dev_flush(), which calls ipoib_mcast_free(),
    which calls ipoib_mcast_leave(). The latter calls
    ib_sa_free_multicast(), and this waits until the multicast completion
    handler finishes.  This handler is ipoib_mcast_join_complete(), which
    waits for the rtnl_lock(), which was already taken by ipoib_stop().
    
    This bug was introduced in commit a77a57a1 ("IPoIB: Fix deadlock on
    RTNL in ipoib_stop()").
    
    Signed-off-by: Yossi Etigin <yosefe@voltaire.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index b0ffc9a..05eb41b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -293,6 +293,7 @@ struct ipoib_dev_priv {
 
 	struct delayed_work pkey_poll_task;
 	struct delayed_work mcast_task;
+	struct work_struct carrier_on_task;
 	struct work_struct flush_light;
 	struct work_struct flush_normal;
 	struct work_struct flush_heavy;
@@ -464,6 +465,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
 void ipoib_dev_cleanup(struct net_device *dev);
 
 void ipoib_mcast_join_task(struct work_struct *work);
+void ipoib_mcast_carrier_on_task(struct work_struct *work);
 void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7e9e218..1b1df5c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1075,6 +1075,7 @@ static void ipoib_setup(struct net_device *dev)
 
 	INIT_DELAYED_WORK(&priv->pkey_poll_task, ipoib_pkey_poll);
 	INIT_DELAYED_WORK(&priv->mcast_task,   ipoib_mcast_join_task);
+	INIT_WORK(&priv->carrier_on_task, ipoib_mcast_carrier_on_task);
 	INIT_WORK(&priv->flush_light,   ipoib_ib_dev_flush_light);
 	INIT_WORK(&priv->flush_normal,   ipoib_ib_dev_flush_normal);
 	INIT_WORK(&priv->flush_heavy,   ipoib_ib_dev_flush_heavy);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index ac33c8f..aae2862 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -366,6 +366,21 @@ static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
 	return ret;
 }
 
+void ipoib_mcast_carrier_on_task(struct work_struct *work)
+{
+	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
+						   carrier_on_task);
+
+	/*
+	 * Take rtnl_lock to avoid racing with ipoib_stop() and
+	 * turning the carrier back on while a device is being
+	 * removed.
+	 */
+	rtnl_lock();
+	netif_carrier_on(priv->dev);
+	rtnl_unlock();
+}
+
 static int ipoib_mcast_join_complete(int status,
 				     struct ib_sa_multicast *multicast)
 {
@@ -392,16 +407,12 @@ static int ipoib_mcast_join_complete(int status,
 					   &priv->mcast_task, 0);
 		mutex_unlock(&mcast_mutex);
 
-		if (mcast == priv->broadcast) {
-			/*
-			 * Take RTNL lock here to avoid racing with
-			 * ipoib_stop() and turning the carrier back
-			 * on while a device is being removed.
-			 */
-			rtnl_lock();
-			netif_carrier_on(dev);
-			rtnl_unlock();
-		}
+		/*
+		 * Defer carrier on work to ipoib_workqueue to avoid a
+		 * deadlock on rtnl_lock here.
+		 */
+		if (mcast == priv->broadcast)
+			queue_work(ipoib_workqueue, &priv->carrier_on_task);
 
 		return 0;
 	}

commit d7ffd5076d4407d54b25bc4b25f3002f74fbafde
Author: Faisal Latif <flatif@neteffect.com>
Date:   Tue Sep 16 11:56:26 2008 -0700

    RDMA/nes: Fix client side QP destroy
    
    Fix QP not being destroyed properly on the client, which leads to
    userspace programs hanging on exit.  This is a missing chunk from the
    connection management rewrite in commit 6492cdf3 ("RDMA/nes: CM
    connection setup/teardown rework").
    
    Signed-off-by: Faisal Latif <flatif@neteffect.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 9f0b964..499d3cf 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1956,13 +1956,6 @@ static int mini_cm_reject(struct nes_cm_core *cm_core,
 		return ret;
 	cleanup_retrans_entry(cm_node);
 	cm_node->state = NES_CM_STATE_CLOSED;
-	ret = send_fin(cm_node, NULL);
-
-	if (cm_node->accept_pend) {
-		BUG_ON(!cm_node->listener);
-		atomic_dec(&cm_node->listener->pend_accepts_cnt);
-		BUG_ON(atomic_read(&cm_node->listener->pend_accepts_cnt) < 0);
-	}
 
 	ret = send_reset(cm_node, NULL);
 	return ret;
@@ -2383,6 +2376,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 			atomic_inc(&cm_disconnects);
 			cm_event.event = IW_CM_EVENT_DISCONNECT;
 			if (last_ae == NES_AEQE_AEID_LLP_CONNECTION_RESET) {
+				issued_disconnect_reset = 1;
 				cm_event.status = IW_CM_EVENT_STATUS_RESET;
 				nes_debug(NES_DBG_CM, "Generating a CM "
 					"Disconnect Event (status reset) for "
@@ -2508,7 +2502,6 @@ static int nes_disconnect(struct nes_qp *nesqp, int abrupt)
 		nes_debug(NES_DBG_CM, "Call close API\n");
 
 		g_cm_core->api->close(g_cm_core, nesqp->cm_node);
-		nesqp->cm_node = NULL;
 	}
 
 	return ret;
@@ -2837,6 +2830,7 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_node->apbvt_set = 1;
 	nesqp->cm_node = cm_node;
 	cm_node->nesqp = nesqp;
+	nes_add_ref(&nesqp->ibqp);
 
 	return 0;
 }
@@ -3167,7 +3161,6 @@ static void cm_event_connect_error(struct nes_cm_event *event)
 	if (ret)
 		printk(KERN_ERR "%s[%u] OFA CM event_handler returned, "
 			"ret=%d\n", __func__, __LINE__, ret);
-	nes_rem_ref(&nesqp->ibqp);
 	cm_id->rem_ref(cm_id);
 
 	rem_ref_cm_node(event->cm_node->cm_core, event->cm_node);

commit 29bdc88384c2b24e37e5760df0dc898546083d6b
Author: Vladimir Sokolovsky <vlad@mellanox.co.il>
Date:   Mon Sep 15 14:25:23 2008 -0700

    IB/mlx4: Fix up fast register page list format
    
    Byte swap the addresses in the page list for fast register work requests
    to big endian to match what the HCA expectx.  Also, the addresses must
    have the "present" bit set so that the HCA knows it can access them.
    Otherwise the HCA will fault the first time it accesses the memory
    region.
    
    Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index f29dbb7..9559248 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1342,6 +1342,12 @@ static __be32 convert_access(int acc)
 static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
 {
 	struct mlx4_ib_fast_reg_page_list *mfrpl = to_mfrpl(wr->wr.fast_reg.page_list);
+	int i;
+
+	for (i = 0; i < wr->wr.fast_reg.page_list_len; ++i)
+		wr->wr.fast_reg.page_list->page_list[i] =
+			cpu_to_be64(wr->wr.fast_reg.page_list->page_list[i] |
+				    MLX4_MTT_FLAG_PRESENT);
 
 	fseg->flags		= convert_access(wr->wr.fast_reg.access_flags);
 	fseg->mem_key		= cpu_to_be32(wr->wr.fast_reg.rkey);
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 644adf0..d1dd5b4 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -71,8 +71,6 @@ struct mlx4_mpt_entry {
 #define MLX4_MPT_PD_FLAG_RAE	    (1 << 28)
 #define MLX4_MPT_PD_FLAG_EN_INV	    (3 << 24)
 
-#define MLX4_MTT_FLAG_PRESENT		1
-
 #define MLX4_MPT_STATUS_SW		0xF0
 #define MLX4_MPT_STATUS_HW		0x00
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 655ea0d..b2f9444 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -141,6 +141,10 @@ enum {
 	MLX4_STAT_RATE_OFFSET	= 5
 };
 
+enum {
+	MLX4_MTT_FLAG_PRESENT		= 1
+};
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;

commit c9257433f2eaf8803a1f3d3be5d984232db41ffe
Author: Vladimir Sokolovsky <vlad@mellanox.co.il>
Date:   Tue Sep 2 13:38:29 2008 -0700

    mlx4_core: Set RAE and init mtt_sz field in FRMR MPT entries
    
    Set the RAE (remote access enable) bit and correctly initialize the
    MTT size in MPT entries being set up for fast register memory
    regions.  Otherwise the callers can't enable remote access and in fact
    can't fast register at all (since the HCA will think no MTT entries
    are allocated).
    
    Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 62071d9..644adf0 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -67,7 +67,8 @@ struct mlx4_mpt_entry {
 #define MLX4_MPT_FLAG_PHYSICAL	    (1 <<  9)
 #define MLX4_MPT_FLAG_REGION	    (1 <<  8)
 
-#define MLX4_MPT_PD_FLAG_FAST_REG   (1 << 26)
+#define MLX4_MPT_PD_FLAG_FAST_REG   (1 << 27)
+#define MLX4_MPT_PD_FLAG_RAE	    (1 << 28)
 #define MLX4_MPT_PD_FLAG_EN_INV	    (3 << 24)
 
 #define MLX4_MTT_FLAG_PRESENT		1
@@ -348,7 +349,10 @@ int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
 	if (mr->mtt.order >= 0 && mr->mtt.page_shift == 0) {
 		/* fast register MR in free state */
 		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_FREE);
-		mpt_entry->pd_flags |= cpu_to_be32(MLX4_MPT_PD_FLAG_FAST_REG);
+		mpt_entry->pd_flags |= cpu_to_be32(MLX4_MPT_PD_FLAG_FAST_REG |
+						   MLX4_MPT_PD_FLAG_RAE);
+		mpt_entry->mtt_sz    = cpu_to_be32((1 << mr->mtt.order) *
+						   MLX4_MTT_ENTRY_PER_SEG);
 	} else {
 		mpt_entry->flags    |= cpu_to_be32(MLX4_MPT_FLAG_SW_OWNS);
 	}
