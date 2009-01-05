Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZAERjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZAERjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAERi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:38:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:9037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZAERi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QzB3YEemS/8YDAT+Okhln0Bj1NhSw7TYSp9IbCLWNcQrWKbzta6llfYWvmbJAoTlO+
         CtSeiQFb+Ia4vU9jjERnLjCeMYwRboaGBTJio0Kd1L5xv3JWhZnFR9LHQpVhpnPfwWEa
         RONonJEaxb3tAb0NC+nrLUireuYjEhjj49Nq4=
Message-ID: <2f11576a0901050938l2b30295ej80a068815ab2a49d@mail.gmail.com>
Date: Tue, 6 Jan 2009 02:38:55 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Cc: linux-kernel@vger.kernel.org, "Greg Ungerer" <gerg@snapgear.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20090105224007.20e60d02.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090105224007.20e60d02.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> m68knommu-use-the-new-byteorder-headers.patch
>> m68knommu-set-no_dma.patch
>>
>>   Architecture things.  Will merge.
>
> I have an m68nommu tree as part of linux-next should these go there?
> (though the last - still outstanding - commit was in November).

I guess m68knommu-set-no_dma.patch isn't right and pci code in
m68knommu use DMA.
because ..

arch/m64knommu/include/asm/dma-mapping.h is

---------------------------------------------------
#ifndef _M68KNOMMU_DMA_MAPPING_H
#define _M68KNOMMU_DMA_MAPPING_H

#ifdef CONFIG_PCI
#include <asm-generic/dma-mapping.h>
#else
#include <asm-generic/dma-mapping-broken.h>
#endif

#endif  /* _M68KNOMMU_DMA_MAPPING_H */
---------------------------------------------------

At least, original author think m68k pci driver use dma.

Recently, I propose following patch.
but nobody replay it ;)


but I also guess it doesn't matter because I guess nobody use m68knommu now ;-/




Subject: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig
can't build
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: 2008/12/30 19:44

>I guess nobody don't test m68knommu at all last three month.
>Do we still need to maintain this architecture?
>
>
>==
>Currently, m68knommu defconfig can't build. it cause following error.
>
>net/built-in.o: In function `skb_dma_map':
>: undefined reference to `dma_mapping_error'
>net/built-in.o: In function `skb_dma_unmap':
>: undefined reference to `dma_unmap_single'
>net/built-in.o: In function `skb_dma_unmap':
>: undefined reference to `dma_unmap_page'
>net/built-in.o: In function `skb_dma_map':
>: undefined reference to `dma_map_single'
>net/built-in.o: In function `skb_dma_map':
>: undefined reference to `dma_map_page'
>net/built-in.o: In function `skb_dma_map':
>: undefined reference to `dma_unmap_page'
>net/built-in.o: In function `skb_dma_map':
>: undefined reference to `dma_unmap_single'
>
>because
> - CONFIG_DMA depend on !NO_DMA
> - m68knommu always doesn't turn on NO_DMA
> - if CONFIG_PCI=n, m68knommu/include/asm/dma-magging.h include
>   asm-generic/dma-mapping-broken.h
> - dma-mapping-broken.h generate link time error.
> - m68knommu defconfig doesn't have CONFIG_PCI
> - On the other hand, net/core/skb_dma_map.c assume CONFIG_DMA=y mean
>  dma related function is callable
>
>So, we want to turn on CONFIG_DMA if CONFIG_PCI=y only.
>
>
>CC: David S. Miller <davem@davemloft.net>
>CC: Geert Uytterhoeven <geert@linux-m68k.org>
>CC: Roman Zippel <zippel@linux-m68k.org>
>CC: Greg Ungerer <gerg@uclinux.org>
>CC: linux-m68k@lists.linux-m68k.org
>---
> arch/m68knommu/Kconfig |    3 +++
> 1 file changed, 3 insertions(+)
>
>Index: b/arch/m68knommu/Kconfig
>===================================================================
>--- a/arch/m68knommu/Kconfig    2008-12-25 08:26:37.000000000 +0900
>+++ b/arch/m68knommu/Kconfig    2008-12-28 21:09:58.000000000 +0900
>@@ -73,6 +73,9 @@ config GENERIC_CLOCKEVENTS
> config NO_IOPORT
>       def_bool y
>
>+config NO_DMA
>+       def_bool !PCI
>+
> source "init/Kconfig"
>
> source "kernel/Kconfig.freezer"
