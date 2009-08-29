Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZH2XDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZH2XDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZH2XDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:03:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37181 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZH2XDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eGqArTjVkXTusJy0fdWQVl883OnyZP8LxxuKp6duFqFSGjWZnblvu4aBEDv9m+ZTUz
         CC1pDRwIvWQSIkyU7oTcoiL38MV1O+nqvgCSdrp4c5Sg+Eqv73E2oiWK64ZimCMJcn2Q
         QLudGoolQmGMah+/aaCNlZyTWMZndmFFgSLPw=
MIME-Version: 1.0
In-Reply-To: <20090821105636.GA2850@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
	 <20090821105636.GA2850@sirena.org.uk>
Date: Sun, 30 Aug 2009 01:03:38 +0200
Message-ID: <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
Subject: Re: [PATCH] AB3100 regulator support v1
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark for the quick and good review, I've ironed out most of the
stuff with some brutal refactoring, but these issues remain, any hints
welcome:

2009/8/21 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Aug 21, 2009 at 12:11:11AM +0200, Linus Walleij wrote:
>> +/*
>> + * This creates a platform device for a regulator and
>> + * registers it to the platform devices.
>> + */
>> +static int __init ab3100_add_regulator_pdev(struct device *parent,
>> +                                 struct ab3100_regulator *rdev,
>> +                                 struct ab3100 *ab3100,
>> +                                 struct ab3100_platform_data *plfdata,
>> +                                 int regid)
>
>> +     /* This would seem logical but makes everything break... */
>> +     /* pdev->dev.parent = parent; */
>
> Err...  it does?  In what way?

The sub-platform devices are added, but when I add a platform driver for
them, the probing does not commence, because they hang in
driver base/dd.c: __driver_attach() trying to take the parent semaphore,
i.e. this line:

	if (dev->parent)	/* Needed for USB */
		down(&dev->parent->sem);

In this case the parent is ab3100-regulators, the platform device for
the set of regulators.

So this is because I am in the parents probe() function of course,
and it's all expected. If I defer to setting the parent after the driver's
been probed, the hierarchy is not working properly in sysfs (it doesn't
crash though, the parent is just ignored).

>> +/*
>> + * This needs to be an fs_initcall() because the
>> + * AB3100 core driver that registers the regulators
>> + * device comes in at subsys_initcall() later than
>> + * this driver due to link order.
>> + */
>> +fs_initcall(ab3100_regulators_init);
>
> That's only happening because you're using platform_driver_probe() - if
> you use platform_driver_register() like the other regulator drivers
> this won't be a problem.  I suspect that platform_driver_probe() here
> may create issues if we do stuff like multi-threaded driver probe
> later.

Not really, I've switched it to platform_driver_register() and the problem
persists, but the reason is not what is stated in the comment.

It's the *same* deadlock again, it hangs on the parent semaphore in
__driver_attach(), because the parent to this device (that in turn
contains the regulators) is ab3100-core which sets itself as parent
to its sub-devices. When it registers its devices, the probe()
gets called and as the parent is still probe():ing it deadlocks.

Moving it to another initlevel makes me go out of the nested
driver probe():s and the parents semaphore is released.

What I do here is that in two levels I add platform devices in the
probe() sections of a driver - ab3100 core adds the ab3100-regulators
and this one then adds each regulator as a platform device.
This works fine as long as none of these devices sets its parent,
but if I do that I hang on the parent semaphore in  __driver_attach().

This didn't happen in 2.6.28, while the parent semaphore check
was indeed in place, so something about the probe calls has changed,
they have been serialized and inlined so that they occur while adding
a device driver.

If I remove the parent semaphore takes in __driver_attach()
everything works like a charm (of course).

I *guess* there is a silent assumption that has appeared between
kernel 2.6.28 and present that a device's probe() cannot just add new
devices to be probed on the same initlevel if it sets itself as parent,
you really have to do this on different initlevels *or* leave your parent
blank.

So while I think of an elegant solution to this...

Hm platform devices really doesn't need their parents semaphore
to be taken during attach, do they? The comment says this is for
some USB devices, so can we do something to avoid that unless
we're a USB device, or would that be a plain BadIdea(TM)?

(Also it looks a bit weird, since __driver_attach() takes the
semaphore of the device's parent but doesn't traverse further up the
hierarchy which would seem logical if you would do such things.)

Linus Walleij
