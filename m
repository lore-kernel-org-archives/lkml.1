Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZFHVb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZFHVb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZFHVbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:31:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZFHVbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:31:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 23:31:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906081626120.13888-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906081626120.13888-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906082331.58933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Alan Stern wrote:
> On Mon, 8 Jun 2009, Rafael J. Wysocki wrote:
> 
> > On Monday 08 June 2009, Oliver Neukum wrote:
> > > Am Sonntag, 7. Juni 2009 23:46:59 schrieb Rafael J. Wysocki:
> > > > It may be necessary to resume a device synchronously, but I'm still
> > > > thinking how to implement that.
> > > 
> > > This will absolutely be the default. You resume a device because you want
> > > it to do something now. It seems to me that you making your problem worse
> > > by using a spinlock as a lock. A mutex would make it easier.
> > 
> > But I need to be able to call __pm_schedule_resume() (at least) from interrupt
> > context and I can't use a mutex from there.  Otherwise I'd have used a mutex. :-)
> > 
> > Anyway, below is a version with synchronous resume.
> 
> There are a few things here which need further thought:
> 
> The implementation of pm_lock_device() assumes it will never be called 
> with interrupts disabled.  This is a bad assumption.

Indeed.

> Use of the RPM_UNKNOWN state isn't good.  A bus may have valid reasons 
> of its own for not carrying out an autosuspend.  When this happens the 
> device's state isn't unknown.

I'm not sure what you mean exactly.

If ->autosuspend() fails, the device power state may be known, but the core
can't be sure if the device is active.  This information is available to the
driver and/or the bus type, which should change the status to whatever is
appropriate.

The name of this constant may be confusing, but I didn't have any better ideas.

> The scheme doesn't include any mechanism for communicating runtime
> power information up the device tree.  When a device is autosuspended,
> its parent's driver should be told so that the driver can consider
> autosuspending the parent.

I thought the bus type's ->autosuspend() callback could take care of this.

> Likewise, if we want to autoresume a device below an autosuspended parent,
> the parent should be autoresumed first.  Did you want to make the bus
> subsystem responsible for all of this?

Yes, that was the idea.
 
> What about device's whose parent belongs to a different subsystem?

Good question. :-)

I think that requires some research.  Probably a USB device attached to a PCI
USB controller is a good example here, but we first need to have a prototype
implementation for PCI to carry out some testing.

In fact I'd like to avoid the complexity for now and consider one bus type at a
time.  Especially that, for example, for PCI we won't autosuspend bridges
initially, so this case is going to be really simple.

> There should be a sysfs interface (like the one in USB) to allow
> userspace to prevent a device from being autosuspended -- and perhaps
> also to force it to be suspended.

To prevent a device from being suspended - yes.  To force it to stay suspended
- I'm not sure.

Anyway, that will be the next step.

> What about devices that have more than two runtime power states?  For
> example, you can't squeeze PCI's {D0,D1,D2,D3hot} range into {running,
> suspended}.

That has to be bus type-specific.

In the case of PCI all of the low power states (D1-D3) are in fact substates of
"suspended", because we generally need to quiesce the device before putting
it into any of these states.

I'm not sure if we can introduce more "levels of suspension", so to speak, at
the core level, but in any case we can easily distinguish between "device
quiesced and in a low power state" and "device fully active".

So, in this picture the device is "suspended" from the core's point of view
once it's bus type's ->autosuspend() callback has been successfully executed. 

> That's what I come up with on a first reading.  There may be more later 
> on...  :-)

Sure.

Thanks for your comments! :-)

Best,
Rafael
