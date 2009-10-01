Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZJATP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZJATP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZJATP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:15:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbZJATP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:15:56 -0400
Date: Thu, 1 Oct 2009 21:15:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
Message-ID: <20091001191515.GB24158@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu> <4AC4FC47.4010405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC4FC47.4010405@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 10/01/2009 08:48 PM, Ingo Molnar wrote:
>> We could do what Avi suggested: not use scheduler classes at all for
>> this (that brings in other limitations like lack of p->policy freedom),
>> but use the existing preempt-notifications callbacks.
>>
>> They are per task - we would simply make preempt notifiers 
>> unconditional, i.e. remove CONFIG_PREEMPT_NOTIFIERS and make it all 
>> unconditional scheduler logic.
>
> Sure, but it would mean that we need a new notifier.  sched_out, 
> sched_in, and wakeup (and, return to userspace, with the new 
> notifier).

perf events have sched out, sched in and wakeup events. Return to 
user-space would be interesting to add as well. (and overhead of that 
can be hidden via TIF - like you did via the return-to-userspace 
notifiers)

Sounds more generally useful (and less scary) than (clever but somewhat 
limiting) sched_class hackery.

I.e. i'd prefer if we had just one callback facility in those codepaths, 
minimizing the hotpath overhead and providing a coherent API.

> btw, I've been thinking we should extend concurrency managed 
> workqueues to userspace.  Right now userspace can spawn a massive 
> amount of threads, hoping to hide any waiting by making more work 
> available to the scheduler.  That has the drawback of increasing 
> latency due to involuntary preemption.  Or userspace can use one 
> thread per cpu, hope it's the only application on the machine, and go 
> all-aio.
>
> But what if we added a way for userspace to tell the kernel to fork 
> off threads when processing power and work to do are both available?  
> The scheduler knows when there is processing power, and an epoll fd 
> can tell it when there is work to do.  So the scheduler will create 
> threads to saturate the processors, if one of them waits for I/O the 
> scheduler forks off another one until all queues are busy again.

Sounds like syslets done right?

	Ingo
