Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZFHFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZFHFtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZFHFtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:49:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:45965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZFHFtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:49:22 -0400
Date: Mon, 8 Jun 2009 14:49:17 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200906041747.04310.arnd@arndb.de>
References: <200906041235.34686.arnd@arndb.de>
	<20090605000424E.fujita.tomonori@lab.ntt.co.jp>
	<200906041747.04310.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090608144921R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 08 Jun 2009 14:49:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 17:47:03 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 04 June 2009, FUJITA Tomonori wrote:
> > On Thu, 4 Jun 2009 12:35:34 +0000
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > > > I do have branches in there that convert x86 and microblaze to use
> > > > 
> > > > x86? How can it use asm-generic-linear.h?
> > > 
> > > Not dma-mapping-linear.h, but a lot of other files in asm-generic. I have
> > > a set of all the common header files in my tree, and x86 can e.g. use
> > > ioctls.h, ipcbuf.h, mman.h, or types.h. For x86, it amounts to 15 files,
> > > microblaze can use almost 50 of the generic files.
> > 
> > I see, but I'm not sure why dma-mapping-linear needs to be merged with
> > them together.
> 
> It doesn't need to, but it would be much more convenient for me having
> to go through the architectures only once. Some of the arch maintainers
> are harder to get hold of than others.
> 
> > > 
> > > I think it is technically correct, but there are two plausible ways of
> > > doing it, I chose the one that requires slightly less code.
> > > 
> > > I call dma_cache_sync() for streaming mappings on dma_map_* and
> > > dma_sync_*_for_device iff the mapping is noncoherent. AFAICT, this
> > > is the same case as dma_alloc_noncoherent, which is expected to give
> > > out a noncoherent mapping.
> > 
> > If I correctly understand DMA-API.txt, dma_alloc_noncoherent can
> > return either consistent or non-consistent memory. On architectures
> > that return consistent memory via dma_alloc_noncoherent,
> > dma_cache_sync should be null. dma_cache_sync() is supposed to be used
> > only with the returned buffers of dma_alloc_noncoherent().
> 
> Good point. This is unfortunately not what is implemented on many
> architectures, which #define dma_alloc_noncoherent dma_alloc_coherent
> but still provide a synchronizing operation in dma_cache_sync().
> 
> dma_alloc_noncoherent is actually only implemented on parisc, mips
> and m68k.
> 
> However, I don't think I have the energy to fix this problem, but
> I agree that it should be fixed eventually. I can leave out
> the declarations of dma_{free,alloc}_coherent from dma-mapping-linear.h
> so that the broken code remains in the architecture specific
> files, and change all references to dma_cache_sync to something
> else. The best I can think of is __dma_cache_sync() with the same
> calling conventions as dma_cache_sync(). Does that make sense?

Sorry, but it doesn't make sense to me because __dma_cache_sync() hack
is against the goal of dma-mapping-linear.h, having a clean, ideal,
unified header file.
