Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbXE2UsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbXE2UsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbXE2UsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:48:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40032 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760450AbXE2UsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:48:09 -0400
Date: Tue, 29 May 2007 16:48:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware
 before hibernation/suspend
In-Reply-To: <200705291309.47559.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0705291636540.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, David Brownell wrote:

> On Monday 28 May 2007, Alan Stern wrote:
> 
> > This is a matter of one's philosophy.  In suspend-to-RAM, should tasks
> > be frozen or should I/O queues be frozen?
> > 
> > With the USB subsystem I have followed the approach taken by the PM
> > core, which is that tasks are frozen.  But one can -- and Linus has on
> > at least one occasion -- make a good case that tasks should be left
> > running while only I/O is frozen. 
> 
> In fact that makes a heck of a lot more sense to me from the
> conceptual point of view.  From the hardware perspective, the
> task of preparing to enter true suspend states (STR, or suspend
> for ACPI; embedded systems have more options) focusses on what
> I/O signals are disabled.
> 
> Once the relevant I/O signals are first idled, then disabled,
> the CPU can do whatever it likes.  Whether it runs or not is
> purely a workload decision...
> 
> Remember too that not all systems suffer from the constraints
> that ACPI decrees.  In particular, it's not uncommon that some
> parts of the system be active in certain suspend states.  The
> whole point is to turn off as much of the system as possible,
> especially the high power portions, while letting work proceed.
> 
> Turning off some clocks and peripherals doesn't need to imply
> turning them all off, or disabling DMA ... and should not need
> to be triggered by a user (or userspace tool) explicitly saying
> "go into STR".

One can think of suspend-to-RAM as nothing more than a super-duper
selective suspend of all devices (including the CPU!).  This
illustrates the relationship between suspend-to-RAM and runtime PM.  
However there is one important distinction, the DoS issue that Pavel
raised.  With true suspend-to-RAM, autoresume on demand is not enabled
-- only on remote wakeup.  With runtime PM, both are enabled.


Elegant though it is, the "freeze I/O" approach suffers from 
implementation awkwardness.  Ideally individual drivers shouldn't have 
to worry about it, but the subsystems certainly will.

Consider as an example the class of char device drivers.  The only 
subsystem they have in common is VFS.  It would then be necessary for 
every entry point into VFS to check whether a suspend-to-RAM is in 
progress, and if it is, block until the suspend is over.  Each one of 
those entry points is on a hot path, so adding these checks is the sort 
of thing one would like to avoid.

By freezing tasks we can eliminate (most) I/O requests at the source 
with a single, relatively small amount of code (i.e., the 
refrigerator).  Freezing I/O, on the other hand, would involve many 
checks dispersed throughout a large number of source files -- checks 
that would have to execute even when a suspend wasn't in progress.

Alan Stern

