Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXC3Teq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXC3Teq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXC3Teq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:34:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXC3Tep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:34:45 -0400
Date: Fri, 30 Mar 2007 12:32:58 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known
	regressions"
Message-ID: <20070330193258.GA7403@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070330141639.GA10387@suse.de> <20070330174619.GA12589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330174619.GA12589@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 07:46:19PM +0200, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > >  BUG: at drivers/base/driver.c:187 driver_unregister()
> > >   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
> > >   [<c01063e2>] show_trace+0x12/0x14
> > >   [<c01063f8>] dump_stack+0x14/0x16
> > >   [<c063f7e6>] driver_unregister+0x3d/0x43
> > >   [<c0488048>] pci_unregister_driver+0x10/0x5f
> > >   [<c1b5f7c7>] slgt_init+0x9b/0x1ca
> > >   [<c1b31a2d>] init+0x15d/0x2bd
> > >   [<c0105bc3>] kernel_thread_helper+0x7/0x10
> 
> > Yes, we should allow the ability to call unregister_driver from within 
> > the module_init function.
> > 
> > But I don't understand what is causing you to see this problem.  Who 
> > is holding the reference on the struct device at this point in time?  
> > Is it the fact that userspace has some files open and it hasn't 
> > released them yet?
> 
> at least in the slgt_init() case the affected codepath is trivial:
> 
>         if ((rc = pci_register_driver(&pci_driver)) < 0) {
>                 printk("%s pci_register_driver error=%d\n", driver_name, rc);
>                 return rc;
>         }
>         pci_registered = 1;
> 
>         if (!slgt_device_list) {
>                 printk("%s no devices found\n",driver_name);
>                 pci_unregister_driver(&pci_driver);
>                 return -ENODEV;
> 
> slgt_device_list is NULL because no matching PCI ID is on my system (i 
> dont have this hardware), so the ->probe() function did not get called 
> at all.

Sorry, no, I realize how this could happen in the driver, I just don't
see what in the driver core would be keeping this driver from having
it's release function called at the unregister() time.

Something has grabbed a reference to the driver...

Oh wait, is this code a module or built into the kernel?

If it's built in, there's still a reference counting bug in the
module/driver hookup logic as we really don't have a "module" yet we are
still thinking we do as we represent it in /sys/module and create the
linkages.

I created some horrible patches to try to track this down, as it was
reported on lkml (look for "Subject: kref refcounting breakage in mainline" )
but never got it working correctly.

I bet if you build that code as a module, it will work just fine, can
you try it?

Kay, did you ever get a chance to look into this reference counting
issue?

thanks,

greg k-h
