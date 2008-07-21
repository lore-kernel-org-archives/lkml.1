Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYGUOdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYGUOdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYGUOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:33:24 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51906 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYGUOdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:33:23 -0400
Date: Mon, 21 Jul 2008 23:35:12 +0900 (JST)
Message-Id: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] 8390: Fix ne.c build
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 055e5110ae0c0c1176a75b78d789294f2ff2f7af ("8390: Split
8390 support into a pausing and a non pausing driver core"), ne.c
cause this build failure:

drivers/built-in.o: In function `ne_probe1':
ne.c:(.init.text+0x2464): undefined reference to `NS8390_init'
drivers/built-in.o: In function `ne_block_output':
ne.c:(.text.ne_block_output+0x1b0): undefined reference to `NS8390_init'

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index 1412697..3df231d 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -536,7 +536,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = eip_poll;
 #endif
-	NS8390_init(dev, 0);
+	NS8390p_init(dev, 0);
 
 	ret = register_netdev(dev);
 	if (ret)
@@ -794,7 +794,7 @@ retry:
 		if (time_after(jiffies, dma_start + 2*HZ/100)) {		/* 20ms */
 			printk(KERN_WARNING "%s: timeout waiting for Tx RDC.\n", dev->name);
 			ne_reset_8390(dev);
-			NS8390_init(dev,1);
+			NS8390p_init(dev,1);
 			break;
 		}
 
@@ -855,7 +855,7 @@ static int ne_drv_resume(struct platform_device *pdev)
 
 	if (netif_running(dev)) {
 		ne_reset_8390(dev);
-		NS8390_init(dev, 1);
+		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
 	}
 	return 0;
