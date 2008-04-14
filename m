Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYDNAUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYDNAUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYDNAUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:20:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbYDNAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:20:20 -0400
Date: Sun, 13 Apr 2008 17:19:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       <linuxppc-dev@ozlabs.org>, <takata@linux-m32r.org>,
       <linux-m32r@ml.linux-m32r.org>, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-Id: <20080413171953.bde5e9ac.akpm@linux-foundation.org>
In-Reply-To: <20080410032354.90CB1DDF0F@ozlabs.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 13:22:56 +1000 Benjamin Herrenschmidt <benh@ozlabs.org> wrote:

> Some architecture need to maintain a kmem cache for thread info
> structures. (next patch adds that to powerpc to fix an alignment
> problem).
> 
> There is no good arch callback to use to initialize that cache
> that I can find, so this adds a new one and adds an empty macro
> for when it's not implemented.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> So we have the choice here between:
> 
>  - the ifdef on the func name that I did, consistent with what
> I did before for iomap, which iirc Linus liked
> 
>  - add some more ARCH_HAS_* or HAVE_* (yuck)
> 
>  - add an empty definition to all archs .h (pain in the neck but I
> can do it, though it will be an annoying patch to keep around)
> 
>  - do a weak function (will slightly bloat everybody for no good reason)
> 
> So unless there is strong complaints, I'd like to stick to my
> current approach.
> 
>  include/linux/sched.h |    4 ++++
>  init/main.c           |    1 +
>  2 files changed, 5 insertions(+)
> 
> --- linux-work.orig/init/main.c	2008-04-10 13:11:06.000000000 +1000
> +++ linux-work/init/main.c	2008-04-10 13:11:19.000000000 +1000
> @@ -623,6 +623,7 @@ asmlinkage void __init start_kernel(void
>  	if (efi_enabled)
>  		efi_enter_virtual_mode();
>  #endif
> +	thread_info_cache_init();
>  	fork_init(num_physpages);
>  	proc_caches_init();
>  	buffer_init();
> Index: linux-work/include/linux/sched.h
> ===================================================================
> --- linux-work.orig/include/linux/sched.h	2008-04-10 13:11:44.000000000 +1000
> +++ linux-work/include/linux/sched.h	2008-04-10 13:12:05.000000000 +1000
> @@ -1893,6 +1893,10 @@ static inline unsigned long *end_of_stac
>  
>  #endif
>  
> +#ifndef thread_info_cache_init
> +#define thread_info_cache_init	do { } while(0)
> +#endif

This trick does cause a bit of a problem: it is undefined which arch header
file is to provide the alternative definition of thread_info_cache_init.

So we can (and have) ended up in the situation where the override appears
in different files on different architectures and various screwups ensue.

So I'd suggest that we have a bigfatcomment telling implementors which file
the override should be implemented in.  And make sure that this arch file is
directly included from within sched.h.

I have a suspicion that we can still get in a mess if .c files include the
per-arch file and don't include sched.h, but I forget where this happened
and why it broke stuff.

Sigh.  A nice, coded-in-C implementation within each and every architecture
remains the best implementation, and all the little tricks-to-save-typing
have failure modes.

otoh, if only one .c file will ever call this function then I think that
all problems are solved by

a) moving the above ifdeffery into the .c file
b) adding a comment explaining which arch file must provide the override
c) directly including that file from within the .c file.

