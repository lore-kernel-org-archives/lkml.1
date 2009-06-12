Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbZFLHLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbZFLHLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZFLHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:11:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZFLHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:11:36 -0400
Subject: Re: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090612084927.11673956@dhcp-lab-109.englab.brq.redhat.com>
References: <20090612084927.11673956@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 09:11:17 +0200
Message-Id: <1244790677.6691.959.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 08:49 +0200, Stanislaw Gruszka wrote:
> tasklist_lock is not needed to protect find_task_by_vpid() nor
> thread_group_leader() nor same_thread_group() , use rcu_read_lock() instead.

Aside from not being strictly needed, one can sometimes require a
tasklist_lock reader to ensure nothing changes, however since the code
is racy in that regard anyway, this looks good.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  kernel/posix-cpu-timers.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index bece7c0..1d9cdf3 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
>  	if (pid == 0)
>  		return 0;
>  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
>  		   same_thread_group(p, current) : thread_group_leader(p))) {
>  		error = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_lock();
>  
>  	return error;
>  }
> @@ -398,7 +398,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
>  	new_timer->it.cpu.incr.sched = 0;
>  	new_timer->it.cpu.expires.sched = 0;
>  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
>  		if (pid == 0) {
>  			p = current;
> @@ -422,7 +422,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
>  	} else {
>  		ret = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  
>  	return ret;
>  }

