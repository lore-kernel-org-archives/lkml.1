Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZESRml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZESRml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZESRmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:42:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZESRmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:42:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Tue, 19 May 2009 17:40:20 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jgarzik@pobox.com,
       hancockrwd@gmail.com, htejun@gmail.com, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, schmitz@biophys.uni-duesseldorf.de,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
References: <200905172245.23774.arnd@arndb.de> <200905191822.48420.arnd@arndb.de> <da824cf30905191001p29217d44u62bcc1c38b0acd92@mail.gmail.com>
In-Reply-To: <da824cf30905191001p29217d44u62bcc1c38b0acd92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191740.21150.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Zc6YsJ+ApY8fs7qUBKguUEXjmQdbEHSxCh2Q
 VgsY5PKa+1MH1U9AHOuNZLtS4LodRHTmRUraNccTm8Y5S53Whq
 YSIo07c6QGcC4y9B0sDBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 17:01:27 Grant Grundler wrote:
> On Tue, May 19, 2009 at 9:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> I've reviewed the first bit and it looks fine (so far to me).
> Two related bugs:
> 1) dma_alloc_coherent() is not respecting the coherent_dma_mask field
> in device.h:struct device.

Hmm, I've taken that function unchanged from powerpc. I guess that means
that powerpc is broken  here as well, right?

> 2) dma_map_single() is not respecting dma_mask in struct pci_dev (and
> pointer from struct device).

What should it do with the mask? All the architectures I've looked
at as well as arch/parisc/kernel/pci-dma.c ignore it.
Should dma_map_* just fail in case of an address exceeding dma_mask?

> > +/**
> > + * dma_alloc_coherent - allocate consistent memory for DMA
> > + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> > + * @size: required memory size
> > + * @handle: bus-specific DMA address
> > + *
> > + * Allocate some uncached, unbuffered memory for a device for
> > + * performing DMA.  This function allocates pages, and will
> > + * return the CPU-viewed address, and sets @handle to be the
> > + * device-viewed address.
> 
> Key here is the DMA is coherent, bi-directional, and the DMA address fit in
> the coherent_dma_mask. "uncached/unbuffered" is one way of doing this and
> is how we've implemented "DMA coherency" on parisc platforms that don't
> have an IOMMU (which all have PA1.1 CPUs) - see arch/parisc/kernel/pci-dma.c

All the architectures I've looked at come with their own version of _alloc_coherent
that works in similar ways to allocate an uncached mapping. Now that you
mention this, I realize that there is a bug on cris, which after my patch either
has two conflicting implementations of dma_{alloc,free}_coherent, or
is missing the dma_coherent_dev() function that is hidden inside of the
same #ifdef. The one in arch/cris/arch-v32/drivers/pci/dma.c does seem
to be correct though.

	Arnd <><
