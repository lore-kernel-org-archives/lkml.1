Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYBTWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYBTWdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYBTWdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:33:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967AbYBTWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:33:07 -0500
Date: Wed, 20 Feb 2008 17:33:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <200802201356.28723.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0802201725070.24070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, David Brownell wrote:

> On Wednesday 20 February 2008, Alan Stern wrote:
> > > ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
> > 
> > lines in the log brings up some ideas that have been percolating in my 
> > mind for a while.  They have to do with the possibility of a race 
> > between the watchdog routine and assertion of IAA.
> 
> The curious bit IMO being STS_INT (0001), which should also have
> triggered an IRQ.  Suggesting to me that the race might be lower
> level than that ... at the level of a conflict between the various
> mechanisms to ack irqs.

Maybe it did trigger an IRQ.  Inside the watchdog routine interrupts 
are disabled.

> > In fact, if the timing comes out just wrong then it's possible (on SMP
> > systems) for an IAA interrupt to arrive when the watchdog
> > routine has already started running.  Then end_unlink_async() might get 
> > called right at the start of a new IAA cycle, or when the reclaim list 
> > is empty.
> 
> The driver's spinlock should prevent that particular problem from
> appearing.

I don't think so:

	CPU 0				CPU 1
	-----				-----
	Watchdog timer expires
	Timer routine acquires spinlock
					IAA IRQ arrives
					ehci_irq tries to acquire 
						spinlock...
	Timer routine either sets
		ehci->reclaim to NULL 
		or else starts a new
		IAA cycle
	Timer routine releases spinlock
		and returns
					ehci_irq acquires spinlock
						and sees IAA is set
					Call end_unlink_async()!

> ========= CUT HERE
> Modify EHCI irq handling on the theory that at least some of the
> "lost" IRQs are caused by goofage between multiple lowlevel IRQ
> acking mechanisms:  try rescanning before we exit the handler, in
> case the EHCI-internal ack (by clearing the irq status) doesn't
> always suffice for IRQs triggered nearly back-to-back.

This might help, but it won't fix the race outlined above.

Alan Stern

