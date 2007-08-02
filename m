Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXHBJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXHBJml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXHBJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:42:32 -0400
Received: from ns1.suse.de ([195.135.220.2]:46896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbXHBJmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:42:31 -0400
Subject: Re: 2.6.22 regression: thermal trip points
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       mjg59@srcf.ucam.org, lenb@kernel.org,
       Adrian =?ISO-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <46B1988C.3090302@t-online.de>
References: <46B1988C.3090302@t-online.de>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 11:42:27 +0200
Message-Id: <1186047747.18821.450.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 10:40 +0200, Knut Petersen wrote:
> Hi everybody!
> 
> Kernel 2.6.22 decreases performance by about 50% on my system.
> No, I do not like that. The reason is a broken BIOS, granted, but there
> was a perfect workaround in the kernel that has been dropped.
> 
> mainboard: AOpen i915GMm-hfs, AWARD BIOS
> cpu: Pentium-M 750 (0.8 to 1.86 MHz)
> openSuSE 10.2 with kernel 2.6.22.1
Is this a DELL laptop that gets throttled by 75% to throttling state 6
if 60 degrees are exceeded?
Adrian has such a machine..., no idea what is going on with that one,
but only workaround to get any use out of this machine is to override at
least the passive trip point.
> 
> The cpu fan can not be controled by linux kernel.
> The BIOS will switch on the cpu fan a bit above 50 deg. Celsius.
> The active and passive trip points both are set to 50 deg. Celsius.
> Temperature of the idle cpu at 800 Mhz: 34 to 42 deg. C.
> The BIOS never changes the trip points.
> Cpufreq does work perfectly.
> 
> Previously there was the possibility  to add something like
> 
> echo  "100:0:65:70:0" > /proc/acpi/thermal_zone/THRM/trip_points
> echo  2 > /proc/acpi/thermal_zone/THRM/polling_frequency
> echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> 
> to e.g. /etc/init.d/boot.local. With 2.6.22 that solution does not exist
> any longer. Now the code in thermal.c slows down the cpu under load
> to prevent "overheating". Kernel compile time increases from about 12
> to 18 minutes. No, I don´t like that, nobody would.
> 
> Possible solutions:
> 
> 1. Get a better BIOS! --- There is none.
> 
> 2. Fix DSDT!  --- Recompiling gives a number of errors ... I do not  know
> how to fix it.
> 
> 3. Don´t include thermal.c! --- That does help, but as this is a 24/7
> system, the
> cpu fan could break. At that time I do not want to rely on the BIOS to
> save my
> system (the next trip point is at 100 deg. Celsius).
> 
> 4. Revert Len Browns commit 11ccc0f249cb01a129f54760b8ff087f242935d4
> 
> I would vote for option 4, but I do understand some of the arguments of
> Len in
> the 2.6.22-rc1-mm1 discussion in May. Yes, communicating trip points to
> thermal.c is a hack, it will fail on systems that change trip points
> dynamically
> and it might be dangerous for the machine if unreasonable trip points
> are chosen.
> But it does help to keep the machine quiet, and to work around a too low
> or too
> trip points defined by the BIOS.
> 
> If it should be not acceptable to revert the questionable commit without
> changes,
As 2.6.22 was shipped without, I think reverting is not a real option.

> would it be acceptable to make rw trip_points a kernel config option?
IMO something new should be added.
On longterm, maybe it's possible to marriage ACPI thermal control with
hwmon interface, AFAIK there are already efforts to do so, but I don't
know much about it. Still overriding trip points is a problem because
BIOS can change them at runtime... IMO it should just be possible and
machines changing them at runtime either:
  - do change the user's overrides
  - or trip points are simply fixed after user has overridden them
    -> my favorite (Don't care for hysteresis BIOS implementations,
    if user changes them, it's his fault, he doesn't need to...)
Sanity checks that trip points only can get lowered (compared to initial
provided ones) needs to be added.
Len, Rui: For short-term can something like that be added at least to
the new sysfs interface (I am willing to help if this is a "would be
nice to have, but no time, maybe later" issue)?

Especially passive trip point modification is IMO a powerful feature.
You can easily build a passive cooled system, running at the performance
level your cooling system allows (CPU frequency simply gets lowered
before fans kick in).
Other architectures than ACPI powered already make use of CPU frequency
scaling. An ACPI independent passive cooling implementation connecting
thermal control (hwmon?) and cpufreq interface should be desired for
future? (could get tricky because ACPI spec has some special needs for
passive cooling)

   Thomas

