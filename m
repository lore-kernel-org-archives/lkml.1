Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYBSSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYBSSwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYBSSvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:51:50 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:20089 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbYBSSvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:51:48 -0500
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 19 Feb 2008 10:51:40 -0800
Message-ID: <adatzk4g4oz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Feb 2008 18:51:43.0281 (UTC) FILETIME=[7836EA10:01C87328]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a couple of small post-2.6.25-rc2 fixes:

Pradeep Satyanarayana (1):
      IPoIB/cm: Fix ipoib_cm_dev_stop() cleanup when drain times out

Roland Dreier (1):
      IB/mthca: Free correct MPT on error exit from mthca_fmr_alloc()

 drivers/infiniband/hw/mthca/mthca_mr.c  |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 3b69855..3538da1 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -686,7 +686,7 @@ err_out_table:
 	mthca_table_put(dev, dev->mr_table.mpt_table, key);
 
 err_out_mpt_free:
-	mthca_free(&dev->mr_table.mpt_alloc, mr->ibmr.lkey);
+	mthca_free(&dev->mr_table.mpt_alloc, key);
 	return err;
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 7dd2ec4..52b1beb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -824,7 +824,6 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_rx *p;
 	unsigned long begin;
-	LIST_HEAD(list);
 	int ret;
 
 	if (!IPOIB_CM_SUPPORTED(dev->dev_addr) || !priv->cm.id)
@@ -857,9 +856,12 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 			/*
 			 * assume the HW is wedged and just free up everything.
 			 */
-			list_splice_init(&priv->cm.rx_flush_list, &list);
-			list_splice_init(&priv->cm.rx_error_list, &list);
-			list_splice_init(&priv->cm.rx_drain_list, &list);
+			list_splice_init(&priv->cm.rx_flush_list,
+					 &priv->cm.rx_reap_list);
+			list_splice_init(&priv->cm.rx_error_list,
+					 &priv->cm.rx_reap_list);
+			list_splice_init(&priv->cm.rx_drain_list,
+					 &priv->cm.rx_reap_list);
 			break;
 		}
 		spin_unlock_irq(&priv->lock);
