Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXCUJVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXCUJVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXCUJVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:21:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37214 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXCUJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:21:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow per-cpu variables to be page-aligned
References: <1174457426.11680.132.camel@localhost.localdomain>
Date: Wed, 21 Mar 2007 03:21:01 -0600
In-Reply-To: <1174457426.11680.132.camel@localhost.localdomain> (Rusty
	Russell's message of "Wed, 21 Mar 2007 17:10:26 +1100")
Message-ID: <m1ejnjc5qa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> [This was part of the GDT cleanups and per-cpu-> pda changes, which I
> have revised, but this stands on its own.  The only change is catching
> the x86-64 per-cpu allocator too].
> ==
> Let's allow page-alignment in general for per-cpu data (wanted by Xen,
> and Ingo suggested KVM as well).
>
> Because larger alignments can use more room, we increase the max
> per-cpu memory to 64k rather than 32k: it's getting a little tight.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Ingo Molnar <mingo@elte.hu>

> ===================================================================
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -346,10 +346,10 @@ static void *percpu_modalloc(unsigned lo
>  	unsigned int i;
>  	void *ptr;
>  
> -	if (align > SMP_CACHE_BYTES) {
> -		printk(KERN_WARNING "%s: per-cpu alignment %li > %i\n",
> -		       name, align, SMP_CACHE_BYTES);
> -		align = SMP_CACHE_BYTES;
> +	if (align > PAGE_SIZE) {
> +		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +		       name, align, PAGE_SIZE);
> +		align = PAGE_SIZE;
>  	}
>  
>  	ptr = __per_cpu_start;
> @@ -430,7 +430,7 @@ static int percpu_modinit(void)
>  	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
>  			    GFP_KERNEL);
>  	/* Static in-kernel percpu data (used). */
> -	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
> +	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, PAGE_SIZE);
>  	/* Free room. */
>  	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
>  	if (pcpu_size[1] < 0) {

Do we really want to allow modules to be able to allocate page sized
per cpu memory.  If my memory servers on how this code works we will wind
up allocating 1 page of per cpu memory for every module that allocates a
per cpu variable.  128 bytes sucks 4k is an order of magnitude worse.

On x86_64 we are only reserving 8K for modules...

Eric
