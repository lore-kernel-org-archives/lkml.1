Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXJZPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXJZPSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760210AbXJZPSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:18:10 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:55793 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbXJZPSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:18:08 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 11:18:08 -0400
Message-Id: <1193411888.5032.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 17:28 -0700, Christoph Lameter wrote:
> On Thu, 25 Oct 2007, David Rientjes wrote:
> 
> > The problem occurs when you add cpusets into the mix and permit the 
> > allowed nodes to change without knowledge to the application.  Right now, 
> > a simple remap is done so if the cardinality of the set of nodes 
> > decreases, you're interleaving over a smaller number of nodes.  If the 
> > cardinality increases, your interleaved nodemask isn't expanded.  That's 
> > the problem that we're facing.  The remap itself is troublesome because it 
> > doesn't take into account the user's desire for a custom nodemask to be 
> > used anyway; it could remap an interleaved policy over several nodes that 
> > will already be contended with one another.
> 
> Right. So I think we are fine if the application cannot setup boundaries 
> for interleave.
> 
> 
> > Normally, MPOL_INTERLEAVE is used to reduce bus contention to improve the 
> > throughput of the application.  If you remap the number of nodes to 
> > interleave over, which is currently how it's done when mems_allowed 
> > changes, you could actually be increasing latency because you're 
> > interleaving over the same bus.
> 
> Well you may hit some nodes more than others so a slight performance 
> degradataion.
> 
> > This isn't a memory policy problem because all it does is effect a 
> > specific policy over a set of nodes.  With my change, cpusets are required 
> > to update the interleaved nodemask if the user specified that they desire 
> > the feature with interleave_over_allowed.  Cpusets are, after all, the 
> > ones that changed the mems_allowed in the first place and invalidated our 
> > custom interleave policy.  We simply can't make inferences about what we 
> > should do, so we allow the creator of the cpuset to specify it for us.  So 
> > the proper place to modify an interleaved policy is in cpusets and not 
> > mempolicy itself.
> 
> With that MPOL_INTERLEAVE would be context dependent and no longer 
> needs translation. Lee had similar ideas. Lee: Could we make 
> MPOL_INTERLEAVE generally cpuset context dependent?
> 

That's what my "cpuset-independent interleave" patch does.  David
doesn't like the "null node mask" interface because it doesn't work with
libnuma.  I plan to fix that, but I'm chasing other issues.  I should
get back to the mempol work after today.

What I like about the cpuset independent interleave is that the "policy
remap" when cpusets are changed is a NO-OP--no need to change the
policy.  Just as "preferred local" policy chooses the node where the
allocation occurs, my cpuset independent interleave patch interleaves
across the set of nodes available at the time of the allocation.  The
application has to specifically ask for this behavior by the null/empty
nodemask or the TBD libnuma API.  IMO, this is the only reasonable
interleave policy for apps running in dynamic cpusets.

An aside:  if David et al [at google] are using cpusets on fake numa for
resource management [I don't know this is the case, but saw some
discussions way back that indicate it might be?], then maybe this
becomes less of an issue when control groups [a.k.a. containers] and
memory resource controls come to fruition?

Lee

