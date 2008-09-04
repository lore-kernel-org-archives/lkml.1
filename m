Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYIDVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYIDVuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYIDVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:50:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46569 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbYIDVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:50:15 -0400
Date: Thu, 4 Sep 2008 15:48:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080904214802.GO2772@parisc-linux.org>
References: <20080903191023.GF2772@parisc-linux.org> <Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0809031544020.3559-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:15:39PM -0400, Alan Stern wrote:
> On Wed, 3 Sep 2008, Matthew Wilcox wrote:
> 
> > > A number of important commands are missing.  Clear-Halt springs to
> > > mind, as do Reset-Device, Set-Configuration, and Set-Interface.
> > 
> > Set Configuration and Set Interface are requests on the command pipe
> > according to the usb 2.0 spec (these would be a control message
> > targetted at endpoint 0).  I don't find Reset Device in usb 2.0; in
> 
> It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13;  
> the request is actually sent to the device's upstream hub.

Mmm.  In this case, we don't have an upstream hub.  The vhci-hcd driver
is on the host and sends URBs across the network where they're received
by the stub driver.  The stub then sends them to the exported device.

I don't have a USB hub, so I can't tell you what happens if the exported
device is plugged into one.

What causes Linux to send a 'reset' to a hub?  What do we do in similar
circumstances if the device isn't attached to a hub?  Is there a *hci
specific way of resetting a bus that's directly attached?

(I suspect you're going to be completely right here and we need to add a
'device reset' message to the protocol.  What isn't clear to me is how
the stub on the device side is going to communicate that reset to the
device.)

> Never mind the details; the important point is this: All these 
> requests, in addition to sending data over the USB bus, have to modify 
> the host's internal state.
> 
> 	Set-Configuration updates the list of available interfaces
> 	and endpoints.
> 
> 	Set-Interface updates the list of available endpoints.
> 
> 	Reset-Device requires the host to verify that the device is
> 	still connected to the port and its descriptors haven't
> 	changed.  The host also has to restore the former configuration
> 	and altsettings.
> 
> 	Clear-Halt requires the endpoint's data toggle value in the 
> 	host controller to be reset.

I see these requests need to be understood by the vhci (host) side, and
by the device itself, but it's not clear to me that they need to be
comprehended by the stub driver on the device side.  OTOH, I'm a long
way from being an expert on the USB protocol, so please tell me again
that I'm wrong ;-)

> So it isn't good enough for the client simply to send a few packets; 
> the server needs to know when these events happen.  In theory they can 
> be detected by parsing packets as they are sent, but IMO it would be 
> better for them to be higher-level calls.

I agree with you that the client-side stub should not be parsing requests.

> > How about this:
> > 
> >  - The sender has a timeout after which time, it will re-send the call.
> 
> How will this timeout be determined?

That's an implementation not protocol question ... I suspect that
something akin to the TCP transmission rules would suffice.

> >  - If the recipient receives a call that is still outstanding, it
> >    replies with a status akin to NFS's EJUKEBOX that means "It's in
> >    progress".
> 
> Should the server send a "submission accepted" message some time before
> the first timeout occurs?  For long-running requests this would
> eliminate a resend.

I think that would be a reasonable thing to do.  Of course, the message
could be dropped on the way, so device-side implementations MAY do this,
not MUST.

> >  - If the recipient receives a call for a reply it has already sent, it
> >    just resends it.
> 
> This requires the server to keep each completed reply for some time.  
> When can this data be freed?

When the device-side receives another packet to the same endpoint,
perhaps?  Does USB permit multiple outstanding commands to the same
endpoint?

> > > There isn't any field in the submit reply to report the status of the 
> > > transfer (as opposed to the status of the submission).  How do errors 
> > > like -EILSEQ get reported back to the client?
> > 
> > Isn't that error entirely within the remote device and should be retried
> > there?
> 
> In brief, no.  The caller needs to know; retrying isn't always the 
> appropriate response.

OK, but if the transfer didn't complete, the submission doesn't have a
status either, so we can use the same status field for both protocol
errors and submission errors.

> > > What about the extra flags that go with URB submissions?  
> > > URB_NO_INTERRUPT and URB_SHORT_NOT_OK might well be useful, 
> > > URB_ZERO_PACKET is certain to be needed, and even URB_ISO_ASAP might 
> > > come in handy.
> > 
> > I think including those flags in the 'call' variable would make sense,
> > assuming they make sense at this level.  I'm trying to understand that,
> > both in the context of pass-through and in the context of a pure
> > userspace USB device.
> 
> They do make sense at this level, just as they make sense in usbfs.
> (However the point of USB_SHORT_NOT_OK would be lost; the semantics of 
> that flag would need to be extended for it to be useful.)

OK.  I think I'm going to change the 4 byte call id to be a 1 byte
call id, and 3 bytes of padding for non-submit commands.  For submit
commands, I'll use 1 byte for the direction + endpoint.  That leaves 2
bytes for flags.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
