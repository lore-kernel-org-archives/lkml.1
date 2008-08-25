Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYHYQS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYHYQS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYHYQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:18:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36821 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753287AbYHYQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:18:20 -0400
Date: Mon, 25 Aug 2008 12:18:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808251705.28455.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808251152030.6639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, Oliver Neukum wrote:

> Am Montag 25 August 2008 16:45:20 schrieb Alan Stern:
> 
> > You didn't answer my question: How does the HLD know whether it's okay 
> > to suspend the link without suspending the device?  I should think that 
> > it _doesn't_ know.
> > 
> > The transport class code might know, or the link's driver -- but not
> > the HLD.  The HLD probably doesn't even know what type of transport is
> > being used!
> 
> There's some truth to that. Unfortunately the transport does not know
> whether a device or link may be suspended. Take the case of a CD playing
> sound. The transport may know what the consequences of suspending
> a link will be to the devices, but only the devices know whether the
> consequences are acceptable.

Even the device (or more properly, the driver) might not know!  In your
example the driver might realize that playing had been started, but it
probably wouldn't know when the playing had ended.

> > I don't understand.  Are you saying that whether or not it's correct to
> > suspend a link depends on whether the device may need to talk to the
> > CPU at unpredictable times?  And if so, isn't that the same as saying
> 
> Yes.
> 
> > that remote wakeup for the link can be enabled?
> 
> Remote wakeup is a concept specific to USB.

That's not true at all.  Maybe the name is specific to USB, but the
concept isn't.  Notice how we have power/wakeup files in the sysfs
directory for every device, even non-USB devices?  Requesting a
low-power to high-power transition is a generic operation.

> If you are writing for
> a generic system the question is indeed whether devices may want
> to talk to the host and whether they can.
> It seems to me that the ULD will know whether its devices will need
> to talk to the CPU.

In general, the link or transport class will know whether it is 
possible for a device to initiate communication with the CPU.  If it is 
possible then the link would probably want to have remote wakeup 
enabled before autosuspending, even if none of the devices currently 
attached actually wants to use it.

> > > That's the problem. You don't tell the children when the parent might want
> > > to suspend.
> > 
> > Why should the children need to know?
> 
> Because they'll want to do things like flushing caches.
>  
> > 	If the children are already suspended then we certainly don't
> > 	need to tell them the link is going down.
> 
> Yes.
>  
> > 	If the children are active, then the link's driver or the
> > 	transport class must already have given the okay for
> > 	suspending the link while leaving the children active.
> 
> Because the transport class may not know either.

So sd.c might, in theory, want to respond in two different ways to an 
autosuspend request:

	(A) Drain the cache,

	(B) Drain the cache and spin down the drive.

How does it know which to do?  Ask the transport class for help 
choosing?

(A) would leave us in an awkward "half-suspended" state.  Is the device
suspended or not?  It is, in the sense that now the link can safely be
suspended.  But it isn't, in the sense that a system sleep would still
require the drive to be spun down.

It's kind of like the state we have following a PMSG_FREEZE --
quiescent but not suspended.  Somehow this extra state needs to be
incorporated into the autosuspend framework.

Alan Stern

