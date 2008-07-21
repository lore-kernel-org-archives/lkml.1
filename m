Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYGURyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYGURyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYGURyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:54:04 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14964 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbYGURyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:54:01 -0400
Date: Mon, 21 Jul 2008 21:53:57 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: PIXIS gpio controller and gpio flags
Message-ID: <20080721175357.GA1773@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp> <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp> <20080718100549.GA28741@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 02:08:01PM -0700, Trent Piepho wrote:
> On Fri, 18 Jul 2008, Anton Vorontsov wrote:
> > +int px_gpio_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
> > +               const void *gpio_spec)
> > +{
> > +     if (gpio[1] & PX_GPIO_FLAG_ACTIVE_LOW)
> > +             px_gc->active_low |= pin2mask(*gpio);
> 
> You have a race here.  What if px_gpio_xlate() is called at the same time
> for different gpios?  This is an easy one to fix, since you can use the
> atomic bitops.

Thanks, I'll fix this. But I think spinlock would be less cryptic here,
since we have one, and the xlate is called quite rarely anyway.

> It doesn't look like you have any way to unset the active low flag.  What if
> I unload the leds-gpio driver (or another gpio user) and then try to use the
> gpio with something else?  The active low flag is stuck on!

Why would you want to unset the flags? It is specified in the device
tree, and can't be changed. Specifying different flags for the same GPIO
would be an error (plus, Linux forbids shared gpios, so you simply can't
specify one gpio for several devices).

> It doesn't show
> in sysfs or debugfs either.  That could be very confusing.

It is in the /proc/device-tree. But I agree, it would be great if
/sys/debug/gpio would show active-low gpios. But this would need gpiolib
changes, with which David will not agree, I suppose. But I didn't try.

> I also wonder if it's ok to have the xlate function do flag setting?

Why not? Of course, we can implement of_gpio_is_active_low(device_node,
gpion), but this is just less convenient than handling active-low gpios
transparently (i.e. for pure OF drivers you don't have to do all
this if (active_low) in the drivers themselves).

> of_get_property() just gets the property, it doesn't allocate it.  Same with
> of_get_address() and of_get_pci_address(), they don't actually allocate or
> map an address, they just get the value.  of_get_gpio() doesn't allocate the
> gpio, that gets done later with gpio_request().  It seems like what it's
> supposed to do is just get the translated value of the gpio property.

Yes, it translates gpio value, and its flags, it also "caches" the flag
so that further gpio_ calls could use it. But the flags for the
particular gpio is constant. So each xlate must end up with the same
active-low flag, otherwise you did something wrong.

> Except, your pixis gpio xlate function sets the gpio's flags.  What if one
> wants to just look up a gpio number, but not allocate it?  The flags will
> still get set.

Nothing is allocated.

> Most gpio users, including leds-gpio, can handle gpios being busy.  If
> leds-gpio can't get one of the gpios, it rolls back all the leds it did
> create, doesn't drive the device and returns EBUSY.  Except with
> of_get_gpio() setting the flags, it will change the flags out from under
> whatever had the gpio already allocated!

You're still assuming that something was allocated. It wasn't. The flag
was set, and it should not change. It is irrelevant if request() failed
or not.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
