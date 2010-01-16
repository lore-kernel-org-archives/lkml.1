Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0APH0L (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 02:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580Ab0APH0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 02:26:07 -0500
Received: from www84.your-server.de ([213.133.104.84]:38969 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0APH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 02:26:06 -0500
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
        Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20100115233820.GF10591@ovro.caltech.edu>
References: <1263546418.9732.11.camel@wall-e>
	 <20100115192029.GC10591@ovro.caltech.edu> <1263591001.7531.1.camel@wall-e>
	 <20100115220153.GE10591@ovro.caltech.edu> <1263593107.8935.1.camel@wall-e>
	 <20100115233820.GF10591@ovro.caltech.edu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Jan 2010 08:25:50 +0100
Message-ID: <1263626750.13343.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 15.01.2010, 15:38 -0800 schrieb Ira W. Snyder:
> On Fri, Jan 15, 2010 at 11:05:07PM +0100, Stefani Seibold wrote:
> > Am Freitag, den 15.01.2010, 14:01 -0800 schrieb Ira W. Snyder:
> > > On Fri, Jan 15, 2010 at 10:30:01PM +0100, Stefani Seibold wrote:
> > > > 
> > > > > I'm glad to see this example, it really illustrates how to use the new
> > > > > DMA functionality of the kfifo API.
> > > > > 
> > > > > Is there any reason why a very large scatterlist could not be used? I
> > > > > have a driver that uses a large scatterlist (~4000 entries, allocated as
> > > > > a struct sg_table). I implemented my own copy_from_user() functionality
> > > > > into this scatterlist, but I'd love to use the kfifo DMA API instead.
> > > > > After filling the scatterlist, I use the usual DMA API's to transfer it
> > > > > to my device.
> > > > > 
> > > > 
> > > > No, but the API will only return max. two entries.
> > > > 
> > > 
> > > Ah, I see. __kfifo_alloc() uses kmalloc() internally. The kfifo API will
> > > not work for my purposes then, since I want to allocate a 16MB chunk of
> > > memory, and I'm very uncomfortable doing that with kmalloc(). I'll stick
> > > with my custom scatterlist code, which uses alloc_page() to fill in the
> > > scatterlist with order-0 allocations.
> > > 
> > 
> > I think you can use vmalloc() instead and assign this buffer with
> > kfifo_init().
> > 
> 
> Yes, that might be an option. I presume I could still use dma_map_sg()
> on the resulting scatterlist.
> 
> > > Another nitpick in the code: I've noticed that you use sgl++ in the
> > > setup_sgl() function. That should become "sgl = sg_next(sgl);" so that
> > > this code can work with an struct sg_table as well.
> > 
> > No, its by definition an array. You cannot pass as struct sg_table to
> > the kfifo_dma_* functions.
> > 
> 
> A struct sg_table is a container for an underlying chain of struct
> scatterlists, allowing for easier allocation. See the definition of
> struct sg_table and the sgl member (include/linux/scatterlist.h line
> 11).
> On Fri, Jan 15, 2010 at 11:05:07PM +0100, Stefani Seibold wrote:
> > > Am Freitag, den 15.01.2010, 14:01 -0800 schrieb Ira W. Snyder:
> > > 
> > > > Ah, I see. __kfifo_alloc() uses kmalloc() internally. The kfifo API will
> > > > not work for my purposes then, since I want to allocate a 16MB chunk of
> > > > memory, and I'm very uncomfortable doing that with kmalloc(). I'll stick
> > > > with my custom scatterlist code, which uses alloc_page() to fill in the
> > > > scatterlist with order-0 allocations.
> > > > 
> > > 
> > > I think you can use vmalloc() instead and assign this buffer with
> > > kfifo_init().
> > > 
> > 
> > Yes, that might be an option. I presume I could still use dma_map_sg()
> > 
> IIRC, struct sg_table allocates arrays of struct scatterlist in
> PAGE_SIZE chunks, and chains them together.
> 
> If you change from "sg++" to "sg_next()", you should be able to work
> with chained scatterlists. You can only have a single struct page * in
> one struct scatterlist. This would mean that if I tried to use
> kfifo_dma_out_prepare() to give me 16MB worth of data, I would need 4096
> seperate struct scatterlist entries. One for each struct page * in that
> 16MB chunk.
> 

No, this would require an initialized scatterlist array and the
kfifo_dma_* function does not expect this. And i am not sure why you
need 4096 seperate struct scatterlist entries for a continues memory, i
need only one. The scatterlist structure contains the page, the offset
and the length. The length can be more the a page size.

Stefani

