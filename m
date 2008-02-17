Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbYBQLwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbYBQLwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYBQLwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:52:04 -0500
Received: from mx1.riseup.net ([204.13.164.18]:40009 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYBQLwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:52:01 -0500
Date: Sun, 17 Feb 2008 12:52:15 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: kas@fi.muni.cz
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] COSA/SRP: Convert channel_data.rsem to mutex
Message-ID: <20080217115215.GA21818@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>, kas@fi.muni.cz,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COSA/SRP driver: The semaphore channel_data.rsem is used as a mutex,
convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

Index: linux-2.6/drivers/net/wan/cosa.c
===================================================================
--- linux-2.6.orig/drivers/net/wan/cosa.c	2008-02-17 12:41:34.000000000 +0100
+++ linux-2.6/drivers/net/wan/cosa.c	2008-02-17 12:42:37.000000000 +0100
@@ -90,6 +90,7 @@
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 
 #undef COSA_SLOW_IO	/* for testing purposes only */
@@ -127,7 +128,8 @@
 	int (*tx_done)(struct channel_data *channel, int size);
 
 	/* Character device parts */
-	struct semaphore rsem, wsem;
+	struct mutex rlock;
+	struct semaphore wsem;
 	char *rxdata;
 	int rxsize;
 	wait_queue_head_t txwaitq, rxwaitq;
@@ -807,7 +809,7 @@
 
 static void chardev_channel_init(struct channel_data *chan)
 {
-	init_MUTEX(&chan->rsem);
+	mutex_init(&chan->rlock);
 	init_MUTEX(&chan->wsem);
 }
 
@@ -825,12 +827,12 @@
 			cosa->name, cosa->firmware_status);
 		return -EPERM;
 	}
-	if (down_interruptible(&chan->rsem))
+	if (mutex_lock_interruptible(&chan->rlock))
 		return -ERESTARTSYS;
 	
 	if ((chan->rxdata = kmalloc(COSA_MTU, GFP_DMA|GFP_KERNEL)) == NULL) {
 		printk(KERN_INFO "%s: cosa_read() - OOM\n", cosa->name);
-		up(&chan->rsem);
+		mutex_unlock(&chan->rlock);
 		return -ENOMEM;
 	}
 
@@ -848,7 +850,7 @@
 			remove_wait_queue(&chan->rxwaitq, &wait);
 			current->state = TASK_RUNNING;
 			spin_unlock_irqrestore(&cosa->lock, flags);
-			up(&chan->rsem);
+			mutex_unlock(&chan->rlock);
 			return -ERESTARTSYS;
 		}
 	}
@@ -857,7 +859,7 @@
 	kbuf = chan->rxdata;
 	count = chan->rxsize;
 	spin_unlock_irqrestore(&cosa->lock, flags);
-	up(&chan->rsem);
+	mutex_unlock(&chan->rlock);
 
 	if (copy_to_user(buf, kbuf, count)) {
 		kfree(kbuf);

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
