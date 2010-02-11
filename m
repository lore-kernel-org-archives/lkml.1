Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0BKM47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:56:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab0BKM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:56:57 -0500
Date: Thu, 11 Feb 2010 13:56:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100211125607.GA5086@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com> <20100208143231.6d804590.akpm@linux-foundation.org> <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com> <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Salman Qazi wrote:
>
> I have
> made a simpler version of tavis's test case:

Thanks, now I see what you mean.

But this all is correct, you can't expect PTRACE_SYSCALL can succeed
is the tracee is running, it must be stopped or traced.

The tracee is running because it was TASK_STOPPED and antagonist()
sends SIGCONT.

The tracee was TASK_STOPPED because the tracer passes sig = SIGSTOP
via ptrace(PTRACE_SYSCALL, WSTOPSIG(status).

Where do you see the bug?

OK, let me simplify the test-case even more:

	int main(void)
	{
		int stat, ret;
		int pid = fork();

		if (!pid) {
			ptrace(PTRACE_TRACEME, 0, NULL, NULL);
			for (;;)
				;
		}

		sleep(1);	// wait for PTRACE_TRACEME
		kill(pid, SIGSTOP);

		// the child reports SIGSTOP, it is TASK_TRACED
		assert(pid == wait(&stat) && WIFSTOPPED(stat));

		// the tracee should stop, we pass sig = SIGSTOP
		assert(ptrace(PTRACE_SYSCALL, pid, 0, WSTOPSIG(stat)) == 0);

		// the child reports the group stop, it is TASK_STOPPED
		assert(pid == wait(&stat) && WIFSTOPPED(stat));

		// the tracee is STOPPED as requested, not TRACED,
		// SIGCONT wakes it up
		kill(pid, SIGCONT);

		// now the tracee is _running_, and PTRACE_SYSCALL must fail
		ret = ptrace(PTRACE_SYSCALL, pid, 0, WSTOPSIG(stat));
		printf("should fail: ret=%d %m\n", ret);

		return 0;
	}

PTRACE_SYSCALL fails, and this is absolutely correct.

Now, let's look at your test-case

> int main(int argc, char **argv)
> {
>         int status;
>         assert((child_pid = do_fork(child)) > 0);
>         assert((ant_pid = do_fork(antagonist)) > 0);
>         waitpid(child_pid, &status, 0);
>         ptrace(PTRACE_SYSCALL, child_pid, NULL, NULL);
>         while(1) {
>                 if (waitpid(child_pid, &status, 0) <= 0) {
>                         printf("Errno %d\n", errno);
>                         exit(EXIT_FAILURE);
>                 }
>                 if (WIFSTOPPED(status)) {

WSTOPSIG() should be either SIGCONT or SIGSTOP

>                         printf("stopped: %d\n", WSTOPSIG(status));
>
>                         /* This should work, but sometimes it doesn't */
>                         if (ptrace(PTRACE_SYSCALL, child_pid,
>                                                 NULL, WSTOPSIG(status)) < 0) {

This should not work if the tracee reported the group stop (not the
fact it dequeued SIGSTOP) and antagonist() sends SIGCONT in between.

>                                 /* Oddly it works the second time! */
>                                 assert (ptrace(PTRACE_SYSCALL,
>                                         child_pid, NULL, WSTOPSIG(status)) < 0);

Of couse, it _can_ work the second time, antagonist() sends a signal
(SIGCONT or SIGSTOP), the tracee dequeues the signal, and stops to
report this signal.

See?

Oleg.

