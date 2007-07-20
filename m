Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbXGTSRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbXGTSRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbXGTSRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:17:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757773AbXGTSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:17:38 -0400
Date: Fri, 20 Jul 2007 14:17:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Milton Miller <miltonm@bga.com>
cc: Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <09666fe245b0fb34a5a09464250e003d@bga.com>
Message-ID: <Pine.LNX.4.44L0.0707201408060.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Milton Miller wrote:

> On Jul 20, 2007, at 11:20 AM, Alan Stern wrote:
> > On Fri, 20 Jul 2007, Milton Miller wrote:
> >>> We can't do this unless we have frozen tasks (this way, or another)
> >>> before
> >>> carrying out the entire operation.
> >>
> >> What can't we do?   We've already worked with the drivers to quesce 
> >> the
> >> hardware and put any information to resume the device in ram.  Now we
> >> ask them to put their device in low power mode so we can go to sleep.
> >> Even if we schedule, the only thing userspace could touch is memory.
> >
> > Userspace can submit I/O requests.  Someone will have to audit every
> > driver to make sure that such I/O requests don't cause a quiesced
> > device to become active.  If the device is active, it will make the
> > memory snapshot inconsistent with the on-device data.
> 
> If a driver is waking a device between the time it was told by 
> hibernation "suspend all operations and save your device state to ram" 
> and "resume your device" then it is a buggy driver.

That's exactly my point.  As far as I know nobody has done a survey,
but I bet you'd find _many_ drivers are buggy either in this way or the
converse (forcing an I/O request to fail immediately instead of waiting
until the suspend is over when it could succeed).  They have this bug 
because they were written -- those which include any suspend/resume 
support at all -- under the assumption that they could rely on the 
freezer.

And that's why Rafael said "We can't do this unless we have frozen
tasks (this way, or another) before carrying out the entire operation."  
Until the drivers are fixed -- which seems like a tremendous job --
none of this will work.

> I argue the process can make the io request after we write to disk, we 
> just can't service it.  If we are suspended it will go to the request 
> queue, and eventually the process will wait for normal throttling 
> mechanisms until the driver is woken up.

Many drivers don't have request queues.  Even for the ones that do, 
there are I/O pathways that bypass the queue (think of ioctl or sysfs).

> Actually, my point was more "what kernel services do the drivers need 
> to transition from quiesced to low power for acpi S4 or 
> suspend-to-ram"?  We can't give them allocate-memory (but we give them 
> a call "we are going to suspend" when they can), but does "run this 
> tasklet" help?  What timer facilities are needed?

Some drivers need the ability to schedule.  Some will need the ability 
to allocate memory (although GFP_ATOMIC is probably sufficient).  Some 
will need timers to run.

> Do we need to differentate init (por by bios) and resume from quiesced 
> (for reboot, kexec start/resume)?  I hope not.

Yes we do.

Alan Stern

