Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZC1LcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZC1LcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 07:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZC1LcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 07:32:07 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37692 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZC1LcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 07:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M1/K96xe/l1nLFm3OU540KKGQR+AYQqi9mB1ViqwKZHCV4fy56d/peu+LmJVmvGg5o
         PsaOn0uPktQtBFzO1v5SVDmy6fkLffg01q1tQF9ItU1HqWDbETgnWtE5HoyFjwPwjt/q
         58ZfEpglRjNeIkWeq76h9tjl0Udl3ETklOiIA=
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
In-Reply-To: <20090327172413.GC25762@redhat.com>
References: <20090327095525.A11052@sedona.ch.intel.com>
	 <20090327143435.GD14504@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
	 <20090327172413.GC25762@redhat.com>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 12:31:52 +0100
Message-Id: <1238239912.6036.0.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 18:24 +0100, Oleg Nesterov wrote:
> On 03/27, Metzger, Markus T wrote:
> >
> > >-----Original Message-----
> > >From: Oleg Nesterov [mailto:oleg@redhat.com]
> > >Sent: Friday, March 27, 2009 3:35 PM
> >
> > >> +static void ptrace_bts_exit(void)
> > >> +{
> > >> +	if (unlikely(!list_empty(&current->ptraced)))
> > >> +		ptrace_bts_exit_tracer();
> > >> +
> > >> +	if (unlikely(current->bts))
> > >> +		ptrace_bts_exit_tracee();
> > >> +}
> > >
> > >Could you explain why do we need ptrace_bts_exit_tracee() ?
> > >
> > >If current is traced, the tracer should do ptrace_bts_release()
> > >eventually, no?
> >
> > If current is traced and exits, it may be reaped by another thread that is not
> > the tracer (that's actually your example you made in an earlier thread to
> > describe the race between a normal detach and an exiting tracee).
> >
> > The ptrace_unlink() call to detach the tracer is executed with irq's disabled.
> > I need irq's enabled (see the other discussion, to wait for the traced task).
> 
> OK,
> 
> > Therefore, I have the tracee disable bts tracing itself when it exits.
> >
> >
> > >And if we really need to do ptrace_bts_exit_tracee(), then
> > >"if (unlikely(current->bts))" check is racy. The tracer
> > >can do PTRACE_BTS_CONFIG right after the check.
> >
> > The ptrace system call to do this would require the tracee to be stopped.
> 
> Yes, but this doesn't matter.
> 
> The tracer starts ptrace(PTRACE_BTS_CONFIG) and stops the tracee.
> But when the tracer calls ptrace_bts_config() the tracee can be already
> killed, and it can exit and bypass ptrace_bts_exit_tracee().

Could something like that work?

ds_release_bts(struct bts_tracer *tracer)
{
	struct task_struct *task =
		tracer->ds.context->task;

	do {
		set_task_state(task, TASK_UNINTERRUPTIBLE);
	while (!wait_task_inactive(task, TASK_UNINTERRUPTIBLE));

	ds_suspend_bts(tracer);
	ds_free_bts(tracer);

	wake_up_process(task);
}

I guess it would not work in general, since task could already sleep
on some event and be woken up after the do loop.

I was thinking it might work for the exit race, since we don't sleep
during exit, but it might have started sleeping before the SIGKILL.


Isn't this a general problem for ptrace?

Ptrace uses a similar pattern in ptrace_check_attach().
It stops the traced task, but that task might wake up immediately after
that check. It might be scheduled in any time during a ptrace operation.

In that case, must I always assume I'm operating on a running task?


regards,
markus.

