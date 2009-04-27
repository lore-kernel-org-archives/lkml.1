Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZD0MRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZD0MRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZD0MRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:17:25 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:57487 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZD0MRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:17:24 -0400
Date: Mon, 27 Apr 2009 09:16:33 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: [PATCH] powerpc: convert mace to netdev_ops (was: Re: [2.6.30-rc3]
	powerpc: compilation error of mace module)
Message-ID: <20090427121633.GA29608@ime.usp.br>
References: <20090426155708.GA23159@ime.usp.br> <20090426.230648.254087966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090426.230648.254087966.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave.

On Apr 26 2009, David Miller wrote:
> Or, if you're bored, feel free to convert the mace driver over
> to netdev_ops :-)

Is this anything close to what needs to be done? It's not without
failures, because the function mace_set_timeout receives a pointer to a
struct net_device, but is marked inline and is used by mace_tx_timeout,
which receives an unsigned long (which calls mace_set_timeout).

Perhaps it would be a case of removing the inline hint to the compiler?
I guess that BenH or Paul could comment here better...


Signed-off-by: Rogério Brito <rbrito@ime.usp.br>

---
--- a/drivers/net/mace.c	2008-12-29 15:25:15.000000000 -0200
+++ b/drivers/net/mace.c	2009-04-27 08:54:16.000000000 -0300
@@ -89,6 +89,16 @@ static inline void dbdma_reset(volatile 
 static inline void mace_clean_rings(struct mace_data *mp);
 static void __mace_set_address(struct net_device *dev, void *addr);
 
+/* Conversion to netdev_ops. */
+static const struct net_device_ops mace_netdev_ops = {
+	.ndo_open		= mace_open,
+	.ndo_stop		= mace_close,
+	.ndo_start_xmit		= mace_xmit_start,
+	.ndo_tx_timeout		= mace_set_timeout,
+	.ndo_set_multicast_list	= mace_set_multicast,
+	.ndo_set_mac_address	= mace_set_address,
+};
+
 /*
  * If we can't get a skbuff when we need it, we use this area for DMA.
  */
@@ -208,11 +217,7 @@ static int __devinit mace_probe(struct m
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

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
