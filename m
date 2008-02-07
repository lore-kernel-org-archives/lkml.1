Return-Path: <linux-kernel-owner+w=401wt.eu-S933985AbYBGX5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbYBGX5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYBGX5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:57:25 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35377 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085AbYBGX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:57:24 -0500
X-Sasl-enc: FK6RoESFzW2Fvg1O4LYE8Jy2xZcT02S0wNWlbH8oP4g4 1202428642
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 2/3] ACPI: thinkpad-acpi: add sysfs led class support for thinklight
Date: Thu,  7 Feb 2008 21:57:12 -0200
Message-Id: <1202428633-6711-2-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
References: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sysfs led class interface to the thinklight (light subdriver).

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/thinkpad-acpi.txt |   25 ++++++++++++++++++++-----
 drivers/misc/thinkpad_acpi.c    |   39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/thinkpad-acpi.txt b/Documentation/thinkpad-acpi.txt
index 204161e..0301394 100644
--- a/Documentation/thinkpad-acpi.txt
+++ b/Documentation/thinkpad-acpi.txt
@@ -640,16 +640,31 @@ while others are still having problems. For more information:
 
 https://bugs.freedesktop.org/show_bug.cgi?id=2000
 
-ThinkLight control -- /proc/acpi/ibm/light
-------------------------------------------
+ThinkLight control
+------------------
+
+procfs: /proc/acpi/ibm/light
+sysfs attributes: as per led class, for the "tp::thinklight" led
+
+procfs notes:
 
-The current status of the ThinkLight can be found in this file. A few
-models which do not make the status available will show it as
-"unknown". The available commands are:
+The ThinkLight status can be read and set through the procfs interface.  A
+few models which do not make the status available will show the ThinkLight
+status as "unknown". The available commands are:
 
 	echo on  > /proc/acpi/ibm/light
 	echo off > /proc/acpi/ibm/light
 
+sysfs notes:
+
+The ThinkLight sysfs interface is documented by the led class
+documentation, in Documentation/leds-class.txt.  The ThinkLight led name
+is "tp::thinklight".
+
+Due to limitations in the sysfs led class, if the status of the thinklight
+cannot be read or if it is unknown, thinkpad-acpi will report it as "off".
+It is impossible to know if the status returned through sysfs is valid.
+
 Docking / undocking -- /proc/acpi/ibm/dock
 ------------------------------------------
 
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index c2cb796..68bd8a1 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -67,6 +67,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/input.h>
+#include <linux/leds.h>
 #include <asm/uaccess.h>
 
 #include <linux/dmi.h>
@@ -3095,8 +3096,27 @@ static int light_set_status(int status)
 	return -ENXIO;
 }
 
+static void light_sysfs_set(struct led_classdev *led_cdev,
+			enum led_brightness brightness)
+{
+	light_set_status((brightness != LED_OFF));
+}
+
+static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
+{
+	return (light_get_status() == 1)? LED_FULL : LED_OFF;
+}
+
+static struct led_classdev tpacpi_led_thinklight = {
+	.name		= "tp::thinklight",
+	.brightness_set = &light_sysfs_set,
+	.brightness_get = &light_sysfs_get,
+};
+
 static int __init light_init(struct ibm_init_struct *iibm)
 {
+	int rc = 0;
+
 	vdbg_printk(TPACPI_DBG_INIT, "initializing light subdriver\n");
 
 	TPACPI_ACPIHANDLE_INIT(ledb);
@@ -3115,7 +3135,23 @@ static int __init light_init(struct ibm_init_struct *iibm)
 	vdbg_printk(TPACPI_DBG_INIT, "light is %s\n",
 		str_supported(tp_features.light));
 
-	return (tp_features.light)? 0 : 1;
+	if (tp_features.light) {
+		rc = led_classdev_register(&tpacpi_pdev->dev,
+					   &tpacpi_led_thinklight);
+	}
+
+	if (rc < 0) {
+		tp_features.light = 0;
+		tp_features.light_status = 0;
+	} else {
+		rc = (tp_features.light)? 0 : 1;
+	}
+	return rc;
+}
+
+static void light_exit(void)
+{
+	led_classdev_unregister(&tpacpi_led_thinklight);
 }
 
 static int light_read(char *p)
@@ -3163,6 +3199,7 @@ static struct ibm_struct light_driver_data = {
 	.name = "light",
 	.read = light_read,
 	.write = light_write,
+	.exit = light_exit,
 };
 
 /*************************************************************************
-- 
1.5.3.8

