Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXDTVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXDTVMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXDTVMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:12:40 -0400
Received: from mail.screens.ru ([213.234.233.54]:39355 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbXDTVMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:12:39 -0400
Date: Sat, 21 Apr 2007 01:12:09 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070420211209.GA820@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419120419.GB17069@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Gautham R Shenoy wrote:
>
> @@ -63,12 +74,16 @@ void refrigerator(void)
>  	recalc_sigpending(); /* We sent fake signal, clean it up */
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> +	task_lock(current);
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  		if (!frozen(current))
>  			break;
> +		task_unlock(current);
>  		schedule();
> +		task_lock(current);
>  	}
> +	task_unlock(current);
>  	pr_debug("%s left refrigerator\n", current->comm);
>  	current->state = save;

Just curious, why this change?

> +int hold_freezer_for_task(struct task_struct *p)
> +{
> +	int ret = 0;
> +	spin_lock(&freezer_status.lock);
> +	if (freezer_status.count >= 0)
> +	{
> +		set_tsk_thread_flag(p, TIF_FREEZER_HELD);
> +		thaw_process(p);
> +		freezer_status.count++;
> +		ret = 1;
> +	}
> +	spin_unlock(&freezer_status.lock);
> +
> +	return ret;
> +}

I think this can work if it is used only in kthread_stop(). But what if
another task wants to do hold_freezer_for_task(p) ? freezer_status.count
is recursive, but TIF_FREEZER_HELD is not. IOW, I believe this is not
generic enough.

Also, you are planning to add different freezing states (FE_HOTPLUG_CPU,
FE_SUSPEND, etc). In that case each of them needs a separate .count, because
it should be negative when try_to_freeze_tasks() returns. Now consider
the case when we are doing freeze_processes(FE_A | FE_B) ...

Oleg.

