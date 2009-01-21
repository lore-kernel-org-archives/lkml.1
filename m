Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZAUVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZAUVeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZAUVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:34:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36459 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZAUVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:34:11 -0500
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
From: john stultz <johnstul@us.ibm.com>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?ISO-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
In-Reply-To: <20090121210726.GK21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org>
	 <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com>
	 <20090121210726.GK21473@genesis.frugalware.org>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 13:34:06 -0800
Message-Id: <1232573646.6997.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 22:07 +0100, Miklos Vajna wrote:
> On Wed, Jan 21, 2009 at 12:00:57PM -0800, john stultz <johnstul@us.ibm.com> wrote:
> > Could you send the output from:
> >    cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >    cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > 
> > For both kernels on the affected hardware ?
> 
> Output when no related kernel parameters are used:
> 
> 2.6.28.1:
> 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc pit jiffies
> 
> 2.6.27.10:
> 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> acpi_pm
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> acpi_pm jiffies tsc
> 
> So it seems the problem is that acpi_pm is no longer available.

Yep. Its there, but I see in the 2.6.28 dmesg:
  PM-Timer running at invalid rate: 87% of normal - aborting.

Which means its being disqualified.

Looking at the dmesg diff I see:
-TSC: PIT calibration confirmed by PMTIMER.
-TSC: using PMTIMER calibration value
-Detected 1499.820 MHz processor.
+TSC: PIT calibration deviates from PMTIMER: 1309343 1499790.
+TSC: Using PIT calibration value
+Detected 1309.343 MHz processor.

So it seems the PIT is having some sort of issue, which causes the TSC
to be miscalibrated (apparently causing the fast timekeeping in 2.6.28
you're seeing) and in addition it also is disqualifying the acpi_pm
clocksource. 

Alas, the circular "what do we trust" issue bites us again.

The TSC calibrate code was reworked recently, but that should have been
in 2.6.27 (if I'm reading the git commit dates properly), so right off I
don't know what to blame.

Ingo/Thomas: Any ideas here?

Miklos: Can you try bisecting this down some?

thanks
-john


