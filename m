Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbZGQAEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbZGQAEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbZGQAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:04:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbZGQAEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:04:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
References: <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
Message-Id: <20090717090003.A903.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 09:04:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 15 Jul 2009, Lee Schermerhorn wrote:
> 
> > Interestingly, on ia64, the top cpuset mems_allowed gets set to all
> > possible nodes, while on x86_64, it gets set to on-line nodes [or nodes
> > with memory].  Maybe this is a to support hot-plug?
> > 
> 
> numactl --interleave=all simply passes a nodemask with all bits set, so if 
> cpuset_current_mems_allowed includes offline nodes from node_possible_map, 
> then mpol_set_nodemask() doesn't mask them off.
> 
> Seems like we could handle this strictly in mempolicies without worrying 
> about top_cpuset like in the following?

This patch seems band-aid patch. it will change memory-hotplug behavior.
Please imazine following scenario:

1. numactl interleave=all process-A
2. memory hot-add

before 2.6.30:
		-> process-A can use hot-added memory

your proposal patch:
		-> process-A can't use hot-added memory




> ---
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -194,6 +194,7 @@ static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
>  static int mpol_set_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
>  {
>  	nodemask_t cpuset_context_nmask;
> +	nodemask_t mems_allowed;
>  	int ret;
>  
>  	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
> @@ -201,20 +202,21 @@ static int mpol_set_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
>  		return 0;
>  
>  	VM_BUG_ON(!nodes);
> +	nodes_and(mems_allowed, cpuset_current_mems_allowed,
> +				node_states[N_HIGH_MEMORY]);
>  	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
>  		nodes = NULL;	/* explicit local allocation */
>  	else {
>  		if (pol->flags & MPOL_F_RELATIVE_NODES)
>  			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
> -					       &cpuset_current_mems_allowed);
> +					       &mems_allowed);
>  		else
>  			nodes_and(cpuset_context_nmask, *nodes,
> -				  cpuset_current_mems_allowed);
> +				  mems_allowed);
>  		if (mpol_store_user_nodemask(pol))
>  			pol->w.user_nodemask = *nodes;
>  		else
> -			pol->w.cpuset_mems_allowed =
> -						cpuset_current_mems_allowed;
> +			pol->w.cpuset_mems_allowed = mems_allowed;
>  	}
>  
>  	ret = mpol_ops[pol->mode].create(pol,



