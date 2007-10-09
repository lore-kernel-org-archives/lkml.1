Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXJIGJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXJIGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXJIGJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:09:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXJIGJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:09:18 -0400
Date: Mon, 8 Oct 2007 23:06:40 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>, linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
Message-ID: <20071009060640.GB15744@kroah.com>
References: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071008.204236.92016616.davem@davemloft.net> <20071009043909.GA4940@kroah.com> <20071008.214727.48799757.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008.214727.48799757.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 09:47:27PM -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Mon, 8 Oct 2007 21:39:09 -0700
> 
> > No, nothing cute in udev itself, but it seems that all distros that I
> > know of have a "load these modules now" type setting in their init
> > scripts that can be used here.
> > 
> > I can't think of a way to enforce this load order on the modules
> > themselves due to the fact that OHCI might not even be needed for EHCI
> > devices on UHCI (Intel) based chipsets :(
> > 
> > Can anyone else?
> 
> The three modules perhaps should be a bundle of whatever ones you have
> enabled, and internally we can dispatch the initialization to occur in
> the correct order from a top-level module_init().
> 
> If the devices need to be initialized in a certain order in a
> situation like this, it really seems like it is the kernel's job to
> enforce it.

I agree.

Here's some information from Intel about where they have seen this
happen for UHCI controllers, so it's not just an OHCI issue :(

thanks,

greg k-h

----------------


We had a logic analyzer attached to the bus going to the ESB (ICH) which
has the USB controller in it. In the passing case we would see no
accesses to UHCI IO registers while EHCI initialized and sets its config
flag. The EHCI Port Status & Control registers were then read and then
we see a write to the EHCI Port Status & Control registers port owner
bit for the low speed devices (keyboard & mouse). This turns control
back over to the companion UHCI controller.=20

In our most prevalent failing case (#1 below) we never saw the write to
port owner bit on the ports with the low speed devices. In the passing
case we see the write to the port owner bit.

I do not see how this would have anything to do with flakey hardware
especially since we can reproduce this on all of our systems and the
same device (USB controller) is used on multiple products.=20

I really believe that this has to do with the UHCI and EHCI drivers
running on top of each other. This seems to be happening fairly often on
our systems. If the EHCI driver runs first then we do not see the
failure. If they are running at the same time then we see different
failure symptoms.=20

1) We see that the ports with low speed devices are still in EHCI mode
(port owner bit not written to in EHCI driver). In our analyzer captures
we see the reads from the Port Status & Control register and it is
indicating that there are low speed devices on the ports. Can you tell
us why the driver would not be doing the write to the port owner bit
when it sees that low speed devices are attached to that port? Is there
something specific that it looks for and decides not to do the write?

2) In other cases we see that the ports with the low speed devices are
back in UHCI mode but the ports are disabled. In this case we see from
the analyzer traces that the UHCI driver has completed setting up the
port. It has actually enabled that port in UHCI mode. We then see the
EHCI driver comes in and it resets everything. The driver then gives
control back to the UCHI controller (by setting the port owner bit)
but...since the UHCI driver has already setup this port once it seems
that it does not go back and set it up again. In this case we do not
think that the UHCI driver has completed running when the EHCI driver
comes in and does the reset. Can you tell us if the UHCI driver was
interrupted in the middle but after the ports with the low speed devices
had been enabled would the UHCI driver ever go back and reinitialize the
ports with the low speed devices?

3) In some cases we see errors in the DMESG log but it seems to recover.

So we really do believe that it has to do with the EHCI driver running
in the middle of the UHCI driver running. And then dependent upon when
the EHCI driver comes in, while the UHCI driver is running, we see the
different failures. And since by default these drivers are not forced to
run sequentially we are susceptible to the failure.=20

