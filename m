Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbYBUQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbYBUQPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYBUQPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:15:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752263AbYBUQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:15:21 -0500
Date: Thu, 21 Feb 2008 11:15:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <200802201454.52125.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0802211057440.4528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, David Brownell wrote:

> > 	CPU 0				CPU 1
> > 	-----				-----
> > 	Watchdog timer expires
> > 	Timer routine acquires spinlock
> > 					IAA IRQ arrives
> > 					ehci_irq tries to acquire 
> > 						spinlock...

The following comment refers to the "Timer routine either sets" below, 
right?

> There's another condition here, and
> another action.  The condition is
> that ehci->reclaim must first be set;
> the action is to clear STS_IAA (and,
> given the previous patch, maybe IAAD).
> 
> And this "either" is more concisely
> written as "call end_unlink_async()"
> (point made just for clarity).

Correct on both counts.  I had forgotten that the watchdog routine 
clears STS_IAA.

> > 	Timer routine either sets
> > 		ehci->reclaim to NULL 
> > 		or else starts a new
> > 		IAA cycle
> > 	Timer routine releases spinlock
> > 		and returns
> > 					ehci_irq acquires spinlock
> > 						and sees IAA is set
> 
> 					Can only happen if a new IAA
> 					cycle was started by CPU0, and
> 					the IAA condition triggered
> 					that quickly.
> 
> > 					Call end_unlink_async()!

Okay, so this isn't as bad as it seemed.  I don't have a copy of your 
most recent patch, but it seems clear that the watchdog routine must:

	First remove the circumstances that would cause the controller 
	to set IAA.  I guess that means clearing IAAD; it's not
	entirely clear from the spec whether this will do what we 
	want.

	Then clear IAA (if it happens to be set).

This is the only way to avoid the race, and I know that my original
version of the routine does these steps in the wrong order (if at all).  
That should be fixed.  Given sufficiently bizarre hardware we can't be
certain that things won't still go wrong on occasion, but this is the
best we can do for now -- weird hardware can be handled as it arises.

The other change to make (which you have already anticipated) is to 
guard against ehci->reclaim == NULL in end_unlink_async().  There's no 
real need for a warning or stack dump; it should just return silently 
when this happens.  If there is a warning, maybe it should be placed at 
the site of the caller (for example, in ehci_irq() when STS_IAA is 
detected).

Alan Stern

