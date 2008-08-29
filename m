Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYH2RTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYH2RTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYH2RTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:19:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2435 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751553AbYH2RTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:19:10 -0400
Date: Fri, 29 Aug 2008 13:19:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Scott Wood <scottwood@freescale.com>, <dbrownell@users.sourceforge.net>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
 driver
In-Reply-To: <200808291829.48939.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.0808291307050.4447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Arnd Bergmann wrote:

> On Friday 29 August 2008, Alan Stern wrote:
> > > The standard requires that there can only be one protocol handler
> > > per physical interface, which is a reasonable limitation.
> > 
> > No, you've got it exactly backward.  There can be multiple protocol 
> > handlers per physical interface, but there must be only one physical 
> > interface per device.
> 
> Maybe I am using wrong terminology, but I still don't see how that
> fits together. Let me try to explain what I have understood so far:
> 
> The physical device is identified by a struct usb_gadget is defined
> statically in the driver that exports the
> usb_gadget_{un,}register_driver() functions. Obviously there can only
> be one physical interface per physical device, I was not arguing
> against that.

I thought you _were_ arguing against that.  Unless I misunderstood,
your original complaint was that since each peripheral controller
driver defines usb_gadget_{un}register_driver, there can be only one
controller driver loaded at a time.

However see below...

> The protocol handler is identified by a usb_gadget_driver and defined
> in a driver that calls usb_gadget_register_driver().
> You say that there can be multiple protocol handlers, which I don't
> understand because the protocol handlers all call set_gadget_data,
> which overwrites the previous driver_data field in struct usb_gadget,
> making it impossible to load more than one simultaneously.

It's a new feature, only recently added to the kernel and not fully 
implemented yet.  The protocol handlers are encapsulated as "function" 
drivers, where multiple functions can be combined at link time into a 
single gadget.

> > > However, what the Linux implementation actually enforces is
> > > that there can only be one hardware specific driver built or loaded
> > > into the kernel, which just looks like an arbitrary restriction
> > > that does not actually help.
> > 
> > Not at all -- it is an implementation of the constraint that there be 
> > only one physical interface.
> 
> How that? Taking drivers/usb/gadget/fsl_usb2_udc.c as an example, it will
> create a new fsl_udc structure for each matching platform_device it finds
> (though it will leak every one except the last one), so the interface
> does not limit the number of physical interfaces at all to this point,
> the implementation of the every gadget hardware driver does this.

fsl_usb2_udc isn't a good example; its behavior is not typical.  Other
peripheral hardware drivers behave differently -- they define a single
static structure (or a dynamic singleton structure) and expect the
platform to contain no more than one matching device.  Look at
lh7a40x_udc.c for a more typical example.

> The real problem is that you cannot build a kernel that has both
> fsl_usb2_udc.c and fsl_qe_udc.c built in. Having both drivers loaded
> would not violate the one-interface rule, because only one of them
> would find hardware to bind to on a given system, just like you can
> load both the uhci and ohci drivers without them interfering.

I see your point.  Even worse, you can't build both of them as modules.

Personally I wouldn't mind relaxing the "one interface per device" 
rule.  But I'm not the Gadget maintainer...

(There is another problem.  If you have multiple peripheral interfaces,
how would you specify which one a particular gadget driver should bind
to?)

Alan Stern

