Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXKCNPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXKCNPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 09:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXKCNO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 09:14:59 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:20536 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXKCNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 09:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EzLDMOXbaSdFhkxY8xdW6DB7pa665emHQJPzXQtPtyGBQSVNPzjvMA++V55s85NTK23K9Zz1tWAkhRRIfYdBQzXhJbZF9pACrYWTHNReURMYk/LB7je9yOT55Vd568tGxz7sWDhBLFrwFAeYDjHOByGBCUGRgq5HRKn1r078xLw=
Message-ID: <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
Date: Sat, 3 Nov 2007 14:14:53 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to boot: kernel BUG at include/linux/scatterlist.h:49!
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <472BA567.8040301@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
	 <472BA567.8040301@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Torsten Kaiser wrote:
> > Both 2.6.24-rc1 and the current git version fail to boot for me:
> >
> > [   57.182205] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
> > MMIO=[effff800-efffffff]  Max Packet=
> > [2048]  IR/IT contexts=[4/8]
> > [   57.194032] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
> > [   57.199527] ------------[ cut here ]------------
> > [   57.204154] kernel BUG at include/linux/scatterlist.h:49!
>
> To which extent do you need IEEE 1394 drivers?

Using eth1394 as primary network connection on this computer.
So switching to the new stack is currently not an option, or did I
missing something?
(I also have a firewire disk, but that is not used right now)

> > from gdb:
> > 0xffffffff80463512 is in dma_region_alloc (include/linux/scatterlist.h:49).
> > 44               * In order for the low bit stealing approach to work, pages
> > 45               * must be aligned at a 32-bit boundary as a minimum.
> > 46               */
> > 47              BUG_ON((unsigned long) page & 0x03);
> > 48      #ifdef CONFIG_DEBUG_SG
> > 49              BUG_ON(sg->sg_magic != SG_MAGIC);
> > 50      #endif
> > 51              sg->page_link = page_link | (unsigned long) page;
> > 52      }
> > 53
>
> Uh oh...

Looking that calltrace upwards, it seems replacing the
memset(dma->sglist,...) with sg_init_table(...) would fix the BUG_ON()
as that inits the SG_MAGIC. But I do not trust myself to fixing all
the iterators correctly to convert this completely to the new API.

What I noticed trying to find the definition of sg_dma_address() is
that all architectures seem to implement identical macros for
sg_dma_address() and sg_dma_length(). The only difference is that some
archs call their fields different.

But I stopped looking if unifiying all names was possible when I found
swiotlb_map_sg() in lib/swiotlb.c...

Why is there a comment about using "sg_dma_{address,length}(SG)" to
obtain the "appropriate dma address and length" when I see no instance
of this macros there? Instead there are direct accesses to sg->length
and sg->dma_length. And the field dma_length only exists in some
arches! (alpha, ia64, powerpc only if __powerpc64__ is defined,
sparc64 and the 64bit variant of x86)
On the other hand I can't find any other "iova_length" in the hole
tree apart from include/asm-parisc/scatterlist.h...

... so I can't really make sense of the sg mechanism and abstain from
trying to fix this myself.

Torsten
