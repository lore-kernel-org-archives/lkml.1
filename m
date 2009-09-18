Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZIRQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZIRQct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZIRQcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:32:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:29749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZIRQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TDIFEIXx3+gNQcMQVkdmrmimxusCs1Nd0wk3BWGuYanAAM79KI5lLHl0swqSEj8mN/
         v2CdzKv+M1/fRhjuMJsCAkrDX1c8xRnsdB1rMLKhJ+pTNZgF0zFCNMGzd6XdzEq4oIlk
         cYvMO63vezWgVHjmeCrlvlPZsn6WgQA731iwM=
Date: Sat, 19 Sep 2009 00:32:41 +0800
From: Wu Fei <at.wufei@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090918163241.GA8556@desktop>
References: <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com> <20090904073749.GB20598@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904073749.GB20598@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 09:37:49AM +0200, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > On 09/01, Eric W. Biederman wrote:
> > >
> > > Oleg Nesterov <oleg@redhat.com> writes:
> > >
> > > > On 09/01, Oleg Nesterov wrote:
> > > >>
> > > >> On 09/01, Ingo Molnar wrote:
> > > >> >
> > > >> > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > >> >
> > > >> > > On 09/01, Ingo Molnar wrote:
> > > >> > > >
> > > >> > > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > >> > > >
> > > >> > > > > Yes, this should work. But I _think_ we can make the better fix...
> > > >> > > > >
> > > >> > > > > I'll try to make the patch soon. Afaics we don't need
> > > >> > > > > kthreadd_task_init_done.
> > > >> > > >
> > > >> > > > ok.
> > > >> > >
> > > >> > > Just in case, the patch is ready. [...]
> > > >> >
> > > >> > yes - that's roughly the cleanup i referred to in the commit log.
> > > >> >
> > > >> > way too late for -rc8 though - the minimal fix i did _might_ be
> > > >> > eligible.
> > > >> >
> > > >> > agreed?
> > > >>
> > > >> Agreed. Then I will sent the patch on top of this change.
> > > >
> > > > OK, I am sending the patch on top of your fix. Not sure how to really
> > > > test it, but at least the kernel works when I apply the debugging patch
> > > > below on top.
> > >
> > > Stupid question.  How is it that we wind up trying to start kernel threads
> > > before it is safe to do so?
> > >
> > > Races should be impossible because the scheduler isn't running until a few
> > > lines later.
> > 
> > Yes, I am confused too.
> > 
> > At first I thought I understand the race, now I don't. Please see 
> > the whole thread: http://marc.info/?t=125180592500005
> 
> I dont understand it either - and the .config being !SMP excludes 
> any sort of SMP race as well.
> 
> Lets delay this until i can debug it more fully.
> 
CONFIG_PREEMPT_VOLUNTARY looks like the key of this problem,
might_resched becomes _cond_resched, and since d86ee480 changes 
it not to check SYSTEM_RUNNING, this function may call schedule().
And might_resched may be called even from do_fork(), so this is a
scenario:

kernel_thread(kernel_init, ...)
pid = kernel_thread(kthreadd, ...)
	-- switch to thread kernel_init, which refers to  kthreadd_task
           and NULL reference happens.  Note, because of
	   !CONFIG_LOCK_KERNEL,  lock_kernel() is nop.

What about just creating kthreadd before kernel_init as the following,
it works for me?


diff --git a/init/main.c b/init/main.c
index b34fd8e..ae86699 100644
--- a/init/main.c
+++ b/init/main.c
@@ -452,10 +452,10 @@ static noinline void __init_refok rest_init(void)
 	int pid;
 
 	rcu_scheduler_starting();
-	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
-	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
+	numa_default_policy();
 	unlock_kernel();
 
 	/*
