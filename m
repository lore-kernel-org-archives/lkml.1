Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXJ1SUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXJ1SUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXJ1SUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:20:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXJ1SUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:20:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=NWeNTx5lAz9XnjdgjaMunT5ob7/pkLLe+HhNvv1cyuG0iInGEWCoMyZxoZtjZAQtT
	oRxbqX/MVwngyy8TblWeA==
Date: Sun, 28 Oct 2007 11:19:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071027161955.e9d4d2db.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com>
 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com> <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com>
 <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com> <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Paul Jackson wrote:

> > but I actually would recommend against any flag to effect Choice A.
> > It's simply going to be too complex to describe and is going to be a
> > headache to code and support. 
> 
> While I am sorely tempted to agree entirely with this, I suspect that
> Christoph has a point when he cautions against breaking this kernel API.
> 
> Especially for users of the set/get mempolicy calls coming in via
> libnuma, we have to be very careful not to break the current behaviour,
> whether it is documented API or just an accident of the implementation.
> 

>From a standpoint of the MPOL_PREFERRED memory policy itself, there is no 
documented behavior or standard that specifies its interaction with 
cpusets.  Thus, it's "undefined."  We are completely free to implement an 
undefined behavior as we choose and change it as Linux matures.

Once it is defined, however, we carry the burden of protecting 
applications that are written on that definition.  That's the point where 
we need to get it right and if we don't, we're stuck with it forever; I 
don't believe we're at that point with MPOL_PREFERRED policies under 
cpusets right now.

> There is a fairly deep and important stack of software, involving a
> well known DBMS product whose name begins with 'O', sitting on that
> libnuma software stack.  Steering that solution stack is like steering
> a giant oil tanker near shore.  You take it slow and easy, and listen
> closely to the advice of the ancient harbor master.  The harbor masters
> in this case are or were Andi Kleen and Christoph Lameter.
> 

Ok, let's take a look at some specific unproprietary examples of tasks 
that use set_mempolicy(MPOL_PREFERRED) for a specific node, intending it 
to be the actual system node offset, that is then assigned to a cpuset 
that doesn't require that offset to be allowed.

I think it's going to become pretty difficult to find an example because 
the whole scenario is pretty lame: you would need to already know which 
nodes you're going to be assigned to in the cpuset to ask for one of them 
as your preferred node.  I don't imagine any application can have that 
type of foresight and, if it does, then we certainly shouldn't support the 
preferred node_remap() when it changes mems.

You're trying to support a scheme, in Choice A, where an application knows 
it's going to be assigned to a range of nodes (for example, 1-3) and wants 
the preferred node to be included (for example, 2).  So now the 
application must have control over both its memory policy and its cpuset 
placement.  Then it must be willing to change its cpuset placement to a 
different set of nodes (with equal or greater cardinality) and have the 
preferred node offset respected.  Why can't it simply then issue another 
set_mempolicy(MPOL_PREFERRED) call for the new preferred node?

See?  The problem is that you're trying to protect applications that know 
its initial cpuset mems [the only way it could ever send a 
set_mempolicy(MPOL_PREFERRED) for the right node in that range in the 
first place] but then seemingly loses control over its cpuset and intends 
for the kernel to fix it up for it without having the burden of issuing 
another set_mempolicy() call.

And you're trying to protect this application that based this 
implementation not on a standard or documentation, but on its observed 
behavior.  My bet is that it's going to issue that subsequent 
set_mempolicy(), at least if libnuma returned a numa_preferred() value 
that it wasn't expecting.

> True, which is why I am hoping we can keep this modal flag, if such be,
> from having to be used on every set/get mempolicy call.  The ordinary
> coder of new code using these calls directly should just see Choice B
> behaviour.  However the user of libnuma should continue to see whatever
> API libnuma supports, with no change whatsoever, and various versions of
> libnuma, including those already shipped years ago, must continue to
> behave without any changes in node numbering.
> 

I don't see how you can accomplish that.  If the default behavior is 
Choice B, which is different from what is currently implemented in the 
kernel, you're going to either require a modification to the application 
to set a flag asking for Choice A again or make the default kernel 
behavior that of Choice A and set a flag implicitly via libnuma when 
future versions are released.

In the former case, just ask the application to adjust its node numbering 
scheme or check the result of numa_preferred().  In the latter case, we're 
not even talking about changing the kernel default anymore to Choice B.

>  2) We have a per-task mode flag selecting whether Choice A or B
>     node numbering apply to the masks passed in to set_mempolicy.
> 
>     The kernel implementation is fairly easy.  (Yeah, I know, I
>     too cringe everytime I read that line ;)
> 

If you add this per-task mode flag to default to Choice A for preferred 
memory policies, it'll be extremely confusing to document and support.  If 
it's already decided that we should default to Choice B, it's going to 
require an update to the application to write to /proc/pid/i_want_choice_A 
or use the new set_mempolicy() option anyway, so instead of adding that 
hack you should simply fix your node numbering.

And I suspect that if that per-task mode flag is added, it will eventually 
be the subject of a thread with the subject "is this highly specialized 
flag even used anymore?" at which point it will be marked deprecated and 
eventually obsoleted.

>     The bulk of the kernel's mempolicy code is coded for Choice B.
> 
>     If Choice B is active, we don't enforce the subset check in
>     contextualize_policy(), and we don't invoke nodes_remap() in either
>     of the set or get mempolicy code paths.
> 

Yeah, remapping the nodemask is a bad idea anyway to get a preferred node.  
Preferred nodes inherently deal with offsets from node 0 anyway.

>     A new option to get_mempolicy() would query the current state of
>     this mode flag, and a new option to set_mempolicy() would set
>     and clear this mode flag.  Perhaps Christoph had this in mind
>     when he wrote in an earlier message "The alternative is to add
>     new set/get mempolicy functions."
> 

That still requires a change to the application.  So they should simply 
rethink their node numbering instead and fix their application to follow a 
behavior that will, at that point, be documented.

Any application that doesn't respect the return value of 
set_mempolicy(MPOL_PREFERRED) node isn't worth supporting anyway.

There's two cases to think about:

 - When the cpuset assignment changes from the root cpuset to a
   user-created cpuset with a subset of system mems and then
   set_mempolicy() is called, and

 - When set_mempolicy() is called and then the cpuset mems change either
   because it was attached to a different cpuset or someone wrote to its
   'mems' file.

In the first case, the new API should return -EINVAL if you ask for a 
preferred node offset that is smaller than the cardinality of your 
mems_allowed.  That will catch some of these applications that may have 
actually been implemented based on the current undocumented behavior.

In the second case, the first node in the nodemask passed to 
set_mempolicy() was a system node offset anyway and had nothing to do with 
cpusets (it was a member of the root cpuset with access to all mems) so it 
already behaves as Choice B.

> There are two major user level libraries sitting on top of this API,
> libnuma and libcpuset.  Libnuma is well known; it was written by Andi
> Kleen.  I wrote libcpuset, and while it is LGPL licensed, it has not
> been publicized very well yet.  I can speak for libcpuset: it could
> adapt to the above proposal, in particular to the details in way (2),
> just fine.  Old versions of libcpuset running on new kernels will
> have a little bit of subtle breakage, but not in areas that I expect
> will cause much grief.  Someone more familiar with libnuma than I would
> have to examine the above proposal in way (2) to be sure that we weren't
> throwing libnuma some curveball that was unnecessarily troublesome.
> 

I think any application that gets constrained to a subset of nodes in its 
mems_allowed and then bases its preferred node number off that subset to 
create an offset that is intended to be preserved over subsequent mems 
changes without rechecking the result with numa_preferred() or issuing a 
subsequent set_mempolicy() is poorly written.  Especially since that 
behavior was undocumented.

		David
