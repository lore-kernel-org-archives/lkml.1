Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZIRVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZIRVST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZIRVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZIRVSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:18:14 -0400
Date: Fri, 18 Sep 2009 23:12:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fei <at.wufei@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090918211218.GA19351@redhat.com>
References: <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu> <20090918163241.GA8556@desktop> <20090918185425.GA16620@redhat.com> <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909181217270.4950@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Linus Torvalds wrote:
>
> On Fri, 18 Sep 2009, Oleg Nesterov wrote:
> > >  	rcu_scheduler_starting();
> > > -	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> > > -	numa_default_policy();
> > >  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> > >  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
> > > +	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
> >
> > We can't do this. kernel_init() should run with ->pid == 1, we are
> > going to exec /sbin/init.
>
> Umm - why not just add CLONE_PID to the 'kthreadd' creation, then?

Not sure I understand... We don't have CLONE_PID, and kthreadd()
shouldn't have pid == 0 anyway.

But this is not needed. We can do alloc_pid() before 'kthreadd' creation,
then free_pid() before kernel_thread(kernel_init).

However, I am not sure we should do something like this. The patch
I sent is very simple, in essence it is one-liner which only does

	-       wake_up_process(kthreadd_task);
	+	if (kthreadd_task)
	+		wake_up_process(kthreadd_task);

this way we should not worry about the ordering, kthread_create()
can be called at any time, even before kthreadd creation (not that
I think this is really useful though).


But personally I still can't understand what happens. If we were
preempted somewhere before "kthreadd_task = find_task_by_pid_ns()"
initialization, then schedule_debug() should complain? rest_init()
runs under preempt_disable().

Oleg.

