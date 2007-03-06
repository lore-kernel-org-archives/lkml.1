Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXCFA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXCFA06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXCFA05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:26:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbXCFA04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:26:56 -0500
Date: Mon, 5 Mar 2007 16:25:21 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <htejun@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: kref refcounting breakage in mainline
Message-ID: <20070306002521.GA12164@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302005833.949be737.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 12:58:33AM -0800, Andrew Morton wrote:
> 
> -mm has a debugging patch which warns when atomic_dec_and_test() takes an
> atomic_t negative
> (ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/detect-atomic-counter-underflows.patch).
> 
> 
> When it is applied to current mainline, a simple `rmmod ipw2200' gives:
> 
> [   75.825072] BUG: atomic counter underflow at:
> [   75.825180]  [<c01c6eb4>] kref_put+0x66/0x82
> [   75.825278]  [<c022e4d4>] bus_remove_driver+0x66/0x75
> [   75.825383]  [<c022ee2c>] driver_unregister+0x8/0x13
> [   75.825484]  [<c01d7add>] pci_unregister_driver+0xc/0x45
> [   75.825593]  [<c0132147>] sys_delete_module+0x157/0x17c
> [   75.825703]  [<c013c663>] audit_syscall_entry+0x10d/0x137
> [   75.825818]  [<c0103b14>] syscall_call+0x7/0xb
> [   75.825913]  [<c02d0000>] xfrm4_dst_destroy+0xe/0xd5
> 
> This didn't happen in 2.6.20-mm2, so this bug was introduced by a patch
> which was not in the -mm lineup twelve days ago.
> 
> Presumably the effect of this is a memory leak or a use-after-free.

Ok, after a zillion bisects, I've tracked this down to:
	commit 63ce18cfe685115ff8d341bae4c9204a79043cf0
	Author: Mike Galbraith <efault@gmx.de>
	Date:   Wed Feb 21 12:45:35 2007 -0800

	    driver core: refcounting fix
	    
	    Fix a reference counting bug exposed by commit
	    725522b5453dd680412f2b6463a988e4fd148757.  If driver.mod_name exists, we
	    take a reference in module_add_driver(), and never release it.  Undo that
	    reference in module_remove_driver().
	    
	    Signed-off-by: Mike Galbraith <efault@gmx.de>
	    Cc: Kay Sievers <kay.sievers@vrfy.org>
	    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
	    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
	

Mike, I've reverted this patch, and I don't see any references leaking.
And, as your patch released the reference on the driver, and the
module_add_driver() call would not grab a reference to the driver, only
the module kobject, I don't see what you were trying to fix with this
patch.

Do you have a test case that this fixes?

Otherwise, I'll just revert it.

thanks,

greg k-h
