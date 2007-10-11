Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbXJKRho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbXJKRho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbXJKRhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:37:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53461 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753158AbXJKRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:37:35 -0400
Date: Thu, 11 Oct 2007 10:37:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <20071011143656.GA3972@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0710111037040.31811@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C>
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
 <20071010121853.GA3911@APFDCB5C> <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
 <20071011143656.GA3972@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Akinobu Mita wrote:

> This is another approach for the fix.

Looks like the cleanest solution.

Acked-by: Christoph Lameter <clameter@sgi.com>


> Use cpumask to check whether kmem_cache_cpu_free initalization for
> the CPU has already been done or not.
> 
> ---
>  mm/slub.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: 2.6-mm/mm/slub.c
> ===================================================================
> --- 2.6-mm.orig/mm/slub.c
> +++ 2.6-mm/mm/slub.c
> @@ -1959,6 +1959,7 @@ static DEFINE_PER_CPU(struct kmem_cache_
>  				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
>  
>  static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
> +static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
>  
>  static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
>  							int cpu, gfp_t flags)
> @@ -2033,8 +2034,13 @@ static void init_alloc_cpu_cpu(int cpu)
>  {
>  	int i;
>  
> +	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
> +		return;
> +
>  	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
>  		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
> +
> +	cpu_set(cpu, kmem_cach_cpu_free_init_once);
>  }
>  
>  static void __init init_alloc_cpu(void)
> 
