Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZC0Rdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZC0Rdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZC0Rdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:33:37 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36861 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZC0Rdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zks+V3KOgSOL5+rsUTB0SnRABTlqz3aP4REYMDSJ7eVySuMHshk5X7jiXgDmmeliwZ
         UAn8cHA21kRqlzEHSdccKlITcVGx8/b3Nnh51w/8Vw4lsvx1SgS13+z8MDftzPqswUsg
         dpnUyHtD9ELBwn/JjLowGEtV0xaNiF6849qC0=
Subject: Re: [rfc] x86, bts: fix crash
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090327165038.GA25762@redhat.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
	 <20090326015801.GA451@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
	 <20090327165038.GA25762@redhat.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 18:33:24 +0100
Message-Id: <1238175204.6077.18.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 17:50 +0100, Oleg Nesterov wrote:
> On 03/27, Metzger, Markus T wrote:
> >
> > >> @@ -752,6 +752,14 @@ void ds_release_bts(struct bts_tracer *t
> > >>
> > >>  	ds_suspend_bts(tracer);
> > >>
> > >> +	/*
> > >> +	 * We must wait for the suspend to take effect before we may
> > >> +	 * free the tracer and the ds configuration.
> > >> +	 */
> > >> +	if (tracer->ds.context->task &&
> > >> +	    (tracer->ds.context->task != current))
> > >> +		wait_task_inactive(tracer->ds.context->task, 0);
> > >
> > >I am not sure I understand the problem. From the changelog:
> > >
> > >	If the children are currently executing, the buffer
> > >	may be freed while the hardware is still tracing.
> > >	This might cause the hardware to overwrite memory.
> > >
> > >So, the problem is that ds.context->task must not be running before we
> > >can start to disable/free ds, yes? Something like ds_switch_to() should
> > >be completed, right?
> > >
> > >In that case I don't really understand how wait_task_inactive() can help.
> > >If the task is killed it can be scheduled again, right after
> > >wait_task_inactive() returns.
> >
> > We first call ds_suspend_bts().
> > This clears the branch tracing control bits for the traced task and already
> > writes the updated value to the msr, if running on the current cpu.
> > If the task is running on a different cpu, the updated value will be written
> > when the task is scheduled out.
> > By waiting for the task to become inactive, we know that it has been scheduled out
> > at least once after we changed the bits. So we know that the hardware will not use
> > the tracing configuration for that task and we can safely free the memory.
> 
> Still can't understand...
> 
> Let's suppose the traced task is scheduled again, right after
> wait_task_inactive() returns a before we set ds.context->bts_master = NULL.
> 
> In this case, can't ds_switch_to() (which plays with ds_context) race
> with ds_put_context()->kfree(context) ?


You're right. Now I see the problem.

The bts_master pointer needs to be set to NULL while the traced task is
off the cpu.

The kfree will only happen if the context is not used. If another tracer
immediately reuses the context and traces the same task, it will
become the new master and overwrite the configuration. 

I assumed that the traced task would always be stopped, since that's
the ptrace scenario. But it's not true for disable, which may be called
by an exiting tracer while the tracee is running.

I would still require it for ds_request_bts_task(), though. I will add
a comment regarding this.

Regarding the race on task->thread.ds_ctx between ds_release_bts() and
ds_switch_to(), how would I prevent a task from being rescheduled for
a small amount of time?


> > >Also. This function is called from ptrace_bts_exit_tracer(), when the
> > >tracee is not stopped. In this case wait_task_inactive() can spin forever.
> > >For example, if the tracee simply does "for (;;) ;" it never succeeds.
> >
> > As far as I understand, wait_task_inactive() returns when the task is scheduled out.
> 
> Yes. But the task does above is never scheduled out, it is always running
> even if preempted by another task. wait_task_inactive() returns when
> ->on_rq == 0, iow when the task sleeps.

Oops.


> This means that the tracer can hang "forever" during exit, until the tracee
> does the blocking syscall or exits.
> 
> This is not acceptable, imho.

Definitely not.


What I would need here (see above) is to get the traced task off any cpu
in order to clear the bts_master pointer.
Is there some existing function that I could use?
Could you point me to some code that does something similar?

thanks,
markus.

