Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbYIBMQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbYIBMQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYIBMQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:16:18 -0400
Received: from www.tglx.de ([62.245.132.106]:32832 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYIBMQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:16:17 -0400
Date: Tue, 2 Sep 2008 14:15:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Linus Torvalds wrote:
> > 
> > Well, the biggest problem is actually _detection_.
> > 
> > We have three different timers, and they all have their own problems. How 
> > do you reliably detect which one to use? The PM_TIMER clearly is _not_ 
> > always the answer here, but the code just assumes it is!
> 
> On the machine you have trouble with the PIT on, does this thing trigger?
> 
> If it does, that could be a simple way to say whether you prefer PM_TIMER 
> over PIT.
> 
> For me, even on a modern machine, I get a pit_count of 46321, which 
> matches the "about one microsecond for an ISA/LPC read" timing pretty 
> well. What do you get? 

About anything between 0 and useful, but still I had cases where the
pit_count was way above the 25000 but the TSC was off by factor 2.

Went down the road and instrumented the code:

   unsinged long tsc_deltas[50000];

   start_pit();
   tsc1 = tsc = read_tsc_start();
   while (!pit_ready()) {
   	 tsc2 = read_tsc();
 	 tsc_deltas[pit_count++] = tsc2 - tsc;
	 tsc = tsc2;
   }

Analysing the tsc_deltas gave interesting insight. On the affected
laptop I had several entries where the delta between two reads was
from 1msec up to 120msec maximum. 

As the code does nothing else and has interrupts disabled there is
only one explanation: the SMM/SMI black hole.

If this high delta hits after the pit_count reached 25000 we still
believe that our calibration against pit is fine :(

So what I'm working on is an algorithm, which is similar to the checks
in the tsc_read_refs() function. That should allow us to detect
whether one of the reads is way off by doing a min/max detection. In
such a case we can either repeat the calibration or try to figure out
whether the pmtimer / hpet can provide us with some useful reference.

Thanks,

	tglx






