Return-Path: <linux-kernel-owner+w=401wt.eu-S1765155AbXJZUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765155AbXJZUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXJZUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:42:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXJZUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:42:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=pS69ATzK7b64WnDQmHGZahK2oHAGGKu0Q9BVumt5XwfLt0SUiJicnxtc8+G5JKsHn
	8bCRRHTTvIz1X0fJ6akMw==
Date: Fri, 26 Oct 2007 13:41:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
In-Reply-To: <20071026025634.0f32e1e2.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710261330110.1804@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com> <20071025230409.81f20ed3.pj@sgi.com>
 <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com> <20071026025634.0f32e1e2.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

>  1) If you want the current behaviour, where set_mempolicy(MPOL_INTERLEAVE)
>     calls mean what they say, and cpusets tries as best it can (imperfectly)
>     to honor those memory policy calls, even in the face of changing cpusets,
>     then leave memory_spread_user turned off (the default, right?)
>  2) If you want MPOL_INTERLEAVE tasks to interleave user memory across all
>     nodes in the cpuset, whatever that might be, then enable memory_spread_user.
> 
> This is admittedly less flexible than your patch provided, but I am
> attracted to the simpler API - easier to explain.
> 

That seems to follow the convention better with respect to 
memory_spread_page and memory_spread_slab anyway.  Either all the tasks 
attached to the cpuset get that behavior or none of them do.  We can do 
the same for memory_spread_user.

Sounds good.

> This does beg yet another question: shouldn't memory_spread_user force
> interleaving of user memory -regardless- of mempolicy.
> 

Sure, I don't see any compelling reason why it shouldn't.

> And yet another question: what about the MPOL_BIND mempolicy?  It too,
> to a lesser extent, has the same problems with cpusets that shrink and
> then expand.  Several tasks in a cpuset with multiple nodes could carefully
> bind to a separate node each, but then end up collapsed all onto the same
> node if the cpuset was shrunk to one node and then expanded again.
> 

Hmm.  At some point we're going to have to just say that if you use 
mempolicies such as MPOL_BIND in your application and then you insanely 
take those nodes away from your application via cpusets, that you are 
actually getting exactly what you asked for.

There's two ways to fix that: try to remap the MPOL_BIND nodes onto the 
new set of mems_allowed regardless of the cardinality of the two sets, or 
refuse to update the nodemask of the cpuset if you're taking one or more 
nodes away from an attached task that has such a policy.  I favor the 
former because, in conjunction with a sane memory_migrate setting, it 
shouldn't actually matter that much.  The memory you previously allocated 
will still be on the removed nodes; only your future allocations will 
actually respect the new nodemask.

The MPOL_INTERLEAVE case is more interesting because we're trying to 
reduce bus contention and decrease our latency with quicker memory access.  
So, using the true definition of a node as a premise, we should get better 
results in terms of performance if we expand the nodemask as much as 
possible.  That's exactly what we've been trying to address: when an 
application's mems_allowed is expanded to allow more nodes, the 
application is unaware of the change and can't take advantage of the 
it (without the get_mempolicy() - set_mempolicy() loop).  That's my whole 
case for why cpusets should be modifying MPOL_INTERLEAVE policies in the 
first place: because they are the ones that allowed access to more memory.

> On a different point, we could, if it was worth the extra bit of code,
> improve the current code's handling of mempolicy rebinding when the
> cpuset adds memory nodes.  If we kept both the original cpusets
> mems_allowed, and the original MPOL_INTERLEAVE nodemask requested by
> the user in a call to set_mempolicy, then we could rebind (nodes_remap)
> the currently active policy v.nodes using that pair of saved masks to
> guide the rebinding.  This way, if say a cpuset shrunk, then regrew back
> to its original size (original number of nodes) we would end up
> replicating the original MPOL_INTERLEAVE request, cpuset relative.

Keeping a copy of the nodemask passed to set_mempolicy() in struct 
mempolicy is an interesting idea and could, with the logic you describe, 
help guide the remapping as the set of allowed nodes changes.  We'd have 
two interleaved nodemasks, the actual (pol->v.nodes) and the requested 
(something like pol->passed_nodemask).  get_mempolicy() would always 
return the actual nodemask so the application can be aware of what it has 
access to and what it doesn't.  I like it.

		David
