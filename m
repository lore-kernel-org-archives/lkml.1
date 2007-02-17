Return-Path: <linux-kernel-owner+w=401wt.eu-S965029AbXBQFeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbXBQFeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 00:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBQFeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 00:34:17 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:61072 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029AbXBQFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 00:34:16 -0500
Date: Sat, 17 Feb 2007 11:02:33 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070217053233.GA22435@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216081209.GB2829@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:42:09PM +0530, Srivatsa Vaddagiri wrote:
> On Fri, Feb 16, 2007 at 12:46:17PM +0530, Srivatsa Vaddagiri wrote:
> > frozen. The only exception is cleaning up of per-cpu threads (which is
> > not possible with processes frozen - if we can find a way to make that
> > possible, then everything can be done in CPU_DEAD).
> 
> How abt a patch like below?
> 
> 
> --- process.c.org	2007-02-16 13:38:39.000000000 +0530
> +++ process.c	2007-02-16 13:38:59.000000000 +0530
> @@ -47,7 +47,7 @@ void refrigerator(void)
>  	recalc_sigpending(); /* We sent fake signal, clean it up */
>  	spin_unlock_irq(&current->sighand->siglock);
> 
> -	while (frozen(current)) {
> +	while (frozen(current) && !kthread_should_stop()) {
>  		current->state = TASK_UNINTERRUPTIBLE;
>  		schedule();
>  	}

This looks ok, but probably we could do it in a better way.
How about an api to thaw only a specific task something like
thaw_process(struct task_struct p). 

That way, the CPU_DEAD handler which wants to kthread_stop a thread
can selectively thaw the thread before it does kthread_stop.

Rafael, does this have any negative impact on the freezer design?

> This should let us do kthread_stop() in CPU_DEAD itself (while processes
> are frozen)? That would allow us to do everything from CPU_DEAD itself
> (and not have CPU_DEAD_KILL_THREADS).
> 
> 
> -- 
> Regards,
> vatsa

thanks
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
