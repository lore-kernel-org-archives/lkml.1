Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbXHSI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbXHSI5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXHSI5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 04:57:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47684 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXHSI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 04:56:41 -0400
Date: Sun, 19 Aug 2007 12:57:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070819085707.GB83@tv-sign.ru>
References: <20070817222228.GA783@tv-sign.ru> <20070818115816.GA23555@hmsreliant.think-freely.org> <20070818125926.GA74@tv-sign.ru> <20070818185529.GA25372@hmsreliant.think-freely.org> <20070818190351.GA98@tv-sign.ru> <20070818232352.GA25994@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818232352.GA25994@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Neil Horman wrote:
>
> +static int proc_pid_limits(struct task_struct *task, char *buffer)
> +{
> +	unsigned int i;
> +	int count = 0;
> +	unsigned long flags;
> +	char *bufptr = buffer;
> +
> +	struct rlimit rlim[RLIM_NLIMITS];
> +
> +	rcu_read_lock();
> +	lock_task_sighand(task,&flags);
> +	if (task->signal == NULL){
> +		unlock_task_sighand(task, &flags);
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
> +	unlock_task_sighand(task, &flags);
> +	rcu_read_unlock();

No, no. If lock_task_sighand() fails, ->signal _should be_ == NULL, but the
"if (task->signal == NULL)" check is not reliable, we don't have any barriers
to serialize with __exit_signal().

More importantly, it is very wrong to do unlock_task_sighand() in that case,
this means NULL pointer dereference.

What we need is:

	rcu_read_lock();
	if (!lock_task_sighand(task, &flags)) {
		rcu_read_unlock();
		return 0;
	}
	memcpy(rlim, task->signal->rlim, sizeof(rlim));
	unlock_task_sighand(task, &flags);
	rcu_read_unlock();

No need to check ->signal != NULL if lock_task_sighand() succeeds.

Oleg.

