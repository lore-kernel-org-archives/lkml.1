Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbYDVGFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbYDVGFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYDVGEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:04:53 -0400
Received: from elvis.franken.de ([193.175.24.41]:58987 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbYDVGEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:04:53 -0400
Date: Tue, 22 Apr 2008 07:48:58 +0200
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cdrom: use kmalloced buffers instead of buffers on stack
Message-ID: <20080422054857.GA5940@alpha.franken.de>
References: <200804220100.m3M10sva024025@hera.kernel.org> <480D46F6.3080305@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480D46F6.3080305@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:01:26PM -0400, Jeff Garzik wrote:
> >    cdrom: use kmalloced buffers instead of buffers on stack
> >    
> >    If cdrom commands are issued to a scsi drive in most cases the buffer 
> >    will be
> >    filled via dma.  This leads to bad stack corruption on non coherent 
> >    platforms,
> >    because the buffers are neither cache line aligned nor is the size a 
> >    multiple
> >    of the cache line size.  Using kmalloced buffers avoids this.
> >    
> >    Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >---
> > drivers/cdrom/cdrom.c |  274 
> > ++++++++++++++++++++++++++++++++-----------------
> > 1 files changed, 181 insertions(+), 93 deletions(-)
> 
> Eh... AFAICS this is only really useful in two of the cases converted.
> 
> For all the other cases (<= 32 bytes), it is _far_ less complex, far 
> less code to simply communicate the additional alignment requirements to 
> the compiler.
> 
> What about __attribute__ __aligned__?  Was that tried?

I used that while narrowing down the bug. But not only the alignment is
important, but also size needs to be a multiple of the cache line size.
Which means it needs to be 128 bytes for most SGI machines. That
and the following in DMA-mapping.txt

"This rule also means that you may use neither kernel image addresses
(items in data/text/bss segments), nor module image addresses, nor
stack addresses for DMA."

let me choose the kmalloc() solution.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
