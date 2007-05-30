Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbXE3RCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbXE3RCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXE3RBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:01:38 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:4879 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbXE3RBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:01:36 -0400
From: divy@chelsio.com
Subject: [PATCH 2/5] cxgb3 - fix netpoll hanlder
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 30 May 2007 10:01:34 -0700
Message-ID: <20070530170134.22807.94226.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Fix netpoll handler to work with line interrupt, msi and msi-x.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |   16 +++++++++++++---
 drivers/net/cxgb3/sge.c        |    1 -
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 67b4b21..dd3710f 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -2076,10 +2076,20 @@ static void vlan_rx_kill_vid(struct net_
 static void cxgb_netpoll(struct net_device *dev)
 {
 	struct adapter *adapter = dev->priv;
-	struct sge_qset *qs = dev2qset(dev);
+	struct port_info *pi = netdev_priv(dev);
+	int qidx;
 
-	t3_intr_handler(adapter, qs->rspq.polling) (adapter->pdev->irq,
-						    adapter);
+	for (qidx = pi->first_qset; qidx < pi->first_qset + pi->nqsets; qidx++) {
+		struct sge_qset *qs = &adapter->sge.qs[qidx];
+		void *source;
+		
+		if (adapter->flags & USING_MSIX)
+			source = qs;
+		else
+			source = adapter;
+
+		t3_intr_handler(adapter, qs->rspq.polling) (0, source);
+	}
 }
 #endif
 
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index eaa7dac..a60ec4d 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2217,7 +2217,6 @@ irqreturn_t t3_sge_intr_msix_napi(int ir
 	struct sge_rspq *q = &qs->rspq;
 
 	spin_lock(&q->lock);
-	BUG_ON(napi_is_scheduled(qs->netdev));
 
 	if (handle_responses(adap, q) < 0)
 		q->unhandled_irqs++;
