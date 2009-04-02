Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbZDBQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbZDBQyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbZDBQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:53:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765822AbZDBQxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:53:52 -0400
Date: Thu, 2 Apr 2009 09:45:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] build fix for generic debug pagealloc
Message-Id: <20090402094522.b29004c8.akpm@linux-foundation.org>
In-Reply-To: <20090402163145.GA28728@localhost.localdomain>
References: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com>
	<20090402163145.GA28728@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009 01:31:52 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> > mm/debug-pagealloc.c: In function 'set_page_poison':
> > mm/debug-pagealloc.c:8: error: 'struct page' has no member named 'debug_flags'
> > mm/debug-pagealloc.c: In function 'clear_page_poison':
> > mm/debug-pagealloc.c:13: error: 'struct page' has no member named 'debug_flags'
> > mm/debug-pagealloc.c: In function 'page_poison':
> > mm/debug-pagealloc.c:18: error: 'struct page' has no member named 'debug_flags'
> > mm/debug-pagealloc.c: At top level:
> > mm/debug-pagealloc.c:120: error: redefinition of 'kernel_map_pages'
> > include/linux/mm.h:1278: error: previous definition of
> > 'kernel_map_pages' was here
> > mm/debug-pagealloc.c: In function 'kernel_map_pages':
> > mm/debug-pagealloc.c:122: error: 'debug_pagealloc_enabled' undeclared
> > (first use in this function)
> 
> This patch fixes build failure with generic debug pagealloc:
> 
>  - debug_flags should be in struct page
>  - define DEBUG_PAGEALLOC config option for all architectures
>
> ...
>
>  	bool "Debug access to per_cpu maps"
>  	depends on DEBUG_KERNEL
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index ddadb4d..0e80e26 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -95,6 +95,9 @@ struct page {
>  	void *virtual;			/* Kernel virtual address (NULL if
>  					   not kmapped, ie. highmem) */
>  #endif /* WANT_PAGE_VIRTUAL */
> +#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
> +	unsigned long debug_flags;	/* Use atomic bitops on this */
> +#endif
>  };
>  
>  /*
> @@ -175,9 +178,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA
>  	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
>  #endif
> -#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
> -	unsigned long debug_flags;	/* Use atomic bitops on this */
> -#endif
>  };

dammit.

>  struct core_thread {
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index c8d62d4..bb01e29 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -1,3 +1,12 @@
> +config DEBUG_PAGEALLOC
> +	bool "Debug page memory allocations"
> +	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
> +	depends on !HIBERNATION || !PPC && !SPARC
> +	---help---
> +	  Unmap pages from the kernel linear mapping after free_pages().
> +	  This results in a large slowdown, but helps to find certain types
> +	  of memory corruptions.
> +

I guess this is why it wasn't discovered in my compile testing.  It's
quite regrettable that `make allmodconfig' didn't enable the feature. 
That's what allmodconfig is for.
