Return-Path: <linux-kernel-owner+w=401wt.eu-S934524AbYBTVpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524AbYBTVpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbYBTVow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:44:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:8119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916AbYBTVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="343090190"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 13:44:11 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201344.11643.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 1:13 pm Linus Torvalds wrote:
> On Wed, 20 Feb 2008, Jesse Barnes wrote:
> > The current callback system looks like this (according to Rafael and the
> > last time I looked):
> >   ->suspend(PMSG_FREEZE)
> >   ->resume()
> >   ->suspend(PMSG_SUSPEND)
> >   *enter S3 or power off*
> >   ->resume()
>
> Yes, it's very messy.
>
> It's messy for a few different reasons:
>
>  - the one you hit: a driver actually has a really hard time telling what
>    PMSG_SUSPEND really means.
>
>  - more importantly, we generally don't want to "suspend/resume" the
>    hardware at all around a power-off, because we're going to resume with
>    the state at the time of the PMSG_FREEZE, which means that the hardware
>    has actually *changed* and been used in between!

Exactly.

> So the "->resume" really isn't a resume at all. It's much closer to a
> "->reset".

Yeah, in the hibernate case this is definitely true.

> Of course, the "solution" to this all right now is that we have to reset
> everything even if it *is* a suspend event, so it basically means that STR
> ends up using the much weaker model that snapshot-to-disk uses.
>
> The fundamental problem being that the two really have nothing
> what-so-ever to do with each other. They aren't even similar. Never were.
>
> > And in the long term we could have:
> >   ->suspend()
> >   *enter S3*
> >   ->resume()
>
> Yes, apart from all the complexities (suspend_late/resume_early). So in
> reality it's more than that, but the suspend/resume things are clearly
> nesting, and they have the potential to actually keep state around
> (because we *know* this machine is not going to mess with the devices in
> between).

Really, in the simple s3 case we still need early/late stuff?

> IOW, here we actually can have as an option "assume the device is there
> when you return".
>
> > or:
> >   ->hibernate()
> >   *kexec to another kernel to save image*
> >   *power off*
> >   ->return_from_hibernate() (or somesuch)
>
> Enough people don't trust kexec that I suspect the right thing simply is
>
> 	->freeze()		// stop dma, synchronize device state
> 	*snapshot*
> 	->unfreeze();		// resume dma
> 	*save image*
> 	[ optionally ->poweroff() ]	// do we really care? I'd say no
> 	*power off*
> 	->restore()		// reset device to the frozen one
>
> which may have four entry-points that can be illogically mapped to the
> suspend/resume ones like we do now, but they really have nothing to do
> with suspending/resuming.

Well, it seems like we'll have to fix drivers in either case, and isn't a 
kexec approach fundamentally more sound and simple, design-wise?  Rafael 
pointed out some problems with properly setting wakeup states, but I think 
that could be overcome...

> And notice how while "freeze/restore" kind of pairs like a
> "suspend/resume", it really shouldn't be expected to realistically restore
> the same state at all. The "restore" part is generally much better seen as
> a "reset hardware" than a "resume" thing. Because we literally cannot
> trust *anything* about the state since we froze it - we might have booted
> a different OS in between etc. Very different from suspend/resume.

Yeah, definitely.  It has to be much more robust and deal with configuration 
changes, etc. (within reason).

Jesse
