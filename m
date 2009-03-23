Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZCWHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZCWHyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZCWHy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:54:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZCWHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:54:27 -0400
Subject: Re: [PATCH -mm 4/6] slqb: record slab's start address in slqb_page
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <49AD3442.5040306@cn.fujitsu.com>
References: <49AD3442.5040306@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 09:54:24 +0200
Message-Id: <1237794864.6313.26.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 21:44 +0800, Lai Jiangshan wrote:
> slqb's slab is coloring, it's will be useful that record the
> color value or start address in struct slqb_page.
> 
> This fix adds a field in struct slqb_page to record slab's
> start address, It will be used by kfree_rcu().
> 
> 
> struct slqb_page has a field:
> 	struct kmem_cache_list *list;
> 
> the corresponding field in struct page is:
> 
> 	union {
> 	    struct {
> 		unsigned long private;
> 		struct address_space *mapping;
> 	    };
> 	    struct kmem_cache *slab;
> 	    struct page *first_page;
> 	};
> 
> It's large than 'struct kmem_cache_list *list;'
> *So we are safe to add a field in struct page.*
> 
> 
> (This field will not become a burden in future:)
> struct page is very small, this fix uses the last room of
> struct page. But if we have to add a more important
> field in struct slqb_page in future, We can record slab's
> color value in slqb_page instead of start address.
> like this:
> 	struct {
> 		unsigned long	flags;
> 		atomic_t	_count;
> 		u16		inuse;		/* use u16 instead */
> 		u16		color;  	/* of unsigned int */
> 		void 		*a_more_important_field;
> 		struct kmem_cache_list *list;
> 		void		 **freelist;
> 		union {
> 			struct list_head lru;
> 			struct rcu_head rcu_head;
> 		};
> 	};
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/slqb.c b/mm/slqb.c
> index 48bdf3b..c258ddc 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -41,6 +41,7 @@ struct slqb_page {
>  			unsigned long	flags;		/* mandatory */
>  			atomic_t	_count;		/* mandatory */
>  			unsigned int	inuse;		/* Nr of objects */
> +			void 		*s_mem;		/* start address */
>  			struct kmem_cache_list *list;	/* Pointer to list */
>  			void		 **freelist;	/* LIFO freelist */
>  			union {
> @@ -1010,6 +1011,7 @@ static struct slqb_page *new_slab_page(struct kmem_cache *s,
>  	}
>  	set_freepointer(s, last, NULL);
>  
> +	page->s_mem = start;
>  	page->freelist = start;
>  	page->inuse = 0;
>  out:

I am okay with this but I think Nick was against it. Nick?

			Pekka

