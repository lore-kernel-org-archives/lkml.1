Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXJLWRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXJLWRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbXJLWRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:17:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:49570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407AbXJLWRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:17:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, David Brownell <david-b@pacbell.net>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/75] platform: prefix MODALIAS with "platform:"
Date: Fri, 12 Oct 2007 15:16:05 -0700
Message-Id: <11922274393667-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: \<20071012221251.GB4559@kroah.com\>
References: \<20071012221251.GB4559@kroah.com\>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

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
Cc: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c           |   15 ++-------------
 drivers/input/misc/pcspkr.c       |    1 +
 drivers/pcmcia/pxa2xx_mainstone.c |    2 +-
 drivers/pcmcia/pxa2xx_sharpsl.c   |    2 +-
 4 files changed, 5 insertions(+), 15 deletions(-)

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
-- 
1.5.3.4

