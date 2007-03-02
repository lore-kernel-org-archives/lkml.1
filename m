Return-Path: <linux-kernel-owner+w=401wt.eu-S1422867AbXCBFfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422867AbXCBFfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422913AbXCBFfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:35:10 -0500
Received: from main.gmane.org ([80.91.229.2]:33756 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422867AbXCBFfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:35:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giridhar Pemmasani <giri@lmc.cs.sunysb.edu>
Subject: [PATCH] mv643xx ethernet driver
Date: Thu, 01 Mar 2007 23:52:06 -0500
Message-ID: <es8ahm$64p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ool-18b86566.dyn.optonline.net
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

During initialization, mv643xx driver registers IRQ before setting up tx/rx
rings. This causes kernel oops because mv643xx_poll, which gets called
right after registering IRQ, calls netif_rx_complete, which accesses the rx
ring (I don't have the oops message anymore; I just remember this sequence
of calls). Attached (tested) patch first initializes the rx/tx rings and
then registers the IRQ.

Giri

Signed-off-by: Giridhar Pemmasani <pgiri@yahoo.com>

--- drivers/net/mv643xx_eth.c   2006-11-29 16:57:37.000000000 -0500
+++ ../linux-2.6.20.orig/drivers/net/mv643xx_eth.c      2007-02-23
09:38:21.000000000 -0500
@@ -778,14 +778,6 @@
        unsigned int size;
        int err;
 
-       err = request_irq(dev->irq, mv643xx_eth_int_handler,
-                       IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);
-       if (err) {
-               printk(KERN_ERR "Can not assign IRQ number to MV643XX_eth%d\n",
-                                                               port_num);
-               return -EAGAIN;
-       }
-
        eth_port_init(mp);
 
        memset(&mp->timeout, 0, sizeof(struct timer_list));
@@ -797,8 +789,7 @@
                                                                GFP_KERNEL);
        if (!mp->rx_skb) {
                printk(KERN_ERR "%s: Cannot allocate Rx skb ring\n", dev->name);
-               err = -ENOMEM;
-               goto out_free_irq;
+               return -ENOMEM;
        }
        mp->tx_skb = kmalloc(sizeof(*mp->tx_skb) * mp->tx_ring_size,
                                                                GFP_KERNEL);
@@ -852,13 +843,8 @@
                                                        dev->name, size);
                printk(KERN_ERR "%s: Freeing previously allocated TX queues...",
                                                        dev->name);
-               if (mp->rx_sram_size)
-                       iounmap(mp->p_tx_desc_area);
-               else
-                       dma_free_coherent(NULL, mp->tx_desc_area_size,
-                                       mp->p_tx_desc_area, mp->tx_desc_dma);
                err = -ENOMEM;
-               goto out_free_tx_skb;
+               goto out_free_tx_ring;
        }
        memset((void *)mp->p_rx_desc_area, 0, size);
 
@@ -866,6 +852,14 @@
 
        mv643xx_eth_rx_refill_descs(dev);       /* Fill RX ring with skb's */
 
+       err = request_irq(dev->irq, mv643xx_eth_int_handler,
+                         IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);
+       if (err) {
+               printk(KERN_ERR "Can not assign IRQ number to MV643XX_eth%d\n",
+                      port_num);
+               goto out_free_rx_ring;
+       }
+
        /* Clear any pending ethernet port interrupts */
        mv_write(MV643XX_ETH_INTERRUPT_CAUSE_REG(port_num), 0);
        mv_write(MV643XX_ETH_INTERRUPT_CAUSE_EXTEND_REG(port_num), 0);
@@ -891,12 +885,22 @@
 
        return 0;
 
+out_free_rx_ring:
+       if (mp->rx_sram_size)
+               iounmap(mp->p_rx_desc_area);
+       else
+               dma_free_coherent(NULL, mp->rx_desc_area_size,
+                                 mp->p_rx_desc_area, mp->rx_desc_dma);
+out_free_tx_ring:
+       if (mp->tx_sram_size)
+               iounmap(mp->p_tx_desc_area);
+       else
+               dma_free_coherent(NULL, mp->tx_desc_area_size,
+                                 mp->p_tx_desc_area, mp->tx_desc_dma);
 out_free_tx_skb:
        kfree(mp->tx_skb);
 out_free_rx_skb:
        kfree(mp->rx_skb);
-out_free_irq:
-       free_irq(dev->irq, dev);
 
        return err;
 }

