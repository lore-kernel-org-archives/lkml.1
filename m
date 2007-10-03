Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbXJCXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbXJCXc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 19:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXJCXcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 19:32:48 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:28987 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbXJCXcr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 19:32:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Decreasing stime running confuses top (was: top displaying 9999% CPU usage)
Date: Thu, 4 Oct 2007 01:32:44 +0200
User-Agent: KMail/1.9.7
References: <200710031433.34504.elendil@planet.nl> <200710032127.42147.elendil@planet.nl> <20071003202446.GQ10199@1wt.eu>
In-Reply-To: <20071003202446.GQ10199@1wt.eu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200710040132.45062.elendil@planet.nl>
X-OriginalArrivalTime: 03 Oct 2007 23:32:45.0393 (UTC) FILETIME=[B365C410:01C80615]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007, you wrote:
> On Wed, Oct 03, 2007 at 09:27:41PM +0200, Frans Pop wrote:
> > On Wednesday 03 October 2007, you wrote:
> > > On Wed, 3 Oct 2007, Ilpo Järvinen wrote:
> > > > On Wed, 3 Oct 2007, Frans Pop wrote:
> > > > > The only change is in 2 consecutive columns: "2911 502" -> "2912
> > > > > 500". Is processor usage calculated from those? Can someone
> > > > > explain how?
> > > >
> > > > The latter seems to be utime ...decreasing. No wonder if
> > > > arithmetics will give strange results (probably top is using
> > > > unsigned delta?)...
> > >
> > > Hmm, minor miscounting from my side, stime seems more appropriate...
> >
> > So, is it normal that stime decreases sometimes or a kernel bug?
> > /me expects the last...
>
> Let me guess... Dual core AMD64 ?

Nope: Intel(R) Pentium(R) D CPU 3.20GHz

> I'm 99.99% sure that if you boot with "notsc", the problem disappears.

Not really. With that first test I did have:
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

If I boot with 'notsc', I get:
cat /sys/devices/system/clocksource/clocksource0/current_clocksource
hpet

But the problem is still exactly the same:
Oct 04 00:53:37 545 92
Oct 04 00:53:38 545 94
Oct 04 00:53:43 546 92  <--
Oct 04 00:53:49 547 94
Oct 04 00:53:54 549 93  <--
Oct 04 00:54:00 550 94

Some relevant lines from kernel log:
checking TSC synchronization [CPU#0 -> CPU#1]: passed  <--- Not there with 'notsc'
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
hpet_resources: 0xfed00000 is busy
Time: tsc clocksource has been installed.  <--- Not there with 'notsc'

> If so, you have one of those wonderful AMD64 with unsynced clock and
> without HPET to sync with. I wrote a simple program in the past to exhibit
> the problem. It would bsimply run "date +%s" in a busy loops and display
> each time it would change. Amazing. It could jump back and forth by up to
> 3 seconds!

I tried your script, but the clock runs perfectly. Never saw anything
other than a 1 second increment.


The following may well be relevant.
With 2.6.22 and early 2.6.23-rc kernels (rc3-rc6) I often had this in my
kernel log (see http://lkml.org/lkml/2007/9/16/45):
   checking TSC synchronization [CPU#0 -> CPU#1]:
   Measured 248 cycles TSC warp between CPUs, turning off TSC clock.
   Marking TSC unstable due to check_tsc_sync_source failed

Some boots the TSC synchronization would be OK, but I'd see ~2/3 failures.
Kernels before 2.6.22 did not have this problem.

However, checking my logs now I see that these messages have disappeared
since 2.6.23-rc7. Now the TSC synchronization check always passes.


I also tried with 2.6.22-6 and with that the jumping around is _not_
present. This was a boot where TSC synchronization failed, so with hpet
as clocksource.
Also, the numbers stay constant much longer and have bigger increments
(updates look to be once per minute?):
Oct 04 01:24:19 465 67
Oct 04 01:24:50 467 69
Oct 04 01:24:51 469 72
Oct 04 01:25:51 474 76
Oct 04 01:26:50 478 80

Cheers,
Frans Pop
