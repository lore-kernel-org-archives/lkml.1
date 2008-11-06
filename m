Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKFUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKFUIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYKFUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:07:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKFUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:07:59 -0500
Date: Thu, 6 Nov 2008 21:07:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] restore sched_exec load balance heuristics
Message-ID: <20081106200746.GA3578@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> We've seen long standing performance regression on sys_execve for several
> upstream kernels, largely on workload that does heavy execve.  The main
> reason for the regression was due to a change in sched_exec load balance
> heuristics.  For example, on 2.6.11 kernel, the "exec" task will run on
> the same cpu if that is the only task running.  However, 2.6.13 and onward
> kernels will go around the sched-domain looking for most idle CPU (which
> doesn't treat task exec'ing as an idle CPU).  Thus bouncing the exec'ing
> task all over the place which leads to poor CPU cache and numa locality.
> (The workload happens to share common data between subsequent exec program).
> 
> This execve heuristic was removed in upstream kernel by this git commit:
> 
> commit 68767a0ae428801649d510d9a65bb71feed44dd1
> Author: Nick Piggin <nickpiggin@yahoo.com.au>
> Date:   Sat Jun 25 14:57:20 2005 -0700
> 
> [PATCH] sched: schedstats update for balance on fork
> Add SCHEDSTAT statistics for sched-balance-fork.
> 
> >From the commit description, it appears that deleting the heuristics
> was an accident, as the commit is supposedly just for schedstats.
> 
> So, restore the sched-exec load balancing if exec'ing task is the only
> task running on that specific CPU.  The logic make sense: newly exec
> program should continue to run on current CPU as it doesn't change any
> load imbalance nor does it help anything by bouncing to another idle
> CPU. By keeping on the same CPU, it preserves cache and numa locality.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e8819bc..4ad1907 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2873,7 +2873,12 @@ out:
>   */
>  void sched_exec(void)
>  {
> -	int new_cpu, this_cpu = get_cpu();
> +	int new_cpu, this_cpu;
> +
> +	if (this_rq()->nr_running <= 1)
> +		return;
> +
> +	this_cpu = get_cpu();
>  	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
>  	put_cpu();
>  	if (new_cpu != this_cpu)

ok, this should be solved - but rather at the level of 
sched_balance_self(): it should never migrate this task over to 
another cpu, it should take away this task's load from the current 
CPU's load when considering migration.

	Ingo
