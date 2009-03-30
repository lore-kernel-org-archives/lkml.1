Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZC3NdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZC3NdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZC3Nci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:32:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZC3Nch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:32:37 -0400
Date: Mon, 30 Mar 2009 15:29:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
Subject: Re: [rfc] x86, bts: fix crash
Message-ID: <20090330132904.GA2822@redhat.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com> <20090326015801.GA451@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com> <20090327165038.GA25762@redhat.com> <1238175204.6077.18.camel@raistlin> <20090327212933.GA5325@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B8F1@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77E9266BB48@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9266BB48@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Metzger, Markus T wrote:
>
> >The benefit would be that I don't need to hook into do_exit() anymore.

Metzger, I got lost ;) And I didn't sleep today, so most probably I missed
what you mean...

do you mean the helper below will be called under write_lock_irq(tasklist)?
In that case,

> >This would rid us of the nasty ->ptraced loop.
> >I will give it a try.
> >
> >
> >I use something like this to wait for the context switch:
> >  nvcsw = task->nvcsw + 1;
> >  nivcsw = task->nivcsw + 1;
> >  for (;;) {
> >	if (nvcsw < task->nvcsw)
> >		break;
> >	if (nivcsw < task->nivcsw)
> >		break;

Not exactly right, schedule() increments nvcsw/nivcsw before context_switch().
But this is fixable.

However. What if this task spins in TASK_RUNNING waiting for tasklist_lock ?
This is deadlockable even with CONFIG_PREEMPT, we take tasklit for reading
in interrupt context.

Afaics, we can also deadlock if task_cpu(task) sends IPI to us (with wait = 1),
the sender spins with preemption disabled.

> >	if (task->state != TASK_RUNNING)
> >		break;
> >  }
> >
>
> That is not quite right, as well. There's a race on the task state.
> In my example, I got TASK_DEAD before the dying task could complete its
> final schedule(), and the cpu continued tracing.

But we still have the same problems.

If the tracee doesn't call a blocking syscall, its ->state is always RUNNING.

It could be woken right after we see !TASK_RUNNING or !task_running().

Oleg.

