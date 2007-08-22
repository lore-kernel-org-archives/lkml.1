Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXHVDHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXHVDHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXHVDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:06:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:54963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbXHVDGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:06:53 -0400
Date: Tue, 21 Aug 2007 20:05:15 -0700
From: Tony Jones <tonyj@suse.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [patch 09/14] Convert from class_device to device for SPI
Message-ID: <20070822030515.GA32136@suse.de>
References: <20070820224806.154198000@suse.de> <20070820225122.627806000@suse.de> <20070821150119.GH26519@suse.de> <200708211128.28552.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211128.28552.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:28:28AM -0700, David Brownell wrote:
> Can you update the Documentation/spi/spi-summary text which is
> invalidated by this change?  That's part of why I rejected an
> earlier version of this patch:  since it broke the documentation,
> it was incomplete.

I believe this is the necessary documentation changes.  Alas I can't write 
verbiage you are necessarily happy with, only you can do that, if there is
a factual error, I'll be happy to correct but feel free to edit for personal 
style.  I'll be gone thru Sunday so if it needs more adjustment I'll do it 
then.

Tony

------------------------------------------------------------------------------

Convert from class_device to device for drivers/spi.  This is part of the work 
to eliminate struct class_device.

Signed-off-by: Tony Jones <tonyj@suse.de>

---
 Documentation/spi/spi-summary |   13 +++++++------
 drivers/spi/spi.c             |   36 ++++++++++++++++++------------------
 drivers/spi/spi_bitbang.c     |    2 +-
 drivers/spi/spi_lm70llp.c     |    2 +-
 include/linux/spi/spi.h       |   12 ++++++------
 5 files changed, 33 insertions(+), 32 deletions(-)

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
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -167,9 +167,9 @@ shows up in sysfs in several locations:
 
    /sys/bus/spi/drivers/D ... driver for one or more spi*.* devices
 
-   /sys/class/spi_master/spiB ... class device for the controller
-	managing bus "B".  All the spiB.* devices share the same
-	physical SPI bus segment, with SCLK, MOSI, and MISO.
+   /sys/class/spi_master/spiB ... device for the controller managing bus "B".
+	All the spiB.* devices share the same physical SPI bus segment, with
+	SCLK, MOSI, and MISO.
 
 
 How does board-specific init code declare SPI devices?
@@ -337,7 +337,8 @@ SPI protocol drivers somewhat resemble p
 
 The driver core will autmatically attempt to bind this driver to any SPI
 device whose board_info gave a modalias of "CHIP".  Your probe() code
-might look like this unless you're creating a class_device:
+might look like this unless you're creating a device which is managing a bus
+(appearing under /sys/class/spi_master).
 
 	static int __devinit CHIP_probe(struct spi_device *spi)
 	{
@@ -442,7 +443,7 @@ An SPI controller will probably be regis
 a driver to bind to the device, whichever bus is involved.
 
 The main task of this type of driver is to provide an "spi_master".
-Use spi_alloc_master() to allocate the master, and class_get_devdata()
+Use spi_alloc_master() to allocate the master, and spi_master_get_devdata()
 to get the driver-private data allocated for that device.
 
 	struct spi_master	*master;
@@ -452,7 +453,7 @@ to get the driver-private data allocated
 	if (!master)
 		return -ENODEV;
 
-	c = class_get_devdata(&master->cdev);
+	c = spi_master_get_devdata(master);
 
 The driver will initialize the fields of that spi_master, including the
 bus number (maybe the same as the platform device ID) and three methods


