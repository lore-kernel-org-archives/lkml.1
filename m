Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbXHTWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbXHTWz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbXHTWxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:60166 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760906AbXHTWw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:59 -0400
Message-Id: <20070820225122.627806000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:15 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, kay.sievers@vrfy.org
Subject: [patch 09/14] Convert from class_device to device for SPI
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=spi.patch

Convert from class_device to device for drivers/spi.  This is part of the work 
to eliminate struct class_device.

---
 drivers/spi/spi.c         |   36 ++++++++++++++++++------------------
 drivers/spi/spi_bitbang.c |    2 +-
 drivers/spi/spi_lm70llp.c |    2 +-
 include/linux/spi/spi.h   |   12 ++++++------
 4 files changed, 26 insertions(+), 26 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -207,7 +207,7 @@ struct spi_device *spi_new_device(struct
 				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 	int			status;
 
 	/* NOTE:  caller did any chip->bus_num checks necessary.
@@ -242,7 +242,7 @@ struct spi_device *spi_new_device(struct
 	proxy->modalias = chip->modalias;
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
-			"%s.%u", master->cdev.class_id,
+			"%s.%u", master->dev.bus_id,
 			chip->chip_select);
 	proxy->dev.parent = dev;
 	proxy->dev.bus = &spi_bus_type;
@@ -341,18 +341,18 @@ static void scan_boardinfo(struct spi_ma
 
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
 
 
@@ -360,7 +360,7 @@ static struct class spi_master_class = {
  * spi_alloc_master - allocate SPI master controller
  * @dev: the controller, possibly using the platform_bus
  * @size: how much zeroed driver-private data to allocate; the pointer to this
- *	memory is in the class_data field of the returned class_device,
+ *	memory is in the driver_data field of the returned device,
  *	accessible with spi_master_get_devdata().
  * Context: can sleep
  *
@@ -386,9 +386,9 @@ struct spi_master *spi_alloc_master(stru
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
@@ -418,7 +418,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 int spi_register_master(struct spi_master *master)
 {
 	static atomic_t		dyn_bus_id = ATOMIC_INIT((1<<15) - 1);
-	struct device		*dev = master->cdev.dev;
+	struct device		*dev = master->dev.parent;
 	int			status = -ENODEV;
 	int			dynamic = 0;
 
@@ -443,12 +443,12 @@ int spi_register_master(struct spi_maste
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
@@ -481,8 +481,8 @@ void spi_unregister_master(struct spi_ma
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->cdev.dev, NULL, __unregister);
-	class_device_unregister(&master->cdev);
+	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
+	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
@@ -498,13 +498,13 @@ EXPORT_SYMBOL_GPL(spi_unregister_master)
  */
 struct spi_master *spi_busnum_to_master(u16 bus_num)
 {
-	struct class_device	*cdev;
+	struct device		*dev;
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
 	down(&spi_master_class.sem);
-	list_for_each_entry(cdev, &spi_master_class.children, node) {
-		m = container_of(cdev, struct spi_master, cdev);
+	list_for_each_entry(dev, &spi_master_class.children, node) {
+		m = container_of(dev, struct spi_master, dev);
 		if (m->bus_num == bus_num) {
 			master = spi_master_get(m);
 			break;
--- a/drivers/spi/spi_lm70llp.c
+++ b/drivers/spi/spi_lm70llp.c
@@ -82,7 +82,7 @@ struct spi_lm70llp {
 	struct pardevice	*pd;
 	struct spi_device	*spidev_lm70;
 	struct spi_board_info	info;
-	struct class_device	*cdev;
+	//struct device		*dev;
 };
 
 /* REVISIT : ugly global ; provides "exclusive open" facility */
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -195,7 +195,7 @@ static inline void spi_unregister_driver
 
 /**
  * struct spi_master - interface to SPI master controller
- * @cdev: class interface to this driver
+ * @dev: device interface to this driver
  * @bus_num: board-specific (and often SOC-specific) identifier for a
  *	given SPI controller.
  * @num_chipselect: chipselects are used to distinguish individual
@@ -222,7 +222,7 @@ static inline void spi_unregister_driver
  * message's completion function when the transaction completes.
  */
 struct spi_master {
-	struct class_device	cdev;
+	struct device	dev;
 
 	/* other than negative (== assign one dynamically), bus_num is fully
 	 * board-specific.  usually that simplifies to being SOC-specific.
@@ -268,17 +268,17 @@ struct spi_master {
 
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
@@ -286,7 +286,7 @@ static inline struct spi_master *spi_mas
 static inline void spi_master_put(struct spi_master *master)
 {
 	if (master)
-		class_device_put(&master->cdev);
+		put_device(&master->dev);
 }
 
 
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi_bitbang.c
@@ -472,7 +472,7 @@ int spi_bitbang_start(struct spi_bitbang
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			bitbang->master->cdev.dev->bus_id);
+			bitbang->master->dev.parent->bus_id);
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;

-- 
