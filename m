Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZBBWcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZBBWcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZBBWcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:32:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35546 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZBBWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:32:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Mon, 2 Feb 2009 23:31:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902022239.02453.rjw@sisk.pl> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022331.49131.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > Yes, which is why I thought it might be a good idea to make the AML interpreter
> > allow is to execute AML with interrupts off, so that we can put devices into
> > low power states and/or put them into D0 with interrupts off.
> > 
> > Then, we'll be able to make ACPI happy (up to some strange ordering
> > expectations of some insane BIOSes maybe) and fix the interrupts issue at
> > the same time.
> > 
> > The idea would be to have a special code path(s) where AML can be executed
> > with interrupts off and a couple of special entry points into the AML
> > interpreter for this purpose.
> 
> Well, I don't think anybody wants to (or necessarily has the ability) 
> touch ACPI internals.

That need not be very difficult AFAICS.

> How about this kind of approach:
> 
>  - step#1: split "sysdev" device suspend/resume from the general 
>    "device_power_on/off()" step
> 
>    Rationale: sysdev's include things like the actual interrupt controller 
>    etc, and we almost certainly really do want to have hard interrupts 
>    disabled over that whole thing. 

Fine by me.

>    I'm appending a suggested trivial patch for this.

Looks correct.

>  - step#2: make suspend/resume actually do the three phases:
> 
> 	a) existing device->suspend() (interrupts on, everything live)
> 
> 	b) disable_device_irq()'s: things are live, but device interrupts 
> 	   are turned off by essentially looping over the irq_desc_ptr[] 
> 	   table. 

Well, do we actually need to turn off all device interrupts?

Shared interrupts are the source of the problem, so perhaps we can
only disable interrupts of devices that use interrupt pins at this point
(MSI/MSI-X need not be disabled, for example, and the timer interrupts most
probably too)?

> 	c) existing device->suspend_late(). System is kind of live, but 
> 	   all interrupts have been shut off at the source. But we really 
> 	   could try to keep timers etc alive.
> 
> 	d) disable CPU interrupts.

At what point do we disable the other CPUs?

> 	e) sysdev_suspend(). This turns off the interrupt controller etc
> 
> 	*suspend cpu*
> 
>    and then do the resume in reverse order.
> 
> The reason step#1 is needed is just because we have that irq handling 
> difference between the two. And if timers are running, we really can 
> pretty much run all normal code (turning timers off does hurt anything 
> that uses timeouts like msleep() or schedule_timeout()). Otherwise step#1 
> isn't important in itself.
> 
> Hmm? It doesn't look too painful,

Well, it means reworking the entire suspend sequence (again) or we will
break assumptions made by some existing drivers (interrupts off during
suspend_late and resume_early).  And that affects all drivers, not only PCI.

> and it would mean that we could go back to a perfectly regular
> pci_set_power_state() in the early-resume codepath.

I first would like to understand what _exactly_ breaks on the iBook reported to
have problems.

Thanks,
Rafael
