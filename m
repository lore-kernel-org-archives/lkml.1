Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZCYMF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZCYMF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZCYMFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:05:12 -0400
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:12645 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752920AbZCYMFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:05:10 -0400
Message-ID: <49CA1DEB.5060007@eisendle.net>
Date: Wed, 25 Mar 2009 13:04:59 +0100
From: Christian Eisendle <lkml@eisendle.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: lanconelli.claudio@eptar.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] enc28j60: spend separate worker thread
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies enc28j60 driver to use its own workqueue instead of 
the default events worker thread for two reasons:

- There is a race condition between fb_flashcursor and con_open (vt.c)
   when using framebuffer device, NFS as rootfs and enc28j60 as NIC:
   fb_flashcursor as well as con_open acquires the console semaphore.
   At system startup, when con_open is called, there are filesystem
   accesses (e.g. vcs_make_sysfs) while the console semaphore is
   being held.
   fb_flashcursor, which is a work_struct handler of the
   events worker thread, waits for the console semaphore to be
   released and blocks the events worker thread meanwhile.
   con_open will never return since NFS access will
   never be successful as the enc28j60 uses also
   the events worker thread.

- IMHO enc28j60 should anyway use its own worker thread since all
   work_structs in this driver (including tx work which always waits
   for SPI) are blocking the defaults worker thread.


Signed-off-by: Christian Eisendle <lkml@eisendle.net>
---

--- linux-2.6.29/drivers/net/enc28j60.c.orig	2009-03-25 
12:05:33.000000000 +0100
+++ linux-2.6.29/drivers/net/enc28j60.c	2009-03-25 12:05:46.000000000 +0100
@@ -23,6 +23,7 @@
  #include <linux/errno.h>
  #include <linux/init.h>
  #include <linux/netdevice.h>
+#include <linux/workqueue.h>
  #include <linux/etherdevice.h>
  #include <linux/ethtool.h>
  #include <linux/tcp.h>
@@ -61,6 +62,7 @@ struct enc28j60_net {
  	struct spi_device *spi;
  	struct mutex lock;
  	struct sk_buff *tx_skb;
+	struct workqueue_struct	*workqueue;
  	struct work_struct tx_work;
  	struct work_struct irq_work;
  	struct work_struct setrx_work;
@@ -1297,7 +1299,7 @@ static int enc28j60_send_packet(struct s
  	priv->netdev->trans_start = jiffies;
  	/* Remember the skb for deferred processing */
  	priv->tx_skb = skb;
-	schedule_work(&priv->tx_work);
+	queue_work(priv->workqueue, &priv->tx_work);

  	return 0;
  }
@@ -1322,7 +1324,7 @@ static irqreturn_t enc28j60_irq(int irq,
  	 * Remember that we access enc28j60 registers through SPI bus
  	 * via spi_sync() call.
  	 */
-	schedule_work(&priv->irq_work);
+	queue_work(priv->workqueue, &priv->irq_work);

  	return IRQ_HANDLED;
  }
@@ -1336,7 +1338,7 @@ static void enc28j60_tx_timeout(struct n

  	ndev->stats.tx_errors++;
  	/* can't restart safely under softirq */
-	schedule_work(&priv->restart_work);
+	queue_work(priv->workqueue, &priv->restart_work);
  }

  /*
@@ -1424,7 +1426,7 @@ static void enc28j60_set_multicast_list(
  	}

  	if (oldfilter != priv->rxfilter)
-		schedule_work(&priv->setrx_work);
+		queue_work(priv->workqueue, &priv->setrx_work);
  }

  static void enc28j60_setrx_work_handler(struct work_struct *work)
@@ -1567,6 +1569,11 @@ static int __devinit enc28j60_probe(stru
  	priv->msg_enable = netif_msg_init(debug.msg_enable,
  						ENC28J60_MSG_DEFAULT);
  	mutex_init(&priv->lock);
+	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (priv->workqueue == NULL) {
+		dev_err(&spi->dev, "Unable to create work queue\n");
+		goto out_noqueue;
+	}
  	INIT_WORK(&priv->tx_work, enc28j60_tx_work_handler);
  	INIT_WORK(&priv->setrx_work, enc28j60_setrx_work_handler);
  	INIT_WORK(&priv->irq_work, enc28j60_irq_work_handler);
@@ -1616,6 +1623,8 @@ static int __devinit enc28j60_probe(stru
  error_register:
  	free_irq(spi->irq, priv);
  error_irq:
+	destroy_workqueue(priv->workqueue);
+out_noqueue:
  	free_netdev(dev);
  error_alloc:
  	return ret;
@@ -1627,6 +1636,7 @@ static int __devexit enc28j60_remove(str

  	if (netif_msg_drv(priv))
  		printk(KERN_DEBUG DRV_NAME ": remove\n");
+	destroy_workqueue(priv->workqueue);

  	unregister_netdev(priv->netdev);
  	free_irq(spi->irq, priv);
