Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYLKUSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYLKUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYLKUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:18:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbYLKUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:18:22 -0500
Date: Thu, 11 Dec 2008 12:16:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, viro@zeniv.linux.org.uk,
       dhowells@redhat.com, miltonm@bga.com, wd@denx.de, dzu@denx.de,
       yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Message-Id: <20081211121635.ff58193f.akpm@linux-foundation.org>
In-Reply-To: <200812101950.51958.yur@emcraft.com>
References: <200812101950.51958.yur@emcraft.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 19:50:51 +0300
Yuri Tikhonov <yur@emcraft.com> wrote:

> 
> The following patch fixes divide-by-zero error for the
> cases of really big PAGE_SIZEs (e.g. 256KB on ppc44x).
> Support for big page sizes on 44x is not present in the
> current kernel yet, but coming soon.
> 
> Also this patch fixes the comment for the max_threads
> settings, as this didn't match the things actually done
> in the code.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> ---
>  kernel/fork.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8d6a7dd..638eb7f 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -181,10 +181,14 @@ void __init fork_init(unsigned long mempages)
>  
>  	/*
>  	 * The default maximum number of threads is set to a safe
> -	 * value: the thread structures can take up at most half
> -	 * of memory.
> +	 * value: the thread structures can take up at most
> +	 * (1/8) part of memory.
>  	 */
> +#if (8 * THREAD_SIZE) > PAGE_SIZE
>  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> +#else
> +	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> +#endif

The expression you've chosen here can be quite inacccurate, because
((PAGE_SIZE / (8 * THREAD_SIZE)) is a small number.  The way to
preserve accuracy is

	max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);

so how about avoiding the nasty ifdefs and doing

--- a/kernel/fork.c~fork_init-fix-division-by-zero
+++ a/kernel/fork.c
@@ -69,6 +69,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/div64.h>
 
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
@@ -185,10 +186,15 @@ void __init fork_init(unsigned long memp
 
 	/*
 	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most half
-	 * of memory.
+	 * value: the thread structures can take up at most
+	 * (1/8) part of memory.
 	 */
-	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
+	{
+		/* max_threads = (mempages * PAGE_SIZE) / THREAD_SIZE / 8; */
+		u64 m = mempages * PAGE_SIZE;
+		do_div(m, THREAD_SIZE * 8);
+		max_threads = m;
+	}
 
 	/*
 	 * we need to allow at least 20 threads to boot a system
_

?


The code is also inaccurate because it assumes that <whatever allocator
is used for threads> will pack the thread_structs into pages with best
possible density, which isn't necessarily the case.  Let's not worry
about that.




OT:

max_threads is widly wrong anyway.

- the caller passes in num_physpages, which includes highmem.  And we
  can't allocate thread structs from highmem.

- num_physpages includes kernel pages and other stuff which can never
  be allocated via the page allocator.

A suitable fix would be to switch the caller to the strangely-named
nr_free_buffer_pages().

If you grep the tree for `num_physpages', you will find a splendid
number of similar bugs.  num_physpages should be unexported, burnt,
deleted, etc.  It's just an invitation to write buggy code.

