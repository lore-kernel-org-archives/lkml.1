Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYFUXq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYFUXq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 19:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYFUXql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 19:46:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751497AbYFUXqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 19:46:39 -0400
Date: Sat, 21 Jun 2008 16:46:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Alexander Beregalov <a.beregalov@gmail.com>,
       kernel-testers@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, bfields@fieldses.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
Subject: Re: 2.6.26-rc: nfsd hangs for a few sec
In-Reply-To: <20080621224135.GD4692@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0806211636090.18642@schroedinger.engr.sgi.com>
References: <a4423d670806210557k1e8fcee1le3526f62962799e@mail.gmail.com>
 <20080621224135.GD4692@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008, Mel Gorman wrote:

> @@ -3257,10 +3259,10 @@ retry:
>  	 * Look through allowed nodes for objects available
>  	 * from existing per node queues.
>  	 */
> -	for (z = zonelist->zones; *z && !obj; z++) {
> -		nid = zone_to_nid(*z);
> +	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> +		nid = zone_to_nid(zone);
>  
> -		if (cpuset_zone_allowed_hardwall(*z, flags) &&
> +		if (cpuset_zone_allowed_hardwall(zone, flags) &&
>  			cache->nodelists[nid] &&
>  			cache->nodelists[nid]->free_objects)
>  				obj = ____cache_alloc_node(cache,
> 
> Note how that loop no longer breaks out when an object is found before the
> patch but not afterwards. The patch to fix that is below but I don't think
> it helps Alexander assuming he is using SLUB.

Right we have a significant memory leak here. Potentially one object for 
each zone is allocated and abandoned. May trigger more allocations
and therefore trigger more frequent reclaim because the free objects are
rapidly consumed on a system that relies on fallback allocations 
(memoryless nodes f.e.). Not a direct explanation for the problem but the
memory wastage could certainly can heretofore undiscovered locking 
dependencies to be exposed.

> --- linux-2.6.26-rc5-clean/mm/slab.c	2008-06-05 04:10:44.000000000 +0100
> +++ linux-2.6.26-rc5-fix-slab-leak/mm/slab.c	2008-06-21 22:50:07.000000000 +0100
> @@ -3266,6 +3266,10 @@ retry:
>  			cache->nodelists[nid]->free_objects)
>  				obj = ____cache_alloc_node(cache,
>  					flags | GFP_THISNODE, nid);
> +
> +		/* Do not scan further once an object has been allocated */
> +		if (obj)
> +			break;
>  	}
>  
>  	if (!obj) {
> 

Ok. That would work but its better to put the check into the if branch:


Subject: Slab: Fix memory leak in fallback_alloc()

The zonelist patches caused the loop that checks for available
objects in permitted zones to not terminate immediately. One object
per zone per allocation may be allocated and then abandoned.

Break the loop when we have successfully allocated one object.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slab.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c	2008-06-21 16:39:04.336377178 -0700
+++ linux-2.6/mm/slab.c	2008-06-21 16:40:07.637834699 -0700
@@ -3263,9 +3263,12 @@ retry:
 
 		if (cpuset_zone_allowed_hardwall(zone, flags) &&
 			cache->nodelists[nid] &&
-			cache->nodelists[nid]->free_objects)
+			cache->nodelists[nid]->free_objects) {
 				obj = ____cache_alloc_node(cache,
 					flags | GFP_THISNODE, nid);
+				if (obj)
+					break;
+		}
 	}
 
 	if (!obj) {

