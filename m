Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXJ2EsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXJ2EsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXJ2EsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:48:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXJ2EsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:48:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=S3ZbnNN9M6JesCy+L7C0YdulbUZtiYe7Ps/V9ZuQ8Shu1uK4PXW5Oo0ObG1tQztcP
	PMqHqDpwnLLo1czp91kEw==
Date: Sun, 28 Oct 2007 21:47:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071028212745.57a7db67.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com> <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com>
 <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com> <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
 <20071028164637.8d1b45b0.pj@sgi.com> <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com> <20071028212745.57a7db67.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Paul Jackson wrote:

> And, unless someone in the know tells us otherwise, I have to assume
> that this could break them.  Now, the odds are that they simply don't
> run that solution stack on any system making active use of cpusets,
> so the odds are this would be no problem for them.  But I don't
> presently have enough knowledge of their situation to take that risk.
> 

If we can't identify any applications that would be broken by this, what's 
the difference in simply implementing Choice B and then, if we hear 
complaints, add your hack to revert back to Choice A behavior based on the 
get_mempolicy() call you specified is always part of libnuma?

The problem that I see with immediately offering both choices is that we 
don't know if anybody is actually reverting back to Choice A behavior 
because libnuma, by default, would use it.  That's going to making it very 
painful to remove later because we've supported both options and have made 
libnuma and {get,set}_mempolicy() arguments ambiguous.  We should only 
support both choices if they will both be used and there's no hard 
evidence to suggest that at this point.

> But dual support is pretty easy so far as the kernel code is concerned.
> It's just a few nodes_remap() calls optionally invoked at a few key
> spots in mm/mempolicy.c.  Consequently there won't be a big hurry to
> remove Choice A.
> 

You earlier insisted on an ease of documentation for the MPOL_INTERLEAVE 
case and now this dual support that you're proposing is going to make the 
documentation very difficult to understand for anyone who simply wants to 
use mempolicies.

Others even in this thread have had a hard enough time understanding the 
difference between the two choices and you explained them very thoroughly.  
It's going to be much more trouble than it's worth, I predict.

> There is no "_then_ attach the task to a cpuset."  On systems with
> kernels configured with CONFIG_CPUSETS=y, all tasks are in a cpuset
> all the time.  Moreover, from a practical point of view, on large
> systems managed with cpuset based mechanisms, almost all tasks are in
> cpusets that do not include all nodes, for the entire life of the task.
> 

And that application would need to be implemented to know the nodes that 
it has access to before it issues its set_mempolicy(MPOL_PREFERRED) 
command anyway if it truly uses Choice A behavior.  So unless these tasks 
are looking in /proc/pid/status and parsing Mems_allowed and then 
specifying one as its preferred node or always being guaranteed a certain 
set of nodes that they are always attached to in a cpuset so they have 
such foresight of what node to prefer, Choice A can't possibly be what 
they want.

> > Yet the 'mems' file would still be system-wide; otherwise it would be 
> > impossible to expand the memory your cpuset has access to.
> 
> I had to read that a couple of times to make sense of it.  I take that
> it means that the node numbering used in each cpuset's 'mems' file has
> to be system-wide.  Yes, agreed.
> 
> (Well, actually, the node numbering of each cpusets 'mems' file could
> be relative to its parent cpusets 'mem' numbers, but let's not go
> there, as this discussion is already sufficiently complicated ;)
> 

I appreciate that very much.

> Would it meet the need that prompted your initial patch set if we
> added Choice B memory policy node numbering, but left Choice A as the
> kernel default, with a per-task option (perhaps invokable by a new
> option to one of the {get,set}_mempolicy() calls) to choose Choice B?
> 

The needs I was addressing with my initial patchset was so that when a 
cpuset is expanded, any MPOL_INTERLEAVE memory policy of attached tasks 
automatically get expanded as well.  This discussion has somewhat diverged 
from that, but I hope you still support what we earlier talked about in 
terms of adding a field to struct mempolicy to remember the intended 
nodemask the application asked to interleave over.

> This lets us get Choice B out there, and lets the two main libraries,
> libnuma and libcpuset, dynamically adapt to whichever Choice is active
> for the current task.
> 
> Unchanged applications and existing binaries would simply continue with
> Choice A.  With one additional line of code, a user application could
> get Choice B, with its ability for example to request MPOL_INTERLEAVE
> over all cpuset allowed nodes, where the kernel automatically adapts
> that to changing cpuset changes from larger 'mems' to smaller 'mems'
> and back to larger 'mems' again.
> 

You don't actually need to choose between the two choices for adapting 
MPOL_INTERLEAVE over _all_ allowed cpuset nodes.

I thought what we agreed upon and what you were going to implement was 
adding a nodemask_t to struct mempolicy for the intended nodemask of the 
memory policy and then AND it with pol->cpuset_mems_allowed.  That 
completely satisfies my needs and my applications that want to allocate 
over all available nodes (by simply passing numa_all_nodes to 
set_mempolicy(MPOL_INTERLEAVE)).  If I wanted to interleave only over a 
subset, the choices would matter.

		David
