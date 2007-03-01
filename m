Return-Path: <linux-kernel-owner+w=401wt.eu-S965103AbXCAO26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103AbXCAO26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965096AbXCAO25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:28:57 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:3807 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965094AbXCAO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:28:56 -0500
Date: Thu, 1 Mar 2007 15:26:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070301152655.f232db64.khali@linux-fr.org>
In-Reply-To: <20070228213803.GA4877@ucw.cz>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, 28 Feb 2007 21:38:04 +0000, Pavel Machek wrote:
> > > Well I had an idea after looking at k8temp -- why not make it default to
> > > doing only reads from the sensor?  You'd only get information from whatever
> > > core/sensor combination that ACPI had last used, but it would be safe.
> > 
> > ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
> > doesn't conflict with only k8temp, but with virtually all hardware
> > monitoring drivers, all I2C/SMBus drivers, and probably other types of
> > drivers too. We just can't restrict or blacklist all these drivers
> > because ACPI misbehaves.
> 
> Oops, sorry about that but no, that will not work.
> 
> There's piece of paper, called ACPI specification, and we are
> following it.

I never suggested otherwise. But the Linux 2.6 device driver model is
based, in part, on the fact that each driver must request the
resources it needs before actually using them. The acpi subsystem fails
to do that, so it is, in that sense, misbehaving. The is the root cause
of the problems people are reporting these days.

> Bug is not in our implementation.
> 
> Bug is in the ACPI specs... it does not explicitely allow you to go
> out and bitbang i2c, and you do it, and you get problems.

It really doesn't have anything to do with bit-banged I2C. It's about
SMBus master chips (most often embedded in south bridges), hardware
monitoring chips (be them SMBus-based or not), or basically any driver
which uses a resource ACPI is using as well (virtually any driver
accessing a Super-IO/LPC device is affected, for example.)

Secondly, your logic is somewhat broken. Just because one specification
doesn't explicitely allow me to do something, I must stop doing it?
There must be two dozen different specifications modern PC hardware
supposedly conforms to. If we stop doing everything which isn't
explicitely allowed by all of them, I fear there won't be much left ;)
A better question would be IMHO: Does the ACPI specification
explicitely _prohibits_ accessing directly to some categories of
hardware?

Lastly, I wholeheartedly agree that the core problem appears to be in
the ACPI design rather than in the Linux implementation. As a matter of
fact, other operating systems are facing the same problem [1]. The
problem isn't less real, though.

> Now, you may try to change specs to be hwmon-friendly... good luck.

I would like them to be driver-model-friendly, that's even a broader
challenge ;)

> But currently hw manufacturers follow ACPI specs, so we have to follow
> it, too; bad luck for hwmon. BIOS hiding smbus from you is good hint
> you are doing something wrong...?

I would love things to be that easy, but unfortunately they are not.

Firstly, the first records of hidden SMBus, in September 2000, predate
ACPI. All the early boards where the SMBus was hidden did not have ACPI
code poking at it at all, so this is definitely not the reason why it
was removed. The Asus P4 series is a good example of that. Unhiding the
SMBus on these boards actually let the user take benefit of the
hardware they had paid for.

Secondly, only a few south bridges are capable of hiding the SMBus. And
an even smaller number of systems have their SMBus actually hidden by
the BIOS. A much large number of systems, especially recent ones, have
ACPI poking at the hardware monitoring chip (again, SMBus-based or
not.) So there is no correlation between hidden SMBus and ACPI poking
at the hardware monitoring chip. So, even though we are very careful
these days when adding a quirk to unhide the SMBus on a new system (we
make sure that ACPI isn't accessing it), this is not going to solve the
general problem.

I would be happy to prevent SMBus and/or hardware monitoring drivers
from being loaded on ACPI-based system if we had a way to know which
systems do have ACPI code accessing these chips and which do not, and if
ACPI was offering a level of functionality comparable to what
individual hardware monitoring drivers offer. Unfortunately:

1* As far as I know, we currently have no way to know if the ACPI code
plans to ever access the hardware monitoring chip. If the acpi
subsystem could export this information somehow, it would help a lot.
But I'm not familiar with ACPI, so I don't know if this is feasable or
not. We just can't prevent the SMBus and hardware monitoring drivers
drivers from being loaded as soon as ACPI is enabled. This would
prevent a majority of users from using them, while they work fine for
most of them.

2* The hardware monitoring features offered by ACPI today are one level
of magnitude weaker than what lm_sensors was already offering back in
1999. The monitoring chips can do much but unfortunately ACPI only
exposes a very small subset of the chip features. ACPI doesn't handle
voltage monitoring at all. It usually reports no more than one fan, and
in my experience, more often than not, the speed is reported as a
boolean (spinning or not), when lm_sensors gives you the exact speed of
all your fans. ACPI thermal zones are not so bad, but the interface to
control them is ugly, and lm_sensors usually gives more details. And
more importantly, on almost all desktop and server motherboards, ACPI
does _not_ provide any hardware monitoring feature. So we really can't
go tell our users: give up the individual hardware monitoring drivers
and lm_sensors on all ACPI-enabled systems and use whatever ACPI offers
instead. This would be a major functionality loss for a vast majority
of users.

What do you propose?

[1] http://www.microsoft.com/whdc/system/pnppwr/powermgmt/BIOSAML.mspx

-- 
Jean Delvare
