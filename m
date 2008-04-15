Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbYDOB7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbYDOB7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbYDOB71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:59:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759417AbYDOB70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:59:26 -0400
Message-ID: <48040B7D.4040708@cn.fujitsu.com>
Date: Tue, 15 Apr 2008 09:57:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, menage@google.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation.
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On ia64, kmalloc() in mem_cgroup_create requires order-4 pages. But this is not
> necessary to be phisically contiguous. And we'll see page allocation failure.
> (Note: x86-32, which has small vmalloc area, has small mem_cgroup struct.)
> For here, vmalloc is better.
> 
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
> @@ -993,7 +994,7 @@ mem_cgroup_create(struct cgroup_subsys *
>  		mem = &init_mem_cgroup;
>  		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
>  	} else
> -		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
> +		mem = vmalloc(sizeof(struct mem_cgroup));
>  

memset(mem, 0, sizeof(*mem));

should we initialize it with 0?

>  	if (mem == NULL)
>  		return ERR_PTR(-ENOMEM);
> @@ -1011,7 +1012,7 @@ free_out:
>  	for_each_node_state(node, N_POSSIBLE)
>  		free_mem_cgroup_per_zone_info(mem, node);
>  	if (cont->parent != NULL)
> -		kfree(mem);
> +		vfree(mem);
>  	return ERR_PTR(-ENOMEM);
>  }
>  
> @@ -1031,7 +1032,7 @@ static void mem_cgroup_destroy(struct cg
>  	for_each_node_state(node, N_POSSIBLE)
>  		free_mem_cgroup_per_zone_info(mem, node);
>  
> -	kfree(mem_cgroup_from_cont(cont));
> +	vfree(mem_cgroup_from_cont(cont));
>  }
>  
>  static int mem_cgroup_populate(struct cgroup_subsys *ss,
> 
>
