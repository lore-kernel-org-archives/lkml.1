Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbZFQOHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbZFQOHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZFQOHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:07:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbZFQOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:07:33 -0400
Date: Wed, 17 Jun 2009 16:02:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_cpu_timers_exit_group: do not use
	thread_group_cputimer()
Message-ID: <20090617140205.GA8632@redhat.com>
References: <20090617153637.3342988c@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617153637.3342988c@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Stanislaw Gruszka wrote:
>
> When the process exits we don't have to run new cputimer nor use running one
> (as it not accounts when tsk->exit_state != 0) to get process CPU times.
> As there is only one thread we can just use CPU times fields form task
> and signal structs.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  kernel/posix-cpu-timers.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index bece7c0..e33a21c 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -521,11 +521,12 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
>  }
>  void posix_cpu_timers_exit_group(struct task_struct *tsk)
>  {
> -	struct task_cputime cputime;
> +	struct signal_struct *const sig = tsk->signal;
>
> -	thread_group_cputimer(tsk, &cputime);
>  	cleanup_timers(tsk->signal->cpu_timers,
> -		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
> +		       cputime_add(tsk->utime, sig->utime),
> +		       cputime_add(tsk->stime, sig->stime),
> +		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
>  }

I think this is correct.

Oleg.

