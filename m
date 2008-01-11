Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbYAKSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbYAKSL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbYAKSLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:11:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761105AbYAKSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:11:19 -0500
Date: Fri, 11 Jan 2008 18:08:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8390: split up 8390 with ISA delay and 8390 without
Message-ID: <20080111180848.10a7f012@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us remove port 0x80 use on the PCI systems. It also speeds up
some of the later 8390 based cores where we know the device does not need
delay loops either because it has internal handling or in most cases a
faster device anyway.

We compile up a new module 8390p to go with 8390 one with delays and one
without. Most users will never need 8390p so it seems best to produce two
modules.

Opinions ?

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/3c503.c linux-2.6.24-rc6-mm1/drivers/net/3c503.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/3c503.c	2008-01-02 16:03:59.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/3c503.c	2008-01-11 14:45:44.000000000 +0000
@@ -149,7 +149,7 @@
 #ifndef MODULE
 struct net_device * __init el2_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = alloc_eip_netdev();
 	int err;
 
 	if (!dev)
@@ -340,7 +340,7 @@
     dev->stop = &el2_close;
     dev->ethtool_ops = &netdev_ethtool_ops;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-    dev->poll_controller = ei_poll;
+    dev->poll_controller = eip_poll;
 #endif
 
     retval = register_netdev(dev);
@@ -386,7 +386,7 @@
 		outb_p(0x00, E33G_IDCFR);
 		if (*irqp == probe_irq_off(cookie)	/* It's a good IRQ line! */
 		    && ((retval = request_irq(dev->irq = *irqp,
-		    ei_interrupt, 0, dev->name, dev)) == 0))
+		    eip_interrupt, 0, dev->name, dev)) == 0))
 		    break;
 	    }
 	} while (*++irqp);
@@ -395,13 +395,13 @@
 	    return retval;
 	}
     } else {
-	if ((retval = request_irq(dev->irq, ei_interrupt, 0, dev->name, dev))) {
+	if ((retval = request_irq(dev->irq, eip_interrupt, 0, dev->name, dev))) {
 	    return retval;
 	}
     }
 
     el2_init_card(dev);
-    ei_open(dev);
+    eip_open(dev);
     return 0;
 }
 
@@ -412,7 +412,7 @@
     dev->irq = ei_status.saved_irq;
     outb(EGACFR_IRQOFF, E33G_GACFR);	/* disable interrupts. */
 
-    ei_close(dev);
+    eip_close(dev);
     return 0;
 }
 
@@ -698,7 +698,7 @@
 			if (this_dev != 0) break; /* only autoprobe 1st one */
 			printk(KERN_NOTICE "3c503.c: Presently autoprobing (not recommended) for a single card.\n");
 		}
-		dev = alloc_ei_netdev();
+		dev = alloc_eip_netdev();
 		if (!dev)
 			break;
 		dev->irq = irq[this_dev];
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/8390.h linux-2.6.24-rc6-mm1/drivers/net/8390.h
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/8390.h	2008-01-02 16:01:36.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/8390.h	2008-01-11 14:50:40.000000000 +0000
@@ -30,8 +30,10 @@
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern void ei_poll(struct net_device *dev);
+extern void eip_poll(struct net_device *dev);
 #endif
 
+/* Without I/O delay - non ISA or later chips */
 extern void NS8390_init(struct net_device *dev, int startp);
 extern int ei_open(struct net_device *dev);
 extern int ei_close(struct net_device *dev);
@@ -42,6 +44,17 @@
 	return __alloc_ei_netdev(0);
 }
 
+/* With I/O delay form */
+extern void NS8390p_init(struct net_device *dev, int startp);
+extern int eip_open(struct net_device *dev);
+extern int eip_close(struct net_device *dev);
+extern irqreturn_t eip_interrupt(int irq, void *dev_id);
+extern struct net_device *__alloc_eip_netdev(int size);
+static inline struct net_device *alloc_eip_netdev(void)
+{
+	return __alloc_eip_netdev(0);
+}
+
 /* You have one of these per-board */
 struct ei_device {
 	const char *name;
@@ -116,13 +129,14 @@
 /*
  *	Only generate indirect loads given a machine that needs them.
  *      - removed AMIGA_PCMCIA from this list, handled as ISA io now
+ *	- the _p for generates no delay by default 8390p.c overrides this.
  */
 
 #ifndef ei_inb
 #define ei_inb(_p)	inb(_p)
 #define ei_outb(_v,_p)	outb(_v,_p)
-#define ei_inb_p(_p)	inb_p(_p)
-#define ei_outb_p(_v,_p) outb_p(_v,_p)
+#define ei_inb_p(_p)	inb(_p)
+#define ei_outb_p(_v,_p) outb(_v,_p)
 #endif
 
 #ifndef EI_SHIFT
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/8390p.c linux-2.6.24-rc6-mm1/drivers/net/8390p.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/8390p.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc6-mm1/drivers/net/8390p.c	2008-01-11 14:52:33.000000000 +0000
@@ -0,0 +1,66 @@
+/* 8390 core for ISA devices needing bus delays */
+
+static const char version[] =
+    "8390p.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\n";
+
+#define ei_inb(_p)	inb(_p)
+#define ei_outb(_v,_p)	outb(_v,_p)
+#define ei_inb_p(_p)	inb_p(_p)
+#define ei_outb_p(_v,_p) outb_p(_v,_p)
+
+#include "lib8390.c"
+
+int eip_open(struct net_device *dev)
+{
+	return __ei_open(dev);
+}
+
+int eip_close(struct net_device *dev)
+{
+	return __ei_close(dev);
+}
+
+irqreturn_t eip_interrupt(int irq, void *dev_id)
+{
+	return __ei_interrupt(irq, dev_id);
+}
+
+#ifdef CONFIG_NET_POLL_CONTROLLER
+void eip_poll(struct net_device *dev)
+{
+	__ei_poll(dev);
+}
+#endif
+
+struct net_device *__alloc_eip_netdev(int size)
+{
+	return ____alloc_ei_netdev(size);
+}
+
+void NS8390p_init(struct net_device *dev, int startp)
+{
+	return __NS8390_init(dev, startp);
+}
+
+EXPORT_SYMBOL(eip_open);
+EXPORT_SYMBOL(eip_close);
+EXPORT_SYMBOL(eip_interrupt);
+#ifdef CONFIG_NET_POLL_CONTROLLER
+EXPORT_SYMBOL(eip_poll);
+#endif
+EXPORT_SYMBOL(NS8390p_init);
+EXPORT_SYMBOL(__alloc_eip_netdev);
+
+#if defined(MODULE)
+
+int init_module(void)
+{
+	return 0;
+}
+
+void cleanup_module(void)
+{
+}
+
+#endif /* MODULE */
+MODULE_LICENSE("GPL");
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c linux-2.6.24-rc6-mm1/drivers/net/hp.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-02 16:04:00.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-11 14:47:44.000000000 +0000
@@ -103,7 +103,7 @@
 #ifndef MODULE
 struct net_device * __init hp_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = alloc_eip_netdev();
 	int err;
 
 	if (!dev)
@@ -176,7 +176,7 @@
 				outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
 				outb_p( 0x00 | HP_RUN, ioaddr + HP_CONFIGURE);
 				if (irq == probe_irq_off(cookie)		 /* It's a good IRQ line! */
-					&& request_irq (irq, ei_interrupt, 0, DRV_NAME, dev) == 0) {
+					&& request_irq (irq, eip_interrupt, 0, DRV_NAME, dev) == 0) {
 					printk(" selecting IRQ %d.\n", irq);
 					dev->irq = *irqp;
 					break;
@@ -191,7 +191,7 @@
 	} else {
 		if (dev->irq == 2)
 			dev->irq = 9;
-		if ((retval = request_irq(dev->irq, ei_interrupt, 0, DRV_NAME, dev))) {
+		if ((retval = request_irq(dev->irq, eip_interrupt, 0, DRV_NAME, dev))) {
 			printk (" unable to get IRQ %d.\n", dev->irq);
 			goto out;
 		}
@@ -202,7 +202,7 @@
 	dev->open = &hp_open;
 	dev->stop = &hp_close;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	dev->poll_controller = ei_poll;
+	dev->poll_controller = eip_poll;
 #endif
 
 	ei_status.name = name;
@@ -231,14 +231,14 @@
 static int
 hp_open(struct net_device *dev)
 {
-	ei_open(dev);
+	eip_open(dev);
 	return 0;
 }
 
 static int
 hp_close(struct net_device *dev)
 {
-	ei_close(dev);
+	eip_close(dev);
 	return 0;
 }
 
@@ -421,7 +421,7 @@
 			if (this_dev != 0) break; /* only autoprobe 1st one */
 			printk(KERN_NOTICE "hp.c: Presently autoprobing (not recommended) for a single card.\n");
 		}
-		dev = alloc_ei_netdev();
+		dev = alloc_eip_netdev();
 		if (!dev)
 			break;
 		dev->irq = irq[this_dev];
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/Makefile linux-2.6.24-rc6-mm1/drivers/net/Makefile
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/Makefile	2008-01-02 16:04:20.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/Makefile	2008-01-11 14:44:10.000000000 +0000
@@ -105,11 +105,11 @@
 endif
 obj-$(CONFIG_68360_ENET) += 68360enet.o
 obj-$(CONFIG_WD80x3) += wd.o 8390.o
-obj-$(CONFIG_EL2) += 3c503.o 8390.o
-obj-$(CONFIG_NE2000) += ne.o 8390.o
+obj-$(CONFIG_EL2) += 3c503.o 8390p.o
+obj-$(CONFIG_NE2000) += ne.o 8390p.o
 obj-$(CONFIG_NE2_MCA) += ne2.o 8390.o
-obj-$(CONFIG_HPLAN) += hp.o 8390.o
-obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390.o
+obj-$(CONFIG_HPLAN) += hp.o 8390p.o
+obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_ULTRAMCA) += smc-mca.o 8390.o
 obj-$(CONFIG_ULTRA32) += smc-ultra32.o 8390.o
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/ne2.c linux-2.6.24-rc6-mm1/drivers/net/ne2.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/ne2.c	2008-01-02 16:04:00.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/ne2.c	2008-01-11 14:46:56.000000000 +0000
@@ -280,7 +280,7 @@
 #ifndef MODULE
 struct net_device * __init ne2_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = alloc_eip_netdev();
 	int err;
 
 	if (!dev)
@@ -457,7 +457,7 @@
 
 	/* Snarf the interrupt now.  There's no point in waiting since we cannot
 	   share and the board will usually be enabled. */
-	retval = request_irq(dev->irq, ei_interrupt, 0, DRV_NAME, dev);
+	retval = request_irq(dev->irq, eip_interrupt, 0, DRV_NAME, dev);
 	if (retval) {
 		printk (" unable to get IRQ %d (irqval=%d).\n",
 				dev->irq, retval);
@@ -497,7 +497,7 @@
 	dev->open = &ne_open;
 	dev->stop = &ne_close;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	dev->poll_controller = ei_poll;
+	dev->poll_controller = eip_poll;
 #endif
 	NS8390_init(dev, 0);
 
@@ -515,7 +515,7 @@
 
 static int ne_open(struct net_device *dev)
 {
-	ei_open(dev);
+	eip_open(dev);
 	return 0;
 }
 
@@ -523,7 +523,7 @@
 {
 	if (ei_debug > 1)
 		printk("%s: Shutting down ethercard.\n", dev->name);
-	ei_close(dev);
+	eip_close(dev);
 	return 0;
 }
 
@@ -781,7 +781,7 @@
 	int this_dev, found = 0;
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		dev = alloc_ei_netdev();
+		dev = alloc_eip_netdev();
 		if (!dev)
 			break;
 		dev->irq = irq[this_dev];
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/ne.c linux-2.6.24-rc6-mm1/drivers/net/ne.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/net/ne.c	2008-01-02 16:04:00.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/net/ne.c	2008-01-11 14:41:29.000000000 +0000
@@ -217,7 +217,7 @@
 #ifndef MODULE
 struct net_device * __init ne_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = alloc_eip_netdev();
 	int err;
 
 	if (!dev)
@@ -490,7 +490,7 @@
 
 	/* Snarf the interrupt now.  There's no point in waiting since we cannot
 	   share and the board will usually be enabled. */
-	ret = request_irq(dev->irq, ei_interrupt, 0, name, dev);
+	ret = request_irq(dev->irq, eip_interrupt, 0, name, dev);
 	if (ret) {
 		printk (" unable to get IRQ %d (errno=%d).\n", dev->irq, ret);
 		goto err_out;
@@ -534,7 +534,7 @@
 	dev->open = &ne_open;
 	dev->stop = &ne_close;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	dev->poll_controller = ei_poll;
+	dev->poll_controller = eip_poll;
 #endif
 	NS8390_init(dev, 0);
 
@@ -554,7 +554,7 @@
 
 static int ne_open(struct net_device *dev)
 {
-	ei_open(dev);
+	eip_open(dev);
 	return 0;
 }
 
@@ -562,7 +562,7 @@
 {
 	if (ei_debug > 1)
 		printk(KERN_DEBUG "%s: Shutting down ethercard.\n", dev->name);
-	ei_close(dev);
+	eip_close(dev);
 	return 0;
 }
 
@@ -814,7 +814,7 @@
 	if (!res || irq < 0)
 		return -ENODEV;
 
-	dev = alloc_ei_netdev();
+	dev = alloc_eip_netdev();
 	if (!dev)
 		return -ENOMEM;
 	dev->irq = irq;
@@ -912,7 +912,7 @@
 	int plat_found = !ne_init();
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		struct net_device *dev = alloc_ei_netdev();
+		struct net_device *dev = alloc_eip_netdev();
 		if (!dev)
 			break;
 		dev->irq = irq[this_dev];
