Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYDAUNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYDAUNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYDAUMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:12:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbYDAUMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:12:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Tue, 1 Apr 2008 22:12:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <200803292317.50218.rjw@sisk.pl> <200803312329.03455.rjw@sisk.pl> <1207037741.23143.81.camel@nigel-laptop>
In-Reply-To: <1207037741.23143.81.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804012212.48609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Nigel Cunningham wrote:
> Hi Rafael.

Hi,

> Please excuse me, but I'm going to ask the questions you get from
> someone who hasn't followed development to date, and is thus reading the
> explanation without prior knowledge. Hopefully that will be helpful when
> you come to finalising the commit message.
> 
> On Mon, 2008-03-31 at 23:29 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce 'struct pm_ops' and 'struct pm_ext_ops' representing
> > suspend and hibernation operations for bus types, device classes and
> > device types.
> 
> Does ..._ext_... mean extended? (external?) If 'extended' (or if not),
> does that imply that they're mutually exclusive alternatives for drivers
> to use?

'ext' means 'extended'.  The idea is that the 'extended' version will be used
by bus types / driver types that don't need to implement the _noirq callbacks.
Both the platform and PCI bus types generally allow drivers to use _noirq
callbacks, so they use 'struct pm_ext_ops', as well as their corresponding
driver types.

> > Modify the PM core to use 'struct pm_ops' and 'struct pm_ext_ops'
> > objects, if defined, instead of the ->suspend() and ->resume() or,
> > respectively, ->suspend_late() and ->resume_early() callbacks that
> > will be considered as legacy and gradually phased out.
> 
> 'Respectively' doesn't look like the right word to use, but I'm not sure
> I understand correctly what you're trying to say. The way it's written
> at the moment, it sounds to me like you're saying that suspend_late()
> and resume_early are deprecated, but you're modifying the PM core to use
> them.

Yes, the changelog is wrong, because I used a separate structure for the
_noirq callbacks and (quite blindly) change the name of the structure in the
changelog, instead of reworking it. 

> > Change the behavior of the PM core wrt the error codes returned by
> > device drivers' ->resume() callbacks.  Namely, if an error code
> > is returned by one of them, the device for which it's been returned
> > is regarded as "invalid" by the PM core which will refuse to handle
> > it from that point on (in particualr, suspend/hibernation will not
> > be started if there is an "invalid" device in the system).
> 
> s/﻿particualr,/particular

Yes, thanks.
 
> So drivers can never validly fail to resume. That sounds fair enough. If
> the hardware has gone away while in lower power mode (USB, say), should
> the driver then just printk an error and return success?

I think so.

IMO, an error code returned by a driver's ->resume() should mean "the device
hasn't resumed and is presumably dead".  Otherwise, ->resume() should return
success.

> > The main purpose of doing this is to separate suspend (aka S2RAM and
> > standby) callbacks from hibernation callbacks in such a way that the
> > new callbacks won't take arguments and the semantics of each of them
> > will be clearly specified.  This has been requested for multiple
> > times by many people, including Linus himself, and the reason is that
> > within the current scheme if ->resume() is called, for example, it's
> > difficult to say why it's been called (ie. is it a resume from RAM or
> > from hibernation or a suspend/hibernation failure etc.?).
> > 
> > The second purpose is to make the suspend/hibernation callbacks more
> > flexible so that device drivers can handle more than they can within
> > the current scheme.  For example, some drivers may need to prevent
> > new children of the device from being registered before their
> > ->suspend() callbacks are executed or they may want to carry out some
> > operations requiring the availability of some other devices, not
> > directly bound via the parent-child relationship, in order to prepare
> > for the execution of ->suspend(), etc.
> 
> Do these changes allow for other power state possibilities besides
> suspend to ram and hibernate (eg on other platforms)?

The other states fall into the "suspend" category.

> > Ultimately, we'd like to stop using the freezing of tasks for suspend
> > and therefore the drivers' suspend/hibernation code will have to take
> > care of the handling of the user space during suspend/hibernation.
> > That, in turn, would be difficult within the current scheme, without
> > the new ->prepare() and ->complete() callbacks.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> >  arch/x86/kernel/apm_32.c   |    4 
> >  drivers/base/power/main.c  |  706 ++++++++++++++++++++++++++++++++++-----------
> >  drivers/base/power/power.h |    2 
> >  drivers/base/power/trace.c |    4 
> >  include/linux/device.h     |    9 
> >  include/linux/pm.h         |  318 ++++++++++++++++++--
> >  kernel/power/disk.c        |   20 -
> >  kernel/power/main.c        |    6 
> >  8 files changed, 870 insertions(+), 199 deletions(-)
> > 
> > Index: linux-2.6/include/linux/pm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/pm.h
> > +++ linux-2.6/include/linux/pm.h
> > @@ -114,7 +114,9 @@ typedef struct pm_message {
> >  	int event;
> >  } pm_message_t;
> >  
> > -/*
> > +/**
> > + * struct pm_ops - device PM callbacks
> > + *
> >   * Several driver power state transitions are externally visible, affecting
> >   * the state of pending I/O queues and (for drivers that touch hardware)
> >   * interrupts, wakeups, DMA, and other hardware state.  There may also be
> > @@ -122,6 +124,288 @@ typedef struct pm_message {
> >   * to the rest of the driver stack (such as a driver that's ON gating off
> >   * clocks which are not in active use).
> >   *
> > + * The externally visible transitions are handled with the help of the following
> > + * callbacks included in this structure:
> > + *
> > + * @prepare: Prepare the device for the upcoming transition, but do NOT change
> > + *	its hardware state.  Prevent new children of the device from being
> > + *	registered after @prepare() returns (the driver's subsystem and
> > + *	generally the rest of the kernel is supposed to prevent new calls to the
> > + *	probe method from being made too once @prepare() has succeeded).  If
> > + *	@prepare() detects a situation it cannot handle (e.g. registration of a
> > + *	child already in progress), it may return -EAGAIN, so that the PM core
> > + *	can execute it once again (e.g. after the new child has been registered)
> > + *	to recover from the race condition.  This method is executed for all
> > + *	kinds of suspend transitions and is followed by one of the suspend
> > + *	callbacks: @suspend(), @freeze(), or @poweroff().
> > + *	The PM core executes @prepare() for all devices before starting to
> > + *	execute suspend callbacks for any of them, so drivers may assume all of
> > + *	the other devices to be present and functional while @prepare() is being
> > + *	executed.  In particular, it is safe to make GFP_KERNEL memory
> > + *	allocations from within @prepare(), although they are likely to fail in
> > + *	case of hibernation, if a substantial amount of memory is requested.
> 
> Why?

Hmm, you're right.  This is the other way around - if a device allocates too
much RAM, we won't have enough memory to create the image.

> > + *	However, drivers may NOT assume anything about the availability of the
> > + *	user space at that time and it is not correct to request firmware from
> > + *	within @prepare() (it's too late to do that).
> 
> That doesn't sound good. It would be good to be able to get drivers to
> request firmware early in the process.

That will be possible when we drop the freezer.

> > + * @complete: Undo the changes made by @prepare().  This method is executed for
> > + *	all kinds of resume transitions, following one of the resume callbacks:
> > + *	@resume(), @thaw(), @restore().  Also called if the state transition
> > + *	fails before the driver's suspend callback (@suspend(), @freeze(),
> > + *	@poweroff()) can be executed (e.g. if the suspend callback fails for one
> > + *	of the other devices that the PM core has unsucessfully attempted to
> 
> s/﻿unsucessfully/﻿unsuccessfully

Thanks, will fix.

Rafael
