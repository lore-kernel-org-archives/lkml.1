Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbXE2SHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbXE2SHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXE2SHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:07:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11225 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXE2SHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:07:24 -0400
Message-ID: <465C6D4B.90403@oracle.com>
Date: Tue, 29 May 2007 11:13:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <20070528212250.eb38af64.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705291012120.23611@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705291012120.23611@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 28 May 2007, Randy Dunlap wrote:
> 
>> Has then already been posted and I missed it.. and it's fixed?  :)
>> /me hopes
> 
> Maybe this patch wil help?

Nope, still no booty.

> SLUB: Fix NUMA / SYSFS bootstrap issue
> 
> The kmem_cache_node cache is very special because it is needed for
> NUMA bootstrap. Under certain conditions (like for example if lockdep is
> enabled and significantly increases the size of spinlock_t) the structure
> may become exactly the size as one of the larger caches in the kmalloc array.
> 
> That early during bootstrap we cannot perform merging properly. The unique
> id for the kmem_cache_node cache will match one of the kmalloc array. Sysfs
> will complain about a duplicate directory entry. All of this occurs while
> the console is not yet fully operational. Thus boot may appear to be
> silently failing.
> 
> The kmem_cache_node cache is very special. During early boostrap the main
> allocation function is not operational yet and so we have to run our
> own small special alloc function during early boot. It is also special in
> that it is never freed.
> 
> We really do not want any merging on that cache. Set the refcount -1 and
> forbid merging of slabs that have a negative refcount.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/slub.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: slub/mm/slub.c
> ===================================================================
> --- slub.orig/mm/slub.c	2007-05-25 18:28:42.000000000 -0700
> +++ slub/mm/slub.c	2007-05-25 18:29:46.000000000 -0700
> @@ -2473,6 +2473,7 @@ void __init kmem_cache_init(void)
>  	 */
>  	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
>  		sizeof(struct kmem_cache_node), GFP_KERNEL);
> +	kmalloc_caches[0].refcount = -1;
>  #endif
>  
>  	/* Able to allocate the per node structures */
> @@ -2520,6 +2521,12 @@ static int slab_unmergeable(struct kmem_
>  	if (s->ctor)
>  		return 1;
>  
> +	/*
> +	 * We may have set a slab to be unmergeable during bootstrap.
> +	 */
> +	if (s->refcount < 0)
> +		return 1;
> +
>  	return 0;
>  }
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
