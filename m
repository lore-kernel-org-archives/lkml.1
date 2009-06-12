Return-Path: <linux-kernel-owner+w=401wt.eu-S1764127AbZFLOGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764127AbZFLOGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZFLOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:06:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZFLOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:06:08 -0400
Date: Fri, 12 Jun 2009 16:00:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
Message-ID: <20090612140044.GB3784@redhat.com>
References: <20090612103412.3c490e3e@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612103412.3c490e3e@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Stanislaw Gruszka wrote:
>
> tasklist_lock is not needed to protect find_task_by_vpid() nor
> thread_group_leader()

It does protect thread_group_leader(), unless we use current.
Please see below.

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

Suppose that the non-main thread execs. de_thread() does

	attach_pid(tsk, PIDTYPE_PID, task_pid(leader));
	leader->group_leader = tsk;

under write_lock(tasklist). This means posix_cpu_timer_create() can return
-EINVAL if it is called in between, or if we found the group leader but
thread_group_leader() is called after "tsk->group_leader = tsk".

I think the patch is fine, but you should also replace thread_group_leader()
with has_group_leader_pid().



This reminds me. !CPUCLOCK_PERTHREAD timers survive after exec, but only
if ->group_leader execs. Not good.

Oleg.

