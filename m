Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXGBO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXGBO54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbXGBO5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:57:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXGBO5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:57:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH][EXPERIMENTAL] PM: Use platform_device for registering timekeeping suspend and resume callbacks
Date: Mon, 2 Jul 2007 16:47:17 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021647.19870.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The experimental patch below replaces sys_device, used by the timekeeping code
to register the suspend and resume callbacks, with a platform device.

For me, personally, the main motivation for doing such a thing is that I'm working
on a hibernation framework separate from the suspend framework that we have
right now and I wouldn't like to have to deal with the sysdevs in it.

Apart from this, IIRC, in one of the recent discussions on linux-pm everyone
seemed to agree that it would be desirable to get rid of sysdevs.

Anyway, please let me know if the approach used in the patch is correct, as I'd
like to make some more similar changes shortly.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Replace sys_device used by the timekeeping code for registering suspend and
resume callbacks with a platform device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/time/timekeeping.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6.22-rc7/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.22-rc7.orig/kernel/time/timekeeping.c	2007-07-02 08:56:08.000000000 +0200
+++ linux-2.6.22-rc7/kernel/time/timekeeping.c	2007-07-02 09:06:18.000000000 +0200
@@ -13,7 +13,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <linux/sysdev.h>
+#include <linux/platform_device.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
@@ -268,7 +268,7 @@ static unsigned long timekeeping_suspend
  * xtime/wall_to_monotonic/jiffies/etc are
  * still managed by arch specific suspend/resume code.
  */
-static int timekeeping_resume(struct sys_device *dev)
+static int timekeeping_resume(struct platform_device *dev)
 {
 	unsigned long flags;
 	unsigned long now = read_persistent_clock();
@@ -299,7 +299,7 @@ static int timekeeping_resume(struct sys
 	return 0;
 }
 
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+static int timekeeping_suspend(struct platform_device *dev, pm_message_t state)
 {
 	unsigned long flags;
 
@@ -314,22 +314,30 @@ static int timekeeping_suspend(struct sy
 }
 
 /* sysfs resume/suspend bits for timekeeping */
-static struct sysdev_class timekeeping_sysclass = {
-	.resume		= timekeeping_resume,
-	.suspend	= timekeeping_suspend,
-	set_kset_name("timekeeping"),
+static struct platform_device timekeeping_dev = {
+	.name = "timekeeping",
+	.id = -1,
 };
 
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timekeeping_sysclass,
+static int __init timekeeping_probe(struct platform_device *dev)
+{
+	return (dev == &timekeeping_dev) ? 0 : -ENODEV;
+}
+
+static struct platform_driver timekeeping_drv = {
+	.driver = {
+		.name = "timekeeping",
+	},
+	.suspend_late = timekeeping_suspend,
+	.resume_early = timekeeping_resume,
 };
 
 static int __init timekeeping_init_device(void)
 {
-	int error = sysdev_class_register(&timekeeping_sysclass);
+	int error = platform_device_register(&timekeeping_dev);
 	if (!error)
-		error = sysdev_register(&device_timer);
+		error = platform_driver_probe(&timekeeping_drv,
+						timekeeping_probe);
 	return error;
 }
 
