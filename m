Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZIGNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZIGNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZIGNK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:10:26 -0400
Received: from ns.penguin.cz ([84.21.108.25]:34149 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZIGNKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:10:25 -0400
Subject: Re: Zaurus suspend saga
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <20090907113132.GM23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <20090907113132.GM23450@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Mon, 07 Sep 2009 15:10:25 +0200
Message-Id: <1252329025.1861.6.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote: 
> 
> > Sadly lack of time means I've lost track of the Zaurus kernels but this
> > sounds like all accesses to the SSP buses now go through the SPI layer
> > and when it was converted nobody thought about the impact this would
> > have on the Zaurus charger code.
>
>Unfortunately... Do you have any idea when this conversion took place?

In past, MAX1111 driver was embedded in the Zaurus specific code. Now
MAX1111 is a generic SPI driver and spitz_pm.c calls it.

Maybe it will still work with CONFIG_CORGI_SSP_DEPRECATED.

> > c) We rip the whole thing out and stop supporting "offline" charging.
> 
> How much faster is offline charge, compared to online charging? I have
> impression that online charging basically does not charge anything...

I think that online charging works, but it seems to be slower. I am not
sure, whether it is a hardware or software issue. You can control
charging speed by software, but the final word has the charging chip.

Here are control wires:
SPITZ_SCP_JK_A: output = turns dummy load to 1 kOhm resistor
SPITZ_SCP_JK_B: output = high charging current
SPITZ_SCP_CHRG_ON: output = charging on
SPITZ_SCP_ADC_TEMP_ON: output = turns battery sensor on/off
SPITZ_GPIO_CHRG_FULL input = charging complete
SPITZ_GPIO_AC_IN input = AC adapter is present

MAX1111 inputs:
MAX1111_ACIN_VOLT: Voltage in AC input (after pass of input circuit,
                   before tha final diode)
MAX1111_BATT_TEMP: Battery temperature sensor
MAX1111_BATT_VOLT: Battery voltage

Here are notes from the design:
Pre-charge = 102mA
Fast charge = 680mA
Fast charge set ON = 105mA
Iterm = 55mA

Thresholds:
SPITZ_GPIO_AC_IN:     4.2V (IC charging circuit)
SPITZ_GPIO_FATAL_BAT: 3.0V (voltage detector IC on battery)
PXA270 batt fault:    2.8V (voltage on the main non-regulated power)
CF/SD:                2.8V (voltage required for CF/SD activation, I am
                            not sure, why it is done, because 2.8V is
                            outside of spec anyway)

When I measured my battery, Linux 2.6.26 went to emergency sleep at
3.4V.

Note that battery thresholds probably should not be hardwired in
spitz_pm.c but read from the NAND configuration instead (Andrea Adami
knows, how it can be done).

Here is the datasheet of the charging circuit:
http://www.penguin.cz/~utx/zaurus/datasheets/power/charging/sc801.pdf

There were more problems in the charging code even before:

- The measurement code should work without turning LED on (bootloader
can do it). SPITZ_SCP_JK_A should connect dummy load. I guess it should
be enough for measurement. But comments in the source tree say that is
did not work. I am not sure why.

- It would be nice to have "small travel charger heuristic": Turn fast
charging on, charger "disappears", switch to slow charging, charger
"appears" => stay in slow charging mode, and retry after some time, or
after going to suspend, reset the flag when charger is removed.

- sysfs interface for charging would be nice. For example: Cyril has an
external battery pack and he wants to disable charging of internal
battery from the external battery.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/


