Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZEZEin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZEZEin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 00:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZEZEiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 00:38:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:55940 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbZEZEiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 00:38:21 -0400
Date: Tue, 26 May 2009 13:36:37 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, jgarzik@pobox.com, hancockrwd@gmail.com,
       htejun@gmail.com, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp,
       grundler@google.com
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905221705.54426.arnd@arndb.de>
References: <200905221607.34025.arnd@arndb.de>
	<20090522233846I.fujita.tomonori@lab.ntt.co.jp>
	<200905221705.54426.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090526122423S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 26 May 2009 13:36:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 17:05:53 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 22 May 2009, FUJITA Tomonori wrote:
> > I'm not sure. And only mips internally uses CONFIG_DMA_COHERENT.
> > 
> > The reason why many architectures need architecture-specific
> > alloc_coherent() is not about coherent or not.
> > 
> > I like a new helper header file having only generic functions without
> > any ifdef.
> 
> Ok, fair enough. Fixing dma_alloc_coherent to handle
> coherent_dma_mask and debug_dma correctly would also
> make it even bigger, and it was already doing more than
> you'd want from a commonly used inline function.
> It may be useful to put it into kernel/dma-coherent.c
> under an #ifdef, but I'll leave this one alone for now.

Adding #ifdef into kernel/dma-coherent.c is ugly.


> I'll leave dma_alloc_coherent and dma_free_coherent
> as extern declarations then, and leave out the
> simple dma_coherent_dev() and dma_cache_sync() that
> all architectures would need to override.

Right, needs to leave the functions that architectures need to
override.


> dma_get_cache_alignment() is still less generic than
> the other functions, as this is still architecture
> specific. Should I leave that out as well then?

Yes, I think that only adding generic functions is a better
approach. Overriding with #ifdef is really ugly.


> One more idea I had was to rename all the functions in
> this file from dma_* to dma_linear_*. This would mean
> that all architectures using it would still need to
> do something like #define dma_map_sg dma_linear_map_sg
> for each function they want to use but can easily chose
> to provide their own ones for those they need different.
> 
> It might also help architectures that work with dma_ops,
> which could then define their own
> struct dma_ops dma_ops_linear = {
> 	.map_single = dma_linear_map_single,
> 	.map_sg = dma_linear_map_sg,
> 	...
> };

To me, looks like this just makes things complicated needlessly. But
I'm not in a position to ACK or NACK this. it's better to ask
architecture maintainers.


> Would you prefer me to do it this way, or just keep the
> standard function names as in the current patch?
