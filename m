Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZCOJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZCOJs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZCOJsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:48:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40692 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZCOJsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:48:19 -0400
Date: Sun, 15 Mar 2009 10:44:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Signal delivery order
Message-ID: <20090315094400.GA455@redhat.com>
References: <200903141750.37238.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903141750.37238.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Gábor Melis wrote:
>
> The test program triggers sigsegvs from a thread and tests whether the
> the sigsegv handler is invoked when the sigusr1 handler is already
> running.

No, this is not what happens with this test case. SIGSEGV can't be
generated when we run SIGUSR1 handler.

	void sigsegv_handler(int signal, siginfo_t *info, void *context)
	{
	     /* The test signal is blocked only in test_handler. */

The comment is not right. We can't be here (in SIGSEGV handler) if
we are in test_handler.

	     if (is_signal_blocked(test_signal)) {
		 _exit(27);
	     }

If test_signal (SIGUSR1) is blocked, this means it is already delivered,
and the handler will be invoked when we return from sigsegv_handler(),
please see below.

> A normal kill does
> not seem to do this.

Yes. Because the task deques the private signals first (sent by tkill,
or generate by kernel when the test case does "*page_address = 1"),
then it dequeues the shared signals (sent by kill).

But please note that it is still possible to hit is_signal_blocked()
even with test_with_kill(), but the probability is very low.

> I would expect that no asynchronously generated signal (and here I
> include those sent by pthread_kill()) can overtake a sigsegv even if
> its signum is lower.

Signum doesn't matter. Any unblocked signal can preempt the task, whether
it runs inside a signal handler or not. This is correct, you can use
sigaction->sa_mask to specify which signals which should be blocked during
execution of the signal handler.

OK, let's do a simple test:

	int is_blocked(int sig)
	{
		sigset_t set;
		sigprocmask(SIG_BLOCK, NULL, &set);
		return sigismember(&set, sig);
	}

	void sig_1(int sig)
	{
		printf("%d %d\n", sig, is_blocked(2));
	}

	void sig_2(int sig)
	{
		printf("%d %d\n", sig, is_blocked(1));
	}

	int main(void)
	{
		sigset_t set;

		signal(1, sig_1);
		signal(2, sig_2);

		sigemptyset(&set);
		sigaddset(&set, 1);
		sigaddset(&set, 2);
		sigprocmask(SIG_BLOCK, &set, NULL);

		kill(getpid(), 1);
		kill(getpid(), 2);

		sigprocmask(SIG_UNBLOCK, &set, NULL);

		return 0;
	}

output is:

	2 1
	1 0

When sigprocmask(SIG_UNBLOCK) returns, both signals are delivered.
The kernel deques 1 first, then 2. This means that the handler for
"2" will be called first.

But if you change kill(getpid(), 2) to tkill(getpid(), 2)) then the
output should be:

	1 1
	2 0

So, what happens with test_with_pthread_kill() is: the sub-thread
likely deques both signals, SIGSEGV=11 and SIGUSR1=10 and starts
the handler for SIGSEGV.

With test_with_kill(), the child dequeues both signals too, but
runs the handler for SIGUSR1 first, because it was send by kill(),
not tkill().

If you modify your test-case so that test_signal == SIGIO, then
I bet test_with_pthread_kill() won't hit is_signal_blocked() too.
Or you can modify test_with_kill() to use tkill(), in that case
you should see the same behaviour as with test_with_pthread_kill().

Please don't hesitate to ask more questions.

Oleg.

