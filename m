Return-Path: <linux-kernel-owner+w=401wt.eu-S1763912AbXJZRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763912AbXJZRoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXJZRo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:44:28 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:42486 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357AbXJZRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:44:27 -0400
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071026101805.df3ebfda.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	 <20071025230409.81f20ed3.pj@sgi.com>
	 <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
	 <20071026025634.0f32e1e2.pj@sgi.com>  <20071026101805.df3ebfda.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 13:43:46 -0400
Message-Id: <1193420627.5032.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 10:18 -0700, Paul Jackson wrote:
> pj wrote:
> > On a different point, we could, if it was worth the extra bit of code,
> > improve the current code's handling of mempolicy rebinding when the
> > cpuset adds memory nodes.  If we kept both the original cpusets
> > mems_allowed, and the original MPOL_INTERLEAVE nodemask requested by
> > the user in a call to set_mempolicy, then we could rebind (nodes_remap)
> > the currently active policy v.nodes using that pair of saved masks to
> > guide the rebinding.  This way, if say a cpuset shrunk, then regrew back
> > to its original size (original number of nodes) we would end up
> > replicating the original MPOL_INTERLEAVE request, cpuset relative.
> > This would provide a more accurate cpuset relative translation of such
> > memory policies with-out- changing the set_mempolicy API.  Hmmm ... this
> > might meet your needs entirely, so that we did not need -any- added
> > flags to the API.
> 
> Thinking about this some more ... there's daylight here!
> 
> I'll see if I can code up a patch for this now, but the idea is
> to allow user code to specify any nodemask to a set_mempolicy
> MPOL_INTERLEAVE call, even including nodes not in their cpuset,
> and then (1) use nodes_remap() to fold that mask down to whatever
> is their current cpuset (2) remember what they passed in and use
> it again with nodes_remap() to re-fold that mask down, anytime
> the cpuset changes.
> 
> For example, if they pass in a mask with all bits sets, then they
> get interleave over all the nodes in their current cpuset, even as
> that cpuset changes.  If they pass in a mask with say just two
> bits set, then they will get interleave over just two nodes anytime
> they are in a cpuset with two or more nodes (when in a single node
> cpuset, they will of course get no interleave, for lack of anything
> to interleave over.)
> 
> This should replace the patches that David is proposing here.  It should
> replace what Lee is proposing.  It should work with libnuma and be
> fully upward compatible with current code (except perhaps code that
> depends on getting an error from requesting MPOL_INTERLEAVE on a node
> not allowed.)
> 
> And instead of just covering the special case of "interleave over all
> available nodes" it should cover the more general case of interleaving
> over any subset of nodes, folded or replicated to handle being in any
> cpuset.

Will it handle the case of MPOL_INTERLEAVE policy on a shm segment that
is mapped by tasks in different, possibly disjoint, cpusets.  Local
allocation does, and my patch does.  That was one of the primary
goals--to address an issue that Christoph has with shared policies.
cpusets really muck these up!

Lee
> 

