Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXD3KGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXD3KGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXD3KF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:05:59 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52042 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbXD3KF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:05:57 -0400
Date: Mon, 30 Apr 2007 15:35:35 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       list <linux-pm@lists.linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, pm@smtp2.linux-foundation.org
Subject: Re: [linux-pm] Re: 2.6.21-rc7-mm2 suspend bug. [kernel/kthread.c]
Message-ID: <20070430100535.GA30975@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <a8f16e2b0704291251l69c1b02ahb9b22370bc468fa1@mail.gmail.com> <200704292227.45215.rjw@sisk.pl> <20070430003946.b4d856b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430003946.b4d856b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:39:46AM -0700, Andrew Morton wrote:
> On Sun, 29 Apr 2007 22:27:44 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 29 April 2007 21:51, Dan Kruchinin wrote:
> > > Hi all.
> > > 
> > > There is a problem on my macbook core duo with suspend.
> > > after suspending when i'm trying to 'wake up' my notebook, it seems
> > > that it works, but i don't see anything at my monitor. So i have to
> > > reboot it to continue my work.
> > 
> > What exactly do you do to suspend?
> > 
> 
> This is due to _cpu_down() calling kthread_bind() in state TASK_RUNNING.

The state should be TASK_INTERRUPTIBLE. That's the state of the thread
'p' should be in when we do a kthread_bind(p) in _cpu_down().

Are you sure about the TASK_RUNNING part ?

> 
> So I was sent the below, including worrisome changelog.
> 

Ok, it should not be that worrisome!
By the time we would be doing kthread_stop(p) in _cpu_down(), 'p' would have
been moved over to some other online cpu, due to the migrate_dead_tasks() 
called in CPU_DEAD handling of migration_call (kernel/sched.c).

So we are safe. Anyway, I apologise for causing any worry :-)

Thanks and Regards
gautham.
> 
> 
> 
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> We are anyway kthread_stop()ping other per-cpu kernel threads after
> move_task_off_dead_cpu(), so we can do it with the stop_machine_run thread
> as well.
> 
> I just checked with Vatsa if there was any subtle reason why they
> had put in the kthread_bind() in cpu.c. Vatsa cannot seem to recollect
> any and I can't see any. So let us just remove the kthread_bind.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Oleg Nesterov <oleg@tv-sign.ru>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/cpu.c |    4 ----
>  1 files changed, 4 deletions(-)
> 
> diff -puN kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down kernel/cpu.c
> --- a/kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down
> +++ a/kernel/cpu.c
> @@ -175,10 +175,6 @@ static int _cpu_down(unsigned int cpu)
>  	/* This actually kills the CPU. */
>  	__cpu_die(cpu);
> 
> -	/* Move it here so it can run. */
> -	kthread_bind(p, get_cpu());
> -	put_cpu();
> -
>  	/* CPU is completely dead: tell everyone.  Too late to complain. */
>  	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) == NOTIFY_BAD)
>  		BUG();
> _
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
