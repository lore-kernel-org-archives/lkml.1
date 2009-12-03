Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZLCWWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZLCWWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZLCWWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:22:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42409 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752733AbZLCWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:22:10 -0500
Date: Thu, 3 Dec 2009 17:22:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912032155.26018.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912031710130.4795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Ondrej Zary wrote:

> > I wish you hadn't removed all the "create qh" log messages.
> 
> I haven't removed them - I was surprised too that they are missing. I probably 
> did something wrong (again).

They probably appeared much earlier in the log.  It doesn't matter.

> > Anyway, it looks like the problem is caused by your driver overwriting
> > the data structure owned by ehci-hcd.  Here's the important part of the
> >
> > log:
> > > [  151.688299] ehci_hcd 0000:00:1d.7: link qh f65cf700 (null)
> > > [  151.688428] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 (null)
> >
> > Here f65cf700 is the only qh on the async list (it is linked in at the
> > head and its qh_next pointer is NULL).
> >
> > > [  151.688497] ehci_hcd 0000:00:1d.7: link qh f65cf080 (null)
> >
> > Now f65cf080 is added to the start of the list.
> >
> > > [  151.688534] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 (null)
> > > [  151.688546] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080
> >
> > And f65cf700 is added to the start, preceding f65cf080.
> >
> > > [  151.688675] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 f65cf080
> > > [  151.688784] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 f65cf080
> >
> > f65cf700 is removed from the start position, leaving f65cf080 at the
> > start.
> >
> > > [  151.688796] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080
> >
> > It is added again at the start, preceding f65cf080.
> >
> > > [  151.688923] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 f65cf080
> > > [  151.689033] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 f65cf080
> >
> > It is removed again from the start position.
> >
> > > [  151.689045] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080
> >
> > It is added again at the start.
> >
> > > [  151.689106] usb 1-1.1: USB disconnect, address 9
> > > [  152.712104] prev is NULL, qh=f65cf080, ehci->async=f65cf000
> >
> > Evidently prev is f65cf700->qh_next.  We know that the value was set to
> > f65cf080 just above, and you added log messages to every place where
> > ehci-hcd changes qh_next.  Hence something your driver did must have
> > been responsible.  Does it access urb->hcpriv anywhere?
> 
> Thanks for explaining this.
> 
> No, it doesn't access urb->hcpriv. The driver should not do anything special. 
> Just sends one interrupt urb, reads the replies and sends ACK (a bulk urb) 
> when touch data was received. When idle, the device sends no reply most of 
> the time, sometimes "8204abaa".
> Here's the latest version: http://lkml.org/lkml/2009/12/3/74

I don't understand.  The URBs shown in the usbmon trace are all 
bulk-IN.  But your patch adds only a bulk-OUT URB.  And the original 
usbtouchscreen driver doesn't use bulk URBs at all, only interrupt 
URBs.  So where are these URBs coming from?

Furthermore, the patch shows that the second-to-last argument to 
usb_fill_bulk_urb() -- the completion function -- is NULL.  That is 
strictly illegal and it should have caused an oops as soon as the URB 
was used.

> > Incidentally, look at the usbmon trace:
> > > f60eecc0 1501056647 S Bi:1:009:2 -115 128 <
> > > f60eecc0 1501056905 C Bi:1:009:2 -32 0
> > > f60eecc0 1501056916 S Bi:1:009:2 -115 128 <
> > > f60eecc0 1501057172 C Bi:1:009:2 -32 0
> > > f60eecc0 1501057183 S Bi:1:009:2 -115 128 <
> > > f60eecc0 1501057394 C Bi:1:009:2 -32 0
> >
> > Why does your driver keep submitting the same request over and over
> > again when each time it fails?
> 
> Looks like it's resubmitting the interrupt urb. This -EPIPE case is not 
> covered in usbtouch_irq() callback. According to some other drivers, -EPIPE 
> means "halt" or "stall" which should be cleared by using usb_clear_halt(). It 
> cannot be used in interrupt context.

-EPIPE does mean "halt" or "stall".  The fact that you can't use 
usb_clear_halt() in interrupt context is no excuse.  You _have_ to use 
it, otherwise the device will continue not working.  The easiest way 
would be to set up a workqueue routine to do it.

Alan Stern

