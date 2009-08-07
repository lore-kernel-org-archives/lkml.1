Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZHGQEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZHGQEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZHGQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:04:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42203 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753652AbZHGQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:04:04 -0400
Date: Fri, 7 Aug 2009 12:04:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
In-Reply-To: <1249657743.32113.733.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0908071154530.3063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Peter Zijlstra wrote:

> On Fri, 2009-08-07 at 09:46 -0500, Clark Williams wrote:
> > Peter,
> > 
> > I'm getting this warning from lockdep when booting on my T60. 
> > 
> > The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
> > actually bracket one call to mutex_lock() in driver_attach() so I'm not
> > sure what the complaint is.

> Oh, that's tglx who's gone wild with sem->mutex conversions.

Is this code available somewhere?

> It used to be that _all_ dev->sem instances were taken on suspend or
> something like that, I think that got fixed a long while back.
> 
> I'd have to look at what the current locking requirements for dev->sem
> are. 

It is supposed to be locked whenever the driver core invokes a probe, 
remove, or PM-related callback.  Under some circumstances, the parent's 
semaphore is supposed to be locked as well.  Individual subsystems may 
have their own requirements in addition to these.

The ordering requirement is: Don't try to acquire a device's lock if
you already hold the lock for a non-ancestor device.  More generally
(if more obscurely): If you already hold device A's lock, then don't
try to acquire the lock for device B unless you already hold the lock
for A & B's most recent common ancestor.

> I remember talking to Alan on several occasions about this, and I just
> went over some of the old emails, but I must say the precise
> requirements stay hidden from me. Also, I'm not sure these emails are
> still representative of the current state.

I think they are, pretty much.  The real problem, of course, is that 
lockdep doesn't understand tree-structured lock orderings.  Hence it 
isn't practical to convert dev->sem into a mutex.

Alan Stern

