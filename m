Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYFVPZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYFVPZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 11:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYFVPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 11:25:32 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46926 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYFVPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 11:25:31 -0400
Message-ID: <485E6F12.4010307@keyaccess.nl>
Date: Sun, 22 Jun 2008 17:26:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl> <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl>
In-Reply-To: <485E61DE.6020202@hhs.nl>
Content-Type: multipart/mixed;
 boundary="------------090203030101080208000306"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090203030101080208000306
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 22-06-08 16:29, Hans de Goede wrote:

> Rene Herman wrote:
>> This is an ABI breakage issue and an unfortunate one at that:
>>
> 
> No it is not, in 2.6.26rcX, the acpi thermalzones have grown a hwmon 
> interface, that is they register a hwmon device so that "sensors" and

[ ... ]

Now what? Yes it is. 2.6.25.7 works and 2.6.26-rcX with the same config 
options and the same userspace does not. What do you think ABI breakage 
is? It's not relevant that you feel/know that the lm_sensors userspace 
has a bug; it used to work, it's widely installed and the new kernel 
side code however conceptually correct breaks those setups.

>> But if not, .26 is around the corner and requiring libsensors-3.0 must 
>> really not be.
>>
> I agree that requiring libsensors-3.0.2 for this is not a good solution, 
> but I don't want to be crippling the kernel for what I believe is a bug 
> in 2.10.x either.

You don't need to. As said, just make it optional. The attached seems to 
be working for me.

Rene.

--------------090203030101080208000306
Content-Type: text/plain;
 name="thermal-hwmon.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="thermal-hwmon.diff"

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 4b62852..f6a7652 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -12,3 +12,12 @@ menuconfig THERMAL
 	  cooling devices.
 	  All platforms with ACPI thermal support can use this driver.
 	  If you want this support, you should say Y or M here.
+
+config THERMAL_HWMON
+	bool "Hardware monitoring support"
+	depends on HWMON=y || HWMON=THERMAL
+	help
+	  The generic thermal sysfs driver's hardware monitoring support
+	  requires a 3.0 or later lm_sensors userspace.
+
+	  Say Y if you have a new enough lm_sensors userspace.
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6098787..fe07462 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -295,8 +295,8 @@ thermal_cooling_device_trip_point_show(struct device *dev,
 
 /* Device management */
 
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
+
 /* hwmon sys I/F */
 #include <linux/hwmon.h>
 static LIST_HEAD(thermal_hwmon_list);

--------------090203030101080208000306--
