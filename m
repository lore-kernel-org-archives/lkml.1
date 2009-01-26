Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZAZWfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZAZWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZAZWez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:34:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52072 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZAZWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:34:54 -0500
Date: Mon, 26 Jan 2009 23:31:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126223145.GA4982@redhat.com>
References: <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126214516.GA22142@elte.hu> <20090126140116.35f9c173.akpm@linux-foundation.org> <20090126220537.GA6755@elte.hu> <20090126141605.707877bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126141605.707877bb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Andrew Morton wrote:
>
> On Mon, 26 Jan 2009 23:05:37 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
> >
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > Well it turns out that I was having a less-than-usually-senile moment:
> > >
> > > :     implement flush_work()
> >
> > > Why isn't that working in this case??
> >
> > how would that work in this case? We defer processing into the workqueue 
> > exactly because we want its per-CPU properties.
>
> It detaches the work item, moves it to head-of-queue, reinserts it then
> waits on it.  I think.

No, no helper works this way.

The reinsert doesn't make sense for cancel_work.

As for flush_work(), I think it is possible to do, but can't help to
avoid the deadlocks. Because we still have to wait for ->current_work.

> This might have a race+hole.  If a currently-running "unrelated"
> work item tries to take the lock which the flush_work() caller is holding
> then there's no way in which keventd will come back to execute
> the work item which we just put on the head of queue.

Yes.

> > We want work_on_cpu() to
> > be done in the workqueue context on the CPUs that were specified, not in
> > the local CPU context.
>
> flush_work() is supposed to work in the way which you describe.

Yes,

> But Oleg's "we may be running on a different CPU" comment has me all
> confused.

I meant, that

	> the caller of flush_work() can detach the work item
	> and run it directly.

this is not possible in work_on_cpu() case, we can't run it directly,
we want it to run on the target CPU.

Oleg.

