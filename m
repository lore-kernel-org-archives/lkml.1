Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYIDFKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYIDFKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYIDFKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:10:17 -0400
Received: from 1wt.eu ([62.212.114.60]:3178 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYIDFKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:10:16 -0400
Date: Thu, 4 Sep 2008 07:09:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
Message-ID: <20080904050929.GA1678@1wt.eu>
References: <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de> <1220490884.22734.83.camel@alok-dev1> <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org> <20080903201602.2ab6c449@infradead.org> <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org> <20080904042542.GH19337@1wt.eu> <alpine.LFD.1.10.0809032141160.3378@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809032141160.3378@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:53:35PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 4 Sep 2008, Willy Tarreau wrote:
> >
> > Basically, I would do this :
> > 
> >     pit1 = readpit();
> >     while (readpit() == pit1);
> >     t1 = rdtsc(); // precise beginning of tick 0
> >     while (readpit() != pit1 - 5000);
> >     t2 = rdtsc(); // precise beginning of tick 5000
> 
> There's a few caveats here:
> 
>  - the "readpit()" has to read without actually latching the value
> 
>    latching the PIT value will stop counting.
> 
>  - and all the docs say that you have to be careful about reading the PIT 
>    without latching it because the two 8-bit accesses aren't atomic.

Ah yes you're right, I remember having been doing crappy stuff like re-reading
and checking for difference bigger than 1.

> so the above will work in practice, but there are dangers.
> 
> The best way to fix most of the dangers is probably to only care about the 
> *high* byte, so that it doesn't matter if the low byte doesn't match the 
> high byte.
> 
> So you could probably change your version to wait for 4096 cycles (a 
> change of 16 in the high byte):
> 
> 	static unsigned char read_pit_msb(void)
> 	{
> 		/* Read but throw away the LSB */
> 		inb(0x42);
> 		return inb(0x42);
> 	}
> 
> 	..
> 	/* PIT ch2: square wave, full 16-bit count */
> 	outb(0xb6, 0x43);
> 	outb(0, 0x42);
> 	outb(0, 0x42);
> 	..
> 
> 	unsigned char pit = read_pit_msb();
> 	/* Wait until the MSB changes */
> 	while (read_pit_msb() == pit1);
> 	t1 = rdtsc();
> 	while ((unsigned char) (pit - read_pit_msb()) < 9);
> 	t2 = rdtsc();
> 
> and it might work out ok without explicit latching, and without having to 
> worry about low/high bytes being out of sync.

I like this variation.

> > If someone wants to test this, I'd be interested in the number of
> > ticks required to get a good accuracy, I bet that even with a few
> > hundred ones it's already precise by a few ppm (about the precision
> > of the input clock in fact).
> 
> I actually tested a patch with a counter value of just 1024, and I got the 
> right answer. 
> 
> But if the busy loops aren't busy (due to MSI or virtualization), then all 
> those things fly out the window.

100% agreed, though the problem is already the same with any calibration code,
with more or less sensitivity.

Willy

