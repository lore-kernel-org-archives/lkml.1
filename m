Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYFXDrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYFXDrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYFXDrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:47:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:40229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYFXDrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,693,1204531200"; 
   d="scan'208";a="344840340"
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
	userspace
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Jean Delvare <khali@linux-fr.org>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
	 <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca>
	 <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 11:47:38 +0800
Message-Id: <1214279258.3001.76.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-24 at 11:07 +0800, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Jun 2008, Robert Hancock wrote:
> 
> > Mark M. Hoffman wrote:
> > >
> > > 1) The bug is in libsensors (2.10), not the kernel.
> >
> > This doesn't matter. Breaking userspace in such a fashion is
> severely frowned
> > upon unless essentially unavoidable, even if it is just triggering a
> bug.
> 
> I do tend to agree. If it used to work, it should continue to work,
> even
> if it wasn't _meant_ to work.
> 
> That's not always 100% possible, but the fact is, neither is updating
> user
> space always possible. The kernel needs to try its best to maintain
> stable
> interfaces, and no, "..but the interface was broken" is _not_ an
> acceptable excuse for unbreaking it if it causes problems.
> 
> > > - but more importantly -
> > >
> > > 2) This patch is broken.
> >
> > You didn't indicate what was wrong with the patch.
> 
> Yes. Leaving everybody wondering whether it's just an opinionated
> expression of the former problem, or whether there is a real and
> understandable reason why it was NACK'ed.

Multiple thermal zone devices may share the same hwmon device.
here is an example,
# grep . /sys/class/hwmon/hwmon0/*
/sys/class/hwmon/hwmon0/name:acpitz
/sys/class/hwmon/hwmon0/temp1_crit:127000
/sys/class/hwmon/hwmon0/temp1_input:40000
/sys/class/hwmon/hwmon0/temp2_crit:100000
/sys/class/hwmon/hwmon0/temp2_input:44000

temp1 and temp2 stand for different ACPI thermal zones.

This patch will break if the first ACPI thermal zone is unregistered
before the others, although it only happens theoretically.
Plus, as this is not a 1:1 binding, a symbol link from the hwmon device
to thermal zone device doesn't make sense.

Following is a possible solution which is also from Rene,
while I think CONFIG_THERMAL_HWMON should be "default n".

thanks,
rui

>From 7b41d17346cdd1f9db1223c024bd9f4604ee5c82 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Mon, 23 Jun 2008 21:50:25 +0200
Subject: [PATCH] acpi/thermal: allow disabling of thermal zone hwmon support

2.6.26-rc gained a hwmon interface to the Thermal Zone driver
which unfortunately breaks lm-sensors 2 userspace and renders
all other (subsequent) hwmon sensors inoperable also.

Many systems, current slackware and derivative systems among
them, are using lm-sensors 2 and would be affected. A new
lm-sensors 2.10.7 release is needed to fix this from the user
side.

This makes the hwmon support optional (enabled by default) and
comments that it needs a new enough lm-sensors userspace. This
also immediately schedules the option for removal again as this
is only intended to not break systems over the 2.6.26 upgrade
when new enough lm-sensors is not yet available or widely
deployed.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
CC: Len Brown <lenb@kernel.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Mark M. Hoffman <mhoffman@lightlink.com>
CC: Jean Delvare <khali@linux-fr.org>
CC: linux-acpi@vger.kernel.org
CC: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/thermal/Kconfig                    |   10 ++++++++++
 drivers/thermal/thermal_sys.c              |    4 ++--
 include/linux/thermal.h                    |    6 ++----
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 5b3f31f..46ece3f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -312,3 +312,12 @@ When:	2.6.26
 Why:	Implementation became generic; users should now include
 	linux/semaphore.h instead.
 Who:	Matthew Wilcox <willy@linux.intel.com>
+
+---------------------------
+
+What:	CONFIG_THERMAL_HWMON
+When:	January 2009
+Why:	This option was introduced just to allow older lm-sensors userspace
+	to keep working over the upgrade to 2.6.26. At the scheduled time of
+	removal fixed lm-sensors (2.x or 3.x) should be readily available.
+Who:	Rene Herman <rene.herman@gmail.com>
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 4b62852..0b359ab 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -12,3 +12,13 @@ menuconfig THERMAL
 	  cooling devices.
 	  All platforms with ACPI thermal support can use this driver.
 	  If you want this support, you should say Y or M here.
+
+config THERMAL_HWMON
+	bool "Hardware monitoring support"
+	depends on HWMON=y || HWMON=THERMAL
+	default y
+	help
+	  The generic thermal sysfs driver's hardware monitoring support
+	  requires a 2.10.7/3.0.2 or later lm-sensors userspace.
+
+	  Say Y unless you need support for older lm-sensors.
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
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 06d3e6e..917707e 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -66,8 +66,7 @@ struct thermal_cooling_device {
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
 /* thermal zone devices with the same type share one hwmon device */
 struct thermal_hwmon_device {
 	char type[THERMAL_NAME_LENGTH];
@@ -94,8 +93,7 @@ struct thermal_zone_device {
 	struct idr idr;
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
-#if defined(CONFIG_HWMON) ||	\
-	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
+#if defined(CONFIG_THERMAL_HWMON)
 	struct list_head hwmon_node;
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
-- 
1.5.5



