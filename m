Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZIRTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZIRTA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZIRTAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZIRTAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:00:22 -0400
Date: Fri, 18 Sep 2009 20:54:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Wu Fei <at.wufei@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090918185425.GA16620@redhat.com>
References: <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918163241.GA8556@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19, Wu Fei wrote:
>
> On Fri, Sep 04, 2009 at 09:37:49AM +0200, Ingo Molnar wrote:
> >
> > Lets delay this until i can debug it more fully.
> >
> CONFIG_PREEMPT_VOLUNTARY looks like the key of this problem,
> might_resched becomes _cond_resched, and since d86ee480 changes
> it not to check SYSTEM_RUNNING,

... and should_resched() is true under preempt_disable()

> --- a/init/main.c
> +++ b/init/main.c
> @@ -452,10 +452,10 @@ static noinline void __init_refok rest_init(void)
>  	int pid;
>
>  	rcu_scheduler_starting();
> -	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> -	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
> +	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);

We can't do this. kernel_init() should run with ->pid == 1, we are
going to exec /sbin/init.

Oleg.

