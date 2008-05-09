Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYEIH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYEIH3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 03:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYEIH3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 03:29:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42980 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYEIH3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 03:29:05 -0400
Date: Fri, 9 May 2008 09:28:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <20080509092835.3bbf0f55@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
	<20080507085953.2c08b854@hyperion.delvare>
	<Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
	<20080508105905.3209c659@hyperion.delvare>
	<Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Fri, 9 May 2008 00:10:47 +0100 (BST), Maciej W. Rozycki wrote:
> > I'm not going to tell how bad I think the GNU coding standards are, the
> > point here is that we don't follow them at all, so whatever they say is
> > totally irrelevant. Read Documentation/CodingStyle, it describes what
> 
>  Oh come on -- that's just common sense.  If something is good, there is
> no point in discarding it without thinking, just because it is a part of a
> bigger entity that we consider bad.  I consider it good not because it is
> a part of the GNU standard, but because I have concluded that it is and it
> is pure coincidence ;-) I have taken it from the said standard.

Let me just quote you:

"This is mostly habitual -- this is what the GNU Coding Standard specifies
for comments and which is enforced for GNU software which I have dealt a
lot with."

You didn't say it was common sense. You did say that it was what the
GNU Coding Standard specified, and as a consequence, what you were used
to. So please keep your "oh come on" for yourself, you pointed the
discussion in this direction yourself.

>                                                                   But as I
> said, this is a minor nit here and I can resist from adding extraneous
> spaces in pieces of code you are interested in as long as I am able to
> track which ones they actually are.

What matters is not "the pieces of code I am interested in", but the
pieces of code _you_ are the master of, or not. As explained somewhere
else in this thread, you are free to use whatever style you like (as
long as it complies with Documentation/CodingStyle, that is) in new
code you write and in code you maintain. For all the rest, you should
stick to the surrounding style. This is common sense, as you'd say.

> (...)
>  Well, arch/mips/sibyte/swarm/ is included for all the three above as well 
> as a couple of other I may not necessarily be sure what they are even.  So 
> this should be of no concern.
> 
>  BTW, do you mean i2c_add_numbered_adapter() will fail if no devices have
> been declared to exist on the given bus with i2c_register_board_info()?  
> That sounds strange...

i2c_add_numbered_adapter() _may_ fail if no I2C devices have been
declared _and_ other i2c adapters are registered using
i2c_add_adapter(). When you declare I2C devices, i2c-core reserves the
bus numbers in question for i2c_add_numbered_adapter() and they cannot
be used for i2c_add_adapter(). This is what guarantees that the calls
to i2c_add_numbered_adapter() (in i2c-sibyte for example) will succeed.
If no I2C devices are declared, bus numbers are not reserved, so if it
happens that another I2C bus driver registers itself before i2c-sibyte
does, when i2c-sibyte calls i2c_add_numbered_adapter(), the bus number
is already in use and the call fails.

I admit that this is unlikely to happen, but depending on what exact
hardware there is on the system and what drivers are built-in, it could
happen. I think it is a weakness of i2c-core, it should allow platform
code to reserve i2c bus numbers regardless of what devices are
registered. I seem to remember I said that when the code was added to
the kernel already. I guess we'll have to fix it the day it actually
breaks.

BTW, i2c-sibyte should be converted to a proper platform driver, so
that only platforms with such a device instantiate it.

>                         Note in all cases there are EEPROMs (onboard ones
> as well as optionally SPD ones) on both buses on Broadcom/SiByte boards
> and they are handled by a legacy client driver.  The Broadcom SOC is
> actually capable to bootstrap from one of these EEPROMs (rather than form
> the usual system parallel Flash ROM).

Which legacy driver, "eeprom"? You should probably look into David
Brownell's at24c driver:
http://lists.lm-sensors.org/pipermail/i2c/2008-April/003307.html
If it gets enough attention and testing, it could go upstream quickly.

-- 
Jean Delvare
