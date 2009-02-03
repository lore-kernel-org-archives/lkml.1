Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZBCXGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZBCXGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZBCXGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:06:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:51649 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBCXGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:06:37 -0500
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902032344.22348.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop>
	 <200902032344.22348.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 10:05:27 +1100
Message-Id: <1233702327.16867.109.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (Newer) ACPI says that devices should be put into low power states (presumably
> with the help of appropriate ACPI AML routines) before the _PTS method is
> called.  In turn, we're supposed to disable nonboot CPUs after calling _PTS.
> There is analogous requirement for the _WAK method during resume.
> 
> Currently, the suspend code ordering follows these rules, but if we move
> the putting of devices into low power states into the suspend_late part, they
> will have to be done after _PTS and that is likely to break things (we've
> already had this problem once and I have really bad memories related to it).

Wait wait wait ... the -whole- point of the exercise, wether using
local_irq_save or disable_irq, -is- to put the ACPI bit -after- setting
the device in low power state and before the restore on wakeup...

So basically, that isn't changing.

The -one- thing that indeed conflicts here is that we disable nonboot
CPUs earlier. Right ?

Now, I doubt that would be a big issue, ie, we are supposedly capable of
dynamically disabling/enabling CPUs anyway, but if it is, then indeed I
see how the using of higher level PIC irq disabling would allow to move
the whole suspend_late() over to before disabling non-boot CPUs.

That does introduce a significant change in semantics for drivers in the
sense that now, suspend_late will be called with timers running, things
scheduling, requests coming in, etc... One of the big reasons for doing
suspend_late with IRQs off was precisely that drivers wouldn't have to
synchronize with all these things. They now do.

Thus I tend to think that keeping the disabling of nonboot CPUs earlier
than the suspending of devices is the least of two evils. _BUT_ As I
said, I'm no ACPI expert and not -that- familiar with x86 land, it might
indeed be a can of worms.

Cheers,
Ben.


