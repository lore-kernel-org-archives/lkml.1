Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbYB1XB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbYB1XB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYB1XBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:01:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567AbYB1XBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:01:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=aCvId45MTxSX0Yh88CYlkgowbKsy0n+j2T+gXcB1KOFLZssldzONnmZYHYnq8cV3M
	hkaw3vP0yk1CBIIDooCQA==
Date: Thu, 28 Feb 2008 15:00:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
In-Reply-To: <20080228164637.114fb19d.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com> <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com> <20080228113728.7b8e5811.pj@sgi.com> <alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com> <20080228164637.114fb19d.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Paul Jackson wrote:

> > How about moving watchdog/0 to a cpuset with exclusive access to only cpu 
> > 1?
> 
> I don't understand your question here.
> 

Move the watchdog/0 thread to a cpuset that doesn't have access to cpu 0.  

> > >     +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
> > >     +	    	     !cpus_subset(p->cpus_allowed, new_mask))) {
> > >     +		ret = -EINVAL;
> > > 
> > 
> > That's a convenient way for a kthread to temporarily expand its set of 
> > cpus_allowed and then never be able to remove the added cpus again.  Do 
> > you have any examples in the tree where a kthread does this?
> 
> Good question.  Actually, we -normally- have pinned tasks in the top cpuset,
> where the top cpuset allows all CPUs, but the pinned task has a cpus_allowed
> (in its task struct) of just one or a few CPUs (for node pinning.)
> 

Same situation occurs for a task bound to a cpuset that issues a 
sched_setaffinity() call to restrict its cpumask further.  There's nothing 
new there.

> So ... could we allow moving pinned threads to any cpuset that allowed
> the CPUs to which it was pinned (my cpus_subset() test, above), but
> -not- change the pinned tasks cpus_allowed in its task struct, keeping
> it pinned to just the same one or few CPUs?
> 

I'd hesitate to do that unless you can guarantee that restricting 
kthreads mems_allowed via the cpuset interface won't cause any problems 
either.  Is there a benefit to reducing the size of a kthread's 
mems_allowed that doesn't have an adverse effect on the kernel?  What 
about kswapd?

> I don't think that the cpus_equal() check prevents that (shrinking a
> pinned tasks cpuset out from under it.)  Try the following on a freshly
> booted system with your proposed patch:
> 
>   mkdir /dev/cpuset
>   mount -t cpuset cpuset /dev/cpuset
>   cd /dev/cpuset
>   mkdir a
>   cp ???s a
>   < tasks sed -un -e p -e 10q > a/tasks
> 
> I'll wager you just moved a few pinned tasks into cpuset 'a'.  This
> would be allowed, as 'a' has the same cpus as the top cpuset.  But then
> one could shrink a (if it had more than 1 CPU in the first place), leaving
> some pinned tasks in a cpuset they weren't allowed to run in, essentially
> unpinning them.
> 

You can move them, but you cannot reduce the size of the thread's 
cpus_allowed since it was bound to a specific cpu via kthread_bind().  The 
change to set_cpus_allowed() simply prevents this from happening in the 
kernel as opposed to just stopping the possibility through cpusets.

> > PF_CPU_BOUND follows the nomenclature of kthread_bind() really well, but 
> > it could probably be confused with a processor-bound task.  So perhaps 
> > PF_BOUND_CPU is even better?
> 
> Good point - "BOUND" as the past tense of "BIND".  How about
> PF_THREAD_BIND ;)?
> 

Sure.
