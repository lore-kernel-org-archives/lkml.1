Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXCVVja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXCVVja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161089AbXCVVj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:39:29 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:35722 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbXCVVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:39:17 -0400
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 22 Mar 2007 14:39:16 -0700
Message-ID: <adaps71c60r.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2007 21:39:16.0319 (UTC) FILETIME=[8A5246F0:01C76CCA]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get various small post-rc4 fixes:

Bryan O'Sullivan (1):
      IB/ipath: check return value of lookup_one_len

Joachim Fenkes (1):
      IB/ehca: Make scaling code work without CPU hotplug

Michael S. Tsirkin (3):
      IPoIB/cm: Fix reaping of stale connections
      IPoIB: Fix use-after-free in path_rec_completion()
      IB/ipoib: Fix thinko in packet length checks

Sean Hefty (1):
      IPoIB: Fix race in detaching from mcast group before attaching

Steve Wise (1):
      RDMA/cxgb3: Handle build_phys_page_list() failure in iwch_reregister_phys_mem()

 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    5 ++++-
 drivers/infiniband/hw/ehca/ehca_irq.c          |    8 ++++++++
 drivers/infiniband/hw/ipath/ipath_fs.c         |   16 +++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 +++---
 7 files changed, 36 insertions(+), 11 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index f2774ae..24e0df0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -545,11 +545,14 @@ static int iwch_reregister_phys_mem(struct ib_mr *mr,
 		php = to_iwch_pd(pd);
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		mh.attr.perms = iwch_ib_to_tpt_access(acc);
-	if (mr_rereg_mask & IB_MR_REREG_TRANS)
+	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
 		ret = build_phys_page_list(buffer_list, num_phys_buf,
 					   iova_start,
 					   &total_size, &npages,
 					   &shift, &page_list);
+		if (ret)
+			return ret;
+	}
 
 	ret = iwch_reregister_mem(rhp, php, &mh, shift, page_list, npages);
 	kfree(page_list);
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 20f36bf..f284be1 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -66,7 +66,9 @@
 static void queue_comp_task(struct ehca_cq *__cq);
 
 static struct ehca_comp_pool* pool;
+#ifdef CONFIG_HOTPLUG_CPU
 static struct notifier_block comp_pool_callback_nb;
+#endif
 
 static inline void comp_event_callback(struct ehca_cq *cq)
 {
@@ -733,6 +735,7 @@ static void take_over_work(struct ehca_comp_pool *pool,
 
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static int comp_pool_callback(struct notifier_block *nfb,
 			      unsigned long action,
 			      void *hcpu)
@@ -775,6 +778,7 @@ static int comp_pool_callback(struct notifier_block *nfb,
 
 	return NOTIFY_OK;
 }
+#endif
 
 int ehca_create_comp_pool(void)
 {
@@ -805,9 +809,11 @@ int ehca_create_comp_pool(void)
 		}
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
 	comp_pool_callback_nb.notifier_call = comp_pool_callback;
 	comp_pool_callback_nb.priority =0;
 	register_cpu_notifier(&comp_pool_callback_nb);
+#endif
 
 	printk(KERN_INFO "eHCA scaling code enabled\n");
 
@@ -821,7 +827,9 @@ void ehca_destroy_comp_pool(void)
 	if (!ehca_scaling_code)
 		return;
 
+#ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&comp_pool_callback_nb);
+#endif
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_online(i))
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 5b40a84..ed55979 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -451,12 +451,18 @@ bail:
 	return ret;
 }
 
-static void remove_file(struct dentry *parent, char *name)
+static int remove_file(struct dentry *parent, char *name)
 {
 	struct dentry *tmp;
+	int ret;
 
 	tmp = lookup_one_len(name, parent, strlen(name));
 
+	if (IS_ERR(tmp)) {
+		ret = PTR_ERR(tmp);
+		goto bail;
+	}
+
 	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
@@ -469,6 +475,14 @@ static void remove_file(struct dentry *parent, char *name)
 		spin_unlock(&tmp->d_lock);
 		spin_unlock(&dcache_lock);
 	}
+
+	ret = 0;
+bail:
+	/*
+	 * We don't expect clients to care about the return value, but
+	 * it's there if they need it.
+	 */
+	return ret;
 }
 
 static int remove_device_files(struct super_block *sb,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 3484e8b..e70492d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -452,7 +452,7 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 			   skb->len, tx->mtu);
 		++priv->stats.tx_dropped;
 		++priv->stats.tx_errors;
-		ipoib_cm_skb_too_long(dev, skb, tx->mtu - INFINIBAND_ALEN);
+		ipoib_cm_skb_too_long(dev, skb, tx->mtu - IPOIB_ENCAP_LEN);
 		return;
 	}
 
@@ -1095,7 +1095,7 @@ static void ipoib_cm_stale_task(struct work_struct *work)
 		/* List if sorted by LRU, start from tail,
 		 * stop when we see a recently used entry */
 		p = list_entry(priv->cm.passive_ids.prev, typeof(*p), list);
-		if (time_after_eq(jiffies, p->jiffies + IPOIB_CM_RX_TIMEOUT))
+		if (time_before_eq(jiffies, p->jiffies + IPOIB_CM_RX_TIMEOUT))
 			break;
 		list_del_init(&p->list);
 		spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index f2aa923..ba0ee5c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -328,9 +328,9 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	struct ipoib_tx_buf *tx_req;
 	u64 addr;
 
-	if (unlikely(skb->len > priv->mcast_mtu + INFINIBAND_ALEN)) {
+	if (unlikely(skb->len > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
 		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
-			   skb->len, priv->mcast_mtu + INFINIBAND_ALEN);
+			   skb->len, priv->mcast_mtu + IPOIB_ENCAP_LEN);
 		++priv->stats.tx_dropped;
 		++priv->stats.tx_errors;
 		ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f9dbc6f..0741c6d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -380,7 +380,7 @@ static void path_rec_completion(int status,
 	struct net_device *dev = path->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_ah *ah = NULL;
-	struct ipoib_neigh *neigh;
+	struct ipoib_neigh *neigh, *tn;
 	struct sk_buff_head skqueue;
 	struct sk_buff *skb;
 	unsigned long flags;
@@ -418,7 +418,7 @@ static void path_rec_completion(int status,
 		while ((skb = __skb_dequeue(&path->queue)))
 			__skb_queue_tail(&skqueue, skb);
 
-		list_for_each_entry(neigh, &path->neigh_list, list) {
+		list_for_each_entry_safe(neigh, tn, &path->neigh_list, list) {
 			kref_get(&path->ah->ref);
 			neigh->ah = path->ah;
 			memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 56c87a8..54fbead 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -644,6 +644,9 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret = 0;
 
+	if (test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
+		ib_sa_free_multicast(mcast->mc);
+
 	if (test_and_clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
 		ipoib_dbg_mcast(priv, "leaving MGID " IPOIB_GID_FMT "\n",
 				IPOIB_GID_ARG(mcast->mcmember.mgid));
@@ -655,9 +658,6 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 			ipoib_warn(priv, "ipoib_mcast_detach failed (result = %d)\n", ret);
 	}
 
-	if (test_and_clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
-		ib_sa_free_multicast(mcast->mc);
-
 	return 0;
 }
 
