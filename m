Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZBCX0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZBCX0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZBCXZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:25:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZBCXZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:25:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Wed, 4 Feb 2009 00:25:27 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop>
In-Reply-To: <1233702327.16867.109.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040025.28254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Benjamin Herrenschmidt wrote:
> 
> > (Newer) ACPI says that devices should be put into low power states (presumably
> > with the help of appropriate ACPI AML routines) before the _PTS method is
> > called.  In turn, we're supposed to disable nonboot CPUs after calling _PTS.
> > There is analogous requirement for the _WAK method during resume.
> > 
> > Currently, the suspend code ordering follows these rules, but if we move
> > the putting of devices into low power states into the suspend_late part, they
> > will have to be done after _PTS and that is likely to break things (we've
> > already had this problem once and I have really bad memories related to it).
> 
> Wait wait wait ... the -whole- point of the exercise, wether using
> local_irq_save or disable_irq, -is- to put the ACPI bit -after- setting
> the device in low power state and before the restore on wakeup...
> 
> So basically, that isn't changing.
> 
> The -one- thing that indeed conflicts here is that we disable nonboot
> CPUs earlier. Right ?
> 
> Now, I doubt that would be a big issue, ie, we are supposedly capable of
> dynamically disabling/enabling CPUs anyway, but if it is, then indeed I
> see how the using of higher level PIC irq disabling would allow to move
> the whole suspend_late() over to before disabling non-boot CPUs.
> 
> That does introduce a significant change in semantics for drivers in the
> sense that now, suspend_late will be called with timers running, things
> scheduling, requests coming in, etc... One of the big reasons for doing
> suspend_late with IRQs off was precisely that drivers wouldn't have to
> synchronize with all these things. They now do.

I realize the problem, but IMO only a few drivers will be affected, since only
a few of them implement suspend_late/resume_early.

> Thus I tend to think that keeping the disabling of nonboot CPUs earlier
> than the suspending of devices is the least of two evils. _BUT_ As I
> said, I'm no ACPI expert and not -that- familiar with x86 land, it might
> indeed be a can of worms.

It is. :-)

Thanks,
Rafael
