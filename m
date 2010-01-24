Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864Ab0AXX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0AXX1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758Ab0AXX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:27:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46166 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0AXX1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:27:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
Date: Mon, 25 Jan 2010 00:27:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <Pine.LNX.4.44L0.1001241712490.441-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001241712490.441-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250027.42621.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Alan Stern wrote:
> On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > There needs to be a public interface to this function available for 
> > > drivers that have non-tree constraints.  The arguments should be the 
> > > device to wait for and the device doing the waiting (needed only to 
> > > determine whether the caller is running synchronously or not).
> > 
> > Something like the patch below?
> 
> Yes, exactly.  Thanks.

OK, I'll put it into the patchset after 5/8.

> > > This will be necessary for USB.  In fact, your current code (with patch 
> > > 7/8 applied) is subject to a race that will sometimes cause a 
> > > non-high-speed USB device to fail to resume from hibernation.
> > 
> > That's the kind of information I need at this point.  What exactly should be
> > added to patch 7/8 to avoid this problem?
> 
> I don't think there's anything you can do about it, really.  It's an
> obscure USB issue: If an EHCI controller was reset or loses power
> during a system sleep (which always happens with hibernation and
> sometimes happens with suspend-to-RAM, depending on the chipset and
> firmware), then the EHCI controller must be resumed after all its
> sibling companion OHCI/UHCI controllers, and USB devices below the
> companion root hubs must be resumed after the EHCI root hub.
> 
> With synchronous resume this happens automatically because the devices
> in question are always registered in the appropriate order.  But the
> only way to meet these constraints with async resume is to add specific
> code to the USB core to enforce the non-tree orderings.
> 
> I intend to write this code, but merging it will be a little tricky.  
> You'll have to coordinate with Greg KH.

OK, I don't think that's a big deal.  I can defer patch 7/8 until that code has
been merged.

> If you have a non-high-speed USB device, you can test to see if this
> problem is not just a figment of my imagination.  To violate the first
> constraint, add an ssleep(1) to the beginning of ohci_pci_resume() in
> drivers/usb/host/ohci-pci.c or to the beginning of uhci_pci_resume() in
> drivers/usb/host/uhci-hcd.c (depending on whether your companion
> controllers are OHCI or UHCI).  To violate the second constraint, add
> an ssleep(1) to the beginning of ehci_bus_resume() in
> drivers/usb/host/ehci-hub.c.  Either constraint violation should cause
> the device to be disconnected and then reconnected during an async
> resume from hibernation, as opposed to simply being reset.

I'll try that, but my mkinitrd automatically puts the USB drivers into
initramfs.  I guess I'll need to do some research to really verify it. :-)

Rafael
