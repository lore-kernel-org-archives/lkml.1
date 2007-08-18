Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXHRChU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXHRChU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 22:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXHRChH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 22:37:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXHRChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 22:37:04 -0400
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
In-Reply-To: <200708171250.09653.david-b@pacbell.net>
References: <200708170823.15894.david-b@pacbell.net>
	 <200708170955.06388.david-b@pacbell.net>
	 <1187371126.4253.10.camel@lov.localdomain>
	 <200708171250.09653.david-b@pacbell.net>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 04:40:39 +0200
Message-Id: <1187404839.4419.5.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19iZ2c2KyYPX7wvsqTt7QXvTM0sF5D/U+Dt4cy
 EAB4TiKDu0BqjU+BmX08qNegYtgThlXjrZWBEB2g1CS0fKbv3H
 S2OGCmNYhSjoA/vnZ3fQs6S9F9hjVBS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 12:50 -0700, David Brownell wrote:
> On Friday 17 August 2007, Kay Sievers wrote:
> > On Fri, 2007-08-17 at 09:55 -0700, David Brownell wrote:

> > > 
> > > If so, then whoever tried to change the usage of module aliases
> > > in that way goofed in several ways.  First, by not changing all
> > > the in-kernel uses.  Second, by not changing all the out-of-tree
> > > uses in various distros, toolchains, etc.  Third, by not even
> > > documenting that change...
> > 
> > Yes, please fix the misuse of MODALIAS.
> 
> I'm not the one who's advocating a change here.  If you want to
> first change/break and then fix things, all of that is up to you.

I'm happy to do that. Patch is attached.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: platform: prefix MODALIAS with "platform:"

Prefix platform modalias strings with "platform:", which
modprobe config to blacklist alias resolving if userspace
configures it.

Send uevents for all platform devices.

Add MODULE_ALIAS's to: pxa2xx_pcmcia, ds1742 and pcspkr to trigger
module autoloading by userspace.

  $ modinfo pcspkr
  alias:          platform:pcspkr
  license:        GPL
  description:    PC Speaker beeper driver
  ...

  $ modprobe -n -v platform:pcspkr
  insmod /lib/modules/2.6.23-rc3-g28e8351a-dirty/kernel/drivers/input/misc/pcspkr.ko

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 base/platform.c           |   15 ++-------------
 input/misc/pcspkr.c       |    1 +
 pcmcia/pxa2xx_mainstone.c |    2 +-
 pcmcia/pxa2xx_sharpsl.c   |    2 +-
 rtc/rtc-ds1742.c          |    1 +
 5 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 869ff8c..9bfc434 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -160,11 +160,6 @@ static void platform_device_release(struct device *dev)
  *
  *	Create a platform device object which can have other objects attached
  *	to it, and which will have attached objects freed when it is released.
- *
- *	This device will be marked as not supporting hotpluggable drivers; no
- *	device add/remove uevents will be generated.  In the unusual case that
- *	the device isn't being dynamically allocated as a legacy "probe the
- *	hardware" driver, infrastructure code should reverse this marking.
  */
 struct platform_device *platform_device_alloc(const char *name, unsigned int id)
 {
@@ -177,12 +172,6 @@ struct platform_device *platform_device_alloc(const char *name, unsigned int id)
 		pa->pdev.id = id;
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
-
-		/* prevent hotplug "modprobe $(MODALIAS)" from causing trouble in
-		 * legacy probe-the-hardware drivers, which don't properly split
-		 * out device enumeration logic from drivers.
-		 */
-		pa->pdev.dev.uevent_suppress = 1;
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -530,7 +519,7 @@ static ssize_t
 modalias_show(struct device *dev, struct device_attribute *a, char *buf)
 {
 	struct platform_device	*pdev = to_platform_device(dev);
-	int len = snprintf(buf, PAGE_SIZE, "%s\n", pdev->name);
+	int len = snprintf(buf, PAGE_SIZE, "platform:%s\n", pdev->name);
 
 	return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
 }
@@ -546,7 +535,7 @@ static int platform_uevent(struct device *dev, char **envp, int num_envp,
 	struct platform_device	*pdev = to_platform_device(dev);
 
 	envp[0] = buffer;
-	snprintf(buffer, buffer_size, "MODALIAS=%s", pdev->name);
+	snprintf(buffer, buffer_size, "MODALIAS=platform:%s", pdev->name);
 	return 0;
 }
 
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 906bf5e..e1a4402 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -23,6 +23,7 @@
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcspkr");
 
 #ifdef CONFIG_X86
 /* Use the global PIT lock ! */
diff --git a/drivers/pcmcia/pxa2xx_mainstone.c b/drivers/pcmcia/pxa2xx_mainstone.c
index 383107b..f6722ba 100644
--- a/drivers/pcmcia/pxa2xx_mainstone.c
+++ b/drivers/pcmcia/pxa2xx_mainstone.c
@@ -175,7 +175,6 @@ static int __init mst_pcmcia_init(void)
 	if (!mst_pcmcia_device)
 		return -ENOMEM;
 
-	mst_pcmcia_device->dev.uevent_suppress = 0;
 	mst_pcmcia_device->dev.platform_data = &mst_pcmcia_ops;
 
 	ret = platform_device_add(mst_pcmcia_device);
@@ -195,3 +194,4 @@ fs_initcall(mst_pcmcia_init);
 module_exit(mst_pcmcia_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-pcmcia");
diff --git a/drivers/pcmcia/pxa2xx_sharpsl.c b/drivers/pcmcia/pxa2xx_sharpsl.c
index a2daa3f..d5c33bd 100644
--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -261,7 +261,6 @@ static int __init sharpsl_pcmcia_init(void)
 	if (!sharpsl_pcmcia_device)
 		return -ENOMEM;
 
-	sharpsl_pcmcia_device->dev.uevent_suppress = 0;
 	sharpsl_pcmcia_device->dev.platform_data = &sharpsl_pcmcia_ops;
 	sharpsl_pcmcia_device->dev.parent = platform_scoop_config->devs[0].dev;
 
@@ -284,3 +283,4 @@ module_exit(sharpsl_pcmcia_exit);
 
 MODULE_DESCRIPTION("Sharp SL Series PCMCIA Support");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-pcmcia");
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index b2e5481..f5af09a 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -273,3 +273,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:ds1742");

