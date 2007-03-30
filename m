Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbXC3OSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbXC3OSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXC3OSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:18:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:55441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXC3OSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:18:33 -0400
Date: Fri, 30 Mar 2007 07:16:40 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known
	regressions"
Message-ID: <20070330141639.GA10387@suse.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330120416.GA19373@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 02:04:16PM +0200, Ingo Molnar wrote:
> 
> i just found a new category of driver regressions in 2.6.21, doing 
> allyesconfig bzImage bootup tests: the init methods of various drivers 
> hangs in driver_unregister().
> 
> It is caused by this problem: the semantics of driver_unregister() [also 
> implicitly called in pci_driver_unregister()] has apparently changed 
> recently. If a driver does:
> 
> 	pci_register_driver(&my_driver);
> 	...
> 	if (some_failure) {
> 		pci_unregister_driver(&my_driver);
> 		...
> 	}
> 
> it will hang the bootup in the following piece of code:
> 
>  drivers/base/driver.c:
> 
>   void driver_unregister(struct device_driver * drv)
>   {
>          bus_remove_driver(drv);
>          wait_for_completion(&drv->unloaded);
> 
> the completion is never done - because nobody removes the bus while the 
> init is still happening, obviously. (and bootup is serialized anyway)
> 
> now, the majority of drivers does the driver unregistry from its 
> module-cleanup function, so it's not affected by this problem. But if 
> you apply the debug patch attached further below, and do an allyesconfig 
> bzImage bootup, there's 3 hits already:
> 
>  BUG: at drivers/base/driver.c:187 driver_unregister()
>   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
>   [<c01063e2>] show_trace+0x12/0x14
>   [<c01063f8>] dump_stack+0x14/0x16
>   [<c063f7e6>] driver_unregister+0x3d/0x43
>   [<c0488048>] pci_unregister_driver+0x10/0x5f
>   [<c1b5f7c7>] slgt_init+0x9b/0x1ca
>   [<c1b31a2d>] init+0x15d/0x2bd
>   [<c0105bc3>] kernel_thread_helper+0x7/0x10
> 
>  BUG: at drivers/base/driver.c:187 driver_unregister()
>   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
>   [<c01063e2>] show_trace+0x12/0x14
>   [<c01063f8>] dump_stack+0x14/0x16
>   [<c063f7e6>] driver_unregister+0x3d/0x43
>   [<c0488048>] pci_unregister_driver+0x10/0x5f
>   [<c0619505>] init_ipmi_si+0x70a/0x738
>   [<c1b31a2d>] init+0x15d/0x2bd
>   [<c0105bc3>] kernel_thread_helper+0x7/0x10
> 
>  BUG: at drivers/base/driver.c:187 driver_unregister()
>   [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
>   [<c01063e2>] show_trace+0x12/0x14
>   [<c01063f8>] dump_stack+0x14/0x16
>   [<c063f7e6>] driver_unregister+0x3d/0x43
>   [<c0488048>] pci_unregister_driver+0x10/0x5f
>   [<c1b6d2d8>] tlan_probe+0x2dd/0x30e
>   [<c1b31a2d>] init+0x15d/0x2bd
>   [<c0105bc3>] kernel_thread_helper+0x7/0x10
> 
> possibly more could trigger. Each of these 3 places caused an actual 
> bootup hang on my testbox, so these are real regressions and need to be 
> fixed.
> 
> because there are a good number of drivers that do 
> pci_unregister_device() from their init function, and because i cannot 
> see anything obviously wrong in doing an unregister call after a 
> failure, i think it's driver_unregister() that needs to be fixed. Greg, 
> what do you think?

Yes, we should allow the ability to call unregister_driver from within
the module_init function.

But I don't understand what is causing you to see this problem.  Who is
holding the reference on the struct device at this point in time?  Is it
the fact that userspace has some files open and it hasn't released them
yet?

I don't see anything implicit in the driver_unregister() path that
should not work from within the module_init() path.  Kay, am I missing
anything here?

(patch left below for Kay's benefit)

thanks,

greg k-h

> Index: linux/drivers/base/driver.c
> ===================================================================
> --- linux.orig/drivers/base/driver.c
> +++ linux/drivers/base/driver.c
> @@ -183,7 +183,8 @@ int driver_register(struct device_driver
>  void driver_unregister(struct device_driver * drv)
>  {
>  	bus_remove_driver(drv);
> -	wait_for_completion(&drv->unloaded);
> +	if (!drv->unloaded.done)
> +		WARN_ON(1);
>  }
>  
>  /**
