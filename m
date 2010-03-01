Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0CAPkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:40:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0CAPkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:40:12 -0500
Date: Mon, 1 Mar 2010 16:37:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
Message-ID: <20100301153750.GA11090@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228141135.GB5495@redhat.com> <4B8BD822.1010402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BD822.1010402@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/02, Tejun Heo wrote:
>
> > and more importantly, if it was possible
> > stop_machine_cpu_callback(CPU_POST_DEAD) (which is called after
> > cpu_hotplug_done()) could race with stop_machine().
> > stop_machine_cpu_callback(CPU_POST_DEAD) relies on fact that this
> > thread has already called schedule() and it can't be woken until
> > kthread_stop() sets ->should_stop.
>
> Hmmm... I'm probably missing something but I don't see how
> stop_machine_cpu_callback(CPU_POST_DEAD) depends on stop_cpu() thread
> already parked in schedule().  Can you elaborate a bit?

Suppose that, when stop_machine_cpu_callback(CPU_POST_DEAD) is called,
that stop_cpu() thread T is still running and it is going to check state
before schedule().

CPU_POST_DEAD is called after cpu_hotplug_done(), another CPU can do
stop_machine() and set STOPMACHINE_PREPARE.

If T sees state == STOPMACHINE_PREPARE it will join the game, but it
wasn't counted in thread_ack counter, it is not cpu-bound, etc.

> >>  int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
> >>  {
> >> ...
> >>  	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
> >>  	 * doesn't hit this CPU until we're ready. */
> >>  	get_cpu();
> >> +	for_each_online_cpu(i)
> >> +		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));
> >
> > I think the comment is wrong, and we need preempt_disable() instead
> > of get_cpu(). We shouldn't worry about this CPU, but we need to ensure
> > the woken real-time thread can't preempt us until we wake up them all.
>
> get_cpu() and preempt_disable() are exactly the same thing, aren't
> they?

Yes,

> Do you think get_cpu() is wrong there for some reason?

No. I think that the comment is confusing, and preempt_disable()
"looks" more correct.


In any case, this is very minor, please ignore. In fact, I mentioned
this only because this email was much longer initially, at first I
thought I noticed the bug, but I was wrong ;)

Oleg.

