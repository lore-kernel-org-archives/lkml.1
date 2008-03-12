Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYCLNiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYCLNiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYCLNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:38:39 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37489 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYCLNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:38:38 -0400
Date: Wed, 12 Mar 2008 13:34:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH rc5-mm1 1/3] mm-have-zonelist: fix memcg ooms
In-Reply-To: <20080312122920.GB25250@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0803121330260.5209@blonde.site>
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
 <20080312122920.GB25250@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Mel Gorman wrote:
> On (11/03/08 21:12), Hugh Dickins didst pronounce:
> > @@ -1454,9 +1453,10 @@ unsigned long try_to_free_mem_cgroup_pag
> >  		.isolate_pages = mem_cgroup_isolate_pages,
> >  	};
> >  	struct zonelist *zonelist;
> > -	int target_zone = gfp_zonelist(GFP_HIGHUSER_MOVABLE);
> >  
> > -	zonelist = &NODE_DATA(numa_node_id())->node_zonelists[target_zone];
> > +	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> > +			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> > +	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
> 
> While it is clear you are setting the mask to include HIGHMEM-related flags,
> it's not as clear to me why you alter the zonelist as well. target_zone was
> already based on HIGHMEM so what are you fixing there?
> 
> It should still work as ->node_zonelists[0] is a zonelist suitable for node
> fallback as opposed to node_zonelists[1] which is for GFP_THISNODE but
> maybe this was not quite what you intended?
> 
> Probably something obvious that will hit me the second I push send :)

That bit wasn't a fix as such, it just came from not wanting to repeat
GFP_HIGHUSER_MOVABLE in there: after I'd looked at gfp_zonelist, it
appeared to be redundant in this context, so I preferred to cut out
the target_zone, and let sc.gfp_mask handle it all.  That worries you?

Hugh
