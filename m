Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbXEKR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbXEKR5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXEKR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:57:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324AbXEKR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:57:42 -0400
Date: Fri, 11 May 2007 10:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section mismatch
Message-Id: <20070511105737.cfa5cfdd.akpm@linux-foundation.org>
In-Reply-To: <20070511153521.GB22577@suse.de>
References: <20070511153521.GB22577@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 17:35:22 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> This patch fixes following compile warning:
> 
> --------- >8 --------
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text
> between 'kmem_cache_create' (at offset 0x2167b) and 'drain_alien_cache'
> 
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text
> between 'kmem_cache_create' (at offset 0x216c1) and 'drain_alien_cache'
> --------- 8< --------
> 
> set_up_list3s() can be called from setup_cpu_cache() [mm/slab.c] which is not
> an init function.
> 
> 

Yes.  This warning is a false positive.  See

static int setup_cpu_cache(struct kmem_cache *cachep)
{
	if (g_cpucache_up == FULL)
		return enable_cpucache(cachep);

	if (g_cpucache_up == NONE) {
		...
		set_up_list3s(cachep, SIZE_AC);

The g_cpucache_up==NONE state only exists before we have run free_initmem().

There is a similar false-positive down in acpi somewhere.

I think Sam is working on a scheme whereby we can add annotation to quash
the warnings in cases such as this.


> 
> ---
>  mm/slab.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -305,7 +305,7 @@ struct kmem_list3 {
>   * Need this for bootstrapping a per node allocator.
>   */
>  #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
> -struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
> +struct kmem_list3 initkmem_list3[NUM_INIT_LISTS];
>  #define	CACHE_CACHE 0
>  #define	SIZE_AC 1
>  #define	SIZE_L3 (1 + MAX_NUMNODES)
> @@ -1960,7 +1960,7 @@ static void slab_destroy(struct kmem_cac
>   * For setting up all the kmem_list3s for cache whose buffer_size is same as
>   * size of kmem_list3.
>   */
> -static void __init set_up_list3s(struct kmem_cache *cachep, int index)
> +static void set_up_list3s(struct kmem_cache *cachep, int index)
>  {
>  	int node;

That'll shut it up, but we'll use more memory at runtime.
