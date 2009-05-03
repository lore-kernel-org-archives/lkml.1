Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZECLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZECLtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZECLtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:49:08 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:34621 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZECLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:49:07 -0400
Date: Sun, 3 May 2009 08:48:20 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: [PATCH] powerpc: convert mace to netdev_ops
Message-ID: <20090503114820.GA14926@ime.usp.br>
References: <20090426155708.GA23159@ime.usp.br> <20090426.230648.254087966.davem@davemloft.net> <20090427121633.GA29608@ime.usp.br> <20090427.054258.16622932.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090427.054258.16622932.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave.

On Apr 27 2009, David Miller wrote:
> You can fix the mace_set_timeout() function arguments by having
> a helper function that simply wraps around it and provides the
> second expection of argument types.

I hope that this version is a slightly better fix to convert mace to
netdev_ops.

This is against this morning's net-2.6 tree.


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
---
diff --git a/drivers/net/mace.c b/drivers/net/mace.c
index feebbd9..03a179d 100644
--- a/drivers/net/mace.c
+++ b/drivers/net/mace.c
@@ -89,6 +89,19 @@ static inline void dbdma_reset(volatile struct dbdma_regs __iomem *dma);
 static inline void mace_clean_rings(struct mace_data *mp);
 static void __mace_set_address(struct net_device *dev, void *addr);
 
+/* Conversion to netdev_ops. */
+static const struct net_device_ops mace_netdev_ops = {
+	.ndo_open		= mace_open,
+	.ndo_stop		= mace_close,
+	.ndo_start_xmit		= mace_xmit_start,
+	.ndo_tx_timeout		= mace_tx_timeout,
+	.ndo_set_multicast_list	= mace_set_multicast,
+	.ndo_set_mac_address	= mace_set_address,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 /*
  * If we can't get a skbuff when we need it, we use this area for DMA.
  */
@@ -207,11 +220,7 @@ static int __devinit mace_probe(struct macio_dev *mdev, const struct of_device_i
 		}
 	}
 
-	dev->open = mace_open;
-	dev->stop = mace_close;
-	dev->hard_start_xmit = mace_xmit_start;
-	dev->set_multicast_list = mace_set_multicast;
-	dev->set_mac_address = mace_set_address;
+	dev->netdev_ops = &mace_netdev_ops;
 
 	/*
 	 * Most of what is below could be moved to mace_open()
@@ -798,6 +807,13 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
     return IRQ_HANDLED;
 }
 
+/*
+ * In the following, the parameter "data" is treated like a pointer,
+ * which is probably OK for 32 bit arches, but not for 64.
+ *
+ * (Are mace's found on any newer machines??) -- rbrito
+ *
+ */
 static void mace_tx_timeout(unsigned long data)
 {
     struct net_device *dev = (struct net_device *) data;


-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
