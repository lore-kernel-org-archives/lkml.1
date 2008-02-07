Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbYBGX62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbYBGX62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbYBGX53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:57:29 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46803 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757599AbYBGX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:57:25 -0500
X-Sasl-enc: mJ9Ci9iGuEMvKUnvTf+HQuM7j5/0xieCxpJg6MbC9o9q 1202428643
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 3/3] ACPI: thinkpad-acpi: add sysfs led class support to thinkpad leds
Date: Thu,  7 Feb 2008 21:57:13 -0200
Message-Id: <1202428633-6711-3-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
References: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sysfs led class interface to the led subdriver.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/thinkpad-acpi.txt |   46 +++++++++++++--
 drivers/misc/thinkpad_acpi.c    |  120 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/Documentation/thinkpad-acpi.txt b/Documentation/thinkpad-acpi.txt
index 0301394..53aa620 100644
--- a/Documentation/thinkpad-acpi.txt
+++ b/Documentation/thinkpad-acpi.txt
@@ -823,28 +823,62 @@ The cmos command interface is prone to firmware split-brain problems, as
 in newer ThinkPads it is just a compatibility layer.  Do not use it, it is
 exported just as a debug tool.
 
-LED control -- /proc/acpi/ibm/led
----------------------------------
+LED control
+-----------
 
-Some of the LED indicators can be controlled through this feature. The
-available commands are:
+procfs: /proc/acpi/ibm/led
+sysfs attributes: as per led class, see below for names
+
+Some of the LED indicators can be controlled through this feature.  On
+some older ThinkPad models, it is possible to query the status of the
+LED indicators as well.  Newer ThinkPads cannot query the real status
+of the LED indicators.
+
+procfs notes:
+
+The available commands are:
 
 	echo '<led number> on' >/proc/acpi/ibm/led
 	echo '<led number> off' >/proc/acpi/ibm/led
 	echo '<led number> blink' >/proc/acpi/ibm/led
 
 The <led number> range is 0 to 7. The set of LEDs that can be
-controlled varies from model to model. Here is the mapping on the X40:
+controlled varies from model to model. Here is the common ThinkPad
+mapping:
 
 	0 - power
 	1 - battery (orange)
 	2 - battery (green)
-	3 - UltraBase
+	3 - UltraBase/dock
 	4 - UltraBay
+	5 - UltraBase battery slot
+	6 - (unknown)
 	7 - standby
 
 All of the above can be turned on and off and can be made to blink.
 
+sysfs notes:
+
+The ThinkPad LED sysfs interface is described in detail by the led class
+documentation, in Documentation/leds-class.txt.
+
+The leds are named: "tp::power", "tp:orange:battery", "tp:green:battery",
+"tp::ultrabase", "tp::ultrabay", "tp::ultrabase_batt", "tp::unknown_led",
+"tp::standby".
+
+Due to limitations in the sysfs led class, if the status of the LED
+indicators cannot be read due to an error, thinkpad-acpi will report it as
+a brightness of zero (same as LED off).
+
+If the thinkpad firmware doesn't support reading the current status, trying
+to read the current LED brightness will just return whatever brightness was
+last written to that attribute.
+
+These LEDs can blink using hardware acceleration.  To request that a
+ThinkPad indicator LED blinks in hardware, use the "timer" trigger, and
+leave the delay_on and delay_off parameters set to zero (to request
+hardware acceleration autodetection).
+
 ACPI sounds -- /proc/acpi/ibm/beep
 ----------------------------------
 
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 68bd8a1..8f0ff2f 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -3233,6 +3233,19 @@ TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
 	   "LED",		/* all others */
 	   );			/* R30, R31 */
 
+#define TPACPI_LED_NUMLEDS 8
+static struct led_classdev *tpacpi_leds;
+static const char const *tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
+	"tp::power",
+	"tp:orange:battery",
+	"tp:green:battery",
+	"tp::ultrabase",
+	"tp::ultrabay",
+	"tp::ultrabase_batt",	/* 19 char + NULL limit on sysfs */
+	"tp::unknown_led",
+	"tp::standby",
+};
+
 static int led_get_status(unsigned int led)
 {
 	int status;
@@ -3296,10 +3309,93 @@ static int led_set_status(unsigned int led, enum led_status_t ledstatus)
 	return rc;
 }
 
+/*
+ * This is highly dependent on the tpacpi_leds array
+ */
+static void led_sysfs_set(struct led_classdev *led_cdev,
+			enum led_brightness brightness)
+{
+	unsigned int led;
+	enum led_status_t newstatus;
+
+	led = led_cdev - tpacpi_leds;
+	BUG_ON(led >= TPACPI_LED_NUMLEDS);
+
+	if (brightness == LED_OFF)
+		newstatus = TPACPI_LED_OFF;
+	else
+		newstatus = TPACPI_LED_ON;
+
+	led_set_status(led, newstatus);
+}
+
+/*
+ * This is highly dependent on the tpacpi_leds array
+ */
+static int led_sysfs_blink_set(struct led_classdev *led_cdev,
+			unsigned long *delay_on, unsigned long *delay_off)
+{
+	unsigned int led;
+
+	led = led_cdev - tpacpi_leds;
+	BUG_ON(led >= TPACPI_LED_NUMLEDS);
+
+	/* Can we choose the flash rate? */
+	if (*delay_on == 0 && *delay_off == 0) {
+		/* yes. set them to the hardware blink rate (1 Hz) */
+		*delay_on = 500; /* ms */
+		*delay_off = 500; /* ms */
+	} else if ((*delay_on != 500) || (*delay_off != 500))
+		return -EINVAL;
+
+	led_set_status(led, TPACPI_LED_BLINK);
+
+	return 0;
+}
+
+/*
+ * This is highly dependent on the tpacpi_leds array
+ */
+static enum led_brightness led_sysfs_get(struct led_classdev *led_cdev)
+{
+	unsigned int led;
+	int rc;
+
+	led = led_cdev - tpacpi_leds;
+	BUG_ON(led >= TPACPI_LED_NUMLEDS);
+
+	rc = led_get_status(led);
+
+	if (rc == TPACPI_LED_OFF || rc < 0)
+		rc = LED_OFF;	/* no error handling in led class :( */
+	else
+		rc = LED_FULL;
+
+	return rc;
+}
+
+static void led_exit(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
+		if (tpacpi_leds[i].name)
+			led_classdev_unregister(&tpacpi_leds[i]);
+	}
+
+	kfree(tpacpi_leds);
+	tpacpi_leds = NULL;
+}
+
 static int __init led_init(struct ibm_init_struct *iibm)
 {
+	unsigned int i;
+	int rc;
+
 	vdbg_printk(TPACPI_DBG_INIT, "initializing LED subdriver\n");
 
+	tpacpi_leds = NULL;
+
 	TPACPI_ACPIHANDLE_INIT(led);
 
 	if (!led_handle)
@@ -3318,6 +3414,29 @@ static int __init led_init(struct ibm_init_struct *iibm)
 	vdbg_printk(TPACPI_DBG_INIT, "LED commands are %s, mode %d\n",
 		str_supported(led_supported), led_supported);
 
+	tpacpi_leds = kzalloc(sizeof(*tpacpi_leds) * TPACPI_LED_NUMLEDS,
+			      GFP_KERNEL);
+	if (!tpacpi_leds) {
+		printk(TPACPI_ERR "Out of memory for LED data\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
+		tpacpi_leds[i].brightness_set = &led_sysfs_set;
+		tpacpi_leds[i].blink_set = &led_sysfs_blink_set;
+		if (led_supported == TPACPI_LED_570)
+			tpacpi_leds[i].brightness_get = &led_sysfs_get;
+		tpacpi_leds[i].name = tpacpi_led_names[i];
+
+		rc = led_classdev_register(&tpacpi_pdev->dev,
+					   &tpacpi_leds[i]);
+		if (rc < 0) {
+			tpacpi_leds[i].name = NULL;
+			led_exit();
+			return rc;
+		}
+	}
+
 	return (led_supported != TPACPI_LED_NONE)? 0 : 1;
 }
 
@@ -3388,6 +3507,7 @@ static struct ibm_struct led_driver_data = {
 	.name = "led",
 	.read = led_read,
 	.write = led_write,
+	.exit = led_exit,
 };
 
 /*************************************************************************
-- 
1.5.3.8

