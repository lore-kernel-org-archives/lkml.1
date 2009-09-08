Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZIHVTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZIHVTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIHVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:19:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47122 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIHVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:19:39 -0400
Date: Tue, 8 Sep 2009 23:19:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Subject: Re: Zaurus suspend saga
Message-ID: <20090908211933.GB17228@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> <20090907113132.GM23450@elf.ucw.cz> <1252329025.1861.6.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252329025.1861.6.camel@hammer.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > c) We rip the whole thing out and stop supporting "offline" charging.
> > 
> > How much faster is offline charge, compared to online charging? I have
> > impression that online charging basically does not charge anything...
> 
> I think that online charging works, but it seems to be slower. I am not
> sure, whether it is a hardware or software issue. You can control
> charging speed by software, but the final word has the charging
> chip.

Well, overnight charge (online) seems to result in pretty much empty
battery...


> Here are control wires:
> SPITZ_SCP_JK_A: output = turns dummy load to 1 kOhm resistor
> SPITZ_SCP_JK_B: output = high charging current
> SPITZ_SCP_CHRG_ON: output = charging on
> SPITZ_SCP_ADC_TEMP_ON: output = turns battery sensor on/off
> SPITZ_GPIO_CHRG_FULL input = charging complete
> SPITZ_GPIO_AC_IN input = AC adapter is present

Is CHRG_ON pin reversed?

static void spitz_charge(int on)
{
	if (on) {
		if (sharpsl_pm.flags & SHARPSL_SUSPENDED) {
			gpio_set_value(SPITZ_GPIO_JK_B, 1);
			gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
		} else {
			gpio_set_value(SPITZ_GPIO_JK_B, 0);
			gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
		}
	} else {
		gpio_set_value(SPITZ_GPIO_JK_B, 0);
		gpio_set_value(SPITZ_GPIO_CHRG_ON, 1);
	}
}


> MAX1111 inputs:
> MAX1111_ACIN_VOLT: Voltage in AC input (after pass of input circuit,
>                    before tha final diode)
> MAX1111_BATT_TEMP: Battery temperature sensor
> MAX1111_BATT_VOLT: Battery voltage
> 
> Here are notes from the design:
> Pre-charge = 102mA

> Fast charge = 680mA
> Fast charge set ON = 105mA

I'm quite confused:

> SPITZ_SCP_JK_B: output = high charging current

Is JK_B active low?

> Iterm = 55mA
> 
> Thresholds:
> SPITZ_GPIO_AC_IN:     4.2V (IC charging circuit)
> SPITZ_GPIO_FATAL_BAT: 3.0V (voltage detector IC on battery)
> PXA270 batt fault:    2.8V (voltage on the main non-regulated power)
> CF/SD:                2.8V (voltage required for CF/SD activation, I am
>                             not sure, why it is done, because 2.8V is
>                             outside of spec anyway)

> - It would be nice to have "small travel charger heuristic": Turn fast
> charging on, charger "disappears", switch to slow charging, charger
> "appears" => stay in slow charging mode, and retry after some time, or
> after going to suspend, reset the flag when charger is removed.

Yes, I have similar "travel charger" (from single AA in fact), too,
and yes getting that heuristic would be cool. But for now, I'd settle
with /sys control enabling that.

> - sysfs interface for charging would be nice. For example: Cyril has an
> external battery pack and he wants to disable charging of internal
> battery from the external battery.

Yes, more debug info in sysfs and some controls would be nice.

BTW... /sys/class/leds/spitz:amber:charge seems to have life of its
own. I can't manually change the brightness; also changing trigger
does not work -- it still displays charging status. What is going on?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
