Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbYBMA0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbYBMA0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYBMAZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:25:44 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:10577 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYBMAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:25:41 -0500
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802111155310.17652@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	 <2f11576a0802111025w4f8d6765w119f9e9c1cddd85e@mail.gmail.com>
	 <alpine.DEB.1.00.0802111155310.17652@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 12 Feb 2008 17:25:43 -0700
Message-Id: <1202862343.4974.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 11:56 -0800, David Rientjes wrote: 
> On Tue, 12 Feb 2008, KOSAKI Motohiro wrote:
> 
> > > @@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
> > >                 return ERR_PTR(-ENOMEM);
> > >         flags &= MPOL_MODE_FLAGS;
> > >         atomic_set(&policy->refcnt, 1);
> > > +       cpuset_update_task_memory_state();
> > > +       nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
> > >         switch (mode) {
> > >         case MPOL_INTERLEAVE:
> > > -               policy->v.nodes = *nodes;
> > > +               if (nodes_empty(*nodes))
> > > +                       return ERR_PTR(-EINVAL);
> > 
> > need kmem_cache_free(policy_cache, policy) before return?
> > 
> 
> Very good catch!
> 
> 
> 
> mempolicy: fix policy memory leak in mpol_new()
> 
> If mpol_new() cannot setup a new mempolicy because of an invalid argument
> provided by the user, avoid leaking the mempolicy that has been dynamically
> allocated.
> 
> Reported by KOSAKI Motohiro.
> 
> Cc: Paul Jackson <pj@sgi.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/mempolicy.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -171,13 +171,11 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>  	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
>  	switch (mode) {
>  	case MPOL_INTERLEAVE:
> -		if (nodes_empty(*nodes))
> -			return ERR_PTR(-EINVAL);
> -		policy->v.nodes = cpuset_context_nmask;
> -		if (nodes_weight(policy->v.nodes) == 0) {
> +		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask)) {
>  			kmem_cache_free(policy_cache, policy);
>  			return ERR_PTR(-EINVAL);
>  		}
> +		policy->v.nodes = cpuset_context_nmask;
>  		break;
>  	case MPOL_PREFERRED:
>  		policy->v.preferred_node = first_node(cpuset_context_nmask);
> @@ -185,8 +183,10 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>  			policy->v.preferred_node = -1;
>  		break;
>  	case MPOL_BIND:
> -		if (nodes_empty(*nodes))
> +		if (nodes_empty(*nodes)) {
> +			kmem_cache_free(policy_cache, policy);
>  			return ERR_PTR(-EINVAL);
> +		}
>  		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
>  		if (IS_ERR(policy->v.zonelist)) {
>  			void *error_code = policy->v.zonelist;

With this patch, we now have 3 error paths from mpol_new that need to
free the mempolicy struct.  How about consolidating them with something
like this [uncompiled/untested]:

PATCH mempolicy - consolidate mpol_new() error paths

Use common error path in mpol_new() for errors that we discover
after allocation the new mempolicy structure.  Free the mempolicy
in the common error path.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mempolicy.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: Linux/mm/mempolicy.c
===================================================================
--- Linux.orig/mm/mempolicy.c	2008-02-12 15:18:12.000000000 -0700
+++ Linux/mm/mempolicy.c	2008-02-12 15:22:07.000000000 -0700
@@ -156,6 +156,7 @@ static struct mempolicy *mpol_new(enum m
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	void *error_code = ERR_PTR(-EINVAL);
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -172,8 +173,7 @@ static struct mempolicy *mpol_new(enum m
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask)) {
-			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-EINVAL);
+			goto free_mpol;
 		}
 		policy->v.nodes = cpuset_context_nmask;
 		break;
@@ -184,14 +184,12 @@ static struct mempolicy *mpol_new(enum m
 		break;
 	case MPOL_BIND:
 		if (nodes_empty(*nodes)) {
-			kmem_cache_free(policy_cache, policy);
-			return ERR_PTR(-EINVAL);
+			goto free_mpol;
 		}
 		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
 		if (IS_ERR(policy->v.zonelist)) {
-			void *error_code = policy->v.zonelist;
-			kmem_cache_free(policy_cache, policy);
-			return error_code;
+			error_code = policy->v.zonelist;
+			goto free_mpol;
 		}
 		break;
 	default:
@@ -201,6 +199,10 @@ static struct mempolicy *mpol_new(enum m
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
 	policy->user_nodemask = *nodes;
 	return policy;
+
+free_mpol:
+	kmem_cache_free(policy_cache, policy);
+	return error_code;
 }
 
 static void gather_stats(struct page *, void *, int pte_dirty);


