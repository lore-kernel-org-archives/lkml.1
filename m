Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZLCTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZLCTjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZLCTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:39:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52730 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755295AbZLCTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:39:29 -0500
Date: Thu, 3 Dec 2009 14:39:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912031331.03323.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912031424270.4795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Ondrej Zary wrote:

> Luckily, it appeared with usbmon active, here's the output:

...

> > Also, try adding some more debugging output (and let's hope it doesn't
> > also make the problem disappear).  In start_unlink_async(), just before
> > your "after:" label, add
> >
> > 	ehci_info(ehci, "unlink qh %p %p\n", qh, qh->qh_next);
> >
> > In qh_link_async(), just after the wmb(), add
> >
> > 	ehci_info(ehci, "link qh %p %p\n", qh, qh->qh_next);
> >
> > In end_unlink_async(), just after the iaa_watchdog_done(ehci), add
> >
> > 	ehci_info(ehci, "end unlink qh %p %p\n", qh, qh->next);
> >
> > And in qh_make(), just before the end, add
> >
> > 	ehci_info(ehci, "create qh %p, dev %s, ep %x\n",
> > 		qh, urb->dev->devpath, urb->ep->desc.bEndpointAddress);
> 
> Thanks for suggestion, here's the output:

I wish you hadn't removed all the "create qh" log messages.

Anyway, it looks like the problem is caused by your driver overwriting 
the data structure owned by ehci-hcd.  Here's the important part of the 
log:

> [  151.688299] ehci_hcd 0000:00:1d.7: link qh f65cf700 (null)
> [  151.688428] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 (null)

Here f65cf700 is the only qh on the async list (it is linked in at the 
head and its qh_next pointer is NULL).

> [  151.688497] ehci_hcd 0000:00:1d.7: link qh f65cf080 (null)

Now f65cf080 is added to the start of the list.

> [  151.688534] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 (null)
> [  151.688546] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080

And f65cf700 is added to the start, preceding f65cf080.

> [  151.688675] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 f65cf080
> [  151.688784] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 f65cf080

f65cf700 is removed from the start position, leaving f65cf080 at the 
start.

> [  151.688796] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080

It is added again at the start, preceding f65cf080.

> [  151.688923] ehci_hcd 0000:00:1d.7: unlink qh f65cf700 f65cf080
> [  151.689033] ehci_hcd 0000:00:1d.7: end unlink qh f65cf700 f65cf080

It is removed again from the start position.

> [  151.689045] ehci_hcd 0000:00:1d.7: link qh f65cf700 f65cf080

It is added again at the start.

> [  151.689106] usb 1-1.1: USB disconnect, address 9
> [  152.712104] prev is NULL, qh=f65cf080, ehci->async=f65cf000

Evidently prev is f65cf700->qh_next.  We know that the value was set to
f65cf080 just above, and you added log messages to every place where
ehci-hcd changes qh_next.  Hence something your driver did must have
been responsible.  Does it access urb->hcpriv anywhere?

Incidentally, look at the usbmon trace:

> f60eecc0 1501056647 S Bi:1:009:2 -115 128 <
> f60eecc0 1501056905 C Bi:1:009:2 -32 0
> f60eecc0 1501056916 S Bi:1:009:2 -115 128 <
> f60eecc0 1501057172 C Bi:1:009:2 -32 0
> f60eecc0 1501057183 S Bi:1:009:2 -115 128 <
> f60eecc0 1501057394 C Bi:1:009:2 -32 0

Why does your driver keep submitting the same request over and over 
again when each time it fails?

Alan Stern

