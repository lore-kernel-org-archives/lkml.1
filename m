Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZAVW3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZAVW3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZAVW3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:29:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZAVW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:29:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=HdCFIeekWR/cejLe5YRhIpYXF2+gzJAKBmSQWY8pBbks4MfPxZ4Kqj9ciAbpWiKrR
	KQuBxUJO6zxEFAiYSlUyw==
Date: Thu, 22 Jan 2009 14:28:11 -0800 (PST)
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
In-Reply-To: <20090122220446.GA1651@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901221415050.10427@chino.kir.corp.google.com>
References: <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com> <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net>
 <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net> <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com> <20090122210613.GA10158@ioremap.net> <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com>
 <20090122220446.GA1651@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Evgeniy Polyakov wrote:

> I showed the case when it does not work at all. And then found (in this
> mail), that task (part) has to be present in the memory, which means it
> will be locked, which in turns will not work with the system which
> already locked its range allowed by the limits.
> 

Yes, a userspace oom handler must be sanely implemented.

> And returning to the oom_adj and cpusets tunables. Why any new process
> started in given cpuset can not be tuned by external application or some
> script to have bigger/smaller oom_adj parameter? :)
> 

oom_adj scores are separate from the hard-coded and very fundamental 
heuristic that we should kill a task that has memory allocated on nodes we 
are attempting to free.  Anything else would just be stupid.

> > How do I prioritize oom killing if my system is running cpusets, then?  
> 
> Just the way it works right now :)
> You do not object against patches which improve superh cpu support
> with the argument, that it is not possible to enable that feature,
> when system does not have superh cpu.
> 

No, I object against any patch that isn't a complete solution to the 
problem being presented.  It's purely a matter of good software 
engineering practices and in the interest of a long-term maintainable 
kernel.

> > The userspace handler is a schedulable task resident in memory that, with 
> > any sane implementation, would not require additional memory when running.
> 
> And what happens when it can not lock the memory because of the limits?
> 

Any sane handler for responding to oom conditions will not require 
additional memory from nodes that are under oom, whether that includes all 
system memory or a subset, if it is attached to the oom notifier.

> Hmm, you likely missed the part in the last line. And in the first two,
> where I said that before oom-killer started (and killed some processes,
> usually not those which were need, but its a different story). System
> just did not have a free memory to have _any_ progress neither in atomic
> context, nor in process, so it had to invoke an oom-killer.
> 

The page allocator cannot invoke the oom killer in atomic context, so this 
would be happening in process content where it can sleep.  The userspace 
oom handler will wake up, handle the condition either by relaxing hardwall 
restrictions for either the memory controller or cpusets, or killing a 
task itself unless it chooses to defer to the kernel.

> In that case userspace just can not reply or even awake. While kernel is
> effectively alive if it does not need to allocate a memory. And could
> kill some process to free up the ram.
> 

Wrong, oom conditions do not preempt task scheduling.

> Userspace notifications are great, no problem, but do not rely on them,
> since there is a huge world outside the case it works in, which will be
> quite unhappy when systems start freezing because oom-killer relied on
> the userspace.
> 

I'm quite certain you've spent more time writing emails to me than merging 
the patch and testing its possibilities, given your lack of understanding 
of its very basic concepts.
