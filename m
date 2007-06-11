Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXFKTEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXFKTEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbXFKTEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:04:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:40126 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbXFKTEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOLmPkDfyAy6ONtRVd+NXW93yapY0kpArPttpg3AhlzkqGTeZbKRcpDCoeUaAM3swFJu/caXLU6flNedCqPMe7Vhm3CBKb4P9zudh0dCNvBJ2ciXlxFTlRgUzH+dlDLKPVkSlYCg6rYXLghWMLZQ1mw4ggSlc5fJRUNH5eGV6sw=
Message-ID: <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com>
Date: Mon, 11 Jun 2007 21:04:32 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: kernel BUG at mm/slub.c:3689!
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com>
	 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com>
	 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com>
	 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com>
	 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com>
	 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com>
	 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Mon, 11 Jun 2007, Håvard Skinnemoen wrote:
>
> > > Note that I do not get why you would be aligning the objects to 32 bytes.
> > > Increasing the smallest cache size wastes a lot of memory. And it is
> > > usually advantageous if multiple related objects are in the same cacheline
> > > unless you have heavy SMP contention.
> >
> > It's not about performance at all, it's about DMA buffers allocated
> > using kmalloc() getting corrupted. Imagine this:
>
> Uhhh... How about using a separate slab for the DMA buffers?

If there were just a few, known drivers that did this, sure. But as
long as Documentation/DMA-mapping.txt includes this paragraph:

    If you acquired your memory via the page allocator
    (i.e. __get_free_page*()) or the generic memory allocators
    (i.e. kmalloc() or kmem_cache_alloc()) then you may DMA to/from
    that memory using the addresses returned from those routines.

I think it's best to ensure that memory returned by kmalloc() actually
can be used for DMA. I used to work around this problem in the SPI
controller driver by using a temporary DMA buffer when possible
misalignment was detected, but David Brownell said it was the wrong
way to do it and pointed at the above paragraph.

But, as I mentioned, perhaps ARCH_KMALLOC_MINALIGN isn't the best way
to solve the problem. I'll look into the flush-caches-from-dma_unmap
approach. However, it looks like other arches set
ARCH_KMALLOC_MINALIGN to various values -- I suspect some of them
might run into the same problem as well?

hskinnemoen@dhcp-255-175:~/git/linux$ grep -r ARCH_KMALLOC_MINALIGN
include/asm-*
include/asm-mips/mach-generic/kmalloc.h:#define ARCH_KMALLOC_MINALIGN   128
include/asm-mips/mach-ip27/kmalloc.h: * All happy, no need to define
ARCH_KMALLOC_MINALIGN
include/asm-mips/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      32
include/asm-mips/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
include/asm-s390/cache.h:#define ARCH_KMALLOC_MINALIGN  8
include/asm-sh64/uaccess.h:#define ARCH_KMALLOC_MINALIGN 8

> > Maybe there are other solutions to this problem, but the old SLAB
> > allocator did guarantee 32-byte alignment as long as SLAB debugging
> > was turned off, so setting ARCH_KMALLOC_MINALIGN seemed like the
> > easiest way to get back to the old, known-working behaviour.
>
> SLABs mininum object size is 32 thus you had no problems. I see. SLAB
> does not guarantee 32 byte alignment. It just happened to work. If you
> switch on CONFIG_SLAB_DEBUG you will likely get into trouble.

Yeah, that's true. CONFIG_SLAB_DEBUG does indeed cause DMA buffer
corruption on avr32, and so does CONFIG_SLOB. I've been wanting to fix
it, but I never understood how. Now that SLUB seems to offer a
solution that doesn't effectively turn off debugging, I thought I'd
finally found it...

Haavard
