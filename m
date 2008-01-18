Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYARUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYARUXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759156AbYARUXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:23:03 -0500
Received: from ozlabs.org ([203.10.76.45]:35079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758999AbYARUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:23:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Improve type handling in interrupt handlers
Date: Sat, 19 Jan 2008 07:22:25 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190722.26154.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This improves typechecking of interrupt handlers by removing
unnecessary (void *) casts and storing handlers in correctly-typed
variables.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Ash Willis <ashwillis@programmer.net>
Cc: linux-pcmcia@lists.infradead.org
---
 drivers/net/e1000/e1000_main.c |    2 +-
 drivers/net/e1000e/netdev.c    |    2 +-
 drivers/net/eth16i.c           |    2 +-
 drivers/net/ewrk3.c            |    2 +-
 drivers/net/skfp/skfddi.c      |    2 +-
 include/pcmcia/cs.h            |    2 +-
 sound/pci/als300.c             |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -r 0fe1a980708b drivers/net/eth16i.c
--- a/drivers/net/eth16i.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/drivers/net/eth16i.c	Thu Jan 17 15:42:00 2008 +1100
@@ -529,7 +529,7 @@ static int __init eth16i_probe1(struct n
 
 	/* Try to obtain interrupt vector */
 
-	if ((retval = request_irq(dev->irq, (void *)&eth16i_interrupt, 0, cardname, dev))) {
+	if ((retval = request_irq(dev->irq, eth16i_interrupt, 0, cardname, dev))) {
 		printk(KERN_WARNING "%s at %#3x, but is unusable due to conflicting IRQ %d.\n",
 		       cardname, ioaddr, dev->irq);
 		goto out;
diff -r 0fe1a980708b drivers/net/ewrk3.c
--- a/drivers/net/ewrk3.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/drivers/net/ewrk3.c	Thu Jan 17 15:42:00 2008 +1100
@@ -635,7 +635,7 @@ static int ewrk3_open(struct net_device 
 	STOP_EWRK3;
 
 	if (!lp->hard_strapped) {
-		if (request_irq(dev->irq, (void *) ewrk3_interrupt, 0, "ewrk3", dev)) {
+		if (request_irq(dev->irq, ewrk3_interrupt, 0, "ewrk3", dev)) {
 			printk("ewrk3_open(): Requested IRQ%d is busy\n", dev->irq);
 			status = -EAGAIN;
 		} else {
diff -r 0fe1a980708b drivers/net/skfp/skfddi.c
--- a/drivers/net/skfp/skfddi.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/drivers/net/skfp/skfddi.c	Thu Jan 17 15:42:00 2008 +1100
@@ -495,7 +495,7 @@ static int skfp_open(struct net_device *
 
 	PRINTK(KERN_INFO "entering skfp_open\n");
 	/* Register IRQ - support shared interrupts by passing device ptr */
-	err = request_irq(dev->irq, (void *) skfp_interrupt, IRQF_SHARED,
+	err = request_irq(dev->irq, skfp_interrupt, IRQF_SHARED,
 			  dev->name, dev);
 	if (err)
 		return err;
diff -r 0fe1a980708b include/pcmcia/cs.h
--- a/include/pcmcia/cs.h	Thu Jan 17 14:48:56 2008 +1100
+++ b/include/pcmcia/cs.h	Thu Jan 17 15:42:01 2008 +1100
@@ -170,7 +170,7 @@ typedef struct irq_req_t {
     u_int	Attributes;
     u_int	AssignedIRQ;
     u_int	IRQInfo1, IRQInfo2; /* IRQInfo2 is ignored */
-    void	*Handler;
+    int		(*Handler)(int, void *);
     void	*Instance;
 } irq_req_t;
 
diff -r 0fe1a980708b sound/pci/als300.c
--- a/sound/pci/als300.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/sound/pci/als300.c	Thu Jan 17 15:42:01 2008 +1100
@@ -678,7 +678,7 @@ static int __devinit snd_als300_create(s
 				       struct snd_als300 **rchip)
 {
 	struct snd_als300 *chip;
-	void *irq_handler;
+	int (*irq_handler)(int, void *);
 	int err;
 
 	static struct snd_device_ops ops = {
diff -r 0fe1a980708b drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/drivers/net/e1000e/netdev.c	Thu Jan 17 15:42:00 2008 +1100
@@ -935,7 +935,7 @@ static int e1000_request_irq(struct e100
 static int e1000_request_irq(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	void (*handler) = &e1000_intr;
+	int (*handler)(int, void *) = &e1000_intr;
 	int irq_flags = IRQF_SHARED;
 	int err;
 
diff -r 0fe1a980708b drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c	Thu Jan 17 14:48:56 2008 +1100
+++ b/drivers/net/e1000/e1000_main.c	Thu Jan 17 15:42:00 2008 +1100
@@ -299,7 +299,7 @@ static int e1000_request_irq(struct e100
 static int e1000_request_irq(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
-	void (*handler) = &e1000_intr;
+	irqreturn_t (*handler)(int, void *) = &e1000_intr;
 	int irq_flags = IRQF_SHARED;
 	int err;
 
