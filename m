Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZKMJm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZKMJm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZKMJm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:42:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbZKMJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:42:25 -0500
Date: Fri, 13 Nov 2009 10:40:29 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix granularity of task_u/stime()
Message-ID: <20091113094028.GA2258@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB9029.9000208@jp.fujitsu.com> <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 06:12:41PM +0000, tip-bot for Hidetoshi Seto wrote:
> sched: Fix granularity of task_u/stime()
> 
> Originally task_s/utime() were designed to return clock_t but
> later changed to return cputime_t by following commit:
> 
>   commit efe567fc8281661524ffa75477a7c4ca9b466c63
>   Author: Christian Borntraeger <borntraeger@de.ibm.com>
>   Date:   Thu Aug 23 15:18:02 2007 +0200
> 
> It only changed the type of return value, but not the
> implementation. As the result the granularity of task_s/utime()
> is still that of clock_t, not that of cputime_t.
>
> So using task_s/utime() in __exit_signal() makes values
> accumulated to the signal struct to be rounded and coarse
> grained.
>
> This patch removes casts to clock_t in task_u/stime(), to keep
> granularity of cputime_t over the calculation.

Patch make only difference on 64 arch and do not fix the ordinal utime
decreasing problem on 32 bits. Anyway except below nit looks good
for me (but I to be honest I don't understand this {u/s}time adjusting
functions at all).

> -	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> +	p->prev_utime = max(p->prev_utime, utime);
>  	return p->prev_utime;
>  }
>  
>  cputime_t task_stime(struct task_struct *p)
>  {
> -	clock_t stime;
> +	cputime_t stime;
>  
>  	/*
>  	 * Use CFS's precise accounting. (we subtract utime from
>  	 * the total, to make sure the total observed by userspace
>  	 * grows monotonically - apps rely on that):
>  	 */
> -	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
> -			cputime_to_clock_t(task_utime(p));
> +	stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
>  
>  	if (stime >= 0)

Since cputime_t is not signed type, we should just remove this or
write something like that:

	runtime = nsecs_to_cputime(p->se.sum_exec_runtime);
	utime = task_utime(p);
	if (cputime_ge(runtime, utime))
		p->prev_stime = max(p->prev_stime, runtime - utime);

Stanislaw
