Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZCWHsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZCWHsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZCWHs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:48:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39049 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZCWHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:48:26 -0400
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <49AD3433.9000001@cn.fujitsu.com>
References: <49AD3433.9000001@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 09:48:22 +0200
Message-Id: <1237794502.6313.21.camel@penberg-laptop>
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
> We can calculate the object poiter from a poiter inside this
> object in slab.c, so we can use a portion_to_obj() to instead
> various container_of() for rcu callback and free the object.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/slab.c b/mm/slab.c
> index 4d00855..a067d3f 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -634,6 +634,17 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
>  	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
>  }
>  
> +static inline void *portion_to_obj(void *portion)
> +{
> +	struct page *page = virt_to_head_page(portion);
> +	struct slab *slab = page_get_slab(page);
> +	struct kmem_cache *cache = page_get_cache(page);
> +	unsigned int offset = portion - slab->s_mem;
> +	unsigned int index = offset / cache->buffer_size;
> +
> +	return index_to_obj(cache, slab, index);
> +}

A minor nit: I think this would be more readable if you separated
variable declarations from the initializations. Also, you can probably
drop the inline from the function declaration and let GCC decide what to
do.

