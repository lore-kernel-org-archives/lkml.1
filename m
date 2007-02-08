Return-Path: <linux-kernel-owner+w=401wt.eu-S1422848AbXBHAbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848AbXBHAbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422874AbXBHAbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:31:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:56349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422852AbXBHAbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:34 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/28] Driver core: convert SPI code to use struct device
Date: Wed,  7 Feb 2007 16:29:51 -0800
Message-Id: <11708946251265-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1170894620889-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

Converts from using struct "class_device" to "struct device" making
everything show up properly in /sys/devices/ with symlinks from the
/sys/class directory.

Cc: <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/pxa2xx_spi.c    |    2 +-
 drivers/spi/spi.c           |   32 ++++++++++++++++----------------
 drivers/spi/spi_bitbang.c   |    6 +++---
 drivers/spi/spi_butterfly.c |    4 ++--
 include/linux/spi/spi.h     |   10 +++++-----
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index 8b41f9c..dccdc50 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1234,7 +1234,7 @@ static int init_queue(struct driver_data *drv_data)
 
 	INIT_WORK(&drv_data->pump_messages, pump_messages);
 	drv_data->workqueue = create_singlethread_workqueue(
-					drv_data->master->cdev.dev->bus_id);
+					drv_data->master->dev.parent->bus_id);
 	if (drv_data->workqueue == NULL)
 		return -EBUSY;
 
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 6307428..35d8c01 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -193,7 +193,7 @@ struct spi_device *__init_or_module
 spi_new_device(struct spi_master *master, struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = &master->dev;
 	int			status;
 
 	/* NOTE:  caller did any chip->bus_num checks necessary */
@@ -215,7 +215,7 @@ spi_new_device(struct spi_master *master, struct spi_board_info *chip)
 	proxy->modalias = chip->modalias;
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
-			"%s.%u", master->cdev.class_id,
+			"%s.%u", master->dev.bus_id,
 			chip->chip_select);
 	proxy->dev.parent = dev;
 	proxy->dev.bus = &spi_bus_type;
@@ -290,7 +290,7 @@ static void __init_or_module
 scan_boardinfo(struct spi_master *master)
 {
 	struct boardinfo	*bi;
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 
 	down(&board_lock);
 	list_for_each_entry(bi, &board_list, list) {
@@ -319,18 +319,18 @@ scan_boardinfo(struct spi_master *master)
 
 /*-------------------------------------------------------------------------*/
 
-static void spi_master_release(struct class_device *cdev)
+static void spi_master_release(struct device *dev)
 {
 	struct spi_master *master;
 
-	master = container_of(cdev, struct spi_master, cdev);
+	master = container_of(dev, struct spi_master, dev);
 	kfree(master);
 }
 
 static struct class spi_master_class = {
 	.name		= "spi_master",
 	.owner		= THIS_MODULE,
-	.release	= spi_master_release,
+	.dev_release	= spi_master_release,
 };
 
 
@@ -364,9 +364,9 @@ spi_alloc_master(struct device *dev, unsigned size)
 	if (!master)
 		return NULL;
 
-	class_device_initialize(&master->cdev);
-	master->cdev.class = &spi_master_class;
-	master->cdev.dev = get_device(dev);
+	device_initialize(&master->dev);
+	master->dev.class = &spi_master_class;
+	master->dev.parent = get_device(dev);
 	spi_master_set_devdata(master, &master[1]);
 
 	return master;
@@ -396,7 +396,7 @@ int __init_or_module
 spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<16) - 1);
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 	int			status = -ENODEV;
 	int			dynamic = 0;
 
@@ -412,12 +412,12 @@ spi_register_master(struct spi_master *master)
 	/* register the device, then userspace will see it.
 	 * registration fails if the bus ID is in use.
 	 */
-	snprintf(master->cdev.class_id, sizeof master->cdev.class_id,
+	snprintf(master->dev.bus_id, sizeof master->dev.bus_id,
 		"spi%u", master->bus_num);
-	status = class_device_add(&master->cdev);
+	status = device_add(&master->dev);
 	if (status < 0)
 		goto done;
-	dev_dbg(dev, "registered master %s%s\n", master->cdev.class_id,
+	dev_dbg(dev, "registered master %s%s\n", master->dev.bus_id,
 			dynamic ? " (dynamic)" : "");
 
 	/* populate children from any spi device tables */
@@ -449,8 +449,8 @@ void spi_unregister_master(struct spi_master *master)
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->cdev.dev, NULL, __unregister);
-	class_device_unregister(&master->cdev);
+	dummy = device_for_each_child(&master->dev, NULL, __unregister);
+	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
@@ -471,7 +471,7 @@ struct spi_master *spi_busnum_to_master(u16 bus_num)
 
 	down(&spi_master_class.sem);
 	list_for_each_entry(cdev, &spi_master_class.children, node) {
-		m = container_of(cdev, struct spi_master, cdev);
+		m = container_of(cdev, struct spi_master, dev.kobj);
 		if (m->bus_num == bus_num) {
 			master = spi_master_get(m);
 			break;
diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
index 57289b6..4638e6c 100644
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi_bitbang.c
@@ -479,7 +479,7 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			bitbang->master->cdev.dev->bus_id);
+			bitbang->master->dev.parent->bus_id);
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;
@@ -513,14 +513,14 @@ int spi_bitbang_stop(struct spi_bitbang *bitbang)
 	while (!list_empty(&bitbang->queue) && limit--) {
 		spin_unlock_irq(&bitbang->lock);
 
-		dev_dbg(bitbang->master->cdev.dev, "wait for queue\n");
+		dev_dbg(&bitbang->master->dev, "wait for queue\n");
 		msleep(10);
 
 		spin_lock_irq(&bitbang->lock);
 	}
 	spin_unlock_irq(&bitbang->lock);
 	if (!list_empty(&bitbang->queue)) {
-		dev_err(bitbang->master->cdev.dev, "queue didn't empty\n");
+		dev_err(&bitbang->master->dev, "queue didn't empty\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/spi/spi_butterfly.c b/drivers/spi/spi_butterfly.c
index 312987a..31b7970 100644
--- a/drivers/spi/spi_butterfly.c
+++ b/drivers/spi/spi_butterfly.c
@@ -246,7 +246,7 @@ static void butterfly_attach(struct parport *p)
 	 * and no way to be selective about what it binds to.
 	 */
 
-	/* FIXME where should master->cdev.dev come from?
+	/* FIXME where should master->dev.parent come from?
 	 * e.g. /sys/bus/pnp0/00:0b, some PCI thing, etc
 	 * setting up a platform device like this is an ugly kluge...
 	 */
@@ -386,7 +386,7 @@ static void butterfly_detach(struct parport *p)
 	butterfly = NULL;
 
 	/* stop() unregisters child devices too */
-	pdev = to_platform_device(pp->bitbang.master->cdev.dev);
+	pdev = to_platform_device(pp->bitbang.master->dev.parent);
 	status = spi_bitbang_stop(&pp->bitbang);
 
 	/* turn off VCC */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 176f6e3..8c2edd8 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -170,7 +170,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * message's completion function when the transaction completes.
  */
 struct spi_master {
-	struct class_device	cdev;
+	struct device		dev;
 
 	/* other than negative (== assign one dynamically), bus_num is fully
 	 * board-specific.  usually that simplifies to being SOC-specific.
@@ -216,17 +216,17 @@ struct spi_master {
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
 {
-	return class_get_devdata(&master->cdev);
+	return dev_get_drvdata(&master->dev);
 }
 
 static inline void spi_master_set_devdata(struct spi_master *master, void *data)
 {
-	class_set_devdata(&master->cdev, data);
+	dev_set_drvdata(&master->dev, data);
 }
 
 static inline struct spi_master *spi_master_get(struct spi_master *master)
 {
-	if (!master || !class_device_get(&master->cdev))
+	if (!master || !get_device(&master->dev))
 		return NULL;
 	return master;
 }
@@ -234,7 +234,7 @@ static inline struct spi_master *spi_master_get(struct spi_master *master)
 static inline void spi_master_put(struct spi_master *master)
 {
 	if (master)
-		class_device_put(&master->cdev);
+		put_device(&master->dev);
 }
 
 
-- 
1.4.4.4

