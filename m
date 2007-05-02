Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXEBDRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXEBDRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXEBDRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:17:34 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:40744 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbXEBDRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:17:33 -0400
X-Greylist: delayed 1294 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 23:17:32 EDT
Date: Wed, 2 May 2007 12:55:56 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 29/33] SONIC interrupt handling, v4
In-Reply-To: <20070501211243.GA27018@infradead.org>
Message-ID: <Pine.LNX.4.64.0705021249160.18686@loopy.telegraphics.com.au>
References: <20070501203234.252205858@mail.of.borg> <20070501203337.746958387@mail.of.borg>
 <20070501211243.GA27018@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Install the built-in macsonic interrupt handler on both IRQs when using 
via_alt_mapping. Otherwise the rare interrupt that still comes from the 
nubus slot will wedge the nubus.

$ cat /proc/interrupts
auto       2:      89176 via2
auto       3:     744367 sonic
auto       4:          0 scc
auto       6:     318363 via1
auto       7:          0 NMI
mac        9:     119413 framebuffer vbl
mac       10:       1971 ADB
mac       14:     198517 timer
mac       17:      89104 nubus
mac       19:         72 Mac ESP SCSI
mac       56:        629 sonic
mac       62:    1142593 ide0

Version 1 of this patch had a bug where a nubus sonic card would register 
two interrupt handlers. Only a built-in sonic needs both.
  
Versions 2 and 3 needed some cleanups, as Raylynn Knight and Christoph 
Hellwig pointed out (thanks).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

 drivers/net/jazzsonic.c |   23 +++++++++++++++++++----
 drivers/net/macsonic.c  |   46 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/sonic.c     |   25 -------------------------
 3 files changed, 61 insertions(+), 33 deletions(-)

Index: linux-2.6.21/drivers/net/jazzsonic.c
===================================================================
--- linux-2.6.21.orig/drivers/net/jazzsonic.c	2007-05-02 11:32:01.000000000 +1000
+++ linux-2.6.21/drivers/net/jazzsonic.c	2007-05-02 11:34:23.000000000 +1000
@@ -88,6 +88,23 @@ static unsigned short known_revisions[] 
 	0xffff			/* end of list */
 };
 
+static int jazzsonic_open(struct net_device* dev)
+{
+	if (request_irq(dev->irq, &sonic_interrupt, IRQF_DISABLED, "sonic", dev)) {
+		printk(KERN_ERR "%s: unable to get IRQ %d.\n", dev->name, dev->irq);
+		return -EAGAIN;
+	}
+	return sonic_open(dev);
+}
+
+static int jazzsonic_close(struct net_device* dev)
+{
+	int err;
+	err = sonic_close(dev);
+	free_irq(dev->irq, dev);
+	return err;
+}
+
 static int __init sonic_probe1(struct net_device *dev)
 {
 	static unsigned version_printed;
@@ -169,8 +186,8 @@ static int __init sonic_probe1(struct ne
 	lp->rra_laddr = lp->rda_laddr + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
 	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
 
-	dev->open = sonic_open;
-	dev->stop = sonic_close;
+	dev->open = jazzsonic_open;
+	dev->stop = jazzsonic_close;
 	dev->hard_start_xmit = sonic_send_packet;
 	dev->get_stats = sonic_get_stats;
 	dev->set_multicast_list = &sonic_multicast_list;
@@ -260,8 +277,6 @@ MODULE_DESCRIPTION("Jazz SONIC ethernet 
 module_param(sonic_debug, int, 0);
 MODULE_PARM_DESC(sonic_debug, "jazzsonic debug level (1-4)");
 
-#define SONIC_IRQ_FLAG IRQF_DISABLED
-
 #include "sonic.c"
 
 static int __devexit jazz_sonic_device_remove (struct platform_device *pdev)
Index: linux-2.6.21/drivers/net/macsonic.c
===================================================================
--- linux-2.6.21.orig/drivers/net/macsonic.c	2007-05-02 11:32:01.000000000 +1000
+++ linux-2.6.21/drivers/net/macsonic.c	2007-05-02 12:35:09.000000000 +1000
@@ -130,6 +130,46 @@ static inline void bit_reverse_addr(unsi
 		addr[i] = bitrev8(addr[i]);
 }
 
+static irqreturn_t macsonic_interrupt(int irq, void *dev_id)
+{
+	irqreturn_t result;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	result = sonic_interrupt(irq, dev_id);
+	local_irq_restore(flags);
+	return result;
+}
+
+static int macsonic_open(struct net_device* dev)
+{
+	if (request_irq(dev->irq, &sonic_interrupt, IRQ_FLG_FAST, "sonic", dev)) {
+		printk(KERN_ERR "%s: unable to get IRQ %d.\n", dev->name, dev->irq);
+		return -EAGAIN;
+	}
+	/* Under the A/UX interrupt scheme, the onboard SONIC interrupt comes
+	 * in at priority level 3. However, we sometimes get the level 2 inter-
+	 * rupt as well, which must prevent re-entrance of the sonic handler.
+	 */
+	if (dev->irq == IRQ_AUTO_3)
+		if (request_irq(IRQ_NUBUS_9, &macsonic_interrupt, IRQ_FLG_FAST, "sonic", dev)) {
+			printk(KERN_ERR "%s: unable to get IRQ %d.\n", dev->name, IRQ_NUBUS_9);
+			free_irq(dev->irq, dev);
+			return -EAGAIN;
+		}
+	return sonic_open(dev);
+}
+
+static int macsonic_close(struct net_device* dev)
+{
+	int err;
+	err = sonic_close(dev);
+	free_irq(dev->irq, dev);
+	if (dev->irq == IRQ_AUTO_3)
+		free_irq(IRQ_NUBUS_9, dev);
+	return err;
+}
+
 int __init macsonic_init(struct net_device* dev)
 {
 	struct sonic_local* lp = netdev_priv(dev);
@@ -160,8 +200,8 @@ int __init macsonic_init(struct net_devi
 	lp->rra_laddr = lp->rda_laddr + (SIZEOF_SONIC_RD * SONIC_NUM_RDS
 	                     * SONIC_BUS_SCALE(lp->dma_bitmode));
 
-	dev->open = sonic_open;
-	dev->stop = sonic_close;
+	dev->open = macsonic_open;
+	dev->stop = macsonic_close;
 	dev->hard_start_xmit = sonic_send_packet;
 	dev->get_stats = sonic_get_stats;
 	dev->set_multicast_list = &sonic_multicast_list;
@@ -572,8 +612,6 @@ MODULE_DESCRIPTION("Macintosh SONIC ethe
 module_param(sonic_debug, int, 0);
 MODULE_PARM_DESC(sonic_debug, "macsonic debug level (1-4)");
 
-#define SONIC_IRQ_FLAG IRQ_FLG_FAST
-
 #include "sonic.c"
 
 static int __devexit mac_sonic_device_remove (struct platform_device *pdev)
Index: linux-2.6.21/drivers/net/sonic.c
===================================================================
--- linux-2.6.21.orig/drivers/net/sonic.c	2007-05-02 11:32:01.000000000 +1000
+++ linux-2.6.21/drivers/net/sonic.c	2007-05-02 11:32:02.000000000 +1000
@@ -50,29 +50,6 @@ static int sonic_open(struct net_device 
 	if (sonic_debug > 2)
 		printk("sonic_open: initializing sonic driver.\n");
 
-	/*
-	 * We don't need to deal with auto-irq stuff since we
-	 * hardwire the sonic interrupt.
-	 */
-/*
- * XXX Horrible work around:  We install sonic_interrupt as fast interrupt.
- * This means that during execution of the handler interrupt are disabled
- * covering another bug otherwise corrupting data.  This doesn't mean
- * this glue works ok under all situations.
- *
- * Note (dhd): this also appears to prevent lockups on the Macintrash
- * when more than one Ethernet card is installed (knock on wood)
- *
- * Note (fthain): whether the above is still true is anyones guess. Certainly
- * the buffer handling algorithms will not tolerate re-entrance without some
- * mutual exclusion added. Anyway, the memcpy has now been eliminated from the
- * rx code to make this a faster "fast interrupt".
- */
-	if (request_irq(dev->irq, &sonic_interrupt, SONIC_IRQ_FLAG, "sonic", dev)) {
-		printk(KERN_ERR "\n%s: unable to get IRQ %d .\n", dev->name, dev->irq);
-		return -EAGAIN;
-	}
-
 	for (i = 0; i < SONIC_NUM_RRS; i++) {
 		struct sk_buff *skb = dev_alloc_skb(SONIC_RBSIZE + 2);
 		if (skb == NULL) {
@@ -170,8 +147,6 @@ static int sonic_close(struct net_device
 		}
 	}
 
-	free_irq(dev->irq, dev);	/* release the IRQ */
-
 	return 0;
 }
 

