Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXHTRCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXHTRCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760433AbXHTRCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:02:00 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35725 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbXHTRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:01:59 -0400
Message-ID: <46C9C8D4.9080108@linux.vnet.ibm.com>
Date: Mon, 20 Aug 2007 22:31:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com> <20070802120427.270e5589.akpm@linux-foundation.org> <20070819213435.72b287ad@localhost.localdomain>
In-Reply-To: <20070819213435.72b287ad@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
> TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats,
> not the basic and extended accounting. With this patch,
> TASKSTATS_CMD_ATTR_TGID returns also the min, max or sum (depending on
> the semantic of the field) of the accounting info for all threads of a
> thread group. This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
> fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
> (http://guichaz.free.fr/misc/iotop.py).
> 
> Changelog since V1 (http://lkml.org/lkml/2007/8/2/185):
> - Update combined stats of exited threads in fill_tgid_exit() as
> suggested by Balbir Singh.
> - Very light cleanup of fill_tgid_exit() by the way.
> - bacct fields are also combined for all threads.
> - Instead of assuming memory stats are identical for all threads, we
> take the max of all threads (hiwater_rss and hiwater_vm).
> 
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Jay Lan <jlan@engr.sgi.com>
> Cc: Jonathan Lim <jlim@sgi.com>
> ---
> 
>  kernel/taskstats.c |   15 ++++++++++-----
>  kernel/tsacct.c    |   43 ++++++++++++++++++++++---------------------
>  2 files changed, 32 insertions(+), 26 deletions(-)
> 
> diff -r 73eff559debc kernel/taskstats.c
> --- a/kernel/taskstats.c	Sat Aug 18 17:15:17 2007 -0700
> +++ b/kernel/taskstats.c	Sun Aug 19 17:20:15 2007 +0200
> @@ -246,6 +246,8 @@ static int fill_tgid(pid_t tgid, struct 
> 
>  		stats->nvcsw += tsk->nvcsw;
>  		stats->nivcsw += tsk->nivcsw;
> +		bacct_add_tsk(stats, tsk);
> +		xacct_add_tsk(stats, tsk);

I'm afraid this is still not good enough. bacct_add_tsk() will assign
values and do nothing in the loop (HINT: no summation). Ideally,
we should split up bacct_add_tsk(), so that the initialization
code is split up from values that can summed.

>  	} while_each_thread(first, tsk);
> 
>  	unlock_task_sighand(first, &flags);
> @@ -265,21 +267,24 @@ static void fill_tgid_exit(struct task_s
>  static void fill_tgid_exit(struct task_struct *tsk)
>  {
>  	unsigned long flags;
> +	struct taskstats *tg_stats;
> 
>  	spin_lock_irqsave(&tsk->sighand->siglock, flags);
> -	if (!tsk->signal->stats)
> +	tg_stats = tsk->signal->stats;
> +	if (!tg_stats)
>  		goto ret;
> 
>  	/*
>  	 * Each accounting subsystem calls its functions here to
>  	 * accumalate its per-task stats for tsk, into the per-tgid structure
>  	 *
> -	 *	per-task-foo(tsk->signal->stats, tsk);
> -	 */
> -	delayacct_add_tsk(tsk->signal->stats, tsk);
> +	 *	per-task-foo(tg_stats, tsk);
> +	 */
> +	bacct_add_tsk(tg_stats, tsk);

Ditto.. see above

> +	xacct_add_tsk(tg_stats, tsk);
> +	delayacct_add_tsk(tg_stats, tsk);
>  ret:
>  	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
> -	return;
>  }
> 
>  static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
> diff -r 73eff559debc kernel/tsacct.c
> --- a/kernel/tsacct.c	Sat Aug 18 17:15:17 2007 -0700
> +++ b/kernel/tsacct.c	Sun Aug 19 17:20:43 2007 +0200
> @@ -38,8 +38,9 @@ void bacct_add_tsk(struct taskstats *sta
>  	/* rebase elapsed time to usec */
>  	ac_etime = timespec_to_ns(&ts);
>  	do_div(ac_etime, NSEC_PER_USEC);
> -	stats->ac_etime = ac_etime;
> -	stats->ac_btime = get_seconds() - ts.tv_sec;
> +	stats->ac_etime = max_t(u64, stats->ac_etime, ac_etime);
> +	stats->ac_btime = min_t(u32, stats->ac_btime,
> +				get_seconds() - ts.tv_sec);

I am not sure why we get the max value, ideally we should
be summing up utime, stime into the stats structure.


Could you please write a simple test case and ensure that the
summed up stats are indeed correct for TGID's?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
