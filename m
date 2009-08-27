Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZH0XT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZH0XT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZH0XTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:19:25 -0400
Received: from ru.mvista.com ([213.79.90.228]:18440 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751330AbZH0XTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:19:24 -0400
Date: Fri, 28 Aug 2009 03:19:25 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>,
       Jean Delvare <khali@linux-fr.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] rtc: Set wakeup capability for I2C and SPI RTC drivers
Message-ID: <20090827231925.GA1131@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090827182207.GA7358@oksana.dev.rtsoft.ru>
 <200908271452.37358.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200908271452.37358.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 02:52:36PM -0700, David Brownell wrote:
[...]
> > I believe that it's not platform code responsibility to allow or
> > disallow wakeups, instead, drivers themselves should set the capability
> > if a device can trigger wakeups.
> 
> Drivers can't generally know if that's possible though.
> They need to be told that it is, by platform code.

Um? Of course they know, DS1374 device driver knows that DS1374
chips can issue wakeups, what it doesn't know is if that wakeup
event will trigger CPU resume/power-up.

And even platform code doesn't know that. For example, on PowerPC
CPUs there could be several 'suspend' states, some allow wakeup
on particular IRQs, some don't. In some cases wakeup event will be
ignored, in other cases it will take effect. The suspend mode
depends on user's decision ('echo <mode> > /sys/power/state').

> Most devices can't issue wakeup events.

The device drivers I modified know that devices can issue wakeup
events.

> > That's what drivers/base/power/sysfs.c says:
> > 
> >  * It is the responsibility of device drivers to enable (or disable)
> >  * wakeup signaling as part of changing device power states, respecting
> >  * the policy choices provided through the driver model.
> > 
> > I2C and SPI RTC devices send wakeup events via interrupt lines, so we
> > should set the wakeup capability if IRQ is routed.
> 
> Re-read the quoted sentence.  You're saying that policy
> choices should be hard-wired into the driver; contrary
> to that quote.  (In this case the choice is one that
> platform code must report, and which the hardware
> designer made:  if the device can issue wakeup events.)

The patch doesn't hard-wire the policy, quite the contrary: it
removes the "can't do wakeup" policy.

I'm just adding device_set_wakeup_capable() calls, telling everybody
that the devices can issue wakeup events (and they truly can).

Yes, it could be that the IRQ line is wired not to a CPU, but
to some power switch, and so nobody pass any IRQs to the drivers.
In that case platform-specific I2C_CLIENT_WAKE may be useful.

> > Ideally we should also check irq for wakeup capability before setting
> > device's capability, i.e.
> > 
> > 	if (can_irq_wake(irq))
> > 		device_set_wakeup_capable(&client->dev, 1);
> > 
> > But there is no can_irq_wake() call exist, and it is not that trivial
> > to implement it for all interrupts controllers and complex/cascaded
> > setups.
> 
> That is why platform code should device_init_wakeup() and
> drivers should check device_can_wakeup(dev) ...

They should (and do) check may_wakeup() (i.e. should_wakeup) before
suspending, not can_wakeup().

static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
{
        if (client->irq >= 0 && device_may_wakeup(&client->dev))
                enable_irq_wake(client->irq);
        return 0;
}

(quite funny, they issue enable_irq_wake(), assuming that otherwise
IRQ line won't trigger CPU wakeup. But in reality, there are interrupt
controllers that you can't control in that regard: any IRQ activity
will always resume CPU. And so 'echo disable > /sys/.../wakeup' won't
guarantee anything. Unreliable, nasty? Could be.)

> > drivers/base/power/sysfs.c also covers these cases:
> > 
> >  * Devices may not be able to generate wakeup events from all power
> >  * states.  Also, the events may be ignored in some configurations;
> >  * for example, they might need help from other devices that aren't
> >  * active
> > 
> > So there is no guarantee that wakeup will actually work, 
> 
> Yes there is ... it's only **exceptional** cases where it can't
> work.  Your patch would make it routine that those flags be
> unreliable; pretty nasty.

It's not exceptional at all, you really can't tell if device's wakeup
event will take any effect. It depends on so many factors that it's
virtually impossible to account them all. And hiding wakeup capability
only because you aren't sure _is_ policy hard-wiring, no?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
