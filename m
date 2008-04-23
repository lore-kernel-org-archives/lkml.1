Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYDWO5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYDWO5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYDWO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:56:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52559 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750832AbYDWO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:56:56 -0400
Date: Wed, 23 Apr 2008 10:56:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, <paulmck@linux.vnet.ibm.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <herbert@gondor.apana.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: device_pm_add (was: Re: 2.6.25-git2: BUG: unable to handle kernel
 paging request at ffffffffffffffff)
In-Reply-To: <200804230250.26159.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0804231047500.2104-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Rafael J. Wysocki wrote:

> > > Are drivers supposed to register children of suspended devices?  That doesn't
> > > make much sense IMO ...
> > 
> > Well, that's why I think the warning itself makes sense - and then we can 
> > decide whether it makes sense for that particular case or not. Clearly it 
> > happens (since it triggered), now we need to figure out _why_ it happened. 
> 
> Well, this particular case looks like a race to me.

I think the reason it happened is clear enough.  Call it a race if you 
want, but the window is so large that it hardly qualifies.

It's a result of the way the MMC core is written.  There's an
upper-level controller device, and below that is a host device, and
below that is the card itself.  The code that adds and removes children
of the host device runs as part of the controller driver.

Hence the problem: The driver adds children below the _host_ as soon as 
the _controller_ is resumed, even though the host is still suspended.  
It's not as big an error as it sounds -- the host was originally a 
class_device and then got converted over to a regular device.  It 
doesn't have a driver of its own.

This is one of the things that needs to be fixed up as part of the 
reworking of the system-sleep API.  I simply haven't had any time to 
work on it (and I'm not likely to in the near future).

You ought to be able to provoke this more or less at will, depending on
the order in which your PCI devices are probed, by inserting or
removing an MMC card during the disk spin-up interval while the system
is waking up.

Alan Stern

