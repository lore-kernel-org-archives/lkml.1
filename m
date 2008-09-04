Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbYIDEUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbYIDEUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYIDEUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYIDEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:20:44 -0400
Date: Wed, 3 Sep 2008 21:20:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <20080903211029.187d8dab@infradead.org>
Message-ID: <alpine.LFD.1.10.0809032112400.3378@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de> <1220490884.22734.83.camel@alok-dev1>
 <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org> <20080903201602.2ab6c449@infradead.org> <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org> <20080903211029.187d8dab@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Arjan van de Ven wrote:
>
> On Wed, 3 Sep 2008 20:59:05 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > The only frequency we can trust on 99% of all machines is the PIT,
> 
> pmtimer is also quite ok, with the exception of some K6 based boxes.
> (I'm surprised the K6 boxes even have enough modern stuff to have
> pmtimer; I'd think they would fall under the date cutoff)

Quite frankly, pmtimer isn't all that much better than PIT. It has a 
slightly bigger range, but it has a much more limited format, and it 
doesn't have a reliable frequency. It was designed for something else.

At least HPET is clearly better than PIT as a _timer_.

All the big HPET problems are with its idiotic interface. 

Of course, in any _sane_ situation, the timer really would have been in 
the local APIC instead, with a fixed and architected frequency, and it 
should run in all power states. But noo, that obviously won't ever work, 
because that would have been _sensible_.

> one of the options we have is to start with an initial
> rough-but-conservative estimate, and refine it over time as the system
> is running.... sort of like ntp but for the calibration.

I do agree that we could aim for something like that. But even to get the 
rough estimate, we'd probably have to do the 5ms thing.

> another option for calibrating the tsc rate is to read it from the
> msr's/cpuid/aperf of what the hardware says it should be, and then all
> we need is to verify it is that; that we could do over timer or quickly.
> (of course that only works for systems with constant tsc)

I don't think it's reliable even for systems with a constant TSC. Because 
the msr/cpuid thing isn't going to actualyl give the right frequency. It 
might be the frequency the thing is _rated_ at, but it will be off when 
people over- or under-clock the front-side bus etc.

This is why it's so important that the clock input be a _known_ frequency. 
The thing that makes the PIT still so useful is not that it's a good 
timer, but that we *know* the frequency it runs at.

			Linus
