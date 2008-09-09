Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYIIPWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYIIPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYIIPVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:21:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38726 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751442AbYIIPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:21:50 -0400
Date: Tue, 9 Sep 2008 11:21:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       <bgmerrell@novell.com>, <hirofuchi@users.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <usbip-devel@lists.sourceforge.net>
Subject: Re: USBIP protocol
In-Reply-To: <20080909005353.GR2772@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.0809091031130.2143-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Matthew Wilcox wrote:

> [Sorry, I meant to send this mail before I left on Friday ... best laid
> plans, etc]

That's okay; I'm not on a deadline.  :-)

> > Sometimes I find the terminology a little confusing.  "Client" and
> > "server" are clear enough, as is "device-side" (synonymous with
> > "server").  I guess vhci-hcd runs on the client, right?
> 
> 'Client' and 'Server' are totally not clear.  Is the 'server' the big
> machine in the closet without USB devices, or is the machine with the
> device attached to it 'serving' the device to the machine without usb
> devices?

It is unfortunate that these two words have been used in multiple ways, 
with meanings that are sometimes only subtly different and sometimes 
grossly conflicting.

Isn't it standard in networking circles for "server" to mean the system
running a daemon that waits for incoming connections and "client" to
mean the system running an on-demand program that initiates a
connection?

> (I'd like to give a big shout-out to my homies working on X Windows for
> making this confusion possible)
> 
> Controller machine:
> 
> Loads vhci-hcd
> runs usbip --attach machine-b 2-2
> 
> Target machine:
> 
> Loads usbip
> runs usbipd
> runs bind_driver --usbip 2-2
> 
> The controller machine now gets a device 9-2 which accesses the target
> machine's 2-2 device.
> 
> I suppose it's my fault for not documenting this clearly in the protocol
> document.  Fixed now.

Okay, "controller" and "target".  I'm not sure that "controller" is the
best word either, since it might be confused with "USB host
controller".

> > But "host" is ambiguous; vhci-hcd is a host controller driver on the
> > client and [uoe]hci-hcd is a host controller driver on the server.  
> > Thus both sides are hosts.  Also, "stub" isn't too clear.  Is vhci-hcd
> > a stub driver?  Or does the stub driver run strictly on the server?
> 
> The usbip module is also referred to as the stub driver:
> 
> [  402.731706] usbip:Stub Driver for USB/IP:1.0

Hmmm.  Above you said that the controller system runs a program named 
"usbip" and the target system loads a module named "usbip".  Since the 
stub driver is the usbip _module_, it must run on the target (AKA 
server).  Right?

> > Getting back to your question...  All devices have an upstream hub,
> > except for root hubs.  In this case the device's upstream hub is the
> > physical hub it is plugged into if it plugged into a hub, or the
> > physical root hub it is plugged into otherwise.  Either way, the
> > upstream hub has to be managed by the server, not by the client.  
> > That's another reason why device reset needs to be treated as a special
> > call.
> 
> OK, I was confused, I didn't realise the *hci included a hub.  I always
> thought of a hub as an external device.

Yes; it is referred to as a "virtual root hub", or just "root hub" for 
short.  We didn't make this up; section 10.2.8 of the USB spec is 
entitled "Root Hub".

FYI, the *hci-hcd modules are collectively known as "host controller
drivers", or HCDs for short.  We USB guys sling that term around a lot
-- if you start using it too you'll impress other programmers.  :-)


> > The server's USB stack needs to know about these requests because they
> > need to affect hardware and software state on the server.  If you tried
> > to pass one these things directly from the client to the device, you'd
> > find that suddenly things weren't working.  The hardware and software
> > on the server would no longer be able to communicate with the device
> > after the device's state was changed without the server's knowledge.
> 
> I'm going to assume you mean 'device server' in this context (now
> referred to as target machine).

Right.

> I just don't understand why the target machine's stack needs to know
> which endpoints are available.  Is it for when the controller detaches?

"Detaches" isn't a USB term.  Do you mean it in the sense of a SCSI 
initiator detaching from its target?

In any event, the answer is that each endpoint has several properties
associated with it (direction, type, maximum packet size, and so on),
and these properties have to be known by both the target's USB stack
and the target's USB host controller hardware.  The hardware uses DMA
to access various in-memory data structures describing the I/O
operations it should perform, and the format and contents of these data
structures depends on the endpoints' properties.  (To make matters
worse, the hardware will sometimes maintain an internal cache for parts
of the data structures and some of the properties; when the properties 
change the cache must be flushed.)

With new configurations or altsettings you end up with a new set of
endpoints, or the same old endpoints with a new set of properties.  
Thus the target really needs to know when these things change.

> I would think that a USB reset should be issued to the device when
> control changes between a real driver (eg usb-storage) and the stub
> driver.

I suppose the controller system, as part of its normal initialization 
procedure for new devices, would issue such a reset.  This area is 
still a little cloudy -- we know that the controller system shouldn't 
treat a new USBIP device exactly the same as a new normal USB device, 
but exactly what the difference should be has yet to be fleshed out.

We may even want to have some sort of method table with entries for 
initialization, reset, suspend, resume, and clear-halt.

> > > When the device-side receives another packet to the same endpoint,
> > > perhaps?  Does USB permit multiple outstanding commands to the same
> > > endpoint?
> > 
> > This isn't a hardware-level issue; it's a software issue.  Linux's USB 
> > stack allows multiple outstanding requests to be queued for the same 
> > endpoint.
> 
> I guess the question is where the queueing happens -- does it happen in
> the *hci driver, or does it happen in the device?

It happens in the HCD, not in the device.

>  Either way, we could
> choose whether to queue the urbs on the controller machine or on the
> target machine -- it's a complexity / performance tradeoff.  I don't
> know where the correct balance point is.

There's more to it.  The USB stack behaves qualitatively and 
quantitatively differently in these two cases:

	An URB completes, the completion handler returns, and then
	a new URB is submitted.

	A new URB is submitted either before the old one completes
	or while the old URB's completion handler is running.

With USBIP it's not feasible for an URB queued on the controller
machine to be submitted as part of the target's completion handler
processing.  If the URB was queued in the target's usbipd driver then 
this would be feasible.  And of course, if the URB was queued in the 
target's HCD then no special treatment would be needed.

For relevant background information, read the kerneldoc for 
usb_submit_urb() and usb_unlink_urb() in drivers/usb/core/urb.c.

Alan Stern

