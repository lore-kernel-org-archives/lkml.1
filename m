Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXISJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXISJ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXISJ17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:27:59 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:40665 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXISJ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:27:58 -0400
Date: Wed, 19 Sep 2007 10:34:00 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [00/17] [RFC] Virtual Compound Page Support
Message-Id: <20070919103400.7bc8ffd9.dada1@cosmosbay.com>
In-Reply-To: <3A6E599E-07AC-4273-8643-ADFC8014D3E6@cam.ac.uk>
References: <20070919033605.785839297@sgi.com>
	<3A6E599E-07AC-4273-8643-ADFC8014D3E6@cam.ac.uk>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 08:34:47 +0100
Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> Hi Christoph,
> 
> On 19 Sep 2007, at 04:36, Christoph Lameter wrote:
> > Currently there is a strong tendency to avoid larger page  
> > allocations in
> > the kernel because of past fragmentation issues and the current
> > defragmentation methods are still evolving. It is not clear to what  
> > extend
> > they can provide reliable allocations for higher order pages (plus the
> > definition of "reliable" seems to be in the eye of the beholder).
> >
> > Currently we use vmalloc allocations in many locations to provide a  
> > safe
> > way to allocate larger arrays. That is due to the danger of higher  
> > order
> > allocations failing. Virtual Compound pages allow the use of regular
> > page allocator allocations that will fall back only if there is an  
> > actual
> > problem with acquiring a higher order page.
> >
> > This patch set provides a way for a higher page allocation to fall  
> > back.
> > Instead of a physically contiguous page a virtually contiguous page
> > is provided. The functionality of the vmalloc layer is used to provide
> > the necessary page tables and control structures to establish a  
> > virtually
> > contiguous area.
> 
> I like this a lot.  It will get rid of all the silly games we have to  
> play when needing both large allocations and efficient allocations  
> where possible.  In NTFS I can then just allocated higher order pages  
> instead of having to mess about with the allocation size and  
> allocating a single page if the requested size is <= PAGE_SIZE or  
> using vmalloc() if the size is bigger.  And it will make it faster  
> because a lot of the time a higher order page allocation will succeed  
> with your patchset without resorting to vmalloc() so that will be a  
> lot faster.
> 
> So where I currently have fs/ntfs/malloc.h the below mess I could get  
> rid of it completely and just use the normal page allocator/ 
> deallocator instead...
> 
> static inline void *__ntfs_malloc(unsigned long size, gfp_t gfp_mask)
> {
>          if (likely(size <= PAGE_SIZE)) {
>                  BUG_ON(!size);
>                  /* kmalloc() has per-CPU caches so is faster for  
> now. */
>                  return kmalloc(PAGE_SIZE, gfp_mask & ~__GFP_HIGHMEM);
>                  /* return (void *)__get_free_page(gfp_mask); */
>          }
>          if (likely(size >> PAGE_SHIFT < num_physpages))
>                  return __vmalloc(size, gfp_mask, PAGE_KERNEL);
>          return NULL;
> }
> 
> And other places in the kernel can make use of the same.  I think XFS  
> does very similar things to NTFS in terms of larger allocations at  
> least and there are probably more places I don't know about off the  
> top of my head...
> 
> I am looking forward to your patchset going into mainline.  (-:

Sure, it sounds *really* good. But...

1) Only power of two allocations are good candidates, or we waste RAM

2) On i386 machines, we have a small vmalloc window. (128 MB default value)
  Many servers with >4GB memory (PAE) like to boot with vmalloc=32M option to get 992MB of LOWMEM.
  If we allow some slub caches to fallback to vmalloc land, we'll have problems to tune this.

3) A fallback to vmalloc means an allocation of one vm_struct per compound page.

4) vmalloc() currently uses a linked list of vm_struct. Might need something more scalable.

