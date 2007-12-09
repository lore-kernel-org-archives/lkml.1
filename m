Return-Path: <linux-kernel-owner+w=401wt.eu-S1751990AbXLIOdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbXLIOdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXLIOdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:33:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXLIOdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:33:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: clock jumps on dualcore PentiumD with cpufreq
Date: Sun, 9 Dec 2007 15:51:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <475BDC14.9040004@msgid.tls.msk.ru>
In-Reply-To: <475BDC14.9040004@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091551.59369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added some CCs.

On Sunday, 9 of December 2007, Michael Tokarev wrote:
> This isn't a new issue, but so far no solution(s)
> has been found, it seems.  And with kernel development
> going on, the issue becomes worse.
> 
> Up to 2.6.20 or so (I don't remember exactly, but if
> I recall correctly the issue first appeared when new
> timer code has been merged), there was no issues at
> all.
> 
> Starting with 2.6.21 (at least), I see frequent messages
> from chronyd (http://chrony.sunsite.dk/), which was running
> on this machine since the day one, messages telling me
> that system clock has been reset - up to +/- several
> seconds.
> 
> On 2.6.22 there were only a few such messages per day,
> and the time delta was less than a second - in between
> 0.2-0.8 second usually.  On 2.6.23, it become much,
> much worse.  Here's a typical log from today:
> 
> ...
> Dec  9 08:10:50 paltus chronyd[1761]: System clock wrong by 0.664195 seconds, adjustment started
> Dec  9 08:31:06 paltus chronyd[1761]: System clock wrong by 0.666263 seconds, adjustment started
> Dec  9 09:10:35 paltus chronyd[1761]: System clock wrong by 0.830534 seconds, adjustment started
> Dec  9 09:47:56 paltus chronyd[1761]: System clock wrong by -0.632430 seconds, adjustment started
> Dec  9 10:11:24 paltus chronyd[1761]: System clock wrong by 0.557093 seconds, adjustment started
> Dec  9 10:30:36 paltus chronyd[1761]: System clock wrong by 0.931442 seconds, adjustment started
> Dec  9 10:31:40 paltus chronyd[1761]: System clock wrong by 0.918518 seconds, adjustment started
> Dec  9 10:32:44 paltus chronyd[1761]: System clock wrong by 0.919524 seconds, adjustment started
> Dec  9 10:33:48 paltus chronyd[1761]: System clock wrong by -1.783922 seconds, adjustment started
> Dec  9 10:50:53 paltus chronyd[1761]: System clock wrong by 0.815781 seconds, adjustment started
> Dec  9 11:18:37 paltus chronyd[1761]: System clock wrong by -1.120279 seconds, adjustment started
> Dec  9 11:48:30 paltus chronyd[1761]: System clock wrong by -0.576473 seconds, adjustment started
> Dec  9 11:50:38 paltus chronyd[1761]: System clock wrong by 0.728826 seconds, adjustment started
> Dec  9 11:52:46 paltus chronyd[1761]: System clock wrong by 0.561940 seconds, adjustment started
> Dec  9 11:57:02 paltus chronyd[1761]: System clock wrong by -0.786041 seconds, adjustment started
> Dec  9 12:18:22 paltus chronyd[1761]: System clock wrong by -0.559688 seconds, adjustment started
> Dec  9 12:20:30 paltus chronyd[1761]: System clock wrong by 0.712789 seconds, adjustment started
> Dec  9 12:26:55 paltus chronyd[1761]: System clock wrong by -0.511155 seconds, adjustment started
> Dec  9 12:40:47 paltus chronyd[1761]: System clock wrong by 0.721966 seconds, adjustment started
> Dec  9 12:47:11 paltus chronyd[1761]: System clock wrong by -1.053725 seconds, adjustment started
> Dec  9 13:01:03 paltus chronyd[1761]: System clock wrong by 0.921670 seconds, adjustment started
> Dec  9 13:21:20 paltus chronyd[1761]: System clock wrong by 0.948468 seconds, adjustment started
> ...
> 
> As far as I can guess, the problem is that the clock is
> different on different CPUs (or, rather, cores), so when
> the process (chronyd) gets moved from one core to another,
> it loses its minds and behaves like the above, unable to
> "understand" what's going on, and the result is that it
> speeds up the clock on a core where it should slow the
> clock down and vise versa, resulting it a mess.
> 
> The machine is an IBM xSeries 3200, single CPU dual-core
> PentiumD processor:
> 
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	: Intel(R) Pentium(R) D CPU 2.80GHz
> stepping	: 4
> cpu MHz		: 2800.000
> cache size	: 2048 KB
> 
> The system says that TSC clocksource is unstable and switches
> to jiffies:
> 
> Clocksource tsc unstable (delta = 70021228 ns)
> Time: jiffies clocksource has been installed.
> 
> There are two things I noticed so far.
> 
> First, this problem is quite strongly related to cpufreq.
> Namely, without cpufreq scaling (with the default "performance"
> governor), everything works correctly.  After switching to
> "ondemand" governor, chronyd goes mad as shown above.  And
> after switching back to "performance", after some time (needed
> for the madness to slowly stop), the problem vanishes again.
> By the way, I'm not exactly sure but it seems that the above
> message (about TSC being unstable) is triggered right when
> switching to "ondemand" governor.
> 
> And second, I've only seen the whole problem with 32bits
> kernel.  x86-64 kernel (with the exact same config) does
> not expose it in any way, be it cpufreq or not.
> 
> This last point is the very interesting one, because it
> suggests that the bug is in kernel somewhere, more, that
> it's in i386 part of it.
> 
> Sadly I've only a limited testing abilities on this machine,
> as it's our main production (file) server (so I can only
> test something on it during weekends and late evenings).
> 
> Similar (but at much smaller extent/scale) behavior has been
> observed on several machines with AMD X2-64 processors as well,
> also related to cpufreq, but this time both 64 and 32 bits
> kernels behaves the same, and it seems this is a different
> issue.
> 
> Any recommendations for me to try to debug it further, please?..
> 
> Thanks.
> 
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
