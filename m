Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYICUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYICUPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYICUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:15:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32854 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751962AbYICUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:15:40 -0400
Date: Wed, 3 Sep 2008 16:15:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <bgmerrell@novell.com>, <hirofuchi@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <usbip-devel@lists.sourceforge.net>
Subject: Re: USBIP protocol
In-Reply-To: <20080903191023.GF2772@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Matthew Wilcox wrote:

> > A number of important commands are missing.  Clear-Halt springs to
> > mind, as do Reset-Device, Set-Configuration, and Set-Interface.
> 
> Set Configuration and Set Interface are requests on the command pipe
> according to the usb 2.0 spec (these would be a control message
> targetted at endpoint 0).  I don't find Reset Device in usb 2.0; in

It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13;  
the request is actually sent to the device's upstream hub.

> usb-storage there's Bulk-Only Mass Storage Reset which is again a
> request on the command pipe.  I also don't find Clear Halt in usb 2.0;
> but if I'm reading 9.4.5 correctly, the Halt state is cleared by sending
> a GetStatus control message to the appropriate endpoint.

In fact it's cleared by sending ClearFeature(ENDPOINT_HALT) to the 
appropriate endpoint.

Never mind the details; the important point is this: All these 
requests, in addition to sending data over the USB bus, have to modify 
the host's internal state.

	Set-Configuration updates the list of available interfaces
	and endpoints.

	Set-Interface updates the list of available endpoints.

	Reset-Device requires the host to verify that the device is
	still connected to the port and its descriptors haven't
	changed.  The host also has to restore the former configuration
	and altsettings.

	Clear-Halt requires the endpoint's data toggle value in the 
	host controller to be reset.

So it isn't good enough for the client simply to send a few packets; 
the server needs to know when these events happen.  In theory they can 
be detected by parsing packets as they are sent, but IMO it would be 
better for them to be higher-level calls.


> > The reply to a submit call will be sent when the USB transfer is
> > complete.  Suppose the transfer takes a long time.  How does the client
> > tell the difference between a long-running transfer and an unreceived
> > submit?  Do you essentially assume that all protocol transfers are
> > reliable?
> 
> How about this:
> 
>  - The sender has a timeout after which time, it will re-send the call.

How will this timeout be determined?

>  - If the recipient receives a call that is still outstanding, it
>    replies with a status akin to NFS's EJUKEBOX that means "It's in
>    progress".

Should the server send a "submission accepted" message some time before
the first timeout occurs?  For long-running requests this would
eliminate a resend.

>  - If the recipient receives a call for a reply it has already sent, it
>    just resends it.

This requires the server to keep each completed reply for some time.  
When can this data be freed?


> > There isn't any field in the submit reply to report the status of the 
> > transfer (as opposed to the status of the submission).  How do errors 
> > like -EILSEQ get reported back to the client?
> 
> Isn't that error entirely within the remote device and should be retried
> there?

In brief, no.  The caller needs to know; retrying isn't always the 
appropriate response.


> > What about the extra flags that go with URB submissions?  
> > URB_NO_INTERRUPT and URB_SHORT_NOT_OK might well be useful, 
> > URB_ZERO_PACKET is certain to be needed, and even URB_ISO_ASAP might 
> > come in handy.
> 
> I think including those flags in the 'call' variable would make sense,
> assuming they make sense at this level.  I'm trying to understand that,
> both in the context of pass-through and in the context of a pure
> userspace USB device.

They do make sense at this level, just as they make sense in usbfs.
(However the point of USB_SHORT_NOT_OK would be lost; the semantics of 
that flag would need to be extended for it to be useful.)

Alan Stern

