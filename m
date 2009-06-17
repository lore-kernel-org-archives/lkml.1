Return-Path: <linux-kernel-owner+w=401wt.eu-S1765573AbZFQM3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765573AbZFQM3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933278AbZFQM26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:28:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765687AbZFQM25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:28:57 -0400
Date: Wed, 17 Jun 2009 14:23:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wait_task_zombie: do not use thread_group_cputime()
Message-ID: <20090617122352.GA4611@redhat.com>
References: <20090615212651.GA22759@redhat.com> <20090617101354.4100a910@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617101354.4100a910@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Stanislaw Gruszka wrote:
>
> On Mon, 15 Jun 2009 23:26:51 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > There is no reason for thread_group_cputime() in wait_task_zombie(),
> > there must be no other threads.
> >
> > This call was previously needed to collect the per-cpu data which
> > we do not have any longer.
>
> Is similar change for posix_cpu_timers_exit_group() correct and worthwhile ?
>
>  void posix_cpu_timers_exit_group(struct task_struct *tsk)
>  {
> -       struct task_cputime cputime;
> +       struct signal_struct *const sig = tsk->signal;
>
> -       thread_group_cputimer(tsk, &cputime);
>         cleanup_timers(tsk->signal->cpu_timers,
> -                      cputime.utime, cputime.stime, cputime.sum_exec_runtime);
> +                      cputime_add(tsk->utime, sig->utime),
> +                      cputime_add(tsk->stime, sig->stime),
> +                      tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
>  }

Yes, I think you are right.

And I think thread_group_cputimer() was never needed, it should be
thread_group_cputime(). Which in turn is not needed any longer too.

Please re-send with changelog/subject ?

Oleg.

