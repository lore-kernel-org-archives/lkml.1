Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYF1QxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYF1QxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYF1QxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:53:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3588 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753067AbYF1QxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:53:02 -0400
Date: Sat, 28 Jun 2008 12:53:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <48665B1A.8000004@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008, Stefan Becker wrote:

> Second try, slightly different tack: no dump_stack() in the _irq() 
> functions, but disabled/enabled indication. Plus debugging code added in 
> usb_hcd_add() to see the interrupt registration. Again too much data was 
> printed for the bug to appear.
> 
> Looking at the collected data it looks like
> 
>   - ehci_irq() is always entered with interrupts enabled (WRONG).
> 
>   - uhci_irq() is entered sometimes with either interrupts enabled 
> (WRONG) or disabled (OK).
> 
> But both interrupts are registered with IRQF_DISABLED...

It certainly looks like you've found a flaw in the core kernel.  Or 
else a subtle hardware flaw in your CPU...

Just to be certain, take out all your new code and instead add a simple 
test at the start of usb_hcd_irq() in hcd.c.  That routine is the 
registered handler for USB interrupts.  If interrupts are ever enabled 
at that spot, then something is badly wrong.

You might also keep track of the total number of each type of call, so
whenever you find interrupts are enabled, you can print out something
like this:

	usb_hcd_irq(): interrupts disabled %d, enabled %d

where the two values are the numbers of times the routine has been 
called with interrupts off or on, respectively.  You don't have to run 
this for a long time; since the test code should _never_ trigger, any 
output at all will indicate a real problem.

When you get that, change the Subject of your email to make it more 
noticeable.  A line like:

	BUG in 2.6.26-rc8 interrupt handling!

should draw people's attention.  :-)  Include a description of the 
problem and a copy of /proc/interrupts.

Alan Stern

