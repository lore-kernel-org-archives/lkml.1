Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZDCLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZDCLcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761120AbZDCLci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:32:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912AbZDCLch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:32:37 -0400
Date: Fri, 3 Apr 2009 13:32:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 04/18] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090403113219.GF31399@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145709.422226000@intel.com> <20090402191730.GD843@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E92718054@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E92718054@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Thursday, April 02, 2009 9:18 PM
> >To: Metzger, Markus T
> >Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
> >eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
> >kernel@vger.kernel.org
> >Subject: Re: [patch 04/18] x86, bts: wait until traced task has been scheduled out
> >
> >
> >* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
> >
> >> In order to stop branch tracing for a running task, we need to
> >> first clear the branch tracing control bits before we may free the
> >> tracing buffer. If the traced task is running, the cpu might still
> >> trace that task after the branch trace control bits have cleared.
> >>
> >> Wait until the traced task has been scheduled out before
> >> proceeding.
> >>
> >> A similar problem affects the task debug store context. We first
> >> remove the context, then we need to wait until the task has been
> >> scheduled out before we can free the context memory.
> >>
> >>
> >> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> >> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> >> ---
> >>  arch/x86/kernel/ds.c |   40 	40 +	0 -	0 !
> >>  1 file changed, 40 insertions(+)
> >>
> >> Index: b/arch/x86/kernel/ds.c
> >> ===================================================================
> >> --- a/arch/x86/kernel/ds.c
> >> +++ b/arch/x86/kernel/ds.c
> >> @@ -250,6 +250,40 @@ static DEFINE_PER_CPU(struct ds_context
> >>  #define system_context per_cpu(system_context_array, smp_processor_id())
> >>
> >>
> >> +/*
> >> + * Wait for the traced task to unschedule.
> >> + *
> >> + * This guarantees that the bts trace configuration has been
> >> + * synchronized with the cpu executing the task.
> >> + */
> >> +static void wait_to_unschedule(struct task_struct *task)
> >> +{
> >
> >this should be in sched.c and task_is_running() should not be
> >exported from there.
> >
> >I.e. your original patch which i objected to is probably the right
> >one, but should be named something like "task_wait_context_switch()"
> >- which signals its purpose: that it is to wait for the task to
> >context-switch at least once, so that its ptrace state is installed
> >(or deinstalled) for sure.
> 
> OK.
> 
> I'll move it to sched.c.
> 
> In that case, I would use task_running() without holding the rq 
> lock, since we don't really care whether we read an old value or 
> not. Would that be OK with you?

i'd have to see that in full context - reading non-locked results 
can in essence result in stale old values being read out, regardless 
of current reality. task_running() is normally used within the rq 
lock.

	Ingo
