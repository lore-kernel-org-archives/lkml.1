Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYGCBDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYGCBDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 21:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYGCBDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 21:03:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:60541 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYGCBDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:03:07 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 2/5] spi: split up spi_new_device() to allow two stage
	registration.
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com, david-b@pacbell.net
Date: Wed, 02 Jul 2008 19:03:03 -0600
Message-ID: <20080703010303.26187.94694.stgit@trillian.secretlab.ca>
In-Reply-To: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

spi_new_device() allocates and registers an spi device all in one swoop.
If the driver needs to add extra data to the spi_device before it is
registered, then this causes problems.

This patch splits the allocation and registration portions of code out
of spi_new_device() and creates three new functions; spi_alloc_device(),
spi_register_device(), and spi_device_release().  spi_new_device() is
modified to use the new functions for allocation and registration.
None of the existing users of spi_new_device() should be affected by
this change.

Drivers using the new API can forego the use of an spi_board_info
structure to describe the device layout and populate data into the
spi_device structure directly.

This change is in preparation for adding an OF device tree parser to
generate spi_devices based on data in the device tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/spi/spi.c       |  139 ++++++++++++++++++++++++++++++++---------------
 include/linux/spi/spi.h |   10 +++
 2 files changed, 105 insertions(+), 44 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 32b7a42..e64add0 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -178,6 +178,96 @@ struct boardinfo {
 static LIST_HEAD(board_list);
 static DEFINE_MUTEX(board_lock);
 
+/**
+ * spi_alloc_device - Allocate a new SPI device
+ * @master: Controller to which device is connected
+ * Context: can sleep
+ *
+ * Allows a driver to allocate and initialize and spi_device without
+ * registering it immediately.  This allows a driver to directly
+ * fill the spi_device with device parameters before calling
+ * spi_add_device() on it.
+ *
+ * Caller is responsible to call spi_add_device() on the returned
+ * spi_device structure to add it to the SPI master.  If the caller
+ * needs to discard the spi_device without adding it, then it should
+ * call spi_dev_put() on it.
+ *
+ * Returns a pointer to the new device, or NULL.
+ */
+struct spi_device *spi_alloc_device(struct spi_master *master)
+{
+	struct spi_device	*spi;
+	struct device		*dev = master->dev.parent;
+
+	if (!spi_master_get(master))
+		return NULL;
+
+	spi = kzalloc(sizeof *spi, GFP_KERNEL);
+	if (!spi) {
+		dev_err(dev, "cannot alloc spi_device\n");
+		spi_master_put(master);
+		return NULL;
+	}
+
+	spi->master = master;
+	spi->dev.parent = dev;
+	spi->dev.bus = &spi_bus_type;
+	spi->dev.release = spidev_release;
+	device_initialize(&spi->dev);
+	return spi;
+}
+EXPORT_SYMBOL_GPL(spi_alloc_device);
+
+/**
+ * spi_add_device - Add an spi_device allocated with spi_alloc_device
+ * @spi: spi_device to register
+ *
+ * Companion function to spi_alloc_device.  Devices allocated with
+ * spi_alloc_device can be added onto the spi bus with this function.
+ *
+ * Returns 0 on success; non-zero on failure
+ */
+int spi_add_device(struct spi_device *spi)
+{
+	struct device *dev = spi->master->dev.parent;
+	int status;
+
+	/* Chipselects are numbered 0..max; validate. */
+	if (spi->chip_select >= spi->master->num_chipselect) {
+		dev_err(dev, "cs%d > max %d\n",
+			spi->chip_select,
+			spi->master->num_chipselect);
+		return -EINVAL;
+	}
+
+	/* Set the bus ID string */
+	snprintf(spi->dev.bus_id, sizeof spi->dev.bus_id,
+			"%s.%u", spi->master->dev.bus_id,
+			spi->chip_select);
+
+	/* drivers may modify this initial i/o setup */
+	status = spi->master->setup(spi);
+	if (status < 0) {
+		dev_err(dev, "can't %s %s, status %d\n",
+				"setup", spi->dev.bus_id, status);
+		return status;
+	}
+
+	/* driver core catches callers that misbehave by defining
+	 * devices that already exist.
+	 */
+	status = device_add(&spi->dev);
+	if (status < 0) {
+		dev_err(dev, "can't %s %s, status %d\n",
+				"add", spi->dev.bus_id, status);
+		return status;
+	}
+
+	dev_dbg(dev, "registered child %s\n", spi->dev.bus_id);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(spi_add_device);
 
 /**
  * spi_new_device - instantiate one new SPI device
@@ -197,7 +287,6 @@ struct spi_device *spi_new_device(struct spi_master *master,
 				  struct spi_board_info *chip)
 {
 	struct spi_device	*proxy;
-	struct device		*dev = master->dev.parent;
 	int			status;
 
 	/* NOTE:  caller did any chip->bus_num checks necessary.
@@ -207,66 +296,28 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	 * suggests syslogged diagnostics are best here (ugh).
 	 */
 
-	/* Chipselects are numbered 0..max; validate. */
-	if (chip->chip_select >= master->num_chipselect) {
-		dev_err(dev, "cs%d > max %d\n",
-			chip->chip_select,
-			master->num_chipselect);
-		return NULL;
-	}
-
-	if (!spi_master_get(master))
+	proxy = spi_alloc_device(master);
+	if (!proxy)
 		return NULL;
 
 	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
 
-	proxy = kzalloc(sizeof *proxy, GFP_KERNEL);
-	if (!proxy) {
-		dev_err(dev, "can't alloc dev for cs%d\n",
-			chip->chip_select);
-		goto fail;
-	}
-	proxy->master = master;
 	proxy->chip_select = chip->chip_select;
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
 	strlcpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
-
-	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
-			"%s.%u", master->dev.bus_id,
-			chip->chip_select);
-	proxy->dev.parent = dev;
-	proxy->dev.bus = &spi_bus_type;
 	proxy->dev.platform_data = (void *) chip->platform_data;
 	proxy->controller_data = chip->controller_data;
 	proxy->controller_state = NULL;
-	proxy->dev.release = spidev_release;
 
-	/* drivers may modify this initial i/o setup */
-	status = master->setup(proxy);
+	status = spi_add_device(proxy);
 	if (status < 0) {
-		dev_err(dev, "can't %s %s, status %d\n",
-				"setup", proxy->dev.bus_id, status);
-		goto fail;
+		spi_dev_put(proxy);
+		return NULL;
 	}
 
-	/* driver core catches callers that misbehave by defining
-	 * devices that already exist.
-	 */
-	status = device_register(&proxy->dev);
-	if (status < 0) {
-		dev_err(dev, "can't %s %s, status %d\n",
-				"add", proxy->dev.bus_id, status);
-		goto fail;
-	}
-	dev_dbg(dev, "registered child %s\n", proxy->dev.bus_id);
 	return proxy;
-
-fail:
-	spi_master_put(master);
-	kfree(proxy);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(spi_new_device);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index b55910b..d45967e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -778,8 +778,18 @@ spi_register_board_info(struct spi_board_info const *info, unsigned n)
  * use spi_new_device() to describe each device.  You can also call
  * spi_unregister_device() to start making that device vanish, but
  * normally that would be handled by spi_unregister_master().
+ *
+ * You can also use spi_alloc_device() and spi_add_device() to
+ * for a two stage registration of an SPI device.  This gives the caller
+ * some more control over the spi_device structure before it is registered
  */
 extern struct spi_device *
+spi_alloc_device(struct spi_master *master);
+
+extern int
+spi_add_device(struct spi_device *spi);
+
+extern struct spi_device *
 spi_new_device(struct spi_master *, struct spi_board_info *);
 
 static inline void

