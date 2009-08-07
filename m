Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZHGQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZHGQpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZHGQpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:45:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52665 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754066AbZHGQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:45:38 -0400
Date: Fri, 7 Aug 2009 12:45:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
In-Reply-To: <1249661754.32113.747.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0908071241170.4758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Peter Zijlstra wrote:

> > I think they are, pretty much.  The real problem, of course, is that 
> > lockdep doesn't understand tree-structured lock orderings.  Hence it 
> > isn't practical to convert dev->sem into a mutex.
> 
> Right, well it would if we'd make every instance a class, but since
> classes should reside in static storage this is far from trivial.
> 
> If we'd be able to find a mapping such that we can use a limited number
> of these classes to represent the needed structure then we're good.
> 
> I think I proposed adding a class to each driver or something, but then
> you countered that a single driver could register itself at conflicting
> places in the device tree.

Also there can be devices in the tree that don't have any driver.  And 
there can be devices that have the same driver as their children.

> Still it might be worth to try that and see where we'll end up and
> possibly fix up a few drivers to be more intelligent.
> 
> /me ponders
> 
> Nested busses would be interesting though, suppose we assign a class to
> a USB bus driver, and we chain USB hubs, you'd get a nesting of similar
> classes and that'd upset lockdep again :/

Yep.

> The other proposal was creating a fixed list of classes and register
> each device at a class corresponding to its depth in the tree. I can't
> remember what was wrong with that, but I seem to have been persuaded
> that that was hard too.

It probably would work for the most part.  However a possible scenario
involves first locking a parent and then locking all its children.  (I
don't know if this ever happens anywhere, but it might.)  This can't
cause a deadlock but it would run into trouble with depth-based
classes.

Alan Stern

