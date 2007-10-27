Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbXJ0RqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbXJ0RqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXJ0RqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:46:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59358 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbXJ0RqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:46:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=hqjChP1HXl/NvH88WLIYO2tk4Exknb7ImWYy3eW9f5VdILaHdOrizOT46s8GzEMnw
	xSE0iv6OiYjzeeX8+negA==
Date: Sat, 27 Oct 2007 10:45:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071026180713.aeedfac2.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710262134180.24687@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost>
 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> Choice A:
>     as it does today, the second node in the tasks cpuset or it could
>     mean
> 
> Choice B:
>     the fourth node in the cpuset, if available, just as
>     it did in the case above involving a cpuset on nodes 10 and 11.
> 

Thanks for describing the situation with MPOL_PREFERRED so thoroughly.

I prefer Choice B because it does not force mempolicies to have any 
dependence on cpusets with regard to what nodemask is passed.

	[rientjes@xroads ~]$ man set_mempolicy | grep -i cpuset | wc -l
	0

It would be very good to store the passed nodemask to set_mempolicy in 
struct mempolicy, as you've already recommended for MPOL_INTERLEAVE, so 
that you can try to match the intent of the application as much as 
possible.  But since cpusets are built on top of mempolicies, I don't 
think there's any reason why we should respect any nodemask in terms of 
the current cpuset context, whether it's preferred or interleave.

So if you were to pass a nodemask with only the fourth node set for an 
MPOL_PREFERRED mempolicy, the correct behavior would be to prefer the 
fourth node on the system or, if constrained by cpusets, the fourth node 
in the cpuset.  If the cpuset has fewer than four nodes, the behavior 
should be undefined (probably implemented to just cycle the set of 
mems_allowed until you reach the fourth entry).  That's the result of 
constraining a task to a cpuset that obviously wants access to more
nodes -- it's a userspace mistake and abusing cpusets so that the task 
does not get what it expects.

That concept isn't actually new: we already restrict tasks to a certain 
amount of memory by writing to the mems file and just because it happens 
to have access to more memory when unconstrained by cpusets doesn't 
matter.  You've placed it in a cpuset that wasn't prepared to deal with 
what the task was asking for.  At least in the MPOL_PREFERRED case you 
describe above, it'll be dealt with much more pleasantly by at least 
giving it a preferred node as opposed to OOM killing it when a task has 
exhausted its available cpuset-constrained memory.

I'd prefer a solution where mempolicies can always be described and used 
without ever considering cpusets.  Then, a sane implementation will 
configure the cpuset accordingly to accomodate its tasks' mempolicies.  We 
don't want to get in a situation where we are denying a task to be 
attached to a cpuset when there are fewer nodes than the preferred node, 
for example, but we can fallback to better behavior by at least giving it 
a preferred node in the MPOL_PREFERRED case.

		David
