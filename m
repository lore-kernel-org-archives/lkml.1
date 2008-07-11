Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbYGKNyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbYGKNyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbYGKNsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:17 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34991 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759437AbYGKNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:58 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 6/30] W1: feature, w1_therm.c use strong pullup and documentation
Date: Fri, 11 Jul 2008 17:51:21 +0400
Message-Id: <12157843061218-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added strong pullup to thermal sensor driver and general documentation
on the sensor.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 Documentation/w1/00-INDEX        |    2 +
 Documentation/w1/slaves/00-INDEX |    4 +++
 Documentation/w1/slaves/w1_therm |   41 ++++++++++++++++++++++++++++++++++++++
 drivers/w1/slaves/w1_therm.c     |   15 ++++++++++++-
 4 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/Documentation/w1/00-INDEX b/Documentation/w1/00-INDEX
index 5270cf4..cb49802 100644
--- a/Documentation/w1/00-INDEX
+++ b/Documentation/w1/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- This file
+slaves/
+	- Drivers that provide support for specific family codes.
 masters/
 	- Individual chips providing 1-wire busses.
 w1.generic
diff --git a/Documentation/w1/slaves/00-INDEX b/Documentation/w1/slaves/00-INDEX
new file mode 100644
index 0000000..f8101d6
--- /dev/null
+++ b/Documentation/w1/slaves/00-INDEX
@@ -0,0 +1,4 @@
+00-INDEX
+	- This file
+w1_therm
+	- The Maxim/Dallas Semiconductor ds18*20 temperature sensor.
diff --git a/Documentation/w1/slaves/w1_therm b/Documentation/w1/slaves/w1_therm
new file mode 100644
index 0000000..0403aaa
--- /dev/null
+++ b/Documentation/w1/slaves/w1_therm
@@ -0,0 +1,41 @@
+Kernel driver w1_therm
+====================
+
+Supported chips:
+  * Maxim ds18*20 based temperature sensors.
+
+Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+
+
+Description
+-----------
+
+w1_therm provides basic temperature conversion for ds18*20 devices.
+supported family codes:
+W1_THERM_DS18S20	0x10
+W1_THERM_DS1822		0x22
+W1_THERM_DS18B20	0x28
+
+Support is provided through the sysfs w1_slave file.  Each open and
+read sequence will initiate a temperature conversion then provide two
+lines of ASCII output.  The first line contains the nine hex bytes
+read along with a calculated crc value and YES or NO if it matched.
+If the crc matched the returned values are retained.  The second line
+displays the retained values along with a temperature in millidegrees
+Centigrade after t=.
+
+Parasite powered devices are limited to one slave performing a
+temperature conversion at a time.  If none of the devices are parasite
+powered it would be possible to convert all the devices at the same
+time and then go back to read individual sensors.  That isn't
+currently supported.  The driver also doesn't support reduced
+precision (which would also reduce the conversion time).
+
+The module parameter strong_pullup can be set to 0 to disable the
+strong pullup or 1 to enable.  If enabled the 5V strong pullup will be
+enabled when the conversion is taking place provided the master driver
+must support the strong pullup (or it falls back to a pullup
+resistor).  The DS18b20 temperature sensor specification lists a
+maximum current draw of 1.5mA and that a 5k pullup resistor is not
+sufficient.  The strong pullup is designed to provide the additional
+current required.
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index fb28aca..e87f464 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -37,6 +37,14 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature family.");
 
+/* Allow the strong pullup to be disabled, but default to enabled.
+ * If it was disabled a parasite powered device might not get the require
+ * current to do a temperature conversion.  If it is enabled parasite powered
+ * devices have a better chance of getting the current required.
+ */
+static int w1_strong_pullup = 1;
+module_param_named(strong_pullup, w1_strong_pullup, int, 0);
+
 static u8 bad_roms[][9] = {
 				{0xaa, 0x00, 0x4b, 0x46, 0xff, 0xff, 0x0c, 0x10, 0x87},
 				{}
@@ -192,9 +200,12 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
 			int count = 0;
 			unsigned int tm = 750;
 
+			/* 750ms strong pullup (or delay) after the convert */
+			if (w1_strong_pullup)
+				w1_next_pullup(dev, tm);
 			w1_write_8(dev, W1_CONVERT_TEMP);
-
-			msleep(tm);
+			if (!w1_strong_pullup)
+				msleep(tm);
 
 			if (!w1_reset_select_slave(sl)) {
 
-- 
1.4.4.4

