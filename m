Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbZGPQzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbZGPQzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbZGPQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:55:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49060 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932479AbZGPQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:55:11 -0400
Subject: Re: kmemleak: Early log buffer exceeded
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247678232.2429.11.camel@ht.satnam>
References: <1247678232.2429.11.camel@ht.satnam>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 16 Jul 2009 17:53:37 +0100
Message-Id: <1247763217.27689.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 16:53:38.0925 (UTC) FILETIME=[F785B9D0:01CA0635]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 22:47 +0530, Jaswinder Singh Rajput wrote:
> Currently this reporting seems not very impressive and not giving much
> useful information :
> 
> kmemleak: Early log buffer exceeded
> kmemleak: Kernel memory leak detector disabled
> 
> It should be something like this because it is an error and this will
> disable Kernel memory leak detector :
> 
> [    0.000173] ------------[ cut here ]------------
> [    0.000186] WARNING: at mm/kmemleak.c:726 log_early+0x39/0xa9()
> [    0.000189] Hardware name:         
> [    0.000192] Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> [    0.000195] Modules linked in:
> [    0.000202] Pid: 0, comm: swapper Not tainted 2.6.31-rc3 #51
> [    0.000206] Call Trace:
> [    0.000216]  [<c102cf74>] warn_slowpath_common+0x60/0x90
> [    0.000222]  [<c102cfd8>] warn_slowpath_fmt+0x24/0x27
> [    0.000227]  [<c109614b>] log_early+0x39/0xa9
> [    0.000232]  [<c109682d>] kmemleak_alloc+0x41/0x4c
> [    0.000241]  [<c1093b63>] __kmalloc+0xcb/0x153
> [    0.000247]  [<c1093c04>] alloc_arraycache+0x19/0x50
> [    0.000253]  [<c1093e44>] do_tune_cpucache+0x209/0x35d
> [    0.000259]  [<c10940ee>] enable_cpucache+0x58/0x9a
> [    0.000267]  [<c14bc6e5>] kmem_cache_init_late+0x21/0xc2
> [    0.000274]  [<c14a8a20>] start_kernel+0x1e5/0x2ba
> [    0.000280]  [<c14a8340>] i386_start_kernel+0x6a/0x6f
> [    0.000380] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000384] kmemleak: Kernel memory leak detector disabled

I'm OK with mentioning DEBUG_KMEMLEAK_EARLY_LOG_SIZE but the stack trace
is not relevant here, it can happen in any place which allocates some
memory.

> Currently default value of DEBUG_KMEMLEAK_EARLY_LOG_SIZE is 400 which
> can be easily exceed-able if debugging is on.

That's why I made it configurable. We can indeed set it to a higher
value but that's after 2.6.31. I have a patch in to mark this buffer as
__initdata so that it is freed.

> These issues can be fixed like this :
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 12327b2..2eaf8bc 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -362,14 +362,15 @@ config DEBUG_KMEMLEAK
>  config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
>  	int "Maximum kmemleak early log entries"
>  	depends on DEBUG_KMEMLEAK
> -	range 200 2000
> -	default 400
> +	range 256 2048
> +	default 512

The power of 2 boundaries is not relevant as this represents the number
of elements in an array rather than a size in bytes.

>  	help
>  	  Kmemleak must track all the memory allocations to avoid
>  	  reporting false positives. Since memory may be allocated or
>  	  freed before kmemleak is initialised, an early log buffer is
> -	  used to store these actions. If kmemleak reports "early log
> -	  buffer exceeded", please increase this value.
> +	  used to store these actions. You need to increase this value,
> +	  if kmemleak reports "Early log buffer exceeded, please increase
> +	  DEBUG_KMEMLEAK_EARLY_LOG_SIZE".
>  
>  config DEBUG_KMEMLEAK_TEST
>  	tristate "Simple test for the kernel memory leak detector"
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 5aabd41..084e927 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -722,7 +722,8 @@ static void log_early(int op_type, const void *ptr, size_t size,
>  	struct early_log *log;
>  
>  	if (crt_early_log >= ARRAY_SIZE(early_log)) {
> -		pr_warning("Early log buffer exceeded\n");
> +		WARN_ONCE(1, KERN_ERR "Early log buffer exceeded, "
> +			  "please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n");
>  		kmemleak_disable();
>  		return;
>  	}

As I said above, I wouldn't want a stack trace here. Initially, this
code called kmemleak_panic() but changed it since the stack trace isn't
relevant.

Thanks.

-- 
Catalin

