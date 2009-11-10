Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZKJHYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZKJHYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZKJHYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:24:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53148 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZKJHYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:24:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v2
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com
In-Reply-To: <20091106090202.dc2472b3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104170944.cef988c7.kamezawa.hiroyu@jp.fujitsu.com> <20091106090202.dc2472b3.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091110162121.361B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 10 Nov 2009 16:24:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> ===================================================================
> --- mmotm-2.6.32-Nov2.orig/mm/oom_kill.c
> +++ mmotm-2.6.32-Nov2/mm/oom_kill.c
> @@ -196,27 +196,40 @@ unsigned long badness(struct task_struct
>  /*
>   * Determine the type of allocation constraint.
>   */
> +#ifdef CONFIG_NUMA
>  static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> -						    gfp_t gfp_mask)
> +				    gfp_t gfp_mask, nodemask_t *nodemask)
>  {
> -#ifdef CONFIG_NUMA
>  	struct zone *zone;
>  	struct zoneref *z;
>  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> -	nodemask_t nodes = node_states[N_HIGH_MEMORY];
> +	int ret = CONSTRAINT_NONE;
>  
> -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
> -		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
> -			node_clear(zone_to_nid(zone), nodes);
> -		else
> +	/*
> + 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
> + 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
> + 	 * feature. Then, only mempolicy use this nodemask.
> + 	 */
> +	if (nodemask && nodes_equal(*nodemask, node_states[N_HIGH_MEMORY]))
> +		ret = CONSTRAINT_MEMORY_POLICY;

!nodes_equal() ?


> +
> +	/* Check this allocation failure is caused by cpuset's wall function */
> +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +			high_zoneidx, nodemask)
> +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
>  			return CONSTRAINT_CPUSET;

If cpuset and MPOL_BIND are both used, Probably CONSTRAINT_MEMORY_POLICY is
better choice.



>  
> -	if (!nodes_empty(nodes))
> -		return CONSTRAINT_MEMORY_POLICY;
> -#endif
> +	/* __GFP_THISNODE never calls OOM.*/
>  
> +	return ret;
> +}
> +#else
> +static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> +				gfp_t gfp_mask, nodemask_t *nodemask)
> +{
>  	return CONSTRAINT_NONE;
>  }
> +#endif


