Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYKQV3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYKQV3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYKQV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:29:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60966 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYKQV3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:29:09 -0500
Subject: Re: 2.6.28-rc4 mem_cgroup_charge_common panic
From: Badari Pulavarty <pbadari@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081114131058.8d538481.kamezawa.hiroyu@jp.fujitsu.com>
References: <1226353408.8805.12.camel@badari-desktop>
	 <20081111101440.f531021d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081111110934.d41fa8db.kamezawa.hiroyu@jp.fujitsu.com>
	 <1226527376.4835.8.camel@badari-desktop>
	 <20081113111702.9a5b6ce7.kamezawa.hiroyu@jp.fujitsu.com>
	 <1226602404.29381.6.camel@badari-desktop>
	 <20081114131058.8d538481.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 13:30:08 -0800
Message-Id: <1226957408.17897.1.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 13:10 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 13 Nov 2008 10:53:24 -0800
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > I tried mmtom + startpfn fix + this fix + notifier fix. Didn't help.
> > I am not using SLUB (using SLAB). Yes. I am testing "real" memory
> > remove (not just offline/online), since it executes more code of
> > freeing memmap etc.
> > 
> > Code that is panicing is list_add() in mem_cgroup_add_list().
> > I will debug it further.
> > 
> 
> Considering difference between "real" memory hotplug and logical ones,
> I found this. I hope this fixes the bug.
> But I myself can't do test this..
> 
> Thanks,
> -Kame
> 

Kame,

With this patch I am able to run tests without any issues.

Sorry for delayed response, I wanted to make sure test runs fine over
the weekend.

Tested-by: Badari Pulavarty <pbadari@us.ibm.com>

Thanks,
Badari


> ==
> Fixes for memcg/memory hotplug.
> 
> 
> While memory hotplug allocate/free memmap, page_cgroup doesn't free
> page_cgroup at OFFLINE when page_cgroup is allocated via bootomem.
> (Because freeing bootmem requires special care.)
> 
> Then, if page_cgroup is allocated by bootmem and memmap is freed/allocated
> by memory hotplug, page_cgroup->page == page is no longer true and
> we have to update that.
> 
> But current MEM_ONLINE handler doesn't check it and update page_cgroup->page
> if it's not necessary to allocate page_cgroup.
> 
> And I noticed that MEM_ONLINE can be called against "part of section".
> So, freeing page_cgroup at CANCEL_ONLINE will cause trouble.
> (freeing used page_cgroup)
> Don't rollback at CANCEL. 
> 
> One more, current memory hotplug notifier is stopped by slub
> because it sets NOTIFY_STOP_MASK to return vaule. So, page_cgroup's callback
> never be called. (low priority than slub now.)
> 
> I think this slub's behavior is not intentional(BUG). and fixes it.
> 
> 
> Another way to be considered about page_cgroup allocation:
>   - free page_cgroup at OFFLINE even if it's from bootmem
>     and remove specieal handler. But it requires more changes.
> 
> 
> Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  mm/page_cgroup.c |   39 +++++++++++++++++++++++++++------------
>  mm/slub.c        |    6 ++++--
>  2 files changed, 31 insertions(+), 14 deletions(-)
> 
> Index: mmotm-2.6.28-Nov10/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/mm/page_cgroup.c
> +++ mmotm-2.6.28-Nov10/mm/page_cgroup.c
> @@ -104,18 +104,30 @@ int __meminit init_section_page_cgroup(u
>  	unsigned long table_size;
>  	int nid, index;
> 
> -	if (section->page_cgroup)
> -		return 0;
> +	if (!section->page_cgroup) {
> 
> -	nid = page_to_nid(pfn_to_page(pfn));
> -	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
> -	if (slab_is_available()) {
> -		base = kmalloc_node(table_size, GFP_KERNEL, nid);
> -		if (!base)
> -			base = vmalloc_node(table_size, nid);
> -	} else {
> -		base = __alloc_bootmem_node_nopanic(NODE_DATA(nid), table_size,
> +		nid = page_to_nid(pfn_to_page(pfn));
> +		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
> +		if (slab_is_available()) {
> +			base = kmalloc_node(table_size, GFP_KERNEL, nid);
> +			if (!base)
> +				base = vmalloc_node(table_size, nid);
> +		} else {
> +			base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> +				table_size,
>  				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> +		}
> +	} else {
> +		/*
> + 		 * We don't have to allocate page_cgroup again, but
> +		 * address of memmap may be changed. So, we have to initialize
> +		 * again.
> +		 */
> +		base = section->page_cgroup + pfn;
> +		table_size = 0;
> +		/* check address of memmap is changed or not. */
> +		if (base->page == pfn_to_page(pfn))
> +			return 0;
>  	}
> 
>  	if (!base) {
> @@ -204,19 +216,22 @@ static int page_cgroup_callback(struct n
>  		ret = online_page_cgroup(mn->start_pfn,
>  				   mn->nr_pages, mn->status_change_nid);
>  		break;
> -	case MEM_CANCEL_ONLINE:
>  	case MEM_OFFLINE:
>  		offline_page_cgroup(mn->start_pfn,
>  				mn->nr_pages, mn->status_change_nid);
>  		break;
>  	case MEM_GOING_OFFLINE:
> +	case MEM_CANCEL_ONLINE:
>  		break;
>  	case MEM_ONLINE:
>  	case MEM_CANCEL_OFFLINE:
>  		break;
>  	}
> 
> -	ret = notifier_from_errno(ret);
> +	if (ret)
> +		ret = notifier_from_errno(ret);
> +	else
> +		ret = NOTIFY_OK;
> 
>  	return ret;
>  }
> Index: mmotm-2.6.28-Nov10/mm/slub.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/mm/slub.c
> +++ mmotm-2.6.28-Nov10/mm/slub.c
> @@ -3220,8 +3220,10 @@ static int slab_memory_callback(struct n
>  	case MEM_CANCEL_OFFLINE:
>  		break;
>  	}
> -
> -	ret = notifier_from_errno(ret);
> +	if (ret)
> +		ret = notifier_from_errno(ret);
> +	else
> +		ret = NOTIFY_OK;
>  	return ret;
>  }
> 
> 

