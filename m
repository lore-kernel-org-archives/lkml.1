Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZEMFfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZEMFfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZEMFfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:35:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:51672 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZEMFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:34:59 -0400
Date: Wed, 13 May 2009 01:34:47 -0400 (EDT)
From: Chris Peterson <cpeterso@cpeterso.com>
X-X-Sender: user@ubuntu-desktop
To: linux-kernel@vger.kernel.org
cc: mpm@selenic.com
Subject: [PATCH] [resend] drivers/net: remove network drivers' last few uses
 of IRQF_SAMPLE_RANDOM
Message-ID: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know a new "pragmatic entropy accounting model" is in the works, but 
until then, this patch removes the network drivers' last few uses of 
theoretically-exploitable network entropy. Only 11 net drivers are 
affected. Headless servers should use a more secure source of entropy, 
such as the userspace daemons.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
 diff --git 
a/drivers/net/3c523.c b/drivers/net/3c523.c index 8f734d7..6e4e06d 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -288,7 +288,7 @@ static int elmc_open(struct net_device *dev)
 
 	elmc_id_attn586();	/* disable interrupts */
 
-	ret = request_irq(dev->irq, &elmc_interrupt, IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+	ret = request_irq(dev->irq, &elmc_interrupt, IRQF_SHARED,
 			  dev->name, dev);
 	if (ret) {
 		printk(KERN_ERR "%s: couldn't get irq %d\n", dev->name, dev->irq);
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index b61073c..8161893 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -444,7 +444,8 @@ static int __init mc32_probe1(struct net_device *dev, int slot)
 	 *	Grab the IRQ
 	 */
 
-	err = request_irq(dev->irq, &mc32_interrupt, IRQF_SHARED | IRQF_SAMPLE_RANDOM, DRV_NAME, dev);
+	err = request_irq(dev->irq, &mc32_interrupt,
+					  IRQF_SHARED, DRV_NAME, dev);
 	if (err) {
 		release_region(dev->base_addr, MC32_IO_EXTENT);
 		printk(KERN_ERR "%s: unable to get IRQ %d.\n", DRV_NAME, dev->irq);
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 0ab2254..f4bf486 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2567,7 +2567,7 @@ static s32 atl1_up(struct atl1_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	int err;
-	int irq_flags = IRQF_SAMPLE_RANDOM;
+	int irq_flags = 0;
 
 	/* hardware has been reset, we need to reload some things */
 	atlx_set_multi(netdev);
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7a18dc7..d021875 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -494,7 +494,7 @@ e100_open(struct net_device *dev)
 	/* allocate the irq corresponding to the receiving DMA */
 
 	if (request_irq(NETWORK_DMA_RX_IRQ_NBR, e100rxtx_interrupt,
-			IRQF_SAMPLE_RANDOM, cardname, (void *)dev)) {
+			0, cardname, (void *)dev)) {
 		goto grace_exit0;
 	}
 
diff --git a/drivers/net/ibmlana.c b/drivers/net/ibmlana.c
index c25bc0b..4270e80 100644
--- a/drivers/net/ibmlana.c
+++ b/drivers/net/ibmlana.c
@@ -782,7 +782,8 @@ static int ibmlana_open(struct net_device *dev)
 
 	/* register resources - only necessary for IRQ */
 
-	result = request_irq(priv->realirq, irq_handler, IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);
+	result = request_irq(priv->realirq, irq_handler,
+						 IRQF_SHARED, dev->name, dev);
 	if (result != 0) {
 		printk(KERN_ERR "%s: failed to register irq %d\n", dev->name, dev->irq);
 		return result;
diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index e82aee4..d4551b0 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -1162,8 +1162,7 @@ static int __init macb_probe(struct platform_device *pdev)
 	}
 
 	dev->irq = platform_get_irq(pdev, 0);
-	err = request_irq(dev->irq, macb_interrupt, IRQF_SAMPLE_RANDOM,
-			  dev->name, dev);
+	err = request_irq(dev->irq, macb_interrupt, 0, dev->name, dev);
 	if (err) {
 		printk(KERN_ERR
 		       "%s: Unable to request IRQ %d (error %d)\n",
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index aef7728..51985d9 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -722,7 +722,7 @@ netxen_nic_request_irq(struct netxen_adapter *adapter)
 	struct nx_host_sds_ring *sds_ring;
 	int err, ring;
 
-	unsigned long flags = IRQF_SAMPLE_RANDOM;
+	unsigned long flags = 0;
 	struct net_device *netdev = adapter->netdev;
 	struct netxen_recv_context *recv_ctx = &adapter->recv_ctx;
 
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 2b17453..7db8b51 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -6068,8 +6068,7 @@ static int niu_request_irq(struct niu *np)
 		struct niu_ldg *lp = &np->ldg[i];
 
 		err = request_irq(lp->irq, niu_interrupt,
-				  IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-				  np->irq_name[i], lp);
+				  IRQF_SHARED, np->irq_name[i], lp);
 		if (err)
 			goto out_free_irqs;
 
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index cadc32c..1c51178 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -3601,7 +3601,7 @@ static int ql_adapter_up(struct ql3_adapter *qdev)
 {
 	struct net_device *ndev = qdev->ndev;
 	int err;
-	unsigned long irq_flags = IRQF_SAMPLE_RANDOM | IRQF_SHARED;
+	unsigned long irq_flags = IRQF_SHARED;
 	unsigned long hw_flags;
 
 	if (ql_alloc_mem_resources(qdev)) {
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 201be42..8b8c319 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -7556,12 +7556,12 @@ static int tg3_request_irq(struct tg3 *tp)
 		fn = tg3_msi;
 		if (tp->tg3_flags2 & TG3_FLG2_1SHOT_MSI)
 			fn = tg3_msi_1shot;
-		flags = IRQF_SAMPLE_RANDOM;
+		flags = 0;
 	} else {
 		fn = tg3_interrupt;
 		if (tp->tg3_flags & TG3_FLAG_TAGGED_STATUS)
 			fn = tg3_interrupt_tagged;
-		flags = IRQF_SHARED | IRQF_SAMPLE_RANDOM;
+		flags = IRQF_SHARED;
 	}
 	return (request_irq(tp->pdev->irq, fn, flags, dev->name, dev));
 }
@@ -7579,7 +7579,7 @@ static int tg3_test_interrupt(struct tg3 *tp)
 	free_irq(tp->pdev->irq, dev);
 
 	err = request_irq(tp->pdev->irq, tg3_test_isr,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err)
 		return err;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index f673253..8a16bdf 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1381,8 +1381,7 @@ static int setup_netfront(struct xenbus_device *dev, struct netfront_info *info)
 		goto fail;
 
 	err = bind_evtchn_to_irqhandler(info->evtchn, xennet_interrupt,
-					IRQF_SAMPLE_RANDOM, netdev->name,
-					netdev);
+					0, netdev->name, netdev);
 	if (err < 0)
 		goto fail;
 	netdev->irq = err;
