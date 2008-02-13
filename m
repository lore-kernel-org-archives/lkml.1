Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbYBMJhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbYBMJhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYBMJgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:36:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYBMJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:36:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=pk4reYm+dhKCLjQ2920g9uk8OXzVDCHhH+uU+qgm/r+VI1K5mZ11sdmeWQNGOS/MD
	twTlPD2/jJF+j++xhxkqw==
Date: Wed, 13 Feb 2008 01:36:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080213020344.45c9d924.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com> <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com> <20080213020344.45c9d924.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Paul Jackson wrote:

> The infamous unpublished (except to a few) patch I drafted on Christmas
> (Dec 25, 2007) basically added two new modes for how mempolicy
> nodemasks were to be resolved:
>  1) a static, no remap, mode, such as in this present patchset, and
>  2) a cpuset relative mode that correctly handled the case of cpusets
>     growing larger (increased numbers of nodes.)
> 
> I'd like to persuade you to add case (2) as well.  But I suspect,
> given that case (2) was never as compelling to you as it was to me
> in our December discussions, that I'll have little luck doing that.
> 

MPOL_F_STATIC_NODES already handles the second case because you can 
specify nodes that aren't currently accessible because of your cpuset in 
the hopes that eventually they will become accessible.  It's possible to 
pass a nodemask with all bits set so that when the cpuset's set of nodes 
expand, the mempolicy is effected over the intersection of the two on 
rebind.

Other than that, perhaps if you can elaborate more on what you imagined 
supporting as far as cpusets growing larger (or supporting node hotplug, 
which is the same type of problem), we can discuss that further before I 
resend my patches.

> Notes and questions on your current patchset:
> 
>  1) It looks like you -add- a second nodemask to struct mempolicy:
> 	    nodemask_t cpuset_mems_allowed; /* mempolicy relative to these nodes */
> 	    nodemask_t user_nodemask;       /* nodemask passed by user */
> 
>     I believe you can overlay these two nodemasks using a union, and avoid making
>     struct mempolicy bigger.
> 

Ahh, since policy->cpuset_mems_allowed is only meaningful in the 
non-MPOL_F_STATIC_NODES case, that probably will work.  For the purposes 
of this patchset, we can certainly do that.  I'm wondering whether future 
expansions will require them to be separated again, however.

>  2) Those 'mpol_mode()' wrappers on all those mempolicy->policy
>     evaluations look dangerous to me.  It looks like a code bug
>     waiting to happen.  Unless I miss my guess, if you forget one of
>     those wrappers (or someone making a future change misses one), no
>     one will notice until sometime at runtime, someone makes use of the
>     new fangled MPOL_F_STATIC_NODES mode in some new situation, and we
>     end up executing code that we didn't expect to execute just then.
> 
>     I urge you to reconsider, and keep it so that the 'policy' field of struct
>     mempolicy naturally evaluates to just the policy.  There should be just one
>     pair of places, on entry to, and exit from, the kernel, where the code is
>     aware of the need to pack the mode and the policy into a single word.
> 

Ok.

>  3) Does your patchset allow the user to specify a nodemask that includes nodes
>     outside of the current cpuset with a MPOL_F_STATIC_NODES mode?  At first
>     glance, I didn't see that it did, but I should have looked closer.  This
>     strikes me as an essential aspect of this mode.
> 

It does, and that's why I was a little curious about your second case at 
the beginning of this email.

The user's nodemask is always stored unaltered in policy->user_nodemask.  
In mpol_new(), we intersect the current accessible nodes with that 
nodemask to determine if there's even a mempolicy to effect.  If not, 
mpol_new() returns ERR_PTR(-EINVAL) and we fall back to the existing 
policy (if any) for the VMA or task.  Otherwise, we use the intersection 
of those two nodemasks.

In mpol_rebind_policy() with MPOL_F_STATIC_NODES, we always intersect 
policy->user_nodemask with the set of accessible nodes (nodemask_t 
*newmask).  So if we can now access nodes that we previously couldn't, 
they are now part of the interleave nodemask.  A similiar situation occurs 
when building the zonelist for the MPOL_BIND case and you can see the 
change I made to MPOL_PREFERRED in the incremental patch I sent you.

The only way that newly-accessible nodes will not become a part of the 
mempolicy nodemask is when the user's nodemask and the set of accessible 
nodes is disjoint when the policy was created.

It is arguable whether we want to support that behavior as well (and we 
definitely could do it, it's not out of the scope of mempolicies).  Lee 
had specific requirements of rejecting nodemasks that had no nodes in the 
intersection based on the current implementation, but we could continue 
discussing the possibility of setting up mempolicies that are uneffected 
when they are created and only become policy when they are rebound later.

		David
