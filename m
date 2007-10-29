Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbXJ2BEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbXJ2BEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXJ2BE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:04:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbXJ2BE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:04:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xbyhcb/XDcWijmEyyE2r4YPlTXBMTOJGevGa8mGJ3wNOCDFg3FNT4w0xTQFyJb5mn
	oeBjWJ0JerNiyzXWax/Ng==
Date: Sun, 28 Oct 2007 18:04:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071028164637.8d1b45b0.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost>
 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
 <20071027161955.e9d4d2db.pj@sgi.com> <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Paul Jackson wrote:

> The Linux documentation is not a legal contract.  Anytime we change the
> actual behaviour of the code, we have to ask ourselves what will be the
> impact of that change on existing users and usages.  The burden is on
> us to minimize breaking things (by that I mean, what users would
> consider breakage, even if we think it is all for the better and that
> their code was the real problem.)  I didn't say no breakage, but
> minimum breakage, doing our best to guide users through changes with
> minimum disruption to their work.
> 

Nobody can show an example of an application that would be broken because 
of this and, given the scenario and sequence of events that it requires to 
be broken when implementing the default as Choice B, I don't think it's as 
much of an issue as you believe.

> >     However, in deference to the needs of libnuma, if the following
> >     call was made, this would change the mode for that task to
> >     Choice A:
> > 
> > 	get_mempolicy(NULL, NULL, 0, 0, 0);
> > 
> >     This last detail above is an admitted hack.  *So far as I know*
> >     it happens that all current infield versions of libnuma issue the
> >     above call, as their first mempolicy query, to detemine whether
> >     the active kernel supports mempolicy.
> 
> The above is the hack that allows us to support existing libnuma based
> applications (the most significant users of memory policy historically)
> with a default of Choice A, while other code and future code defaults
> to Choice B.
> 

So all applications that use the libnuma interface and numactl will have 
different default behavior than those that simply issue 
{get,set}_mempolicy() calls.  libnuma is a collection of higher level 
functions that should be built upon {get,set}_mempolicy() like they 
currently are and not introduce new subtleties like changing the semantics 
of a preferred node argument.  This is going to quickly become a 
documentation nightmare and, in my opinion, isn't worth the time or effort 
to support because we haven't even idenitifed any real-world examples.

Maybe Andi Kleen should weigh in on this topic because, if we go with what 
you're suggesting, we'll never get rid of the two differing behaviors and 
we'll be introducing different semantics to arguments of libnuma functions 
than the kernel API they are built upon.

> I'm trying to protect almost any application that uses both
> set_mempolicy or mbind, while in a cpuset.
> 
>     If a task is in a cpuset on say nodes 16-23, and it wants to issue
>     any mbind, or any MPOL_PREFERRED, MPOL_BIND, or MPOL_INTERLEAVE
>     mempolicy call, then under Choice A it must issue nodemasks offset
>     by 16, relative to what it would issue under Choice B.
> 

True, but the ordering of that scenario is troublesome.  The correct way 
to implement it is to use set_mempolicy() or a higher level libnuma 
function with the same semantics and _then_ attach the task to a cpuset.  
Then the nodes_remap() takes care of the rest.

The scenario you describe above has a problem because it requires the task 
to have knowledge of the cpuset's mems in which it is attached when, for 
portability, it should have been written so that it is robust to any range 
of nodes you happen to assign it to.

> Almost any task using memory policies on a system making active use of
> cpusets will be affected, even well written ones doing simple things.
> 

No, because nodes_remap() takes care of the instances you describe above 
when the task sets its memory policy (usually done when it is started) and 
is then attached to a cpuset.

> However, if anyone is deploying product or has important (to them) but
> not easy to change software using both memory policies and cpusets that
> are not doing so via libnuma or libcpuset, then any change that
> changes the default for their memory policy calls from Choice A to
> Choice B will probably break them.
> 

Supporting two different behaviors is going to be more problematic than 
simply selecting one and going with it and its associated documentation in 
future versions of the kernel.

> I'm tempted to think I need to go a bit further:
>  1) Add a per-system or per-cpuset runtime mode, to enable a system
>     administrator to revert to the Choice A default.

Paul, the changes required to an application that is currently using 
{get,set}_mempolicy() calls to setup the memory policy or the higher level 
functions through libnuma is so easy to use Choice B as a default instead 
of Choice A that it would be ridiculous to support configuring it on a 
per-system or per-cpuset basis.

>  2) Make sure that both the new libnuma and libcpuset versions dynamically
>     probe the state of this default, and dynamically adapt to running
>     on a kernel, or in a cpuset, of either default.  If this mode is
>     per-cpuset, then so long as there are not two applications that
>     must both run in the same cpuset, both using memory policies,
>     neither using libnuma or libcpuset, requiring conflicting defaults
>     (one Choice A, the other Choice B) then this would provide an
>     administrator sufficient flexibility to adapt.
> 

Choosing only one behavior for the kernel (Choice B) is by far the 
superior selection because then any task can share a cpuset with any other 
task and implement its memory policy preferences in terms of low level 
system calls, numactl, or libnuma.  That's the power that we should be 
giving users, not the addition of hacks or more configuration knobs that 
is going to clutter and confuse anybody who wants to simply pick a 
preferred node.

> There would be one key advantage to a per-cpuset mode flag here.  It
> exposes in a fairly visible way this change in the default numbering of
> memory policy node masks, from cpuset relative to system relative (with
> the system now automatically making them cpuset relative across any
> changes in the number of nodes in the cpuset.)  This is a classic way
> to guide users to understanding new alternatives and changes; expose it
> as a 'button on the dashboard', a feature, not a hidden gotcha.
> 

Yet the 'mems' file would still be system-wide; otherwise it would be 
impossible to expand the memory your cpuset has access to.  Everything 
else would be relative to 'mems'.

		David
