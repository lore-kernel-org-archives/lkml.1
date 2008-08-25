Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYHYOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYHYOp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYHYOpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:45:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39349 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753242AbYHYOpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:45:21 -0400
Date: Mon, 25 Aug 2008 10:45:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808251450.09292.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808251033460.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, Oliver Neukum wrote:

> Am Dienstag 19 August 2008 17:28:28 schrieb Alan Stern:
> > On Tue, 19 Aug 2008, Oliver Neukum wrote:
>  
> > > I suggest by talking to the HLDs.
> > 
> > Why would the HLD (= ULD?) know?
> > 
> > For example, consider a USB disk drive.  How is sd.c (the HLD) supposed 
> > to know that it's not safe to suspend the USB link without spinning 
> > down the drive?  Or consider a traditional SCSI parallel interface
> 
> The HLD is responsible for suspending the disk in case the system is
> suspended. The HLD must know how to safely suspend a device. It may be
> overcautious, but it'll work.

You didn't answer my question: How does the HLD know whether it's okay 
to suspend the link without suspending the device?  I should think that 
it _doesn't_ know.

The transport class code might know, or the link's driver -- but not
the HLD.  The HLD probably doesn't even know what type of transport is
being used!

> > > It seems to me that abstractly talking there are three criteria for suspension
> > > 
> > > - the cpu needs to talk to the device now
> > 
> > I.e., whether the idle timeout has expired, right?
> > 
> > > - the device may need to talk to the CPU at unpredictable times
> > 
> > I.e, whether remote wakeup needs to be enabled, right?
> 
> I am talking about correctness for controllers. So remote wakeup may or may not
> be available. Likewise the bus may be able to predict how long it'll be idle.

I don't understand.  Are you saying that whether or not it's correct to
suspend a link depends on whether the device may need to talk to the
CPU at unpredictable times?  And if so, isn't that the same as saying
that remote wakeup for the link can be enabled?

As for predicting how long the link will be idle...  I doubt it is 
possible to do that with any reliability.

> > I'm not sure what you mean by that.  Suspension always has side effects 
> > of one kind or another.
> 
> But not outside the controller. If you suspend the root hub of a usb bus,
> you suspend everything on the bus. It's a feature of the hardware. Other
> busses are different.

All right, granted.

> > There's nothing about my suspend framework to prevent a driver from 
> > autosuspending its device while the children are still active.  
> > Rather, the framework insists on notifications going the other way: 
> > The driver has to be told whenever one of its device's children is 
> > suspended or resumed.
> 
> That's the problem. You don't tell the children when the parent might want
> to suspend.

Why should the children need to know?

	If the children are already suspended then we certainly don't
	need to tell them the link is going down.

	If the children are active, then the link's driver or the
	transport class must already have given the okay for
	suspending the link while leaving the children active.
	So again, why consult the children's drivers?

Alan Stern

