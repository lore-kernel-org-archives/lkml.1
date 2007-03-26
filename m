Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbXCZQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbXCZQkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXCZQkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 12:40:22 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:34012 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752960AbXCZQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 12:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O0ZO0d7kKR5Nqz7kPC2SuzhnJTs+snLepDvkLUNUC0tnUuP+5iSX4b4lbdCCOL55VBhRVQjWQ+juOVNZou9oKt3tybH9YJ0bOUpNi07W4PTZe5oIi41uBprOowDqhrCTAp/d3ZrZCoCxY0FR+nNC1aWir2qbDPgBSv+C03IJys8=  ;
X-YMail-OSG: QKJWJDIVM1nAIH.MHpmmykHfZFKnqNrHQSDz9fcohlrPpoNbVIjNbaV_GSqULs7.GgJr_rVLA7eXeGd32xgSYhT1cE7qAKy_QqJhtAuinacbnKVryRSfCD2653kXKxQanf0gB_tPxue.1cMsUhHa5V_lWg--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc5 3/3] layered parport code uses parport->dev
Date: Mon, 26 Mar 2007 09:11:43 -0700
User-Agent: KMail/1.7.1
Cc: akpm@linux-foundation.org, Jean Delvare <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260911.43480.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update some of the layered parport_driver code to use parport->dev:

	- i2c-parport (parent of i2c_adapter)
	- spi_butterfly (parent of spi_master, allowing cruft removal)
	- lp (creating class_device)
	- ppdev (parent of parportN device)
	- tipar (creating class_device)

There are still drivers that should be updated, like some of the input
drivers; but they won't be any worse off than they are today.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/lp.c                |    2 +-
 drivers/char/ppdev.c             |    2 +-
 drivers/char/tipar.c             |    2 +-
 drivers/i2c/busses/i2c-parport.c |    1 +
 drivers/spi/spi_butterfly.c      |   21 ++++-----------------
 5 files changed, 8 insertions(+), 20 deletions(-)

Index: g26/drivers/spi/spi_butterfly.c
===================================================================
--- g26.orig/drivers/spi/spi_butterfly.c	2007-03-07 10:10:33.000000000 -0800
+++ g26/drivers/spi/spi_butterfly.c	2007-03-07 11:17:26.000000000 -0800
@@ -20,7 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/platform_device.h>
+#include <linux/device.h>
 #include <linux/parport.h>
 
 #include <linux/sched.h>
@@ -237,24 +237,16 @@ static void butterfly_attach(struct parp
 	int			status;
 	struct butterfly	*pp;
 	struct spi_master	*master;
-	struct platform_device	*pdev;
+	struct device		*dev = p->physport->dev;
 
-	if (butterfly)
+	if (butterfly || !dev)
 		return;
 
 	/* REVISIT:  this just _assumes_ a butterfly is there ... no probe,
 	 * and no way to be selective about what it binds to.
 	 */
 
-	/* FIXME where should master->cdev.dev come from?
-	 * e.g. /sys/bus/pnp0/00:0b, some PCI thing, etc
-	 * setting up a platform device like this is an ugly kluge...
-	 */
-	pdev = platform_device_register_simple("butterfly", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return;
-
-	master = spi_alloc_master(&pdev->dev, sizeof *pp);
+	master = spi_alloc_master(dev, sizeof *pp);
 	if (!master) {
 		status = -ENOMEM;
 		goto done;
@@ -366,14 +358,12 @@ clean1:
 clean0:
 	(void) spi_master_put(pp->bitbang.master);
 done:
-	platform_device_unregister(pdev);
 	pr_debug("%s: butterfly probe, fail %d\n", p->name, status);
 }
 
 static void butterfly_detach(struct parport *p)
 {
 	struct butterfly	*pp;
-	struct platform_device	*pdev;
 	int			status;
 
 	/* FIXME this global is ugly ... but, how to quickly get from
@@ -386,7 +376,6 @@ static void butterfly_detach(struct parp
 	butterfly = NULL;
 
 	/* stop() unregisters child devices too */
-	pdev = to_platform_device(pp->bitbang.master->cdev.dev);
 	status = spi_bitbang_stop(&pp->bitbang);
 
 	/* turn off VCC */
@@ -397,8 +386,6 @@ static void butterfly_detach(struct parp
 	parport_unregister_device(pp->pd);
 
 	(void) spi_master_put(pp->bitbang.master);
-
-	platform_device_unregister(pdev);
 }
 
 static struct parport_driver butterfly_driver = {
Index: g26/drivers/i2c/busses/i2c-parport.c
===================================================================
--- g26.orig/drivers/i2c/busses/i2c-parport.c	2007-03-07 10:10:31.000000000 -0800
+++ g26/drivers/i2c/busses/i2c-parport.c	2007-03-07 11:14:35.000000000 -0800
@@ -175,6 +175,7 @@ static void i2c_parport_attach (struct p
 		adapter->algo_data.getscl = NULL;
 	adapter->algo_data.data = port;
 	adapter->adapter.algo_data = &adapter->algo_data;
+	adapter->adapter.dev.parent = port->physport->dev;
 
 	if (parport_claim_or_block(adapter->pdev) < 0) {
 		printk(KERN_ERR "i2c-parport: Could not claim parallel port\n");
Index: g26/drivers/char/ppdev.c
===================================================================
--- g26.orig/drivers/char/ppdev.c	2007-03-07 10:10:31.000000000 -0800
+++ g26/drivers/char/ppdev.c	2007-03-07 11:14:35.000000000 -0800
@@ -752,7 +752,7 @@ static const struct file_operations pp_f
 
 static void pp_attach(struct parport *port)
 {
-	device_create(ppdev_class, NULL, MKDEV(PP_MAJOR, port->number),
+	device_create(ppdev_class, port->dev, MKDEV(PP_MAJOR, port->number),
 			"parport%d", port->number);
 }
 
Index: g26/drivers/char/lp.c
===================================================================
--- g26.orig/drivers/char/lp.c	2007-03-07 10:10:31.000000000 -0800
+++ g26/drivers/char/lp.c	2007-03-07 11:14:35.000000000 -0800
@@ -803,7 +803,7 @@ static int lp_register(int nr, struct pa
 	if (reset)
 		lp_reset(nr);
 
-	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), NULL,
+	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), port->dev,
 				"lp%d", nr);
 
 	printk(KERN_INFO "lp%d: using %s (%s).\n", nr, port->name, 
Index: g26/drivers/char/tipar.c
===================================================================
--- g26.orig/drivers/char/tipar.c	2007-03-07 10:10:31.000000000 -0800
+++ g26/drivers/char/tipar.c	2007-03-07 11:14:35.000000000 -0800
@@ -442,7 +442,7 @@ tipar_register(int nr, struct parport *p
 	}
 
 	class_device_create(tipar_class, NULL, MKDEV(TIPAR_MAJOR,
-			TIPAR_MINOR + nr), NULL, "par%d", nr);
+			TIPAR_MINOR + nr), port->dev, "par%d", nr);
 
 	/* Display informations */
 	pr_info("tipar%d: using %s (%s)\n", nr, port->name, (port->irq ==
