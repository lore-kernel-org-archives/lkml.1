Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbYDOCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbYDOCXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYDOCXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:23:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758081AbYDOCXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:23:15 -0400
Date: Mon, 14 Apr 2008 19:17:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, lizf@cn.fujitsu.com,
       menage@google.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation. v2
Message-Id: <20080414191730.7d13e619.akpm@linux-foundation.org>
In-Reply-To: <20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
	<20080415111038.ffac0e12.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 11:10:38 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On ia64, this kmalloc() requires order-4 pages. But this is not
> necessary to be phisically contiguous. (and x86-32, which has
> small vmalloc area, has small mem_cgroup struct.)
> 
> For here, vmalloc is better.
> 
> Changelog: v1->v2
>  - added memset().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Index: mm-2.6.25-rc8-mm2/mm/memcontrol.c
> ===================================================================
> --- mm-2.6.25-rc8-mm2.orig/mm/memcontrol.c
> +++ mm-2.6.25-rc8-mm2/mm/memcontrol.c
> @@ -31,6 +31,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/fs.h>
>  #include <linux/seq_file.h>
> +#include <linux/vmalloc.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -992,8 +993,10 @@ mem_cgroup_create(struct cgroup_subsys *
>  	if (unlikely((cont->parent) == NULL)) {
>  		mem = &init_mem_cgroup;
>  		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
> -	} else
> -		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
> +	} else {
> +		mem = vmalloc(sizeof(struct mem_cgroup));
> +		memset(mem, 0, sizeof(*mem));
> +	}
>  
>  	if (mem == NULL)
>  		return ERR_PTR(-ENOMEM);
> @@ -1011,7 +1014,7 @@ free_out:
>  	for_each_node_state(node, N_POSSIBLE)
>  		free_mem_cgroup_per_zone_info(mem, node);
>  	if (cont->parent != NULL)
> -		kfree(mem);
> +		vfree(mem);
>  	return ERR_PTR(-ENOMEM);
>  }
>  
> @@ -1031,7 +1034,7 @@ static void mem_cgroup_destroy(struct cg
>  	for_each_node_state(node, N_POSSIBLE)
>  		free_mem_cgroup_per_zone_info(mem, node);
>  
> -	kfree(mem_cgroup_from_cont(cont));
> +	vfree(mem_cgroup_from_cont(cont));
>  }
>  
>  static int mem_cgroup_populate(struct cgroup_subsys *ss,

Well...  vmalloced memory is of course a little slower to use - additional
TLB pressure.

Do you think the memcgroup is accessed frequently enough to use vmalloc()
only on those architectures which actually need it?

Because it'd be pretty simple to implement:

	if (sizeof(struct mem_group) > PAGE_SIZE)
		vmalloc()
	else
		kmalloc()

	...

	if (sizeof(struct mem_group) > PAGE_SIZE)
		vfree()
	else
		kfree()

the compiler will optimise away the `if'.
