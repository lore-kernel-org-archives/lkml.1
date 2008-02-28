Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbYB1VZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbYB1VZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYB1VZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:25:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25583 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYB1VZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:25:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=YJjkaqK9TGkcg+JEXDtP0dxoZ6Ai9AvKPqq9FIBTqPA8CU/5fwG2vdfIJiuLtSmoA
	XGA7hvHlw3v6vafcs+hSw==
Date: Thu, 28 Feb 2008 13:24:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
In-Reply-To: <20080228113728.7b8e5811.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com> <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com> <20080228113728.7b8e5811.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Paul Jackson wrote:

> I don't have strong opinions either way on this patch; it adds an error
> check that makes sense.  I haven't seen much problem not having this check,
> nor do I know of any code that depends on doing what this check prohibits.
> 

How about moving watchdog/0 to a cpuset with exclusive access to only cpu 
1?

> Except for three details:
> 
>  1) +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
>     +	    	     !cpus_equal(p->cpus_allowed, new_mask))) {
>     +		ret = -EINVAL;
> 
>     The check for equal cpus allowed seems too strong.  Shouldn't you be
>     checking that all of task p's cpus_allowed would still be allowed in
>     the new mask:
> 
>     +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
>     +	    	     !cpus_subset(p->cpus_allowed, new_mask))) {
>     +		ret = -EINVAL;
> 

That's a convenient way for a kthread to temporarily expand its set of 
cpus_allowed and then never be able to remove the added cpus again.  Do 
you have any examples in the tree where a kthread does this?

>  2) Doesn't this leave out a check for the flip side -- shrinking
>     the cpus allowed by a cpuset so that it no longer contains those
>     required by any PF_CPU_BOUND tasks in that cpuset?  I'm not sure
>     if this second check is a good idea or not.
> 

That's why the check in set_cpus_allowed() is

	cpus_equal(p->cpus_allowed, newmask)

since it prevents PF_CPU_BOUND tasks from being moved out of the root 
cpuset.

>  3) Could we call this PF_CPU_PINNED instead?  I tend to use "cpu
>     bound" to refer to tasks that consume alot of CPU cycles (which
>     these pinned tasks rarely do), and "pinned" to refer to what is
>     done to confine a task to a particular subset of all possible CPUs.
>     It looks to me like some code in kernel/sched.c already uses the
>     word pinned in this same way, so PF_CPU_PINNED would be more
>     consistent terminology.
> 

PF_CPU_BOUND follows the nomenclature of kthread_bind() really well, but 
it could probably be confused with a processor-bound task.  So perhaps 
PF_BOUND_CPU is even better?

		David
