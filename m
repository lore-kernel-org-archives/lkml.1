Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbYBMRF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbYBMRF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbYBMREg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:04:36 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44446 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933862AbYBMREc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:04:32 -0500
Date: Wed, 13 Feb 2008 11:04:26 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080213110426.15179378.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, responding to pj, write:
> >  2) a cpuset relative mode that correctly handled the case of cpusets
> >     growing larger (increased numbers of nodes.)
> > 
> > I'd like to persuade you to add case (2) as well.  But I suspect,
> > given that case (2) was never as compelling to you as it was to me
> > in our December discussions, that I'll have little luck doing that.
> > 
> 
> MPOL_F_STATIC_NODES already handles the second case because you can 
> specify nodes that aren't currently accessible because of your cpuset in 
> the hopes that eventually they will become accessible.

No -- MPOL_F_STATIC_NODES does not handle my second case.  Notice the
phrase 'cpuset relative.'

In my second case, nodes are numbered relative to the cpuset.  If you
say "node 2" then you mean whatever is the third (since numbering is
zero based) node in your current cpuset.

This cpuset relative mode that I'm proposing is an entirely different
mode of numbering nodes than anything we've seen so far (except for our
side discussions with just yourself, Lee and Christoph, last December.)

In this mode, "node 2" doesn't mean what the system calls "node 2"; it
means the third node in whatever is ones current cpuset placement (if
your cpuset even has that many nodes), and mempolicies using this mode
are automatically remapped by the kernel, anytime the cpuset placement
changes.

This second, cpuset relative, mode is required:

1) to provide a race-free means for an application to place its memory
   when the application considers all physical nodes essentially
   equivalent, and just wants to lay things out relative to whatever
   cpuset it happens to be running in, and

2) to provide a practical means, without the need for constantly
   reprobing ones current cpuset placement, for an application to
   specify cpuset-relative placement to be applied whenever the
   application is placed in a larger cpuset, even if the application
   is presently in a smaller cpuset.

Without it, the application has to first query its current physical
cpuset placement, then calculate its desired relative placement into
terms of the current physical nodes it finds itself on, and then issue
various mbind or set_mempolicy calls using those current physical node
numbers, praying that it wasn't migrated to other physical nodes at the
same time, which would have invalidated its current placement
assumptions in its relative to physical node number calculations.

And without it, if an application is currently placed in a smaller cpuset
than it would prefer, it cannot specify how it would want its mempolicies
should it ever subsequently be moved to a larger cpuset.  This leaves such
an application with little option other than to constantly reprobe its
cpuset placement, in order to know if and when it needs to reissue its
mbind and set_mempolicy calls because it gained access to a larger cpuset.

I agree, David, that this present MPOL_F_STATIC_NODES patch handles the
case of a growing cpuset (or hotplug added nodes) for the static mapped
case (node "2" means physical system node "2", always.)  But this
present patch, by design, does not address the case of a growing cpuset
for the case where an application actually wants its mempolicies remapped.

My original code remapping mempolicies when cpuset placement changes,
that has been in the kernel for a couple of years now, was -supposed-
to handle this relative case.  But it is flawed, as it fails to meet
the requirements I list above.  We can't just change the way that mode
works now, for compatibility reasons.  So we need to add a new cpuset
relative mode, just as you're adding a STATIC mode, that addresses the
above requirements for a cpuset relative, remapped, numbering of
mempolicy nodes.


> Other than that, perhaps if you can elaborate more on what you imagined 
> supporting as far as cpusets growing larger (or supporting node hotplug, 
> which is the same type of problem), we can discuss that further before I 
> resend my patches.

Ok - I tried to elaborate, above.  You (David), Lee and Christoph will
perhaps recognize this elaboration, as it essentially repeats things
I said in our earlier discussion in December and early January.

Yes - hotplug presents the same problems as cpusets growing larger.

If this makes sense to you, David, and you'd like to include this
second, cpuset relative mode, in your patchset, that would be excellent.

Given that I have not been very good at explaining this second mode
you might choose not to do that; in that case I'll have to follow up,
after your second patch shapes up, with a patch of my own, adding this
cpuset relative mode.


> >     I believe you can overlay these two nodemasks using a union, and
> >     avoid making struct mempolicy bigger.
> 
> Ahh, since policy->cpuset_mems_allowed is only meaningful in the 
> non-MPOL_F_STATIC_NODES case, that probably will work.  For the purposes 
> of this patchset, we can certainly do that.  I'm wondering whether future 
> expansions will require them to be separated again, however.

I'd suggest we let future expansions deal with their own needs.  We
don't usually pad internal (not externally visible) data structures
in anticipation that someone else might need the space in the future.

At least earlier, Andi Kleen, when he was the primary author and sole
active maintainer of this mempolicy code, was always keen to avoid
expanding the size of 'struct mempolicy' by another nodemask.

I have not done the calculations myself to know how vital it is to
keep the size of struct mempolicy to a minimum.  It certainly seems
worth a bit of effort, however, if adding this union of these two
nodemasks doesn't complicate the code too horribly much.

> >     I urge you to reconsider, and keep it so that the 'policy' field of struct
> >     mempolicy naturally evaluates to just the policy.  There should be just one
> >     pair of places, on entry to, and exit from, the kernel, where the code is
> >     aware of the need to pack the mode and the policy into a single word.
> > 
> 
> Ok.

Cool.  Thanks.  (I'm glad you caved ... ;).  Looking forward in my inbox, I see
that Lee has some suggestions on where to handle the conversion between the
packed mode and the separate fields.  I'm too lazy to think about that more,
and will likely acquiesce to whatever you and Lee agree to.


> >  3) Does your patchset allow the user to specify a nodemask that includes nodes
> >     outside of the current cpuset with a MPOL_F_STATIC_NODES mode?  At first
> >     glance, I didn't see that it did, but I should have looked closer.  This
> >     strikes me as an essential aspect of this mode.
> > 
> 
> It does, and that's why I was a little curious about your second case at 
> the beginning of this email.
> 
> The user's nodemask is always stored unaltered in policy->user_nodemask.  

Ah - good.  I missed that.  Just to be sure I'm reading the code right,
I take it that it is the following line, at the end of the mpol_new()
routine, that stores the unaltered user nodemask ... right?

	policy->user_nodemask = *nodes;


> The only way that newly-accessible nodes will not become a part of the 
> mempolicy nodemask is when the user's nodemask and the set of accessible 
> nodes is disjoint when the policy was created.
> 
> It is arguable whether we want to support that behavior as well (and we 
> definitely could do it, it's not out of the scope of mempolicies).  Lee 
> had specific requirements of rejecting nodemasks that had no nodes in the 
> intersection based on the current implementation, but we could continue 
> discussing the possibility of setting up mempolicies that are uneffected 
> when they are created and only become policy when they are rebound later.

I would be inclined toward having the classic compatibility mode (no
such mode as MPOL_F_STATIC_NODES specified) continue to do as it always
has done, which apparently includes failing EINVAL in some cases due to
an empty nodemask intersection with the current cpuset.

But I would also expect that this new MPOL_F_STATIC_NODES would allow
specifying any nodes, whether or not any of them were in the tasks
current cpuset.

Looking ahead, I think Lee is saying pretty much the same thing.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
