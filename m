Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYGZSO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYGZSO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYGZSOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:14:07 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45176 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYGZSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:14:06 -0400
Date: Sat, 26 Jul 2008 19:13:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Adrian Bunk <bunk@kernel.org>
cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
In-Reply-To: <20080726173832.GE9301@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0807261852050.582@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
 <20080726173832.GE9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Adrian Bunk wrote:
> On Sat, Jul 26, 2008 at 07:18:05PM +0200, Haavard Skinnemoen wrote:
> > This fixes the following compile error on avr32, introduced by
> > commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c
> > (exec: remove some includes):
> > 
> > In file included from include/asm/tlb.h:24,
> >                  from fs/exec.c:55:
> > include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> > include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> > include/asm-generic/tlb.h: In function 'tlb_remove_page':
> > include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> > make[1]: *** [fs/exec.o] Error 1
> > 
> > Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > ---
> >  include/asm-generic/tlb.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> > index f490e43..f85f3a2 100644
> > --- a/include/asm-generic/tlb.h
> > +++ b/include/asm-generic/tlb.h
> > @@ -13,6 +13,7 @@
> >  #ifndef _ASM_GENERIC__TLB_H
> >  #define _ASM_GENERIC__TLB_H
> >  
> > +#include <linux/pagemap.h>
> >  #include <linux/swap.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/tlbflush.h>
> 
> The patch is not the correct fix since the actual problem comes from 
> free_pages_and_swap_cache() in swap.h

You're right, but ...

> 
> Patch is below, but it has not yet gotten enough testing that I'm 100% 
> confident it doesn't break anything else...

... according to the comment in swap.h, we have to expect that
yours (just like Yoichi-san's) will cause some problem on sparc.

I quite like Haavard's, since almost all the arch tlb.hs seem to
have noticed a similar issue and already include pagemap.h.  But
if we do go with his, it looks to me like include/asm-s390/tlb.h
would also need the same.

My preference for now is just to go with the fs/exec.c fixup at
the bottom, restoring things more how they were before I came
along and screwed everyone over.  Adrian, may I impertinently
ask you to give that one a go in your build farm?

The _right_ fix looks to me to be different from all of these, but
something we shouldn't get into while people are waiting for their
kernel builds to be fixed: probably not for 2.6.27.

That right fix, I think, would be to move free_page_and_swap_cache
and free_pages_and_swap_cache (and free_swap_cache) from mm/swap_state.c
to mm/swap.c, and move their prototype declarations from linux/swap.h to
asm*/tlb.h, and hopefully remove swap.h and pagemap.h from asm*/tlb.h.
But that could cause a lot more trouble than I have done already!

Hugh

> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   CC      fs/exec.o
> In file included from include2/asm/tlb.h:24,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/exec.c:55:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_remove_page':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> make[2]: *** [fs/exec.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 2dab88e59c7ec942df29bbdee041e54edeee1d25 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0b33776..f835058 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -7,6 +7,7 @@
>  #include <linux/list.h>
>  #include <linux/memcontrol.h>
>  #include <linux/sched.h>
> +#include <linux/pagemap.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/page.h>

--- 2.6.26-git/fs/exec.c	2008-07-26 12:33:28.000000000 +0100
+++ linux/fs/exec.c	2008-07-26 18:50:38.000000000 +0100
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
