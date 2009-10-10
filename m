Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZJJE4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZJJE4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZJJE4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:56:46 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:53047 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZJJE4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pMpAyaLkCDftKqPQk4zrQxWyhCxJw27xjgaoHkwWM9sCgOZmfmPBboKVdkOYSx0C1Y
         ClYhHLZLu8NQud4wvOV7huYvwWJN6MG5vArUQdJmmTBlPXox5PL1uGoyO6xPgbgoCyEw
         H+t/Mtk+CJy6ibMIi2BCTeab8gHhsC3Xxe1TA=
Date: Fri, 9 Oct 2009 21:56:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: linux-input@vger.kernel.org,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: New driver for Altera PS/2 controller
Message-ID: <20091010045603.GA9914@core.coreip.homeip.net>
References: <1254985152-32407-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254985152-32407-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, Oct 08, 2009 at 02:59:12PM +0800, Thomas Chou wrote:
> This patch adds a new SERIO driver to support the Altera University
> Program PS/2 controller.
> 

Thank you for the patch, it looks like it is reasonable written although
it should do request_mem_region for the IO memory region it tries to
remap and also IO addresses should not be cast to unsigned int but
rather 'void __iomem *'. I also don;t see the reason for it to depend on
EMBEDDED since the things that depend on EMBEDDED are usually features
that are used almost by everyone and only in case of embedded arch you
may want to turn them off to save some memory.

I also prefer even static functions to have the driver name as their
prefix - this way if I see a backtrace I know exactly which module is
involved.

I made a small patch on top of yours, please give it a try and if it did
not break anything then I will fold it all together and queue for
2.6.33.

Thanks!

-- 
Dmitry


Input: altera_ps2 - miscellaneous fixes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/Kconfig      |    1 
 drivers/input/serio/altera_ps2.c |  139 +++++++++++++++++++++-----------------
 2 files changed, 77 insertions(+), 63 deletions(-)


diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index b3a6c1a..7e319d6 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -203,7 +203,6 @@ config SERIO_XILINX_XPS_PS2
 
 config SERIO_ALTERA_PS2
 	tristate "Altera UP PS/2 controller"
-	depends on EMBEDDED
 	help
 	  Say Y here if you have Altera University Program PS/2 ports.
 
diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 6a7ef09..f479ea5 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -22,9 +22,9 @@
 #define DRV_NAME "altera_ps2"
 
 struct ps2if {
-	struct serio		*io;
-	struct platform_device	*dev;
-	unsigned base;
+	struct serio *io;
+	struct resource *iomem_res;
+	void __iomem *base;
 	unsigned irq;
 };
 
@@ -32,7 +32,7 @@ struct ps2if {
  * Read all bytes waiting in the PS2 port.  There should be
  * at the most one, but we loop for safety.
  */
-static irqreturn_t ps2_rxint(int irq, void *dev_id)
+static irqreturn_t altera_ps2_rxint(int irq, void *dev_id)
 {
 	struct ps2if *ps2if = dev_id;
 	unsigned int status;
@@ -42,13 +42,14 @@ static irqreturn_t ps2_rxint(int irq, void *dev_id)
 		serio_interrupt(ps2if->io, status & 0xff, 0);
 		handled = IRQ_HANDLED;
 	}
+
 	return handled;
 }
 
 /*
  * Write a byte to the PS2 port.
  */
-static int ps2_write(struct serio *io, unsigned char val)
+static int altera_ps2_write(struct serio *io, unsigned char val)
 {
 	struct ps2if *ps2if = io->port_data;
 
@@ -56,100 +57,114 @@ static int ps2_write(struct serio *io, unsigned char val)
 	return 0;
 }
 
-static int ps2_open(struct serio *io)
+static int altera_ps2_open(struct serio *io)
 {
 	struct ps2if *ps2if = io->port_data;
-	int ret;
-
-	ret = request_irq(ps2if->irq, ps2_rxint, 0,
-			  DRV_NAME, ps2if);
-	if (ret) {
-		printk(KERN_ERR DRV_NAME ": could not allocate IRQ%d: %d\n",
-			ps2if->irq, ret);
-		return ret;
-	}
+
+	/* clear fifo */
+	while (readl(ps2if->base) & 0xffff0000)
+		/* empty */;
+
 	writel(1, ps2if->base + 4); /* enable rx irq */
 	return 0;
 }
 
-static void ps2_close(struct serio *io)
+static void altera_ps2_close(struct serio *io)
 {
 	struct ps2if *ps2if = io->port_data;
 
 	writel(0, ps2if->base); /* disable rx irq */
-	free_irq(ps2if->irq, ps2if);
 }
 
 /*
  * Add one device to this driver.
  */
-static int ps2_probe(struct platform_device *dev)
+static int altera_ps2_probe(struct platform_device *pdev)
 {
 	struct ps2if *ps2if;
 	struct serio *serio;
-	struct resource *res;
-	int ret;
+	int error;
 
 	ps2if = kzalloc(sizeof(struct ps2if), GFP_KERNEL);
 	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
 	if (!ps2if || !serio) {
-		ret = -ENOMEM;
-		goto free;
+		error = -ENOMEM;
+		goto err_free_mem;
 	}
 
 	serio->id.type		= SERIO_8042;
-	serio->write		= ps2_write;
-	serio->open		= ps2_open;
-	serio->close		= ps2_close;
-	strlcpy(serio->name, dev_name(&dev->dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
+	serio->write		= altera_ps2_write;
+	serio->open		= altera_ps2_open;
+	serio->close		= altera_ps2_close;
+	strlcpy(serio->name, dev_name(&pdev->dev), sizeof(serio->name));
+	strlcpy(serio->phys, dev_name(&pdev->dev), sizeof(serio->phys));
 	serio->port_data	= ps2if;
-	serio->dev.parent	= &dev->dev;
+	serio->dev.parent	= &pdev->dev;
 	ps2if->io		= serio;
-	ps2if->dev		= dev;
-	platform_set_drvdata(dev, ps2if);
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		ret = -ENOENT;
-		goto free;
+	ps2if->iomem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (ps2if->iomem_res == NULL) {
+		error = -ENOENT;
+		goto err_free_mem;
 	}
-	ps2if->irq  = platform_get_irq(dev, 0);
+
+	ps2if->irq  = platform_get_irq(pdev, 0);
 	if (ps2if->irq < 0) {
-		ret = -ENXIO;
-		goto free;
+		error = -ENXIO;
+		goto err_free_mem;
+	}
+
+	if (!request_mem_region(ps2if->iomem_res->start,
+				resource_size(ps2if->iomem_res), pdev->name)) {
+		error = -EBUSY;
+		goto err_free_mem;
 	}
-	ps2if->base = (unsigned) ioremap(res->start,
-					 (res->end - res->start) + 1);
+
+	ps2if->base = ioremap(ps2if->iomem_res->start,
+			      resource_size(ps2if->iomem_res));
 	if (!ps2if->base) {
-		ret = -ENOMEM;
-		goto free;
+		error = -ENOMEM;
+		goto err_free_res;
 	}
-	printk(KERN_INFO DRV_NAME ": base %08x irq %d\n",
-	       ps2if->base, ps2if->irq);
-	/* clear fifo */
-	while (readl(ps2if->base) & 0xffff0000)
-		;
+
+	error = request_irq(ps2if->irq, altera_ps2_rxint, 0, pdev->name, ps2if);
+	if (error) {
+		dev_err(&pdev->dev, "could not allocate IRQ %d: %d\n",
+			ps2if->irq, error);
+		goto err_unmap;
+	}
+
+	dev_info(&pdev->dev, "base %p, irq %d\n", ps2if->base, ps2if->irq);
+
 	serio_register_port(ps2if->io);
+	platform_set_drvdata(pdev, ps2if);
+
 	return 0;
 
- free:
-	platform_set_drvdata(dev, NULL);
+ err_unmap:
+	iounmap(ps2if->base);
+ err_free_res:
+	release_mem_region(ps2if->iomem_res->start,
+			   resource_size(ps2if->iomem_res));
+ err_free_mem:
 	kfree(ps2if);
 	kfree(serio);
-	return ret;
+	return error;
 }
 
 /*
  * Remove one device from this driver.
  */
-static int ps2_remove(struct platform_device *dev)
+static int altera_ps2_remove(struct platform_device *pdev)
 {
-	struct ps2if *ps2if = platform_get_drvdata(dev);
+	struct ps2if *ps2if = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(dev, NULL);
+	platform_set_drvdata(pdev, NULL);
 	serio_unregister_port(ps2if->io);
-	iounmap((void *)ps2if->base);
+	free_irq(ps2if->irq, ps2if);
+	iounmap(ps2if->base);
+	release_mem_region(ps2if->iomem_res->start,
+			   resource_size(ps2if->iomem_res));
 	kfree(ps2if);
 
 	return 0;
@@ -158,26 +173,26 @@ static int ps2_remove(struct platform_device *dev)
 /*
  * Our device driver structure
  */
-static struct platform_driver ps2_driver = {
-	.probe		= ps2_probe,
-	.remove		= ps2_remove,
+static struct platform_driver altera_ps2_driver = {
+	.probe		= altera_ps2_probe,
+	.remove		= altera_ps2_remove,
 	.driver	= {
 		.name	= DRV_NAME,
 	},
 };
 
-static int __init ps2_init(void)
+static int __init altera_ps2_init(void)
 {
-	return platform_driver_register(&ps2_driver);
+	return platform_driver_register(&altera_ps2_driver);
 }
 
-static void __exit ps2_exit(void)
+static void __exit altera_ps2_exit(void)
 {
-	platform_driver_unregister(&ps2_driver);
+	platform_driver_unregister(&altera_ps2_driver);
 }
 
-module_init(ps2_init);
-module_exit(ps2_exit);
+module_init(altera_ps2_init);
+module_exit(altera_ps2_exit);
 
 MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
