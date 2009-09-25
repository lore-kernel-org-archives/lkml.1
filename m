Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZIYCxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZIYCxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZIYCxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:53:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZIYCxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:53:16 -0400
Date: Fri, 25 Sep 2009 04:48:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Heffner <mikeh@fesnel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>
Subject: Re: HR timers prevent an itimer from generating EINTR?
Message-ID: <20090925024848.GA20855@redhat.com>
References: <4AA1860B.4030409@fesnel.com> <20090924160946.f54aa215.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924160946.f54aa215.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Andrew Morton wrote:
>
> (cc's added)

add Roland.

> (it's a regression)

Not sure...

> On Fri, 04 Sep 2009 17:26:35 -0400
> Mike Heffner <mikeh@fesnel.com> wrote:
>
> > Summary:
> >
> > Mixing HR timers with itimers occasionally hides an EINTR from a
> > blocking syscall.
> >
> >
> > Description:
> >
> > In my test program I have a High Resolution timer firing every one
> > second (with SA_RESTART) and I set an itimer (without SA_RESTART) to
> > fire after three seconds. I then execute a blocking system call (flock
> > in this case) and expect the three second itimer to interrupt the system
> > call with EINTR. However, I frequently notice that the itimer will fire
> > but it will not interrupt the blocking system call. There appears to be
> > a race between the HR timer firing and the itimer firing. If I offset
> > the HR timer frequency by a half second, the itimer always interrupts
> > the system call.
> >
> > Kernel version:
> >
> > These kernels both demonstrate the condition:
> >
> > 2.6.29.6-217.2.16.fc11.x86_64
> > 	and
> > 2.6.30.5-43.fc11.x86_64
> >
> >
> > I do not see this condition on:
> >
> > 2.6.18-53.el5

This is strange.

> > The following program illustrates this condition:
> >
> > http://github.com/mheffner/scripts/commits/master/hrtimer_vs_itimer.c

I didn't try this test-case, but afaics everything is clear, please
see below.

> > Is this behavior expected?

I don't know ;)

Well, I'd say this is expected. I mean, I am not surprized. But I can't
"prove" this is correct.

OK, I wrote the simple test-case to simplify the explanation. The child
instals the same handler for SIGHUP < SIGINT < SIGQUIT, but SIGINT doesn't
use SA_RESTART.

The test-case:

	static void sigh(int sig)
	{
		printf("SIG: %d\n", sig);
	}

	int main(void)
	{
		int pid;

		if (!(pid = fork())) {
			struct sigaction sa = { .sa_handler = sigh };

			sa.sa_flags = SA_RESTART;
			assert(0 == sigaction(SIGHUP, &sa, NULL));

			sa.sa_flags = 0;
			assert(0 == sigaction(SIGINT, &sa, NULL));

			sa.sa_flags = SA_RESTART;
			assert(0 == sigaction(SIGQUIT, &sa, NULL));

			printf("block...\n");
			getchar();		// any restartable syscall
			printf("exit\n");

			return 0;
		}

		sleep(1);
		printf("it shouldn't exit\n");
		kill(pid, SIGHUP); kill(pid, SIGINT);

		sleep(1);
		printf("now it should exit!\n");
		kill(pid, SIGINT); kill(pid, SIGQUIT);

		wait(NULL);

		return 0;
	}

The output:

	block...
	it shouldn't exit
	SIG: 2
	SIG: 1
	now it should exit!
	SIG: 3
	SIG: 2
	exit

So. The child sleeps in getchar().

The parent sends SIGHUP + SIGINT. The child recievese both signals and
restarts the syscall, despite the fact the hanlder for SIGINT has not
SA_RESTART flag.

What happens is:

	syscall returns -ERESTARTSYS

	SIGHUP < SIGINT, the child dequeues SIGHUP first.

	handle_signal() notices -ERESTARTSYS and does:
			
		regs->ax = regs->orig_ax;
		regs->ip -= 2;

Before the child returns to user-mode, it will also dequeue SIGINT, but
this does not matter. regs->ax was changed, the next signal can't see
the soon-to-be-restarted syscall returned ERESTARTSYS.

When we send SIGINT + SIGHUP, SIGINT wins. It changes ->ax too, but
doesn't change ->ip - the child returns from syscall.

Again, this test-case relies on SIGHUP < SIGINT < SIGQUIT, but this is
not necessary. The thing is, if we dequeue the !SA_RESTART signal after
SA_RESTART signal - syscall will be restarted.



And this does not look like a bug to me. Because we can pretend that
SIGINT was sent _after_ the task has actually returned to user-mode
and before it restarts this syscall. In this case SIGINT can not
cancel the syscall which was not called yet.

IOW, we have SIG_1 and SIG_2. SIG_1 has SA_RESTART, SIG_2 not. The
task sleeps in syscall(). Then,

	the task recieves SIG_1

	syscall() returns -ERESTARTSYS

	the tasks returns to user mode to restart syscall()

	the task recieves SIG_2, handles the new signal

	syscall() restarted

We can change this test-case so that SIGHUP will block all signals,
but this will only change the order of printf's from the handler.


If we want to change the current behaviour, we need the nontrivial
changes.

Oleg.

