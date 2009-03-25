Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZCYAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZCYAaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZCYA3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:36 -0400
Received: from kroah.org ([198.145.64.141]:54036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753407AbZCYA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 02/61] spi: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:06 -0700
Message-Id: <1237940825-22904-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/spi/atmel_spi.c       |    8 ++++----
 drivers/spi/mpc52xx_psc_spi.c |    2 +-
 drivers/spi/omap2_mcspi.c     |    2 +-
 drivers/spi/omap_uwire.c      |   12 ++++++------
 drivers/spi/orion_spi.c       |    2 +-
 drivers/spi/pxa2xx_spi.c      |    4 ++--
 drivers/spi/spi_bfin5xx.c     |    4 ++--
 drivers/spi/spi_gpio.c        |    2 +-
 drivers/spi/spi_imx.c         |    5 +++--
 drivers/spi/spi_mpc83xx.c     |    4 ++--
 drivers/spi/spi_txx9.c        |    3 ++-
 11 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 56ff3e6..12e443c 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -322,7 +322,7 @@ static void atmel_spi_next_message(struct spi_master *master)
 	spi = msg->spi;
 
 	dev_dbg(master->dev.parent, "start message %p for %s\n",
-			msg, spi->dev.bus_id);
+			msg, dev_name(&spi->dev));
 
 	/* select chip if it's not still active */
 	if (as->stay) {
@@ -627,7 +627,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 		if (!asd)
 			return -ENOMEM;
 
-		ret = gpio_request(npcs_pin, spi->dev.bus_id);
+		ret = gpio_request(npcs_pin, dev_name(&spi->dev));
 		if (ret) {
 			kfree(asd);
 			return ret;
@@ -668,7 +668,7 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 	as = spi_master_get_devdata(spi->master);
 
 	dev_dbg(controller, "new message %p submitted for %s\n",
-			msg, spi->dev.bus_id);
+			msg, dev_name(&spi->dev));
 
 	if (unlikely(list_empty(&msg->transfers)))
 		return -EINVAL;
@@ -803,7 +803,7 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 	as->clk = clk;
 
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
-			pdev->dev.bus_id, master);
+			dev_name(&pdev->dev), master);
 	if (ret)
 		goto out_unmap_regs;
 
diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 3b97803..68c77a9 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -429,7 +429,7 @@ static int __init mpc52xx_psc_spi_do_probe(struct device *dev, u32 regaddr,
 	INIT_LIST_HEAD(&mps->queue);
 
 	mps->workqueue = create_singlethread_workqueue(
-		master->dev.parent->bus_id);
+		dev_name(master->dev.parent));
 	if (mps->workqueue == NULL) {
 		ret = -EBUSY;
 		goto free_irq;
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
index 454a271..1c65e38 100644
--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -1003,7 +1003,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 		goto err1;
 	}
 	if (!request_mem_region(r->start, (r->end - r->start) + 1,
-			pdev->dev.bus_id)) {
+			dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto err1;
 	}
diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
index bab6ff0..60b5381 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/omap_uwire.c
@@ -245,7 +245,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 
 #ifdef	VERBOSE
 			pr_debug("%s: write-%d =%04x\n",
-					spi->dev.bus_id, bits, val);
+					dev_name(&spi->dev), bits, val);
 #endif
 			if (wait_uwire_csr_flag(CSRB, 0, 0))
 				goto eio;
@@ -305,7 +305,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 			status += bytes;
 #ifdef	VERBOSE
 			pr_debug("%s: read-%d =%04x\n",
-					spi->dev.bus_id, bits, val);
+					dev_name(&spi->dev), bits, val);
 #endif
 
 		}
@@ -331,7 +331,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	uwire = spi_master_get_devdata(spi->master);
 
 	if (spi->chip_select > 3) {
-		pr_debug("%s: cs%d?\n", spi->dev.bus_id, spi->chip_select);
+		pr_debug("%s: cs%d?\n", dev_name(&spi->dev), spi->chip_select);
 		status = -ENODEV;
 		goto done;
 	}
@@ -343,7 +343,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 		bits = 8;
 
 	if (bits > 16) {
-		pr_debug("%s: wordsize %d?\n", spi->dev.bus_id, bits);
+		pr_debug("%s: wordsize %d?\n", dev_name(&spi->dev), bits);
 		status = -ENODEV;
 		goto done;
 	}
@@ -378,7 +378,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 		hz = t->speed_hz;
 
 	if (!hz) {
-		pr_debug("%s: zero speed?\n", spi->dev.bus_id);
+		pr_debug("%s: zero speed?\n", dev_name(&spi->dev));
 		status = -EINVAL;
 		goto done;
 	}
@@ -406,7 +406,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	}
 	if (div1_idx == 4) {
 		pr_debug("%s: lowest clock %ld, need %d\n",
-			spi->dev.bus_id, rate / 10 / 8, hz);
+			dev_name(&spi->dev), rate / 10 / 8, hz);
 		status = -EDOM;
 		goto done;
 	}
diff --git a/drivers/spi/orion_spi.c b/drivers/spi/orion_spi.c
index 014becb..c8b0bab 100644
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/orion_spi.c
@@ -496,7 +496,7 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 	}
 
 	if (!request_mem_region(r->start, (r->end - r->start) + 1,
-				pdev->dev.bus_id)) {
+				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index d0fc4ca..ec24f2d 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1333,7 +1333,7 @@ static int __init init_queue(struct driver_data *drv_data)
 
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->dev.parent->bus_id);
+				dev_name(drv_data->master->dev.parent));
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
@@ -1462,7 +1462,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 		drv_data->mask_sr = SSSR_TINT | SSSR_RFS | SSSR_TFS | SSSR_ROR;
 	}
 
-	status = request_irq(ssp->irq, ssp_int, 0, dev->bus_id, drv_data);
+	status = request_irq(ssp->irq, ssp_int, 0, dev_name(dev), drv_data);
 	if (status < 0) {
 		dev_err(&pdev->dev, "cannot get IRQ %d\n", ssp->irq);
 		goto out_error_master_alloc;
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7fea3cf..3410b0c 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1160,8 +1160,8 @@ static inline int init_queue(struct driver_data *drv_data)
 
 	/* init messages workqueue */
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
-	drv_data->workqueue =
-	    create_singlethread_workqueue(drv_data->master->dev.parent->bus_id);
+	drv_data->workqueue = create_singlethread_workqueue(
+				dev_name(drv_data->master->dev.parent));
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
index f5ed972..d2866c2 100644
--- a/drivers/spi/spi_gpio.c
+++ b/drivers/spi/spi_gpio.c
@@ -191,7 +191,7 @@ static int spi_gpio_setup(struct spi_device *spi)
 		return -EINVAL;
 
 	if (!spi->controller_state) {
-		status = gpio_request(cs, spi->dev.bus_id);
+		status = gpio_request(cs, dev_name(&spi->dev));
 		if (status)
 			return status;
 		status = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 269a55e..0480d8b 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -1381,7 +1381,7 @@ static int __init init_queue(struct driver_data *drv_data)
 
 	INIT_WORK(&drv_data->work, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->dev.parent->bus_id);
+				dev_name(drv_data->master->dev.parent));
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
@@ -1525,7 +1525,8 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 		status = -ENODEV;
 		goto err_no_irqres;
 	}
-	status = request_irq(irq, spi_int, IRQF_DISABLED, dev->bus_id, drv_data);
+	status = request_irq(irq, spi_int, IRQF_DISABLED,
+			     dev_name(dev), drv_data);
 	if (status < 0) {
 		dev_err(&pdev->dev, "probe - cannot get IRQ (%d)\n", status);
 		goto err_no_irqres;
diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index ac0e3e4..44a2b46 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -637,7 +637,7 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
 	INIT_LIST_HEAD(&mpc83xx_spi->queue);
 
 	mpc83xx_spi->workqueue = create_singlethread_workqueue(
-		master->dev.parent->bus_id);
+		dev_name(master->dev.parent));
 	if (mpc83xx_spi->workqueue == NULL) {
 		ret = -EBUSY;
 		goto free_irq;
@@ -649,7 +649,7 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
 
 	printk(KERN_INFO
 	       "%s: MPC83xx SPI Controller driver at 0x%p (irq = %d)\n",
-	       dev->dev.bus_id, mpc83xx_spi->base, mpc83xx_spi->irq);
+	       dev_name(&dev->dev), mpc83xx_spi->base, mpc83xx_spi->irq);
 
 	return ret;
 
diff --git a/drivers/spi/spi_txx9.c b/drivers/spi/spi_txx9.c
index 2296f37..29cbb06 100644
--- a/drivers/spi/spi_txx9.c
+++ b/drivers/spi/spi_txx9.c
@@ -404,7 +404,8 @@ static int __init txx9spi_probe(struct platform_device *dev)
 	if (ret)
 		goto exit;
 
-	c->workqueue = create_singlethread_workqueue(master->dev.parent->bus_id);
+	c->workqueue = create_singlethread_workqueue(
+				dev_name(master->dev.parent));
 	if (!c->workqueue)
 		goto exit_busy;
 	c->last_chipselect = -1;
-- 
1.6.2

