Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXK0DDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXK0DDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXK0DDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:03:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbXK0DDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:03:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [PATCH 1/3] signal(i386): alternative signal stack
	wraparound occurs
In-Reply-To: Ingo Molnar's message of  Tuesday, 27 November 2007 00:02:42 +0100 <20071126230242.GA9623@elte.hu>
References: <20071126143317.dd884128.akpm@linux-foundation.org>
	<20071126230242.GA9623@elte.hu>
X-Shopping-List: (1) Didactic outrageous watch expectorants
   (2) Odious miscreant salmon
   (3) Vibrant bogs
   (4) Graphic battalions
   (5) Epileptic intrusion adhesives
Message-Id: <20071127030222.ACD7326F8C5@magilla.localdomain>
Date: Mon, 26 Nov 2007 19:02:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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


Thanks,
Roland

---

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d58d455..0000000 100644  
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -295,6 +295,13 @@ get_sigframe(struct k_sigaction *ka, str
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
