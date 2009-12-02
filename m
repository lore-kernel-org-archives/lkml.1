Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZLBUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZLBUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZLBUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:33:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:36606 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZLBUdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q8lA/9LOS/bwHpPgI1G738k0ldZ4G0fZxNW/+/2MbWr/BQ6Nqa2qZ67Dmo9+SqksXp
         oitcL+XMfTDNXipgGhVl4YqA9wQLuP7x3EiEG6LggMp/hnsIqmhwCXein8FQ7Hx7AaVR
         WKeY5CIw0P69qJ774ecdeqj08YI0aB9WyZwLw=
MIME-Version: 1.0
In-Reply-To: <20091202173321.GA23738@nokia.com>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
	 <20091202173321.GA23738@nokia.com>
Date: Wed, 2 Dec 2009 22:34:00 +0200
Message-ID: <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: felipe.balbi@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 7:33 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> Hi,
>
> On Fri, Nov 27, 2009 at 03:44:20PM +0100, ext Grazvydas Ignotas wrote:
>>
>> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>> index b96f29d..9cea9b5 100644
>> --- a/drivers/power/Makefile
>> +++ b/drivers/power/Makefile
>> @@ -29,3 +29,4 @@ obj-$(CONFIG_BATTERY_BQ27x00) += bq27x00_battery.o
>> obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
>> obj-$(CONFIG_BATTERY_MAX17040) += max17040_battery.o
>> obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
>> +obj-$(CONFIG_CHARGER_TWL4030)  += twl4030_charger.o
>> diff --git a/drivers/power/twl4030_charger.c
>> b/drivers/power/twl4030_charger.c
>> new file mode 100644
>> index 0000000..604dd56
>> --- /dev/null
>> +++ b/drivers/power/twl4030_charger.c
>> @@ -0,0 +1,499 @@
>> +/*
>> + * TWL4030/TPS65950 BCI (Battery Charger Interface) driver
>> + *
>> + * Copyright (C) 2009 Gražvydas Ignotas <notasas@gmail.com>
>> + *
>> + * based on twl4030_bci_battery.c by TI
>> + * Copyright (C) 2008 Texas Instruments, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/i2c/twl4030.h>
>> +#include <linux/power_supply.h>
>> +
>> +#define REG_BCIMSTATEC         0x02
>
> please prepend these defines with e.g. TWL4030_BCI_
>
> this would look like:
>
> #define TWL4030_BCI_MSTATEC     0x02

ok

<snip>

>> +
>> +#define BCI_DELAY              100
>
> 100ms ??? that's too quick for battery monitoring. Imagine that you'll have
> 10 i2c transfers per-second forever with this one. Don't you think you're
> waking up omap for nothing ??

The work item doesn't queue itself, so this is only used once after
every interrupt. The delay itself is needed because charge state
machine needs some time to switch states and is not yet in expected
state at the time VBUS/AC detect interrupt kicks.

> something like 1 second when doing heavy operation should be enough and 5 to
> 10 seconds in idle is good enough as well.
>
>> +static struct twl4030_bci_device_info twl4030_bci = {
>
> this should be allocated on probe() time.

I need to access it from twl4030charger_usb_en().. Could only leave
delayed_work global and allocate everything else in probe() if you
prefer that.

>
>> +/*
>> + * called by TWL4030 USB transceiver driver on USB_PRES interrupt.
>> + */
>> +int twl4030charger_usb_en(int enable)
>> +{
>> +       if (twl4030_bci.started)
>> +               schedule_delayed_work(&twl4030_bci.bat_work,
>> +                       msecs_to_jiffies(BCI_DELAY));
>
> I don't like the way you did this. I would expect twl4030-usb to kick the
> charger detection based on the VBUS irq. You have to consider the
> possibility of boards which won't use BCI module and will have some bq24xxx
> chip dealing with that like RX51. So instead of implementing this here and
> forcing people to have this driver enabled on e.g. RX51, you should
> implement the charger_enable_usb() logic in twl4030-usb itself. /me thinks

I don't think charging is twl4030-usb's business, also notifying
power_supply core about charge state changes that I do here.

What about just returning early from twl4030charger_usb_en() if this
driver is not started? TWL4030-core requires twl4030_bci_platform_data
to be present to even register this driver, so it won't start on RX51.
RX51 can also choose not to compile this driver in, then
twl4030charger_usb_en() call won't even be done fom twl4030-usb.

>
>> +static int __devinit twl4030_bci_probe(struct platform_device *pdev)
>> +{
>> +       int irq;
>> +       int ret;
>> +
>> +       twl4030_charger_enable_ac(true);
>> +       twl4030_charger_enable_usb(true);
>> +
>> +       irq = platform_get_irq(pdev, 0);
>> +
>> +       /* CHG_PRES irq */
>> +       ret = request_irq(irq, twl4030_charger_interrupt,
>> +               0, pdev->name, &twl4030_bci);
>
> how about using request_threaded_irq() ?? then you avoid having that
> workqueue.

I need to do some delayed processing after VBUS/AC detect interrupts
kick, delayed_work looked perfect for this. Also note that I can't get
USB_PRES interrupt (taken by twl4030-usb), only a callback from
twl4030-usb.

>
> --
> balbi
>
