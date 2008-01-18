Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbYARFzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbYARFzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYARFzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:55:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33862 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYARFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:55:35 -0500
Date: Thu, 17 Jan 2008 21:55:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rculist.h: use the rcu API
Message-ID: <20080118055529.GE8477@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <478FBEA0.9090203@gmail.com> <478FBF19.1090009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478FBF19.1090009@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:48:25PM +0100, Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> This patch makes almost all list mutation primitives use
> rcu_assign_pointer().
> 
> The main point of this being readability improvement.

Looks better to me!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  include/linux/rculist.h |   23 +++++++++--------------
>  1 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 8056d38..038b64f 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -7,6 +7,7 @@
>   * RCU-protected list version
>   */
>  #include <linux/list.h>
> +#include <linux/rcupdate.h>
> 
>  /*
>   * Insert a new entry between two known consecutive entries.
> @@ -19,9 +20,8 @@ static inline void __list_add_rcu(struct list_head * new,
>  {
>  	new->next = next;
>  	new->prev = prev;
> -	smp_wmb();
> +	rcu_assign_pointer(prev->next, new);
>  	next->prev = new;
> -	prev->next = new;
>  }
> 
>  /**
> @@ -110,9 +110,8 @@ static inline void list_replace_rcu(struct list_head *old,
>  {
>  	new->next = old->next;
>  	new->prev = old->prev;
> -	smp_wmb();
> +	rcu_assign_pointer(new->prev->next, new);
>  	new->next->prev = new;
> -	new->prev->next = new;
>  	old->prev = LIST_POISON2;
>  }
> 
> @@ -166,8 +165,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
>  	 */
> 
>  	last->next = at;
> -	smp_wmb();
> -	head->next = first;
> +	rcu_assign_pointer(head->next, first);
>  	first->prev = head;
>  	at->prev = last;
>  }
> @@ -280,10 +278,9 @@ static inline void hlist_replace_rcu(struct hlist_node *old,
> 
>  	new->next = next;
>  	new->pprev = old->pprev;
> -	smp_wmb();
> +	rcu_assign_pointer(*new->pprev, new);
>  	if (next)
>  		new->next->pprev = &new->next;
> -	*new->pprev = new;
>  	old->pprev = LIST_POISON2;
>  }
> 
> @@ -310,12 +307,12 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
>  					struct hlist_head *h)
>  {
>  	struct hlist_node *first = h->first;
> +
>  	n->next = first;
>  	n->pprev = &h->first;
> -	smp_wmb();
> +	rcu_assign_pointer(h->first, n);
>  	if (first)
>  		first->pprev = &n->next;
> -	h->first = n;
>  }
> 
>  /**
> @@ -341,9 +338,8 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
>  {
>  	n->pprev = next->pprev;
>  	n->next = next;
> -	smp_wmb();
> +	rcu_assign_pointer(*(n->pprev), n);
>  	next->pprev = &n->next;
> -	*(n->pprev) = n;
>  }
> 
>  /**
> @@ -369,8 +365,7 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
>  {
>  	n->next = prev->next;
>  	n->pprev = &prev->next;
> -	smp_wmb();
> -	prev->next = n;
> +	rcu_assign_pointer(prev->next, n);
>  	if (n->next)
>  		n->next->pprev = &n->next;
>  }
> -- 
> 1.5.3.7
> 
