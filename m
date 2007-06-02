Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbXFBOtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbXFBOtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbXFBOtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:49:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2084 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759847AbXFBOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:49:46 -0400
Date: Sat, 2 Jun 2007 10:49:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michael Hanselmann <linux-kernel@hansmi.ch>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@killerfox.forkbomb.ch>
Subject: Re: [linux-usb-devel] [PATCH] Fix NEC OHCI chip silicon bug
In-Reply-To: <20070602124009.GA6991@hansmi.ch>
Message-ID: <Pine.LNX.4.44L0.0706021042360.11640-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Michael Hanselmann wrote:

> On Fri, Jun 01, 2007 at 10:19:30AM -0400, Alan Stern wrote:
> > > @@ -779,7 +790,11 @@ static int ohci_restart (struct ohci_hcd
> > >  	 */
> > >  	spin_lock_irq(&ohci->lock);
> > >  	disable (ohci);
> > > +
> > > +#ifdef CONFIG_PM
> > >  	usb_root_hub_lost_power(ohci_to_hcd(ohci)->self.root_hub);
> > > +#endif
> > > +
> 
> > Suppose CONFIG_PM isn't defined.  How are you going to let usbcore 
> > know about all the old connections which no longer exist?
> 
> You're right, something is wrong there. The patch below uses
> usb_root_hub_lost_power again but disables CONFIG_PM specific code in it
> when CONFIG_PM isn't defined. It seems to work for me with and without
> CONFIG_PM, but I have to confess I might not know enough about Linux'
> USB core. Is it better now?

Well no, even this is still wrong.

What you don't understand is how usb_root_hub_lost_power() works.  It 
doesn't actually do much of anything itself; it simply sets a flag in 
the root hub's device structure.  Then later on, when the hub driver 
is resumed it will see the flag and disconnect all the devices below 
the root hub.

In your case the last step won't work, because the hub driver will
never be resumed since it wasn't suspended to begin with.  You need to
use a completely different approach.  For instance, you could force
ohci-hcd to report connect-change events on all the ports.  Perhaps it
does something like that anyway, in which case you wouldn't have to
worry about it.

Alan Stern

