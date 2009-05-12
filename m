Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZELW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZELW1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZELW1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:27:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44056 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZELW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:27:30 -0400
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
From: john stultz <johnstul@us.ibm.com>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <1242094321.7214.156.camel@localhost.localdomain>
	 <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Content-Type: text/plain
Date: Tue, 12 May 2009 15:26:11 -0700
Message-Id: <1242167171.3462.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 10:36 +0200, Ulrich Windl wrote:
> On 11 May 2009 at 19:12, john stultz wrote:
> 
> > All, 
> > 
> > Despite recent tweaking, TSC calibration variance is still biting users
> > who care about keeping close sync with NTP servers over reboots.
> > 
> > Here's a recent example:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0905.0/02061.html
> > 
> > The problem is, each reboot, we have to calibrate the TSC, and any
> > error, regardless of how small, in the calibrated freq has to be
> > corrected for by NTP. Assuming the error is within 500ppm NTP can
> > correct this, but until it finds the proper correction value for the new
> > TSC freq, users may see time offsets from the NTP server.
> > 
> > In my experience, its fairly easy to see 100khz variance from reboot to
> > reboot with 2.6.30-rc.
> > 
> > While I think its worth trying to improve the calibration further, there
> > will likely be a trade-off between very accurate calibration and fast
> > boot times.
> > 
> > To mitigate this, I wanted to provide a tsc_khz= boot option. This would
> > allow users to set the tsc_khz value at boot-up, assuming they are
> > within 1Mhz of the calibrated value (to protect against bad values).
> > Once the tsc_khz value is set in grub, the box will always boot with the
> > same value, so the NTP drift value prior to reboot will still be correct
> > after rebooting.
> 
> [...]
> 
> Hi everyone!
> 
> I was thinking a little bit on the issue, and I wondered (assuming the TSC 
> calibration and the hardware is somewhat stable) whether one should invent a 
> mechanism similar to the RTC or random pool; i.e. load the last value that was 
> stored or accumulated before. For the TSC calibaration one could build the average 
> of previous calibration values (if the value jumps between different numbers).
> That would require a sysctl (or equivalent) interface however.

I still feel that a sysctrl or /sys/ interface for this sort of thing is
overkill. It creates yet another interface we have to manage, and really
doesn't improve the situation more then the boot option would.
Additionally it would require quite a bit of work at the clocksource
level to allow for re-calibration (currently we avoid this by
disqualifying the TSC if it changes freq). 

That said, I've gotten very few positive comments from my patch, so I'm
going to give it one more spin (to address Serge's point) and if folks
are still feeling blah about it I'll stop pushing it.

thanks
-john

