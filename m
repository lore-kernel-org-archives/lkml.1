Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXJ2E2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXJ2E2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXJ2E1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:27:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54851 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbXJ2E1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:27:52 -0400
Date: Sun, 28 Oct 2007 21:27:45 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071028212745.57a7db67.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Nobody can show an example of an application that would be broken because 
> of this and, given the scenario and sequence of events that it requires to 
> be broken when implementing the default as Choice B, I don't think it's as 
> much of an issue as you believe.

Well, neither you nor I have shown an example.  That's different than
"nobody can."

Since it would affect any task setting memory policies while in a
cpuset holding less than all memory nodes, it seems potentially serious
to me.

Actually, I have one example.  The libcpuset library would have some
breakage with Choice B the only Choice.  But I'm in a position to deal
with that, so it's not a big deal.


> So all applications that use the libnuma interface and numactl will have 
> different default behavior than those that simply issue 
> {get,set}_mempolicy() calls.

Breaking the libnuma-Oracle solution stack is not an option.

And, unless someone in the know tells us otherwise, I have to assume
that this could break them.  Now, the odds are that they simply don't
run that solution stack on any system making active use of cpusets,
so the odds are this would be no problem for them.  But I don't
presently have enough knowledge of their situation to take that risk.


> if we go with what you're suggesting, we'll never get rid of the two
> differing behaviors and we'll be introducing different semantics
> to arguments of libnuma functions than the kernel API they are
> built upon.

We could get rid of Choice A once libnuma and libcpuset have adapted
to Choice B, and any other uses of Choice A that we've subsequently
identified have had sufficient time to adapt.

But dual support is pretty easy so far as the kernel code is concerned.
It's just a few nodes_remap() calls optionally invoked at a few key
spots in mm/mempolicy.c.  Consequently there won't be a big hurry to
remove Choice A.


> > I'm trying to protect almost any application that uses both
> > set_mempolicy or mbind, while in a cpuset.
> > 
> >     If a task is in a cpuset on say nodes 16-23, and it wants to issue
> >     any mbind, or any MPOL_PREFERRED, MPOL_BIND, or MPOL_INTERLEAVE
> >     mempolicy call, then under Choice A it must issue nodemasks offset
> >     by 16, relative to what it would issue under Choice B.
> > 
> 
> True, but the ordering of that scenario is troublesome.  The correct way 
> to implement it is to use set_mempolicy() or a higher level libnuma 
> function with the same semantics and _then_ attach the task to a cpuset.  
> Then the nodes_remap() takes care of the rest.

There is no "_then_ attach the task to a cpuset."  On systems with
kernels configured with CONFIG_CPUSETS=y, all tasks are in a cpuset
all the time.  Moreover, from a practical point of view, on large
systems managed with cpuset based mechanisms, almost all tasks are in
cpusets that do not include all nodes, for the entire life of the task.

And besides, I can't break existing applications willy-nilly, and
then claim it's their fault, because they should have been coded
differently.  So "correct way" arguments don't hold alot of weight
for already released and deployed product.


> Paul, the changes required to an application that is currently using 
> {get,set}_mempolicy() calls to setup the memory policy or the higher level 
> functions through libnuma is so easy to use Choice B as a default instead 
> of Choice A that it would be ridiculous to support configuring it on a 
> per-system or per-cpuset basis.

David ;)  I make some effort to avoid forcing applications to be
recoded and rebuilt in order to continue functioning.


> Yet the 'mems' file would still be system-wide; otherwise it would be 
> impossible to expand the memory your cpuset has access to.

I had to read that a couple of times to make sense of it.  I take that
it means that the node numbering used in each cpuset's 'mems' file has
to be system-wide.  Yes, agreed.

(Well, actually, the node numbering of each cpusets 'mems' file could
be relative to its parent cpusets 'mem' numbers, but let's not go
there, as this discussion is already sufficiently complicated ;)


> Everything else would be relative to 'mems'.

That's what Choice B states, yes.  Though to be clear, time for another
example:
  * task is in cpuset with mems: 24-31
  * task wants some memory policy on the first two nodes of its cpuset.
  * by Choice A, it asks for nodes 24 and 25
  * by Choice B, it asks for nodes 0 and 1

The Choice B numbering can be thought of as cpuset relative.  In it,
node N means the N-th node in my current cpuset, modulo whatever is the
node size of that cpuset.

However ...

We need to continue to support Choice A as well, perhaps for some
interim, perhaps forever.  Which doesn't much matter for now.

===

David - how would the following do for you?

Would it meet the need that prompted your initial patch set if we
added Choice B memory policy node numbering, but left Choice A as the
kernel default, with a per-task option (perhaps invokable by a new
option to one of the {get,set}_mempolicy() calls) to choose Choice B?

This lets us get Choice B out there, and lets the two main libraries,
libnuma and libcpuset, dynamically adapt to whichever Choice is active
for the current task.

Unchanged applications and existing binaries would simply continue with
Choice A.  With one additional line of code, a user application could
get Choice B, with its ability for example to request MPOL_INTERLEAVE
over all cpuset allowed nodes, where the kernel automatically adapts
that to changing cpuset changes from larger 'mems' to smaller 'mems'
and back to larger 'mems' again.

It would mean you would have to make a change to your applications
to get this improved interleaving.  But I trust from all you've been
advocating that such a code change and rebuild would not be any problem
for whatever situation you're concerned with.

We could recommend that new code probe to see if Choice B is available
and prefer it if it is.   At some future time, we might deprecate and
eventually remove Choice A.

I appreciate that you don't want to leave in place the complications
of dual Choices, but I lack the experience, knowledge or clarity I
need to support fully changing over to Choice B at this time.

Getting Choice B out there will go a long way toward providing us
with the feedback we will need to guide future decisions.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
