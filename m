Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYBMA6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYBMA6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765375AbYBMA5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:57:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:41720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYBMA5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:57:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=kC8TJTZpfxDsGmHO9TY4T3g64/mLjDSNqyddy133TesEkbzILAHZ77UgI5fDzss1u
	UP3s79mTmSFs63fvVWQLg==
Date: Tue, 12 Feb 2008 16:57:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <1202862343.4974.44.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802121655580.3291@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>  <2f11576a0802111025w4f8d6765w119f9e9c1cddd85e@mail.gmail.com>
  <alpine.DEB.1.00.0802111155310.17652@chino.kir.corp.google.com> <1202862343.4974.44.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Lee Schermerhorn wrote:

> PATCH mempolicy - consolidate mpol_new() error paths
> 
> Use common error path in mpol_new() for errors that we discover
> after allocation the new mempolicy structure.  Free the mempolicy
> in the common error path.
> 
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
>  mm/mempolicy.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> Index: Linux/mm/mempolicy.c
> ===================================================================
> --- Linux.orig/mm/mempolicy.c	2008-02-12 15:18:12.000000000 -0700
> +++ Linux/mm/mempolicy.c	2008-02-12 15:22:07.000000000 -0700
> @@ -156,6 +156,7 @@ static struct mempolicy *mpol_new(enum m
>  {
>  	struct mempolicy *policy;
>  	nodemask_t cpuset_context_nmask;
> +	void *error_code = ERR_PTR(-EINVAL);
>  
>  	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
>  		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
> @@ -172,8 +173,7 @@ static struct mempolicy *mpol_new(enum m
>  	switch (mode) {
>  	case MPOL_INTERLEAVE:
>  		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask)) {
> -			kmem_cache_free(policy_cache, policy);
> -			return ERR_PTR(-EINVAL);
> +			goto free_mpol;
>  		}
>  		policy->v.nodes = cpuset_context_nmask;
>  		break;

You can also get rid of the parentheses to make checkpatch.pl happy, too.

> @@ -184,14 +184,12 @@ static struct mempolicy *mpol_new(enum m
>  		break;
>  	case MPOL_BIND:
>  		if (nodes_empty(*nodes)) {
> -			kmem_cache_free(policy_cache, policy);
> -			return ERR_PTR(-EINVAL);
> +			goto free_mpol;
>  		}
>  		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
>  		if (IS_ERR(policy->v.zonelist)) {
> -			void *error_code = policy->v.zonelist;
> -			kmem_cache_free(policy_cache, policy);
> -			return error_code;
> +			error_code = policy->v.zonelist;
> +			goto free_mpol;
>  		}
>  		break;
>  	default:
> @@ -201,6 +199,10 @@ static struct mempolicy *mpol_new(enum m
>  	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
>  	policy->user_nodemask = *nodes;
>  	return policy;
> +
> +free_mpol:
> +	kmem_cache_free(policy_cache, policy);
> +	return error_code;
>  }
>  
>  static void gather_stats(struct page *, void *, int pte_dirty);
> 

I'll fold this into my patchset when I repost it, thanks.

		David
