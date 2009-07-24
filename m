Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZGXWwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZGXWwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZGXWwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:52:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbZGXWwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:52:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uqWyf0yaCRMQ57SnvkE/ZHfnNjuhaW1YnCfcUdgW3CF0ChHxDLlXs5f9ElF7ULz8M
	X35lpBY7r9xw2hkL5C/Dg==
Date: Fri, 24 Jul 2009 15:51:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com> <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, David Rientjes wrote:

> numactl --interleave=all simply passes a nodemask with all bits set, so if 
> cpuset_current_mems_allowed includes offline nodes from node_possible_map, 
> then mpol_set_nodemask() doesn't mask them off.
> 
> Seems like we could handle this strictly in mempolicies without worrying 
> about top_cpuset like in the following?
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
> 

Should this patch be added to 2.6.31-rc4 to prevent the kernel panic while 
hotplug notifiers are being added to mempolicies?
