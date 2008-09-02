Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYIBPKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYIBPKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYIBPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:10:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYIBPKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:10:24 -0400
Date: Tue, 2 Sep 2008 08:09:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> 
> Analysing the tsc_deltas gave interesting insight. On the affected
> laptop I had several entries where the delta between two reads was
> from 1msec up to 120msec maximum. 

Ok, that sounds like a good approach to find if it's done by some 
kind of emulation or not. Of course, any machine with SMM (even if it 
doesn't emulate the PIT per se - maybe it just gets some event related to 
overheating or other 'maintenance' stuff) can have occasional hickups, but 
the '120msec' thing is, I think, the real clincher. 

Why? Because we only try to wait for 50ms in the first place! Even if 
emulation is 100% exact (or even none at all, and the PIT accesses are in 
hardware), if we have a 120ms hickup while waiting for 50ms, then the end 
result will obviously be total crap, and yes, that sure explains how you 
can get >100% wrong values.

> So what I'm working on is an algorithm, which is similar to the checks
> in the tsc_read_refs() function. That should allow us to detect
> whether one of the reads is way off by doing a min/max detection. In
> such a case we can either repeat the calibration or try to figure out
> whether the pmtimer / hpet can provide us with some useful reference.

I think the most trivial approach would be to

 - just keep track of the max TSC difference for each loop iteration.

 - if the max TSC is bigger than 1% of the total TSC, then something is 
   already seriously wrong (either we had very few loops indeed, or some 
   of them were very expensive)

 - perhaps loop over the calibration, and make the TSC calibration loop 
   increase the delay. Because even if there is a 120ms hickup, if we had 
   used a longer calibration delay, we'd probably not have noticed (well, 
   ok, 120ms is pretty damning and is probably just unfixable, but smaller 
   hickups are probably harmless)

Additionally doing a min/max comparison to see that the loop is very 
_stable_ is of course also a way to validate things, but expecting _too_ 
much stability may be wrong too. As mentioned, SMM events can happen for 
other reasons than emulation.

		Linus
