Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYJ3BJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYJ3BJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ3BJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:09:16 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:58226 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJ3BJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:09:14 -0400
Subject: input: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:09:15 +0100
Message-Id: <1225328955.5970.64.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: input: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/input/evbug.c b/drivers/input/evbug.c
index 0353601..f7c5c14 100644
--- a/drivers/input/evbug.c
+++ b/drivers/input/evbug.c
@@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
 static void evbug_event(struct input_handle *handle, unsigned int type, unsigned int code, int value)
 {
 	printk(KERN_DEBUG "evbug.c: Event. Dev: %s, Type: %d, Code: %d, Value: %d\n",
-		handle->dev->dev.bus_id, type, code, value);
+		dev_name(&handle->dev->dev), type, code, value);
 }
 
 static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
@@ -65,7 +65,7 @@ static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_unregister_handle;
 
 	printk(KERN_DEBUG "evbug.c: Connected device: %s (%s at %s)\n",
-		dev->dev.bus_id,
+		dev_name(&dev->dev),
 		dev->name ?: "unknown",
 		dev->phys ?: "unknown");
 
@@ -81,7 +81,7 @@ static int evbug_connect(struct input_handler *handler, struct input_dev *dev,
 static void evbug_disconnect(struct input_handle *handle)
 {
 	printk(KERN_DEBUG "evbug.c: Disconnected device: %s\n",
-		handle->dev->dev.bus_id);
+		dev_name(&handle->dev->dev));
 
 	input_close_device(handle);
 	input_unregister_handle(handle);
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 3524bef..34090c6 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -1001,7 +1001,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
 
-	strlcpy(evdev->dev.bus_id, evdev->name, sizeof(evdev->dev.bus_id));
+	dev_set_name(&evdev->dev, evdev->name);
 	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 2880eaa..ebf4be5 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -530,8 +530,7 @@ static void gameport_init_port(struct gameport *gameport)
 
 	mutex_init(&gameport->drv_mutex);
 	device_initialize(&gameport->dev);
-	snprintf(gameport->dev.bus_id, sizeof(gameport->dev.bus_id),
-		 "gameport%lu", (unsigned long)atomic_inc_return(&gameport_no) - 1);
+	dev_set_name(&gameport->dev, "gameport%lu", (unsigned long)atomic_inc_return(&gameport_no) - 1);
 	gameport->dev.bus = &gameport_bus;
 	gameport->dev.release = gameport_release_port;
 	if (gameport->parent)
diff --git a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
index 2b282cd..db556b7 100644
--- a/drivers/input/gameport/ns558.c
+++ b/drivers/input/gameport/ns558.c
@@ -226,7 +226,7 @@ static int ns558_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 	ns558->gameport = port;
 
 	gameport_set_name(port, "NS558 PnP Gameport");
-	gameport_set_phys(port, "pnp%s/gameport0", dev->dev.bus_id);
+	gameport_set_phys(port, "pnp%s/gameport0", dev_name(&dev->dev));
 	port->dev.parent = &dev->dev;
 	port->io = ioport;
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index c13ced3..1730d73 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1389,8 +1389,8 @@ int input_register_device(struct input_dev *dev)
 	if (!dev->setkeycode)
 		dev->setkeycode = input_default_setkeycode;
 
-	snprintf(dev->dev.bus_id, sizeof(dev->dev.bus_id),
-		 "input%ld", (unsigned long) atomic_inc_return(&input_no) - 1);
+	dev_set_name(&dev->dev, "input%ld",
+		     (unsigned long) atomic_inc_return(&input_no) - 1);
 
 	error = device_add(&dev->dev);
 	if (error)
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 65d7077..f9b876b 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -801,7 +801,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		}
 	}
 
-	strlcpy(joydev->dev.bus_id, joydev->name, sizeof(joydev->dev.bus_id));
+	dev_set_name(&joydev->dev, joydev->name);
 	joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
 	joydev->dev.class = &input_class;
 	joydev->dev.parent = &dev->dev;
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 8137e50..4ab8b28 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -879,8 +879,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	mousedev->handle.handler = handler;
 	mousedev->handle.private = mousedev;
 
-	strlcpy(mousedev->dev.bus_id, mousedev->name,
-		sizeof(mousedev->dev.bus_id));
+	dev_set_name(&mousedev->dev, mousedev->name);
 	mousedev->dev.class = &input_class;
 	if (dev)
 		mousedev->dev.parent = &dev->dev;
diff --git a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
index 1b404f9..1dacbe0 100644
--- a/drivers/input/serio/pcips2.c
+++ b/drivers/input/serio/pcips2.c
@@ -153,7 +153,7 @@ static int __devinit pcips2_probe(struct pci_dev *dev, const struct pci_device_i
 	serio->open		= pcips2_open;
 	serio->close		= pcips2_close;
 	strlcpy(serio->name, pci_name(dev), sizeof(serio->name));
-	strlcpy(serio->phys, dev->dev.bus_id, sizeof(serio->phys));
+	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
 	serio->port_data	= ps2if;
 	serio->dev.parent	= &dev->dev;
 	ps2if->io		= serio;
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 2f12d60..99e27b5 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -546,8 +546,7 @@ static void serio_init_port(struct serio *serio)
 	spin_lock_init(&serio->lock);
 	mutex_init(&serio->drv_mutex);
 	device_initialize(&serio->dev);
-	snprintf(serio->dev.bus_id, sizeof(serio->dev.bus_id),
-		 "serio%ld", (long)atomic_inc_return(&serio_no) - 1);
+	dev_set_name(&serio->dev, "serio%ld", (long)atomic_inc_return(&serio_no) - 1);
 	serio->dev.bus = &serio_bus;
 	serio->dev.release = serio_release_port;
 	if (serio->parent) {
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b9b7fc6..6017ea6 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -559,7 +559,7 @@ static void ads7846_rx(void *ads)
 	if (packet->tc.ignore || Rt > ts->pressure_max) {
 #ifdef VERBOSE
 		pr_debug("%s: ignored %d pressure %d\n",
-			ts->spi->dev.bus_id, packet->tc.ignore, Rt);
+			dev_name(&ts->spi->dev), packet->tc.ignore, Rt);
 #endif
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
 			      HRTIMER_MODE_REL);
@@ -947,7 +947,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 		ts->penirq_recheck_delay_usecs =
 				pdata->penirq_recheck_delay_usecs;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", spi->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", dev_name(&spi->dev));
 
 	input_dev->name = "ADS784x Touchscreen";
 	input_dev->phys = ts->phys;


