Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXDRTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXDRTl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXDRTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:41:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbXDRTlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:41:25 -0400
Date: Wed, 18 Apr 2007 12:40:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418175936.GA11980@elte.hu>
Message-ID: <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
References: <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org>
 <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org>
 <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org>
 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Ingo Molnar wrote:
> 
> perhaps a more fitting term would be 'precise group-scheduling'. Within 
> the lowest level task group entity (be that thread group or uid group, 
> etc.) 'precise scheduling' is equivalent to 'fairness'.

Yes. Absolutely. Except I think that at least if you're going to name 
somethign "complete" (or "perfect" or "precise"), you should also admit 
that groups can be hierarchical.

The "threads in a process" thing is a great example of a hierarchical 
group. Imagine if X was running as a collection of threads - then each 
server thread would no longer be more important than the clients! But if 
you have a mix of "bags of threads" and "single process" kind 
applications, then very arguably the single thread in a single traditional 
process should get as much time as the "bag of threads" process gets 
total.

So it really should be a hierarchical notion, where each thread is owned 
by one "process", and each process is owned by one "user", and each user 
is in one "virtual machine" - there's at least three different levels to 
this, and you'd want to schedule this thing top-down: virtual machines 
should be given CPU time "fairly" (which doesn't need to mean "equally", 
of course - nice-values could very well work at that level too), and then 
within each virtual machine users or "scheduling groups" should be 
scheduled fairly, and then within each scheduling group the processes 
should be scheduled, and within each process threads should equally get 
their fair share at _that_ level.

And no, I don't think we necessarily need to do something quite that 
elaborate. But I think that's the kind of "obviously good goal" to keep in 
mind. Can we perhaps _approximate_ something like that by other means? 

For example, maybe we can approximate it by spreading out the statistics: 
right now you have things like

 - last_ran, wait_runtime, sum_wait_runtime..

be per-thread things. Maybe some of those can be spread out, so that you 
put a part of them in the "struct vm_struct" thing (to approximate 
processes), part of them in the "struct user" struct (to approximate the 
user-level thing), and part of it in a per-container thing for when/if we 
support that kind of thing?

IOW, I don't think the scheduling "groups" have to be explicit boxes or 
anything like that. I suspect you can make do with just heurstics that 
penalize the same "struct user" and "struct vm_struct" to get overly much 
scheduling time, and you'll get the same _effect_. 

And I don't think it's wrong to look at the "one hundred processes by the 
same user" case as being an important case. But it should not be the 
*only* case or even necessarily the *main* case that matters. I think a 
benchmark that literally does

	pid_t pid = fork();
	if (pid < 0)
		exit(1);
	if (pid) {
		if (setuid(500) < 0)
			exit(2);
		for (;;)
			/* Do nothing */;
	}
	if (setuid(501) < 0)
		exit(3);
	fork();
	for (;;)
		/* Do nothing in two processes */;

and I think that it's a really valid benchmark: if the scheduler gives 25% 
of time to each of the two processes of user 501, and 50% to user 500, 
then THAT is a good scheduler.

If somebody wants to actually write and test the above as a test-script, 
and add it to a collection of scheduler tests, I think that could be a 
good thing.

		Linus
