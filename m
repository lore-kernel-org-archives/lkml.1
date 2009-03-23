Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCWHuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCWHuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZCWHua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:50:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33062 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbZCWHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:50:29 -0400
Subject: Re: [PATCH -mm 3/6] slub: introduce __kfree_rcu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <49AD343E.6010903@cn.fujitsu.com>
References: <49AD343E.6010903@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 09:50:26 +0200
Message-Id: <1237794626.6313.24.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 21:44 +0800, Lai Jiangshan wrote:
> Introduce __kfree_rcu() for kfree_rcu()
> 
> It like __kfree_rcu() in slab.c.
> We can calculate the object poiter from a poiter inside this
> object in slub.c, so we can use it for rcu callback and free
> the object.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/slub.c b/mm/slub.c
> index 0280eee..b438ec5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2756,6 +2756,30 @@ void kfree(const void *x)
>  }
>  EXPORT_SYMBOL(kfree);
>  
> +static void kfree_rcu_callback(struct rcu_head *rcu)
> +{
> +	void *portion = rcu;
> +	struct page *page = virt_to_head_page(portion);
> +
> +	if (unlikely(!PageSlab(page))) {
> +		BUG_ON(!PageCompound(page));

I'd prefer you did a WARN_ON() to increase the likelihood that people
will be able to copy-paste the oops for a bug report.

> +		put_page(page);
> +	} else {
> +		struct kmem_cache *s = page->slab;
> +		void *start = page_address(page);
> +		unsigned int index = (portion - start) / s->size;
> +		void *object = start + s->size * index;
> +

Again, I think the above would be more readable if you split the
variable initialization from the declaration.

> +		slab_free(s, page, object, _RET_IP_);
> +	}
> +}
> +
> +void __kfree_rcu(const void *x, struct rcu_head *rcu)
> +{
> +	call_rcu(rcu, kfree_rcu_callback);
> +}
> +EXPORT_SYMBOL(__kfree_rcu);
> +
>  /*
>   * kmem_cache_shrink removes empty slabs from the partial lists and sorts
>   * the remaining slabs by the number of items in use. The slabs with the
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

