Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYIIAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYIIAyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYIIAyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:54:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43487 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYIIAyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:54:10 -0400
Date: Mon, 8 Sep 2008 18:53:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080909005353.GR2772@parisc-linux.org>
References: <20080904214802.GO2772@parisc-linux.org> <Pine.LNX.4.44L0.0809051017280.2493-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0809051017280.2493-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Sorry, I meant to send this mail before I left on Friday ... best laid
plans, etc]

On Fri, Sep 05, 2008 at 11:05:53AM -0400, Alan Stern wrote:
> On Thu, 4 Sep 2008, Matthew Wilcox wrote:
> 
> > > It's referred to as SetPortFeature(PORT_RESET) in section 11.24.2.13;  
> > > the request is actually sent to the device's upstream hub.
> > 
> > Mmm.  In this case, we don't have an upstream hub.  The vhci-hcd driver
> > is on the host and sends URBs across the network where they're received
> > by the stub driver.  The stub then sends them to the exported device.
> 
> Sometimes I find the terminology a little confusing.  "Client" and
> "server" are clear enough, as is "device-side" (synonymous with
> "server").  I guess vhci-hcd runs on the client, right?

'Client' and 'Server' are totally not clear.  Is the 'server' the big
machine in the closet without USB devices, or is the machine with the
device attached to it 'serving' the device to the machine without usb
devices?

(I'd like to give a big shout-out to my homies working on X Windows for
making this confusion possible)

Controller machine:

Loads vhci-hcd
runs usbip --attach machine-b 2-2

Target machine:

Loads usbip
runs usbipd
runs bind_driver --usbip 2-2

The controller machine now gets a device 9-2 which accesses the target
machine's 2-2 device.

I suppose it's my fault for not documenting this clearly in the protocol
document.  Fixed now.

> But "host" is ambiguous; vhci-hcd is a host controller driver on the
> client and [uoe]hci-hcd is a host controller driver on the server.  
> Thus both sides are hosts.  Also, "stub" isn't too clear.  Is vhci-hcd
> a stub driver?  Or does the stub driver run strictly on the server?

The usbip module is also referred to as the stub driver:

[  402.731706] usbip:Stub Driver for USB/IP:1.0

> Getting back to your question...  All devices have an upstream hub,
> except for root hubs.  In this case the device's upstream hub is the
> physical hub it is plugged into if it plugged into a hub, or the
> physical root hub it is plugged into otherwise.  Either way, the
> upstream hub has to be managed by the server, not by the client.  
> That's another reason why device reset needs to be treated as a special
> call.

OK, I was confused, I didn't realise the *hci included a hub.  I always
thought of a hub as an external device.

So the hub in the usbip scenario is on the controller machine.  Obviously,
the target machine also has a hub (ohci/uhci/ehci), but from the point
of view of sending a reset, it would be sent to vhci which then has to
communicate it to the device somehow.  So yep, let's include a reset
message in the protocol and that's how it will work.

Brian, how does it work today?  Does it just ignore reset commands?

> Similarly, suspend and resume involve sending requests to the upstream 
> hub.  They too would need to be treated specially.

An excellent point.  More commands!

> I'm not sure I understand the question.  Linux sends a port-reset 
> request whenever anyone calls usb_reset_device().  Is that what you 
> meant?

Not quite, but it's good enough for me.

> > > Never mind the details; the important point is this: All these 
> > > requests, in addition to sending data over the USB bus, have to modify 
> > > the host's internal state.
> > > 
> > > 	Set-Configuration updates the list of available interfaces
> > > 	and endpoints.
> > > 
> > > 	Set-Interface updates the list of available endpoints.
> > > 
> > > 	Reset-Device requires the host to verify that the device is
> > > 	still connected to the port and its descriptors haven't
> > > 	changed.  The host also has to restore the former configuration
> > > 	and altsettings.
> > > 
> > > 	Clear-Halt requires the endpoint's data toggle value in the 
> > > 	host controller to be reset.
> > 
> > I see these requests need to be understood by the vhci (host) side, and
> > by the device itself, but it's not clear to me that they need to be
> > comprehended by the stub driver on the device side.  OTOH, I'm a long
> > way from being an expert on the USB protocol, so please tell me again
> > that I'm wrong ;-)
> 
> Okay.  You're wrong.  :-)

You say that so authoritatively, I'm convinced!

> The server's USB stack needs to know about these requests because they
> need to affect hardware and software state on the server.  If you tried
> to pass one these things directly from the client to the device, you'd
> find that suddenly things weren't working.  The hardware and software
> on the server would no longer be able to communicate with the device
> after the device's state was changed without the server's knowledge.

I'm going to assume you mean 'device server' in this context (now
referred to as target machine).

I just don't understand why the target machine's stack needs to know
which endpoints are available.  Is it for when the controller detaches?
I would think that a USB reset should be issued to the device when
control changes between a real driver (eg usb-storage) and the stub
driver.

> > > >  - If the recipient receives a call for a reply it has already sent, it
> > > >    just resends it.
> > > 
> > > This requires the server to keep each completed reply for some time.  
> > > When can this data be freed?
> > 
> > When the device-side receives another packet to the same endpoint,
> > perhaps?  Does USB permit multiple outstanding commands to the same
> > endpoint?
> 
> This isn't a hardware-level issue; it's a software issue.  Linux's USB 
> stack allows multiple outstanding requests to be queued for the same 
> endpoint.

I guess the question is where the queueing happens -- does it happen in
the *hci driver, or does it happen in the device?  Either way, we could
choose whether to queue the urbs on the controller machine or on the
target machine -- it's a complexity / performance tradeoff.  I don't
know where the correct balance point is.

> > OK, but if the transfer didn't complete, the submission doesn't have a
> > status either, so we can use the same status field for both protocol
> > errors and submission errors.
> 
> It would be easy enough to multiplex the two status values in the same
> field, since URB statuses are ordinary negative Exxxx values.  If 
> USBIP's errors are represented using positive integers then there would 
> be no confusion.

Works for me.  We'll still want to document what they are since we
presumably want to encourage people to come up with their own
implementations of this protocol for other operating systems and fake
devices and so on.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
