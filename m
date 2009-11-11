Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZKKF6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZKKF6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 00:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZKKF6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 00:58:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:63284 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZKKF6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 00:58:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lxjn3XhR5kl7XXZ95/KxQVMlVq49+kB/Dn7c673vFNVQQQX52+Np/T3ZSAjf9mFOX
	Iba1FgWYUdP80MMx741xA==
Date: Tue, 10 Nov 2009 21:58:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.1
In-Reply-To: <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com> <20091110163419.361E.A69D9226@jp.fujitsu.com> <20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com> <20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
 <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com> <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com> <20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com> <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Index: mm-test-kernel/drivers/char/sysrq.c
> ===================================================================
> --- mm-test-kernel.orig/drivers/char/sysrq.c
> +++ mm-test-kernel/drivers/char/sysrq.c
> @@ -339,7 +339,7 @@ static struct sysrq_key_op sysrq_term_op
>  
>  static void moom_callback(struct work_struct *ignored)
>  {
> -	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
> +	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL);
>  }
>  
>  static DECLARE_WORK(moom_work, moom_callback);
> Index: mm-test-kernel/mm/oom_kill.c
> ===================================================================
> --- mm-test-kernel.orig/mm/oom_kill.c
> +++ mm-test-kernel/mm/oom_kill.c
> @@ -196,27 +196,47 @@ unsigned long badness(struct task_struct
>  /*
>   * Determine the type of allocation constraint.
>   */
> -static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> -						    gfp_t gfp_mask)
> -{
>  #ifdef CONFIG_NUMA
> +static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> +				    gfp_t gfp_mask, nodemask_t *nodemask)
> +{
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
> -			return CONSTRAINT_CPUSET;
> +	/*
> +	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
> + 	 * to kill current.We have to random task kill in this case.
> + 	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
> + 	 */
> +	if (gfp_mask & __GPF_THISNODE)
> +		return ret;
>  

That shouldn't compile.

> -	if (!nodes_empty(nodes))
> +	/*
> + 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
> + 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
> + 	 * feature. mempolicy is an only user of nodemask here.
> +	 * check mempolicy's nodemask contains all N_HIGH_MEMORY
> + 	 */
> +	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask))
>  		return CONSTRAINT_MEMORY_POLICY;
> -#endif
>  
> +	/* Check this allocation failure is caused by cpuset's wall function */
> +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +			high_zoneidx, nodemask)
> +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
> +			return CONSTRAINT_CPUSET;
> +
> +	return CONSTRAINT_NONE;
> +}
> +#else
> +static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> +				gfp_t gfp_mask, nodemask_t *nodemask)

inline seems appropriate in this case, gcc will optimize it anyway.
