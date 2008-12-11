Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYLKWWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYLKWWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYLKWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:22:40 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:48265 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbYLKWWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:22:39 -0500
Date: Fri, 12 Dec 2008 01:22:32 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <483237973.20081212012232@emcraft.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       <Geert.Uytterhoeven@sonycom.com>, <viro@zeniv.linux.org.uk>,
       <dhowells@redhat.com>, <miltonm@bga.com>, <wd@denx.de>, <dzu@denx.de>,
       <yanok@emcraft.com>
Subject: Re[2]: [PATCH][v2] fork_init: fix division by zero
In-Reply-To: <20081211121635.ff58193f.akpm@linux-foundation.org>
References: <200812101950.51958.yur@emcraft.com> <20081211121635.ff58193f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Andrew,

On Thursday, December 11, 2008 you wrote:

[snip]

> The expression you've chosen here can be quite inacccurate, because
> ((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number. 

 But why is it bad? We do multiplication to 'mempages', not division. 
All the numbers in the multiplier are the power of 2, so both 
expressions:

mempages * (PAGE_SIZE / (8 * THREAD_SIZE))

and

max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE)

are finally equal. 

>  The way to preserve accuracy is

>         max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);

> so how about avoiding the nasty ifdefs and doing

 I'm OK with the approach below, but, leading resulting to the same, 
this involves some overhead to the code where there was no this 
overhead before this patch: e.g. your implementation is finally boils 
down to ~5 times more processor instructions than there were before,
plus operations with stack for the 'm' variable.

 On the other hand, my approach with nasty (I agree) ifdefs doesn't 
lead to overheads to the code which does not need this: i.e. the most 
common situation of small PAGE_SIZEs. Big PAGE_SIZE is the exception, 
so I believe that the more common cases should not suffer because of 
this.

> --- a/kernel/fork.c~fork_init-fix-division-by-zero
> +++ a/kernel/fork.c
> @@ -69,6 +69,7 @@
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
>  #include <asm/tlbflush.h>
> +#include <asm/div64.h>
>  
>  /*
>   * Protected counters by write_lock_irq(&tasklist_lock)
> @@ -185,10 +186,15 @@ void __init fork_init(unsigned long memp
>  
>         /*
>          * The default maximum number of threads is set to a safe
> -        * value: the thread structures can take up at most half
> -        * of memory.
> +        * value: the thread structures can take up at most
> +        * (1/8) part of memory.
>          */
> -       max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> +       {
> +               /* max_threads = (mempages * PAGE_SIZE) / THREAD_SIZE / 8; */
> +               u64 m = mempages * PAGE_SIZE;
> +               do_div(m, THREAD_SIZE * 8);
> +               max_threads = m;
> +       }
>  
>         /*
>          * we need to allow at least 20 threads to boot a system
> _

> ?


> The code is also inaccurate because it assumes that <whatever allocator
is used for threads>> will pack the thread_structs into pages with best
> possible density, which isn't necessarily the case.  Let's not worry
> about that.




> OT:

> max_threads is widly wrong anyway.

> - the caller passes in num_physpages, which includes highmem.  And we
>   can't allocate thread structs from highmem.

> - num_physpages includes kernel pages and other stuff which can never
>   be allocated via the page allocator.

> A suitable fix would be to switch the caller to the strangely-named
> nr_free_buffer_pages().

> If you grep the tree for `num_physpages', you will find a splendid
> number of similar bugs.  num_physpages should be unexported, burnt,
> deleted, etc.  It's just an invitation to write buggy code.


 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

