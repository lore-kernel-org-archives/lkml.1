Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYB1VI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYB1VI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763905AbYB1VI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:08:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762078AbYB1VIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:08:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ZXxC6hwxe917ewOXHpVIe6bLL3z/osZtXM+3bwHg21nPEeOmJXCEi3OVQMmXAiRzy
	Qc6KX1b1K5ExoTIgaFiqg==
Date: Thu, 28 Feb 2008 13:08:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <1204126666.5029.26.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802281259030.24402@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
  <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com> <1204126666.5029.26.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Lee Schermerhorn wrote:

> > Here's some examples of the functional changes between the default 
> > actions of the various mempolicy modes and the new behavior with 
> > MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES.
> 
> Nice work.  Would you consider adding this [with the corrections you
> note below] to the memory policy doc under the "interaction with
> cpusets" section?
> 

I think it's overly verbose for adding to documentation.  Other than 
describing the effects of MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES, I 
don't think much more in the way of examples need to be provided (they 
were here to show that the patchset actually works on creation and 
rebind).

> > 			MPOL_INTERLEAVE
> > 			---------------
> > 	mems	nodemask	result		rebind		result
> > 	1-3	0-2		1-2[*]		4-6		4-5
> > 	1-3	1-2		1-2		0-2		0-1
> > 	1-3	1-3		1-3		4-7		4-6
> > 	1-3	2-4		2-3		0-2		1-2
> > 	1-3	2-6		2-3		4-7		5-6
> > 	1-3	4-7		EINVAL
> > 	1-3	0-7		1-3		4-7		4-6
> > 
> > 			MPOL_PREFERRED
> > 			--------------
> > 	mems	nodemask	result		rebind		result
> > 	1-3	0		EINVAL
> > 	1-3	2		2		4-7		5
> > 	1-3	5		EINVAL
> > 
> > 			MPOL_BIND
> > 			---------
> > 	mems	nodemask	result		rebind		result
> > 	1-3	0-2		1-2		0-2		0-1
> > 	1-3	1-2		1-2		2-7		2-3
> > 	1-3	1-3		1-3		0-1		0-1
> > 	1-3	2-4		2-3		3-6		4-5
> > 	1-3	2-6		2-3		5		5
> > 	1-3	4-7		EINVAL
> > 	1-3	0-7		1-3		1-3		1-3
> 
> Just a note here:  If you had used the same set of "rebind targets" for
> _BIND as you did for _INTERLEAVE, I would expect the same results,
> because were just remapping bit masks in both cases.  Do you agree?
>  

Yes, the results are the same for both interleave and bind and that's 
actually why I didn't use the same rebind targets.

> >  [*] Notice how the resulting nodemask for all of these examples when
> >      creating the mempolicy is intersected with mems_allowed.  This is
> >      the current behavior, with contextualize_policy(), and is identical
> >      to the initial result of the MPOL_F_STATIC_NODES case.
> > 
> >      Perhaps it would make more sense to remap the nodemask when it is
> >      created, as well, in the ~MPOL_F_STATIC_NODES case.  For example, in
> >      this case, the "result" would be 1-3 instead.
> > 
> >      That is a departure from what is currently implemented in HEAD (and,
> >      thus, can be used as ample justification for the above behavior) but
> >      makes more sense.  Thoughts?
> 
> Thoughts:
> 
> 1) this IS a change in behavior, right?  My first inclination is to shy
> away from this.  However, ...
> 

Yes, it's the current behavior as a result of contextualize_policy() 
before mpol_new() is ever reached.

> 2) the current interaction of mempolicies with cpusets is not well
> documented--until Paul's cpuset.4 man page hits the streets, anyway.
> That doc does say that mempolicy is not allowed to use a node outside
> the cpuset.  It does NOT say how this is enforced--reject vs masking vs
> remap.  The set_mempolicy(2) and mbind(2) man pages [in at least 2.70
> man pages] says that you get EINVAL if you specify a node outside the
> current cpuset constraints.  This was relaxed by the recent patch to
> "silently restrict" the nodes to mems allowed.
> 
> Since we update the man pages anyway, we COULD change it to say that we
> remap policy to allowed nodes.  However, the application may have chosen
> the nodes based on some knowledge of hardware topology, such as IO
> attachement, interrupt handling cpus, ...  In this case, remapping
> doesn't make so much sense to me.  
> 
> If you need/want a mode that remaps policy to mems allowed on
> installation--e.g., to provide the maximum number of interleave
> nodes--how about yet another flag, such as '_REMAP, to effect this
> behavior?
> 

MPOL_F_RELATIVE_NODES actually does map onto and fold the passed nodemask 
when the mempolicy is created.  That flag specifically refers to relative 
nodes within a task's mems_allowed all the time; MPOL_F_STATIC_NODES 
refers specifically to physical node ids.

So adding MPOL_F_REMAP doesn't make sense for MPOL_F_RELATIVE_NODES since 
its already mapped onto and folded, and doesn't make sense for 
MPOL_F_STATIC_NODES since the nodemask is explicitly never remapped.

It would make sense as an optional third flag that would be disjoint from 
the other two and would only be useful when the mempolicy is created.

> > 			MPOL_INTERLEAVE | MPOL_F_STATIC_NODES
> > 			-------------------------------------
> > 	mems	nodemask	result		rebind		result
> > 	1-3	0-2		1-2		4-6		nil
> > 	1-3	1-2		1-2		0-2		1-2
> > 	1-3	1-3		1-3		4-7		nil
> > 	1-3	2-4		2-3		0-2		2
> > 	1-3	2-6		2-3		4-7		4-6
> > 	1-3	4-7		EINVAL
> > 	1-3	0-7		1-3		4-7		4-7
> 
> 'nil' falls back to local allocation, right?
> 

Yes, it's an interleave over no nodes and is thus a local allocation 
(current->il_next is numa_node_id()).

		David
