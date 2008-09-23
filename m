Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYIWPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYIWPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYIWPsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:48:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYIWPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:48:23 -0400
Date: Tue, 23 Sep 2008 08:46:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <48D901FE.5060604@redhat.com>
Message-ID: <alpine.LFD.1.10.0809230821170.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>  <48D7F5E8.3000705@redhat.com>  <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>  <48D81B5F.2030702@redhat.com>  <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
  <48D832B6.3010409@redhat.com> <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com> <48D901FE.5060604@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Sep 2008, Masami Hiramatsu wrote:
> 
> $ dmesg | grep TSC
> checking TSC synchronization [CPU#0 -> CPU#1]:
> Measured 4246549092 cycles TSC warp between CPUs, turning off TSC clock.
> Marking TSC unstable due to: check_tsc_sync_source failed.

Hmm.. Very interesting.

It smells of a non-stable TSC, but your Core2 Cpu shouldn't have that 
issue:

> 
> $ cat /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
> stepping	: 6
> cpu MHz	: 1000.000
> cache size	: 4096 KB
> flags		: ... constant_tsc ...
> 
> Actually, I had measured TSC drifting and reported to systemtap-bugzilla
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=3916#c19

I'd have assumed it was just some initial offset issue, but your 
bug-report seems to say that it really does change the TSC frequency when 
the CPU frequency changes. That should _not_ happen on a core2 CPU, afaik. 
I didn't even know it could be a setup issue, but it does really smell 
like your TSC frequency changes.

Now, unstable TSC's are not uncommon per se, and most older Intel CPU's 
will do it, it's just that I thought it was fixed in Core2 (and later P4's 
for that matter).

The rule *should* be that:
 - family = 15 (netburst), model 3 or higher has constant TSC
 - family = 6 (PPro), model 14 or higher (Core, Core 2)
have constant TSCs. This is quite clearly documented: see Intel ia docs, 
vol 3B, 18.10 "Time-stamp counter".

Very odd. I wonder what your laptop does to screw this up. 

I also suspect that since we already _noticed_ that the TSC isn't stable, 
we should also have then cleared the "constant TSC" bit. And we apparently 
didn't.

Btw, your CPU looks quite odd in other respects too. Judging by your 
bugzilla entry, the TSC sometimes ticks at 2GHz (fine), sometimes at 1Ghz 
(also fine), and sometimes at 667/500MHz judging by the ratios you show 
for TSC/timer tick.

And that last one is really odd, afaik most 2GHz Core 2 duo's will have a 
lower frequency of 1GHz. Is that some special low-power version, perhaps? 
Or maybe it isn't a speedstep-able CPU at all, and the system actually 
changes the *bus* frequency (and then the CPU frequency is some constant 
factor of that). If so, the system messes with the CPU in bad ways.

And btw, I'm almost certain that what you see isn't actually any "CPU 
drift" in the sense that I strongly suspect that the TSC's for both cores 
will change frequency together. So because the TSC isn't stable, it's not 
a good time-source, but despite that it's not necessarily a bad way to 
compare events across cores.

To actually have different CPU's TSC drift wrt each other, you almost have 
to have them in different clock domains. And that is *very* rare. It 
happens when the CPU's are on different boards, and sure if happens if the 
CPU's have non-constant TSCs with different frequencies, but neither of 
those should be very common at all. The latter is uncommon because it's 
almost unheard of of having multi-socket devices with old CPU's that also 
do frequency changes.

Older multi-core CPU's tend to do frequency changes the whole chip at a 
time, and newer multi-core CPU's should all basically have a fixed TSC so 
even when they do frequency changes independently, the TSC should still be 
off the same clock on the die.

			Linus
