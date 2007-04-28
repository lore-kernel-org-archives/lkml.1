Return-Path: <linux-kernel-owner+w=401wt.eu-S1030495AbXD1BnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030495AbXD1BnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXD1BnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:43:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030495AbXD1BnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:43:21 -0400
Date: Fri, 27 Apr 2007 18:42:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1: BUG_ON in kthread_bind during _cpu_down
Message-Id: <20070427184258.62794053.akpm@linux-foundation.org>
In-Reply-To: <20070426125838.GC12892@in.ibm.com>
References: <200704260110.22224.rjw@sisk.pl>
	<20070425165410.b73443b4.akpm@linux-foundation.org>
	<20070426100922.GB12892@in.ibm.com>
	<20070426101547.GA97@tv-sign.ru>
	<20070426125838.GC12892@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 18:28:38 +0530
Gautham R Shenoy <ego@in.ibm.com> wrote:

> I just checked with Vatsa if there was any subtle reason why they
> had put in the kthread_bind() in cpu.c. Vatsa cannot seem to recollect
> any and I can't see any. So let us just remove the kthread_bind.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  kernel/cpu.c |    4 ----
>  1 files changed, 4 deletions(-)
> 
> Index: linux-2.6.21-rc7/kernel/cpu.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/cpu.c
> +++ linux-2.6.21-rc7/kernel/cpu.c
> @@ -176,10 +176,6 @@ static int _cpu_down(unsigned int cpu, i
>  	/* This actually kills the CPU. */
>  	__cpu_die(cpu);
>  
> -	/* Move it here so it can run. */
> -	kthread_bind(p, get_cpu());
> -	put_cpu();
> -
>  	/* CPU is completely dead: tell everyone.  Too late to complain. */
>  	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
>  				    hcpu) == NOTIFY_BAD)

So I cooked up a changelog and queued up the diff.  But I have an uneasy
feeling that things are getting a bit close to guesswork here.

We have a huge amount of change pending in the kthread/workqueue/freezer
area, partly because I decided not to merge most of the workqueue changes
into 2.6.21.

It'd be good if people could take some time to sit down and re-review the
code which we presently have.  I plan on sending it all off for 2.6.22 and
there might be some glitches but it seems to have a good track record so
far.

