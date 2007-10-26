Return-Path: <linux-kernel-owner+w=401wt.eu-S1765674AbXJZRSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765674AbXJZRSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbXJZRSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:18:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34767 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764467AbXJZRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:18:07 -0400
Date: Fri, 26 Oct 2007 10:18:05 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@sgi.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
Message-Id: <20071026101805.df3ebfda.pj@sgi.com>
In-Reply-To: <20071026025634.0f32e1e2.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	<20071025230409.81f20ed3.pj@sgi.com>
	<alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
	<20071026025634.0f32e1e2.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pj wrote:
> On a different point, we could, if it was worth the extra bit of code,
> improve the current code's handling of mempolicy rebinding when the
> cpuset adds memory nodes.  If we kept both the original cpusets
> mems_allowed, and the original MPOL_INTERLEAVE nodemask requested by
> the user in a call to set_mempolicy, then we could rebind (nodes_remap)
> the currently active policy v.nodes using that pair of saved masks to
> guide the rebinding.  This way, if say a cpuset shrunk, then regrew back
> to its original size (original number of nodes) we would end up
> replicating the original MPOL_INTERLEAVE request, cpuset relative.
> This would provide a more accurate cpuset relative translation of such
> memory policies with-out- changing the set_mempolicy API.  Hmmm ... this
> might meet your needs entirely, so that we did not need -any- added
> flags to the API.

Thinking about this some more ... there's daylight here!

I'll see if I can code up a patch for this now, but the idea is
to allow user code to specify any nodemask to a set_mempolicy
MPOL_INTERLEAVE call, even including nodes not in their cpuset,
and then (1) use nodes_remap() to fold that mask down to whatever
is their current cpuset (2) remember what they passed in and use
it again with nodes_remap() to re-fold that mask down, anytime
the cpuset changes.

For example, if they pass in a mask with all bits sets, then they
get interleave over all the nodes in their current cpuset, even as
that cpuset changes.  If they pass in a mask with say just two
bits set, then they will get interleave over just two nodes anytime
they are in a cpuset with two or more nodes (when in a single node
cpuset, they will of course get no interleave, for lack of anything
to interleave over.)

This should replace the patches that David is proposing here.  It should
replace what Lee is proposing.  It should work with libnuma and be
fully upward compatible with current code (except perhaps code that
depends on getting an error from requesting MPOL_INTERLEAVE on a node
not allowed.)

And instead of just covering the special case of "interleave over all
available nodes" it should cover the more general case of interleaving
over any subset of nodes, folded or replicated to handle being in any
cpuset.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
