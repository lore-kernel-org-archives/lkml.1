Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbZC0QyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbZC0QyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbZC0QyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:54:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZC0QyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:54:08 -0400
Date: Fri, 27 Mar 2009 17:50:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>
Subject: Re: [rfc] x86, bts: fix crash
Message-ID: <20090327165038.GA25762@redhat.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com> <20090326015801.GA451@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Metzger, Markus T wrote:
>
> >> @@ -752,6 +752,14 @@ void ds_release_bts(struct bts_tracer *t
> >>
> >>  	ds_suspend_bts(tracer);
> >>
> >> +	/*
> >> +	 * We must wait for the suspend to take effect before we may
> >> +	 * free the tracer and the ds configuration.
> >> +	 */
> >> +	if (tracer->ds.context->task &&
> >> +	    (tracer->ds.context->task != current))
> >> +		wait_task_inactive(tracer->ds.context->task, 0);
> >
> >I am not sure I understand the problem. From the changelog:
> >
> >	If the children are currently executing, the buffer
> >	may be freed while the hardware is still tracing.
> >	This might cause the hardware to overwrite memory.
> >
> >So, the problem is that ds.context->task must not be running before we
> >can start to disable/free ds, yes? Something like ds_switch_to() should
> >be completed, right?
> >
> >In that case I don't really understand how wait_task_inactive() can help.
> >If the task is killed it can be scheduled again, right after
> >wait_task_inactive() returns.
>
> We first call ds_suspend_bts().
> This clears the branch tracing control bits for the traced task and already
> writes the updated value to the msr, if running on the current cpu.
> If the task is running on a different cpu, the updated value will be written
> when the task is scheduled out.
> By waiting for the task to become inactive, we know that it has been scheduled out
> at least once after we changed the bits. So we know that the hardware will not use
> the tracing configuration for that task and we can safely free the memory.

Still can't understand...

Let's suppose the traced task is scheduled again, right after
wait_task_inactive() returns a before we set ds.context->bts_master = NULL.

In this case, can't ds_switch_to() (which plays with ds_context) race
with ds_put_context()->kfree(context) ?

> >Also. This function is called from ptrace_bts_exit_tracer(), when the
> >tracee is not stopped. In this case wait_task_inactive() can spin forever.
> >For example, if the tracee simply does "for (;;) ;" it never succeeds.
>
> As far as I understand, wait_task_inactive() returns when the task is scheduled out.

Yes. But the task does above is never scheduled out, it is always running
even if preempted by another task. wait_task_inactive() returns when
->on_rq == 0, iow when the task sleeps.

This means that the tracer can hang "forever" during exit, until the tracee
does the blocking syscall or exits.

This is not acceptable, imho.

Oleg.

