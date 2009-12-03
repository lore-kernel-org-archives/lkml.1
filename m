Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZLCVUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZLCVUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZLCVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:20:12 -0500
Received: from p01c11o147.mxlogic.net ([208.65.144.70]:46511 "EHLO
	p01c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZLCVUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:20:11 -0500
X-MXL-Hash: 4b182b92639e0ad4-a983eae7c1253380412aa9d433c82e726cf6e729
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.32 2/3] net: Fix ks8851 snl transmit problem
Date: Thu, 3 Dec 2009 13:17:48 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A41@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.32 2/3] net: Fix ks8851 snl transmit problem
Thread-Index: Acp0XhBSLUE4QjZiQmeHe0FClnVRmQ==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Ben Dooks" <ben@simtec.co.uk>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Dec 2009 21:17:48.0893 (UTC) FILETIME=[10ABE8D0:01CA745E]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=Ki-VXRIJiUUA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=25f3cJ-BANjovUbLHX0A:9 a=oGsQxZ9fENHNBX]
X-AnalysisOut: [oc8_EA:7 a=xW_zJYDuc8fGKDPAYm2gRIU-apQA:4 a=yJsD6ztlz_8A:1]
X-AnalysisOut: [0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

This fixes a transmit problem of the ks8851 snl network driver.  Under heavy TCP traffic the device will stop transmitting.  Turning off the transmit interrupt avoids this issue.  A new workqueue was implemented to replace the functionality of the transmit interrupt processing.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
diff -urpN linux-2.6.32.old/drivers/net/ks8851.c linux-2.6.32.new/drivers/net/ks8851.c
--- linux-2.6.32.old/drivers/net/ks8851.c	2009-11-03 11:37:49.000000000 -0800
+++ linux-2.6.32.new/drivers/net/ks8851.c	2009-12-02 15:31:39.000000000 -0800
@@ -111,11 +111,13 @@ struct ks8851_net {
 	struct mii_if_info	mii;
 	struct ks8851_rxctrl	rxctrl;
 
+	struct work_struct	tx_check;
 	struct work_struct	tx_work;
 	struct work_struct	irq_work;
 	struct work_struct	rxctrl_work;
 
 	struct sk_buff_head	txq;
+	int			tx_len;
 
 	struct spi_message	spi_msg1;
 	struct spi_message	spi_msg2;
@@ -573,19 +575,6 @@ static void ks8851_irq_work(struct work_
 	if (status & IRQ_RXPSI)
 		handled |= IRQ_RXPSI;
 
-	if (status & IRQ_TXI) {
-		handled |= IRQ_TXI;
-
-		/* no lock here, tx queue should have been stopped */
-
-		/* update our idea of how much tx space is available to the
-		 * system */
-		ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
-
-		if (netif_msg_intr(ks))
-			ks_dbg(ks, "%s: txspace %d\n", __func__, ks->tx_space);
-	}
-
 	if (status & IRQ_RXI)
 		handled |= IRQ_RXI;
 
@@ -623,9 +612,6 @@ static void ks8851_irq_work(struct work_
 
 	mutex_unlock(&ks->lock);
 
-	if (status & IRQ_TXI)
-		netif_wake_queue(ks->netdev);
-
 	enable_irq(ks->netdev->irq);
 }
 
@@ -703,6 +689,17 @@ static void ks8851_done_tx(struct ks8851
 	dev_kfree_skb(txb);
 }
 
+static void ks8851_tx_check(struct work_struct *work)
+{
+	struct ks8851_net *ks = container_of(work, struct ks8851_net, tx_check);
+
+	ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
+	if (ks->tx_space > ks->tx_len)
+		netif_wake_queue(ks->netdev);
+	else
+		schedule_work(&ks->tx_check);
+}
+
 /**
  * ks8851_tx_work - process tx packet(s)
  * @work: The work strucutre what was scheduled.
@@ -814,7 +811,6 @@ static int ks8851_net_open(struct net_de
 	/* clear then enable interrupts */
 
 #define STD_IRQ (IRQ_LCI |	/* Link Change */	\
-		 IRQ_TXI |	/* TX done */		\
 		 IRQ_RXI |	/* RX done */		\
 		 IRQ_SPIBEI |	/* SPI bus error */	\
 		 IRQ_TXPSI |	/* TX process stop */	\
@@ -830,6 +826,7 @@ static int ks8851_net_open(struct net_de
 		ks_dbg(ks, "network device %s up\n", dev->name);
 
 	mutex_unlock(&ks->lock);
+	ks8851_write_mac_addr(dev);
 	return 0;
 }
 
@@ -854,6 +851,7 @@ static int ks8851_net_stop(struct net_de
 
 	/* stop any outstanding work */
 	flush_work(&ks->irq_work);
+	flush_work(&ks->tx_check);
 	flush_work(&ks->tx_work);
 	flush_work(&ks->rxctrl_work);
 
@@ -912,14 +910,16 @@ static netdev_tx_t ks8851_start_xmit(str
 
 	if (needed > ks->tx_space) {
 		netif_stop_queue(dev);
+		ks->tx_len = needed;
+		schedule_work(&ks->tx_check);
 		ret = NETDEV_TX_BUSY;
 	} else {
 		ks->tx_space -= needed;
 		skb_queue_tail(&ks->txq, skb);
+		schedule_work(&ks->tx_work);
 	}
 
 	spin_unlock(&ks->statelock);
-	schedule_work(&ks->tx_work);
 
 	return ret;
 }
@@ -1229,6 +1229,7 @@ static int __devinit ks8851_probe(struct
 	mutex_init(&ks->lock);
 	spin_lock_init(&ks->statelock);
 
+	INIT_WORK(&ks->tx_check, ks8851_tx_check);
 	INIT_WORK(&ks->tx_work, ks8851_tx_work);
 	INIT_WORK(&ks->irq_work, ks8851_irq_work);
 	INIT_WORK(&ks->rxctrl_work, ks8851_rxctrl_work);
@@ -1281,6 +1282,7 @@ static int __devinit ks8851_probe(struct
 
 	ks8851_read_selftest(ks);
 	ks8851_init_mac(ks);
+	ks->tx_space = ks8851_rdreg16(ks, KS_TXMIR);
 
 	ret = request_irq(spi->irq, ks8851_irq, IRQF_TRIGGER_LOW,
 			  ndev->name, ks);
