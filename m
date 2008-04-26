Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYDZUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYDZUMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbYDZUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:12:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1313 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759196AbYDZUMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:12:24 -0400
Date: Sat, 26 Apr 2008 16:12:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [GIT PATCH] USB patches for 2.6.25-git
In-Reply-To: <20080426002004.GA23817@suse.de>
Message-ID: <Pine.LNX.4.44L0.0804261114090.31732-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, Greg KH wrote:

> On Fri, Apr 25, 2008 at 04:51:51PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 24 Apr 2008, Greg KH wrote:
> > >
> > > Here is a set of USB patches against your current git tree.
> > 
> > Hmm. This seesm to have brought with it some new errors.
> > 
> > >From my dmesg:
> > 
> > 	ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
> > 	PCI: Setting latency timer of device 0000:00:1a.1 to 64
> > 	uhci_hcd 0000:00:1a.1: UHCI Host Controller
> > 	uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> > 	uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
> > 	usb usb4: configuration #1 chosen from 1 choice
> > 	hub 4-0:1.0: USB hub found
> > 	hub 4-0:1.0: 2 ports detected
> > **	hub 1-0:1.0: unable to enumerate USB device on port 4
> > 	usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> > 	usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > 	usb usb4: Product: UHCI Host Controller
> > 	usb usb4: Manufacturer: Linux 2.6.25-05086-g3dd7b71 uhci_hcd
> > 	usb usb4: SerialNumber: 0000:00:1a.1
> > 
> > there's a few of them there, and they seem to be new (ie they don't show 
> > up in my previous message logs). dmesg | grep shows a total of four:
> > 
> > 	hub 1-0:1.0: unable to enumerate USB device on port 4
> > 	hub 2-0:1.0: unable to enumerate USB device on port 2
> > 	hub 2-0:1.0: unable to enumerate USB device on port 3
> > 	hub 2-0:1.0: unable to enumerate USB device on port 4
> > 
> > but things seem to work. Whether that is because I don't have anything 
> > *connected* at those ports or not, I don't know ;)
> 
> This was always happening before, but now we are actually logging the
> error.  Commit 6427f7995338387ddded92f98adec19ddbf0ae5e was the one, and
> Alan Stern added it to the tree to help try to determine some reports
> that people had been having at times.
> 
> It should be harmless, right Alan?

That's right.  For some reason those hubs must report connections on 
those ports even though nothing is actually attached.  When the kernel 
tries to enumerate them, naturally it fails.

Previously there were error pathways in the enumeration code in which
we would never log an error message, which meant that people had no
indication there really was a problem.  That's why this message was 
added.

But it looks like the new message may show up more often than we want.  
I've seen it happen when a low- or full-speed device is plugged into a
high-speed bus, because of the port handover.  This may be the same
sort of thing or it may be something different; I can't tell without
the verbose USB debugging log.

In any event the message is indeed harmless.  It doesn't represent a 
real change in behavior; it simply reports a potential error that 
previously would go unreported.

Alan Stern

