Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXDBLTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXDBLTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXDBLTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:19:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbXDBLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:19:20 -0400
Date: Mon, 2 Apr 2007 13:18:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402111828.GA14771@elte.hu>
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402092818.GE2456@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Mon, Apr 02, 2007 at 08:16:12AM +0200, Ingo Molnar wrote:
> > hm, shouldnt the make be frozen immediately?
> > 
> > doesnt the 'please freeze ASAP' flag get propagated to all tasks, 
> > immediately? After that point any cloning activity should duplicate 
> > that flag too, resulting in any new child freezing immediately too.
> 
> afaics, setting the 'please freeze asap' flag is racy wrt 
> dup_task_struct (where the child's tsk->thread_info->flags are copied 
> from its parent?). Secondly, from what I understand, it takes a 'flag 
> to be set + signal marked pending' for the child task to be frozen. If 
> that is the case, then copy_process may not propogae the signal to the 
> child, which could mean mean that we can be in a catch-up game in 
> freeze_processes, trying to freeze processes we didnt see in earlier 
> passes.
> 
> I think copy_process() can check for something like this:
> 
> 	write_lock_irq(&tasklist_lock);
> 
> 	...
> 
> 	if (freezing(current))
> 		freeze_process(p);	/* function exported by freezer */

yeah. (is that safe with tasklist_lock held?)

i'm wondering whether we could do even better than the signal approach. 
I _think_ the best approach would be to only wait for tasks that are _on 
the runqueue_. I.e. any task that has scheduled away with 
TASK_UNINTERRUPTIBLE (and might not be able to process signal events for 
a long time) is still freezable because it scheduled away.

the only freeze-unsafe task is one that is on the runqueue, executing 
some unknown kernel code. But the number of those is typically pretty 
low, even with very large make -j task-counts.

now, the current approach approximates that set of tasks, but not 
completely: in particular TASK_UNINTERRUPTIBLE sleeping threads can 
introduce arbitrary long delays (and hence freezing failures). [in 
addition to any fork-related 'leaks' of freeze-notification]

	Ingo
