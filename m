Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZCHUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZCHUk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZCHUkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 16:40:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54823 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753126AbZCHUkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 16:40:19 -0400
Date: Sun, 8 Mar 2009 16:40:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?ISO-8859-15?Q?Arve__Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <alpine.LFD.2.00.0903081014430.19207@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0903081629010.9313-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Mar 2009, Linus Torvalds wrote:

> On Sat, 7 Mar 2009, Alan Stern wrote:
> > 
> > You didn't answer my question.  Why bother to distinguish between 
> > "wake-up" interrupts and non-"wake-up" interrupts?
> > 
> > In other words, why not simply abort the suspend if IRQ_PENDING is set
> > for _any_ interrupt during sysdev_suspend()?
> 
> .. because some drivers might not actually shut down the hardware until 
> they get to "suspend_late"? If even then, for that matter - a driver may 
> simply not care, knowing that the hardware will be powered off, and will 
> be re-initialized at resume.
> 
> The thinking that you have to shut your hardware down at "->suspend()" 
> time is a _disease_. There are literally classes of hardware out there 
> where that would be an outright _bug_, like for a PCI bridge device. For 
> many devices, "suspend()" has to be the phase where you shut down the 
> _external_ stuff (eg for a disk controller, it's when you'd flush and stop 
> your disks), but the controller itself may well be alive until later.

Yes, certainly.  I agree completely.

But there is a difference between shutting down the hardware and merely
preventing it from generating interrupt requests.  If a device remains
capable of generating IRQs after its driver's suspend method has run,
the driver runs the risk of having its handler called at a time when it
isn't prepared to cope correctly.  Of course, this will depend on the
details of how the driver is written.

There have been examples in the past of devices that, for one reason or
another, _did_ generate IRQs at inconvenient times.  The hardware or
the BIOS may have done improper initialization, for example.  On a
shared IRQ this led to interrupt storms.  IIRC, the solution was to add
a PCI quirk routine to disable IRQ generation at an early stage.  
Didn't e100 have this problem?

Alan Stern

