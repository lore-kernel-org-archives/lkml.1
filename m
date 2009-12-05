Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZLEChm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZLEChm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZLEChm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:37:42 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48065 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753756AbZLEChl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:37:41 -0500
Date: Fri, 4 Dec 2009 21:37:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, <stable@kernel.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <20091205003533.GD8792@suse.de>
Message-ID: <Pine.LNX.4.44L0.0912042113440.7227-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Greg KH wrote:

> On Fri, Dec 04, 2009 at 06:50:35PM -0500, Alan Stern wrote:
> > On Fri, 4 Dec 2009, Dmitry Torokhov wrote:
> > 
> > > > Maybe reference counting is inelegant; it depends on your point of
> > > > view.  Can you think of a more elegant way to make sure that a pointer
> > > > isn't stale?
> > > 
> > > Yes, just say "no" to device_create() and friends.
> > 
> > device_create() wasn't used in the case Oliver is discussing.
> 
> It was implied, as you had a pointer to the device, not the device
> itself.

Not necessarily.  For example, the serial drivers have pointers to 
struct tty, not the tty structures themselves.  That doesn't imply the 
tty structures were constructed using device_create().

> > >  Embed device structure in
> > > yours,
> > 
> > You can't do that when the device structure wasn't created by your 
> > driver.
> 
> But for USB devices, it is part of the device you are handed.  Same goes
> for PCI devices, and most other types of drivers, right?

Yes.  Dmitry's word "yours" is ambiguous here.  It's true that struct
pci_device contains an embedded struct device.  But for example, struct
ehci_hcd doesn't -- even when the EHCI controller is a PCI device.  So
if you are the ehci-hcd driver, which structure is "yours": the struct
pci_device or the struct ehci_hcd?

> > >  be mindful of lifetime rules and only use "your" device (i.e device
> > > bound to your driver).
> > 
> > What do you mean by "use"?  In Oliver's case he wasn't using the
> > device, he was using the device structure.  (Maybe that's what you
> > meant.)
> 
> I think that is what is meant here.
> 
> > And he wanted to use it at a time when it wasn't bound to his
> > driver, because userspace still had an open file reference to it.  
> > There isn't really any way around this.
> 
> But you still have a valid device, just not maybe a driver bound to it.

If a driver isn't bound to it then you don't know whether the device
structure is valid or not.  It could have been deallocated.  Unless
you have taken a reference to it -- then you know.

Alan Stern

