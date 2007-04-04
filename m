Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXDDSCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXDDSCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXDDSCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:02:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45686 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbXDDSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:02:37 -0400
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
	 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
	 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:02:35 -0700
Message-Id: <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:03 -0700, Christoph Lameter wrote:
> On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> 
> > On Tue, 2007-04-03 at 16:55 -0700, Christoph Lameter wrote:
> > > On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> > > 
> > > > Hmm. booted fine with slub_debug :(
> > > 
> > > Try to selectively disable debug options... if you got the 
> > > time...
> > > 
> > > F.e. Try with sanity checks only
> > > 
> > > slub_debug=F
> > 
> > slub_debug=F got something. 
> 
> Ahh.... Seems that the first 4 bytes of the allocations is zapped after 
> the object has been freed. Can you trap writes to the first four bytes of 
> the object? This should give you the culprit.
> 
> The other thing is that the system is performing DMA allocations
> for the file cache???? Then its running out of memory.
> 
> Argh.... We use  GFP DMA bitmask to check SLAB flags field:
> 
> Try this fix:
> 
> 
> 
> SLUB: Use correct flags to check for DMA cache
> 
> We use a GFP mask to check the SLAB flags if this is a DMA cache.
> 
> Fix this by using the correct SLAB mask and then use the SLUB_DMA
> for the ORing of flags. If the system does not support DMA then
> we will OR zero which will hopefully get the compiler to drop the
> useless if statement as well.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.21-rc5-mm4/mm/slub.c
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-04 09:59:05.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-04 10:01:14.000000000 -0700
> @@ -678,8 +678,8 @@ static struct page *allocate_slab(struct
>  	if (s->order)
>  		flags |= __GFP_COMP;
>  
> -	if (s->flags & SLUB_DMA)
> -		flags |= GFP_DMA;
> +	if (s->flags & SLAB_CACHE_DMA)
> +		flags |= SLUB_DMA;
>  
>  	if (node == -1)
>  		page = alloc_pages(flags, s->order);
> 


Machine booted fine with slub_debug=F. Got following in the
log. I guess we need to track down who is touching after
free. Any ideas on how I can track down easily ? Is there
a way to store last allocated (function, line#) and look
around there ?

Thanks,
Badari

*** SLUB: Freepointer corrupt in kmalloc-16@0xffff810173f172a0 Slab
0xffff81017f9f8b80
    offset=672 flags=0x2000000000000c7 inuse=42
freelist=0xffff810173f172a0
  Bytes b4 0xffff810173f17290:  a0 72 f1 73 00 00 00 00 00 00 00 00 00
00 00 00 .r\uffffs............
    Object 0xffff810173f172a0:  00 00 00 00 01 81 ff ff 00 00 00 00 00
00 00 00 ......\uffff\uffff........
FreePointer 0xffff810173f172a0 -> 0xffff810100000000

Call Trace:
 [<ffffffff802840e5>] object_err+0x105/0x1b0
 [<ffffffff80284485>] check_object+0x1b5/0x1d0
 [<ffffffff80284ad4>] alloc_object_checks+0x64/0x110
 [<ffffffff8028611c>] kmem_cache_alloc+0xfc/0x1a0
 [<ffffffff802dcb27>] sysfs_create_link+0xb7/0x160
 [<ffffffff8024f431>] module_add_driver+0x41/0xd0
 [<ffffffff8040241e>] bus_add_driver+0xce/0x1d0
 [<ffffffff8040324d>] driver_register+0x5d/0x90
 [<ffffffff803a16a8>] __pci_register_driver+0x68/0xb0
 [<ffffffff806d6066>] agp_amd64_init+0x36/0xe0
 [<ffffffff806c3ad6>] gart_iommu_init+0x4c6/0x560
 [<ffffffff80227a8e>] __wake_up+0x4e/0x70
 [<ffffffff80495eb0>] genl_rcv+0x0/0x70
 [<ffffffff8049432c>] netlink_kernel_create+0x14c/0x160
 [<ffffffff80495cd0>] genl_unlock+0x10/0x40
 [<ffffffff806bc8de>] pci_iommu_init+0xe/0x20
 [<ffffffff806b2a04>] kernel_init+0x154/0x330
 [<ffffffff8020a8c8>] child_rip+0xa/0x12
 [<ffffffff806b28b0>] kernel_init+0x0/0x330
 [<ffffffff8020a8be>] child_rip+0x0/0x12


