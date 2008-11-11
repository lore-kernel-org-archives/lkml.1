Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYKKDLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYKKDLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYKKDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:11:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53658 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbYKKDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:11:17 -0500
Date: Tue, 11 Nov 2008 12:10:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v2)
Message-Id: <20081111121039.91017d3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081108091113.32236.12390.sendpatchset@localhost.localdomain>
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain>
	<20081108091113.32236.12390.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Nov 2008 14:41:13 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> Don't enable multiple hierarchy support by default. This patch introduces
> a features element that can be set to enable the nested depth hierarchy
> feature. This feature can only be enabled when the cgroup for which the
> feature this is enabled, has no children.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
IMHO, permission to this is not enough.

I think following is sane way.
==
   When parent->use_hierarchy==1.
	my->use_hierarchy must be "1" and cannot be tunrned to be "0" even if no children.
   When parent->use_hierarchy==0
	my->use_hierarchy can be either of "0" or "1".
	this value can be chagned if we don't have children
==

Thanks,
-Kame


>  mm/memcontrol.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff -puN mm/memcontrol.c~memcg-add-hierarchy-selector mm/memcontrol.c
> --- linux-2.6.28-rc2/mm/memcontrol.c~memcg-add-hierarchy-selector	2008-11-08 14:09:33.000000000 +0530
> +++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-08 14:10:53.000000000 +0530
> @@ -137,6 +137,11 @@ struct mem_cgroup {
>  	 * reclaimed from.
>  	 */
>  	struct mem_cgroup *last_scanned_child;
> +	/*
> +	 * Should the accounting and control be hierarchical, per subtree?
> +	 */
> +	unsigned long use_hierarchy;
> +
>  };
>  static struct mem_cgroup init_mem_cgroup;
>  
> @@ -1079,6 +1084,33 @@ out:
>  	return ret;
>  }
>  
> +static u64 mem_cgroup_hierarchy_read(struct cgroup *cont, struct cftype *cft)
> +{
> +	return mem_cgroup_from_cont(cont)->use_hierarchy;
> +}
> +
> +static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
> +					u64 val)
> +{
> +	int retval = 0;
> +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> +
> +	if (val == 1) {
> +		if (list_empty(&cont->children))
> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else if (val == 0) {
> +		if (list_empty(&cont->children))
> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else
> +		retval = -EINVAL;
> +
> +	return retval;
> +}
> +
>  static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
>  {
>  	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
> @@ -1213,6 +1245,11 @@ static struct cftype mem_cgroup_files[] 
>  		.name = "stat",
>  		.read_map = mem_control_stat_show,
>  	},
> +	{
> +		.name = "use_hierarchy",
> +		.write_u64 = mem_cgroup_hierarchy_write,
> +		.read_u64 = mem_cgroup_hierarchy_read,
> +	},
>  };
>  
>  static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
> @@ -1289,9 +1326,13 @@ mem_cgroup_create(struct cgroup_subsys *
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		if (!mem)
>  			return ERR_PTR(-ENOMEM);
> +		mem->use_hierarchy = parent->use_hierarchy;
>  	}
>  
> -	res_counter_init(&mem->res, parent ? &parent->res : NULL);
> +	if (parent && parent->use_hierarchy)
> +		res_counter_init(&mem->res, &parent->res);
> +	else
> +		res_counter_init(&mem->res, NULL);
>  
>  	for_each_node_state(node, N_POSSIBLE)
>  		if (alloc_mem_cgroup_per_zone_info(mem, node))
> _
> 
> -- 
> 	Balbir
> 

