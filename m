Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZAVWE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZAVWE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZAVWEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:04:48 -0500
Received: from cs-studio.ru ([195.178.208.66]:56001 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZAVWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:04:48 -0500
Date: Fri, 23 Jan 2009 01:04:46 +0300
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
Message-ID: <20090122220446.GA1651@ioremap.net>
References: <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com> <20090122095026.GA10579@ioremap.net> <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com> <20090122101424.GA12317@ioremap.net> <alpine.DEB.2.00.0901220218120.2851@chino.kir.corp.google.com> <20090122132133.GA17524@ioremap.net> <alpine.DEB.2.00.0901221216330.2085@chino.kir.corp.google.com> <20090122210613.GA10158@ioremap.net> <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901221314010.6145@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 01:35:13PM -0800, David Rientjes (rientjes@google.com) wrote:
> > And that is The Main Point. Not to help some subsystem, but be useful
> > for others. It is different tunable. It has really nothing with cpusets.
> 
> It doesn't work with any system that is running with cpusets, that's the 
> problem with accepting such code.  There needs to be clear and convincing 
> evidence that a userspace oom notifier, which could handle all possible 
> cases and is much more robust and flexible, would not suffice for such 
> situations.

I showed the case when it does not work at all. And then found (in this
mail), that task (part) has to be present in the memory, which means it
will be locked, which in turns will not work with the system which
already locked its range allowed by the limits.

And returning to the oom_adj and cpusets tunables. Why any new process
started in given cpuset can not be tuned by external application or some
script to have bigger/smaller oom_adj parameter? :)

> > Then do not use anything else when cpusets are enabled.
> > Do not compile SuperH cpu support when you do not have such processes.
> > Do not enable iscsi support if you do not need this.
> > Do not enable cgroup oom-killer tunable when you want cpuset.
> > 
> 
> How do I prioritize oom killing if my system is running cpusets, then?  

Just the way it works right now :)
You do not object against patches which improve superh cpu support
with the argument, that it is not possible to enable that feature,
when system does not have superh cpu.

> Your answer is that I can't, since this new cgroup doesn't work with them; 
> so this solution is incomplete.  The oom killer notification patch[*] is 
> much more functional and does allow this problem to be solved on all types 
> of systems because the implementation of such a handler is left to the 
> administrator.
> 
>  [*] http://marc.info/?l=linux-mm&m=122575082227252

Let me draw the line in this discussion: people propose a patches to tweak
the oom-killer behaviour in some situation. You say that this does not
cover another case, and thus has to be dropped. You instead propose
another solution, which does not work either in some cases (IMO more
wider).

It may be a good idea, and likely it is (at least its notification
part), but please look a bit wider, since in cases when it does not work,
still there are lots of systems which want to have a proper OOM tunables.

> > Please explain, how task will make that decision (like freeing some
> > ram), when it can not be even swapped out? It is a great idea to be able
> > to monitor memory usage, but relying on that just does not work.
> > 
> 
> The userspace handler is a schedulable task resident in memory that, with 
> any sane implementation, would not require additional memory when running.

And what happens when it can not lock the memory because of the limits?

> > Yup, it will wait for some timeout while userspace will respond. The
> > problem is that it will not in some cases. And so far I think (and I may
> > be wrong), that it will not be able to respond most of the time.
> > 
> 
> We've used it quite successfully for over a year, so your hypothesis in 
> this case may be less than accurate.

You also used oom_adj which was not documented. Is this an argument?

> > In every oom-condition I worked with, system was completely unusable
> > before oom-killer started to berserk several processes. They were not
> > able to allocate some data to read network input (atomic context) and to
> > even read a console input.
> > 
> 
> If your system failed to allocate GFP_ATOMIC memory, then those are page 
> allocation failures in the buddy allocator and will actually never invoke 
> the oom killer since it cannot sleep in that context.

Hmm, you likely missed the part in the last line. And in the first two,
where I said that before oom-killer started (and killed some processes,
usually not those which were need, but its a different story). System
just did not have a free memory to have _any_ progress neither in atomic
context, nor in process, so it had to invoke an oom-killer.

In that case userspace just can not reply or even awake. While kernel is
effectively alive if it does not need to allocate a memory. And could
kill some process to free up the ram.

Userspace notifications are great, no problem, but do not rely on them,
since there is a huge world outside the case it works in, which will be
quite unhappy when systems start freezing because oom-killer relied on
the userspace.

-- 
	Evgeniy Polyakov
