Return-Path: <linux-kernel-owner+w=401wt.eu-S1946086AbXBPTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946086AbXBPTqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946088AbXBPTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:46:40 -0500
Received: from mail.screens.ru ([213.234.233.54]:33118 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946086AbXBPTqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:46:39 -0500
Date: Fri, 16 Feb 2007 22:46:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216194605.GB192@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com> <20070216081209.GB2829@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216081209.GB2829@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> On Fri, Feb 16, 2007 at 12:46:17PM +0530, Srivatsa Vaddagiri wrote:
> > frozen. The only exception is cleaning up of per-cpu threads (which is
> > not possible with processes frozen - if we can find a way to make that
> > possible, then everything can be done in CPU_DEAD).
> 
> How abt a patch like below?
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

Instead, we can just clear PF_FROZEN before kthread_should_stop().
I don't claim this is better, but this way we don't need to add a
subtle change to process.c.

> This should let us do kthread_stop() in CPU_DEAD itself (while processes
> are frozen)? That would allow us to do everything from CPU_DEAD itself
> (and not have CPU_DEAD_KILL_THREADS).

... and probably avoid many races, good.

Oleg.

