Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZAHLIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZAHLIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZAHLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:08:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56623 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZAHLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:08:05 -0500
Message-ID: <39822.10.75.179.62.1231412881.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090108191501.dc469a51.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
    <20090108191501.dc469a51.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 8 Jan 2009 20:08:01 +0900 (JST)
Subject: Re: [RFC][PATCH 3/4] memcg: fix for mem_cgroup_hierarchical_reclaim
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> If root_mem has no children, last_scaned_child is set to root_mem itself.
> But after some children added to root_mem, mem_cgroup_get_next_node can
> mem_cgroup_put the root_mem although root_mem has not been mem_cgroup_get.
>
> This patch fixes this behavior by:
> - Set last_scanned_child to NULL if root_mem has no children or DFS search
>   has returned to root_mem itself(root_mem is not a "child" of root_mem).
>   Make mem_cgroup_get_first_node return root_mem in this case.
>   There are no mem_cgroup_get/put for root_mem.
> - Rename mem_cgroup_get_next_node to __mem_cgroup_get_next_node, and
>   mem_cgroup_get_first_node to mem_cgroup_get_next_node.
>   Make mem_cgroup_hierarchical_reclaim call only new
> mem_cgroup_get_next_node.
>
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Hmm, seems necessary fix. Then, it's better to rebase my patch on to this.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Maybe simpler one can be written but my patch remove all this out later....

Thanks,
-Kame

> ---
>  mm/memcontrol.c |   37 +++++++++++++++++++++----------------
>  1 files changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 288e22c..dc38a0e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -622,7 +622,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long
> nr_to_scan,
>   * called with hierarchy_mutex held
>   */
>  static struct mem_cgroup *
> -mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup
> *root_mem)
> +__mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup
> *root_mem)
>  {
>  	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
>
> @@ -644,8 +644,8 @@ mem_cgroup_get_next_node(struct mem_cgroup *curr,
> struct mem_cgroup *root_mem)
>  visit_parent:
>  	if (curr_cgroup == root_cgroup) {
>  		mem_cgroup_put(curr);
> -		curr = root_mem;
> -		mem_cgroup_get(curr);
> +		/* caller handles NULL case */
> +		curr = NULL;
>  		goto done;
>  	}
>
> @@ -668,7 +668,6 @@ visit_parent:
>  	goto visit_parent;
>
>  done:
> -	root_mem->last_scanned_child = curr;
>  	return curr;
>  }
>
> @@ -678,20 +677,29 @@ done:
>   * that to reclaim free pages from.
>   */
>  static struct mem_cgroup *
> -mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
> +mem_cgroup_get_next_node(struct mem_cgroup *root_mem)
>  {
>  	struct cgroup *cgroup;
>  	struct mem_cgroup *ret;
>  	bool obsolete;
>
> -	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
> -
>  	/*
>  	 * Scan all children under the mem_cgroup mem
>  	 */
>  	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
> +
> +	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
> +
>  	if (list_empty(&root_mem->css.cgroup->children)) {
> -		ret = root_mem;
> +		/*
> +		 * root_mem might have children before and last_scanned_child
> +		 * may point to one of them.
> +		 */
> +		if (root_mem->last_scanned_child) {
> +			VM_BUG_ON(!obsolete);
> +			mem_cgroup_put(root_mem->last_scanned_child);
> +		}
> +		ret = NULL;
>  		goto done;
>  	}
>
> @@ -705,13 +713,13 @@ mem_cgroup_get_first_node(struct mem_cgroup
> *root_mem)
>  		ret = mem_cgroup_from_cont(cgroup);
>  		mem_cgroup_get(ret);
>  	} else
> -		ret = mem_cgroup_get_next_node(root_mem->last_scanned_child,
> +		ret = __mem_cgroup_get_next_node(root_mem->last_scanned_child,
>  						root_mem);
>
>  done:
>  	root_mem->last_scanned_child = ret;
>  	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
> -	return ret;
> +	return (ret) ? ret : root_mem;
>  }
>
>  static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
> @@ -769,21 +777,18 @@ static int mem_cgroup_hierarchical_reclaim(struct
> mem_cgroup *root_mem,
>  	if (!root_mem->use_hierarchy)
>  		return ret;
>
> -	next_mem = mem_cgroup_get_first_node(root_mem);
> +	next_mem = mem_cgroup_get_next_node(root_mem);
>
>  	while (next_mem != root_mem) {
>  		if (mem_cgroup_is_obsolete(next_mem)) {
> -			mem_cgroup_put(next_mem);
> -			next_mem = mem_cgroup_get_first_node(root_mem);
> +			next_mem = mem_cgroup_get_next_node(root_mem);
>  			continue;
>  		}
>  		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
>  						   get_swappiness(next_mem));
>  		if (mem_cgroup_check_under_limit(root_mem))
>  			return 0;
> -		mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
> -		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
> -		mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
> +		next_mem = mem_cgroup_get_next_node(root_mem);
>  	}
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


