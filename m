Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXJJPcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXJJPcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXJJPcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:32:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59385 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753933AbXJJPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:32:42 -0400
Date: Wed, 10 Oct 2007 11:32:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-usb-devel@lists.sourceforge.net, <greg@kroah.com>,
       <davem@davemloft.net>, <linux-usb-users@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071009192250.BD703236A37@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0710101057400.4765-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, David Brownell wrote:

> > From: Greg KH <greg@kroah.com>
> >
> > Here's some information from Intel about where they have seen this
> > happen for UHCI controllers, so it's not just an OHCI issue :(
> >
> >	...
> >

The Intel error reports here are kind of unclear.

> > 1) We see that the ports with low speed devices are still in EHCI mode
> > (port owner bit not written to in EHCI driver).

_When_ are they still in EHCI mode?

> > In our analyzer captures
> > we see the reads from the Port Status & Control register and it is
> > indicating that there are low speed devices on the ports. Can you tell
> > us why the driver would not be doing the write to the port owner bit
> > when it sees that low speed devices are attached to that port? Is there
> > something specific that it looks for and decides not to do the write?
> 
> It's hard to say without more info about what's going on.  It
> might be on a non-enumeraton code path -- where nothing expects
> to set the OWNER bit -- or the CONNECT bit might not be set.
> See host/ehci-hub.c for details about exactly what the EHCI parts
> are doing, and core/hub.c for how it's driven.

Right.  In general the driver _does_ write to the port owner bit when 
it sees a low-speed device is attached to the port.  If that didn't 
happen in this case, maybe it's because the driver didn't see it.  
There are only one or two places in the code where the driver checks.

> (It can be tricky to make sense of all that, easier if debugging
> messages are turned on.   But that changes timings.  Better yet
> would be being non-intrusive tracing of the actual code paths
> that the CPU follows.)

It certainly would help us if the tests were made on a kernel with
CONFIG_USB_DEBUG enabled.

> > 2) In other cases we see that the ports with the low speed devices are
> > back in UHCI mode but the ports are disabled. In this case we see from
> > the analyzer traces that the UHCI driver has completed setting up the
> > port. It has actually enabled that port in UHCI mode.

This implies that the reset sequence finished successfully.  Did that 
actually happen?

> > We then see the
> > EHCI driver comes in and it resets everything. The driver then gives
> > control back to the UCHI controller (by setting the port owner bit)
> > but...since the UHCI driver has already setup this port once it seems
> > that it does not go back and set it up again. In this case we do not
> > think that the UHCI driver has completed running when the EHCI driver
> > comes in and does the reset.

But above they said that it _had_ completed!  Did they mean that the 
reset was complete but the driver hadn't yet detected that it was 
complete?

> > Can you tell us if the UHCI driver was
> > interrupted in the middle but after the ports with the low speed devices
> > had been enabled would the UHCI driver ever go back and reinitialize the
> > ports with the low speed devices?
> 
> If the UHCI driver got disconnect and reconnect notifications,
> I expect it would do so.  At least OHCI seems *not* to have gotten
> such notifications.  I'm speculating that the "just a switch"
> behavior for the CF (and OWNER) bits may not allow notifications
> like that to happen when the companion controllers are resetting.

That seems likely.  There's no way (as far as I can tell) for a host to 
see a disconnect while a reset is in progress.  Of course, as soon as 
the reset is over then the host should see the disconnect, and it 
should set the corresponding Connect-Status-Changed bit.

Amusing scenario: Suppose that ehci-hcd initializes the EHCI controller 
(taking control of the port), sees that the device isn't high speed, 
and switches port ownership back to the companion controller, all 
during the span of the companion's reset.  The companion would never 
know anything had happened!  But then everything should just work -- 
the port would be enabled and communication should proceed normally.

Alan Stern

