Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXEJOFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXEJOFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbXEJOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:04:46 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60212 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXEJOEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:04:44 -0400
Date: Thu, 10 May 2007 23:04:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: kogiidena <kogiidena@eggplant.ddo.jp>
Cc: cbou@mail.ru, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
Message-ID: <20070510140415.GA19167@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	kogiidena <kogiidena@eggplant.ddo.jp>, cbou@mail.ru,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
References: <20070509160328.GA13640@zarina> <1249.192.168.1.10.1178797933.squirrel@eggplant.ddo.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249.192.168.1.10.1178797933.squirrel@eggplant.ddo.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kogiidena-san,

On Thu, May 10, 2007 at 08:52:13PM +0900, kogiidena wrote:
> diff -urpN OLD/drivers/leds/leds-landisk.c NEW/drivers/leds/leds-landisk.c
> --- OLD/drivers/leds/leds-landisk.c	1970-01-01 09:00:00.000000000 +0900
> +++ NEW/drivers/leds/leds-landisk.c	2007-05-10 20:07:11.000000000 +0900
[snip]
> +spinlock_t landisk_led_lock;

DEFINE_SPINLOCK(), please.

> +static int landisk_arch;	/* 0:LANDISK, LANTank 1:USL-5P */
> +
If you're going to do this, enums are probably the cleaner way to go.
Checking landisk_arch == 0 all over the place is non-obvious without
seeing this comment.

> +static void landisk_led_set(struct led_classdev *led_cdev,
> +			    enum led_brightness value)
> +{
> +	u8 tmp;
> +	int bitmask;
> +	unsigned long flags;
> +
> +	bitmask = 0x01 << (led_cdev - &landisk_leds[0]);
> +
> +	spin_lock_irqsave(&landisk_led_lock, flags);
> +	tmp = ctrl_inb(PA_LED);
> +	if (value)
> +		tmp |= bitmask;
> +	else
> +		tmp &= ~bitmask;
> +	ctrl_outb(tmp, PA_LED);

You may also want some sanity checking here, while PA_LED is only 8-bits,
your bitmask is not.
