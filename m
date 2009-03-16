Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbZCPVRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbZCPVRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762413AbZCPVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:17:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35812 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457AbZCPVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:17:24 -0400
Date: Mon, 16 Mar 2009 22:13:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Signal delivery order
Message-ID: <20090316211316.GA6270@redhat.com>
References: <200903141750.37238.mega@retes.hu> <200903152306.53031.mega@retes.hu> <20090316002833.GA17615@redhat.com> <200903160934.03700.mega@retes.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903160934.03700.mega@retes.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Gábor Melis wrote:
>
> In a nutshell, the context argument is wrong.

I strongly disagree. This all is correct and works as expected.
Yes, it doesn't match your expectations/needs, but this doesn't
mean it is wrong.

> On Lunes 16 Marzo 2009, Oleg Nesterov wrote:
> > On 03/15, Gábor Melis wrote:
> >
> > > The revised signal-delivery-order.c (also attached) outputs:
> > >
> > > test_handler=8048727
> > > sigsegv_handler=804872c
> > > eip: 8048727
> > > esp: b7d94cb8
> > >
> > > which shows that sigsegv_handler also has incorrect eip in the
> > > context.
> >
> > Why do you think it is not correct?
> >
> > I didn't try your test-case, but I can't see where "esp: b7d94cb8"
> > comes from. But "eip: 8048727" looks exactly right, this is the
> > address of test_handler.
>
> Sorry, I removed the printing of esp from the code as it was not
> relevant to my point but pasted the output of a previous run.
>
> Anyway, I think eip is incorrect in sigsegv because it's not pointing to
> the instruction that caused the sigsegv. In general the ucontext is
> wrong, because it's as if sigsegv_handler were invoked within
> test_handler.
>
> This is problematic if the sigsegv handler wants to do something with
> the context. The real life sigsegv handler that's been failing does
> this:
> - skip the offending instruction by incrementing eip

I don't know how to solve your problem cleanly. Please let me now
if you find the solution ;)

As a workaround, perhaps sigsegv_handler() can just return if
uc_mcontext->ip points to another signal handler (assuming that
the first instruction of the signal handler can't cause the fault).
In this case the task will repeat the faulting instruction, and
sigsegv_handler() will be called again.

Agreed, this is not nice and the task should track sigaction()
calls, or sigsegv_handler() can do sigaction(signr, NULL, &oldact)
in a loop to see which handler we have.


Can the kernel help?

Perhaps we can add si_ip to _sigfault, in this case we could just
check uc_mcontext->ip != info->si_ip and return. Or we can unwind
the stack and find the "correct" rt_sigframe which matches the
page fault.

Or, we can change force_sig_info_fault() to block all signals
except si_signo and use set_restore_sigmask() logic. This means
no other signal can be dequeued until sigsegv_handler() returns.

I dunno. I am not sure your problem is common enough to do these
changes, but I can't judge.

Oleg.

