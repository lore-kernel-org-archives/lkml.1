Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYIEPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYIEPGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYIEPF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:05:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49985 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753681AbYIEPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:05:55 -0400
Date: Fri, 5 Sep 2008 11:05:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       <bgmerrell@novell.com>, <hirofuchi@users.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <usbip-devel@lists.sourceforge.net>
Subject: Re: USBIP protocol
In-Reply-To: <20080904214802.GO2772@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.0809051017280.2493-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Matthew Wilcox wrote:

> > It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13;  
> > the request is actually sent to the device's upstream hub.
> 
> Mmm.  In this case, we don't have an upstream hub.  The vhci-hcd driver
> is on the host and sends URBs across the network where they're received
> by the stub driver.  The stub then sends them to the exported device.

Sometimes I find the terminology a little confusing.  "Client" and
"server" are clear enough, as is "device-side" (synonymous with
"server").  I guess vhci-hcd runs on the client, right?

But "host" is ambiguous; vhci-hcd is a host controller driver on the
client and [uoe]hci-hcd is a host controller driver on the server.  
Thus both sides are hosts.  Also, "stub" isn't too clear.  Is vhci-hcd
a stub driver?  Or does the stub driver run strictly on the server?

Getting back to your question...  All devices have an upstream hub,
except for root hubs.  In this case the device's upstream hub is the
physical hub it is plugged into if it plugged into a hub, or the
physical root hub it is plugged into otherwise.  Either way, the
upstream hub has to be managed by the server, not by the client.  
That's another reason why device reset needs to be treated as a special
call.

Similarly, suspend and resume involve sending requests to the upstream 
hub.  They too would need to be treated specially.

> I don't have a USB hub, so I can't tell you what happens if the exported
> device is plugged into one.

It shouldn't make any difference.  If it does then there's something 
wrong with the implementation.

> What causes Linux to send a 'reset' to a hub?

I'm not sure I understand the question.  Linux sends a port-reset 
request whenever anyone calls usb_reset_device().  Is that what you 
meant?

>  What do we do in similar
> circumstances if the device isn't attached to a hub?

Every device is attached to a hub, except for root hubs.  
usb_reset_device() fails if its argument is a root hub.  (Root hubs 
cannot be reset like normal devices.)

>  Is there a *hci
> specific way of resetting a bus that's directly attached?

USB doesn't reset buses; it resets devices (or more precisely, a 
device's port on its upstream hub).  So I guess you're asking if there 
is a driver-specific way of resetting a port on a root hub.  The answer 
is Yes, but it is encapsulated in a driver-independent interface.

> (I suspect you're going to be completely right here and we need to add a
> 'device reset' message to the protocol.  What isn't clear to me is how
> the stub on the device side is going to communicate that reset to the
> device.)

It will call usb_reset_device().

> > Never mind the details; the important point is this: All these 
> > requests, in addition to sending data over the USB bus, have to modify 
> > the host's internal state.
> > 
> > 	Set-Configuration updates the list of available interfaces
> > 	and endpoints.
> > 
> > 	Set-Interface updates the list of available endpoints.
> > 
> > 	Reset-Device requires the host to verify that the device is
> > 	still connected to the port and its descriptors haven't
> > 	changed.  The host also has to restore the former configuration
> > 	and altsettings.
> > 
> > 	Clear-Halt requires the endpoint's data toggle value in the 
> > 	host controller to be reset.
> 
> I see these requests need to be understood by the vhci (host) side, and
> by the device itself, but it's not clear to me that they need to be
> comprehended by the stub driver on the device side.  OTOH, I'm a long
> way from being an expert on the USB protocol, so please tell me again
> that I'm wrong ;-)

Okay.  You're wrong.  :-)

The server's USB stack needs to know about these requests because they
need to affect hardware and software state on the server.  If you tried
to pass one these things directly from the client to the device, you'd
find that suddenly things weren't working.  The hardware and software
on the server would no longer be able to communicate with the device
after the device's state was changed without the server's knowledge.


> > >  - If the recipient receives a call for a reply it has already sent, it
> > >    just resends it.
> > 
> > This requires the server to keep each completed reply for some time.  
> > When can this data be freed?
> 
> When the device-side receives another packet to the same endpoint,
> perhaps?  Does USB permit multiple outstanding commands to the same
> endpoint?

This isn't a hardware-level issue; it's a software issue.  Linux's USB 
stack allows multiple outstanding requests to be queued for the same 
endpoint.

> > > > There isn't any field in the submit reply to report the status of the 
> > > > transfer (as opposed to the status of the submission).  How do errors 
> > > > like -EILSEQ get reported back to the client?
> > > 
> > > Isn't that error entirely within the remote device and should be retried
> > > there?
> > 
> > In brief, no.  The caller needs to know; retrying isn't always the 
> > appropriate response.
> 
> OK, but if the transfer didn't complete, the submission doesn't have a
> status either, so we can use the same status field for both protocol
> errors and submission errors.

It would be easy enough to multiplex the two status values in the same
field, since URB statuses are ordinary negative Exxxx values.  If 
USBIP's errors are represented using positive integers then there would 
be no confusion.

Alan Stern

