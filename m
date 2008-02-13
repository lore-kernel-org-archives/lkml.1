Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbYBMTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbYBMTN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYBMTNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:13:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYBMTNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:13:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=cxf3gX6kFfcfguEmlRpqHE15dSkxHTVhZhCCVJsOL2yRfKGNY8NgjTofU/kPg8gDN
	XBSAkqj8O54oElEjucEbg==
Date: Wed, 13 Feb 2008 11:12:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <1202919288.4978.51.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802131103090.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>  <1202862136.4974.41.camel@localhost> 
 <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com> <1202919288.4978.51.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Lee Schermerhorn wrote:

> > > If we just want to preserve existing behavior, we can define an
> > > additional mode flag that we set in the sbinfo policy in
> > > shmem_parse_mpol() and test in mpol_new().  If we want to be able to
> > > specify existing or new behavior, we can use the same flag, but set it
> > > or not based on an additional qualifier specified via the mount option.
> > > 
> > 
> > Shmem areas between cpusets with disjoint mems_allowed seems like an error 
> > in userspace to me and I would prefer that mpol_new() reject it outright.
> 
> I don't think so, and I'd like to explain why.  Perhaps this is too big
> a topic to cover in the context of this patch response.  I think I'll
> start another thread.  Suffice it to say here that cpusets and
> mempolicies don't constrain, in anyway, the ability of tasks in a cpuset
> to attach to shmem segments created by tasks in other, perhaps disjoint,
> cpusets.  The cpusets and mempolicies DO constrain page allocations,
> however.  This can result in OOM faults for tasks in cpusets whose
> mems_allowed contains no overlap with a shared policy installed by the
> creating task.  This can be avoided if the task that creates the shmem
> segment faults in all of the pages and SHM_LOCKs them down.  Whether
> this is sufficient for all applications is subject of the other
> discussion.  In any case, I think we need to point this out in mempolicy
> and cpuset man pages.
> 

I don't think we're likely to see examples of actual code written to do 
this being posted to refute my comment.

I think what you said above is right and that it should be allowed.  
You're advocating for allowing task A to attach to shmem segments created 
by task B while task A has its own mempolicy that restricts its own 
allocations but still being able to access the shmem segments of task B, 
providing that task A will not fault them back in itself.

You're right, that's not a scenario that I was hoping to address to 
MPOL_F_STATIC_NODES.

> > Since we're allowed to remap the node to a different node than the user 
> > specified with either syscall, the current behavior is that "one node is 
> > as good as another."  In other words, we're trying to accomodate the mode 
> > first by setting pol->v.preferred_node to some accessible node and only 
> > setting that to the user-supplied node if it is available.
> > 
> > If the node isn't available and the user specifically asked that it is not 
> > remapped (with MPOL_F_STATIC_NODES), then I felt local allocation was best 
> > compared to remapping to a node that may be unrelated to the VMA or task.  
> > This preserves a sense of the current behavior that "one node is as good 
> > as another," but the user specifically asked for no remap.
> 
> Yeah.  I went back and read the update to the mempolicy doc where you
> make it clear that this is the semantic of 'STATIC_NODES.  You also
> mentioned it in the patch description, but I didn't "get it".  Sorry.  
> 
> Still a comment in the code would, I think, help future spelunkers.
> 

Ok, I'll clarify the intention in this code that we agreed was better:

	case MPOL_PREFERRED:
		if (!remap) {
			int nid = first_node(pol->user_nodemask);

			if (node_isset(nid, *newmask))
				pol->v.preferred_node = nid;
			else
				pol->v.preferred_node = -1;
		} else
			pol->v.preferred_node = node_remap(pol->v.preferred_node,
							*mpolmask, *newmask);
		break;
