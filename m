Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZIVVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZIVVV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZIVVV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:21:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303AbZIVVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:21:26 -0400
Date: Tue, 22 Sep 2009 14:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: david-b@pacbell.net, ben-linux@fluff.org, khali@linux-fr.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] rtc: Set wakeup capability for I2C and SPI RTC drivers
Message-Id: <20090922141940.22596f11.akpm@linux-foundation.org>
In-Reply-To: <20090828003010.GA19160@oksana.dev.rtsoft.ru>
References: <20090827182207.GA7358@oksana.dev.rtsoft.ru>
	<200908271452.37358.david-b@pacbell.net>
	<20090827231925.GA1131@oksana.dev.rtsoft.ru>
	<20090828003010.GA19160@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 04:30:10 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Fri, Aug 28, 2009 at 03:19:25AM +0400, Anton Vorontsov wrote:
> [...]
> > > That is why platform code should device_init_wakeup() and
> > > drivers should check device_can_wakeup(dev) ...
> > 
> > They should (and do) check may_wakeup() (i.e. should_wakeup) before
> > suspending, not can_wakeup().
> > 
> > static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
> > {
> >         if (client->irq >= 0 && device_may_wakeup(&client->dev))
> >                 enable_irq_wake(client->irq);
> >         return 0;
> > }
> > 
> > (quite funny, they issue enable_irq_wake(), assuming that otherwise
> > IRQ line won't trigger CPU wakeup. But in reality, there are interrupt
> > controllers that you can't control in that regard: any IRQ activity
> > will always resume CPU. And so 'echo disable > /sys/.../wakeup' won't
> > guarantee anything. Unreliable, nasty? Could be.)
> 
> BTW, of course we can fix this by masking interrupts before
> suspending, but nobody actually do this (but should, I think).
> 
> And if RTC's IRQ is wired to power switch you're in trouble
> without any way to fix this.
> 

afaik nothing got resolved here, so this patch is floating about
wondering what its future will be.



From: Anton Vorontsov <avorontsov@ru.mvista.com>

RTC core won't allow wakeup alarms to be set if RTC devices' parent (i.e. 
i2c_client or spi_device) isn't wakeup capable.

For I2C devices there is I2C_CLIENT_WAKE flag exists that we can pass via
board info, and if set, I2C core will initialize wakeup capability.  For
SPI devices there is no such flag at all.

I believe that it's not platform code responsibility to allow or disallow
wakeups, instead, drivers themselves should set the capability if a device
can trigger wakeups.

That's what drivers/base/power/sysfs.c says:

 * It is the responsibility of device drivers to enable (or disable)
 * wakeup signaling as part of changing device power states, respecting
 * the policy choices provided through the driver model.

I2C and SPI RTC devices send wakeup events via interrupt lines, so we
should set the wakeup capability if IRQ is routed.

Ideally we should also check irq for wakeup capability before setting
device's capability, i.e.

	if (can_irq_wake(irq))
		device_set_wakeup_capable(&client->dev, 1);

But there is no can_irq_wake() call exist, and it is not that trivial to
implement it for all interrupts controllers and complex/cascaded setups.

drivers/base/power/sysfs.c also covers these cases:

 * Devices may not be able to generate wakeup events from all power
 * states.  Also, the events may be ignored in some configurations;
 * for example, they might need help from other devices that aren't
 * active

So there is no guarantee that wakeup will actually work, and so I think
there is no point in being pedantic wrt checking IRQ wakeup capability.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    2 ++
 drivers/rtc/rtc-ds1307.c |    2 ++
 drivers/rtc/rtc-ds1374.c |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1305.c
@@ -780,6 +780,8 @@ static int __devinit ds1305_probe(struct
 					spi->irq, status);
 			goto fail1;
 		}
+
+		device_set_wakeup_capable(&spi->dev, 1);
 	}
 
 	/* export NVRAM */
diff -puN drivers/rtc/rtc-ds1307.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1307.c
@@ -881,6 +881,8 @@ read_rtc:
 				"unable to request IRQ!\n");
 			goto exit_irq;
 		}
+
+		device_set_wakeup_capable(&client->dev, 1);
 		set_bit(HAS_ALARM, &ds1307->flags);
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
diff -puN drivers/rtc/rtc-ds1374.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1374.c
@@ -383,6 +383,8 @@ static int ds1374_probe(struct i2c_clien
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
 		}
+
+		device_set_wakeup_capable(&client->dev, 1);
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
_

