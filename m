Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYGSVLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYGSVLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYGSVK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:10:59 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38950 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYGSVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:10:59 -0400
Date: Sat, 19 Jul 2008 14:08:01 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: PIXIS gpio controller and gpio flags
In-Reply-To: <20080718100549.GA28741@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
 <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru>
 <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca>
 <20080717152006.GA26120@polina.dev.rtsoft.ru>
 <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
 <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
 <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
 <20080718100549.GA28741@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Anton Vorontsov wrote:
> +int px_gpio_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
> +               const void *gpio_spec)
> +{
> +     if (gpio[1] & PX_GPIO_FLAG_ACTIVE_LOW)
> +             px_gc->active_low |= pin2mask(*gpio);

You have a race here.  What if px_gpio_xlate() is called at the same time
for different gpios?  This is an easy one to fix, since you can use the
atomic bitops.

It doesn't look like you have any way to unset the active low flag.  What if
I unload the leds-gpio driver (or another gpio user) and then try to use the
gpio with something else?  The active low flag is stuck on!  It doesn't show
in sysfs or debugfs either.  That could be very confusing.

I also wonder if it's ok to have the xlate function do flag setting?

of_get_property() just gets the property, it doesn't allocate it.  Same with
of_get_address() and of_get_pci_address(), they don't actually allocate or
map an address, they just get the value.  of_get_gpio() doesn't allocate the
gpio, that gets done later with gpio_request().  It seems like what it's
supposed to do is just get the translated value of the gpio property.

Except, your pixis gpio xlate function sets the gpio's flags.  What if one
wants to just look up a gpio number, but not allocate it?  The flags will
still get set.

Most gpio users, including leds-gpio, can handle gpios being busy.  If
leds-gpio can't get one of the gpios, it rolls back all the leds it did
create, doesn't drive the device and returns EBUSY.  Except with
of_get_gpio() setting the flags, it will change the flags out from under
whatever had the gpio already allocated!
