Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYHMPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYHMPoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYHMPos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:44:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751087AbYHMPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:44:47 -0400
Date: Wed, 13 Aug 2008 11:44:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@hansenpartnership.com>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <200808131721.42721.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Oliver Neukum wrote:

> Am Mittwoch 13 August 2008 16:59:23 schrieb Alan Stern:
> > On Wed, 13 Aug 2008, Oliver Neukum wrote:
> > 
> > > Very well. I see a basic problem here. For USB it is necessary that child
> > > devices be suspended before anything higher up in the tree is suspended.
> > > SATA seems to be able to power down a link while the device is not suspended.
> > 
> > Is the USB transport unique in its requirement that all the child
> > devices must be suspended before the link can be powered down?  Maybe
> 
> All children that are USB must be powered down. We know in fact that most
> drives don't care that the device is suspended. The problem was drive
> enclosures that cut power upon suspension losing cached data.

You misunderstood my question.  Are there SCSI transports other than
USB sharing the requirement that all child devices must be suspended
before the link can be powered down?

> > > In fact in true SCSI busses can be shared. So are we using the correct
> > > approach?
> > 
> > This is a good question.  Most USB mass-storage devices do not act as a
> > true SCSI bus, but I believe there are a few non-standard ones that do
> > -- the USB device really contains a SCSI host and arbitrary SCSI
> > targets can be attached to it.  For the moment, we should be safe
> > enough using a model in which there are no other initiators on a
> > USB-type SCSI transport, but it's something to keep in mind.
> 
> So do we really want to do autosuspend on the device level? Or do we work
> on hosts and just use the suspend()/resume() support of the sd, sr, ... etc?

For transports which are like USB, we should do autosuspend at the
target (not device) level.  This means invoking the suspend/resume 
routines of the ULDs like sd and sr.  The transport gets notified when 
all of the targets are suspended.  (Or maybe the host driver gets 
notified instead; there probably isn't any advantage to using the 
transport class here.)

For other transports, we should only do idle-timeout detection.  The
transport gets notified when any target has been idle for sufficiently 
long, so that it can power down the link.  The ULDs are not involved.

Does that sound okay?

Alan Stern

