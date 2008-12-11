Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYLKAuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYLKAuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLKAug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:50:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37089 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYLKAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:50:34 -0500
Date: Thu, 11 Dec 2008 09:49:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: menage@google.com
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory
 controller
Message-Id: <20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081210234432.236302000@menage.corp.google.com>
References: <20081210233654.563182000@menage.corp.google.com>
	<20081210234432.236302000@menage.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 15:36:56 -0800
menage@google.com wrote:

> This patch updates the memory controller to use its hierarchy_mutex
> rather than calling cgroup_lock() to protected against
> cgroup_mkdir()/cgroup_rmdir() from occurring in its hierarchy.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
Hmm, can we avoid following kind of dead-lock by this ?

Assume subsys A and B is on the same hierarchy, A's subsys ID is smaller than B's.
(I assume memory and cpuset for A and B, but just an example.)

	an operation like rmdir() in somewhere.
		hierarchy_lock for A (acquired)
		hierarchy_lock for B (waiting)

	in subsys A.
		mmap_sem (acquired)
		hierarchy_lock for A (waiting)
	in subsys B.
		hierarchy_lock for B (aquired)
		mmap_sem 	     (waiting)



Thanks,
-Kame

> ---
>  mm/memcontrol.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> Index: hierarchy_lock-mmotm-2008-12-09/mm/memcontrol.c
> ===================================================================
> --- hierarchy_lock-mmotm-2008-12-09.orig/mm/memcontrol.c
> +++ hierarchy_lock-mmotm-2008-12-09/mm/memcontrol.c
> @@ -154,7 +154,7 @@ struct mem_cgroup {
>  
>  	/*
>  	 * While reclaiming in a hiearchy, we cache the last child we
> -	 * reclaimed from. Protected by cgroup_lock()
> +	 * reclaimed from. Protected by hierarchy_mutex
>  	 */
>  	struct mem_cgroup *last_scanned_child;
>  	/*
> @@ -529,7 +529,7 @@ unsigned long mem_cgroup_isolate_pages(u
>  
>  /*
>   * This routine finds the DFS walk successor. This routine should be
> - * called with cgroup_mutex held
> + * called with hierarchy_mutex held
>   */
>  static struct mem_cgroup *
>  mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
> @@ -598,7 +598,7 @@ mem_cgroup_get_first_node(struct mem_cgr
>  	/*
>  	 * Scan all children under the mem_cgroup mem
>  	 */
> -	cgroup_lock();
> +	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
>  	if (list_empty(&root_mem->css.cgroup->children)) {
>  		ret = root_mem;
>  		goto done;
> @@ -619,7 +619,7 @@ mem_cgroup_get_first_node(struct mem_cgr
>  
>  done:
>  	root_mem->last_scanned_child = ret;
> -	cgroup_unlock();
> +	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
>  	return ret;
>  }
>  
> @@ -683,18 +683,16 @@ static int mem_cgroup_hierarchical_recla
>  	while (next_mem != root_mem) {
>  		if (next_mem->obsolete) {
>  			mem_cgroup_put(next_mem);
> -			cgroup_lock();
>  			next_mem = mem_cgroup_get_first_node(root_mem);
> -			cgroup_unlock();
>  			continue;
>  		}
>  		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
>  						   get_swappiness(next_mem));
>  		if (mem_cgroup_check_under_limit(root_mem))
>  			return 0;
> -		cgroup_lock();
> +		mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
>  		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
> -		cgroup_unlock();
> +		mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
>  	}
>  	return ret;
>  }
> 
> --
> 

