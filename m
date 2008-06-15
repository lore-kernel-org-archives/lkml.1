Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYFOSCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYFOSCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbYFOSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:02:25 -0400
Received: from woodchuck.wormnet.eu ([77.75.105.223]:55409 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802AbYFOSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:02:24 -0400
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2008 14:02:23 EDT
Date: Sun, 15 Jun 2008 18:31:05 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH,RFC] timer iomem hwrng driver
Message-ID: <20080615173105.GJ1098@inskipp.digriz.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed that the HW RNG core is orphaned so I'm posted this here...

I have been putting together some patches[1] for mainline support for the 
Technologic Systems TS-7800 which also includes a HW RNG generator; 32 bits 
of entropy a second is not great but hell if it's there, why not use it?

So I started slapping a driver together and realised it might be handy to 
generalise the driver a bit as in the case of the TS-7800 you just yank data 
once a second from a memory address and that's it; I imagine there are other 
boards out there that provision this kind of thing too.  Nosing around in 
drivers/char/hw_random I noticed that ixp4xx-rng.c could trivially be 
replaced with my driver too.

So what's the consensus?  The only possibly 'offencive' bit I can think of is 
that the ioremap'ing is done in the platform code.  After a lot of head 
scratched I managed to get it to use a timer queue so hopefully it's rather 
lightweight; saving me the stack of 64bit calculations on an ARM chip I had 
before I got it using the timer queue.

Comments, flames, suggestions for improvement all welcomed.

Cheers

Alex

P.S. I'm not subscribed to LKML so please CC me in on your replies, the FAQ 
	said this was not a 'faux par'...

[1] http://marc.info/?l=linux-arm-kernel&m=121280018602505&w=2

-- 
 ________________________________________
/ You may be marching to the beat of a   \
| different drummer, but you're still in |
\ the parade.                            /
 ----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index bbf87a4..6599bd9 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -15,6 +15,7 @@
 #include <linux/mv643xx_eth.h>
 #include <linux/ata_platform.h>
 #include <linux/m48t86.h>
+#include <linux/timeriomem-rng.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -37,6 +38,8 @@
 #define TS78XX_FPGA_REGS_SYSCON_LCDI	(TS78XX_FPGA_REGS_VIRT_BASE | 0x004)
 #define TS78XX_FPGA_REGS_SYSCON_LCDO	(TS78XX_FPGA_REGS_VIRT_BASE | 0x008)
 
+#define TS78XX_FPGA_REGS_SYSCON_RNG	(TS78XX_FPGA_REGS_VIRT_BASE | 0x044)
+
 #define TS78XX_FPGA_REGS_RTC_CTRL	(TS78XX_FPGA_REGS_VIRT_BASE | 0x808)
 #define TS78XX_FPGA_REGS_RTC_DATA	(TS78XX_FPGA_REGS_VIRT_BASE | 0x80c)
 
@@ -108,6 +111,27 @@ static struct mv643xx_eth_platform_data ts78xx_eth_data = {
 };
 
 /*****************************************************************************
+ * RNG
+ ****************************************************************************/
+#ifdef CONFIG_HW_RANDOM_TIMERIOMEM
+static struct timeriomem_rng_data ts78xx_rng_data = {
+	.address	= (u32 *__iomem) TS78XX_FPGA_REGS_SYSCON_RNG,
+	.width		= 32,
+	.mask		= 0,
+	.period		= 1000000,
+};
+
+static struct platform_device ts78xx_rng_device = {
+	.name		= "timeriomem_rng",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &ts78xx_rng_data,
+	},
+	.num_resources	= 0,
+};
+#endif
+
+/*****************************************************************************
  * RTC M48T86 - nicked^Wborrowed from arch/arm/mach-ep93xx/ts72xx.c
  ****************************************************************************/
 #ifdef CONFIG_RTC_DRV_M48T86
@@ -258,6 +282,9 @@ static void __init ts78xx_init(void)
 
 	if (!ts78xx_rtc_init())
 		printk(KERN_INFO "TS-78xx RTC not detected or enabled\n");
+#ifdef CONFIG_HW_RANDOM_TIMERIOMEM
+	platform_device_register(&ts78xx_rng_device);
+#endif
 }
 
 MACHINE_START(TS78XX, "Technologic Systems TS-78xx SBC")
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 8d6c208..3eff545 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -20,6 +20,19 @@ config HW_RANDOM
 
 	  If unsure, say Y.
 
+config HW_RANDOM_TIMERIOMEM
+	tristate "Timer IOMEM HW Random Number Generator support"
+	depends on HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for a generic Random
+	  Number Generator provisioned by hardware through a dumb iomem
+	  address; for example the TS-7800 is such a device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called timeriomem-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_INTEL
 	tristate "Intel HW Random Number Generator support"
 	depends on HW_RANDOM && (X86 || IA64) && PCI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index c8b7300..490bec0 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_HW_RANDOM) += rng-core.o
 rng-core-y := core.o
+obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
new file mode 100644
index 0000000..f88fd1d
--- /dev/null
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -0,0 +1,152 @@
+/*
+ * drivers/char/hw_random/timerioport-rng.c
+ *
+ * Copyright (C) 2008 Alexander Clouter <alex@digriz.org.uk>
+ *
+ * Derived from drivers/char/hw_random/omap-rng.c
+ *   Copyright 2005 (c) MontaVista Software, Inc.
+ *   Author: Deepak Saxena <dsaxena@plexity.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Overview:
+ *   This driver is useful for platforms that have an IO range that provides
+ *   periodic random data from a single IO memory address.  All the platform
+ *   has to do is provide the address, width, shift and 'wait time' that new
+ *   data becomes available
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/timeriomem-rng.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+
+static struct timeriomem_rng_data *timeriomem_rng_data;
+
+static void timeriomem_rng_trigger(unsigned long);
+static DEFINE_TIMER(timeriomem_rng_timer, &timeriomem_rng_trigger, 0, 0);
+
+/*
+ * have data return 1, however return 0 if we have nothing
+ */
+static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
+{
+	unsigned int delay;
+
+	if (rng->priv == 0)
+		return 1;
+
+	if (timer_pending(&timeriomem_rng_timer)) {
+		if (!wait)
+			return 0;
+
+		del_timer(&timeriomem_rng_timer);
+		delay = timeriomem_rng_timer.expires - get_jiffies_64();
+
+		schedule_timeout_uninterruptible(delay);
+	}
+
+	return 1;
+}
+
+/* FIXME: add width/mask support (must be endian safe too) */
+static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	u64 cur;
+	unsigned int delay;
+
+	*data = *timeriomem_rng_data->address;
+
+	if (rng->priv != 0) {
+		cur = get_jiffies_64();
+
+		delay = cur - timeriomem_rng_timer.expires;
+		delay = rng->priv - (delay % rng->priv);
+
+		timeriomem_rng_timer.expires = cur + delay;
+		add_timer(&timeriomem_rng_timer);
+	}
+
+	return 4;
+}
+
+static void timeriomem_rng_trigger(unsigned long dummy)
+{
+  del_timer(&timeriomem_rng_timer);
+}
+
+static struct hwrng timeriomem_rng_ops = {
+	.name		= "timeriomem",
+	.data_present	= timeriomem_rng_data_present,
+	.data_read	= timeriomem_rng_data_read,
+	.priv		= 0,
+};
+
+static int __init timeriomem_rng_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	timeriomem_rng_data = pdev->dev.platform_data;
+
+	if (timeriomem_rng_data->period != 0
+		&& usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
+		timeriomem_rng_timer.expires = get_jiffies_64();
+		init_timer(&timeriomem_rng_timer);
+
+		timeriomem_rng_ops.priv = usecs_to_jiffies(
+						timeriomem_rng_data->period);
+	}
+
+	ret = hwrng_register(&timeriomem_rng_ops);
+	if (ret) {
+		dev_err(&pdev->dev, "problem registering\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "%dbits from 0x%p period %d usecs\n",
+			timeriomem_rng_data->width,
+			timeriomem_rng_data->address,
+			timeriomem_rng_data->period);
+
+	return 0;
+}
+
+static int __exit timeriomem_rng_remove(struct platform_device *pdev)
+{
+	del_timer(&timeriomem_rng_timer);
+	hwrng_unregister(&timeriomem_rng_ops);
+
+	return 0;
+}
+
+static struct platform_driver timeriomem_rng_driver = {
+	.driver = {
+		.name		= "timeriomem_rng",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= timeriomem_rng_probe,
+};
+
+static int __init timeriomem_rng_init(void)
+{
+	return platform_driver_register(&timeriomem_rng_driver);
+}
+
+static void __exit timeriomem_rng_exit(void)
+{
+	platform_driver_unregister(&timeriomem_rng_driver);
+}
+
+module_init(timeriomem_rng_init);
+module_exit(timeriomem_rng_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
+MODULE_DESCRIPTION("Timer IOMEM H/W RNG driver");
diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
new file mode 100644
index 0000000..f7f2905
--- /dev/null
+++ b/include/linux/timeriomem-rng.h
@@ -0,0 +1,21 @@
+/*
+ * linux/include/linux/timeriomem-rng.h
+ *
+ * Copyright (c) 2008 Alexander Clouter <alex@digriz.org.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+struct timeriomem_rng_data {
+	u32 __iomem	*address;
+
+	/* width in bits */
+	unsigned int	width;
+	/* if non-zero the mask to apply to get the bits we want */
+	unsigned int	mask;
+
+	/* measures in usecs */
+	unsigned int	period;
+};
