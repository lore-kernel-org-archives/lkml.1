Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYF3CSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYF3CSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYF3CSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:18:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49651 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYF3CSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:18:35 -0400
Date: Mon, 30 Jun 2008 11:23:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix shmem_unuse_inode charging
Message-Id: <20080630112347.76ed11a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:13:20 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> The mem_cgroup_cache_charge in shmem_unuse_inode has been moved after
> the radix_tree_preload, so generating a BUG: sleeping function called
> from invalid context.  Move it back, uncharging where necessary.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Sure, thanks,

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> Should follow mmotm's memcg-remove-refcnt-from-page_cgroup.patch
> 
> mm/shmem.c |   28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> --- mmotm/mm/shmem.c	2008-06-27 13:39:20.000000000 +0100
> +++ linux/mm/shmem.c	2008-06-27 17:25:41.000000000 +0100
> @@ -922,27 +922,24 @@ found:
>  	error = 1;
>  	if (!inode)
>  		goto out;
> -	error = radix_tree_preload(GFP_KERNEL);
> -	if (error)
> -		goto out;
> -	/*
> -	 * Because we use GFP_NOWAIT in add_to_page_cache(), we can see -ENOMEM
> -	 * failure because of memory pressure in memory resource controller.
> -	 * Then, precharge page while we can wait, uncharge at failure will be
> -	 * automatically done in add_to_page_cache()
> -	 */
> +	/* Precharge page using GFP_KERNEL while we can wait */
>  	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
>  	if (error)
> -		goto preload_out;
> -
> +		goto out;
> +	error = radix_tree_preload(GFP_KERNEL);
> +	if (error) {
> +		mem_cgroup_uncharge_cache_page(page);
> +		goto out;
> +	}
>  	error = 1;
>  
>  	spin_lock(&info->lock);
>  	ptr = shmem_swp_entry(info, idx, NULL);
> -	if (ptr && ptr->val == entry.val)
> -		error = add_to_page_cache(page, inode->i_mapping, idx,
> -					GFP_NOWAIT);
> -	else /* we don't have to account this page. */
> +	if (ptr && ptr->val == entry.val) {
> +		error = add_to_page_cache(page, inode->i_mapping,
> +						idx, GFP_NOWAIT);
> +		/* does mem_cgroup_uncharge_cache_page on error */
> +	} else	/* we must compensate for our precharge above */
>  		mem_cgroup_uncharge_cache_page(page);
>  
>  	if (error == -EEXIST) {
> @@ -969,7 +966,6 @@ found:
>  	if (ptr)
>  		shmem_swp_unmap(ptr);
>  	spin_unlock(&info->lock);
> -preload_out:
>  	radix_tree_preload_end();
>  out:
>  	unlock_page(page);
> 

