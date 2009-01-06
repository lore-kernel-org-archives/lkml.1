Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZAFWX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZAFWX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZAFWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:49 -0500
Received: from kroah.org ([198.145.64.141]:51259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755970AbZAFWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/60] spi: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:49 -0800
Message-Id: <1231279939-32728-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/spi/spi.c           |   20 +++++++++-----------
 drivers/spi/spi_bitbang.c   |    2 +-
 drivers/spi/spi_butterfly.c |    2 +-
 drivers/spi/spi_lm70llp.c   |    2 +-
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3734dc9..643908b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -47,7 +47,7 @@ modalias_show(struct device *dev, struct device_attribute *a, char *buf)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
 
-	return snprintf(buf, BUS_ID_SIZE + 1, "%s\n", spi->modalias);
+	return sprintf(buf, "%s\n", spi->modalias);
 }
 
 static struct device_attribute spi_dev_attrs[] = {
@@ -63,7 +63,7 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
 
-	return strncmp(spi->modalias, drv->name, BUS_ID_SIZE) == 0;
+	return strcmp(spi->modalias, drv->name) == 0;
 }
 
 static int spi_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -243,8 +243,7 @@ int spi_add_device(struct spi_device *spi)
 	}
 
 	/* Set the bus ID string */
-	snprintf(spi->dev.bus_id, sizeof spi->dev.bus_id,
-			"%s.%u", spi->master->dev.bus_id,
+	dev_set_name(&spi->dev, "%s.%u", dev_name(&spi->master->dev),
 			spi->chip_select);
 
 
@@ -254,7 +253,7 @@ int spi_add_device(struct spi_device *spi)
 	 */
 	mutex_lock(&spi_add_lock);
 
-	if (bus_find_device_by_name(&spi_bus_type, NULL, spi->dev.bus_id)
+	if (bus_find_device_by_name(&spi_bus_type, NULL, dev_name(&spi->dev))
 			!= NULL) {
 		dev_err(dev, "chipselect %d already in use\n",
 				spi->chip_select);
@@ -269,7 +268,7 @@ int spi_add_device(struct spi_device *spi)
 	status = spi->master->setup(spi);
 	if (status < 0) {
 		dev_err(dev, "can't %s %s, status %d\n",
-				"setup", spi->dev.bus_id, status);
+				"setup", dev_name(&spi->dev), status);
 		goto done;
 	}
 
@@ -277,9 +276,9 @@ int spi_add_device(struct spi_device *spi)
 	status = device_add(&spi->dev);
 	if (status < 0)
 		dev_err(dev, "can't %s %s, status %d\n",
-				"add", spi->dev.bus_id, status);
+				"add", dev_name(&spi->dev), status);
 	else
-		dev_dbg(dev, "registered child %s\n", spi->dev.bus_id);
+		dev_dbg(dev, "registered child %s\n", dev_name(&spi->dev));
 
 done:
 	mutex_unlock(&spi_add_lock);
@@ -504,12 +503,11 @@ int spi_register_master(struct spi_master *master)
 	/* register the device, then userspace will see it.
 	 * registration fails if the bus ID is in use.
 	 */
-	snprintf(master->dev.bus_id, sizeof master->dev.bus_id,
-		"spi%u", master->bus_num);
+	dev_set_name(&master->dev, "spi%u", master->bus_num);
 	status = device_add(&master->dev);
 	if (status < 0)
 		goto done;
-	dev_dbg(dev, "registered master %s%s\n", master->dev.bus_id,
+	dev_dbg(dev, "registered master %s%s\n", dev_name(&master->dev),
 			dynamic ? " (dynamic)" : "");
 
 	/* populate children from any spi device tables */
diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
index 96cc39e..85e61f4 100644
--- a/drivers/spi/spi_bitbang.c
+++ b/drivers/spi/spi_bitbang.c
@@ -475,7 +475,7 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
 	/* this task is the only thing to touch the SPI bits */
 	bitbang->busy = 0;
 	bitbang->workqueue = create_singlethread_workqueue(
-			bitbang->master->dev.parent->bus_id);
+			dev_name(bitbang->master->dev.parent));
 	if (bitbang->workqueue == NULL) {
 		status = -EBUSY;
 		goto err1;
diff --git a/drivers/spi/spi_butterfly.c b/drivers/spi/spi_butterfly.c
index 0ee2b20..c218486 100644
--- a/drivers/spi/spi_butterfly.c
+++ b/drivers/spi/spi_butterfly.c
@@ -287,7 +287,7 @@ static void butterfly_attach(struct parport *p)
 	pp->dataflash = spi_new_device(pp->bitbang.master, &pp->info[0]);
 	if (pp->dataflash)
 		pr_debug("%s: dataflash at %s\n", p->name,
-				pp->dataflash->dev.bus_id);
+				dev_name(&pp->dataflash->dev));
 
 	// dev_info(_what?_, ...)
 	pr_info("%s: AVR Butterfly\n", p->name);
diff --git a/drivers/spi/spi_lm70llp.c b/drivers/spi/spi_lm70llp.c
index 39d8d8a..af65267 100644
--- a/drivers/spi/spi_lm70llp.c
+++ b/drivers/spi/spi_lm70llp.c
@@ -287,7 +287,7 @@ static void spi_lm70llp_attach(struct parport *p)
 	pp->spidev_lm70 = spi_new_device(pp->bitbang.master, &pp->info);
 	if (pp->spidev_lm70)
 		dev_dbg(&pp->spidev_lm70->dev, "spidev_lm70 at %s\n",
-				pp->spidev_lm70->dev.bus_id);
+				dev_name(&pp->spidev_lm70->dev));
 	else {
 		printk(KERN_WARNING "%s: spi_new_device failed\n", DRVNAME);
 		status = -ENODEV;
-- 
1.6.0.4

