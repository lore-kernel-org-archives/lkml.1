Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbXJZD6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbXJZD6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXJZD6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:58:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXJZD6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:58:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mGbXGvrV42rcd8DpnX8G16JxFDoMgYNZYWRBBFwatBQ/QFORbGBG1YhRr3IvGA5KT
	Ixobv0UZi+UuNKHtR8NWg==
Date: Thu, 25 Oct 2007 20:58:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071025201455.acb4e72c.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <20071025192945.82962eea.pj@sgi.com> <alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
 <20071025201455.acb4e72c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Paul Jackson wrote:

> The user space man pages for set_mempolicy(2) are now even more
> behind the curve, by not mentioning that MPOL_INTERLEAVE's mask
> might mean nothing, if (1) in a cpuset marked memory_spread_user,
> (2) after the cpuset has changed 'mems'.
> 

Yeah.  They were already outdated in the sense that they did not specify 
that the interleave nodemask could change as a result of a cpuset mems 
change.

> I wonder if there is any way to fix that.  Who does the man pages
> for Linux system calls?
> 

Good question.

> Hmmm ... that reminds me ... the period of time between when the
> task issues the set_mempolicy(2) MPOL_INTERLEAVE call and when some
> cpuset 'mems' change subsequently moves its memory placement is an
> anomaly here. During that period of time, the MPOL_INTERLEAVE mask
> -does- apply, even if a subset of the 'mems' in the tasks cpuset.
> This could result in test cases missing some failures.  If they
> test with a particular, carefully crafted MPOL_INTERLEAVE mask
> that is a proper (strictly less than) subset of the nodes allowed
> in the cpuset, they might not notice that their code is broken if
> they happen to be in a memory_spread_user cpuset after a 'mems'
> change has jammed the entire cpusets 'mems' into their interleave
> mask.
> 

Well, sure, but mempolicy's already get overridden by cpusets anyway.  For 
example, if you were to attach a task with an MPOL_BIND mempolicy to a 
cpuset with a disjoint set of allowed mems.

The important distinction is that you can still interleave over a subset 
of the mems_allowed if you set your memory policy after being attached to 
the cpuset.

> Perhaps we should make it so that doing a set_mempolicy(2) call
> to set MPOL_INTERLEAVE immediately changes the memory policy to
> the cpusets mems_allowed.
> 

No, because that would negate the above.  We still want to be able to 
restrict interleaved memory policies to a subset of allowed mems.  This 
option gives the most power to applications.

> A key advantage in doing this would be that the set_mempolicy user
> documentation could simply state that the MPOL_INTERLEAVE mask is
> ignored when in a cpuset marked memory_spread_user, instead interleaving
> over all the memory nodes in the cpuset.  This would be quite a bit
> simpler and clearer than saying that the cpusets nodes are used only
> after subsequent cpuset 'mems' changes.
> 

I think that documenting the change in the man page as saying that "the 
nodemask will include all allowed nodes if the mems_allowed of a 
memory_spread_user cpuset is expanded" is better.

I've got a few fixes for my patchset queued so I'll resend it later; it's 
mostly style changes but there is a subtle bug where the task changing the 
value of a cpuset's memory_spread_page is not in the same cpuset.

		David
