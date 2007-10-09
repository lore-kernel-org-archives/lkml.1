Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXJIDHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXJIDHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXJIDHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:07:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49410 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXJIDHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:07:33 -0400
Date: Mon, 8 Oct 2007 20:10:49 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
Message-ID: <20071009031049.GD14127@kroah.com>
References: <20071006.235358.104048815.davem@davemloft.net> <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071007.005156.85395415.davem@davemloft.net> <20071008.165420.42793456.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008.165420.42793456.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 04:54:20PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 07 Oct 2007 00:51:56 -0700 (PDT)
> 
> > From: David Brownell <david-b@pacbell.net>
> > Date: Sun, 07 Oct 2007 00:31:41 -0700
> > 
> > > Are the other ports still behaving?  Is EHCI maybe trying to switch
> > > ownership of that port?  Is maybe the (newish) autosuspend stuff
> > > kicking in?
> > 
> > I wouldn't know, the machine hangs and doesn't get any further.
> 
> To add some more information here, I think the EHCI idea might
> hold some water.
> 
> What I have here are two NEC OHCI USB interfaces and one NEC EHCI
> USB interface on PCI.  Aparently they all go through a shared
> USB hub, mapped like this:
> 
> HUB Port 1: OHCI #1, EHCI
> HUB Port 2: OHCI #2, EHCI
> HUB Port 3: OHCI #1, EHCI
> HUB Port 4: OHCI #2, EHCI
> HUB Port 5: OHCI #1, EHCI
> 
> The OHCI ports go out to external USB connectors on the back panel of
> the machine, whereas the EHCI is connected up to an internal USB
> storage CDROM device and what appears to be another USB hub.
> 
> The problem seems to be very strongly tied to timing.  For example
> simply adding "ignore_loglevel" to the kernel boot command line can
> make the problem go away.
> 
> This got me thinking about your EHCI comment.
> 
> If these controllers are going through the same HUB, things might go
> south if OHCI initialized first, then khubd et al. are asynchronously
> accessing the segments behind OHCI at the same time that the EHCI
> driver is initializing.  Perhaps, this is the kind of sequence of
> events which makes one of the root ports reset in such a way that the
> the reset bit never clears.
> 
> Given that this machine has 64 cpus, the likelyhood for such parallel
> accesses is very likely :-)
> 
> Does this make any sense?

Yes it does, I'm seeing reports from some hardware companies of the very
same thing.  If you serialize and load the ehci driver first, and then
the ohci driver, that should fix the problem.

Does that also work for you?  Or are these drivers built into the
kernel?

thanks,

greg k-h
