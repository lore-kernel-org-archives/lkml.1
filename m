Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbZAVWxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbZAVWxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZAVWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:53:07 -0500
Received: from cs-studio.ru ([195.178.208.66]:59420 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817AbZAVWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:53:06 -0500
Date: Fri, 23 Jan 2009 01:53:04 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090122225304.GA3551@ioremap.net>
References: <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net> <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com> <20090122210613.GA10158@ioremap.net> <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com> <20090122220446.GA1651@ioremap.net> <alpine.DEB.2.00.0901221415050.10427@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901221415050.10427@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 02:28:11PM -0800, David Rientjes (rientjes@google.com) wrote:
> > And returning to the oom_adj and cpusets tunables. Why any new process
> > started in given cpuset can not be tuned by external application or some
> > script to have bigger/smaller oom_adj parameter? :)
> 
> oom_adj scores are separate from the hard-coded and very fundamental 
> heuristic that we should kill a task that has memory allocated on nodes we 
> are attempting to free.  Anything else would just be stupid.

The right answer is that oom-adj scores are global, while it is required
in some cases to have local groups processes can be arranged into so
that local tunables could be used. cpusets just happend to be those
groups, while it could be in turn wider cgroups with the proposed
or similar patch.

Or those groups could be processes started with special name :)
It just happend that cpusets were the first, so you can say,
that they are so special, while actually they are not.

We already have this, and history does not tolerate conjunctives,
so let's drop this part :)

> No, I object against any patch that isn't a complete solution to the 
> problem being presented.  It's purely a matter of good software 
> engineering practices and in the interest of a long-term maintainable 
> kernel.

Is this double standards, since your proposal, if implemented a
little bit different, does not solve the problem at all. And you argue
that uncomplete solution should not be merged. Please note, that I do
not object against notifications, but just want to have a system which
will work in all cases or at least in the majority of them.

> > > The userspace handler is a schedulable task resident in memory that, with 
> > > any sane implementation, would not require additional memory when running.
> > 
> > And what happens when it can not lock the memory because of the limits?
> 
> Any sane handler for responding to oom conditions will not require 
> additional memory from nodes that are under oom, whether that includes all 
> system memory or a subset, if it is attached to the oom notifier.

This reminds me a thread, where modporbe stuck because initrd code is
actually not allowed to write something to the console, and while it
happend that bug is somewhere else, the same argument was rised about
such fun limitations. What about just asking userspace developers not to
write a code, which may lead to OOM conditions :)

Even not arguing 'sane implementation' case, what about process which
happend to be in swap? Its oom handler has to be locked in the memory to
be sucessfully invoked, but this does not work if all allowed to be
locked memory is used.

> > Hmm, you likely missed the part in the last line. And in the first two,
> > where I said that before oom-killer started (and killed some processes,
> > usually not those which were need, but its a different story). System
> > just did not have a free memory to have _any_ progress neither in atomic
> > context, nor in process, so it had to invoke an oom-killer.
> > 
> 
> The page allocator cannot invoke the oom killer in atomic context, so this 
> would be happening in process content where it can sleep.  The userspace 
> oom handler will wake up, handle the condition either by relaxing hardwall 
> restrictions for either the memory controller or cpusets, or killing a 
> task itself unless it chooses to defer to the kernel.

Seems like you just do not read what I wrote. Please do. At least the
last sentence :) And what I wrote about swapped and locked memory.

> > In that case userspace just can not reply or even awake. While kernel is
> > effectively alive if it does not need to allocate a memory. And could
> > kill some process to free up the ram.
> 
> Wrong, oom conditions do not preempt task scheduling.

I actually did not tell anything about task scheduling.

I said that in the case above, if oom-killer would depend on the
userspace it could not make a progress, since oom-handlers would
not be able to wake up if swapped, and in this case oom-killer
would need just to select one by its own hueristics.

> > Userspace notifications are great, no problem, but do not rely on them,
> > since there is a huge world outside the case it works in, which will be
> > quite unhappy when systems start freezing because oom-killer relied on
> > the userspace.
> 
> I'm quite certain you've spent more time writing emails to me than merging 
> the patch and testing its possibilities, given your lack of understanding 
> of its very basic concepts.

How cute :)
Any other technical arguments of the same strength?

-- 
	Evgeniy Polyakov
