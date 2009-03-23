Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZCWHzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZCWHzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZCWHzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:55:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCWHzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:55:01 -0400
Subject: Re: [PATCH -mm 5/6] slqb: introduce __kfree_rcu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <49AD3448.6050105@cn.fujitsu.com>
References: <49AD3448.6050105@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 09:54:59 +0200
Message-Id: <1237794899.6313.28.camel@penberg-laptop>
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
> It like __kfree_rcu() in slab.c, slub.c
> We can calculate the object poiter from a poiter inside this
> object in slqb.c, so we can use it for rcu callback and free
> the object.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/slqb.c b/mm/slqb.c
> index 48bdf3b..c258ddc 100644
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -2482,6 +2484,23 @@ void kfree(const void *object)
>  }
>  EXPORT_SYMBOL(kfree);
>  
> +static void kfree_rcu_callback(struct rcu_head *rcu)
> +{
> +	void *portion = rcu;
> +	struct slqb_page *page = virt_to_head_slqb_page(portion);
> +	struct kmem_cache *s = page->list->cache;
> +	unsigned int index = (portion - page->s_mem) / s->size;
> +	void *object = page->s_mem + s->size * index;

Basically the same nit as with the other patches as well: please
separate variable declarations from the initializations for readability.

> +
> +	slab_free(s, page, object);
> +}
> +
> +void __kfree_rcu(const void *objp, struct rcu_head *rcu)
> +{
> +	call_rcu(rcu, kfree_rcu_callback);
> +}
> +EXPORT_SYMBOL(__kfree_rcu);
> +
>  static void kmem_cache_trim_percpu(void *arg)
>  {
>  	int cpu = smp_processor_id();
> 
> 
> 
> 
> 

