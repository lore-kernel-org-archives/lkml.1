Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbYBSAq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbYBSAq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYBSAqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:46:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYBSAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:46:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=yRsl3cJ0BNHm3LVa31cHBa66FbrLL5kNE6D5UCsu6oNGjTgHVcNHJgnE2IQUkRLLx
	ICLm6Q3wBqrJBufRpE4xg==
Date: Mon, 18 Feb 2008 16:46:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, ray-lk@madrabbit.org,
       kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [RFC] bitmap onto and fold operators for mempolicy extensions
In-Reply-To: <20080216123315.28685.5796.sendpatchset@jackhammer.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0802181637530.17993@chino.kir.corp.google.com>
References: <20080216123315.28685.5796.sendpatchset@jackhammer.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Paul Jackson wrote:

> Let's say an application has specified some mempolicies
> that presume 16 memory nodes, including say a mempolicy that
> specified MPOL_F_RELATIVE_NODES (cpuset relative) nodes 12-15.
> Then lets say that application is crammed into a cpuset that only
> has 8 memory nodes, 0-7.  If one just uses bitmap_onto(), this
> mempolicy, mapped to that cpuset, would ignore the requested
> relative nodes above 7, leaving it empty of nodes.  That's not
> good; better to fold the higher nodes down, so that some nodes
> are included in the resulting mapped mempolicy.  In this case,
> the mempolicy nodes 12-15 are taken modulo 8 (the weight of the
> mems_allowed of the confining cpuset), resulting in a mempolicy
> specifying nodes 4-7.
> 

So what is the MPOL_F_RELATIVE_NODES behavior?  Is it a combination of 
nodes_onto() and nodes_fold()?

In your example, the only way we know to use nodes_fold() is if the 
resultant of nodes_onto() has a weight of 0.  An MPOL_F_RELATIVE_NODES 
nodemask for 4-6, for example, works fine in your case of a cpuset with 
memory nodes 0-7 and no fold is required.

So it's easy enough to do this:

	case MPOL_INTERLEAVE:
		if (flags & MPOL_F_RELATIVE_NODES) {
			nodes_onto(pol->v.nodes, pol->user_nodemask,
				   cpuset_context_nmask);
			if (nodes_empty(pol->v.nodes))
				nodes_fold(pol->v.nodes,
					   pol->user_nodemask,
					   nodes_weight(cpuset_context_nmask));
		} else {
			...
		}
		break;

But what if we require a combination?  Say the user asked for a policy of 
MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES over nodes 4-8 in a cpuset 
constrained to mems 0-7?  Should the resultant be 0,4-7 (combination of 
nodes_onto() and nodes_fold()) or simply be 4-7 (just nodes_onto())?

And what if the MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES nodemask is 0,4-8 
in the same cpuset constrained to mems 0-7?  Should the resultant be

 - 0,4-7 (nodes_onto() and nodes_fold()),

 - 0,4-7 (just nodes_onto()), or

 - 0-1,4-7 (nodes_onto(), nodes_fold(), and shift)?

The last option, 0-1,4-7, is the only one that preserves the same weight 
as the relative nodemask.

		David
