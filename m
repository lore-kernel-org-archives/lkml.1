Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYBMTDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYBMTDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBMTDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:03:24 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbYBMTDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:03:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=IrzSBcCsBKXMN3NSetFjnNzgHgFURtAwIkkF9mlKtyj/lPf1/I9FLV57XL6YImuV0
	PxfAgQg0N+wWJHcrl+6xA==
Date: Wed, 13 Feb 2008 11:02:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080213110426.15179378.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com> <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com> <20080213020344.45c9d924.pj@sgi.com>
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com> <20080213110426.15179378.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Paul Jackson wrote:

> No -- MPOL_F_STATIC_NODES does not handle my second case.  Notice the
> phrase 'cpuset relative.'
> 
> In my second case, nodes are numbered relative to the cpuset.  If you
> say "node 2" then you mean whatever is the third (since numbering is
> zero based) node in your current cpuset.
> 

Ok, so this truly is a new feature that isn't addressed either by the 
current implementation or my patchset.  Fair enough.

You're specifically trying to avoid having the application know about its 
cpuset placement with regard to mems at the time it sets up its mempolicy, 
right?  Otherwise it could already setup this relative nodemask by 
selecting node 2, from your example above, in its mems_allowed and it 
would always be remapped appropriately.

> In this mode, "node 2" doesn't mean what the system calls "node 2"; it
> means the third node in whatever is ones current cpuset placement (if
> your cpuset even has that many nodes), and mempolicies using this mode
> are automatically remapped by the kernel, anytime the cpuset placement
> changes.
> 
> This second, cpuset relative, mode is required:
> 
> 1) to provide a race-free means for an application to place its memory
>    when the application considers all physical nodes essentially
>    equivalent, and just wants to lay things out relative to whatever
>    cpuset it happens to be running in, and
> 
> 2) to provide a practical means, without the need for constantly
>    reprobing ones current cpuset placement, for an application to
>    specify cpuset-relative placement to be applied whenever the
>    application is placed in a larger cpuset, even if the application
>    is presently in a smaller cpuset.
> 

So, for example, if the task is bound by mems 1-3, and it asks for 
MPOL_INTERLEAVE over 2-4, then initially the mempolicy is only effected 
over node 3 and if it's later expanded to mems 1-8, then the mempolicy is 
effected over nodes 3-5, right?

And if the mems change to 3-8, the mempolicy is remapped to 5-7 even 
though 3-5 (which it already was interleaving over) is still accessible?

> I agree, David, that this present MPOL_F_STATIC_NODES patch handles the
> case of a growing cpuset (or hotplug added nodes) for the static mapped
> case (node "2" means physical system node "2", always.)  But this
> present patch, by design, does not address the case of a growing cpuset
> for the case where an application actually wants its mempolicies remapped.
> 

Does MPOL_INTERLEAVE | MPOL_F_STATIC_NODES | MPOL_F_PAULS_NEW_FLAG make 
any logical sense?  If it does, I think we're going to be writing some 
very complex remap code in our future.

> > Ahh, since policy->cpuset_mems_allowed is only meaningful in the 
> > non-MPOL_F_STATIC_NODES case, that probably will work.  For the purposes 
> > of this patchset, we can certainly do that.  I'm wondering whether future 
> > expansions will require them to be separated again, however.
> 
> I'd suggest we let future expansions deal with their own needs.  We
> don't usually pad internal (not externally visible) data structures
> in anticipation that someone else might need the space in the future.
> 
> At least earlier, Andi Kleen, when he was the primary author and sole
> active maintainer of this mempolicy code, was always keen to avoid
> expanding the size of 'struct mempolicy' by another nodemask.
> 
> I have not done the calculations myself to know how vital it is to
> keep the size of struct mempolicy to a minimum.  It certainly seems
> worth a bit of effort, however, if adding this union of these two
> nodemasks doesn't complicate the code too horribly much.
> 

I think it will work very nicely and the benefit is immediately obvious 
for systems that have large nodemasks.

> > >     I urge you to reconsider, and keep it so that the 'policy' field of struct
> > >     mempolicy naturally evaluates to just the policy.  There should be just one
> > >     pair of places, on entry to, and exit from, the kernel, where the code is
> > >     aware of the need to pack the mode and the policy into a single word.
> > > 
> > 
> > Ok.
> 
> Cool.  Thanks.  (I'm glad you caved ... ;).  Looking forward in my inbox, I see
> that Lee has some suggestions on where to handle the conversion between the
> packed mode and the separate fields.  I'm too lazy to think about that more,
> and will likely acquiesce to whatever you and Lee agree to.
> 

Well, I didn't cave on anything, I said that we can reconsider it in the 
hopes that other people would add their feedback.  I think continuing to 
discuss this matter with yourself and Lee (and whomever else is 
interested) will lead us to the correct solution.  Since this is an 
internal implementation detail, I think it's important to hear other 
people's opinions since we're the ones who will be hacking the code in the 
future so it's really our opinions that matter.

> > The user's nodemask is always stored unaltered in policy->user_nodemask.  
> 
> Ah - good.  I missed that.  Just to be sure I'm reading the code right,
> I take it that it is the following line, at the end of the mpol_new()
> routine, that stores the unaltered user nodemask ... right?
> 
> 	policy->user_nodemask = *nodes;
> 

Yes.

> > The only way that newly-accessible nodes will not become a part of the 
> > mempolicy nodemask is when the user's nodemask and the set of accessible 
> > nodes is disjoint when the policy was created.
> > 
> > It is arguable whether we want to support that behavior as well (and we 
> > definitely could do it, it's not out of the scope of mempolicies).  Lee 
> > had specific requirements of rejecting nodemasks that had no nodes in the 
> > intersection based on the current implementation, but we could continue 
> > discussing the possibility of setting up mempolicies that are uneffected 
> > when they are created and only become policy when they are rebound later.
> 
> I would be inclined toward having the classic compatibility mode (no
> such mode as MPOL_F_STATIC_NODES specified) continue to do as it always
> has done, which apparently includes failing EINVAL in some cases due to
> an empty nodemask intersection with the current cpuset.
> 

And it does in my latest series, which I sent to you last night.

		David
