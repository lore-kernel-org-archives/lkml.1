Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbXEZXAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbXEZXAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXEZW75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:59:57 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8902 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXEZW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:59:55 -0400
From: divy@chelsio.com
Subject: [PATCH 2/7] cxgb3 - fix netpoll hanlder
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sat, 26 May 2007 15:59:52 -0700
Message-ID: <20070526225952.12115.30971.stgit@localhost.localdomain>
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

 drivers/net/cxgb3/cxgb3_main.c |   12 +++++++++---
 drivers/net/cxgb3/sge.c        |    1 -
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 67b4b21..e0ef724 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -2076,10 +2076,16 @@ static void vlan_rx_kill_vid(struct net_
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
+		
+		t3_intr_handler(adapter, qs->rspq.polling) (0, 
+					(adapter->flags & USING_MSIX) ?
+					(void *)qs : (void *)adapter);
+	}
 }
 #endif
 
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 8dd5b1e..a2cfd68 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2228,7 +2228,6 @@ irqreturn_t t3_sge_intr_msix_napi(int ir
 	struct sge_rspq *q = &qs->rspq;
 
 	spin_lock(&q->lock);
-	BUG_ON(napi_is_scheduled(qs->netdev));
 
 	if (handle_responses(adap, q) < 0)
 		q->unhandled_irqs++;
