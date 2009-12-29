Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZL2MQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZL2MQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZL2MQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:16:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZL2MQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:16:15 -0500
Subject: Re: [RFC 12/12][PATCH] SCHED_DEADLINE: modified sched_*_ex API
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255708086.6228.469.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708086.6228.469.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 13:15:09 +0100
Message-ID: <1262088909.7135.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:48 +0200, Raistlin wrote:
> This commit amends the new API introduced to deal with the new sched_param_ex
> scheduling parameter data structure.
> 
> What we add is one more parameter to all the functions, containing the size of
> sched_param_ex. It might turn out useful in possible future extensions of
> sched_param_ex itself, to avoid issue with ABI of legacy applications.
> 
> Signed-off-by: Raistlin <raistlin@linux.it>

> @@ -6807,9 +6811,10 @@ out_unlock:
>  /**
>   * sys_sched_getparam - get the DEADLINE task parameters of a thread
>   * @pid: the pid in question.
> + * @len: size of data pointed by param_ex.
>   * @param_ex: structure containing the new parameters (deadline, runtime, etc.).
>   */
> -SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> +SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
>  		struct sched_param_ex __user *, param_ex)
>  {
>  	struct sched_param_ex lp;
> @@ -6818,6 +6823,8 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
>  
>  	if (!param_ex || pid < 0)
>  		return -EINVAL;
> +	if (len < sizeof(struct sched_param_ex))
> +		return -EINVAL;
>  
>  	read_lock(&tasklist_lock);
>  	p = find_process_by_pid(pid);
> @@ -6837,7 +6844,7 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
>  	/*
>  	 * This one might sleep, we cannot do it with a spinlock held ...
>  	 */
> -	retval = copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT : 0;
> +	retval = copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
>  
>  	return retval;
>  

I think this doesn't even do what it claims to do, namely provide a
flexible ABI, since you fail the operation when there is not enough room
provided. Hence, when we grow the struct an older program that was
compiled against the smaller one will become an insta-fail.

What this should do is deal with smaller structs by ensuring the tail is
0 and simply copying out the head.

New bits in the flags field are also an interesting challenge.

