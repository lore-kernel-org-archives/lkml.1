Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbYFYSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbYFYSjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYFYSjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:39:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56839 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752226AbYFYSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:38:59 -0400
Date: Wed, 25 Jun 2008 14:38:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <486269AE.7050006@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806251408300.3394-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Stefan Becker wrote:

> Well, I guess I'm just lucky it didn't turn into a heisenbug with all 
> those printk's in the code :-)

Yes indeed.

> > The usage in usb_hcd_link_urb_to_ep() appears benign; the code doesn't 
> > do anything that might hang while holding the lock.  All it does is 
> > manipulate a linked list.
> 
> Unfortunately I could only run a small test today. I added some simple 
> debugging code for the spinlock usage in hcd.c (see attached diff) and I 
> get the following message at lockup (I tried it twice just to be sure):
> 
> HCD URB list locked by usb_hcd_link_urb_to_ep!
> 
> As far as I understand the matter this only can happen if 
> usb_hcd_link_urb_to_ep() gets interrupted while holding the spinlock. 
> But according to the contract at the header of the function it should be 
> called with interrupts disabled!

So it should.  Do you know how to test whether interrupts are enabled?  
There's a routine called raw_irqs_disabled() defined in 
include/asm/irqflags.h.  Stick it inside usb_hcd_link_urb_to_ep, and 
the first time it returns nonzero, do a dump_stack().

> I guess the obvious way forward from here is:
> 
>   - replace the spin_lock() in the function with the irqsave version
> 
>   - if that fixes the problem add debugging code to the function and 
> panic with a stack trace when the interrupts aren't disabled one entry 
> (don't know how to detect that yet, any suggestions?) That hopefully 
> identifies the culprit that calls the function with interrupts enabled.

That should do the trick.  Although it would be quicker just to make a
small change to your existing code: The first time the spin_trylock
fails, do a dump_stack().  You did say this is a UP system, right?  
(Because obviously on SMP systems, one expects spin_trylock to fail
from time to time.)

The only callers of usb_hcd_link_urb_to_ep are the host controller
drivers plus a couple of routines in hcd.c itself.  But all the
callers are in the scope of spin_lock_irqsave or spin_lock_irq!  So
maybe there's more going on here than meets the eye.

Alan Stern

