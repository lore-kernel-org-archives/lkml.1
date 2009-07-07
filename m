Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbZGGReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbZGGReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZGGReN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:34:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZGGReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:34:12 -0400
Date: Tue, 7 Jul 2009 18:33:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090707173344.GA18504@n2100.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906301448.55064.arnd@arndb.de> <20090630140945.0784e174@lxorguk.ukuu.org.uk> <200906301538.44684.arnd@arndb.de> <d82e647a0907061854l7d862191w1a9aa667eca7abb5@mail.gmail.com> <20090707074821.GB6995@n2100.arm.linux.org.uk> <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:43:37PM +0800, Ming Lei wrote:
> 2009/7/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Tue, Jul 07, 2009 at 09:54:20AM +0800, Ming Lei wrote:
> >> 2009/6/30 Arnd Bergmann <arnd@arndb.de>:
> >> > On Tuesday 30 June 2009, Alan Cox wrote:
> >> > Well, not even that. dma-mapping-common.h only makes sense on architectures
> >> > that have multiple dma-mapping implementations (parisc, mips, arm, powerpc,
> >>
> >> It seems that there is only one dma-mmaping implementation on ARM, doesn't it?
> >> Is it necessary that using dma-mapping-common.h on ARM?
> >
> > ARM has two (normal, and dma bounce), and in the long run we need to do
> 
> OK, Can we use dma-mapping-common.h on ARM?

No.

> > cache handling on unmap as well as map due to CPU speculative fetches.
> 
> IMHO, it seems we can fix this problem now.
> 
> For DMA_TO_DEVICE transfer, clean cache in dma map, but does nothing in
> dma unmap;
> 
> For  DMA_FROM_DEVICE, we may do nothing in dma map, but invaliate cache
> in dma unmap.

No.  If there are dirty lines, they can be written back, overwriting the
data which has been DMA'd there.

Basically, with speculative prefetching, we need to:

- for DMA_TO_DEVICE, clean the cache in the DMA map and do nothing on DMA unmap
- for DMA_FROM_DEVICE, invalidate the cache on DMA map and again on DMA unmap

Moreover, this isn't going to be trivial.  In order to do these cache
operations, we need the virtual address.  However, the unmap APIs aren't
given this information (though dma_to_virt() will do what's required for
the dma_unmap_single case.)

dma_unmap_page() on the other hand, we don't have any API existing to
turn a DMA address back into a page struct...

If only we had an architecture specific struct to contain whatever
information needs to be carried from map to unmap...
