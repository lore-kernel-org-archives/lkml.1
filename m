Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbYBSGFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbYBSGFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYBSGFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:05:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751887AbYBSGFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:05:35 -0500
Date: Tue, 19 Feb 2008 00:05:29 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, ray-lk@madrabbit.org,
       kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [RFC] bitmap onto and fold operators for mempolicy extensions
Message-Id: <20080219000529.f2366d62.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802181637530.17993@chino.kir.corp.google.com>
References: <20080216123315.28685.5796.sendpatchset@jackhammer.engr.sgi.com>
	<alpine.DEB.1.00.0802181637530.17993@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> So what is the MPOL_F_RELATIVE_NODES behavior?  Is it a combination of 
> nodes_onto() and nodes_fold()?

MPOL_F_RELATIVE_NODES should always combination of nodes_onto() and
nodes_fold().

The reason I say that is consistency with the end cases.  That is,
we need fold in the case that no requested nodes have numbers
smaller than the weight of the cpusets mems_allowed.  At the opposite
extreme, when -all- requested node numbers are smaller than the weight
of mems_allowed, fold has no affect, so it's fine to use there.  And
for the in between cases, when some requested nodes are smaller and
some not, fold is one possible reasonable answer.  So use it everywhere
for consistency.

> So it's easy enough to do this:
> 	case MPOL_INTERLEAVE:
> 		if (flags & MPOL_F_RELATIVE_NODES) {
> 			nodes_onto(pol->v.nodes, pol->user_nodemask,
> 				   cpuset_context_nmask);
> 			if (nodes_empty(pol->v.nodes))

I hate any more special cases than I have to have -- so not that way.

> But what if we require a combination?  Say the user asked for a policy of 
> MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES over nodes 4-8 in a cpuset 
> constrained to mems 0-7?  Should the resultant be 0,4-7 (combination of 
> nodes_onto() and nodes_fold()) or simply be 4-7 (just nodes_onto())?

All fold, all the time ;).  So this one should be 0,4-7.


> And what if the MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES nodemask is 0,4-8 
> in the same cpuset constrained to mems 0-7?  Should the resultant be
> 
>  - 0,4-7 (nodes_onto() and nodes_fold()),
> 
>  - 0,4-7 (just nodes_onto()), or
> 
>  - 0-1,4-7 (nodes_onto(), nodes_fold(), and shift)?
> 
> The last option, 0-1,4-7, is the only one that preserves the same weight 
> as the relative nodemask.

Again, 0,4-7.

Weight preservation is not a goal here, and would require special cases.

If someone crams a five pound cpuset relative memory policy into a two
poound cpuset, they will likely loose weight.  What matters in that
case is that things plod along without too much distress, and that
when the job is restored to a proper size cpuset, its memory policies
recover their full health.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
