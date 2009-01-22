Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZAVUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZAVUai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZAVUa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:30:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZAVUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:30:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=yCsxJSDqfbt8mB/mb223/IxrpcKJ8azQu8hLLsLi7qLNxReoe+OIbCnZhiYfEQ5GF
	CqaY3Z/h+ukKQaCig+Kaw==
Date: Thu, 22 Jan 2009 12:28:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090122132133.GA17524@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
 <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Evgeniy Polyakov wrote:

> > Of course, because the oom killer must be aware that tasks in disjoint 
> > cpusets are more likely than not to result in no memory freeing for 
> > current's subsequent allocations.
> 
> And if we replace cpuset with cgroup (or anything else), nothing
> changes, so why this was made so special?
> 

I don't know what you're talking about, cpusets are simply a client of the 
cgroup interface.

The problem that I'm identifying with this change is that the 
user-specified priority (in terms of oom.victim settings) conflicts when 
the kernel encounters a system-wide unconstrained oom versus a 
cpuset-constrained oom.

The oom.victim priority may well be valid for a system-wide condition 
where a specific aggregate of tasks are less critical than others and 
would be preferred to be killed.  But that doesn't help in a 
cpuset-constrained oom on the same machine if it doesn't lead to future 
memory freeing.

Cpusets are special in this regard because the oom killer's heuristics in 
this case are based on a function of the oom triggering task, current.  We 
check for tasks sharing current->mems_allowed so that we are freeing 
memory that the task can eventually use.  So this new oom cgroup cannot be 
used on any machine with one or more cpusets that may oom without the 
possibility of needlessly killing tasks.

> Having userspace to decide which task to kill may not work in some cases
> at all (when task is swapped and we need to kill someone to get the mem
> to swap out the task, which will make that decision).
> 

Yes, and it's always possible for userspace to defer back to the kernel in 
such cases.  But in the majority of cases that you seem to be interested 
in, this type of notification system seems like it would work quite well:

 - to replace your oom_victim patch, your userspace handler could simply
   issue a SIGKILL to the chosen job in place of the oom killer.  The 
   added benefit here is that your userspace handler could actually 
   support a prioritized list so if one application isn't running, it
   could check another, and another, etc., and

 - to replace this oom.victim patch, the userspace handler could check
   for the presence of the aggregate of tasks that would have appeared
   attached to the new cgroup and issue the same SIGKILL.

> +			/* If we're planning to retry, we should wake
> +			 * up any userspace waiter in order to let it
> +			 * handle the OOM
> +			 */
> +			wake_up_all(&cs->oom_wait);
> 
> You must be kidding :)
> If by the 'userspace' you do not mean special kernel thread, but in
> this case there is no difference compared to existing in-kernel code.
> 

That wakes up any userspace notifier that you've attached to the cgroup 
representing the tasks you're interested in controlling oom responses for.  
Your userspace application can then effectively take the place of the oom 
killer by expanding a cpuset's memory, elevating a memory controller 
reservation, killing current, or using its own heuristics to respond to 
the problem.

But we should probably discuss the implementation of the per-cgroup oom 
notifier in the thread dedicated to it, not this one.

> At OOM time there is no userspace. We can not wakeup anyone or send (and
> expect it will be received) some notification. The only alive entity in
> the system is the kernel, who has to decide who must be killed based on
> some data provided by administrator (or by default with some
> heuristics).
> 

This is completely and utterly wrong.  If you had read the code 
thoroughly, you would see that the page allocation is deferred until 
userspace has the opportunity to respond.  That time in deferral isn't 
absurd, it would take time for the oom killer's exiting task to free 
memory anyway.  The change simply allows a delay between a page 
allocation failure and invoking the oom killer.

It will even work on UP systems since the page allocator has multiple 
reschedule points where a dedicated or monitoring application attached to 
the cgroup could add or free memory itself so the allocation succeeds when 
current is rescheduled.
