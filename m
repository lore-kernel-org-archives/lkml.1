Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZDJW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZDJW4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZDJW4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:56:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43203 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDJW4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:56:38 -0400
Date: Fri, 10 Apr 2009 17:56:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/30] netns: extract net_create()
Message-ID: <20090410225636.GD13873@us.ibm.com>
References: <20090410023448.GH27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023448.GH27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> net_create() will be used by C/R code to create fresh netns on restart.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

Although this ends up making a new assumption that setup_net(), and
therefore the pernet_ops->init() functions, do not return error > 0.
There's nothing actually stopping that (outside of code review, but
there appears to be no comment anywhere saying that's uncooth).

If it returns > 0, then we return the ns as though it were valid, but
don't add it to the list of namespaces...  Do we care?

-serge

> ---
> 
>  include/net/net_namespace.h |    1 +
>  net/core/net_namespace.c    |   44 ++++++++++++++++++++------------------------
>  2 files changed, 21 insertions(+), 24 deletions(-)
> 
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -107,6 +107,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
>  extern struct list_head net_namespace_list;
> 
>  #ifdef CONFIG_NET_NS
> +struct net *net_create(void);
>  extern void __put_net(struct net *net);
> 
>  static inline struct net *get_net(struct net *net)
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -115,38 +115,34 @@ static void net_free(struct net *net)
>  	kmem_cache_free(net_cachep, net);
>  }
> 
> -struct net *copy_net_ns(unsigned long flags, struct net *old_net)
> +struct net *net_create(void)
>  {
> -	struct net *new_net = NULL;
> -	int err;
> -
> -	if (!(flags & CLONE_NEWNET))
> -		return get_net(old_net);
> -
> -	err = -ENOMEM;
> -	new_net = net_alloc();
> -	if (!new_net)
> -		goto out_err;
> +	struct net *net;
> +	int rv;
> 
> +	net = net_alloc();
> +	if (!net)
> +		return ERR_PTR(-ENOMEM);
>  	mutex_lock(&net_mutex);
> -	err = setup_net(new_net);
> -	if (!err) {
> +	rv = setup_net(net);
> +	if (rv == 0) {
>  		rtnl_lock();
> -		list_add_tail(&new_net->list, &net_namespace_list);
> +		list_add_tail(&net->list, &net_namespace_list);
>  		rtnl_unlock();
>  	}
>  	mutex_unlock(&net_mutex);
> +	if (rv < 0) {
> +		net_free(net);
> +		return ERR_PTR(rv);
> +	}
> +	return net;
> +}
> 
> -	if (err)
> -		goto out_free;
> -out:
> -	return new_net;
> -
> -out_free:
> -	net_free(new_net);
> -out_err:
> -	new_net = ERR_PTR(err);
> -	goto out;
> +struct net *copy_net_ns(unsigned long flags, struct net *old_net)
> +{
> +	if (!(flags & CLONE_NEWNET))
> +		return get_net(old_net);
> +	return net_create();
>  }
> 
>  static void cleanup_net(struct work_struct *work)
