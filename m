Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXJ1Xqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXJ1Xqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXJ1Xqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:46:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60804 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753533AbXJ1Xqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:46:42 -0400
Date: Sun, 28 Oct 2007 16:46:37 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071028164637.8d1b45b0.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
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
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> From a standpoint of the MPOL_PREFERRED memory policy itself, there
> is no documented behavior or standard that specifies its interaction
> with cpusets.  Thus, it's "undefined."  We are completely free
> to implement an undefined behavior as we choose and change it as
> Linux matures.

You state this point clearly, but I have to disagree.

The Linux documentation is not a legal contract.  Anytime we change the
actual behaviour of the code, we have to ask ourselves what will be the
impact of that change on existing users and usages.  The burden is on
us to minimize breaking things (by that I mean, what users would
consider breakage, even if we think it is all for the better and that
their code was the real problem.)  I didn't say no breakage, but
minimum breakage, doing our best to guide users through changes with
minimum disruption to their work.

Linux is gaining market share rapidly because we co-operate with our
users to give us both the best chance of succeeding.

We don't just play gotcha games with the documentation -- ha ha --
we didn't document that detail, so it's your fault for ever depending
on it.  And besides your code sucks.  So there!  Let's leave that game
for others.

> And you're trying to protect this application that based this 
> implementation not on a standard or documentation, but on its observed 
> behavior.

Yes, if there is such an application, I'm trying to protect it.

> My bet is that it's going to issue that subsequent 
> set_mempolicy(), at least if libnuma returned a numa_preferred() value 
> that it wasn't expecting.

Perhaps.  Perhaps not.  I don't know.

> That still requires a change to the application.

If that were so, then yes much of your subsequent reasoning would follow.

However, let me repeat the following from my previous message:

>     However, in deference to the needs of libnuma, if the following
>     call was made, this would change the mode for that task to
>     Choice A:
> 
> 	get_mempolicy(NULL, NULL, 0, 0, 0);
> 
>     This last detail above is an admitted hack.  *So far as I know*
>     it happens that all current infield versions of libnuma issue the
>     above call, as their first mempolicy query, to detemine whether
>     the active kernel supports mempolicy.

The above is the hack that allows us to support existing libnuma based
applications (the most significant users of memory policy historically)
with a default of Choice A, while other code and future code defaults
to Choice B.

> See?  The problem is that you're trying to protect applications that know 
> its initial cpuset mems [the only way it could ever send a 
> set_mempolicy(MPOL_PREFERRED) for the right node in that range in the 
> first place] but then seemingly loses control over its cpuset and intends 
> for the kernel to fix it up for it without having the burden of issuing 
> another set_mempolicy() call.

That's not the only sort of application I'm trying to protect.

I'm trying to protect almost any application that uses both
set_mempolicy or mbind, while in a cpuset.

    If a task is in a cpuset on say nodes 16-23, and it wants to issue
    any mbind, or any MPOL_PREFERRED, MPOL_BIND, or MPOL_INTERLEAVE
    mempolicy call, then under Choice A it must issue nodemasks offset
    by 16, relative to what it would issue under Choice B.

Almost any task using memory policies on a system making active use of
cpusets will be affected, even well written ones doing simple things.

I am more concerned that the above hack for libnuma isn't enough,
rather than it is unnecessary.

I think the above hack covers existing libnuma users rather well,
though I could be wrong even here, as I don't actually work with
most of the existing libnuma users.

And I can cover those using both memory policies and cpusets via
libcpuset, as there I am the expert and know that I can guide
libcpuset and its users through this change.  There will be some
breakage, but I know how to manage it.

However, if anyone is deploying product or has important (to them) but
not easy to change software using both memory policies and cpusets that
are not doing so via libnuma or libcpuset, then any change that
changes the default for their memory policy calls from Choice A to
Choice B will probably break them.

Perhaps there are no significant cases like this, using memory policies
on cpuset managed systems, but not via libnuma or libcpuset.  It might
be that the only way to smoke out such cases is to ship the change (to
Choice B default) and see what squawks.  That kinda sucks.

I'm tempted to think I need to go a bit further:
 1) Add a per-system or per-cpuset runtime mode, to enable a system
    administrator to revert to the Choice A default.
 2) Make sure that both the new libnuma and libcpuset versions dynamically
    probe the state of this default, and dynamically adapt to running
    on a kernel, or in a cpuset, of either default.  If this mode is
    per-cpuset, then so long as there are not two applications that
    must both run in the same cpuset, both using memory policies,
    neither using libnuma or libcpuset, requiring conflicting defaults
    (one Choice A, the other Choice B) then this would provide an
    administrator sufficient flexibility to adapt.

There would be one key advantage to a per-cpuset mode flag here.  It
exposes in a fairly visible way this change in the default numbering of
memory policy node masks, from cpuset relative to system relative (with
the system now automatically making them cpuset relative across any
changes in the number of nodes in the cpuset.)  This is a classic way
to guide users to understanding new alternatives and changes; expose it
as a 'button on the dashboard', a feature, not a hidden gotcha.

It's the old "it's a feature, not a bug" approach.  It can be a
useful mechanism to educate and enpower customers.

Users end up seeing it, learning about it, enjoying some sense of
control, and usually being able to make it work for them, one way
or the other.  That works out better than just hitting some random
subset of users with subtle bugs (from their perspective) over which
they have little or no control and fewer clues.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
