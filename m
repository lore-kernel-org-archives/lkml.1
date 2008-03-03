Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbYCCVNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbYCCVNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760960AbYCCVMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:12:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38214 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760647AbYCCVMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:12:45 -0500
Date: Mon, 3 Mar 2008 13:12:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Message-ID: <20080303211241.GG12453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080225090316.GA420@elf.ucw.cz> <20080303154831.22a4eb14@core> <20080303172410.GA13869@elf.ucw.cz> <200803032127.30761.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803032127.30761.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 09:27:29PM +0100, Rafael J. Wysocki wrote:
> On Monday, 3 of March 2008, Pavel Machek wrote:
> > Hi!
> > 
> > > > Ok, so linux actually atomicity of long?
> >                          ^~-- assumes should be here.
> > 
> > > No it doesn't. And even if it did you couldn't use long for this because
> > > atomic_t also ensures the points operations complete are defined. You
> > > might just about get away with volatile long * objects on x86 for simple
> > > assignments but for anything else gcc can and will generate code to
> > > update values whichever way it feels best - which includes turning
> > > 
> > > 	long *x = a + b;
> > > 
> > > into
> > > 
> > > 	*x = a;
> > > 	*x += b;
> > 
> > Ok, I can understand the gcc side. But do we actually run on an
> > architecture where
> > 
> > long *x;
> > 
> > *x = 0;
> > 
> > racing with 
> > 
> > *x = 0x12345678;
> > 
> > can produce
> > 
> > *x == 0x12340000;
> > 
> > or something like that?
> 
> Well something like this could happen, in theory, on a "32-bit" architecture
> with a 16-bit bus.  In that case, one can imagine, the first word of the
> first write may be sent through the bus immediately followed by the first
> word of the second write, followed by the second word of the second
> write and by the second word of the first write, in this order.
> 
> > I'm told RCU relies on architectures not doing this, and I'd like to get this
> > clarified.
> 
> Yes, it would be good to know that for sure.

Most rcu_assign_pointer() calls are protected by locks, but there might
be a few that are not.  However, the case that concerns me most would be
the following:

o	Task 0 writes the lower 16 bits of the pointer.

o	Task 1 reads the lower 16 bits of the pointer.

o	Task 1 reads the upper 16 bits of the pointer.

o	Task 0 writes the upper 16 bits of the pointer.

This would result in task 1 getting a mish-mash of the old and new
versions of the pointer.  Very bad!!!  RCU heavily relies on the reader
seeing either the initial value of the pointer or on the value written
by some single write.

But doesn't this require a -multi-CPU- system with a 16-bit data path
from the ALU to the L0 cache?  This seems a bit unlikely.  Or am I being
naive about embedded CPUs?

On the other hand, if you have a 32-bit single-CPU system with a 16-bit
path to memory, all we need is that interrupts be restricted to happening
at instruction boundaries rather than in the middle of instructions.

							Thanx, Paul
