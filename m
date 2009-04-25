Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZDYGlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZDYGlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 02:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZDYGk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 02:40:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:22194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZDYGk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 02:40:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,245,1239001200"; 
   d="scan'208";a="509819831"
Message-ID: <49F2B075.4090300@linux.intel.com>
Date: Sat, 25 Apr 2009 08:40:53 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Markus Metzger <markus.t.metzger@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
References: <20090424100055.A30408@sedona.ch.intel.com>
In-Reply-To: <20090424100055.A30408@sedona.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Metzger wrote:
> Use vmalloc to allocate the branch trace buffer.
> 
> Peter Zijlstra suggested to use vmalloc rather than kmalloc to
> allocate the potentially multi-page branch trace buffer.
> 
> Is there a way to have vmalloc allocate a physically non-contiguous
> buffer for test purposes? Ideally, the memory area would have big
> holes in it with sensitive data in between so I would know immediately
> when this is overwritten.

For test purposes you could hack vmalloc.c to allocate more pages
and only put in every second/third/... into the mapping. You would
just need to add another to loop to __vmalloc_area_node() that allocates
more. That should give you non continuous mappings unless you're really unlucky.

-Andi


> 
> 
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
>  arch/x86/kernel/ptrace.c |    5 	3 +	2 -	0 !
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: b/arch/x86/kernel/ptrace.c
> ===================================================================
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -22,6 +22,7 @@
>  #include <linux/seccomp.h>
>  #include <linux/signal.h>
>  #include <linux/workqueue.h>
> +#include <linux/vmalloc.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
>  	if (err < 0)
>  		return err;
>  
> -	buffer = kzalloc(size, GFP_KERNEL);
> +	buffer = vmalloc(size);
>  	if (!buffer)
>  		goto out_refund;
>  
> @@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
>  	if (!context->buffer)
>  		return;
>  
> -	kfree(context->buffer);
> +	vfree(context->buffer);
>  	context->buffer = NULL;
>  
>  	refund_locked_memory(context->mm, context->size);

