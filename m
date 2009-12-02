Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbZLBF2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbZLBF2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZLBF23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:28:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56739 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZLBF22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=kYBqoOmPMI5xxrkTuDqusPl1Jvrq+wrEJCTl/a5zG9BMPP31JoB9HTei03amIbugbb
         WQx2u8G6ETcC+Cim0u0EJKhsdW8YHLIvJlws8zUmN/c6KZwVFxRazuTrSI0TXJ/d8YFw
         /KiZjIUtkkVv5BisH1Exl0j126KyEFgioO028=
From: Magnus Damm <magnus.damm@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       grant.likely@secretlab.ca, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, akpm@linux-foundation.org
Date: Wed, 02 Dec 2009 14:23:02 +0900
Message-Id: <20091202052302.12394.18621.sendpatchset@rxone.opensource.se>
Subject: [PATCH][RFC] spi: put struct spi_master in struct spi_bitbang
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This hack simply converts struct spi_bitbang from
containing a struct master * to containing the actual
structure itself. This allows us to use container_of()
in spi_bitbang_setup() and spi_bitbang_transfer().

Together with this are the functions spi_init_master()
and spi_bitbang_init() for initialization of static
structures. The idea is that spi_master_release() never
should be invoked, but not sure if I got that right.

Only the drivers spi_gpio.c and spi_sh_msiof.c are converted
at this point. If this seems like a good idea then we should
do this step by step and all drivers should be modified.

Dry coded only at this point.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/spi/spi.c               |   17 ++++++++++++++---
 drivers/spi/spi_bitbang.c       |   39 ++++++++++++++++++++++++---------------
 drivers/spi/spi_gpio.c          |   15 ++++++++-------
 drivers/spi/spi_sh_msiof.c      |   18 +++++++++---------
 include/linux/spi/spi.h         |    1 +
 include/linux/spi/spi_bitbang.h |    4 +++-
 6 files changed, 59 insertions(+), 35 deletions(-)

--- 0001/drivers/spi/spi.c
+++ work/drivers/spi/spi.c	2009-12-02 13:57:02.000000000 +0900
@@ -441,6 +441,19 @@ static struct class spi_master_class = {
 
 
 /**
+ * spi_init_master - init SPI master controller
+ * @master: master to initialize
+ * @dev: the controller device
+ */
+void spi_init_master(struct spi_master *master, struct device *dev)
+{
+	device_initialize(&master->dev);
+	master->dev.class = &spi_master_class;
+	master->dev.parent = get_device(dev);
+}
+EXPORT_SYMBOL_GPL(spi_init_master);
+
+/**
  * spi_alloc_master - allocate SPI master controller
  * @dev: the controller, possibly using the platform_bus
  * @size: how much zeroed driver-private data to allocate; the pointer to this
@@ -470,9 +483,7 @@ struct spi_master *spi_alloc_master(stru
 	if (!master)
 		return NULL;
 
-	device_initialize(&master->dev);
-	master->dev.class = &spi_master_class;
-	master->dev.parent = get_device(dev);
+	spi_init_master(master, dev);
 	spi_master_set_devdata(master, &master[1]);
 
 	return master;
--- 0001/drivers/spi/spi_bitbang.c
+++ work/drivers/spi/spi_bitbang.c	2009-12-02 13:59:26.000000000 +0900
@@ -186,7 +186,7 @@ int spi_bitbang_setup(struct spi_device 
 	int			retval;
 	unsigned long		flags;
 
-	bitbang = spi_master_get_devdata(spi->master);
+	bitbang = container_of(spi->master, struct spi_bitbang, master);
 
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
@@ -398,8 +398,7 @@ int spi_bitbang_transfer(struct spi_devi
 
 	m->actual_length = 0;
 	m->status = -EINPROGRESS;
-
-	bitbang = spi_master_get_devdata(spi->master);
+	bitbang = container_of(spi->master, struct spi_bitbang, master);
 
 	spin_lock_irqsave(&bitbang->lock, flags);
 	if (!spi->max_speed_hz)
@@ -443,35 +442,35 @@ int spi_bitbang_start(struct spi_bitbang
 {
 	int	status;
 
-	if (!bitbang->master || !bitbang->chipselect)
+	if (!bitbang->chipselect)
 		return -EINVAL;
 
 	INIT_WORK(&bitbang->work, bitbang_work);
 	spin_lock_init(&bitbang->lock);
 	INIT_LIST_HEAD(&bitbang->queue);
 
-	if (!bitbang->master->mode_bits)
-		bitbang->master->mode_bits = SPI_CPOL | SPI_CPHA | bitbang->flags;
+	if (!bitbang->master.mode_bits)
+		bitbang->master.mode_bits = SPI_CPOL | SPI_CPHA | bitbang->flags;
 
-	if (!bitbang->master->transfer)
-		bitbang->master->transfer = spi_bitbang_transfer;
+	if (!bitbang->master.transfer)
+		bitbang->master.transfer = spi_bitbang_transfer;
 	if (!bitbang->txrx_bufs) {
 		bitbang->use_dma = 0;
 		bitbang->txrx_bufs = spi_bitbang_bufs;
-		if (!bitbang->master->setup) {
+		if (!bitbang->master.setup) {
 			if (!bitbang->setup_transfer)
 				bitbang->setup_transfer =
 					 spi_bitbang_setup_transfer;
-			bitbang->master->setup = spi_bitbang_setup;
-			bitbang->master->cleanup = spi_bitbang_cleanup;
+			bitbang->master.setup = spi_bitbang_setup;
+			bitbang->master.cleanup = spi_bitbang_cleanup;
 		}
-	} else if (!bitbang->master->setup)
+	} else if (!bitbang->master.setup)
 		return -EINVAL;
 
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			dev_name(bitbang->master->dev.parent));
+			dev_name(bitbang->master.dev.parent));
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;
@@ -480,7 +479,7 @@ int spi_bitbang_start(struct spi_bitbang
 	/* driver may get busy before register() returns, especially
 	 * if someone registered boardinfo for devices
 	 */
-	status = spi_register_master(bitbang->master);
+	status = spi_register_master(&bitbang->master);
 	if (status < 0)
 		goto err2;
 
@@ -498,7 +497,7 @@ EXPORT_SYMBOL_GPL(spi_bitbang_start);
  */
 int spi_bitbang_stop(struct spi_bitbang *bitbang)
 {
-	spi_unregister_master(bitbang->master);
+	spi_unregister_master(&bitbang->master);
 
 	WARN_ON(!list_empty(&bitbang->queue));
 
@@ -508,5 +507,15 @@ int spi_bitbang_stop(struct spi_bitbang 
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_stop);
 
+/**
+ * spi_bitbang_init - init SPI bitbang controller
+ */
+void spi_bitbang_init(struct spi_bitbang *bitbang, struct device *dev)
+{
+	spi_init_master(&bitbang->master, dev);
+}
+EXPORT_SYMBOL_GPL(spi_bitbang_init);
+
+
 MODULE_LICENSE("GPL");
 
--- 0001/drivers/spi/spi_gpio.c
+++ work/drivers/spi/spi_gpio.c	2009-12-02 14:05:39.000000000 +0900
@@ -278,24 +278,26 @@ static int __init spi_gpio_probe(struct 
 	if (status < 0)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof *spi_gpio);
-	if (!master) {
+	spi_gpio = kzalloc(sizeof(struct spi_gpio), GFP_KERNEL);
+	if (!spi_gpio) {
 		status = -ENOMEM;
 		goto gpio_free;
 	}
-	spi_gpio = spi_master_get_devdata(master);
+
+	spi_bitbang_init(&spi_gpio->bitbang, &pdev->dev);
+	spi_master_set_devdata(&spi_gpio->bitbang.master, spi_gpio);
 	platform_set_drvdata(pdev, spi_gpio);
 
 	spi_gpio->pdev = pdev;
 	if (pdata)
 		spi_gpio->pdata = *pdata;
 
+	master = &spi_gpio->bitbang.master;
 	master->bus_num = pdev->id;
 	master->num_chipselect = SPI_N_CHIPSEL;
 	master->setup = spi_gpio_setup;
 	master->cleanup = spi_gpio_cleanup;
 
-	spi_gpio->bitbang.master = spi_master_get(master);
 	spi_gpio->bitbang.chipselect = spi_gpio_chipselect;
 	spi_gpio->bitbang.txrx_word[SPI_MODE_0] = spi_gpio_txrx_word_mode0;
 	spi_gpio->bitbang.txrx_word[SPI_MODE_1] = spi_gpio_txrx_word_mode1;
@@ -306,12 +308,11 @@ static int __init spi_gpio_probe(struct 
 
 	status = spi_bitbang_start(&spi_gpio->bitbang);
 	if (status < 0) {
-		spi_master_put(spi_gpio->bitbang.master);
 gpio_free:
 		gpio_free(SPI_MISO_GPIO);
 		gpio_free(SPI_MOSI_GPIO);
 		gpio_free(SPI_SCK_GPIO);
-		spi_master_put(master);
+		kfree(spi_gpio);
 	}
 
 	return status;
@@ -328,7 +329,7 @@ static int __exit spi_gpio_remove(struct
 
 	/* stop() unregisters child devices too */
 	status = spi_bitbang_stop(&spi_gpio->bitbang);
-	spi_master_put(spi_gpio->bitbang.master);
+	kfree(spi_gpio);
 
 	platform_set_drvdata(pdev, NULL);
 
--- 0010/drivers/spi/spi_sh_msiof.c
+++ work/drivers/spi/spi_sh_msiof.c	2009-12-02 14:00:30.000000000 +0900
@@ -29,7 +29,7 @@
 #include <asm/unaligned.h>
 
 struct sh_msiof_spi_priv {
-	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
+	struct spi_bitbang bitbang;
 	void __iomem *mapbase;
 	struct clk *clk;
 	struct platform_device *pdev;
@@ -542,15 +542,15 @@ static int sh_msiof_spi_probe(struct pla
 	int i;
 	int ret;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct sh_msiof_spi_priv));
-	if (master == NULL) {
-		dev_err(&pdev->dev, "failed to allocate spi master\n");
+	p = kzalloc(sizeof(struct sh_msiof_spi_priv), GFP_KERNEL);
+	if (!p) {
+		dev_err(&pdev->dev, "failed to allocate private spi data\n");
 		ret = -ENOMEM;
 		goto err0;
 	}
 
-	p = spi_master_get_devdata(master);
-
+	spi_bitbang_init(&p->bitbang, &pdev->dev);
+	spi_master_set_devdata(&p->bitbang.master, p);
 	platform_set_drvdata(pdev, p);
 	p->info = pdev->dev.platform_data;
 	init_completion(&p->done);
@@ -604,6 +604,7 @@ static int sh_msiof_spi_probe(struct pla
 		p->rx_fifo_size = p->info->rx_fifo_override;
 
 	/* init master and bitbang code */
+	master = &p->bitbang.master;
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 	master->mode_bits |= SPI_LSB_FIRST | SPI_3WIRE;
 	master->flags = 0;
@@ -612,7 +613,6 @@ static int sh_msiof_spi_probe(struct pla
 	master->setup = spi_bitbang_setup;
 	master->cleanup = spi_bitbang_cleanup;
 
-	p->bitbang.master = master;
 	p->bitbang.chipselect = sh_msiof_spi_chipselect;
 	p->bitbang.setup_transfer = sh_msiof_spi_setup_transfer;
 	p->bitbang.txrx_bufs = sh_msiof_spi_txrx;
@@ -631,7 +631,7 @@ static int sh_msiof_spi_probe(struct pla
  err2:
 	clk_put(p->clk);
  err1:
-	spi_master_put(master);
+	kfree(p);
  err0:
 	return ret;
 }
@@ -647,7 +647,7 @@ static int sh_msiof_spi_remove(struct pl
 		free_irq(platform_get_irq(pdev, 0), sh_msiof_spi_irq);
 		iounmap(p->mapbase);
 		clk_put(p->clk);
-		spi_master_put(p->bitbang.master);
+		kfree(p);
 	}
 	return ret;
 }
--- 0001/include/linux/spi/spi.h
+++ work/include/linux/spi/spi.h	2009-12-02 13:42:23.000000000 +0900
@@ -320,6 +320,7 @@ static inline void spi_master_put(struct
 
 
 /* the spi driver core manages memory for the spi_master classdev */
+extern void spi_init_master(struct spi_master *master, struct device *dev);
 extern struct spi_master *
 spi_alloc_master(struct device *host, unsigned size);
 
--- 0001/include/linux/spi/spi_bitbang.h
+++ work/include/linux/spi/spi_bitbang.h	2009-12-02 13:59:43.000000000 +0900
@@ -31,7 +31,7 @@ struct spi_bitbang {
 	u8			use_dma;
 	u8			flags;		/* extra spi->mode support */
 
-	struct spi_master	*master;
+	struct spi_master	master;
 
 	/* setup_transfer() changes clock and/or wordsize to match settings
 	 * for this transfer; zeroes restore defaults from spi_device.
@@ -67,6 +67,8 @@ extern int spi_bitbang_setup_transfer(st
 extern int spi_bitbang_start(struct spi_bitbang *spi);
 extern int spi_bitbang_stop(struct spi_bitbang *spi);
 
+extern void spi_bitbang_init(struct spi_bitbang *bitbang, struct device *dev);
+
 #endif	/* __SPI_BITBANG_H */
 
 /*-------------------------------------------------------------------------*/
