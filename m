Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZA0R0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZA0R0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZA0R0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:26:47 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13037 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZA0R0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:26:46 -0500
Date: Tue, 27 Jan 2009 18:26:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] CONFIG_I2C_VIAPRO=y breaks skge
Message-ID: <20090127182631.13568383@hyperion.delvare>
In-Reply-To: <20090127154410.GA24470@elte.hu>
References: <20090127151359.GA20369@elte.hu>
	<20090127162729.50cd2e61@hyperion.delvare>
	<20090127154410.GA24470@elte.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 27 Jan 2009 16:44:10 +0100, Ingo Molnar wrote:
> * Jean Delvare <khali@linux-fr.org> wrote:
> > Wow. This is hard to believe. The i2c-viapro driver only cares about the 
> > SMBus interface of the VIA south bridge. I have a hard time imagining 
> > how it could have any effect on networking.
> > 
> > Is the skge ethernet an on-board thing or an external adapter? I guess 
> > the former. Do you have the detailed hardware specification for that 
> > machine? I wonder if the ethernet chip could be somehow connected to the 
> > SMBus.
> 
> on-board. No specification - it's an old testbox.
> 
> > Does the SMBus work on that machine? (Probably easier to test with 
> > CONFIG_I2C_VIAPRO=m and CONFIG_I2C_CHARDEV=m.) I would also like to know 
> > if there is anything in the logs when loading the i2c-viapro driver.
> 
> What's the best way to see whether the SMBus fully works on that machine?

modprobe i2c-viapro # if not built-in
modprobe i2c-dev # if not built-in
i2cdetect -l
i2cdetect <n> # where <n> is the bus number of the VIA SMBus (probably 0
              # in your case)

i2cdetect is part of i2c-tools:
http://www.lm-sensors.org/wiki/I2CTools

> > What I2C chip drivers did you include in your kernel? Presumably this is 
> > a random config, so I can imagine that there is a chip on the SMBus to 
> > which an I2C chip driver would have bound and that is causing the 
> > problem, rather than i2c-viapro itself.
> 
> Correct, i found it via random config testing. x86 defconfig + VIAPRO 
> enabled boots fine so it indeed could be interaction between i2c drivers.

Is there anything like a x86 defconfig? I didn't know. I should
probably take a look and make sure that the defaults for i2c and hwmon
are sane. What is this default configuration meant for? There are so
many different x86 machines out there... Is it supposed to support all
of them, or is it an hardware-neutral base to be extended for every
given machine?

> I've attached:
> 
>  - the bad config - it does have a good deal of other I2C drivers enabled 
>  - the good config
>  - the bad bootlog
>  - the good bootlog

OK, in the bad log I can see a lot of probings for I2C devices from
various drivers (eeprom, pcf8591, w83792d, w83781d, adm1021, etc.) Two
possibilities:
* The probes alone are enough to confuse the network adapter.
* A probe succeeds when it shouldn't and the driver binds to the wrong
  device and breaks it.

The easiest way to tell is to get a list of probes that succeeded. For
this, boot the bad kernel and run:

$ ls -l /sys/bus/i2c/devices/*/driver

> Anyway, this bug is not a big deal - i can work it around locally by 
> excluding VIAPRO on that box. If you'd like to figure out why this happens 
> that would be preferred of course, and i can send any debug info you need.

Well my guess is that you have included an I2C chip driver with a weak
detection routine. More likely this is a typical case of "if it hurts,
don't do it". But maybe we can improve the help text or default, or
even disable probing for these devices.

At this point I am reasonably certain that the i2c-viapro driver is
innocent.

-- 
Jean Delvare
