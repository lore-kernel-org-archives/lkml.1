Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXHUFbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXHUFbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 01:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXHUFbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 01:31:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbXHUFbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 01:31:32 -0400
Date: Mon, 20 Aug 2007 22:31:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <200708202148.45575.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com> <200708202102.58508.david-b@pacbell.net>
 <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
 <200708202148.45575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, David Brownell wrote:

> On Monday 20 August 2007, Linus Torvalds wrote:
> > 
> > Fair enough. However, it still seems particularly idiotic to
> >  - penalize everybody
> >  - mix up two totally unrelated areas (cpufreq and USB) for a bug that is 
> >    extremely rare and could be handled differently.
> 
> Yes on #1, but on #2 ... frequency transitions are a common place
> for systems to want to hiccup.

I disagree - it's extremely rare. We've probably had more *software* 
problems with cpufreq than we've had real hardware problems (ie all the 
locking for cpufreq has been pretty painful).

It's also something that probably depends a lot on the particular CPU. 
Some CPU's have very short PLL relocking, and continue running while the 
voltage is changed. Others seem to stop for much longer times. This is not 
somethign that the USB layer should stick its fingers in - because quite 
frankly, it really doesn't have a clue.

> Maybe less so on PCs, but it's hard to say that re-clocking an I/O or 
> memory bus shouldn't affect the peripherals using it for "realtime" 
> (deadlines) I/O !!

Normally the memory bus isn't reclocked (it's *possible* to do, but it's 
complex and can be quite fragile). I think the issue was just that the CPU 
itself was reclocked, and had long latencies for probing the cache. Not 
unlike a sleep state: there can be long DMA latencies just from the CPU 
being in S1!

So adding this special case for CPU frequency is not at all unlike adding 
a special case saying that the CPU cannot go into "halt" state, because 
the DMA latency is too high.

Have we done that? Yes. We actually had a "no-hlt" kernel command line 
flag that literally disabled halting the CPU, because it apparently caused 
problems for some floppy disk setups (and yes, the main reasonable 
explanation was some bad DMA interaction, we never figured it out).

So it might be much better if we instead re-introduced that kind of "DMA 
latency requirement", and letting different subsystems react to that as 
they may.

It really can affect more than just cpufreq - I would not be in the 
*least* surprised if C3 latencies and other things can cause these things 
too! But even within cpufreq, it's quite likely to hit certain situations 
more than others.

(Of course, if C3 latencies are high on a MB that has known DMA latency 
issues, you'd hope that the BIOS has simply disabled C3 entirely in the 
ACPI tables)

> transitions if the Broadcom chipset (or maybe it's just specific
> boards?) finds itself in the awkward configuration ... penalizing
> only the people we know could have trouble.

Yes, that would be more acceptable, I think. 

It is also quite likely that this is not a generic cpufreq issue, but one 
that happens with just a certain class of CPU's - ie some particular CPU 
that is just slower than others at re-clocking.

Just disabling things blindly on cpufreq events, when what it actually 
wants to do is say "I need low DMA latency", and then the cpu-freq layer 
(which can know about these things) may decide internally that it knows 
that a particular setup is not able to have low-latency DMA durign 
frequency relocking.

On other - saner - CPU's, the frequency relock may take a fraction of the 
time, and the CPU is running perfectly the whole time - and it would _not_ 
be affected.

> > As far as I know, split transactions aren't required anyway, they are just 
> > a performance optimization.
> 
> Nope.  Linus, this is at least the second or third time you've
> been wrong -- sorry.  But I wish you were right, since they're
> such a PITA to cope with.  ;)
> 
> Split transactions are how the full and low speed devices bridge
> to high speed busses.  Think of the TT hub as a speed converter,
> buffering data and then retransmitting it at the other (slower or
> faster) speed.  Some systems don't even have a full/low speed host
> adapter ... they just have a high speed root hub and rely on some
> external TT hubs (maybe on a mainboard) to handle the rest.

Ok. But in the meantime, I really think we should just revert the code 
that causes a known regression.

Because, quite frankly, you may not like VIA, but in the bigger picture, 
VIA has been a hell of a lot better than Broadcom. 

		Linus
