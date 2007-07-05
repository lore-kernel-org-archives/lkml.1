Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXGENJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXGENJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbXGENJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:09:13 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:46982 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758690AbXGENJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:09:12 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@lists.osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] potential compiler error, irqfunc caller sites update
Date: Thu, 05 Jul 2007 15:08:40 +0200
Message-ID: <871wfnj8vb.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In 7d12e780e003f93433d49ce78cfedf4b4c52adc5 David Howells performed
this evolution: 
 "IRQ: Maintain regs pointer globally rather than passing to IRQ handlers"

He correctly updated many of the function definitions that were using
this extra regs pointer parameter but forgot to update some caller
sites of those functions. The reason the modifications was not
properly done on all drivers is that some drivers were rarely compiled
because they are for AMIGA, or that some code sites were inside
#ifdefs where the option is not set or inside #if 0.

Here is the semantic patch that found the occurences 
and fixed the problem.

@ rule1 @
identifier fn;
identifier irq, dev_id;
typedef irqreturn_t;
@@

static irqreturn_t fn(int irq, void *dev_id) 
{
   ...
}

@@
identifier rule1.fn;
expression E1, E2, E3;
@@

 fn(E1, E2
-   ,E3
   )

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 



diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 7f6d02c..38b688f 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1654,7 +1654,7 @@ static void fs_poll (unsigned long data)
 {
 	struct fs_dev *dev = (struct fs_dev *) data;
   
-	fs_irq (0, dev, NULL);
+	fs_irq (0, dev);
 	dev->timer.expires = jiffies + FS_POLL_FREQ;
 	add_timer (&dev->timer);
 }
diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index 8f0d7ce..2143eeb 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -634,7 +634,7 @@ static void am79c961_poll_controller(str
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	am79c961_interrupt(dev->irq, dev, NULL);
+	am79c961_interrupt(dev->irq, dev);
 	local_irq_restore(flags);
 }
 #endif
diff --git a/drivers/net/ixp2000/ixpdev.c b/drivers/net/ixp2000/ixpdev.c
index 6683afc..d5f694f 100644
--- a/drivers/net/ixp2000/ixpdev.c
+++ b/drivers/net/ixp2000/ixpdev.c
@@ -222,7 +222,7 @@ #ifdef CONFIG_NET_POLL_CONTROLLER
 static void ixpdev_poll_controller(struct net_device *dev)
 {
 	disable_irq(IRQ_IXP2000_THDA0);
-	ixpdev_interrupt(IRQ_IXP2000_THDA0, dev, NULL);
+	ixpdev_interrupt(IRQ_IXP2000_THDA0, dev);
 	enable_irq(IRQ_IXP2000_THDA0);
 }
 #endif
diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 132e214..e7fdcf1 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -1159,7 +1159,7 @@ static void sbmac_netpoll(struct net_dev
 
 	__raw_writeq(0, sc->sbm_imr);
 
-	sbmac_intr(irq, netdev, NULL);
+	sbmac_intr(irq, netdev);
 
 #ifdef CONFIG_SBMAC_COALESCE
 	__raw_writeq(((M_MAC_INT_EOP_COUNT | M_MAC_INT_EOP_TIMER) << S_MAC_TX_CH0) |
diff --git a/drivers/scsi/53c7xx.c b/drivers/scsi/53c7xx.c
index 93b41f4..45097fb 100644
--- a/drivers/scsi/53c7xx.c
+++ b/drivers/scsi/53c7xx.c
@@ -5177,7 +5177,7 @@ #endif
     if (NCR53c7x0_read8(hostdata->istat) & (ISTAT_DIP|ISTAT_SIP)) {
 	printk ("scsi%d : dropped interrupt for command %ld\n", host->host_no,
 	    cmd->pid);
-	NCR53c7x0_intr (host->irq, NULL, NULL);
+	NCR53c7x0_intr (host->irq, NULL);
 	return SCSI_ABORT_BUSY;
     }
 	
diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 7025025..1a60f9c 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -336,7 +336,7 @@ static int uss720_irq(int usbstatus, voi
 	memcpy(priv->reg, buffer, 4);
 	/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 	if (priv->reg[2] & priv->reg[1] & 0x10)
-		parport_generic_irq(0, pp, NULL);
+		parport_generic_irq(0, pp);
 	return 1;
 }
 #endif

