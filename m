Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXK2PHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXK2PHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXK2PHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:07:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35485 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbXK2PHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:07:04 -0500
Date: Tue, 27 Nov 2007 14:57:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
Message-ID: <20071127145741.290af6ed@laptopd505.fenrus.org>
In-Reply-To: <20071127030222.ACD7326F8C5@magilla.localdomain>
References: <20071126143317.dd884128.akpm@linux-foundation.org>
	<20071126230242.GA9623@elte.hu>
	<20071127030222.ACD7326F8C5@magilla.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 19:02:22 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> cf http://lkml.org/lkml/2007/10/3/41
> 
> To summarize: on Linux, SA_ONSTACK decides whether you are already on
> the signal stack based on the value of the SP at the time of a
> signal.  If you are not already inside the range, you are not "on the
> signal stack" and so the new signal handler frame starts over at the
> base of the signal stack.
> 
> sigaltstack (and sigstack before it) was invented in BSD.  There, the
> SA_ONSTACK behavior has always been different.  It uses a kernel state
> flag to decide, rather than the SP value.  When you first take an
> SA_ONSTACK signal and switch to the alternate signal stack, it sets
> the SS_ONSTACK flag in the thread's sigaltstack state in the kernel.
> Thereafter you are "on the signal stack" and don't switch SP before
> pushing a handler frame no matter what the SP value is.  Only when you
> sigreturn from the original handler context do you clear the
> SS_ONSTACK flag so that a new handler frame will start over at the
> base of the alternate signal stack.
> 
> The undesireable effect of the Linux behavior is that an overflow of
> the alternate signal stack can not only go undetected, but lead to a
> ring buffer effect of clobbering the original handler frame at the
> base of the signal stack for each successive signal that comes just
> after the overflow.  This is what Shi Weihua's test case
> demonstrates.  Normally this does not come up because of the signal
> mask, but the test case uses SA_NODEFER for its SIGSEGV handler.
> 
> The other subtle part of the existing Linux semantics is that a simple
> longjmp out of a signal handler serves to take you off the signal
> stack in a safe and reliable fashion without having used sigreturn
> (nor having just returned from the handler normally, which means the
> same).  After the longjmp (or even informal stack switching not via
> any proper libc or kernel interface), the alternate signal stack
> stands ready to be used again.
> 
> A paranoid program would allocate a PROT_NONE red zone around its
> alternate signal stack.  Then a small overflow would trigger a
> SIGSEGV in handler setup, and be fatal (core dump) whether or not
> SIGSEGV is blocked.  As with thread stack red zones, that cannot
> catch all overflows (or underflows).  e.g., a local array as large as
> page size allocated in a function called from a handler, but not
> actually touched before more calls push more stack, could cause an
> overflow that silently pushes into some unrelated allocated pages.
> 
> The BSD behavior does not do anything in particular about overflow.
> But it does at least avoid the wraparound or "ring buffer effect", so
> you'll just get a straightforward all-out overflow down your address
> space past the low end of the alternate signal stack.  I don't know
> what the BSD behavior is for longjmp out of an SA_ONSTACK handler.
> 
> The POSIX wording relating to sigaltstack is pretty minimal.  I don't
> think it speaks to this issue one way or another.  (The program that
> overflows its stack is clearly in undefined behavior territory of one
> sort or another anyhow.)
> 
> Given the longjmp issue and the potential for highly subtle
> complications in existing programs relying on this in arcane ways
> deep in their code, I am very dubious about changing the behavior to
> the BSD style persistent flag.  I think Shi Weihua's patches have a
> similar effect by tracking the SP used in the last handler setup.
> 
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
> 


we probably should also make sure userspace has at least a little bit
of stack space for itself, say 2Kb or 4Kb, not just "the kernel puts
you right at the edge"....

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
