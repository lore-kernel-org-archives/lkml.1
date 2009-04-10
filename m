Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbZDJWdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbZDJWdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZDJWdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:33:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59441 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZDJWdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:33:20 -0400
Date: Fri, 10 Apr 2009 17:33:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/30] nsproxy: add create_nsproxy()
Message-ID: <20090410223318.GB13873@us.ibm.com>
References: <20090410023413.GF27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023413.GF27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> clone_nsproxy() does useless copying of old nsproxy -- every pointer
> will be rewritten to new ns or to old ns.
> 
> Remove copying, rename clone_nsproxy(), it will be used by C/R code
> to create fresh nsproxy on restart.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  kernel/nsproxy.c |   19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -26,19 +26,14 @@ static struct kmem_cache *nsproxy_cachep;
> 
>  struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
> 
> -/*
> - * creates a copy of "orig" with refcount 1.
> - */
> -static inline struct nsproxy *clone_nsproxy(struct nsproxy *orig)
> +static inline struct nsproxy *create_nsproxy(void)
>  {
> -	struct nsproxy *ns;
> +	struct nsproxy *nsproxy;
> 
> -	ns = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
> -	if (ns) {
> -		memcpy(ns, orig, sizeof(struct nsproxy));
> -		atomic_set(&ns->count, 1);
> -	}
> -	return ns;
> +	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
> +	if (nsproxy)
> +		atomic_set(&nsproxy->count, 1);
> +	return nsproxy;
>  }
> 
>  /*
> @@ -52,7 +47,7 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>  	struct nsproxy *new_nsp;
>  	int err;
> 
> -	new_nsp = clone_nsproxy(tsk->nsproxy);
> +	new_nsp = create_nsproxy();
>  	if (!new_nsp)
>  		return ERR_PTR(-ENOMEM);
