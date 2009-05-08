Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbZEHTXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbZEHTXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZEHTXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:23:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55212 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbZEHTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:23:34 -0400
Date: Fri, 8 May 2009 14:15:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, xemul@parallels.com
Subject: Re: [PATCH 1/2] pidns 1/2: make create_pid_namespace() accept
	parent pidns
Message-ID: <20090508191552.GA28885@us.ibm.com>
References: <20090503232700.GD16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503232700.GD16631@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> create_pid_namespace() creates everything, but caller has to assign parent
> pidns by hand, which is unnatural. At the moment of call new ->level has
> to be taken from somewhere and parent pidns is already available.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Yes, nicer.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/pid_namespace.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 2d1001b..495d5de 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -67,9 +67,10 @@ err_alloc:
>  	return NULL;
>  }
> 
> -static struct pid_namespace *create_pid_namespace(unsigned int level)
> +static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
>  {
>  	struct pid_namespace *ns;
> +	unsigned int level = parent_pid_ns->level + 1;
>  	int i;
> 
>  	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
> @@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
> 
>  	kref_init(&ns->kref);
>  	ns->level = level;
> +	ns->parent = get_pid_ns(parent_pid_ns);
> 
>  	set_bit(0, ns->pidmap[0].page);
>  	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
> @@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old
>  	if (flags & CLONE_THREAD)
>  		goto out_put;
> 
> -	new_ns = create_pid_namespace(old_ns->level + 1);
> -	if (!IS_ERR(new_ns))
> -		new_ns->parent = get_pid_ns(old_ns);
> +	new_ns = create_pid_namespace(old_ns);
> 
>  out_put:
>  	put_pid_ns(old_ns);
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
