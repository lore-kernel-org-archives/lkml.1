Return-Path: <linux-kernel-owner+w=401wt.eu-S937553AbXHHXgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937553AbXHHXgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763900AbXHHXfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:35:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763451AbXHHXfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:35:55 -0400
Date: Wed, 8 Aug 2007 16:35:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
 zonelists v2
In-Reply-To: <20070808214420.GD2441@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708081633190.17335@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0708081025330.12652@schroedinger.engr.sgi.com>
 <1186597819.5055.37.camel@localhost> <20070808214420.GD2441@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Mel Gorman wrote:

> 
> >  For various policies, the arguments would look like this:
> > Policy		start node	nodemask
> > 
> > default		local node	cpuset_current_mems_allowed
> > 
> > preferred	preferred_node	cpuset_current_mems_allowed
> > 
> > interleave	computed node	cpuset_current_mems_allowed
> > 
> > bind		local node	policy nodemask [replaces bind
> > 				zonelist in mempolicy]
> > 

GFP_THISNODE could be realized by only setting the desired nodenumber in 
the nodemask.

> The last one is the most interesting. Much of the patch in development
> involves deleting the custom node stuff. I've included the patch below if
> you're curious. I wanted to get one-zonelist out first to see if we could
> agree on that before going further with it.

I think we do.

> > Then, just walk the zonelist for the starting node--already ordered by
> > distance--filtering by gfp_zone() and nodemask.  Done "right", this
> > should always return memory from the closest allowed node [based on the
> > nodemask argument] to the starting node.  And, it would eliminate the
> > custom zonelists for bind policy.  Can also eliminate cpuset checks in
> > the allocation loop because that constraint would already be applied to
> > the nodemask argument.
> > 
> 
> This is what I'm hoping. I haven't looked closely enough to be sure this will
> work but currently I see no reason why it couldn't and it might eliminate
> some of the NUMA-specific paths in the allocator.

Right. But lets first get the general case for the single nodelist 
accepted (with the zoneid optimizations?)
