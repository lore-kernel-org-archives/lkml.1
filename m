Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXK0KvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXK0KvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXK0KvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:51:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbXK0KvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:51:01 -0500
Date: Tue, 27 Nov 2007 11:50:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [PATCH 1/3] signal(i386): alternative signal stack
	wraparound occurs
Message-ID: <20071127105045.GG6286@elte.hu>
References: <20071126143317.dd884128.akpm@linux-foundation.org> <20071126230242.GA9623@elte.hu> <20071127030222.ACD7326F8C5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127030222.ACD7326F8C5@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

[...]
> I think it would be sensible for the signal handler setup code to 
> detect when it would itself be causing a stack overflow.  Maybe 
> something like the following patch (untested).  This issue exists in 
> the same way on all machines, so ideally they would all do a similar 
> check.
> 
> When it's the handler function itself or its callees that cause the 
> overflow, rather than the signal handler frame setup alone crossing 
> the boundary, this still won't help.  But I don't see any way to 
> distinguish that from the valid longjmp case.

thanks Roland for the detailed analysis. I've queued up the patch below 
in the x86 tree. I suspect we can wait with this for v2.6.25, due to 
this being long-standing behavior of Linux? Thus we could observe the 
effects of this patch for a longer time.

I'm wondering how widespread sigaltstack use is in general. Googling 
around gives:

  http://google.com/codesearch?q=sigaltstack

~400 matches. A more common signal API in comparison:

  http://google.com/codesearch?q=sigaction

gives ~139,000 matches. So i guess the right approach would be to also 
extend LTP's sigaltstack tests to cover whatever new desired behavior - 
so that we at least have a minimal chance of catching obvious breakages 
here.

	Ingo

--------------->
Subject: x86: protect against sigaltstack wraparound
From: Roland McGrath <roland@redhat.com>

cf http://lkml.org/lkml/2007/10/3/41

To summarize: on Linux, SA_ONSTACK decides whether you are already on the
signal stack based on the value of the SP at the time of a signal.  If
you are not already inside the range, you are not "on the signal stack"
and so the new signal handler frame starts over at the base of the signal
stack.

sigaltstack (and sigstack before it) was invented in BSD.  There, the
SA_ONSTACK behavior has always been different.  It uses a kernel state
flag to decide, rather than the SP value.  When you first take an
SA_ONSTACK signal and switch to the alternate signal stack, it sets the
SS_ONSTACK flag in the thread's sigaltstack state in the kernel.
Thereafter you are "on the signal stack" and don't switch SP before
pushing a handler frame no matter what the SP value is.  Only when you
sigreturn from the original handler context do you clear the SS_ONSTACK
flag so that a new handler frame will start over at the base of the
alternate signal stack.

The undesireable effect of the Linux behavior is that an overflow of the
alternate signal stack can not only go undetected, but lead to a ring
buffer effect of clobbering the original handler frame at the base of the
signal stack for each successive signal that comes just after the
overflow.  This is what Shi Weihua's test case demonstrates.  Normally
this does not come up because of the signal mask, but the test case uses
SA_NODEFER for its SIGSEGV handler.

The other subtle part of the existing Linux semantics is that a simple
longjmp out of a signal handler serves to take you off the signal stack
in a safe and reliable fashion without having used sigreturn (nor having
just returned from the handler normally, which means the same).  After
the longjmp (or even informal stack switching not via any proper libc or
kernel interface), the alternate signal stack stands ready to be used
again.

A paranoid program would allocate a PROT_NONE red zone around its
alternate signal stack.  Then a small overflow would trigger a SIGSEGV in
handler setup, and be fatal (core dump) whether or not SIGSEGV is
blocked.  As with thread stack red zones, that cannot catch all overflows
(or underflows).  e.g., a local array as large as page size allocated in
a function called from a handler, but not actually touched before more
calls push more stack, could cause an overflow that silently pushes into
some unrelated allocated pages.

The BSD behavior does not do anything in particular about overflow.  But
it does at least avoid the wraparound or "ring buffer effect", so you'll
just get a straightforward all-out overflow down your address space past
the low end of the alternate signal stack.  I don't know what the BSD
behavior is for longjmp out of an SA_ONSTACK handler.

The POSIX wording relating to sigaltstack is pretty minimal.  I don't
think it speaks to this issue one way or another.  (The program that
overflows its stack is clearly in undefined behavior territory of one
sort or another anyhow.)

Given the longjmp issue and the potential for highly subtle complications
in existing programs relying on this in arcane ways deep in their code, I
am very dubious about changing the behavior to the BSD style persistent
flag.  I think Shi Weihua's patches have a similar effect by tracking the
SP used in the last handler setup.

I think it would be sensible for the signal handler setup code to detect
when it would itself be causing a stack overflow.  Maybe something like
the following patch (untested).  This issue exists in the same way on all
machines, so ideally they would all do a similar check.

When it's the handler function itself or its callees that cause the
overflow, rather than the signal handler frame setup alone crossing the
boundary, this still won't help.  But I don't see any way to distinguish
that from the valid longjmp case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/signal_32.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-x86.q/arch/x86/kernel/signal_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/signal_32.c
+++ linux-x86.q/arch/x86/kernel/signal_32.c
@@ -296,6 +296,13 @@ get_sigframe(struct k_sigaction *ka, str
 	/* Default to using normal stack */
 	esp = regs->esp;
 
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (on_sig_stack(esp) && !likely(on_sig_stack(esp - frame_size)))
+		return (void __user *) -1L;
+
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
 		if (sas_ss_flags(esp) == 0)
