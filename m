Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZGAJeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZGAJeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZGAJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:34:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:16546 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZGAJeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:34:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,322,1243839600"; 
   d="scan'208";a="529318404"
Subject: Re: [patch] fix hugepage unuseable issu on non-NUMA machine
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Chen, Tim C" <tim.c.chen@intel.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
In-Reply-To: <4A48F377.3020008@kernel.org>
References: <1246273802.3160.28.camel@alexs-hp>
	 <4A48F377.3020008@kernel.org>
Content-Type: text/plain
Organization: intel.com
Date: Wed, 01 Jul 2009 17:38:58 +0800
Message-Id: <1246441138.3042.18.camel@alexs-hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried your patch. the specjbb2005 still can not run with the
following parameters under jrockit-R27.3.1-jre1.5.0_11 and with totla
2GB hugepage memory setting. 
JAVA_OPTION= -Xmx2g -Xms2g -Xns1g -XXaggressive -Xlargepages -XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k  -Djava.awt.headless=true


Alex 



On Tue, 2009-06-30 at 01:01 +0800, Yinghai Lu wrote:
> alex.shi wrote:
> > 73d60b7f747176dbdff826c4127d22e1fd3f9f74 commit introduced a nodes_clear
> > function for NUMA machine. But seems the commit omits non-NUMA machine.
> > If find_zone_movable_pfns_for_nodes/early_calculate_totalpages has no
> > chance to run. nodes_clear will block HUPEPAGE using in my specjbb2005
> > testing. 
> > 
> > 
> > So maybe we need to disable nodes_clear sometimes. With the following
> > patch. specjbb2005 recovered. 
> 
> please check if following patch fixed your problem
> 
> [PATCH] x86: only clear node_states for 64bit
> 
> Nathan reported that
> | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
> | Author: Yinghai Lu <yinghai@kernel.org>
> | Date:   Tue Jun 16 15:33:00 2009 -0700
> |
> |    page-allocator: clear N_HIGH_MEMORY map before we set it again
> |    
> |    SRAT tables may contains nodes of very small size.  The arch code may
> |    decide to not activate such a node.  However, currently the early boot
> |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
> |    active although these nodes have no present pages.
> |    
> |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
> 
> broke the cpuset.mems cgroup attribute on an i386 kvm guest
> 
> fix it by only clearing node_states[N_NORMAL_MEMORY] for 64bit only.
> and need to do save/restore for that in find_zone_movable_pfn
> 
> Reported-by: Nathan Lynch <ntl@pobox.com>
> Tested-by: Nathan Lynch <ntl@pobox.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/mm/init_64.c |    2 ++
>  mm/page_alloc.c       |   13 +++++++------
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_64.c
> +++ linux-2.6/arch/x86/mm/init_64.c
> @@ -598,6 +598,8 @@ void __init paging_init(void)
>  
>  	sparse_memory_present_with_active_regions(MAX_NUMNODES);
>  	sparse_init();
> +	/* clear the default setting with node 0 */
> +	nodes_clear(node_states[N_NORMAL_MEMORY]);
>  	free_area_init_nodes(max_zone_pfns);
>  }
>  
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -4037,6 +4037,8 @@ static void __init find_zone_movable_pfn
>  	int i, nid;
>  	unsigned long usable_startpfn;
>  	unsigned long kernelcore_node, kernelcore_remaining;
> +	/* save the state before borrow the nodemask */
> +	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
>  	unsigned long totalpages = early_calculate_totalpages();
>  	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
>  
> @@ -4064,7 +4066,7 @@ static void __init find_zone_movable_pfn
>  
>  	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
>  	if (!required_kernelcore)
> -		return;
> +		goto out;
>  
>  	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
>  	find_usable_zone_for_movable();
> @@ -4163,6 +4165,10 @@ restart:
>  	for (nid = 0; nid < MAX_NUMNODES; nid++)
>  		zone_movable_pfn[nid] =
>  			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
> +
> +out:
> +	/* restore the node_state */
> +	node_states[N_HIGH_MEMORY] = saved_node_state;
>  }
>  
>  /* Any regular memory on that node ? */
> @@ -4247,11 +4253,6 @@ void __init free_area_init_nodes(unsigne
>  						early_node_map[i].start_pfn,
>  						early_node_map[i].end_pfn);
>  
> -	/*
> -	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
> -	 * that node_mask, clear it at first
> -	 */
> -	nodes_clear(node_states[N_HIGH_MEMORY]);
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();

