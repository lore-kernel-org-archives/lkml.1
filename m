Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZHGQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZHGQQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZHGQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:16:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZHGQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:16:38 -0400
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <Pine.LNX.4.44L0.0908071154530.3063-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908071154530.3063-100000@iolanthe.rowland.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Aug 2009 18:15:54 +0200
Message-Id: <1249661754.32113.747.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 12:04 -0400, Alan Stern wrote:
> On Fri, 7 Aug 2009, Peter Zijlstra wrote:
> 
> > On Fri, 2009-08-07 at 09:46 -0500, Clark Williams wrote:
> > > Peter,
> > > 
> > > I'm getting this warning from lockdep when booting on my T60. 
> > > 
> > > The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
> > > actually bracket one call to mutex_lock() in driver_attach() so I'm not
> > > sure what the complaint is.
> 
> > Oh, that's tglx who's gone wild with sem->mutex conversions.
> 
> Is this code available somewhere?

Its in the -rt tree, but this patch was posted to lkml at:
  http://lkml.org/lkml/2009/7/26/36

The -rt tree can be found in various places, but while tglx is out
celebrating his holidays the latest can be found through:
  http://lkml.org/lkml/2009/8/5/406

> > It used to be that _all_ dev->sem instances were taken on suspend or
> > something like that, I think that got fixed a long while back.
> > 
> > I'd have to look at what the current locking requirements for dev->sem
> > are. 
> 
> It is supposed to be locked whenever the driver core invokes a probe, 
> remove, or PM-related callback.  Under some circumstances, the parent's 
> semaphore is supposed to be locked as well.  Individual subsystems may 
> have their own requirements in addition to these.
> 
> The ordering requirement is: Don't try to acquire a device's lock if
> you already hold the lock for a non-ancestor device.  More generally
> (if more obscurely): If you already hold device A's lock, then don't
> try to acquire the lock for device B unless you already hold the lock
> for A & B's most recent common ancestor.
> 
> > I remember talking to Alan on several occasions about this, and I just
> > went over some of the old emails, but I must say the precise
> > requirements stay hidden from me. Also, I'm not sure these emails are
> > still representative of the current state.
> 
> I think they are, pretty much.  The real problem, of course, is that 
> lockdep doesn't understand tree-structured lock orderings.  Hence it 
> isn't practical to convert dev->sem into a mutex.

Right, well it would if we'd make every instance a class, but since
classes should reside in static storage this is far from trivial.

If we'd be able to find a mapping such that we can use a limited number
of these classes to represent the needed structure then we're good.

I think I proposed adding a class to each driver or something, but then
you countered that a single driver could register itself at conflicting
places in the device tree.

Still it might be worth to try that and see where we'll end up and
possibly fix up a few drivers to be more intelligent.

/me ponders

Nested busses would be interesting though, suppose we assign a class to
a USB bus driver, and we chain USB hubs, you'd get a nesting of similar
classes and that'd upset lockdep again :/


The other proposal was creating a fixed list of classes and register
each device at a class corresponding to its depth in the tree. I can't
remember what was wrong with that, but I seem to have been persuaded
that that was hard too.


