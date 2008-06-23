Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYFWSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYFWSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYFWSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:10:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37998 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754847AbYFWSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:10:14 -0400
Date: Mon, 23 Jun 2008 14:10:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <485FC6C7.5030001@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806231403350.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Stefan Becker wrote:

> >>> I get random machine lockups when accessing my USB harddrive with 
> >>> kernels 2.6.24/25. They don't occur with kernel 2.6.23. During testing I 
> >>> figured out that it has something to do with the USB Bluetooth adaptor. 
> >>> If I remove it before the testing I don't get any lockups.
> > 
> > Does the same problem still occur in 2.6.26-rc7?
> 
> Yes.
> 
> 
> >  Does it occur if you rmmod ehci-hcd?
> 
> Yes, i.e. it also happens when the external hardrive runs as USB 1.1 
> device with 12mpbs.
> 
> 
> > Machine lockups are awfully hard to debug.  Can you get any information
> > at all (like Alt-SysRq-T) when this happens?
> 
> SysRq does not work when the machine locks up. I forgot to mention that 
> the test machine is a single CPU machine and that the CPU fan starts to 
> run full speed when the lockup occurs.
> 
> Guessing from the commit returned by git bisect there is a locking 
> error, i.e. the CPU runs into a spinlock that is already locked and 
> therefore busy loops.

That is certainly possible.  But an error like that should affect lots 
of different people and computers, not just your one machine.

> > Can you add debugging
> > printk statements to the USB bluetooth driver to try and localize where
> > the hang occurs?
> 
> Any suggestions where to start?

Around every place where the driver calls into the core.  You might 
also want to debug the places where uhci-hcd acquires and releases 
spinlocks.

> >>> git bisect resulted in the following bad commit:
> >>>
> >>> e9df41c5c5899259541dc928872cad4d07b82076 is first bad commit
> >>> commit e9df41c5c5899259541dc928872cad4d07b82076
> >>> Author: Alan Stern <stern@rowland.harvard.edu>
> >>> Date:   Wed Aug 8 11:48:02 2007 -0400
> >>>
> >>>     USB: make HCDs responsible for managing endpoint queues
> > 
> > Knowing this doesn't help much without more information.
> 
> Too bad. Each bisect cycle took 2-3 hours and the whole process took me 
> 3 days :-( :-(

I didn't mean that your efforts were wasted.  They just don't help much 
at this point; maybe later on they will be more useful.

> That commit has spinlock changes so I hoped that it would be a good 
> starting point. Is there a way to track the locks?

Only what I suggested: Print something in the log whenever a lock is 
acquired or released.

> > Do you have any idea why nobody else has reported this sort of problem?  
> > Is it reproducible on other machines?
> 
> I attached both USB devices to another, newer dual core laptop. I 
> couldn't reproduce the problem there, even when I simulated a single CPU 
> machine with maxcpus=1.

Alan Stern

