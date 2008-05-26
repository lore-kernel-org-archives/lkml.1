Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYEZKvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYEZKvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYEZKvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:51:46 -0400
Received: from www.tglx.de ([62.245.132.106]:38549 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYEZKvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:51:45 -0400
Date: Mon, 26 May 2008 12:50:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stas Sergeev <stsp@aknet.ru>
cc: =?ISO-8859-15?Q?Magos=E1nyi_=C1rp=E1d?= <m4gw4s@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer_get_res() problem (pcsp does not work)
In-Reply-To: <48364469.5090400@aknet.ru>
Message-ID: <alpine.LFD.1.10.0805261249000.3295@apollo.tec.linutronix.de>
References: <36d9c4070805171745y50c1648br553428d7a2b6373c@mail.gmail.com>  <483064A6.8040809@aknet.ru>  <36d9c4070805191222k7d873bffq41e17c989e8f0f3e@mail.gmail.com>  <48328330.7050707@aknet.ru>  <36d9c4070805201458v7d08b167ve2b72b1e8b3371a4@mail.gmail.com>
  <48339B7F.2010307@aknet.ru>  <36d9c4070805211403h37b4d4ebj90c5ffad592fcffe@mail.gmail.com>  <4835CDD8.4020808@aknet.ru> <36d9c4070805221837g21cd72c7l387f8a44004a064c@mail.gmail.com> <48364469.5090400@aknet.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1967058792-1211799050=:3295"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1967058792-1211799050=:3295
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 23 May 2008, Stas Sergeev wrote:
> Magosányi Árpád wrote:
> > code:
> >         hrtimer_get_res(CLOCK_MONOTONIC, &tp);
> > +      printk(KERN_INFO "PCSP: sec=%li, nsec=%linS\n",tp.tv_sec, tp.tv_nsec);
> > 
> > output:
> > [   22.882520] PCSP: sec=0, nsec=1nS
> > after an rmmod and modprobe:
> > [  476.300571] PCSP: sec=0, nsec=1nS
> > after an rmmod, changing clocksource to tsc, and insmod:
> > [  669.124557] PCSP: sec=0, nsec=1nS
> OK, thanks you.
> In this case I suspect this is not an
> snd-pcsp bug, but a hrtimer bug. Adding
> more people to CC.
> 
> So what we have:
> ---
> I have a PIIX4 chipset, the full dmesg is attached.
> Note that it is an old 400Mhz pentium, and there is some problem with
> the timer source I use:
> [    0.822740] * Found PM-Timer Bug on the chipset. Due to workarounds
> for a bug,
> [    0.822750] * this clock source is slow. Consider trying other clock
> sources
> ---
> and (presumably) because of that PM-Timer
> Bug, snd-pcsp produces only the noice.
> dmesg said that the clock source is slow,
> yet the hrtimer_get_res() claims the
> resolution is 1nS. I think this is wrong,
> hrtimer_get_res() might be broken.
> Can someone please comment on that?
> Is hrtimer_get_res() known to return 1nS
> regardless of the real clock resolution?

It's not an hrtimer bug. The kernel internal time has nsec units.

The internal resolution of hrtimers is HZ when high resolution timers
are disabled or 1nsec when high resolution timers are available and
active.

We can not expose an exact resolution in this interface as this
depends on too many factors and it would be a horrible hackery to take
the theroetical resolution which results from the available clock
source and the resolution of the device which generates the timer
events into account in the hrtimer code. Even if we would expose an
interface which lets you know the exact resulting resolution there is
no guarantee that a timer meets its expiry time exactly.

The pmtimer bug is not causing the problems you have. It just slows
down the access to the pmtimer (instead of reading it straight we need
to read twice and do a sanity check).

Thanks,
        tglx
--8323328-1967058792-1211799050=:3295--
