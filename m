Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbZBXP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbZBXP54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZBXP5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:57:36 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:41234 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756752AbZBXP5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:57:35 -0500
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [RFC PATCH 1/3] platform_device: add init() exit() callbacks
To: greg@kroah.com
Cc: s.hauer@pengutronix.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2009 17:57:31 +0200
Message-ID: <20090224155731.28880.77132.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some(many?) platform drivers needs board specific callbacks
to initialize/deinitialize(request/release) GPIO pins,
generic bus initialization, board specific configuration
and etc.

Currently this is done by passing pointers to such functions
through platform_data. It is common for such drivers to have
init()/exit() functions declared in platform_data structure.

Using platform_data for this purpose has some drawbacks:
1. You have to write checks for platform_data and functions
   pointers existance and ensure correct error path in every
   platform driver.
2. Since part of the code is in driver and another in board
   specific code, usually you have to push this code through
   different maintainers. This also adds some not necessary work
   to ensure that adding changes to the board code, while changes
   to the driver are still pending, will not break this board
   compilation.
3. In my case, I am adding support for new ARM CPU, this needs
   to be done for some already existing drivers like serial 8250,
   mtd physmap and etc. this becomes pain in the ...

Adding init()/exit() callbacks to the platform_device eliminates
these drawbacks and you can simply add board specific init()/exit()
without changing any code in the driver itself.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 Documentation/driver-model/platform.txt |    8 ++++++--
 drivers/base/platform.c                 |   21 +++++++++++++++++++--
 include/linux/platform_device.h         |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)


diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 83009fd..9bac835 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -18,8 +18,10 @@ is direct addressing from a CPU bus.  Rarely, a platform_device will
 be connected through a segment of some other kind of bus; but its
 registers will still be directly addressable.
 
-Platform devices are given a name, used in driver binding, and a
-list of resources such as addresses and IRQs.
+Platform devices are given a name, used in driver binding, a list
+of resources such as addresses and IRQs, and optionaly board/platform
+specific init()/exit() functions called before probing and after removing
+platform driver.
 
 struct platform_device {
 	const char	*name;
@@ -27,6 +29,8 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	*resource;
+	int (*init)(struct platform_device *);
+	void (*exit)(struct platform_device *);
 };
 
 
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349a101..c3ef008 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -444,8 +444,19 @@ static int platform_drv_probe(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
+	int retval;
+
+	if (dev->init) {
+		retval = dev->init(dev);
+		if (retval)
+			return retval;
+	}
+
+	retval = drv->probe(dev);
+	if (retval && dev->exit)
+		dev->exit(dev);
 
-	return drv->probe(dev);
+	return retval;
 }
 
 static int platform_drv_probe_fail(struct device *_dev)
@@ -457,8 +468,14 @@ static int platform_drv_remove(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
+	int retval;
+
+	retval = drv->remove(dev);
 
-	return drv->remove(dev);
+	if (!retval && dev->exit)
+		dev->exit(dev);
+
+	return retval;
 }
 
 static void platform_drv_shutdown(struct device *_dev)
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 9a34269..d51f19e 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -19,6 +19,8 @@ struct platform_device {
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
+	int (*init)(struct platform_device *);
+	void (*exit)(struct platform_device *);
 };
 
 #define to_platform_device(x) container_of((x), struct platform_device, dev)

