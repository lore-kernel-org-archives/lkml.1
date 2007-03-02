Return-Path: <linux-kernel-owner+w=401wt.eu-S2992456AbXCBOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992456AbXCBOF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992455AbXCBOF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:05:29 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2861 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992452AbXCBOF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:05:28 -0500
Date: Fri, 2 Mar 2007 15:03:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070302150313.198b6053.khali@linux-fr.org>
In-Reply-To: <20070302114023.GD2163@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Fri, 2 Mar 2007 12:40:23 +0100, Pavel Machek wrote:
> Ok. You are right that ACPI is an ugly piece of mess. But I'm pretty
> sure that 90%+ of ACPI notebook implementations *will* want to talk to
> their monitoring chips... for temperature readings.
>
> So even if we fixed ACPI to reserve the ports, you'd be still unhappy;
> lm-sensors would break at least on all the notebooks.

That's a secondary problem. The primary issue is the concurrent access
to resources, which cause lots of trouble which are hard to investigate.
If ACPI reserves the ports, then the SMBus or hardware monitoring
drivers (or any other conflicting driver) will cleanly fail to load,
which would be a move in the right direction. Ideally we would be able
to synchronize the accesses between ACPI and the other drivers, but if
we can't, I'd already be _very happy_ to just prevent conflicting
drivers from being loaded at the same time.

So, can ACPI actually reserve the ports it accesses?

> > I would be happy to prevent SMBus and/or hardware monitoring drivers
> > from being loaded on ACPI-based system if we had a way to know which
> > systems do have ACPI code accessing these chips and which do not, and if
> > ACPI was offering a level of functionality comparable to what
> > individual hardware monitoring drivers offer. Unfortunately:
> 
> Well, I'm afraid you should assume all recent notebooks touch sensors
> from ACPI.

Correct, and on most notebooks, traditional hardware monitoring
drivers do not work anyway. Or I should say, used to not work. The
recent CPUs have embedded sensors which can be read using Rudolf
Marek's k8temp and coretemp drivers, this works on laptops as well.
Chances are good that future laptops will not include a separate
temperature sensor but will read the temperature from the CPU directly,
which will cause conflicts with our drivers.

Now the problem is that we can't blacklist SMBus and hardware
monitoring drivers on all laptops by default. There may be other
devices on the SMBus which the user can legitimately want to access,
such as EEPROMs or RTCs.

> > 1* As far as I know, we currently have no way to know if the ACPI code
> > plans to ever access the hardware monitoring chip. If the acpi
> > subsystem could export this information somehow, it would help a lot.
> > But I'm not familiar with ACPI, so I don't know if this is feasable or
> > not. We just can't prevent the SMBus and hardware monitoring drivers
> > drivers from being loaded as soon as ACPI is enabled. This would
> > prevent a majority of users from using them, while they work fine for
> > most of them.
> 
> What about whitelist? DMI-based? That's only way to do it, I'm afraid.

What kind of whitelist do you have in mind? We can't realistically
maintain an ever-growing whitelist of hundreds of entries in the
kernel. We could block all laptops by default and maintain a white list
only for them, and a black list for other systems, the would probably
limit the maintenance work, maybe not to an acceptable level though.

Anyway I would definitely prefer the resource conflicts approach, as it
wouldn't need maintenance at all.

> > 2* The hardware monitoring features offered by ACPI today are one level
> > of magnitude weaker than what lm_sensors was already offering back in
> > 1999. The monitoring chips can do much but unfortunately ACPI only
> > exposes a very small subset of the chip features. ACPI doesn't
> > handle
> 
> Yes, I know ACPI sucks at hardware monitoring. Unfortunately, we can't
> go without ACPI.

Agreed.

> > voltage monitoring at all. It usually reports no more than one fan, and
> > in my experience, more often than not, the speed is reported as a
> > boolean (spinning or not), when lm_sensors gives you the exact speed of
> > all your fans. ACPI thermal zones are not so bad, but the interface to
> > control them is ugly, and lm_sensors usually gives more details. And
> 
> Fix the interface? ;-). Actually that move may be underway as we are
> moving out of /proc.

Great, looking forward.

-- 
Jean Delvare
