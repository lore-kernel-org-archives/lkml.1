Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYIBWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYIBWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYIBWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:22:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbYIBWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:22:24 -0400
Date: Tue, 2 Sep 2008 15:21:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809022239220.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809021446360.3160@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022239220.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> 
> On that box, the PIT is probably real hardware or a damned good
> emulation. When you look at the 10 loop values you see that it does
> 50% perfectly fine calibration loops. The others are just SMI
> interruptions caused by random unknown crap in the BIOS.

Ok, so I actually think I know how to resolve the problem once and for 
all.

The solution is actually fairly simple: we use the HPET algorithm. The 
reason the HPET algorithm is so robust is that

 - we can actually read the frequency from the HPET itself

 - we also simply just read the counter values from the HPET, and so it 
   doesn't really matter how much time has passed between the two reads, 
   it only matters that _some_ time has passed, and that we pick _one_ 
   stable read that we can associate with a TSC value.

But the thing is, the exact same thing is actually true of the old PIT 
timer too - except we simply don't take advantage of it. The PIT timer has 
a very well known frequency value (PIT_TICK_RATE: 1193180 Hz), and we can 
trivially read the counter value too.

But the thing is, that for some forgotten reason, that's not actually what 
we do. Instead of reading the counter value, we wait until it counts down 
to zero, and read the output value instead. So instead of having a nice 
and dependable counter that ticks down (16 bits of precision), we actually 
use a _single_ bit of result, and depend on reading the TSC at the same 
time.

That's kind of sad. 

I'll try to whip up a test-patch to do this in a smarter way.

		Linus
