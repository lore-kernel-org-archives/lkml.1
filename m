Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbXFAPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbXFAPEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXFAPEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:04:36 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:40571 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbXFAPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer;
        b=Aq32/MrFlYLkfICUQN6fc/xqE0qbObXxiOLMD1GlsQ2wtiMVNtEh5e+du7an8mCItFpPS0JKazKd3VcZchl/rMMTH3x6AHKmsUiSl8UXKKxTX5U6cu4b9CPHW6VB5PGh/O42NSLWQ/EBDSQwbxR2brWYTvYTrBAogyOjCHz4V70=
Subject: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Hughes <hughsient@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "kay.sievers" <kay.sievers@vrfy.org>,
       Richard Purdie <rpurdie@openedhand.com>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-urpZ5xrA613iSFLjxhAl"
Date: Fri, 01 Jun 2007 16:04:30 +0100
Message-Id: <1180710270.3782.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-urpZ5xrA613iSFLjxhAl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-05-31 at 00:24 -0700, Greg KH wrote: 
> On Wed, May 30, 2007 at 05:19:31PM +0100, Richard Purdie wrote:
> > On Wed, 2007-05-30 at 16:34 +0100, Richard Hughes wrote:
> > > I've talked with other kernel guys here at red hat and they don't think
> > > putting properties in the handle is a good idea.
> > > 
> > > I've cc'd Kay, Greg KH and a few other developers for comments.
> > > 
> > > To summarize, the LED device class creates a device with a ":" delimited
> > > handle, where properties that are not going to changed get included in
> > > the handle name for userspace to parse with sscanf. For
> > > example, /sys/class/leds/thinklight:blue:keyboard_backlight/brightness
> > > 
> > > I think this breaks the one-value-per sysfs file rule and sure makes it
> > > more difficult to extract information in HAL. The backlight class should
> > > have an attribute "color" and "function" so new properties can be added
> > > (or ones that make no sense removed) without breaking API, but the
> > > maintainer doesn't like that idea.
> > 
> > I will put my side (as the above maintainer) across. When deciding on
> > the naming for the LEDs in /sys/class/leds/ we had several choices.
> > Taking my handheld as an example, some choices were:
> > 
> > /sys/class/leds/led0/
> > /sys/class/leds/led1/
> 
> Yes.
> 
> > /sys/class/leds/spitz0/
> > /sys/class/leds/spitz1/
> 
> Yes.
> 
> > /sys/class/leds/spitz:amber/
> > /sys/class/leds/spitz:green/
> 
> No way!  Don't do that.
> 
> > The first contains no useful information, the second one is only
> > fractionally better, the third is actually quite useful. Faced with the
> > third name, a person can actually point to the right LED on the device.
> 
> So?  You need to read the attributes in the sysfs device directory to
> find out exactly what type of device this is, what it does, and all
> sorts of other information.
> 
> The first two examples above are correct.  They use a "bus id" type
> naming scheme, like ALL OTHER DEVICES IN THE KERNEL.  The only
> requirement is that it is unique.
> 
> Userspace programs, like HAL, can handle the fact that spitz0 is really
> a gree LED and it means that the device is charging.  That all comes
> from the individual sysfs files.
> 
> So please, don't imbend sysfs attributes into the bus id for the device,
> that's just wrong on so many levels...
> 
> > As far as the class is concerned, LED colour is a static property (it
> > could handle multi coloured through multiple LED devices).
> 
> Yes, and as a property, it needs to be an attribute, not the bus id.
> 
> Do you really want to see /sys/bus/usb/devices/usb:hub23 or
> /sys/bus/usb/devices/usb:nerf_rocket_launcher3 ?  No, just read the
> attributes to determine the type of the device, like all other devices.
> 
> Please, if this is the way that the code is currently working, change it
> now.

Kay,

Patch attached corrects all the brokenness with the led class (encoding
some attributes in the device handle).

 Documentation/leds-class.txt    |   13 --------
 drivers/leds/led-class.c        |   62 ++++++++++++++++++++++++++++++++++++++--
 drivers/leds/leds-ams-delta.c   |   18 +++++++----
 drivers/leds/leds-corgi.c       |    8 +++--
 drivers/leds/leds-h1940.c       |   12 +++++--
 drivers/leds/leds-locomo.c      |    8 +++--
 drivers/leds/leds-net48xx.c     |    3 +
 drivers/leds/leds-spitz.c       |    8 +++--
 drivers/leds/leds-tosa.c        |    8 +++--
 drivers/leds/leds-wrap.c        |    6 ++-
 drivers/macintosh/via-pmu-led.c |    1 
 drivers/misc/asus-laptop.c      |    3 +
 include/linux/leds.h            |    2 +
 13 files changed, 115 insertions(+), 37 deletions(-)

Signed-off-by: Richard Hughes <richard@hughsie.com>

Please review attached patch, thanks.


--=-urpZ5xrA613iSFLjxhAl
Content-Disposition: attachment; filename=leds-add-colour-and-description.patch
Content-Type: text/x-patch; name=leds-add-colour-and-description.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/Documentation/leds-class.txt b/Documentation/leds-class.txt
index 8c35c04..083222b 100644
--- a/Documentation/leds-class.txt
+++ b/Documentation/leds-class.txt
@@ -34,19 +34,6 @@ and the aim is to keep a small amount of code giving as much functionality
 as possible.  Please keep this in mind when suggesting enhancements.
 
 
-LED Device Naming
-=================
-
-Is currently of the form:
-
-"devicename:colour"
-
-There have been calls for LED properties such as colour to be exported as
-individual led class attributes. As a solution which doesn't incur as much
-overhead, I suggest these become part of the device name. The naming scheme
-above leaves scope for further attributes should they be needed.
-
-
 Known Issues
 ============
 
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 3c17112..42b7355 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -36,6 +36,30 @@ static ssize_t led_brightness_show(struct class_device *dev, char *buf)
 	return ret;
 }
 
+static ssize_t led_colour_show(struct class_device *dev, char *buf)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	ssize_t ret = 0;
+
+	/* no lock needed for this */
+	sprintf(buf, "%s\n", led_cdev->colour);
+	ret = strlen(buf) + 1;
+
+	return ret;
+}
+
+static ssize_t led_description_show(struct class_device *dev, char *buf)
+{
+	struct led_classdev *led_cdev = class_get_devdata(dev);
+	ssize_t ret = 0;
+
+	/* no lock needed for this */
+	sprintf(buf, "%s\n", led_cdev->description);
+	ret = strlen(buf) + 1;
+
+	return ret;
+}
+
 static ssize_t led_brightness_store(struct class_device *dev,
 				const char *buf, size_t size)
 {
@@ -58,6 +82,8 @@ static ssize_t led_brightness_store(struct class_device *dev,
 
 static CLASS_DEVICE_ATTR(brightness, 0644, led_brightness_show,
 			led_brightness_store);
+static CLASS_DEVICE_ATTR(colour, 0644, led_colour_show, NULL);
+static CLASS_DEVICE_ATTR(description, 0644, led_description_show, NULL);
 #ifdef CONFIG_LEDS_TRIGGERS
 static CLASS_DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
 #endif
@@ -106,6 +132,19 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	if (rc)
 		goto err_out;
 
+	/* these are optional */
+	if (led_cdev->colour)
+		rc = class_device_create_file(led_cdev->class_dev,
+					      &class_device_attr_colour);
+		if (rc)
+			goto err_out_brightness;
+	if (led_cdev->description)
+		rc = class_device_create_file(led_cdev->class_dev,
+					      &class_device_attr_description);
+		if (rc)
+			goto err_out_colour;
+
+
 	/* add to the list of leds */
 	write_lock(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
@@ -129,12 +168,23 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 
 #ifdef CONFIG_LEDS_TRIGGERS
 err_out_led_list:
-	class_device_remove_file(led_cdev->class_dev,
-				&class_device_attr_brightness);
-	list_del(&led_cdev->node);
+	if (led_cdev->description)
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_description);
 #endif
+
+err_out_colour:
+	if (led_cdev->colour)
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_colour);
+err_out_brightness:
+	class_device_remove_file(led_cdev->class_dev,
+				 &class_device_attr_brightness);
 err_out:
 	class_device_unregister(led_cdev->class_dev);
+
+	list_del(&led_cdev->node);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(led_classdev_register);
@@ -149,6 +199,12 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 {
 	class_device_remove_file(led_cdev->class_dev,
 				&class_device_attr_brightness);
+	if (led_cdev->colour)
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_colour);
+	if (led_cdev->description)
+		class_device_remove_file(led_cdev->class_dev,
+					 &class_device_attr_description);
 #ifdef CONFIG_LEDS_TRIGGERS
 	class_device_remove_file(led_cdev->class_dev,
 				&class_device_attr_trigger);
diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
index 599878c..21b1bef 100644
--- a/drivers/leds/leds-ams-delta.c
+++ b/drivers/leds/leds-ams-delta.c
@@ -37,42 +37,48 @@ static void ams_delta_led_set(struct led_classdev *led_cdev,
 static struct ams_delta_led ams_delta_leds[] = {
 	{
 		.cdev		= {
-			.name		= "ams-delta:camera",
+			.name		= "ams-delta-camera",
+			.description	= "camera",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_CAMERA,
 	},
 	{
 		.cdev		= {
-			.name		= "ams-delta:advert",
+			.name		= "ams-delta-advert",
+			.description	= "advert",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_ADVERT,
 	},
 	{
 		.cdev		= {
-			.name		= "ams-delta:email",
+			.name		= "ams-delta-email",
+			.description	= "email",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_EMAIL,
 	},
 	{
 		.cdev		= {
-			.name		= "ams-delta:handsfree",
+			.name		= "ams-delta-handsfree",
+			.description	= "handsfree",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_HANDSFREE,
 	},
 	{
 		.cdev		= {
-			.name		= "ams-delta:voicemail",
+			.name		= "ams-delta-voicemail",
+			.description	= "voicemail",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICEMAIL,
 	},
 	{
 		.cdev		= {
-			.name		= "ams-delta:voice",
+			.name		= "ams-delta-voice",
+			.description	= "voice",
 			.brightness_set = ams_delta_led_set,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICE,
diff --git a/drivers/leds/leds-corgi.c b/drivers/leds/leds-corgi.c
index cf1dcd7..eeb5a7c 100644
--- a/drivers/leds/leds-corgi.c
+++ b/drivers/leds/leds-corgi.c
@@ -38,13 +38,17 @@ static void corgiled_green_set(struct led_classdev *led_cdev, enum led_brightnes
 }
 
 static struct led_classdev corgi_amber_led = {
-	.name			= "corgi:amber",
+	.name			= "corgi_charge",
+	.colour			= "amber",
+	.description		= "charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= corgiled_amber_set,
 };
 
 static struct led_classdev corgi_green_led = {
-	.name			= "corgi:green",
+	.name			= "corgi_disk",
+	.colour			= "green",
+	.description		= "disk",
 	.default_trigger	= "nand-disk",
 	.brightness_set		= corgiled_green_set,
 };
diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
index 677c993..d134c79 100644
--- a/drivers/leds/leds-h1940.c
+++ b/drivers/leds/leds-h1940.c
@@ -44,7 +44,9 @@ void h1940_greenled_set(struct led_classdev *led_dev, enum led_brightness value)
 }
 
 static struct led_classdev h1940_greenled = {
-	.name			= "h1940:green",
+	.name			= "h1940_green",
+	.colour			= "green",
+	.description		= "charger",
 	.brightness_set		= h1940_greenled_set,
 	.default_trigger	= "h1940-charger",
 };
@@ -73,7 +75,9 @@ void h1940_redled_set(struct led_classdev *led_dev, enum led_brightness value)
 }
 
 static struct led_classdev h1940_redled = {
-	.name			= "h1940:red",
+	.name			= "h1940_charger",
+	.colour			= "red",
+	.description		= "charger",
 	.brightness_set		= h1940_redled_set,
 	.default_trigger	= "h1940-charger",
 };
@@ -96,7 +100,9 @@ void h1940_blueled_set(struct led_classdev *led_dev, enum led_brightness value)
 }
 
 static struct led_classdev h1940_blueled = {
-	.name			= "h1940:blue",
+	.name			= "h1940_bluetooth",
+	.colour			= "blue",
+	.description		= "bluetooth",
 	.brightness_set		= h1940_blueled_set,
 	.default_trigger	= "h1940-bluetooth",
 };
diff --git a/drivers/leds/leds-locomo.c b/drivers/leds/leds-locomo.c
index 6f2d449..0e297d4 100644
--- a/drivers/leds/leds-locomo.c
+++ b/drivers/leds/leds-locomo.c
@@ -43,13 +43,17 @@ static void locomoled_brightness_set1(struct led_classdev *led_cdev,
 }
 
 static struct led_classdev locomo_led0 = {
-	.name			= "locomo:amber",
+	.name			= "locomo_charge",
+	.colour			= "amber",
+	.description		= "charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= locomoled_brightness_set0,
 };
 
 static struct led_classdev locomo_led1 = {
-	.name			= "locomo:green",
+	.name			= "locomo_disk",
+	.colour			= "green",
+	.description		= "disk",
 	.default_trigger	= "nand-disk",
 	.brightness_set		= locomoled_brightness_set1,
 };
diff --git a/drivers/leds/leds-net48xx.c b/drivers/leds/leds-net48xx.c
index 45ba3d4..5e21553 100644
--- a/drivers/leds/leds-net48xx.c
+++ b/drivers/leds/leds-net48xx.c
@@ -31,7 +31,8 @@ static void net48xx_error_led_set(struct led_classdev *led_cdev,
 }
 
 static struct led_classdev net48xx_error_led = {
-	.name		= "net48xx:error",
+	.name		= "net48xx_error",
+	.description	= "error",
 	.brightness_set	= net48xx_error_led_set,
 };
 
diff --git a/drivers/leds/leds-spitz.c b/drivers/leds/leds-spitz.c
index 126d09c..b8340ab 100644
--- a/drivers/leds/leds-spitz.c
+++ b/drivers/leds/leds-spitz.c
@@ -38,13 +38,17 @@ static void spitzled_green_set(struct led_classdev *led_cdev, enum led_brightnes
 }
 
 static struct led_classdev spitz_amber_led = {
-	.name			= "spitz:amber",
+	.name			= "spitz_charge",
+	.colour			= "amber",
+	.description		= "charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= spitzled_amber_set,
 };
 
 static struct led_classdev spitz_green_led = {
-	.name			= "spitz:green",
+	.name			= "spitz_disk",
+	.colour			= "green",
+	.description		= "disk",
 	.default_trigger	= "ide-disk",
 	.brightness_set		= spitzled_green_set,
 };
diff --git a/drivers/leds/leds-tosa.c b/drivers/leds/leds-tosa.c
index fb2416a..6e2fb39 100644
--- a/drivers/leds/leds-tosa.c
+++ b/drivers/leds/leds-tosa.c
@@ -45,13 +45,17 @@ static void tosaled_green_set(struct led_classdev *led_cdev,
 }
 
 static struct led_classdev tosa_amber_led = {
-	.name			= "tosa:amber",
+	.name			= "tosa_charge",
+	.colour			= "amber",
+	.description		= "charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= tosaled_amber_set,
 };
 
 static struct led_classdev tosa_green_led = {
-	.name			= "tosa:green",
+	.name			= "tosa_disk",
+	.colour			= "green",
+	.description		= "disk",
 	.default_trigger	= "nand-disk",
 	.brightness_set		= tosaled_green_set,
 };
diff --git a/drivers/leds/leds-wrap.c b/drivers/leds/leds-wrap.c
index 27fb2d8..1daa13e 100644
--- a/drivers/leds/leds-wrap.c
+++ b/drivers/leds/leds-wrap.c
@@ -43,12 +43,14 @@ static void wrap_extra_led_set(struct led_classdev *led_cdev,
 }
 
 static struct led_classdev wrap_error_led = {
-	.name		= "wrap:error",
+	.name		= "wrap_error",
+	.description	= "error",
 	.brightness_set	= wrap_error_led_set,
 };
 
 static struct led_classdev wrap_extra_led = {
-	.name           = "wrap:extra",
+	.name           = "wrap_extra",
+	.description    = "extra",
 	.brightness_set = wrap_extra_led_set,
 };
 
diff --git a/drivers/macintosh/via-pmu-led.c b/drivers/macintosh/via-pmu-led.c
index 55ad956..b67a95a 100644
--- a/drivers/macintosh/via-pmu-led.c
+++ b/drivers/macintosh/via-pmu-led.c
@@ -73,6 +73,7 @@ static void pmu_led_set(struct led_classdev *led_cdev,
 
 static struct led_classdev pmu_led = {
 	.name = "pmu-front-led",
+	.description = "front-led",
 #ifdef CONFIG_ADB_PMU_LED_IDE
 	.default_trigger = "ide-disk",
 #endif
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 4f9060a..d7f1175 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -235,7 +235,8 @@ static struct workqueue_struct *led_workqueue;
 	static int object##_led_wk;					\
 	static DECLARE_WORK(object##_led_work, object##_led_update);	\
 	static struct led_classdev object##_led = {			\
-		.name           = "asus:" ledname,			\
+		.name           = "asus_" ledname,			\
+		.description    = ledname,				\
 		.brightness_set = object##_led_set,			\
 	}
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 88afcef..c9cb394 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -41,6 +41,8 @@ struct led_classdev {
 	struct class_device	*class_dev;
 	struct list_head	 node;			/* LED Device list */
 	char			*default_trigger;	/* Trigger to use */
+	char			*colour;		/* Colour of the LED */
+	char			*description;		/* Description of purpose */
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */

--=-urpZ5xrA613iSFLjxhAl--

