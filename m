Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZLBRdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZLBRdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZLBRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:33:49 -0500
Received: from smtp.nokia.com ([192.100.105.134]:37804 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbZLBRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:33:48 -0500
Date: Wed, 2 Dec 2009 19:33:21 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grazvydas Ignotas <notasas@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091202173321.GA23738@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259333060-24277-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Dec 2009 17:33:39.0773 (UTC) FILETIME=[95F54ED0:01CA7375]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 27, 2009 at 03:44:20PM +0100, ext Grazvydas Ignotas wrote:
>diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>index b96f29d..9cea9b5 100644
>--- a/drivers/power/Makefile
>+++ b/drivers/power/Makefile
>@@ -29,3 +29,4 @@ obj-$(CONFIG_BATTERY_BQ27x00) += bq27x00_battery.o
> obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
> obj-$(CONFIG_BATTERY_MAX17040) += max17040_battery.o
> obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
>+obj-$(CONFIG_CHARGER_TWL4030)  += twl4030_charger.o
>diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
>new file mode 100644
>index 0000000..604dd56
>--- /dev/null
>+++ b/drivers/power/twl4030_charger.c
>@@ -0,0 +1,499 @@
>+/*
>+ * TWL4030/TPS65950 BCI (Battery Charger Interface) driver
>+ *
>+ * Copyright (C) 2009 Gražvydas Ignotas <notasas@gmail.com>
>+ *
>+ * based on twl4030_bci_battery.c by TI
>+ * Copyright (C) 2008 Texas Instruments, Inc.
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License as published by
>+ * the Free Software Foundation; either version 2 of the License, or
>+ * (at your option) any later version.
>+ */
>+
>+#include <linux/init.h>
>+#include <linux/module.h>
>+#include <linux/platform_device.h>
>+#include <linux/interrupt.h>
>+#include <linux/i2c/twl4030.h>
>+#include <linux/power_supply.h>
>+
>+#define REG_BCIMSTATEC         0x02

please prepend these defines with e.g. TWL4030_BCI_

this would look like:

#define TWL4030_BCI_MSTATEC	0x02

>+#define REG_BCIICHG            0x08
>+#define REG_BCIVAC             0x0a
>+#define REG_BCIVBUS            0x0c
>+#define REG_BCIMFSTS4          0x10
>+#define REG_BCICTL1            0x23
>+
>+#define REG_BOOT_BCI           0x07
>+#define REG_STS_HW_CONDITIONS  0x0f
>+
>+#define BCIAUTOWEN             0x20
>+#define CONFIG_DONE            0x10
>+#define CVENAC                 0x04
>+#define BCIAUTOUSB             0x02
>+#define BCIAUTOAC              0x01
>+#define BCIMSTAT_MASK          0x3F
>+#define STS_VBUS               0x80
>+#define STS_CHG                        0x02
>+#define STS_USB_ID             0x04
>+#define CGAIN                  0x20
>+#define USBFASTMCHG            0x04
>+
>+#define STATEC_USB             0x10
>+#define STATEC_AC              0x20
>+#define STATEC_STATUS_MASK     0x0f
>+#define STATEC_QUICK1          0x02
>+#define STATEC_QUICK7          0x07
>+#define STATEC_COMPLETE1       0x0b
>+#define STATEC_COMPLETE4       0x0e
>+
>+#define BCI_DELAY              100

100ms ??? that's too quick for battery monitoring. Imagine that you'll 
have 10 i2c transfers per-second forever with this one. Don't you think 
you're waking up omap for nothing ??

something like 1 second when doing heavy operation should be enough and 
5 to 10 seconds in idle is good enough as well.

>+static struct twl4030_bci_device_info twl4030_bci = {

this should be allocated on probe() time.

>+/*
>+ * called by TWL4030 USB transceiver driver on USB_PRES interrupt.
>+ */
>+int twl4030charger_usb_en(int enable)
>+{
>+       if (twl4030_bci.started)
>+               schedule_delayed_work(&twl4030_bci.bat_work,
>+                       msecs_to_jiffies(BCI_DELAY));

I don't like the way you did this. I would expect twl4030-usb to kick 
the charger detection based on the VBUS irq. You have to consider the 
possibility of boards which won't use BCI module and will have some 
bq24xxx chip dealing with that like RX51. So instead of implementing 
this here and forcing people to have this driver enabled on e.g. RX51, 
you should implement the charger_enable_usb() logic in twl4030-usb 
itself. /me thinks

>+static int __devinit twl4030_bci_probe(struct platform_device *pdev)
>+{
>+       int irq;
>+       int ret;
>+
>+       twl4030_charger_enable_ac(true);
>+       twl4030_charger_enable_usb(true);
>+
>+       irq = platform_get_irq(pdev, 0);
>+
>+       /* CHG_PRES irq */
>+       ret = request_irq(irq, twl4030_charger_interrupt,
>+               0, pdev->name, &twl4030_bci);

how about using request_threaded_irq() ?? then you avoid having that 
workqueue.

-- 
balbi
