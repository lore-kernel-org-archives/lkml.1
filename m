Return-Path: <linux-kernel-owner+w=401wt.eu-S967189AbXEHMzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967189AbXEHMzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967043AbXEHMzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:55:03 -0400
Received: from tim.rpsys.net ([194.106.48.114]:60690 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966446AbXEHMzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:55:02 -0400
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: kogiidena@eggplant.ddo.jp
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
Content-Type: text/plain
Date: Tue, 08 May 2007 13:54:48 +0100
Message-Id: <1178628889.6061.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2007-05-08 at 21:26 +0900, kogiidena wrote:
> To:Richard-san
> CC:all
> 
> LED driver of I-O DATA LANDISK and USL-5P
> Please apply following patch
> 
> Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
> 
[...]
> +/* HDD-access-LED setting at landisk status LED */
> +static void landisk_disk_trig_activate(struct led_classdev *led_cdev)
> +{
> +        unsigned long flags;
> +        spin_lock_irqsave(&landisk_led_lock, flags);
> +        ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x04, PA_LED);
> +        spin_unlock_irqrestore(&landisk_led_lock, flags);
> +}
> +
> +static void landisk_disk_trig_deactivate(struct led_classdev *led_cdev)
> +{
> +        unsigned long flags;
> +        spin_lock_irqsave(&landisk_led_lock, flags);
> +        ctrl_outb((ctrl_inb(PA_LED) & ~0x0c) | 0x0c, PA_LED);
> +        spin_unlock_irqrestore(&landisk_led_lock, flags);
> +}
> +
> +static struct led_trigger landisk_disk_led_trigger = {
> +        .name = "disk",
> +        .activate = landisk_disk_trig_activate,
> +        .deactivate = landisk_disk_trig_deactivate,
> +};

You can't do this since the trigger will appear for all LEDs and it only
applies to a single LED. There has been previous discussion of LED
specific triggers and we'll need that support before you can make
something like this work. Nobody has sent me a patch for that yet and I
haven't had time to write one...

+static int __init landisk_led_init(void)
> +{
> +        u8 orig, test;
> +
> +        orig = ctrl_inb(PA_LED);
> +        ctrl_outb(0x40, PA_LED);
> +
> +        test = ctrl_inb(PA_LED);
> +        ctrl_outb(orig, PA_LED);
> +
> +        landisk_arch = (test == 0x40);
> +
> +        if (landisk_arch == 0) {
> +                /* arch == landisk */
> +                ctrl_outb(orig | 0x07, PA_LED);
> +                landisk_leds[1].default_trigger = "disk";
> +                led_trigger_register(&landisk_disk_led_trigger);
> +        } else {
> +                /* arch == usl-5p */
> +                ctrl_outb(orig | 0x03, PA_LED);
> +        }
> +        return platform_driver_register(&landisk_led_driver);

Broken error handling - you should check the return code of
led_trigger_register().

> +static void __exit landisk_led_exit(void)
> +{
> +        if (landisk_arch == 0)
> +                led_trigger_unregister(&landisk_disk_led_trigger);
> +        return platform_driver_unregister(&landisk_led_driver);
> +}

void functions don't return.

Other than those issues, it looks ok.

Richard


