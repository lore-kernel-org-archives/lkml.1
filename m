Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZFDAW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZFDAW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZFDAWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:22:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57204 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbZFDAWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:22:18 -0400
Message-ID: <4A27134A.2080209@linux.vnet.ibm.com>
Date: Wed, 03 Jun 2009 17:20:26 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 07/38] pidns 1/2: make create_pid_namespace() accept parent
 pidns
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-7-git-send-email-adobriyan@gmail.com>
In-Reply-To: <1242968132-1044-7-git-send-email-adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> create_pid_namespace() creates everything, but caller has to assign parent
> pidns by hand, which is unnatural. At the moment of call new ->level has
> to be taken from somewhere and parent pidns is already available.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

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

