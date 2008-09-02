Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYIBSoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYIBSoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYIBSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:44:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYIBSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:44:03 -0400
Date: Tue, 2 Sep 2008 11:42:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> 
> Yeah, I know. One of the oddballs is the USB->PS2 keyboard emulator
> which is active during early boot. We do the USB handoff definitely
> after the TSC calibration. Found a box with similar (not that bad)
> hickups which go away when I disable that in the BIOS settings. 
> 
> Can't say anything about the laptop in that regard, because the BIOS
> does not offer me a switch for that :(

Dang. 

We actually _used_ to do this fairly early for UHCI, since it was simple 
and very useful to do, and not doing it caused serious problems with the 
USB stack.

But then it got moved to the USB stack itself, and for some reason the 
DECLARE_PCI_FIXUP_HEADER got turned into a DECLARE_PCI_FIXUP_FINAL instead 
(probably because the USB layer expected things to be fairly set up), 
which means that it now happens much much later.

But I guess even DECLARE_PCI_FIXUP_HEADER was is too late for TSC, so it 
doesn't much matter. Even with the old setup, it would be too late.

You're definitely right that this could easily be the _real_ problem. 
Especially as your TSC min value of 2160 is (a) pretty close to the 
expected time of a microsecond and (b) so stable that I actually do not 
believe that the PIT itself is at all emulated or the problem.

Btw - as to caring about the average value: that's pointless. If you only 
look at the average time the PIT read takes place, then it is going to 
approximate that "pit_count" thing in the end that I already did. 

Why? Because the average value should essentially end up being "(end_tsc - 
start_tsc) / pit_count". And if you just compare that to "min_tsc", then 
that should always be about a microsecond (on normal machines where the 
PIT is essentially on the old emulated internal "ISA" bus on the 
southbridge). So you end up with what I already posted, and you already 
dismissed.

So average TSC is not any more interesting than "pit_count". 

			Linus
