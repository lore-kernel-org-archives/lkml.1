Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYHSP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYHSP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYHSP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:28:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55091 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752807AbYHSP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:28:30 -0400
Date: Tue, 19 Aug 2008 11:28:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808191533.15244.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Oliver Neukum wrote:

> > More to the point is whether you should ever suspend any of these 
> > devices if there can be multiple initiators.  But that's a separate 
> > question.
> 
> But one that needs to be addressed.

One possibility is to have an attribute flag for SCSI transport
classes, indicating whether the transport supports multiple initiators.

Besides, isn't this already an issue?  What happens when someone does a 
system suspend or hibernate?  Don't the attached disk drives get spun 
down, even if there are other initiators on the same SCSI bus?

(And is this really a problem?  If an error occurs because a drive is 
spun down when some other device tries to access it, that other device 
should simply spin the drive back up again.)

> > What is your point?  You seem to be saying that it would be nice to
> > suspend a host adapter at times when some of the SCSI targets beneath
> > it are not suspended.  I agree, but how would you determine whether
> > such a thing was safe?
> 
> I suggest by talking to the HLDs.

Why would the HLD (= ULD?) know?

For example, consider a USB disk drive.  How is sd.c (the HLD) supposed 
to know that it's not safe to suspend the USB link without spinning 
down the drive?  Or consider a traditional SCSI parallel interface 
drive.  How is sd.c supposed to know that it is safe to suspend the 
SPI host adapter without first spinning down the drive?

> It seems to me that abstractly talking there are three criteria for suspension
> 
> - the cpu needs to talk to the device now

I.e., whether the idle timeout has expired, right?

> - the device may need to talk to the CPU at unpredictable times

I.e, whether remote wakeup needs to be enabled, right?

> - suspending has side effects

I'm not sure what you mean by that.  Suspension always has side effects 
of one kind or another.

> Suspension in USB has always side effects. That's not true for other
> subsystems.

Name one.  At the very least, suspending a device means you can't use
it again without first calling the driver's resume method.  That's a 
side effect.

Hopefully, in most subsystems suspending a device would reduce its 
power usage.  Unfortunately this isn't true for SCSI at the moment...

> It seems to me that for the general case we need to divorce
> the notion of a child being suspended itself from a child agreeing to its
> parent being suspended.

This is already possible.  For example, you may remember a couple of
years ago I posted a patch for usb-storage which would autosuspend it
without regard for the state of its child devices.  The patch didn't
work out, because some devices really did need to have their caches
drained or disks spun down.

There's nothing about my suspend framework to prevent a driver from 
autosuspending its device while the children are still active.  
Rather, the framework insists on notifications going the other way: 
The driver has to be told whenever one of its device's children is 
suspended or resumed.

Alan Stern

