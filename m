Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYHSWD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYHSWD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYHSWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:03:15 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:9449 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYHSWDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:03:14 -0400
X-IronPort-AV: E=Sophos;i="4.32,237,1217808000"; 
   d="scan'208";a="20257363"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 19 Aug 2008 15:03:13 -0700
Message-ID: <adaabf8r7by.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Aug 2008 22:03:13.0863 (UTC) FILETIME=[60511570:01C90247]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Dave Olson (1):
      IB/ipath: Fix incorrect check for max physical address in TID

Ralph Campbell (1):
      IB/ipath: Fix lost UD send work request

Roland Dreier (2):
      IPoIB: Fix deadlock on RTNL in ipoib_stop()
      Merge branches 'ipath' and 'ipoib' into for-linus

 drivers/infiniband/hw/ipath/ipath_iba7220.c    |    2 +-
 drivers/infiniband/hw/ipath/ipath_ud.c         |    8 ++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   19 +++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   10 +++++++++-
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index d90f5e9..9839e20 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -1720,7 +1720,7 @@ static void ipath_7220_put_tid(struct ipath_devdata *dd, u64 __iomem *tidptr,
 				 "not 2KB aligned!\n", pa);
 			return;
 		}
-		if (pa >= (1UL << IBA7220_TID_SZ_SHIFT)) {
+		if (chippa >= (1UL << IBA7220_TID_SZ_SHIFT)) {
 			ipath_dev_err(dd,
 				      "BUG: Physical page address 0x%lx "
 				      "larger than supported\n", pa);
diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/infiniband/hw/ipath/ipath_ud.c
index 36aa242..729446f 100644
--- a/drivers/infiniband/hw/ipath/ipath_ud.c
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c
@@ -267,6 +267,7 @@ int ipath_make_ud_req(struct ipath_qp *qp)
 	u16 lrh0;
 	u16 lid;
 	int ret = 0;
+	int next_cur;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
@@ -290,8 +291,9 @@ int ipath_make_ud_req(struct ipath_qp *qp)
 		goto bail;
 
 	wqe = get_swqe_ptr(qp, qp->s_cur);
-	if (++qp->s_cur >= qp->s_size)
-		qp->s_cur = 0;
+	next_cur = qp->s_cur + 1;
+	if (next_cur >= qp->s_size)
+		next_cur = 0;
 
 	/* Construct the header. */
 	ah_attr = &to_iah(wqe->wr.wr.ud.ah)->attr;
@@ -315,6 +317,7 @@ int ipath_make_ud_req(struct ipath_qp *qp)
 				qp->s_flags |= IPATH_S_WAIT_DMA;
 				goto bail;
 			}
+			qp->s_cur = next_cur;
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 			ipath_ud_loopback(qp, wqe);
 			spin_lock_irqsave(&qp->s_lock, flags);
@@ -323,6 +326,7 @@ int ipath_make_ud_req(struct ipath_qp *qp)
 		}
 	}
 
+	qp->s_cur = next_cur;
 	extra_bytes = -wqe->length & 3;
 	nwords = (wqe->length + extra_bytes) >> 2;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f51201b..7e9e218 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -156,14 +156,8 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	/*
-	 * Now flush workqueue to make sure a scheduled task doesn't
-	 * bring our internal state back up.
-	 */
-	flush_workqueue(ipoib_workqueue);
-
-	ipoib_ib_dev_down(dev, 1);
-	ipoib_ib_dev_stop(dev, 1);
+	ipoib_ib_dev_down(dev, 0);
+	ipoib_ib_dev_stop(dev, 0);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
 		struct ipoib_dev_priv *cpriv;
@@ -1314,7 +1308,7 @@ sysfs_failed:
 
 register_failed:
 	ib_unregister_event_handler(&priv->event_handler);
-	flush_scheduled_work();
+	flush_workqueue(ipoib_workqueue);
 
 event_failed:
 	ipoib_dev_cleanup(priv->dev);
@@ -1373,7 +1367,12 @@ static void ipoib_remove_one(struct ib_device *device)
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		ib_unregister_event_handler(&priv->event_handler);
-		flush_scheduled_work();
+
+		rtnl_lock();
+		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
+		rtnl_unlock();
+
+		flush_workqueue(ipoib_workqueue);
 
 		unregister_netdev(priv->dev);
 		ipoib_dev_cleanup(priv->dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 8950e95..ac33c8f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -392,8 +392,16 @@ static int ipoib_mcast_join_complete(int status,
 					   &priv->mcast_task, 0);
 		mutex_unlock(&mcast_mutex);
 
-		if (mcast == priv->broadcast)
+		if (mcast == priv->broadcast) {
+			/*
+			 * Take RTNL lock here to avoid racing with
+			 * ipoib_stop() and turning the carrier back
+			 * on while a device is being removed.
+			 */
+			rtnl_lock();
 			netif_carrier_on(dev);
+			rtnl_unlock();
+		}
 
 		return 0;
 	}
