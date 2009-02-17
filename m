Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZBQONh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZBQONh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZBQON2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:13:28 -0500
Received: from woodchuck.wormnet.eu ([77.75.105.223]:45828 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZBQON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:13:27 -0500
Date: Tue, 17 Feb 2009 14:13:24 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCHv3 REPOST] hw_random: add timeriomem-rng driver
Message-ID: <20090217141324.GP32719@woodchuck>
References: <20090217135130.GN32719@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217135130.GN32719@woodchuck>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: jimdigriz@jabber.earth.li
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware platforms, the TS-7800[1] is one for example, can
supply the kernel with an entropy source, albeit a slow one for
TS-7800 users, by just reading a particular IO address.  This
source must not be read above a certain rate otherwise the quality
suffers.

The driver is then hooked into by calling
platform_device_(register|add|del) passing a structure similar to:
------
static struct timeriomem_rng_data ts78xx_ts_rng_data = {
        .address        = (u32 *__iomem) TS_RNG,
        .period         = 1000000, /* one second */
};

static struct platform_device ts78xx_ts_rng_device = {
        .name           = "timeriomem_rng",
        .id             = -1,
        .dev            = {
                .platform_data  = &ts78xx_ts_rng_data,
        },
        .num_resources  = 0,
};
------

[1] http://www.embeddedarm.com/products/board-detail.php?product=TS-7800

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

----
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 8822eca..e86dd42 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -20,6 +20,20 @@ config HW_RANDOM
 
 	  If unsure, say Y.
 
+config HW_RANDOM_TIMERIOMEM
+	tristate "Timer IOMEM HW Random Number Generator support"
+	depends on HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for a generic Random
+	  Number Generator used by reading a 'dumb' iomem address that
+	  is to be read no faster than, for example, once a second;
+	  the default FPGA bitstream on the TS-7800 has such functionality.
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
index b6effb7..e81d21a 100644
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
index 0000000..10ad41b
--- /dev/null
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -0,0 +1,151 @@
+/*
+ * drivers/char/hw_random/timeriomem-rng.c
+ *
+ * Copyright (C) 2009 Alexander Clouter <alex@digriz.org.uk>
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
+ *   has to do is provide the address and 'wait time' that new data becomes
+ *   available.
+ *
+ * TODO: add support for reading sizes other than 32bits and masking
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
+#include <linux/completion.h>
+
+static struct timeriomem_rng_data *timeriomem_rng_data;
+
+static void timeriomem_rng_trigger(unsigned long);
+static DEFINE_TIMER(timeriomem_rng_timer, timeriomem_rng_trigger, 0, 0);
+
+/*
+ * have data return 1, however return 0 if we have nothing
+ */
+static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
+{
+	if (rng->priv == 0)
+		return 1;
+
+	if (!wait || timeriomem_rng_data->present)
+		return timeriomem_rng_data->present;
+
+	wait_for_completion(&timeriomem_rng_data->completion);
+
+	return 1;
+}
+
+static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	unsigned long cur;
+	s32 delay;
+
+	*data = readl(timeriomem_rng_data->address);
+
+	if (rng->priv != 0) {
+		cur = jiffies;
+
+		delay = cur - timeriomem_rng_timer.expires;
+		delay = rng->priv - (delay % rng->priv);
+
+		timeriomem_rng_timer.expires = cur + delay;
+		timeriomem_rng_data->present = 0;
+
+		init_completion(&timeriomem_rng_data->completion);
+		add_timer(&timeriomem_rng_timer);
+	}
+
+	return 4;
+}
+
+static void timeriomem_rng_trigger(unsigned long dummy)
+{
+	timeriomem_rng_data->present = 1;
+	complete(&timeriomem_rng_data->completion);
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
+		timeriomem_rng_timer.expires = jiffies;
+
+		timeriomem_rng_ops.priv = usecs_to_jiffies(
+						timeriomem_rng_data->period);
+	}
+	timeriomem_rng_data->present = 1;
+
+	ret = hwrng_register(&timeriomem_rng_ops);
+	if (ret) {
+		dev_err(&pdev->dev, "problem registering\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
+			timeriomem_rng_data->address,
+			timeriomem_rng_data->period);
+
+	return 0;
+}
+
+static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
+{
+	del_timer_sync(&timeriomem_rng_timer);
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
+	.remove		= __devexit_p(timeriomem_rng_remove),
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
index 0000000..dd25317
--- /dev/null
+++ b/include/linux/timeriomem-rng.h
@@ -0,0 +1,21 @@
+/*
+ * linux/include/linux/timeriomem-rng.h
+ *
+ * Copyright (c) 2009 Alexander Clouter <alex@digriz.org.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/completion.h>
+
+struct timeriomem_rng_data {
+	struct completion	completion;
+	unsigned int		present:1;
+
+	u32 __iomem		*address;
+
+	/* measures in usecs */
+	unsigned int		period;
+};
