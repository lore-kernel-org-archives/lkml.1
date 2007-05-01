Return-Path: <linux-kernel-owner+w=401wt.eu-S1945960AbXEAUv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960AbXEAUv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423646AbXEAUlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:41:46 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:45709 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423643AbXEAUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:04 -0400
Message-Id: <20070501203337.471162729@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:33:02 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 28/33] SONIC: small fix and cleanup
Content-Disposition: inline; filename=mac68k-sonic-fixes.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Fix a potential problem in the timeout handling: don't free the DMA buffers
before resetting the chip.

Also a trivial cleanup. Bring macsonic and jazzsonic into sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/jazzsonic.c |    4 ++--
 drivers/net/macsonic.c  |   17 ++++++++---------
 drivers/net/sonic.c     |    7 ++++++-
 3 files changed, 16 insertions(+), 12 deletions(-)

--- linux-m68k-2.6.21.orig/drivers/net/jazzsonic.c
+++ linux-m68k-2.6.21/drivers/net/jazzsonic.c
@@ -269,11 +269,11 @@ static int __devexit jazz_sonic_device_r
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct sonic_local* lp = netdev_priv(dev);
 
-	unregister_netdev (dev);
+	unregister_netdev(dev);
 	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
 	                  lp->descriptors, lp->descriptors_laddr);
 	release_region (dev->base_addr, SONIC_MEM_SIZE);
-	free_netdev (dev);
+	free_netdev(dev);
 
 	return 0;
 }
--- linux-m68k-2.6.21.orig/drivers/net/macsonic.c
+++ linux-m68k-2.6.21/drivers/net/macsonic.c
@@ -522,7 +522,7 @@ int __init mac_nubus_sonic_probe(struct 
 	return macsonic_init(dev);
 }
 
-static int __init mac_sonic_probe(struct platform_device *device)
+static int __init mac_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
@@ -534,8 +534,8 @@ static int __init mac_sonic_probe(struct
 		return -ENOMEM;
 
 	lp = netdev_priv(dev);
-	lp->device = &device->dev;
-	SET_NETDEV_DEV(dev, &device->dev);
+	lp->device = &pdev->dev;
+	SET_NETDEV_DEV(dev, &pdev->dev);
  	SET_MODULE_OWNER(dev);
 
 	/* This will catch fatal stuff like -ENOMEM as well as success */
@@ -576,15 +576,15 @@ MODULE_PARM_DESC(sonic_debug, "macsonic 
 
 #include "sonic.c"
 
-static int __devexit mac_sonic_device_remove (struct platform_device *device)
+static int __devexit mac_sonic_device_remove (struct platform_device *pdev)
 {
-	struct net_device *dev = platform_get_drvdata(device);
+	struct net_device *dev = platform_get_drvdata(pdev);
 	struct sonic_local* lp = netdev_priv(dev);
 
-	unregister_netdev (dev);
+	unregister_netdev(dev);
 	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
 	                  lp->descriptors, lp->descriptors_laddr);
-	free_netdev (dev);
+	free_netdev(dev);
 
 	return 0;
 }
@@ -607,9 +607,8 @@ static int __init mac_sonic_init_module(
 	}
 
 	mac_sonic_device = platform_device_alloc(mac_sonic_string, 0);
-	if (!mac_sonic_device) {
+	if (!mac_sonic_device)
 		goto out_unregister;
-	}
 
 	if (platform_device_add(mac_sonic_device)) {
 		platform_device_put(mac_sonic_device);
--- linux-m68k-2.6.21.orig/drivers/net/sonic.c
+++ linux-m68k-2.6.21/drivers/net/sonic.c
@@ -178,8 +178,13 @@ static void sonic_tx_timeout(struct net_
 {
 	struct sonic_local *lp = netdev_priv(dev);
 	int i;
-	/* Stop the interrupts for this */
+	/*
+	 * put the Sonic into software-reset mode and
+	 * disable all interrupts before releasing DMA buffers
+	 */
 	SONIC_WRITE(SONIC_IMR, 0);
+	SONIC_WRITE(SONIC_ISR, 0x7fff);
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RST);
 	/* We could resend the original skbs. Easier to re-initialise. */
 	for (i = 0; i < SONIC_NUM_TDS; i++) {
 		if(lp->tx_laddr[i]) {

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

