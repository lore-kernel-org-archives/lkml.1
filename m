Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZCIPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZCIPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZCIPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:00:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZCIPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:00:58 -0400
Date: Mon, 9 Mar 2009 07:59:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
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
In-Reply-To: <Pine.LNX.4.44L0.0903081629010.9313-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.0903090748350.19207@localhost.localdomain>
References: <Pine.LNX.4.44L0.0903081629010.9313-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Mar 2009, Alan Stern wrote:
> 
> There have been examples in the past of devices that, for one reason or
> another, _did_ generate IRQs at inconvenient times.  The hardware or
> the BIOS may have done improper initialization, for example.  On a
> shared IRQ this led to interrupt storms.  IIRC, the solution was to add
> a PCI quirk routine to disable IRQ generation at an early stage.  
> Didn't e100 have this problem?

.. and this is exactly the reason why we've done all these changes.

There are tons of drivers that are unable to cope with interrupts that 
happen after they've done their "pci_set_power_state(PCI_D3hot)".

With shared interrupts (and _another_ device still live), they do stupid 
things like read the interrupt status register, getting all-ones (because 
the device is dead), and then deciding that that means that that need to 
handle the interrupt. And that goes on in a loop. Forever.

Or they do _that_ part right, but their suspend also free'd some data 
structure, so now the interrupt handler will follow a NULL pointer and/or 
scribble to freed memory. The source of bugs is infinite, and not fixable 
(because, quite frankly, most device driver writers are very focused on 
the hardware, and have a hard time thinking about it as part of the bigger 
system - and even if they happen test suspend/resume, they probably won't 
be testing it with shared interrupts, so it will work _for_them_ even if 
it's totally broken).

So what all the PCI changes try to do is to basically not have the driver 
do the "pci_set_power_state(PCI_D3)" at _all_, an do it in the PCI layer. 
But more importantly, it needs to be done _after_ interrupts have been 
disabled for this all to work. And, for exactly the same reason, the PCI 
layer needs to wake the device up and restore its config space _before_ 
enabling interrupts again, and _before_ doing any ->resume calls.

And that, in turn, means that since we have all these ACPI ordering 
things, and many cases want to use ACPI to wake things up, and/or have 
delays etc, we end up actually wanting things like timer interrupts 
working at that time - but not normal "device" interrupts. Because many 
delays do need them, even as simple delays as the (fairly short, but not 
"busy loop" short) one for turning the device back into PCI_D0 again.

So this literally explains all the re-ordering, and all the interrupt 
games we now play in Rafael's patch-set. The _whole_ (and only) point is 
to make it easier for device drivers, while also changing the environment 
so that we can call ACPI and we can sleep even before the devices have 
really resumed (or even early_resume'd).

			Linus
