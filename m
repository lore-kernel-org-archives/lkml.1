Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZC0Vda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZC0Vda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZC0VdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:33:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZC0VdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:33:20 -0400
Date: Fri, 27 Mar 2009 22:29:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86, bts: fix crash
Message-ID: <20090327212933.GA5325@redhat.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com> <20090326015801.GA451@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com> <20090327165038.GA25762@redhat.com> <1238175204.6077.18.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238175204.6077.18.camel@raistlin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Markus Metzger wrote:
>
> Regarding the race on task->thread.ds_ctx between ds_release_bts() and
> ds_switch_to(), how would I prevent a task from being rescheduled for
> a small amount of time?

I don't see how we can do this. We can split wait_task_inactive() into
2 functions, the first one returns with task_rq_lock() held and interrupts
disabled. But this is nasty, and in any case wait_task_inactive(p) can't
force "p" to be deactivated.

Can't we do something different?

For simplicity, let's suppose that we have only task_struct->bts and it
is just a blob of memory which can be used by CPU somehow.

First, we add "struct rcu_head" into task_struct->bts, and then

	void free_bts((struct rcu_head *rcu)
	{
		struct bts_tracer *bts = container_of();
		...
		kfree(bts);
	}

	void ds_release_bts(struct bts_tracer *tracer)
	{
		struct task_struct *child = tracer->ds.context->task;
		struct bts_tracer *bts = child->bts;

		child->bts = NULL;

		// make sure child will NOT use ->bts
		// after the next context switch,
		// clear TIF_DS_AREA_MSR or something
		...

		call_rcu_sched(bts->rcu, free_bts);
	}

Now we can call ds_release_bts() from the atomic context (as we do
now).

Once again, the pseudo code above has nothing to do with reality,
just for illustration.

(as for the memory accounting, this is another issue, let's forget
 for now).

Oleg.

