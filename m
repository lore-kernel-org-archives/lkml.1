Return-Path: <linux-kernel-owner+w=401wt.eu-S1946090AbXDEKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946090AbXDEKyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946096AbXDEKyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:54:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:53222 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946090AbXDEKyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:54:12 -0400
Date: Thu, 5 Apr 2007 14:53:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070405105356.GA713@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053824.GC12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Gautham R Shenoy wrote:
>
> +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> +		thaw_processes(FE_HOTPLUG_CPU);
> +		return -EBUSY;
> +	}

Off-topic. This is a common pattern. Perhaps it makes sense to
introduce a try_to_freeze_or_thaw_and_return_an_error() helper.

> @@ -161,10 +141,13 @@ static int _cpu_down(unsigned int cpu)
>  					    hcpu) == NOTIFY_BAD)
>  			BUG();
>
> -		if (IS_ERR(p)) {
> +		set_cpus_allowed(current, old_allowed);
> +
> +		if (IS_ERR(p))
>  			err = PTR_ERR(p);
> -			goto out_allowed;
> -		}
> +		else
> +			err = kthread_stop(p);
> +
>  		goto out_thread;
>  	}

Why this change? We are doing kthread_stop() + set_cpus_allowed() on
return. Imho,

		if (IS_ERR(p))
			goto out_allowed;
		goto out_thread;

looks a bit better. Yes we need a couple of error labels at the end.

> --- linux-2.6.21-rc5.orig/kernel/softlockup.c
> +++ linux-2.6.21-rc5/kernel/softlockup.c
> @@ -147,6 +147,7 @@ cpu_callback(struct notifier_block *nfb,
>  	case CPU_DEAD:
>  		p = per_cpu(watchdog_task, hotcpu);
>  		per_cpu(watchdog_task, hotcpu) = NULL;
> +		thaw_process(p);
>  		kthread_stop(p);

As it was already discussed, this is racy. As Srivatsa (imho rightly)
suggested, kthread_stop(p) should thaw process itself. This also allows
us to kill at least some of wait_for_die loops.

However, the change in kthread_stop(p) in not enough to close the race.
We can check kthread_should_stop() in refrigerator(), this looks like
a most simple approach for now.

Alternatively, Srivatsa suggests to introduce a new task_lock() protected
task_struct->freezer_state (so we can reliably set FE_ALL). Surely this is
more poweful, but needs more changes. I am not sure. Perhaps we can do
this later.

In any case, imho "try3" should add thaw_process() to kthread_stop().
Gautham, Srivatsa, do you agree?

Oleg.

