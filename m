Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYDVMEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYDVMEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYDVMEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:04:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15404 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYDVMEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:04:44 -0400
Date: Tue, 22 Apr 2008 14:04:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tsbogend@alpha.franken.de, jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: cdrom: use kmalloced buffers instead of buffers on stack
Message-ID: <20080422120438.GD12774@kernel.dk>
References: <20080422054857.GA5940@alpha.franken.de> <20080422204637G.tomof@acm.org> <20080422115519.GB12774@kernel.dk> <20080422205933P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422205933P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, FUJITA Tomonori wrote:
> On Tue, 22 Apr 2008 13:55:19 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Apr 22 2008, FUJITA Tomonori wrote:
> > > On Tue, 22 Apr 2008 07:48:58 +0200
> > > tsbogend@alpha.franken.de (Thomas Bogendoerfer) wrote:
> > > 
> > > > On Mon, Apr 21, 2008 at 10:01:26PM -0400, Jeff Garzik wrote:
> > > > > >    cdrom: use kmalloced buffers instead of buffers on stack
> > > > > >    
> > > > > >    If cdrom commands are issued to a scsi drive in most cases the buffer 
> > > > > >    will be
> > > > > >    filled via dma.  This leads to bad stack corruption on non coherent 
> > > > > >    platforms,
> > > > > >    because the buffers are neither cache line aligned nor is the size a 
> > > > > >    multiple
> > > > > >    of the cache line size.  Using kmalloced buffers avoids this.
> > > > > >    
> > > > > >    Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > > > >    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > > >---
> > > > > > drivers/cdrom/cdrom.c |  274 
> > > > > > ++++++++++++++++++++++++++++++++-----------------
> > > > > > 1 files changed, 181 insertions(+), 93 deletions(-)
> > > > > 
> > > > > Eh... AFAICS this is only really useful in two of the cases converted.
> > > > > 
> > > > > For all the other cases (<= 32 bytes), it is _far_ less complex, far 
> > > > > less code to simply communicate the additional alignment requirements to 
> > > > > the compiler.
> > > > > 
> > > > > What about __attribute__ __aligned__?  Was that tried?
> > > > 
> > > > I used that while narrowing down the bug. But not only the alignment is
> > > > important, but also size needs to be a multiple of the cache line size.
> > > > Which means it needs to be 128 bytes for most SGI machines. That
> > > > and the following in DMA-mapping.txt
> > > > 
> > > > "This rule also means that you may use neither kernel image addresses
> > > > (items in data/text/bss segments), nor module image addresses, nor
> > > > stack addresses for DMA."
> > > > 
> > > > let me choose the kmalloc() solution.
> > > 
> > > Can we advertise such architecture's dma restrictions? For example, if
> > > we can update dma_pad_mask and dma_alignment in request_queue,
> > > blk_rq_map_kern uses a proper bounce buffer for such
> > > architectures. Then we can avoid putting extra complexity in uppper
> > > drivers such as cdrom.c
> > 
> > That would work fine, if cdrom was then also updated to get rid of
> > ->generic_packet() and use the regular queue transport instead. Which
> > would be a VERY nice thing to do anyway, so I'd welcome the effort :-)
> 
> sr_packet calls ioctl so it works for SCSI at least?

Yup, it'll work fine for sr currently, but not ide-cd. But we should
just get rid of ->generic_packet() and prepare a request in cdrom.c
instead.

-- 
Jens Axboe

