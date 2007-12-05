Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXLEXv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXLEXv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXLEXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:51:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:52376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXLEXvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:51:51 -0500
Date: Thu, 6 Dec 2007 00:51:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: akpm@linux-foundation.org, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] ieee1394: nopage
Message-ID: <20071205235149.GD5617@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.360419000@nick.local0.net> <4756A31C.5060405@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756A31C.5060405@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 02:09:48PM +0100, Stefan Richter wrote:
> npiggin@suse.de wrote:
> > Convert ieee1394 from nopage to fault.
> > Remove redundant vma range checks (correct resource range check is retained).
> 
> I never really looked into that part of the 1394 drivers and I'm too
> lazy to figure this out myself, so I ask:  What would trip the .fault
> handler?  Would be good if I could runtime-test it.

mmap()ing a device file for that driver, and accessing the memory.

 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > Cc: krh@redhat.com
> 
> It's an obscure and unimportant detail but I mention it nevertheless:
> It's not necessary to Cc krh on drivers/ieee1394 stuff.  He is more into
> drivers/firewire. :-)

OK, I'll try to keep it straight ;)

> > +	if (vmf->pgoff >= dma->n_pages)
> > +		goto error;
> > +
> > +	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
> > +	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
> > +	get_page(vmf->page);
> > +	return 0;
> > +
> > +      error:
> > +	return VM_FAULT_SIGBUS;
> >  }
> 
> Why not replacing the two 'goto error' by 'return VM_FAULT_SIGBUS'?  If
> there is no cleanup after that error jump, I find it sensible to return
> early.

Fair enough, I just didn't want to gamut of reactions from maintainers
to my cleanups ;)


> >  static struct vm_operations_struct dma_region_vm_ops = {
> > -	.nopage = dma_region_pagefault,
> > +	.fault = dma_region_pagefault,
> >  };
> >  
> >  /**
> > @@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
> >  	if (!dma->kvirt)
> >  		return -EINVAL;
> >  
> > -	/* must be page-aligned */
> > +	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
> >  	if (vma->vm_pgoff != 0)
> >  		return -EINVAL;
> >  
> 
> Are you sure that the comment is wrong?  Could it be that there are
> assumptions elsewhere which require page alignment?  (I should be able
> to answer that, but I'm not.)

The file offset given to mmap must be page size multiple, and thus vm_pgoff
is in units of page size (see the fault handler, where it gets shifted).
Removing this restriction would allow the use of offset in mmap(), but if
you want to disallow it for other reasons, then I guess the comment
should be changed to explain why.

