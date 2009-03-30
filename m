Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZC3B0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZC3B0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZC3B0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:26:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZC3B0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:26:38 -0400
Date: Mon, 30 Mar 2009 03:22:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
Message-ID: <20090330012204.GA2058@redhat.com>
References: <20090327095525.A11052@sedona.ch.intel.com> <20090327143435.GD14504@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com> <20090327172413.GC25762@redhat.com> <1238239912.6036.0.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238239912.6036.0.camel@raistlin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Markus Metzger wrote:
>
> ds_release_bts(struct bts_tracer *tracer)
> {
> 	struct task_struct *task =
> 		tracer->ds.context->task;
>
> 	do {
> 		set_task_state(task, TASK_UNINTERRUPTIBLE);

Oh, this is not right,

> 	while (!wait_task_inactive(task, TASK_UNINTERRUPTIBLE));

and can't help to wait_task_inactive(). Again, unless this task
does a blocking call wait_task_inactive() can't force this task
to be deactivated. Even we set TASK_UNINTERRUPTIBLE.

> 	ds_suspend_bts(tracer);
> 	ds_free_bts(tracer);
>
> 	wake_up_process(task);

makes it TASK_RUNNING. This can't restores the proper ->state
if it was not running (say, TASK_STOPPED).

> }
>
> I guess it would not work in general, since task could already sleep
> on some event and be woken up after the do loop.

This too,

> I was thinking it might work for the exit race, since we don't sleep
> during exit,

We do. In the context of bts problems, we don't care if the task sleeps
after _free_tracee(). But this task can have tracees too, it can in turn
sleep in wait_task_inactive().

> Isn't this a general problem for ptrace?
>
> Ptrace uses a similar pattern in ptrace_check_attach().
> It stops the traced task, but that task might wake up immediately after
> that check. It might be scheduled in any time during a ptrace operation.

Yes. ptrace() can assume the tracee is TASK_TRACED, or it is dying/dead.

If you need to make sure it is still traced, you can re-check ->state
under ->siglock. Until you drop this lock, the tracee (if still traced)
can't escape from ptrace_stop/do_signal_stop, even if scheduled.

Oleg.

