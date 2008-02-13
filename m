Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbYBMV6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbYBMV6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbYBMVgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:36:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765214AbYBMVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:36:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=vbQGSLAExzgfB6jBLgcHf3gybyA5NTiXAGSB879gnA14K8rMf7dZjm4F4RJE1gL5l
	qUPOG4KitggvqjekKrR5w==
Date: Wed, 13 Feb 2008 13:35:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080213142956.5ba52101.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802131314210.5914@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com> <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com> <20080213020344.45c9d924.pj@sgi.com>
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com> <20080213110426.15179378.pj@sgi.com> <alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com> <20080213142956.5ba52101.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Paul Jackson wrote:

> Yes, if an application considers nodes to be interchangeable, I'm
> trying to avoid having that application -have- to know its current
> cpuset placement, for two reasons:
> 
>     For one thing, it's racey.  It's cpuset placement could change,
>     unbeknownst to it, between the time it queried it, and the time
>     that it issued the mbind or set_mempolicy call.
> 
>     For the other thing, it's not always possible.  If the application
>     is currently in a cpuset that is smaller than it's preferred
>     configuration, it would not be possible to express its preferred
>     memory policies using just the smaller number of memory nodes
>     allowed by its current cpuset placement.  How do you say "put
>     this on my third node" if you don't have a third node and you
>     can only speak of the nodes you currently have?
> 

So let's say, like my first example from the previous email, that you have 
MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES over nodes 3-4 and your cpuset's 
mems is only nodes 5-7.  This would interleave over no nodes.  Correct?

It seems like MPOL_F_RELATIVE_NODES is primarily designed to maintain a 
certain order among the nodes it effects the mempolicy over.  It comes 
with the premise that the task doesn't already know it's cpuset mems 
(otherwise, the current implementation without MPOL_F_STATIC_NODES would 
work fine for this) so it doesn't really care what nodes it allocates 
pages on, it just cares about the order.

This works for MPOL_PREFERRED and MPOL_BIND as well, right?

I don't understand the use case for this (at all), but if you have 
workloads that require this type of setting then I can implement this as 
part of my series.  I just want to confirm that there are real world cases 
backing this so that we don't have flags with highly highly specialized 
cornercases.

 [ If a user _does_ specify MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES
   as part of their syscall, then we'll simply return -EINVAL. ]

> > Well, I didn't cave on anything 
> 
> ;)   Your simple "ok" was ambiguous enough that we were able to
>      read into it whatever we wanted to.
> 
> But I've made my case on that issue (involving the separate or
> packed policy flag field).  So I probably won't say more, and
> I expect to live with whatever you choose, after any further
> input from Lee or others.
> 

Well, there's advantages and disadvantages to either approach.

My preference (both mode and flags stored in the same member of struct 
mempolicy):

   Advantages:

	- completely consistent with the userspace API of passing modes
	  and flags together in a pointer to an int, and

	- does not require additional formals to be added to several
	  functions, including functions outside mm/mempolicy.c.

   Disadvantage:

	- use of mpol_mode() throughout mm/mempolicy.c code to mask
	  off optional mode flags for conditionals or switch statements.

Your preference (separate mode and flags members in struct mempolicy):

   Advantages:

	- clearer implementation when dealing with modes: all existing
	  statements involving pol->policy can remain unchanged.

   Disadvantages:

	- requires additional formals to be added to several functions,
	  including functions outside mm/mempolicy.c, and

	- takes additional space in struct mempolicy (two bytes) which
	  could eventually be used for something else.

In both cases the testing of mode flags is the same as before:

	if (pol->policy & MPOL_F_STATIC_NODES) {
		...
	}
