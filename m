Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZDGTpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZDGTpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbZDGTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:45:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZDGTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:45:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KrK4HybizBG65/5hA0gW6dEOEB4s3lPa42qXJ9GNIsxoTbueKH/YOkjoqrDY3qQY8
	1NvOVOr9IWvg4ekCATlwQ==
Date: Tue, 7 Apr 2009 12:44:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Pekka Enberg wrote:

> > Hmm, partial lists are per-node, so wouldn't it be better to do the
> > adjustment for every struct kmem_cache_node separately? The
> > 'min_partial_per_node' global seems just too ugly and confusing to live
> > with.
> 
> Btw, that requires moving ->min_partial to struct kmem_cache_node from
> struct kmem_cache.  But I think that makes a whole lot of sense if
> some nodes may have more CPUs than others.
> 
> And while the improvement is kinda obvious, I would be interested to
> know what kind of workload benefits from this patch (and see numbers
> if there are any).
> 

It doesn't really depend on the workload, it depends on the type of NUMA 
machine it's running on (and whether that NUMA is asymmetric amongst 
cpus).

Since min_partial_per_node is capped at MAX_PARTIAL, this is only really 
relevant for remote node defragmentation if it's allowed (and not just 2% 
of the time like the default).  We want to avoid stealing partial slabs 
from remote nodes if there are fewer than the number of cpus on that node.

Otherwise, it's possible for each cpu on the victim node to try to 
allocate a single object and require nr_cpus_node(node) new slab 
allocations.  In this case it's entirely possible for the majority of cpus 
to have cpu slabs from remote nodes.  This change reduces the liklihood of 
that happening because we'll always have cpu slab replacements on our 
local partial list before allowing remote defragmentation.

I'd be just as happy with the following, although it would require 
changing MIN_PARTIAL to be greater than its default of 5 if a node 
supports more cpus for optimal performance (the old patch did that 
automatically up to MAX_PARTIAL).
---
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1326,11 +1326,13 @@ static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
 	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 		struct kmem_cache_node *n;
+		int node;
 
-		n = get_node(s, zone_to_nid(zone));
+		node = zone_to_nid(zone);
+		n = get_node(s, node);
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
-				n->nr_partial > s->min_partial) {
+				n->nr_partial > nr_cpus_node(node)) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
