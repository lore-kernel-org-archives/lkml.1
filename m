Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbXCFMLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbXCFMLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934097AbXCFMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:11:09 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:42784 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094AbXCFMLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:11:07 -0500
Date: Tue, 6 Mar 2007 12:11:03 +0000
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Tejun Heo <htejun@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       ipslinux@adaptec.com
Subject: Re: kref refcounting breakage in mainline
Message-ID: <20070306121102.GA367@skynet.ie>
References: <20070302005833.949be737.akpm@linux-foundation.org> <20070306002521.GA12164@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070306002521.GA12164@kroah.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/03/07 16:25), Greg KH didst pronounce:
> On Fri, Mar 02, 2007 at 12:58:33AM -0800, Andrew Morton wrote:
> > 
> > -mm has a debugging patch which warns when atomic_dec_and_test() takes an
> > atomic_t negative
> > (ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/detect-atomic-counter-underflows.patch).
> > 
> > 
> > When it is applied to current mainline, a simple `rmmod ipw2200' gives:
> > 
> > [   75.825072] BUG: atomic counter underflow at:
> > [   75.825180]  [<c01c6eb4>] kref_put+0x66/0x82
> > [   75.825278]  [<c022e4d4>] bus_remove_driver+0x66/0x75
> > [   75.825383]  [<c022ee2c>] driver_unregister+0x8/0x13
> > [   75.825484]  [<c01d7add>] pci_unregister_driver+0xc/0x45
> > [   75.825593]  [<c0132147>] sys_delete_module+0x157/0x17c
> > [   75.825703]  [<c013c663>] audit_syscall_entry+0x10d/0x137
> > [   75.825818]  [<c0103b14>] syscall_call+0x7/0xb
> > [   75.825913]  [<c02d0000>] xfrm4_dst_destroy+0xe/0xd5
> > 
> > This didn't happen in 2.6.20-mm2, so this bug was introduced by a patch
> > which was not in the -mm lineup twelve days ago.
> > 
> > Presumably the effect of this is a memory leak or a use-after-free.
> 
> Ok, after a zillion bisects, I've tracked this down to:
> 	commit 63ce18cfe685115ff8d341bae4c9204a79043cf0
> 	Author: Mike Galbraith <efault@gmx.de>
> 	Date:   Wed Feb 21 12:45:35 2007 -0800
> 
> 	    driver core: refcounting fix
> 	    
> 	    Fix a reference counting bug exposed by commit
> 	    725522b5453dd680412f2b6463a988e4fd148757.  If driver.mod_name exists, we
> 	    take a reference in module_add_driver(), and never release it.  Undo that
> 	    reference in module_remove_driver().
> 	    
> 	    Signed-off-by: Mike Galbraith <efault@gmx.de>
> 	    Cc: Kay Sievers <kay.sievers@vrfy.org>
> 	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 	    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 	
> 

On http://test.kernel.org, elm3b132 is showing a similar error message for
the IPS driver on 2.6.21-rc2-mm1. There is no such device in the machine so
this is a normal error path for no devices found. The warning looks like

BUG: atomic counter underflow at:
 [<c027ccb4>] kref_put+0x7d/0x9d
 [<c02a4e38>] bus_remove_driver+0x36/0x41
 [<c02a5997>] driver_unregister+0xb/0x13
 [<c0286bdd>] pci_unregister_driver+0xb/0x13
 [<c04c653a>] ips_module_init+0x41/0x57
 [<c04b2bd2>] do_initcalls+0x58/0xf5
 [<c01353d5>] register_irq_proc+0x75/0x92
 [<c04b2c97>] init+0x0/0x8b
 [<c04b2ce0>] init+0x49/0x8b
 [<c01030ff>] kernel_thread_helper+0x7/0x10

This is essentially identical to the warning on ipw2200. It occurs whether
the driver is compiled into the kernel or as a module.  Reverting Mike's
patch fixes the problem - or at least the warning has disappeared.

However, I've cc'd the IPS maintainers so they can confirm they are
calling pci_unregister_driver() correctly. I note that many drivers in
drivers/scsi do not call pci_unregister_driver() in the module_init path.
ipw2200 also calls pci_unregister_driver() in the module_init path when
an error is encountered.

So, maybe this is an error in how the drivers use pci_[un]register_driver()
instead of a problem with Mike's patch?

> Mike, I've reverted this patch, and I don't see any references leaking.
> And, as your patch released the reference on the driver, and the
> module_add_driver() call would not grab a reference to the driver, only
> the module kobject, I don't see what you were trying to fix with this
> patch.
> 
> Do you have a test case that this fixes?
> 
> Otherwise, I'll just revert it.
> 
> thanks,
> 
> greg k-h
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
