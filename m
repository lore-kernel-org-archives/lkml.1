Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZCOOkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZCOOkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 10:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZCOOkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 10:40:08 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:39303 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZCOOkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 10:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=EMCvfOe2wPHUMEZKAqn06LJeRtGY1hcnMtxwtAX5R0PWYD7TYDVc1pQ7wnN1ZizAaq
         cjD8XSspdJk9ORO3cwvPjYxZTXq5eUpDILwAsPvO+6FHTBys2UrN1FY80U4xjQiE6vOa
         NYl+YsyXodB/qHcAvUunp6SNblLH4QMMV6K9g=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Signal delivery order
Date: Sun, 15 Mar 2009 15:40:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200903141750.37238.mega@retes.hu> <20090315094400.GA455@redhat.com>
In-Reply-To: <20090315094400.GA455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903151540.00542.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> On 03/14, Gábor Melis wrote:
> > The test program triggers sigsegvs from a thread and tests whether
> > the the sigsegv handler is invoked when the sigusr1 handler is
> > already running.
>
> No, this is not what happens with this test case. SIGSEGV can't be
> generated when we run SIGUSR1 handler.
>
> 	void sigsegv_handler(int signal, siginfo_t *info, void *context)
> 	{
> 	     /* The test signal is blocked only in test_handler. */
>
> The comment is not right. We can't be here (in SIGSEGV handler) if
> we are in test_handler.
> 	     if (is_signal_blocked(test_signal)) {
> 		 _exit(27);
> 	     }
>
> If test_signal (SIGUSR1) is blocked, this means it is already
> delivered, and the handler will be invoked when we return from
> sigsegv_handler(), please see below.

SIGUSR1 is delivered, its sigmask is added to the current mask but the 
handler is not yet invoked and in this instant synchronous sigsegv is 
delivered, its handler invoked?

> > A normal kill does
> > not seem to do this.
>
> Yes. Because the task deques the private signals first (sent by
> tkill, or generate by kernel when the test case does "*page_address =
> 1"), then it dequeues the shared signals (sent by kill).
>
> But please note that it is still possible to hit is_signal_blocked()
> even with test_with_kill(), but the probability is very low.
>
> > I would expect that no asynchronously generated signal (and here I
> > include those sent by pthread_kill()) can overtake a sigsegv even
> > if its signum is lower.
>
> Signum doesn't matter. Any unblocked signal can preempt the task,
> whether it runs inside a signal handler or not. This is correct, you
> can use sigaction->sa_mask to specify which signals which should be
> blocked during execution of the signal handler.
>
> OK, let's do a simple test:
>
> 	int is_blocked(int sig)
> 	{
> 		sigset_t set;
> 		sigprocmask(SIG_BLOCK, NULL, &set);
> 		return sigismember(&set, sig);
> 	}
>
> 	void sig_1(int sig)
> 	{
> 		printf("%d %d\n", sig, is_blocked(2));
> 	}
>
> 	void sig_2(int sig)
> 	{
> 		printf("%d %d\n", sig, is_blocked(1));
> 	}
>
> 	int main(void)
> 	{
> 		sigset_t set;
>
> 		signal(1, sig_1);
> 		signal(2, sig_2);
>
> 		sigemptyset(&set);
> 		sigaddset(&set, 1);
> 		sigaddset(&set, 2);
> 		sigprocmask(SIG_BLOCK, &set, NULL);
>
> 		kill(getpid(), 1);
> 		kill(getpid(), 2);
>
> 		sigprocmask(SIG_UNBLOCK, &set, NULL);
>
> 		return 0;
> 	}
>
> output is:
>
> 	2 1
> 	1 0
>
> When sigprocmask(SIG_UNBLOCK) returns, both signals are delivered.
> The kernel deques 1 first, then 2. This means that the handler for
> "2" will be called first.

My mental model that matches what I quickly glean from the sources (from 
kernel/signal.c, arch/x86/kernel/signal_32.c) goes like this:

- signal 1 and signal 2 are generated and made pending
- they are unblocked by sigprocmask
- signal 1 is delivered: signals in its mask (only itself here) are 
blocked its handler is invoked
- barely into sig_1 (the printf didn't get a chance to run), signal 2 is 
delivered its sigmask is added to current one that already includes 
signal 1, sig_2 is invoked
- sig_2 prints "2 1" and returns
- sig_1 reaches the printf printing "1 0"
hes this model.

I can't find how 'handler for "2" will be called first'. Furthermore, if 
it's indeed sig_2 that's invoked first then sig_1's sigmask is added to 
the current mask upon dequeueing???

> But if you change kill(getpid(), 2) to tkill(getpid(), 2)) then the
> output should be:
>
> 	1 1
> 	2 0

Right.

> So, what happens with test_with_pthread_kill() is: the sub-thread
> likely deques both signals, SIGSEGV=11 and SIGUSR1=10 and starts
> the handler for SIGSEGV.
>
> With test_with_kill(), the child dequeues both signals too, but
> runs the handler for SIGUSR1 first, because it was send by kill(),
> not tkill().
>
> If you modify your test-case so that test_signal == SIGIO, then
> I bet test_with_pthread_kill() won't hit is_signal_blocked() too.
> Or you can modify test_with_kill() to use tkill(), in that case
> you should see the same behaviour as with test_with_pthread_kill().
>
> Please don't hesitate to ask more questions.

Thank you,
Gabor

> Oleg.
