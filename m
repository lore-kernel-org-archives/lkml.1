Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYBKT6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYBKT6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYBKT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:57:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYBKT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:57:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=tER+j/jLPw3wUDMj8Jh32EYw+wUHei+3bNYbuGzzEEgPOg21p81NXWcv596wEevf6
	FEDKXq6pKYctJeB2vrtng==
Date: Mon, 11 Feb 2008 11:56:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <2f11576a0802111025w4f8d6765w119f9e9c1cddd85e@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0802111155310.17652@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
 <2f11576a0802111025w4f8d6765w119f9e9c1cddd85e@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, KOSAKI Motohiro wrote:

> > @@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
> >                 return ERR_PTR(-ENOMEM);
> >         flags &= MPOL_MODE_FLAGS;
> >         atomic_set(&policy->refcnt, 1);
> > +       cpuset_update_task_memory_state();
> > +       nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
> >         switch (mode) {
> >         case MPOL_INTERLEAVE:
> > -               policy->v.nodes = *nodes;
> > +               if (nodes_empty(*nodes))
> > +                       return ERR_PTR(-EINVAL);
> 
> need kmem_cache_free(policy_cache, policy) before return?
> 

Very good catch!



mempolicy: fix policy memory leak in mpol_new()

If mpol_new() cannot setup a new mempolicy because of an invalid argument
provided by the user, avoid leaking the mempolicy that has been dynamically
allocated.

Reported by KOSAKI Motohiro.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -171,13 +171,11 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
 	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		if (nodes_empty(*nodes))
-			return ERR_PTR(-EINVAL);
-		policy->v.nodes = cpuset_context_nmask;
-		if (nodes_weight(policy->v.nodes) == 0) {
+		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask)) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
+		policy->v.nodes = cpuset_context_nmask;
 		break;
 	case MPOL_PREFERRED:
 		policy->v.preferred_node = first_node(cpuset_context_nmask);
@@ -185,8 +183,10 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
 			policy->v.preferred_node = -1;
 		break;
 	case MPOL_BIND:
-		if (nodes_empty(*nodes))
+		if (nodes_empty(*nodes)) {
+			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
+		}
 		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
 		if (IS_ERR(policy->v.zonelist)) {
 			void *error_code = policy->v.zonelist;
